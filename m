Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab3HMQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:30:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3HMQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:56 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=VnSFgcBX-AMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OtEz8PCO-34A:10 a=pGLkceISAAAA:8 a=1RTuLK3dAAAA:8 a=QyXUC8HyAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=7I5jNDqDwggut0BNmlQA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=-7CqDtAj-f4oG9fP:21 a=6HxrMK_ld5JGHsj4:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155833.089151902@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhang Yi <zhang.yi20@zte.com.cn>, Jiang Biao <jiang.biao2@zte.com.cn>,
        Ma Chenggong <ma.chenggong@zte.com.cn>, Mel Gorman <mgorman@suse.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [60/88] futex: Take hugepages into account when generating futex_key
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0060-futex-Take-hugepages-into-account-when-generating-fu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zhang Yi <wetpzy@gmail.com>

[ Upstream commit 13d60f4b6ab5b702dc8d2ee20999f98a93728aec ]

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/000101ce71a6%24a83c5880%24f8b50980%24@com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/hugetlb.h |   16 ++++++++++++++++
 kernel/futex.c          |    3 ++-
 mm/hugetlb.c            |   17 +++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2251648..2d7c263 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -341,6 +341,17 @@ static inline int hstate_index(struct hstate *h)
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
 #else
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -360,6 +371,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 }
 #define hstate_index_to_shift(index) 0
 #define hstate_index(h) 0
+
+static inline pgoff_t basepage_index(struct page *page)
+{
+       return page->index;
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..1f71e4d 100644
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
index 7e5ff99..52b15a6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -685,6 +685,23 @@ int PageHuge(struct page *page)
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
1.7.10.4


