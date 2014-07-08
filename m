Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaGHNA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:00:58 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29969 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754254AbaGHNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:00:51 -0400
X-IronPort-AV: E=Sophos;i="5.00,856,1396972800"; 
   d="scan'208";a="32994968"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in memory.
Date: Tue, 8 Jul 2014 21:01:32 +0800
Message-ID: <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic access page is pinned in memory. As a result, it cannot be migrated/hot-removed.
Actually, it is not necessary to be pinned.

The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer. When
the page is migrated, kvm_mmu_notifier_invalidate_page() will invalidate the
corresponding ept entry. This patch introduces a new vcpu request named
KVM_REQ_APIC_PAGE_RELOAD, and makes this request to all the vcpus at this time,
and force all the vcpus exit guest, and re-enter guest till they updates the VMCS
APIC_ACCESS_ADDR pointer to the new apic access page address, and updates
kvm->arch.apic_access_page to the new page.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              | 11 +++++++++++
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              |  8 +++++++-
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 12 ++++++++++++
 7 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 62f973e..9ce6bfd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -737,6 +737,7 @@ struct kvm_x86_ops {
 	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..551693d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3427,6 +3427,17 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			 level, gfn, pfn, prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
+	/*
+	 * apic access page could be migrated. When the guest tries to access
+	 * the apic access page, ept violation will occur, and we can use GUP
+	 * to find the new page.
+	 *
+	 * GUP will wait till the migrate entry be replaced with the new page.
+	 */
+	if (gpa == APIC_DEFAULT_PHYS_BASE)
+		vcpu->kvm->arch.apic_access_page = gfn_to_page_no_pin(vcpu->kvm,
+					APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+
 	return r;
 
 out_unlock:
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 576b525..dc76f29 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3612,6 +3612,11 @@ static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	return;
 }
 
+static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
+{
+	return;
+}
+
 static int svm_vm_has_apicv(struct kvm *kvm)
 {
 	return 0;
@@ -4365,6 +4370,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5532ac8..f7c6313 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3992,7 +3992,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
@@ -7073,6 +7073,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	vmx_set_msr_bitmap(vcpu);
 }
 
+static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
+{
+	vmcs_write64(APIC_ACCESS_ADDR, hpa);
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8842,6 +8847,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffbe557..7080eda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5929,6 +5929,18 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When the page is being migrated, GUP will wait till the migrate
+	 * entry is replaced with the new pte entry pointing to the new page.
+	 */
+	struct page *page = gfn_to_page_no_pin(vcpu->kvm,
+					APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
+					       page_to_phys(page));
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -5989,6 +6001,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
+			vcpu_reload_apic_access_page(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7c58d9d..f49be86 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -136,6 +136,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
 #define KVM_REQ_ENABLE_IBS        23
 #define KVM_REQ_DISABLE_IBS       24
+#define KVM_REQ_APIC_PAGE_RELOAD  25
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
@@ -596,6 +597,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+void kvm_reload_apic_access_page(struct kvm *kvm);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6091849..965b702 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -210,6 +210,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+void kvm_reload_apic_access_page(struct kvm *kvm)
+{
+	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
+}
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
@@ -294,6 +299,13 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
 
+	/*
+	 * The physical address of apic access page is stroed in VMCS.
+	 * So need to update it when it becomes invalid.
+	 */
+	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
+		kvm_reload_apic_access_page(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
-- 
1.8.3.1

