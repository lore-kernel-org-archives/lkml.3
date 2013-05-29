Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966641Ab3E2OAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:00:30 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42423 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966498Ab3E2OAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:00:25 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH v6, part4 38/41] mm/unicore32: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:56 +0800
Message-Id: <1369835879-23553-39-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/unicore32/mm/init.c | 49 ++----------------------------------------------
 1 file changed, 2 insertions(+), 47 deletions(-)

diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index 7d1356c..ae6bc03 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -383,10 +383,6 @@ static void __init free_unused_memmap(struct meminfo *mi)
  */
 void __init mem_init(void)
 {
-	unsigned long reserved_pages, free_pages;
-	struct memblock_region *reg;
-	int i;
-
 	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
 
 	free_unused_memmap(&meminfo);
@@ -394,48 +390,7 @@ void __init mem_init(void)
 	/* this will put all unused low memory onto the freelists */
 	free_all_bootmem();
 
-	reserved_pages = free_pages = 0;
-
-	for_each_bank(i, &meminfo) {
-		struct membank *bank = &meminfo.bank[i];
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
-
-		pfn1 = bank_pfn_start(bank);
-		pfn2 = bank_pfn_end(bank);
-
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
-
-		do {
-			if (PageReserved(page))
-				reserved_pages++;
-			else if (!page_count(page))
-				free_pages++;
-			page++;
-		} while (page < end);
-	}
-
-	/*
-	 * Since our memory may not be contiguous, calculate the
-	 * real number of pages we have in this system
-	 */
-	printk(KERN_INFO "Memory:");
-	num_physpages = 0;
-	for_each_memblock(memory, reg) {
-		unsigned long pages = memblock_region_memory_end_pfn(reg) -
-			memblock_region_memory_base_pfn(reg);
-		num_physpages += pages;
-		printk(" %ldMB", pages >> (20 - PAGE_SHIFT));
-	}
-	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
-
-	printk(KERN_NOTICE "Memory: %luk/%luk available, %luk reserved, %luK highmem\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		free_pages << (PAGE_SHIFT-10),
-		reserved_pages << (PAGE_SHIFT-10),
-		totalhigh_pages << (PAGE_SHIFT-10));
-
+	mem_init_print_info(NULL);
 	printk(KERN_NOTICE "Virtual kernel memory layout:\n"
 		"    vector  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
@@ -464,7 +419,7 @@ void __init mem_init(void)
 	BUILD_BUG_ON(TASK_SIZE				> MODULES_VADDR);
 	BUG_ON(TASK_SIZE				> MODULES_VADDR);
 
-	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
+	if (PAGE_SIZE >= 16384 && get_num_physpages() <= 128) {
 		/*
 		 * On a machine this small we won't get
 		 * anywhere without overcommit, so turn
-- 
1.8.1.2

