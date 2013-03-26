Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab3CZQAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:00:06 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42565 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab3CZQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:00:00 -0400
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
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3, part4 18/39] mm/h8300: prepare for removing num_physpages and simplify mem_init()
Date: Tue, 26 Mar 2013 23:54:37 +0800
Message-Id: <1364313298-17336-19-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
---
Hi all,
	Sorry for my mistake that my previous patch series has been screwed up.
So I regenerate a third version and also set up a git tree at:
	git://github.com/jiangliu/linux.git mem_init
	Any help to review and test are welcomed!

	Regards!
	Gerry
---
 arch/h8300/mm/init.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 22fd869..0088f3a 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -121,40 +121,22 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek = 0, datak = 0, initk = 0;
-	/* DAVIDM look at setup memory map generically with reserved area */
-	unsigned long tmp;
-	extern unsigned long  _ramend, _ramstart;
-	unsigned long len = &_ramend - &_ramstart;
-	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
-	unsigned long end_mem   = memory_end; /* DAVIDM - this must not include kernel stack at top */
+	unsigned long codesize = _etext - _stext;
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
+	pr_debug("Mem_init: start=%lx, end=%lx\n", memory_start, memory_end);
 #endif
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *) end_mem;
-
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
+	high_memory = (void *) (memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
 
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (__bss_stop - _sdata) >> 10;
-	initk = (__init_begin - __init_end) >> 10;
-
-	tmp = nr_free_pages() << PAGE_SHIFT;
-	printk(KERN_INFO "Memory available: %luk/%luk RAM, %luk/%luk ROM (%dk kernel code, %dk data)\n",
-	       tmp >> 10,
-	       len >> 10,
-	       (rom_length > 0) ? ((rom_length >> 10) - codek) : 0,
-	       rom_length >> 10,
-	       codek,
-	       datak
-	       );
+	mem_init_print_info(NULL);
+	if (rom_length > 0 && rom_length > codesize)
+		pr_info("Memory available: %luK/%luK ROM\n",
+			(rom_length - codesize) >> 10, rom_length >> 10);
 }
 
 
-- 
1.7.9.5

