Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaIXH6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:58:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7440 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752735AbaIXH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:58:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,587,1406563200"; 
   d="scan'208";a="36385397"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v8 4/8] kvm, mem-hotplug: Reload L1's apic access page in vcpu_enter_guest().
Date: Wed, 24 Sep 2014 15:57:54 +0800
Message-ID: <1411545478-9848-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wants to migrate apic access page pinned by guest (L1 and L2) to make memory
hotplug available.

There are two situations need to be handled for apic access page used by L2 vm:
1. L1 prepares a separate apic access page for L2.

   L2 pins a lot of pages in memory. Even if we can migrate apic access page,
   memory hotplug is not available when L2 is running. So do not handle this
   now. Migrate L1's apic access page only.

2. L1 and L2 share one apic access page.

   Since we will migrate L1's apic access page, we should do some handling when
   migration happens in the following situations:

   1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
      vmcs in the next L1->L2 entry.

   2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
      L0->L1 entry and L2's vmcs in the next L1->L2 entry.

   3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
      L0->L2 entry and L1's vmcs in the next L2->L1 exit.

This patch handles 1) and 2).

Since we don't handle L1 ans L2 have separate apic access pages situation,
when we update vmcs, we need to check if we are in L2 and if L1 prepares an
non-shared apic access page for L2. We do this in vmx_set_apic_access_page_addr()
when trying to set new apic access page's hpa like this:

       if (!is_guest_mode(vcpu) ||
           !(vmx->nested.current_vmcs12->secondary_vm_exec_control &
             SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx.c              | 39 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h        |  1 +
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35171c7..582cd0f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -739,6 +739,7 @@ struct kvm_x86_ops {
 	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 72a0470..1411bab 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3108,9 +3108,17 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_unrestricted_guest())
 		enable_unrestricted_guest = 0;
 
-	if (!cpu_has_vmx_flexpriority())
+	if (!cpu_has_vmx_flexpriority()) {
 		flexpriority_enabled = 0;
 
+		/*
+		 * set_apic_access_page_addr() is used to reload apic access
+		 * page in case it is migrated for memory hotplug reason. If
+		 * platform doesn't have this affinity, no need to handle it.
+		 */
+		kvm_x86_ops->set_apic_access_page_addr = NULL;
+	}
+
 	if (!cpu_has_vmx_tpr_shadow())
 		kvm_x86_ops->update_cr8_intercept = NULL;
 
@@ -7090,6 +7098,34 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	vmx_set_msr_bitmap(vcpu);
 }
 
+static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * This function is used to reload apic access page in case it is
+	 * migrated for memory hotplug reason. And only L1 and L2 share the
+	 * same apic access page situation is handled.
+	 *
+	 * 1) If vcpu is not in guest mode (in L1), reload the page for L1.
+	 *    And L2's page will be reloaded in the next L1->L2 entry by
+	 *    prepare_vmcs02().
+	 *
+	 * 2) If vcpu is in guest mode (in L2), but L1 didn't not prepare an
+	 *    apic access page for L2 (current_vmcs12->secondary_vm_exec_control
+	 *    does not have SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES bit set),
+	 *    reload the page for L2.
+	 *    And L1's page will be reloaded in the next L2->L1 exit.
+	 *
+	 * 3) Otherwise, do nothing. L2's specific apic access page is still
+	 *    pinned in memory, and not hotpluggable.
+	 */
+	if (!is_guest_mode(vcpu) ||
+	    !(vmx->nested.current_vmcs12->secondary_vm_exec_control &
+	      SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+		vmcs_write64(APIC_ACCESS_ADDR, hpa);
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8909,6 +8945,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e05bd58..1f0c99a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5989,6 +5989,27 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If platform doesn't have 2nd exec virtualize apic access affinity,
+	 * set_apic_access_page_addr() will be set to NULL in hardware_setup(),
+	 * and no need to reload apic access page here.
+	 */
+	if (!kvm_x86_ops->set_apic_access_page_addr)
+		return;
+
+	/*
+	 * APIC access page could be migrated. When the page is being
+	 * migrated, GUP will wait till the migrate entry is replaced
+	 * with the new pte entry pointing to the new page.
+	 */
+	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
+			APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	kvm_x86_ops->set_apic_access_page_addr(vcpu,
+			page_to_phys(vcpu->kvm->arch.apic_access_page));
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -6049,6 +6070,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
+			kvm_vcpu_reload_apic_access_page(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a4c33b3..c23236a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -136,6 +136,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
 #define KVM_REQ_ENABLE_IBS        23
 #define KVM_REQ_DISABLE_IBS       24
+#define KVM_REQ_APIC_PAGE_RELOAD  25
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
-- 
1.8.3.1

