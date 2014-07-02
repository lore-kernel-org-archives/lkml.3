Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaGBJAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:00:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28751 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbaGBI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:59:56 -0400
X-IronPort-AV: E=Sophos;i="5.00,818,1396972800"; 
   d="scan'208";a="32730467"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH 3/4] kvm, memory-hotplug: Update ept identity pagetable when it is migrated.
Date: Wed, 2 Jul 2014 17:00:36 +0800
Message-ID: <1404291637-15048-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ept identity pagetable is pinned in memory, and as a result it cannot be
migrated/hot-removed.

But actually it doesn't need to be pinned in memory.

This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT to reset ept
indetity pagetable related variable. This request will be made when
kvm_mmu_notifier_invalidate_page() is called when the page is unmapped
from the qemu user space to reset kvm->arch.ept_identity_pagetable to NULL.
And will also be made when ept violation happens to reset
kvm->arch.ept_identity_pagetable to the new page.
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              | 11 +++++++++++
 arch/x86/kvm/vmx.c              |  3 ++-
 arch/x86/kvm/x86.c              | 16 ++++++++++++++++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             |  6 ++++++
 6 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4931415..8771c0f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -581,6 +581,7 @@ struct kvm_arch {
 	struct page *ept_identity_pagetable;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
+	bool ept_identity_pagetable_migrated;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..c0d72f6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3425,6 +3425,17 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable,
 			 level, gfn, pfn, prefault);
+
+	/*
+	 * Update ept identity pagetable page and apic access page if
+	 * they are migrated.
+	 */
+	if (gpa == vcpu->kvm->arch.ept_identity_map_addr &&
+	    vcpu->kvm->arch.ept_identity_pagetable_migrated) {
+		vcpu->kvm->arch.ept_identity_pagetable_migrated = false;
+		kvm_make_request(KVM_REQ_MIGRATE_EPT, vcpu);
+	}
+
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 366b5b3..c336cb3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4018,7 +4018,8 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm,
+			kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..a26524f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5929,6 +5929,20 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
+static void vcpu_migrated_page_update_ept(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (kvm->arch.ept_identity_pagetable_migrated)
+		kvm->arch.ept_identity_pagetable = NULL;
+	else {
+		struct page *page;
+		page = gfn_to_page_no_pin(kvm,
+				kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
+		kvm->arch.ept_identity_pagetable = page;
+	}
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -5989,6 +6003,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_MIGRATE_EPT, vcpu))
+			vcpu_migrated_page_update_ept(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7c58d9d..4b7e51a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -136,6 +136,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
 #define KVM_REQ_ENABLE_IBS        23
 #define KVM_REQ_DISABLE_IBS       24
+#define KVM_REQ_MIGRATE_EPT       25
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6091849..d271e89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -294,6 +294,12 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
 
+	if (address ==
+	    gfn_to_hva(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT)) {
+		kvm->arch.ept_identity_pagetable_migrated = true;
+		kvm_make_request(KVM_REQ_MIGRATE_EPT, kvm->vcpus[0]);
+	}
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
-- 
1.8.3.1

