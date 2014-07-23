Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaGWHnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:43:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25698 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932293AbaGWHnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:43:01 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671774"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 6/6] kvm, mem-hotplug: Reload L1's apic access page if it is migrated when L2 is running.
Date: Wed, 23 Jul 2014 15:42:10 -0400
Message-ID: <1406144530-23002-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only handle "L1 and L2 vm share one apic access page" situation.

When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
nothing.

When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  3 +++
 4 files changed, 47 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ce6bfd..613ee7f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -738,6 +738,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
 	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
+	void (*set_nested_apic_page_migrated)(struct kvm_vcpu *vcpu, bool set);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index dc76f29..87273ef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3617,6 +3617,11 @@ static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
 	return;
 }
 
+static void svm_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
+{
+	return;
+}
+
 static int svm_vm_has_apicv(struct kvm *kvm)
 {
 	return 0;
@@ -4371,6 +4376,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
 	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
+	.set_nested_apic_page_migrated = svm_set_nested_apic_page_migrated,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c123c1d..9231afe 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -379,6 +379,16 @@ struct nested_vmx {
 	 * we must keep them pinned while L2 runs.
 	 */
 	struct page *apic_access_page;
+	/*
+	 * L1's apic access page can be migrated. When L1 and L2 are sharing
+	 * the apic access page, after the page is migrated when L2 is running,
+	 * we have to reload it to L1 vmcs before we enter L1.
+	 *
+	 * When the shared apic access page is migrated in L1 mode, we don't
+	 * need to do anything else because we reload apic access page each
+	 * time when entering L2 in prepare_vmcs02().
+	 */
+	bool apic_access_page_migrated;
 	u64 msr_ia32_feature_control;
 
 	struct hrtimer preemption_timer;
@@ -7077,6 +7087,12 @@ static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
 	vmcs_write64(APIC_ACCESS_ADDR, hpa);
 }
 
+static void vmx_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	vmx->nested.apic_access_page_migrated = set;
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8727,6 +8743,26 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	/*
+	 * When shared (L1 & L2) apic access page is migrated during L2 is
+	 * running, mmu_notifier will force to reload the page's hpa for L2
+	 * vmcs. Need to reload it for L1 before entering L1.
+	 */
+	if (vmx->nested.apic_access_page_migrated) {
+		/*
+		 * Do not call kvm_reload_apic_access_page() because we are now
+		 * in L2. We should not call make_all_cpus_request() to exit to
+		 * L0, otherwise we will reload for L2 vmcs again.
+		 */
+		int i;
+
+		for (i = 0; i < atomic_read(&vcpu->kvm->online_vcpus); i++)
+			kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD,
+					 vcpu->kvm->vcpus[i]);
+
+		vmx->nested.apic_access_page_migrated = false;
+	}
+
+	/*
 	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
 	 * finished a VMLAUNCH or VMRESUME instruction, so we need to set the
 	 * success or failure flag accordingly.
@@ -8847,6 +8883,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.set_nested_apic_page_migrated = vmx_set_nested_apic_page_migrated,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7541a66..0c11e12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5940,6 +5940,9 @@ static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
 				page_to_phys(vcpu->kvm->arch.apic_access_page));
+
+	if (is_guest_mode(vcpu))
+		kvm_x86_ops->set_nested_apic_page_migrated(vcpu, true);
 }
 
 /*
-- 
1.8.3.1

