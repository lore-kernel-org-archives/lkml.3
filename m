Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaJNTkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:40:12 -0400
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:39168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755357AbaJNTkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:40:09 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <pavel@denx.de>, <arnd@arndb.de>, <s.trumtrar@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 1/2] socfpga: hotplug: put cpu1 in wfi
Date: Tue, 14 Oct 2014 14:33:38 -0500
Message-ID: <1413315219-28885-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
References: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR09CA0021.namprd09.prod.outlook.com (25.160.223.31) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03648EFF89
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(46102003)(80022003)(42186005)(33646002)(87976001)(89996001)(81156004)(106356001)(48376002)(95666004)(122386002)(77096002)(50466002)(229853001)(77156001)(19580395003)(40100003)(97736003)(105586002)(107046002)(19580405001)(50986999)(99396003)(101416001)(85852003)(53416004)(20776003)(64706001)(47776003)(92726001)(86152002)(92566001)(86362001)(93916002)(31966008)(87286001)(62966002)(66066001)(85306004)(76176999)(69596002)(104166001)(21056001)(76482002)(4396001)(50226001)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
since that results in increased power consumption.

Reset CPU1 briefly during CPU1 bootup.

This has been tested for hotplug and suspend/resume and results
in no increased power consumption.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Cc: Pavel Machek <pavel@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
---
v2: no need to flush the caches
    clean up spacing in comments
    replace a register offset with a macro
v3: Use writel, not __raw_writel
---
 arch/arm/mach-socfpga/core.h    |    3 +++
 arch/arm/mach-socfpga/platsmp.c |   19 +++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
index 572b8f7..953a9c0 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -21,6 +21,7 @@
 #define __MACH_CORE_H
 
 #define SOCFPGA_RSTMGR_CTRL	0x04
+#define SOCFPGA_RSTMGR_MODMPURST	0x10
 #define SOCFPGA_RSTMGR_MODPERRST	0x14
 #define SOCFPGA_RSTMGR_BRGMODRST	0x1c
 
@@ -28,6 +29,8 @@
 #define RSTMGR_CTRL_SWCOLDRSTREQ	0x1	/* Cold Reset */
 #define RSTMGR_CTRL_SWWARMRSTREQ	0x2	/* Warm Reset */
 
+#define RSTMGR_MPUMODRST_CPU1		0x2     /* CPU1 Reset */
+
 extern void socfpga_secondary_startup(void);
 extern void __iomem *socfpga_scu_base_addr;
 
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index 5356a72..9166dd4 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -34,17 +34,21 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
 
 	if (cpu1start_addr) {
+		/* This will put CPU #1 into reset. */
+		writel(RSTMGR_MPUMODRST_CPU1,
+		       rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
+
 		memcpy(phys_to_virt(0), &secondary_trampoline, trampoline_size);
 
-		__raw_writel(virt_to_phys(socfpga_secondary_startup),
-			(sys_manager_base_addr + (cpu1start_addr & 0x000000ff)));
+		writel(virt_to_phys(socfpga_secondary_startup),
+		       sys_manager_base_addr + (cpu1start_addr & 0x000000ff));
 
 		flush_cache_all();
 		smp_wmb();
 		outer_clean_range(0, trampoline_size);
 
-		/* This will release CPU #1 out of reset.*/
-		__raw_writel(0, rst_manager_base_addr + 0x10);
+		/* This will release CPU #1 out of reset. */
+		writel(0, rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
 	}
 
 	return 0;
@@ -86,10 +90,9 @@ static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
  */
 static void socfpga_cpu_die(unsigned int cpu)
 {
-	cpu_do_idle();
-
-	/* We should have never returned from idle */
-	panic("cpu %d unexpectedly exit from shutdown\n", cpu);
+	/* Do WFI. If we wake up early, go back into WFI */
+	while (1)
+		cpu_do_idle();
 }
 
 struct smp_operations socfpga_smp_ops __initdata = {
-- 
1.7.9.5

