Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaKGRpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:45:53 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58253 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaKGRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:45:51 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Mario Smarduch <m.smarduch@samsung.com>, christoffer.dall@linaro.org
Subject: [PATCH] KVM: x86: switch to kvm_get_dirty_log_protect
Date: Fri,  7 Nov 2014 18:45:43 +0100
Message-Id: <1415382343-13406-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have a generic function that does most of the work of
kvm_vm_ioctl_get_dirty_log, now use it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Mario/Christoffer, please include this in the ARM series too

 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/mmu.c              |  8 +++----
 arch/x86/kvm/x86.c              | 52 ++++-------------------------------------
 virt/kvm/kvm_main.c             |  3 +--
 4 files changed, 9 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ac807646911..16b795a397ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -804,9 +804,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
-void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c8540ac45e20..f078fca44fe6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1218,7 +1218,7 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 }
 
 /**
- * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+ * kvm_arch_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
  * @slot: slot to protect
  * @gfn_offset: start of the BITS_PER_LONG pages we care about
@@ -1227,9 +1227,9 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
  * Used when we do not need to care about huge page mappings: e.g. during dirty
  * logging we do not have any such mappings.
  */
-void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask)
+void kvm_arch_mmu_write_protect_pt_masked(struct kvm *kvm,
+				          struct kvm_memory_slot *slot,
+				          gfn_t gfn_offset, unsigned long mask)
 {
 	unsigned long *rmapp;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c7f27f5e88b..f0eb749331c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3661,65 +3661,21 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
  */
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
-	int r;
-	struct kvm_memory_slot *memslot;
-	unsigned long n, i;
-	unsigned long *dirty_bitmap;
-	unsigned long *dirty_bitmap_buffer;
 	bool is_dirty = false;
+	int r;
 
 	mutex_lock(&kvm->slots_lock);
 
-	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
-		goto out;
-
-	memslot = id_to_memslot(kvm->memslots, log->slot);
-
-	dirty_bitmap = memslot->dirty_bitmap;
-	r = -ENOENT;
-	if (!dirty_bitmap)
-		goto out;
-
-	n = kvm_dirty_bitmap_bytes(memslot);
-
-	dirty_bitmap_buffer = dirty_bitmap + n / sizeof(long);
-	memset(dirty_bitmap_buffer, 0, n);
-
-	spin_lock(&kvm->mmu_lock);
-
-	for (i = 0; i < n / sizeof(long); i++) {
-		unsigned long mask;
-		gfn_t offset;
-
-		if (!dirty_bitmap[i])
-			continue;
-
-		is_dirty = true;
-
-		mask = xchg(&dirty_bitmap[i], 0);
-		dirty_bitmap_buffer[i] = mask;
-
-		offset = i * BITS_PER_LONG;
-		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
-	}
-
-	spin_unlock(&kvm->mmu_lock);
-
-	r = 0;
-	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
-		r = -EFAULT;
-
-	/* See the comments in kvm_mmu_slot_remove_write_access(). */
-	lockdep_assert_held(&kvm->slots_lock);
+	r = kvm_get_dirty_log_protect(kvm, log, &is_dirty);
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
 	 * kvm_mmu_slot_remove_write_access().
 	 */
+	lockdep_assert_held(&kvm->slots_lock);
 	if (is_dirty)
 		kvm_flush_remote_tlbs(kvm);
-out:
+
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cbc136777c07..6e0a5826d416 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -999,8 +999,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
 
-#if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS) || \
-    defined(CONFIG_IA64) || defined(CONFIG_X86) || defined(CONFIG_ARM64)
+#if !defined(CONFIG_X86) && !defined(CONFIG_ARM)
 /*
  * For architectures that don't use kvm_get_dirty_log_protect() for dirty page
  * logging, calling this function is illegal. Otherwise the function is defined
-- 
2.1.0

