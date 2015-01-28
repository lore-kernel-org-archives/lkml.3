Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbbA1Bim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020AbbA1Bi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianyu Zhan <nasa4836@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Shaohua Li <shli@kernel.org>,
        Bob Liu <bob.liu@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rafael Aquini <aquini@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 45/77] mm/swap.c: clean up *lru_cache_add* functions
Date: Tue, 27 Jan 2015 17:27:23 -0800
Message-Id: <20150128012747.306069863@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyu Zhan <nasa4836@gmail.com>

commit 2329d3751b082b4fd354f334a88662d72abac52d upstream.

In mm/swap.c, __lru_cache_add() is exported, but actually there are no
users outside this file.

This patch unexports __lru_cache_add(), and makes it static.  It also
exports lru_cache_add_file(), as it is use by cifs and fuse, which can
loaded as modules.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/swap.h |   19 ++-----------------
 mm/swap.c            |   31 +++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 25 deletions(-)

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -268,8 +268,9 @@ extern unsigned long nr_free_pagecache_p
 
 
 /* linux/mm/swap.c */
-extern void __lru_cache_add(struct page *);
 extern void lru_cache_add(struct page *);
+extern void lru_cache_add_anon(struct page *page);
+extern void lru_cache_add_file(struct page *page);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
@@ -283,22 +284,6 @@ extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
 
-/**
- * lru_cache_add: add a page to the page lists
- * @page: the page to add
- */
-static inline void lru_cache_add_anon(struct page *page)
-{
-	ClearPageActive(page);
-	__lru_cache_add(page);
-}
-
-static inline void lru_cache_add_file(struct page *page)
-{
-	ClearPageActive(page);
-	__lru_cache_add(page);
-}
-
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -580,13 +580,7 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-/*
- * Queue the page for addition to the LRU via pagevec. The decision on whether
- * to add the page to the [in]active [file|anon] list is deferred until the
- * pagevec is drained. This gives a chance for the caller of __lru_cache_add()
- * have the page added to the active list using mark_page_accessed().
- */
-void __lru_cache_add(struct page *page)
+static void __lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
 
@@ -596,11 +590,32 @@ void __lru_cache_add(struct page *page)
 	pagevec_add(pvec, page);
 	put_cpu_var(lru_add_pvec);
 }
-EXPORT_SYMBOL(__lru_cache_add);
+
+/**
+ * lru_cache_add: add a page to the page lists
+ * @page: the page to add
+ */
+void lru_cache_add_anon(struct page *page)
+{
+	ClearPageActive(page);
+	__lru_cache_add(page);
+}
+
+void lru_cache_add_file(struct page *page)
+{
+	ClearPageActive(page);
+	__lru_cache_add(page);
+}
+EXPORT_SYMBOL(lru_cache_add_file);
 
 /**
  * lru_cache_add - add a page to a page list
  * @page: the page to be added to the LRU.
+ *
+ * Queue the page for addition to the LRU via pagevec. The decision on whether
+ * to add the page to the [in]active [file|anon] list is deferred until the
+ * pagevec is drained. This gives a chance for the caller of lru_cache_add()
+ * have the page added to the active list using mark_page_accessed().
  */
 void lru_cache_add(struct page *page)
 {


