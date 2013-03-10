Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3CJGbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:31:21 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44774 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3CJGbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:31:17 -0500
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
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2, part1 11/29] mm/m32r: use common help functions to free reserved pages
Date: Sun, 10 Mar 2013 14:26:54 +0800
Message-Id: <1362896833-21104-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/mm/init.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index 78b660e..ab4cbce 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -28,10 +28,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/tlb.h>
-
-/* References to section boundaries */
-extern char _text, _etext, _edata;
-extern char __init_begin, __init_end;
+#include <asm/sections.h>
 
 pgd_t swapper_pg_dir[1024];
 
@@ -184,17 +181,7 @@ void __init mem_init(void)
  *======================================================================*/
 void free_initmem(void)
 {
-	unsigned long addr;
-
-	addr = (unsigned long)(&__init_begin);
-	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk (KERN_INFO "Freeing unused kernel memory: %dk freed\n", \
-	  (int)(&__init_end - &__init_begin) >> 10);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -204,13 +191,6 @@ void free_initmem(void)
  *======================================================================*/
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	unsigned long p;
-	for (p = start; p < end; p += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(p));
-		init_page_count(virt_to_page(p));
-		free_page(p);
-		totalram_pages++;
-	}
-	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
-- 
1.7.9.5

