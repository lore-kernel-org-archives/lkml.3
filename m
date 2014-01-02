Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaABHOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:14:17 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61829 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:13:13 -0500
X-AuditID: 9c930197-b7c4aae000003d84-0d-52c51185962e
From: Minchan Kim <minchan@kernel.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        John Stultz <john.stultz@linaro.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Jason Evans <je@fb.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v10 06/16] vrange: introduce fake VM_VRANGE flag
Date: Thu,  2 Jan 2014 16:12:14 +0900
Message-Id: <1388646744-15608-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388646744-15608-1-git-send-email-minchan@kernel.org>
References: <1388646744-15608-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce fake VM_VRANGE flag in vma->vm_flags.
Actually, vma->vm_flags doesn't have such flag and it is just
used to detect a page is volatile page or not in page_referenced.

For it, page_referenced's vm_flags argument semantic is changed so that
caller should specify what kinds of flags he has interest.
It could make to avoid unnecessary volatile range lookup in
page_referenced_one.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/mm.h |    9 +++++++++
 mm/rmap.c          |   17 +++++++++++++----
 mm/vmscan.c        |    4 ++--
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55ee8855..3dec30154f96 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -103,6 +103,15 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
 					/* Used by sys_madvise() */
+/*
+ * VM_VRANGE is rather special. Actually, vma->vm_flags doesn't have such flag.
+ * It is used to identify whether a page put on volatile range or not
+ * by page_referenced. So, if we are lack of new bit in vmflags, we could
+ * replace it with assembling exclusive flags.
+ *
+ * ex) VM_HUGEPAGE|VM_NOHUGEPAGE
+ */
+#define VM_VRANGE	0x00001000
 #define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
 #define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
 
diff --git a/mm/rmap.c b/mm/rmap.c
index fd3ee7a54a13..9220f12deb93 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -57,6 +57,7 @@
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
 #include <linux/backing-dev.h>
+#include <linux/vrange.h>
 
 #include <asm/tlbflush.h>
 
@@ -685,7 +686,7 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 		if (vma->vm_flags & VM_LOCKED) {
 			spin_unlock(&mm->page_table_lock);
 			*mapcount = 0;	/* break early from loop */
-			*vm_flags |= VM_LOCKED;
+			*vm_flags &= VM_LOCKED;
 			goto out;
 		}
 
@@ -708,7 +709,7 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 		if (vma->vm_flags & VM_LOCKED) {
 			pte_unmap_unlock(pte, ptl);
 			*mapcount = 0;	/* break early from loop */
-			*vm_flags |= VM_LOCKED;
+			*vm_flags &= VM_LOCKED;
 			goto out;
 		}
 
@@ -724,12 +725,18 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 				referenced++;
 		}
 		pte_unmap_unlock(pte, ptl);
+		if (*vm_flags & VM_VRANGE &&
+				vrange_addr_volatile(vma, address)) {
+			*mapcount = 0; /* break ealry from loop */
+			*vm_flags &= VM_VRANGE;
+			goto out;
+		}
 	}
 
 	(*mapcount)--;
 
 	if (referenced)
-		*vm_flags |= vma->vm_flags;
+		*vm_flags &= vma->vm_flags;
 out:
 	return referenced;
 }
@@ -844,6 +851,9 @@ static int page_referenced_file(struct page *page,
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
+ *
+ * NOTE: caller should pass interested flags in vm_flags to collect
+ * vma->vm_flags.
  */
 int page_referenced(struct page *page,
 		    int is_locked,
@@ -853,7 +863,6 @@ int page_referenced(struct page *page,
 	int referenced = 0;
 	int we_locked = 0;
 
-	*vm_flags = 0;
 	if (page_mapped(page) && page_rmapping(page)) {
 		if (!is_locked && (!PageAnon(page) || PageKsm(page))) {
 			we_locked = trylock_page(page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index eea668d9cff6..8bff386e65a0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -672,7 +672,7 @@ static enum page_references page_check_references(struct page *page,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
-	unsigned long vm_flags;
+	unsigned long vm_flags = VM_EXEC|VM_LOCKED|VM_VRANGE;
 
 	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
 					  &vm_flags);
@@ -1619,7 +1619,6 @@ static void shrink_active_list(unsigned long nr_to_scan,
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
-	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
@@ -1652,6 +1651,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
+		unsigned long vm_flags = VM_EXEC;
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
-- 
1.7.9.5

