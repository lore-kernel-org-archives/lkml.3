Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3CJGaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:30:55 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51658 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3CJGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:30:52 -0500
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
        David Howells <dhowells@redhat.com>
Subject: [PATCH v2, part1 08/29] mm/FRV: use common help functions to free reserved pages
Date: Sun, 10 Mar 2013 14:26:51 +0800
Message-Id: <1362896833-21104-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/mm/init.c |   34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index 92e97b0..21b9290 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -122,7 +122,7 @@ void __init mem_init(void)
 #endif
 	int codek = 0, datak = 0;
 
-	/* this will put all memory onto the freelists */
+	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
 #ifdef CONFIG_MMU
@@ -132,11 +132,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--) {
-		struct page *page = &mem_map[pfn];
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
+		__free_reserved_page(&mem_map[pfn]);
 		totalram_pages++;
 	}
 #endif
@@ -168,21 +164,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 #if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
-	unsigned long start, end, addr;
-
-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
-
-	/* next to check that the page we free is not a partial page */
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
-	       (end - start) >> 10, start, end);
+	free_initmem_default(0);
 #endif
 } /* end free_initmem() */
 
@@ -193,14 +175,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	int pages = 0;
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-		pages++;
-	}
-	printk("Freeing initrd memory: %dKiB freed\n", (pages * PAGE_SIZE) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 } /* end free_initrd_mem() */
 #endif
-- 
1.7.9.5

