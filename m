Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966454Ab3E2N7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:59:15 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37559 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966413Ab3E2N7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:59:07 -0400
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
        Mike Frysinger <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH v6, part4 16/41] mm/blackfin: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:34 +0800
Message-Id: <1369835879-23553-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
---
 arch/blackfin/mm/init.c | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index c73d80e..166842d 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -90,43 +90,17 @@ asmlinkage void __init init_pda(void)
 
 void __init mem_init(void)
 {
-	unsigned int codek = 0, datak = 0, initk = 0;
-	unsigned int reservedpages = 0, freepages = 0;
-	unsigned long tmp;
-	unsigned long start_mem = memory_start;
-	unsigned long end_mem = memory_end;
+	char buf[64];
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *)end_mem;
-
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
-	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", num_physpages);
+	high_memory = (void *)(memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
+	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", max_mapnr);
 
 	/* This will put all low memory onto the freelists. */
 	free_all_bootmem();
 
-	reservedpages = 0;
-	for (tmp = ARCH_PFN_OFFSET; tmp < max_mapnr; tmp++)
-		if (PageReserved(pfn_to_page(tmp)))
-			reservedpages++;
-	freepages =  max_mapnr - ARCH_PFN_OFFSET - reservedpages;
-
-	/* do not count in kernel image between _rambase and _ramstart */
-	reservedpages -= (_ramstart - _rambase) >> PAGE_SHIFT;
-#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-	reservedpages += (_ramend - memory_end - DMA_UNCACHED_REGION) >> PAGE_SHIFT;
-#endif
-
-	codek = (_etext - _stext) >> 10;
-	initk = (__init_end - __init_begin) >> 10;
-	datak = ((_ramstart - _rambase) >> 10) - codek - initk;
-
-	printk(KERN_INFO
-	     "Memory available: %luk/%luk RAM, "
-		"(%uk init code, %uk kernel code, %uk data, %uk dma, %uk reserved)\n",
-		(unsigned long) freepages << (PAGE_SHIFT-10), (_ramend - CONFIG_PHY_RAM_BASE_ADDRESS) >> 10,
-		initk, codek, datak, DMA_UNCACHED_REGION >> 10, (reservedpages << (PAGE_SHIFT-10)));
+	snprintf(buf, sizeof(buf) - 1, "%uK DMA", DMA_UNCACHED_REGION >> 10);
+	mem_init_print_info(buf);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.8.1.2

