Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaDQJFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:05:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:52280 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbaDQJFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:05:50 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 5/5] KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
Date: Thu, 17 Apr 2014 17:06:16 +0800
Message-Id: <1397725576-6617-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041709-9574-0000-0000-00000D1E9F92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can flush all the TLBs out of the mmu lock without TLB corruption when
write-proect the sptes, it is because:
- we have marked large sptes readonly instead of dropping them that means we
  just change the spte from writable to readonly so that we only need to care
  the case of changing spte from present to present (changing the spte from
  present to nonpresent will flush all the TLBs immediately), in other words,
  the only case we need to care is mmu_spte_update()

- in mmu_spte_update(), we haved checked
  SPTE_HOST_WRITEABLE | PTE_MMU_WRITEABLE instead of PT_WRITABLE_MASK, that
  means it does not depend on PT_WRITABLE_MASK anymore

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 25 +++++++++++++++++++++----
 arch/x86/kvm/mmu.h | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c | 12 ++++++++++--
 3 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 388a2ef..65f2400 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4309,15 +4309,32 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			if (*rmapp)
 				__rmap_write_protect(kvm, rmapp, false);
 
-			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-				kvm_flush_remote_tlbs(kvm);
+			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
 				cond_resched_lock(&kvm->mmu_lock);
-			}
 		}
 	}
 
-	kvm_flush_remote_tlbs(kvm);
 	spin_unlock(&kvm->mmu_lock);
+
+	/*
+	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
+	 * which do tlb flush out of mmu-lock should be serialized by
+	 * kvm->slots_lock otherwise tlb flush would be missed.
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+
+	/*
+	 * We can flush all the TLBs out of the mmu lock without TLB
+	 * corruption since we just change the spte from writable to
+	 * readonly so that we only need to care the case of changing
+	 * spte from present to present (changing the spte from present
+	 * to nonpresent will flush all the TLBs immediately), in other
+	 * words, the only case we care is mmu_spte_update() where we
+	 * haved checked SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE
+	 * instead of PT_WRITABLE_MASK, that means it does not depend
+	 * on PT_WRITABLE_MASK anymore.
+	 */
+	kvm_flush_remote_tlbs(kvm);
 }
 
 #define BATCH_ZAP_PAGES	10
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3842e70..b982112 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -104,6 +104,39 @@ static inline int is_present_gpte(unsigned long pte)
 	return pte & PT_PRESENT_MASK;
 }
 
+/*
+ * Currently, we have two sorts of write-protection, a) the first one
+ * write-protects guest page to sync the guest modification, b) another one is
+ * used to sync dirty bitmap when we do KVM_GET_DIRTY_LOG. The differences
+ * between these two sorts are:
+ * 1) the first case clears SPTE_MMU_WRITEABLE bit.
+ * 2) the first case requires flushing tlb immediately avoiding corrupting
+ *    shadow page table between all vcpus so it should be in the protection of
+ *    mmu-lock. And the another case does not need to flush tlb until returning
+ *    the dirty bitmap to userspace since it only write-protects the page
+ *    logged in the bitmap, that means the page in the dirty bitmap is not
+ *    missed, so it can flush tlb out of mmu-lock.
+ *
+ * So, there is the problem: the first case can meet the corrupted tlb caused
+ * by another case which write-protects pages but without flush tlb
+ * immediately. In order to making the first case be aware this problem we let
+ * it flush tlb if we try to write-protect a spte whose SPTE_MMU_WRITEABLE bit
+ * is set, it works since another case never touches SPTE_MMU_WRITEABLE bit.
+ *
+ * Anyway, whenever a spte is updated (only permission and status bits are
+ * changed) we need to check whether the spte with SPTE_MMU_WRITEABLE becomes
+ * readonly, if that happens, we need to flush tlb. Fortunately,
+ * mmu_spte_update() has already handled it perfectly.
+ *
+ * The rules to use SPTE_MMU_WRITEABLE and PT_WRITABLE_MASK:
+ * - if we want to see if it has writable tlb entry or if the spte can be
+ *   writable on the mmu mapping, check SPTE_MMU_WRITEABLE, this is the most
+ *   case, otherwise
+ * - if we fix page fault on the spte or do write-protection by dirty logging,
+ *   check PT_WRITABLE_MASK.
+ *
+ * TODO: introduce APIs to split these two cases.
+ */
 static inline int is_writable_pte(unsigned long pte)
 {
 	return pte & PT_WRITABLE_MASK;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebd8506..fe2590f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3646,11 +3646,19 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 		offset = i * BITS_PER_LONG;
 		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
 	}
-	if (is_dirty)
-		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
 
+	/* See the comments in kvm_mmu_slot_remove_write_access(). */
+	lockdep_assert_held(&kvm->slots_lock);
+
+	/*
+	 * All the TLBs can be flushed out of mmu lock, see the comments in
+	 * kvm_mmu_slot_remove_write_access().
+	 */
+	if (is_dirty)
+		kvm_flush_remote_tlbs(kvm);
+
 	r = -EFAULT;
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		goto out;
-- 
1.8.1.4

