Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3GKW0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:26:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab3GKWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Yi <zhang.yi20@zte.com.cn>, Jiang Biao <jiang.biao2@zte.com.cn>,
        Ma Chenggong <ma.chenggong@zte.com.cn>, Mel Gorman <mgorman@suse.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 10/15] futex: Take hugepages into account when generating futex_key
Date: Thu, 11 Jul 2013 15:19:40 -0700
Message-Id: <20130711221257.132899862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221255.925669600@linuxfoundation.org>
References: <20130711221255.925669600@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/hugetlb.h |   16 ++++++++++++++++
 kernel/futex.c          |    3 ++-
 mm/hugetlb.c            |   17 +++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -354,6 +354,17 @@ static inline int hstate_index(struct hs
 	return h - hstates;
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
@@ -374,6 +385,11 @@ static inline unsigned int pages_per_hug
 }
 #define hstate_index_to_shift(index) 0
 #define hstate_index(h) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+	return page->index;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 #endif /* _LINUX_HUGETLB_H */
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -61,6 +61,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
 #include <linux/sched/rt.h>
+#include <linux/hugetlb.h>
 
 #include <asm/futex.h>
 
@@ -365,7 +366,7 @@ again:
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
-		key->shared.pgoff = page_head->index;
+		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -690,6 +690,23 @@ int PageHuge(struct page *page)
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


