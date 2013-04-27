Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3D0SLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 14:11:50 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:41457 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752636Ab3D0SLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:11:49 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Apr 2013 14:11:49 EDT
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: add cache way information to cpuinfo
Date: Sat, 27 Apr 2013 21:02:32 +0300
Message-Id: <1367085752-4736-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Motivation for this is to be able to print the way information
properly in print_cpuinfo(), instead of hardcoding it to one.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/include/asm/cpuinfo.h |  2 ++
 arch/openrisc/kernel/setup.c        | 20 +++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/openrisc/include/asm/cpuinfo.h b/arch/openrisc/include/asm/cpuinfo.h
index 917318b..ec10679 100644
--- a/arch/openrisc/include/asm/cpuinfo.h
+++ b/arch/openrisc/include/asm/cpuinfo.h
@@ -24,9 +24,11 @@ struct cpuinfo {
 
 	u32 icache_size;
 	u32 icache_block_size;
+	u32 icache_ways;
 
 	u32 dcache_size;
 	u32 dcache_block_size;
+	u32 dcache_ways;
 };
 
 extern struct cpuinfo cpuinfo;
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index f4d5bed..6b0e2c4 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -129,13 +129,15 @@ static void print_cpuinfo(void)
 	if (upr & SPR_UPR_DCP)
 		printk(KERN_INFO
 		       "-- dcache: %4d bytes total, %2d bytes/line, %d way(s)\n",
-		       cpuinfo.dcache_size, cpuinfo.dcache_block_size, 1);
+		       cpuinfo.dcache_size, cpuinfo.dcache_block_size,
+		       cpuinfo.dcache_ways);
 	else
 		printk(KERN_INFO "-- dcache disabled\n");
 	if (upr & SPR_UPR_ICP)
 		printk(KERN_INFO
 		       "-- icache: %4d bytes total, %2d bytes/line, %d way(s)\n",
-		       cpuinfo.icache_size, cpuinfo.icache_block_size, 1);
+		       cpuinfo.icache_size, cpuinfo.icache_block_size,
+		       cpuinfo.icache_ways);
 	else
 		printk(KERN_INFO "-- icache disabled\n");
 
@@ -167,25 +169,25 @@ void __init setup_cpuinfo(void)
 {
 	struct device_node *cpu;
 	unsigned long iccfgr, dccfgr;
-	unsigned long cache_set_size, cache_ways;
+	unsigned long cache_set_size;
 
 	cpu = of_find_compatible_node(NULL, NULL, "opencores,or1200-rtlsvn481");
 	if (!cpu)
 		panic("No compatible CPU found in device tree...\n");
 
 	iccfgr = mfspr(SPR_ICCFGR);
-	cache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
+	cpuinfo.icache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
 	cache_set_size = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
 	cpuinfo.icache_block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >> 7);
 	cpuinfo.icache_size =
-	    cache_set_size * cache_ways * cpuinfo.icache_block_size;
+	    cache_set_size * cpuinfo.icache_ways * cpuinfo.icache_block_size;
 
 	dccfgr = mfspr(SPR_DCCFGR);
-	cache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
+	cpuinfo.dcache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
 	cache_set_size = 1 << ((dccfgr & SPR_DCCFGR_NCS) >> 3);
 	cpuinfo.dcache_block_size = 16 << ((dccfgr & SPR_DCCFGR_CBS) >> 7);
 	cpuinfo.dcache_size =
-	    cache_set_size * cache_ways * cpuinfo.dcache_block_size;
+	    cache_set_size * cpuinfo.dcache_ways * cpuinfo.dcache_block_size;
 
 	if (of_property_read_u32(cpu, "clock-frequency",
 				 &cpuinfo.clock_frequency)) {
@@ -336,8 +338,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			  "frequency\t: %ld\n"
 			  "dcache size\t: %d bytes\n"
 			  "dcache block size\t: %d bytes\n"
+			  "dcache ways\t: %d\n"
 			  "icache size\t: %d bytes\n"
 			  "icache block size\t: %d bytes\n"
+			  "icache ways\t: %d\n"
 			  "immu\t\t: %d entries, %lu ways\n"
 			  "dmmu\t\t: %d entries, %lu ways\n"
 			  "bogomips\t: %lu.%02lu\n",
@@ -346,8 +350,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			  loops_per_jiffy * HZ,
 			  cpuinfo.dcache_size,
 			  cpuinfo.dcache_block_size,
+			  cpuinfo.dcache_ways,
 			  cpuinfo.icache_size,
 			  cpuinfo.icache_block_size,
+			  cpuinfo.icache_ways,
 			  1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
 			  1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW),
 			  1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
-- 
1.8.1.2

