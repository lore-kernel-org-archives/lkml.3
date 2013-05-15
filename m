Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab3EON5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:57:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33890 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3EON5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:57:08 -0400
From: "Zhang Yi" <wetpzy@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>, <mgorman@suse.de>,
        <zhang.yi20@zte.com.cn>
Subject: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
Date: Wed, 15 May 2013 21:57:03 +0800
Message-ID: <000101ce5174$1962bac0$4c283040$@com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac5RdBPni8groG2oSUCK+HwqmstPgg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex-keys of processes share futex determined by page-offset,
mapping-host, and mapping-index of the user space address. User
appications using hugepage for futex may lead to futex-key conflict.

Assume there are two or more futexes in diffrent normal pages of the
hugepage, and each futex has the same offset in its normal page,
causing all the futexes have the same futex-key.

This patch adds the normal page index in the compound page into
the pgoff of futex-key.

Steps to reproduce the bug:
1. The 1st thread map a file of hugetlbfs, and use the return address
as the 1st mutex's address, and use the return address with PAGE_SIZE
added as the 2nd mutex's address.
2. The 1st thread initialize the two mutexes with pshared attribute,
and lock the two mutexes.
3. The 1st thread create the 2nd thread, and the 2nd thread block on
the 1st mutex.
4. The 1st thread create the 3rd thread, and the 3rd thread block on
the 2nd mutex.
5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take
the 2nd mutex, and may block forever.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>


diff -uprN linux-3.10-rc1.org/include/linux/hugetlb.h linux-3.10-rc1/include/linux/hugetlb.h
--- linux-3.10-rc1.org/include/linux/hugetlb.h	2013-05-12 00:14:08.000000000 +0000
+++ linux-3.10-rc1/include/linux/hugetlb.h	2013-05-14 10:15:49.849389000 +0000
@@ -358,6 +358,17 @@ static inline int hstate_index(struct hs
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
@@ -378,6 +389,11 @@ static inline unsigned int pages_per_hug
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
diff -uprN linux-3.10-rc1.org/kernel/futex.c linux-3.10-rc1/kernel/futex.c
--- linux-3.10-rc1.org/kernel/futex.c	2013-05-12 00:14:08.000000000 +0000
+++ linux-3.10-rc1/kernel/futex.c	2013-05-14 10:15:04.804350000 +0000
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
diff -uprN linux-3.10-rc1.org/mm/hugetlb.c linux-3.10-rc1/mm/hugetlb.c
--- linux-3.10-rc1.org/mm/hugetlb.c	2013-05-12 00:14:08.000000000 +0000
+++ linux-3.10-rc1/mm/hugetlb.c	2013-05-14 10:15:37.470175000 +0000
@@ -690,6 +690,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);

+pgoff_t __basepage_index(struct page *page)
+{
+	struct page *page_head = compound_head(page);
+	pgoff_t index = page_index(page_head);
+	int compound_idx;
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


