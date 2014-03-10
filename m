Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaCJOCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:02:09 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34446 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaCJOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:02:05 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 5/5] KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
Date: Mon, 10 Mar 2014 22:01:49 +0800
Message-Id: <1394460109-3150-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031014-2000-0000-0000-00001019EEBD
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

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 25 +++++++++++++++++++++----
 arch/x86/kvm/mmu.h | 14 ++++++++++++++
 arch/x86/kvm/x86.c | 12 ++++++++++--
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 17bb136..01a8c35 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4281,15 +4281,32 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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
index 2926152..585d6b1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -96,6 +96,20 @@ static inline int is_present_gpte(unsigned long pte)
 	return pte & PT_PRESENT_MASK;
 }
 
+/*
+ * Please note PT_WRITABLE_MASK is not stable since
+ * 1) fast_page_fault() sets spte from readonly to writable out of mmu-lock or
+ * 2) kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
+ *    can write protect sptes but flush tlb out mmu-lock that means we may use
+ *    the corrupt tlb entries which depend on this bit.
+ *
+ * Both cases do not modify the status of  spte_is_locklessly_modifiable() so
+ * if you want to check whether the spte is writable on MMU you can check
+ * SPTE_MMU_WRITEABLE instead. If you want to update spte without losing
+ * A/D bits and tlb flush, you can check spte_is_locklessly_modifiable()
+ * instead. See the comments in spte_has_volatile_bits() and
+ * mmu_spte_update().
+ */
 static inline int is_writable_pte(unsigned long pte)
 {
 	return pte & PT_WRITABLE_MASK;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6bcc343..ba1b1db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3642,11 +3642,19 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
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

