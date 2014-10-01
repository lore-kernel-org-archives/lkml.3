Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJAToi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:44:38 -0400
Received: from mail-bl2on0059.outbound.protection.outlook.com ([65.55.169.59]:33520
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbaJAToh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:44:37 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 1/2] socfpga: hotplug: put cpu1 in wfi
Date: Wed, 1 Oct 2014 14:38:23 -0500
Message-ID: <1412192304-1209-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412192304-1209-1-git-send-email-atull@opensource.altera.com>
References: <1412192304-1209-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0053.namprd05.prod.outlook.com (10.141.20.23) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(77096002)(105586002)(81156004)(85306004)(106356001)(102836001)(33646002)(229853001)(107046002)(48376002)(99396003)(50466002)(77156001)(53416004)(10300001)(42186005)(95666004)(97736003)(20776003)(50226001)(47776003)(64706001)(50986999)(4396001)(86152002)(92566001)(92726001)(21056001)(62966002)(120916001)(93916002)(76176999)(86362001)(31966008)(88136002)(19580405001)(87286001)(85852003)(89996001)(19580395003)(76482002)(66066001)(69596002)(101416001)(87976001)(80022003)(104166001)(46102003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

v2: no need to flush the caches
    clean up spacing in comments
    replace a register offset with a macro
---
 arch/arm/mach-socfpga/core.h    |    3 +++
 arch/arm/mach-socfpga/platsmp.c |   16 ++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

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
index 5356a72..97907dd 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
 
 	if (cpu1start_addr) {
+		/* This will put CPU #1 into reset. */
+		__raw_writel(RSTMGR_MPUMODRST_CPU1,
+			     rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
+
 		memcpy(phys_to_virt(0), &secondary_trampoline, trampoline_size);
 
 		__raw_writel(virt_to_phys(socfpga_secondary_startup),
@@ -43,8 +47,9 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		smp_wmb();
 		outer_clean_range(0, trampoline_size);
 
-		/* This will release CPU #1 out of reset.*/
-		__raw_writel(0, rst_manager_base_addr + 0x10);
+		/* This will release CPU #1 out of reset. */
+		__raw_writel(0,
+			     rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
 	}
 
 	return 0;
@@ -86,10 +91,9 @@ static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
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

