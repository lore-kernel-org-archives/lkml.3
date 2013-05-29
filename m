Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966433Ab3E2N7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:59:04 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51040 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966413Ab3E2N65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:57 -0400
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
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6, part4 13/41] mm/ARM: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:31 +0800
Message-Id: <1369835879-23553-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mm/init.c | 47 ++---------------------------------------------
 1 file changed, 2 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 4ca7c1a..59c18b8 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -582,9 +582,6 @@ static void __init free_highpages(void)
  */
 void __init mem_init(void)
 {
-	unsigned long reserved_pages, free_pages;
-	struct memblock_region *reg;
-	int i;
 #ifdef CONFIG_HAVE_TCM
 	/* These pointers are filled in on TCM detection */
 	extern u32 dtcm_end;
@@ -604,47 +601,7 @@ void __init mem_init(void)
 
 	free_highpages();
 
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
+	mem_init_print_info(NULL);
 
 #define MLK(b, t) b, t, ((t) - (b)) >> 10
 #define MLM(b, t) b, t, ((t) - (b)) >> 20
@@ -710,7 +667,7 @@ void __init mem_init(void)
 	BUG_ON(PKMAP_BASE + LAST_PKMAP * PAGE_SIZE	> PAGE_OFFSET);
 #endif
 
-	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
+	if (PAGE_SIZE >= 16384 && get_num_physpages() <= 128) {
 		extern int sysctl_overcommit_memory;
 		/*
 		 * On a machine this small we won't get
-- 
1.8.1.2

