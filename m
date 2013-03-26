Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965665Ab3CZP7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:59:23 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:63964 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab3CZP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:59:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH v3, part4 13/39] mm/AVR32: prepare for removing num_physpages and simplify mem_init()
Date: Tue, 26 Mar 2013 23:54:32 +0800
Message-Id: <1364313298-17336-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org (open list)
---
Hi all,
	Sorry for my mistake that my previous patch series has been screwed up.
So I regenerate a third version and also set up a git tree at:
	git://github.com/jiangliu/linux.git mem_init
	Any help to review and test are welcomed!

	Regards!
	Gerry
---
 arch/avr32/mm/init.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 7e8d55a..c1706a0 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -100,26 +100,16 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	int nid, i;
+	pg_data_t *pgdat;
 
-	reservedpages = 0;
 	high_memory = NULL;
 
 	/* this will put all low memory onto the freelists */
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
-		unsigned long node_pages = 0;
+	for_each_online_pgdat(pgdat) {
 		void *node_high_memory;
 
-		num_physpages += pgdat->node_present_pages;
-
 		if (pgdat->node_spanned_pages != 0)
-			node_pages = free_all_bootmem_node(pgdat);
-
-		for (i = 0; i < node_pages; i++)
-			if (PageReserved(pgdat->node_mem_map + i))
-				reservedpages++;
+			free_all_bootmem_node(pgdat);
 
 		node_high_memory = (void *)((pgdat->node_start_pfn
 					     + pgdat->node_spanned_pages)
@@ -130,18 +120,7 @@ void __init mem_init(void)
 
 	max_mapnr = MAP_NR(high_memory);
 
-	codesize = (unsigned long)_etext - (unsigned long)_text;
-	datasize = (unsigned long)_edata - (unsigned long)_data;
-	initsize = (unsigned long)__init_end - (unsigned long)__init_begin;
-
-	printk ("Memory: %luk/%luk available (%dk kernel code, "
-		"%dk reserved, %dk data, %dk init)\n",
-		nr_free_pages() << (PAGE_SHIFT - 10),
-		totalram_pages << (PAGE_SHIFT - 10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT - 10),
-		datasize >> 10,
-		initsize >> 10);
+	mem_init_print_info(NULL);
 }
 
 void free_initmem(void)
-- 
1.7.9.5

