Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaGBJAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:00:06 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48510 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752916AbaGBJAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:00:00 -0400
X-IronPort-AV: E=Sophos;i="5.00,818,1396972800"; 
   d="scan'208";a="32730472"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it is migrated.
Date: Wed, 2 Jul 2014 17:00:37 +0800
Message-ID: <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic access page is pinned in memory, and as a result it cannot be
migrated/hot-removed.

Actually it doesn't need to be pinned in memory.

This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT. This requet
will be made when kvm_mmu_notifier_invalidate_page() is called when the page
is unmapped from the qemu user space to reset APIC_ACCESS_ADDR pointer in
each online vcpu to 0. And will also be made when ept violation happens to
reset APIC_ACCESS_ADDR to the new page phys_addr (host phys_addr).
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.c              | 15 +++++++++++++++
 arch/x86/kvm/vmx.c              |  9 ++++++++-
 arch/x86/kvm/x86.c              | 20 ++++++++++++++++++++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             | 15 +++++++++++++++
 6 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8771c0f..f104b87 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -575,6 +575,7 @@ struct kvm_arch {
 
 	unsigned int tss_addr;
 	struct page *apic_access_page;
+	bool apic_access_page_migrated;
 
 	gpa_t wall_clock;
 
@@ -739,6 +740,7 @@ struct kvm_x86_ops {
 	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
+	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c0d72f6..a655444 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3436,6 +3436,21 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		kvm_make_request(KVM_REQ_MIGRATE_EPT, vcpu);
 	}
 
+	if (gpa == VMX_APIC_ACCESS_PAGE_ADDR &&
+	    vcpu->kvm->arch.apic_access_page_migrated) {
+		int i;
+
+		vcpu->kvm->arch.apic_access_page_migrated = false;
+
+		/*
+		 * We need update APIC_ACCESS_ADDR pointer in each VMCS of
+		 * all the online vcpus.
+		 */
+		for (i = 0; i < atomic_read(&vcpu->kvm->online_vcpus); i++)
+			kvm_make_request(KVM_REQ_MIGRATE_APIC,
+					 vcpu->kvm->vcpus[i]);
+	}
+
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c336cb3..abc152f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3988,7 +3988,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
@@ -7075,6 +7075,12 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
 	vmx_set_msr_bitmap(vcpu);
 }
 
+static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
+{
+	if (vm_need_virtualize_apic_accesses(kvm))
+		vmcs_write64(APIC_ACCESS_ADDR, hpa);
+}
+
 static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
 {
 	u16 status;
@@ -8846,6 +8852,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
 	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.vm_has_apicv = vmx_vm_has_apicv,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a26524f..14e7174 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5943,6 +5943,24 @@ static void vcpu_migrated_page_update_ept(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vcpu_migrated_page_update_apic(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (kvm->arch.apic_access_page_migrated) {
+		if (kvm->arch.apic_access_page)
+			kvm->arch.apic_access_page = pfn_to_page(0);
+		kvm_x86_ops->set_apic_access_page_addr(kvm, 0x0ull);
+	} else {
+		struct page *page;
+		page = gfn_to_page_no_pin(kvm,
+				VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
+		kvm->arch.apic_access_page = page;
+		kvm_x86_ops->set_apic_access_page_addr(kvm,
+						       page_to_phys(page));
+	}
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -6005,6 +6023,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			vcpu_scan_ioapic(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_EPT, vcpu))
 			vcpu_migrated_page_update_ept(vcpu);
+		if (kvm_check_request(KVM_REQ_MIGRATE_APIC, vcpu))
+			vcpu_migrated_page_update_apic(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4b7e51a..e2ad65e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -137,6 +137,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_ENABLE_IBS        23
 #define KVM_REQ_DISABLE_IBS       24
 #define KVM_REQ_MIGRATE_EPT       25
+#define KVM_REQ_MIGRATE_APIC      26
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d271e89..f06438c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -54,6 +54,7 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
+#include <asm/vmx.h>
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
@@ -300,6 +301,20 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 		kvm_make_request(KVM_REQ_MIGRATE_EPT, kvm->vcpus[0]);
 	}
 
+	if (address ==
+	    gfn_to_hva(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT)) {
+		int i;
+
+		kvm->arch.apic_access_page_migrated = true;
+
+		/*
+		 * We need update APIC_ACCESS_ADDR pointer in each VMCS of
+		 * all the online vcpus.
+		 */
+		for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
+			kvm_make_request(KVM_REQ_MIGRATE_APIC, kvm->vcpus[i]);
+	}
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
-- 
1.8.3.1

