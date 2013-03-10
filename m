Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3CJGck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:32:40 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37099 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3CJGch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:32:37 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH v2, part1 20/29] mm/score: use common help functions to free reserved pages
Date: Sun, 10 Mar 2013 14:27:03 +0800
Message-Id: <1362896833-21104-21-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/mm/init.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index cee6bce..1592aad 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(empty_zero_page);
 
 static struct kcore_list kcore_mem, kcore_vmalloc;
 
-static unsigned long setup_zero_page(void)
+static void setup_zero_page(void)
 {
 	struct page *page;
 
@@ -52,9 +52,7 @@ static unsigned long setup_zero_page(void)
 		panic("Oh boy, that early out of memory?");
 
 	page = virt_to_page((void *) empty_zero_page);
-	SetPageReserved(page);
-
-	return 1UL;
+	mark_page_reserved(page);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -84,7 +82,7 @@ void __init mem_init(void)
 
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
+	setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -109,37 +107,16 @@ void __init mem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long pfn;
-
-	for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
-		struct page *page = pfn_to_page(pfn);
-		void *addr = phys_to_virt(PFN_PHYS(pfn));
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		__free_page(page);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory",
-		virt_to_phys((void *) start),
-		virt_to_phys((void *) end));
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
 void __init_refok free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-	__pa(&__init_begin),
-	__pa(&__init_end));
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 unsigned long pgd_current;
-- 
1.7.9.5

