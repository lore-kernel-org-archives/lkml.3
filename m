Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaGXOgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:36:50 -0400
Received: from 8bytes.org ([81.169.241.247]:57889 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759211AbaGXOgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:36:07 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de, Jay.Cornwall@amd.com,
        Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: [PATCH 3/3] mmu_notifier: Add the call-back for mmu_notifier_invalidate_range()
Date: Thu, 24 Jul 2014 16:35:41 +0200
Message-Id: <1406212541-25975-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406212541-25975-1-git-send-email-joro@8bytes.org>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Now that the mmu_notifier_invalidate_range() calls are in
place, add the call-back to allow subsystems to register
against it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 include/linux/mmu_notifier.h | 28 ++++++++++++++++++++++------
 mm/mmu_notifier.c            | 15 +++++++++++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 6959dc8..50dc679 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -95,11 +95,11 @@ struct mmu_notifier_ops {
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
 	 * paired and are called only when the mmap_sem and/or the
-	 * locks protecting the reverse maps are held. The subsystem
-	 * must guarantee that no additional references are taken to
-	 * the pages in the range established between the call to
-	 * invalidate_range_start() and the matching call to
-	 * invalidate_range_end().
+	 * locks protecting the reverse maps are held. If the subsystem
+	 * can't guarantee that no additional references are taken to
+	 * the pages in the range, it has to implement the
+	 * invalidate_range() notifier to remove any references taken
+	 * after invalidate_range_start().
 	 *
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
@@ -110,9 +110,19 @@ struct mmu_notifier_ops {
 	 * invalidate_range_start() is called when all pages in the
 	 * range are still mapped and have at least a refcount of one.
 	 *
+	 * invalidate_range() is called between invalidate_range_start()
+	 * and invalidate_range_end() when the memory management code
+	 * removed mappings to pages in the range and is about to free
+	 * them.  This captures the point when pages are unmapped but
+	 * not yet freed.
+	 * Note that invalidate_range() might be called only on a
+	 * sub-range of the range passed to the corresponding
+	 * invalidate_range_start() call.
+	 *
 	 * invalidate_range_end() is called when all pages in the
 	 * range have been unmapped and the pages have been freed by
-	 * the VM.
+	 * the VM. It might be called under the ptl spin-lock, so this
+	 * notifier is not allowed to preempt.
 	 *
 	 * The VM will remove the page table entries and potentially
 	 * the page between invalidate_range_start() and
@@ -138,6 +148,8 @@ struct mmu_notifier_ops {
 	void (*invalidate_range_start)(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long start, unsigned long end);
+	void (*invalidate_range)(struct mmu_notifier *mn, struct mm_struct *mm,
+				 unsigned long start, unsigned long end);
 	void (*invalidate_range_end)(struct mmu_notifier *mn,
 				     struct mm_struct *mm,
 				     unsigned long start, unsigned long end);
@@ -182,6 +194,8 @@ extern void __mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address);
 extern void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
+extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end);
 extern void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
 
@@ -231,6 +245,8 @@ static inline void mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
+	if (mm_has_notifiers(mm))
+		__mmu_notifier_invalidate_range(mm, start, end);
 }
 
 static inline void mmu_notifier_invalidate_range_end(struct mm_struct *mm,
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 41cefdf..d1bdea0 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -165,6 +165,21 @@ void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);
 
+void __mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+	struct mmu_notifier *mn;
+	int id;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
+		if (mn->ops->invalidate_range)
+			mn->ops->invalidate_range(mn, mm, start, end);
+	}
+	srcu_read_unlock(&srcu, id);
+}
+EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range);
+
 void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
-- 
1.9.1

