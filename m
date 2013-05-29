Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966405Ab3E2Op1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50432 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966381Ab3E2OpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:21 -0400
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
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH, v2 02/13] mm/AVR32: prepare for killing free_all_bootmem_node()
Date: Wed, 29 May 2013 22:44:41 +0800
Message-Id: <1369838692-26860-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem() instead.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org
---
 arch/avr32/mm/init.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 0fc04b9..def5391 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -103,23 +103,12 @@ void __init mem_init(void)
 	pg_data_t *pgdat;
 
 	high_memory = NULL;
+	for_each_online_pgdat(pgdat)
+		high_memory = max_t(void *, high_memory,
+				    __va(pgdat_end_pfn(pgdat) << PAGE_SHIFT));
 
-	/* this will put all low memory onto the freelists */
-	for_each_online_pgdat(pgdat) {
-		void *node_high_memory;
-
-		if (pgdat->node_spanned_pages != 0)
-			free_all_bootmem_node(pgdat);
-
-		node_high_memory = (void *)((pgdat->node_start_pfn
-					     + pgdat->node_spanned_pages)
-					    << PAGE_SHIFT);
-		if (node_high_memory > high_memory)
-			high_memory = node_high_memory;
-	}
-
-	max_mapnr = MAP_NR(high_memory);
-
+	set_max_mapnr(MAP_NR(high_memory));
+	free_all_bootmem();
 	mem_init_print_info(NULL);
 }
 
-- 
1.8.1.2

