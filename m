Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3FYVQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3FYVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:16:39 -0400
Date: Tue, 25 Jun 2013 14:15:42 -0700
From: tip-bot for Zhang Yi <tipbot@zytor.com>
Message-ID: <tip-13d60f4b6ab5b702dc8d2ee20999f98a93728aec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org, zhang.yi20@zte.com.cn,
        jiang.biao2@zte.com.cn, ma.chenggong@zte.com.cn, mgorman@suse.de,
        tglx@linutronix.de, wetpzy@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org, zhang.yi20@zte.com.cn,
        jiang.biao2@zte.com.cn, mgorman@suse.de, ma.chenggong@zte.com.cn,
        wetpzy@gmail.com, tglx@linutronix.de
In-Reply-To: <000101ce71a6$a83c5880$f8b50980$@com>
References: <000101ce71a6$a83c5880$f8b50980$@com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex:
  Take hugepages into account when generating futex_key
Git-Commit-ID: 13d60f4b6ab5b702dc8d2ee20999f98a93728aec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 14:15:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13d60f4b6ab5b702dc8d2ee20999f98a93728aec
Gitweb:     http://git.kernel.org/tip/13d60f4b6ab5b702dc8d2ee20999f98a93728aec
Author:     Zhang Yi <wetpzy@gmail.com>
AuthorDate: Tue, 25 Jun 2013 21:19:31 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 23:11:19 +0200

futex: Take hugepages into account when generating futex_key

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

---
 include/linux/hugetlb.h | 16 ++++++++++++++++
 kernel/futex.c          |  3 ++-
 mm/hugetlb.c            | 17 +++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6b4890f..feaf0c7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -358,6 +358,17 @@ static inline int hstate_index(struct hstate *h)
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
@@ -378,6 +389,11 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
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
diff --git a/kernel/futex.c b/kernel/futex.c
index b26dcfc..49dacfb 100644
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f8feeec..aea87ce 100644
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
