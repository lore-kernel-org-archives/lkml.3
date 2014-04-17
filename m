Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDQJIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:08:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37602 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaDQJFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:05:47 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 3/5] KVM: MMU: lazily drop large spte
Date: Thu, 17 Apr 2014 17:06:14 +0800
Message-Id: <1397725576-6617-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041709-2000-0000-0000-000010D966BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kvm zaps the large spte if write-protected is needed, the later
read can fault on that spte. Actually, we can make the large spte readonly
instead of making them un-present, the page fault caused by read access can
be avoided

The idea is from Avi:
| As I mentioned before, write-protecting a large spte is a good idea,
| since it moves some work from protect-time to fault-time, so it reduces
| jitter.  This removes the need for the return value.

This version has fixed the issue reported in 6b73a9606, the reason of that
issue is that fast_page_fault() directly sets the readonly large spte to
writable but only dirty the first page into the dirty-bitmap that means
other pages are missed. Fixed it by only the normal sptes (on the
PT_PAGE_TABLE_LEVEL level) can be fast fixed

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 34 ++++++++++++++++++----------------
 arch/x86/kvm/x86.c |  8 ++++++--
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6310704..ddf0696 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1176,8 +1176,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
- * spte writ-protection is caused by protecting shadow page table.
- * @flush indicates whether tlb need be flushed.
+ * spte write-protection is caused by protecting shadow page table.
  *
  * Note: write protection is difference between drity logging and spte
  * protection:
@@ -1186,10 +1185,9 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  * - for spte protection, the spte can be writable only after unsync-ing
  *   shadow page.
  *
- * Return true if the spte is dropped.
+ * Return true if tlb need be flushed.
  */
-static bool
-spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
+static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool pt_protect)
 {
 	u64 spte = *sptep;
 
@@ -1199,17 +1197,11 @@ spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 
 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
 
-	if (__drop_large_spte(kvm, sptep)) {
-		*flush |= true;
-		return true;
-	}
-
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
 	spte = spte & ~PT_WRITABLE_MASK;
 
-	*flush |= mmu_spte_update(sptep, spte);
-	return false;
+	return mmu_spte_update(sptep, spte);
 }
 
 static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
@@ -1221,11 +1213,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
-			sptep = rmap_get_first(*rmapp, &iter);
-			continue;
-		}
 
+		flush |= spte_write_protect(kvm, sptep, pt_protect);
 		sptep = rmap_get_next(&iter);
 	}
 
@@ -2877,6 +2866,19 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		goto exit;
 
 	/*
+	 * Do not fix write-permission on the large spte since we only dirty
+	 * the first page into the dirty-bitmap in fast_pf_fix_direct_spte()
+	 * that means other pages are missed if its slot is dirty-logged.
+	 *
+	 * Instead, we let the slow page fault path create a normal spte to
+	 * fix the access.
+	 *
+	 * See the comments in kvm_arch_commit_memory_region().
+	 */
+	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+		goto exit;
+
+	/*
 	 * Currently, fast page fault only works for direct mapping since
 	 * the gfn is not stable for indirect shadow page.
 	 * See Documentation/virtual/kvm/locking.txt to get more detail.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b8fc0b..ebd8506 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7329,8 +7329,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	/*
 	 * Write protect all pages for dirty logging.
-	 * Existing largepage mappings are destroyed here and new ones will
-	 * not be created until the end of the logging.
+	 *
+	 * All the sptes including the large sptes which point to this
+	 * slot are set to readonly. We can not create any new large
+	 * spte on this slot until the end of the logging.
+	 *
+	 * See the comments in fast_page_fault().
 	 */
 	if ((change != KVM_MR_DELETE) && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
 		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
-- 
1.8.1.4

