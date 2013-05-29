Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966416Ab3E2N66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:58:58 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41353 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966394Ab3E2N6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:53 -0400
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
        James Hogan <james.hogan@imgtec.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v6, part4 12/41] mm/ARC: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:30 +0800
Message-Id: <1369835879-23553-13-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>   # for arch/arc
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/arc/mm/init.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index c668a60..a08ce71 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -74,7 +74,7 @@ void __init setup_arch_memory(void)
 	/* Last usable page of low mem (no HIGHMEM yet for ARC port) */
 	max_low_pfn = max_pfn = PFN_DOWN(end_mem);
 
-	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
+	max_mapnr = max_low_pfn - min_low_pfn;
 
 	/*------------- reserve kernel image -----------------------*/
 	memblock_reserve(CONFIG_LINUX_LINK_BASE,
@@ -84,7 +84,7 @@ void __init setup_arch_memory(void)
 
 	/*-------------- node setup --------------------------------*/
 	memset(zones_size, 0, sizeof(zones_size));
-	zones_size[ZONE_NORMAL] = num_physpages;
+	zones_size[ZONE_NORMAL] = max_low_pfn - min_low_pfn;
 
 	/*
 	 * We can't use the helper free_area_init(zones[]) because it uses
@@ -106,39 +106,9 @@ void __init setup_arch_memory(void)
  */
 void __init mem_init(void)
 {
-	int codesize, datasize, initsize, reserved_pages, free_pages;
-	int tmp;
-
 	high_memory = (void *)(CONFIG_LINUX_LINK_BASE + arc_mem_sz);
-
 	free_all_bootmem();
-
-	/* count all reserved pages [kernel code/data/mem_map..] */
-	reserved_pages = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++)
-		if (PageReserved(mem_map + tmp))
-			reserved_pages++;
-
-	/* XXX: nr_free_pages() is equivalent */
-	free_pages = max_mapnr - reserved_pages;
-
-	/*
-	 * For the purpose of display below, split the "reserve mem"
-	 * kernel code/data is already shown explicitly,
-	 * Show any other reservations (mem_map[ ] et al)
-	 */
-	reserved_pages -= (((unsigned int)_end - CONFIG_LINUX_LINK_BASE) >>
-								PAGE_SHIFT);
-
-	codesize = _etext - _text;
-	datasize = _end - _etext;
-	initsize = __init_end - __init_begin;
-
-	pr_info("Memory Available: %dM / %ldM (%dK code, %dK data, %dK init, %dK reserv)\n",
-		PAGES_TO_MB(free_pages),
-		TO_MB(arc_mem_sz),
-		TO_KB(codesize), TO_KB(datasize), TO_KB(initsize),
-		PAGES_TO_KB(reserved_pages));
+	mem_init_print_info(NULL);
 }
 
 /*
-- 
1.8.1.2

