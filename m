Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaIXUeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:34:20 -0400
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:5698
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751563AbaIXUdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:33:50 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
Date: Wed, 24 Sep 2014 15:27:28 -0500
Message-ID: <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA036.namprd06.prod.outlook.com (10.141.250.154) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(74662003)(107046002)(53416004)(106356001)(46102003)(50466002)(4396001)(50226001)(92726001)(93916002)(79102003)(90102001)(92566001)(64706001)(42186005)(229853001)(86152002)(87286001)(10300001)(105586002)(88136002)(66066001)(50986999)(62966002)(33646002)(86362001)(104166001)(89996001)(85852003)(19580405001)(83322001)(21056001)(69596002)(80022003)(20776003)(81542003)(76176999)(77156001)(120916001)(19580395003)(101416001)(74502003)(83072002)(77982003)(81156004)(81342003)(48376002)(76482002)(95666004)(87976001)(85306004)(47776003)(77096002)(99396003)(102836001)(31966008)(97736003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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
---
 arch/arm/mach-socfpga/core.h    |    2 ++
 arch/arm/mach-socfpga/platsmp.c |   12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
index 572b8f7..c4a0929 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -28,6 +28,8 @@
 #define RSTMGR_CTRL_SWCOLDRSTREQ	0x1	/* Cold Reset */
 #define RSTMGR_CTRL_SWWARMRSTREQ	0x2	/* Warm Reset */
 
+#define RSTMGR_MPUMODRST_CPU1		0x2     /*CPU1 Reset*/
+
 extern void socfpga_secondary_startup(void);
 extern void __iomem *socfpga_scu_base_addr;
 
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index 5356a72..1d5f8ad 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
 
 	if (cpu1start_addr) {
+		/* This will put CPU #1 into reset.*/
+		__raw_writel(RSTMGR_MPUMODRST_CPU1,
+			     rst_manager_base_addr + 0x10);
+
 		memcpy(phys_to_virt(0), &secondary_trampoline, trampoline_size);
 
 		__raw_writel(virt_to_phys(socfpga_secondary_startup),
@@ -86,10 +90,12 @@ static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
  */
 static void socfpga_cpu_die(unsigned int cpu)
 {
-	cpu_do_idle();
+	/* Flush the L1 data cache. */
+	flush_cache_all();
 
-	/* We should have never returned from idle */
-	panic("cpu %d unexpectedly exit from shutdown\n", cpu);
+	/* Do WFI. If we wake up early, go back into WFI */
+	while (1)
+		cpu_do_idle();
 }
 
 struct smp_operations socfpga_smp_ops __initdata = {
-- 
1.7.9.5

