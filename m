Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbaABHze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:55:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:7093 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaABHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:55:32 -0500
Message-ID: <52C51B3C.6090200@huawei.com>
Date: Thu, 2 Jan 2014 15:54:36 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, genghui 00204690 <hui.geng@huawei.com>
Subject: ARM: Whether a bank must be fully contained by a section?
References: <20140102074314.GB24225@kernel-host>
In-Reply-To: <20140102074314.GB24225@kernel-host>
X-Forwarded-Message-Id: <20140102074314.GB24225@kernel-host>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

By reading the code of show_mem(), I found that there is an assumption
that the page structs must be continuous for each bank:

	for_each_bank (i, mi) {
		...
		page = pfn_to_page(pfn1);
		end  = pfn_to_page(pfn2 - 1) + 1;
	
		do {
			...
			page++;  <-- pageframe must be continuous
			...
		} while (page < end);
		...
	}

Therefore, a bank must be fully contained in a section in sparse memory
mode, because page frames are allocated section by section (in
sparse_init()).

However, I didn't find other code which enforces this assumption.
Instead, in arm_memory_present (arch/arm/mm/init.c), it seems that a
bank may contain more than one section:

arm_memory_present:
	...
	for_each_memblock(memory, reg)
		memory_present(0, memblock_region_memory_base_pfn(reg),
			       memblock_region_memory_end_pfn(reg));
	...

memory_present:
	...
	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
		...
	}
	...


Therefore, would you please consider the following patch, which removes
the assumption that a bank must be fully contained in one section?


===========================


>From b2c4bb5807c755d92274e11bb00cc548fea62242 Mon Sep 17 00:00:00 2001
From: Wang Nan <wangnan0@huawei.com>
Date: Thu, 2 Jan 2014 13:20:02 +0800
Subject: [PATCH] use pfn_to_page in show_mem

If a bank spans into different sections, the page structures of the bank
may not continous.

This patch uses pfn_to_page to recompute the address of struct page in show_mem
from pfn, makes it to collect correct information even if a bank spans into
different sections.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/mm/init.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 1f7b19a..3078e5a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -97,16 +97,14 @@ void show_mem(unsigned int filter)

 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
+		unsigned int pfn, pfn_end;
+		struct page *page;

-		pfn1 = bank_pfn_start(bank);
-		pfn2 = bank_pfn_end(bank);
-
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
+		pfn = bank_pfn_start(bank);
+		pfn_end = bank_pfn_end(bank);

 		do {
+			page = pfn_to_page(pfn);
 			total++;
 			if (PageReserved(page))
 				reserved++;
@@ -118,8 +116,8 @@ void show_mem(unsigned int filter)
 				free++;
 			else
 				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
+			pfn++;
+		} while (pfn < pfn_end);
 	}

 	printk("%d pages of RAM\n", total);
-- 
1.8.4





