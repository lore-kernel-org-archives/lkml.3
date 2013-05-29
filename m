Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966546Ab3E2OGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:06:33 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60962 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966252Ab3E2N7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:59:37 -0400
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
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH v6, part4 24/41] mm/m68k: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:42 +0800
Message-Id: <1369835879-23553-25-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org
---
 arch/m68k/mm/init.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 614c60a..397a884 100644
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
 
 #if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
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
1.8.1.2

