Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaGWHnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:43:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25698 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932272AbaGWHm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:58 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671769"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 5/6] kvm, mem-hotplug: Do not pin apic access page in memory.
Date: Wed, 23 Jul 2014 15:42:09 -0400
Message-ID: <1406144530-23002-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
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
 arch/x86/kvm/vmx.c              |  8 +++++++-
 arch/x86/kvm/x86.c              | 17 +++++++++++++++--
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 12 ++++++++++++
 6 files changed, 43 insertions(+), 3 deletions(-)

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
index 6ab4f87..c123c1d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3995,7 +3995,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
@@ -7072,6 +7072,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
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
@@ -8841,6 +8846,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffbe557..7541a66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5929,6 +5929,19 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * apic access page could be migrated. When the page is being migrated,
+	 * GUP will wait till the migrate entry is replaced with the new pte
+	 * entry pointing to the new page.
+	 */
+	vcpu->kvm->arch.apic_access_page = gfn_to_page_no_pin(vcpu->kvm,
+				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
+				page_to_phys(vcpu->kvm->arch.apic_access_page));
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -5989,6 +6002,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
+			vcpu_reload_apic_access_page(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -7175,8 +7190,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
-	if (kvm->arch.apic_access_page)
-		put_page(kvm->arch.apic_access_page);
 	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 }
 
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

