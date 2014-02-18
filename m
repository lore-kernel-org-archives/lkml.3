Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBRWqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaBRWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        rajman mekaco <rajman.mekaco@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 08/24] mm/page_alloc.c: remove pageblock_default_order()
Date: Tue, 18 Feb 2014 14:46:55 -0800
Message-Id: <20140218224550.466043876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 955c1cd7401565671b064e499115344ec8067dfd upstream.

This has always been broken: one version takes an unsigned int and the
other version takes no arguments.  This bug was hidden because one
version of set_pageblock_order() was a macro which doesn't evaluate its
argument.

Simplify it all and remove pageblock_default_order() altogether.

Reported-by: rajman mekaco <rajman.mekaco@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4254,25 +4254,24 @@ static inline void setup_usemap(struct p
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
-/* Return a sensible default order for the pageblock size. */
-static inline int pageblock_default_order(void)
-{
-	if (HPAGE_SHIFT > PAGE_SHIFT)
-		return HUGETLB_PAGE_ORDER;
-
-	return MAX_ORDER-1;
-}
-
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(unsigned int order)
+static inline void __init set_pageblock_order(void)
 {
+	unsigned int order;
+
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
 		return;
 
+	if (HPAGE_SHIFT > PAGE_SHIFT)
+		order = HUGETLB_PAGE_ORDER;
+	else
+		order = MAX_ORDER - 1;
+
 	/*
 	 * Assume the largest contiguous order of interest is a huge page.
-	 * This value may be variable depending on boot parameters on IA64
+	 * This value may be variable depending on boot parameters on IA64 and
+	 * powerpc.
 	 */
 	pageblock_order = order;
 }
@@ -4280,15 +4279,13 @@ static inline void __init set_pageblock_
 
 /*
  * When CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not set, set_pageblock_order()
- * and pageblock_default_order() are unused as pageblock_order is set
- * at compile-time. See include/linux/pageblock-flags.h for the values of
- * pageblock_order based on the kernel config
+ * is unused as pageblock_order is set at compile-time. See
+ * include/linux/pageblock-flags.h for the values of pageblock_order based on
+ * the kernel config
  */
-static inline int pageblock_default_order(unsigned int order)
+static inline void set_pageblock_order(void)
 {
-	return MAX_ORDER-1;
 }
-#define set_pageblock_order(x)	do {} while (0)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
@@ -4376,7 +4373,7 @@ static void __paginginit free_area_init_
 		if (!size)
 			continue;
 
-		set_pageblock_order(pageblock_default_order());
+		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);


