Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaIKFhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:37:03 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58644 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752288AbaIKFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:37:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35792877"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page on migration in vcpu_enter_guest().
Date: Thu, 11 Sep 2014 13:38:03 +0800
Message-ID: <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
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
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx.c              |  6 ++++++
 arch/x86/kvm/x86.c              | 15 +++++++++++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 12 ++++++++++++
 6 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35171c7..514183e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -739,6 +739,7 @@ struct kvm_x86_ops {
 	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1d941ad..f2eacc4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3619,6 +3619,11 @@ static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
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
@@ -4373,6 +4378,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
 	.vm_has_apicv = svm_vm_has_apicv,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 63c4c3e..da6d55d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7093,6 +7093,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
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
@@ -8910,6 +8915,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e05bd58..96f4188 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5989,6 +5989,19 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * apic access page could be migrated. When the page is being migrated,
+	 * GUP will wait till the migrate entry is replaced with the new pte
+	 * entry pointing to the new page.
+	 */
+	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
+				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
+				page_to_phys(vcpu->kvm->arch.apic_access_page));
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -6049,6 +6062,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
+			vcpu_reload_apic_access_page(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a4c33b3..8be076a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -136,6 +136,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
 #define KVM_REQ_ENABLE_IBS        23
 #define KVM_REQ_DISABLE_IBS       24
+#define KVM_REQ_APIC_PAGE_RELOAD  25
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
@@ -579,6 +580,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+void kvm_reload_apic_access_page(struct kvm *kvm);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33712fb..d8280de 100644
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

