Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3HNKiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3HNKh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Yi <zhang.yi20@zte.com.cn>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/75] futex: Take hugepages into account when generating futex_key
Date: Wed, 14 Aug 2013 11:36:25 +0100
Message-Id: <1376476624-10011-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <wetpzy@gmail.com>

commit 13d60f4b6ab5b702dc8d2ee20999f98a93728aec upstream.

The futex_keys of process shared futexes are generated from the page
offset, the mapping host and the mapping index of the futex user space
address. This should result in an unique identifier for each futex.

Though this is not true when futexes are located in different subpages
of an hugepage. The reason is, that the mapping index for all those
futexes evaluates to the index of the base page of the hugetlbfs
mapping. So a futex at offset 0 of the hugepage mapping and another
one at offset PAGE_SIZE of the same hugepage mapping have identical
futex_keys. This happens because the futex code blindly uses
page->index.

Steps to reproduce the bug:

1. Map a file from hugetlbfs. Initialize pthread_mutex1 at offset 0
   and pthread_mutex2 at offset PAGE_SIZE of the hugetlbfs
   mapping.

   The mutexes must be initialized as PTHREAD_PROCESS_SHARED because
   PTHREAD_PROCESS_PRIVATE mutexes are not affected by this issue as
   their keys solely depend on the user space address.

2. Lock mutex1 and mutex2

3. Create thread1 and in the thread function lock mutex1, which
   results in thread1 blocking on the locked mutex1.

4. Create thread2 and in the thread function lock mutex2, which
   results in thread2 blocking on the locked mutex2.

5. Unlock mutex2. Despite the fact that mutex2 got unlocked, thread2
   still blocks on mutex2 because the futex_key points to mutex1.

To solve this issue we need to take the normal page index of the page
which contains the futex into account, if the futex is in an hugetlbfs
mapping. In other words, we calculate the normal page mapping index of
the subpage in the hugetlbfs mapping.

Mappings which are not based on hugetlbfs are not affected and still
use page->index.

Thanks to Mel Gorman who provided a patch for adding proper evaluation
functions to the hugetlbfs code to avoid exposing hugetlbfs specific
details to the futex code.

[ tglx: Massaged changelog ]

Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: 'Mel Gorman' <mgorman@suse.de>
Acked-by: 'Darren Hart' <dvhart@linux.intel.com>
Cc: 'Peter Zijlstra' <peterz@infradead.org>
Link: http://lkml.kernel.org/r/000101ce71a6%24a83c5880%24f8b50980%24@com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/hugetlb.h | 16 ++++++++++++++++
 kernel/futex.c          |  3 ++-
 mm/hugetlb.c            | 17 +++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b8cdad6..9003fe3 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -301,6 +301,17 @@ static inline unsigned hstate_index_to_shift(unsigned index)
 	return hstates[index].order + PAGE_SHIFT;
 }
 
+pgoff_t __basepage_index(struct page *page);
+
+/* Return page->index in PAGE_SIZE units */
+static inline pgoff_t basepage_index(struct page *page)
+{
+	if (!PageCompound(page))
+		return page->index;
+
+	return __basepage_index(page);
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -319,6 +330,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 	return 1;
 }
 #define hstate_index_to_shift(index) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+	return page->index;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/kernel/futex.c b/kernel/futex.c
index 8879430..f0ee318 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
+#include <linux/hugetlb.h>
 
 #include <asm/futex.h>
 
@@ -363,7 +364,7 @@ again:
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
-		key->shared.pgoff = page_head->index;
+		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c6557ef..44fd603 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -679,6 +679,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+pgoff_t __basepage_index(struct page *page)
+{
+	struct page *page_head = compound_head(page);
+	pgoff_t index = page_index(page_head);
+	unsigned long compound_idx;
+
+	if (!PageHuge(page_head))
+		return page_index(page);
+
+	if (compound_order(page_head) >= MAX_ORDER)
+		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
+	else
+		compound_idx = page - page_head;
+
+	return (index << compound_order(page_head)) + compound_idx;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
-- 
1.8.3.2

