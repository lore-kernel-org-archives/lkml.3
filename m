Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab3IEKdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:33:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54167 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935634Ab3IEK3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:42 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 06/15] KVM: MMU: update spte and add it into rmap before dirty log
Date: Thu,  5 Sep 2013 18:29:09 +0800
Message-Id: <1378376958-27252-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090521-3568-0000-0000-0000043200D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the its dirty
bitmap, so we should ensure the writable spte can be found in rmap before the
dirty bitmap is visible. Otherwise, we clear the dirty bitmap but fail to
write-protect the page which is detailed in the comments in this patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 84 ++++++++++++++++++++++++++++++++++++++++++------------
 arch/x86/kvm/x86.c | 10 +++++++
 2 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a983570..8ea54d9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2428,6 +2428,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 {
 	u64 spte;
 	int ret = 0;
+	bool remap = is_rmap_spte(*sptep);
 
 	if (set_mmio_spte(vcpu->kvm, sptep, gfn, pfn, pte_access))
 		return 0;
@@ -2489,12 +2490,73 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK)
-		mark_page_dirty(vcpu->kvm, gfn);
-
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
+
+	if (!remap) {
+		if (rmap_add(vcpu, sptep, gfn) > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
+
+		if (level > PT_PAGE_TABLE_LEVEL)
+			++vcpu->kvm->stat.lpages;
+	}
+
+	/*
+	 * The orders we require are:
+	 * 1) set spte to writable __before__ set the dirty bitmap.
+	 *    It makes sure that dirty-logging is not missed when do
+	 *    live migration at the final step where kvm should stop
+	 *    the guest and push the remaining dirty pages got from
+	 *    dirty-bitmap to the destination. The similar cases are
+	 *    in fast_pf_fix_direct_spte() and kvm_write_guest_page().
+	 *
+	 * 2) add the spte into rmap __before__ set the dirty bitmap.
+	 *
+	 * They can ensure we can find the writable spte on the rmap
+	 * when we do lockless write-protection since
+	 * kvm_vm_ioctl_get_dirty_log() write-protects the pages based
+	 * on its dirty-bitmap, otherwise these cases will happen:
+	 *
+	 *      CPU 0                         CPU 1
+	 *                              kvm ioctl doing get-dirty-pages
+	 * mark_page_dirty(gfn) which
+	 * set the gfn on the dirty maps
+	 *                              mask = xchg(dirty_bitmap, 0)
+	 *
+	 *                              try to write-protect gfns which
+	 *                              are set on "mask" then walk then
+	 *                              rmap, see no spte on that rmap
+	 * add the spte into rmap
+	 *
+	 * !!!!!! Then the page can be freely wrote but not recorded in
+	 * the dirty bitmap.
+	 *
+	 * And:
+	 *
+	 *      VCPU 0                        CPU 1
+	 *                                kvm ioctl doing get-dirty-pages
+	 * mark_page_dirty(gfn) which
+	 * set the gfn on the dirty maps
+	 *
+	 * add spte into rmap
+	 *                                mask = xchg(dirty_bitmap, 0)
+	 *
+	 *                                try to write-protect gfns which
+	 *                                are set on "mask" then walk then
+	 *                                rmap, see spte is on the ramp
+	 *                                but it is readonly or nonpresent
+	 * Mark spte writable
+	 *
+	 * !!!!!! Then the page can be freely wrote but not recorded in the
+	 * dirty bitmap.
+	 *
+	 * See the comments in kvm_vm_ioctl_get_dirty_log().
+	 */
+	smp_wmb();
+
+	if (pte_access & ACC_WRITE_MASK)
+		mark_page_dirty(vcpu->kvm, gfn);
 done:
 	return ret;
 }
@@ -2504,9 +2566,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 int level, gfn_t gfn, pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
-	int was_rmapped = 0;
-	int rmap_count;
-
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
@@ -2528,8 +2587,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			kvm_flush_remote_tlbs(vcpu->kvm);
-		} else
-			was_rmapped = 1;
+		}
 	}
 
 	if (set_spte(vcpu, sptep, pte_access, level, gfn, pfn, speculative,
@@ -2547,16 +2605,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 is_large_pte(*sptep)? "2MB" : "4kB",
 		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
 		 *sptep, sptep);
-	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;
-
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
-	}
 
 	kvm_release_pfn_clean(pfn);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72f1487..5582b66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3555,6 +3555,16 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 		is_dirty = true;
 
 		mask = xchg(&dirty_bitmap[i], 0);
+		/*
+		 * smp_rmb();
+		 *
+		 * The read-barrier is implied in xchg() acting as a
+		 * full barrier and it ensures getting dirty bitmap
+		 * is before walking the rmap and spte write-protection.
+		 *
+		 * See the comments in set_spte().
+		 */
+
 		dirty_bitmap_buffer[i] = mask;
 
 		offset = i * BITS_PER_LONG;
-- 
1.8.1.4

