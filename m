Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3JWNeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:34:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60047 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3JWN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:29:58 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 04/15] KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
Date: Wed, 23 Oct 2013 21:29:22 +0800
Message-Id: <1382534973-13197-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-5816-0000-0000-00000A8A956E
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
 arch/x86/kvm/mmu.c | 18 ++++++++++++++----
 arch/x86/kvm/x86.c |  9 +++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 62f18ec..337d173 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4273,15 +4273,25 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b3aa650..573c6b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3571,11 +3571,16 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 		offset = i * BITS_PER_LONG;
 		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
 	}
-	if (is_dirty)
-		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
 
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

