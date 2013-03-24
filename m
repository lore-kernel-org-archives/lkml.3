Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3CXHb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:31:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62335 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3CXHbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:31:21 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org
Subject: [RFC PATCH v2, part4 21/39] mm/m68k: prepare for removing num_physpages and simplify mem_init()
Date: Sun, 24 Mar 2013 15:25:00 +0800
Message-Id: <1364109934-7851-35-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org
---
 arch/m68k/mm/init.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 0450989..f58fa43 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -149,33 +149,11 @@ void __init print_memmap(void)
 void __init mem_init(void)
 {
 	pg_data_t *pgdat;
-	int codepages = 0;
-	int datapages = 0;
-	int initpages = 0;
 	int i;
 
 	/* this will put all memory onto the freelists */
-	num_physpages = 0;
-	for_each_online_pgdat(pgdat) {
-		num_physpages += pgdat->node_present_pages;
-
+	for_each_online_pgdat(pgdat)
 		free_all_bootmem_node(pgdat);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat->node_mem_map + i;
-			char *addr = page_to_virt(page);
-
-			if (!PageReserved(page))
-				continue;
-			if (addr >= _text &&
-			    addr < _etext)
-				codepages++;
-			else if (addr >= __init_begin &&
-				 addr < __init_end)
-				initpages++;
-			else
-				datapages++;
-		}
-	}
 
 #if !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	/* insert pointer tables allocated so far into the tablelist */
@@ -190,12 +168,7 @@ void __init mem_init(void)
 		init_pointer_table((unsigned long)zero_pgtable);
 #endif
 
-	pr_info("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       totalram_pages << (PAGE_SHIFT-10),
-	       codepages << (PAGE_SHIFT-10),
-	       datapages << (PAGE_SHIFT-10),
-	       initpages << (PAGE_SHIFT-10));
+	mem_init_print_info(NULL);
 	print_memmap();
 }
 
-- 
1.7.9.5

