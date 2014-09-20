Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaITKqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:46:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755312AbaITKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:46:28 -0400
X-IronPort-AV: E=Sophos;i="5.04,559,1406563200"; 
   d="scan'208";a="36212241"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v7 5/9] kvm, mem-hotplug: Reload L1's apic access page in vcpu_enter_guest().
Date: Sat, 20 Sep 2014 18:47:47 +0800
Message-ID: <1411210071-14727-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are handling "L1 and L2 share one apic access page" situation when migrating
apic access page. We should do some handling when migration happens in the
following situations:

   1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
      vmcs in the next L1->L2 entry.

   2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
      L0->L1 entry and L2's vmcs in the next L1->L2 entry.

   3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
      L0->L2 entry and L1's vmcs in the next L2->L1 exit.

This patch handles 1) and 2) by making a new vcpu request named KVM_REQ_APIC_PAGE_RELOAD
to reload apic access page in L0->L1 entry.

Since we don't handle L1 ans L2 have separate apic access pages situation,
when we update vmcs, we need to check if we are in L2 and if L2's secondary
exec virtualzed apic accesses is enabled.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              |  6 ++++++
 arch/x86/kvm/x86.c              | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h        |  1 +
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69fe032..56156eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -740,6 +740,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
 	bool (*has_secondary_apic_access)(struct kvm_vcpu *vcpu);
+	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9c8ae32..99378d7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3624,6 +3624,11 @@ static bool svm_has_secondary_apic_access(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
+{
+	return;
+}
+
 static int svm_vm_has_apicv(struct kvm *kvm)
 {
 	return 0;
@@ -4379,6 +4384,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
 	.has_secondary_apic_access = svm_has_secondary_apic_access,
+	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0b541d9..c8e90ec 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7098,6 +7098,11 @@ static bool vmx_has_secondary_apic_access(struct kvm_vcpu *vcpu)
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 }
 
+static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
+{
+	vmcs_write64(APIC_ACCESS_ADDR, hpa);
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8918,6 +8923,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
 	.has_secondary_apic_access = vmx_has_secondary_apic_access,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e05bd58..fc54fa6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5989,6 +5989,27 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Only APIC access page shared by L1 and L2 vm is handled. The APIC
+	 * access page prepared by L1 for L2's execution is still pinned in
+	 * memory, and it cannot be migrated.
+	 */
+	if (!is_guest_mode(vcpu) ||
+	    !kvm_x86_ops->has_secondary_apic_access(vcpu)) {
+		/*
+		 * APIC access page could be migrated. When the page is being
+		 * migrated, GUP will wait till the migrate entry is replaced
+		 * with the new pte entry pointing to the new page.
+		 */
+		vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
+				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+		kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
+				page_to_phys(vcpu->kvm->arch.apic_access_page));
+	}
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

