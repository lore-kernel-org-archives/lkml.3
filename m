Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3AXLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:12:48 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42954 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3AXLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:40 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 63/71] ARC: [Review] Multi-platform image #3: switch to board callback
Date: Thu, 24 Jan 2013 16:36:23 +0530
Message-ID: <1359025589-22277-40-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-platform API is retired and instead callbacks are used

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/irq.h               |    1 -
 arch/arc/include/asm/smp.h               |    5 ---
 arch/arc/kernel/irq.c                    |    2 -
 arch/arc/kernel/setup.c                  |    5 ---
 arch/arc/kernel/smp.c                    |    1 -
 arch/arc/plat-arcfpga/include/plat/irq.h |    2 +
 arch/arc/plat-arcfpga/include/plat/smp.h |    2 +
 arch/arc/plat-arcfpga/irq.c              |    2 +-
 arch/arc/plat-arcfpga/platform.c         |   50 +++++++++++++++++++++++++-----
 arch/arc/plat-arcfpga/smp.c              |    4 +--
 10 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index c91b2e4..f1b318d 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -17,7 +17,6 @@
 #include <asm-generic/irq.h>
 
 extern void __init arc_init_IRQ(void);
-extern void __init plat_init_IRQ(void);
 extern int __init get_hw_config_num_irq(void);
 
 void __cpuinit arc_local_timer_setup(unsigned int cpu);
diff --git a/arch/arc/include/asm/smp.h b/arch/arc/include/asm/smp.h
index f91f194..0cff3a5 100644
--- a/arch/arc/include/asm/smp.h
+++ b/arch/arc/include/asm/smp.h
@@ -46,10 +46,6 @@ extern int smp_ipi_irq_setup(int cpu, int irq);
  * arc_platform_smp_cpuinfo:
  *	returns a string containing info for /proc/cpuinfo
  *
- * arc_platform_smp_init_cpu:
- *	Called from start_kernel_secondary to do any CPU local setup
- *	such as starting a timer, setting up IPI etc
- *
  * arc_platform_smp_wait_to_boot:
  *	Called from early bootup code for non-Master CPUs to "park" them
  *
@@ -64,7 +60,6 @@ extern int smp_ipi_irq_setup(int cpu, int irq);
  *	Takes @cpu which got IPI at @irq to do any IPI clearing
  */
 extern const char *arc_platform_smp_cpuinfo(void);
-extern void arc_platform_smp_init_cpu(void);
 extern void arc_platform_smp_wait_to_boot(int cpu);
 extern void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc);
 extern void arc_platform_ipi_send(const struct cpumask *callmap);
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 1198168..551c10d 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -124,7 +124,6 @@ void __init init_onchip_IRQ(void)
 void __init init_IRQ(void)
 {
 	init_onchip_IRQ();
-	plat_init_IRQ();
 
 	/* Any external intc can be setup here */
 	if (machine_desc->init_irq)
@@ -132,7 +131,6 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_SMP
 	/* Master CPU can initialize it's side of IPI */
-	arc_platform_smp_init_cpu();
 	if (machine_desc->init_smp)
 		machine_desc->init_smp(smp_processor_id());
 #endif
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 20273b8..e591c6a 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -319,10 +319,6 @@ void __init setup_processor(void)
 	arc_chk_fpu();
 }
 
-void __init __attribute__((weak)) arc_platform_early_init(void)
-{
-}
-
 void __init setup_arch(char **cmdline_p)
 {
 #ifdef CONFIG_CMDLINE_UBOOT
@@ -347,7 +343,6 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	/* Platform/board specific: e.g. early console registration */
-	arc_platform_early_init();
 	if (machine_desc->init_early)
 		machine_desc->init_early();
 
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index ea15f07..8ee010f 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -127,7 +127,6 @@ void __cpuinit start_kernel_secondary(void)
 
 	pr_info("## CPU%u LIVE ##: Executing Code...\n", cpu);
 
-	arc_platform_smp_init_cpu();
 	if (machine_desc->init_smp)
 		machine_desc->init_smp(smp_processor_id());
 
diff --git a/arch/arc/plat-arcfpga/include/plat/irq.h b/arch/arc/plat-arcfpga/include/plat/irq.h
index 255b90e..6515df2 100644
--- a/arch/arc/plat-arcfpga/include/plat/irq.h
+++ b/arch/arc/plat-arcfpga/include/plat/irq.h
@@ -32,4 +32,6 @@
 #define IDU_INTERRUPT_0 16
 #endif
 
+extern void __init plat_fpga_init_IRQ(void);
+
 #endif
diff --git a/arch/arc/plat-arcfpga/include/plat/smp.h b/arch/arc/plat-arcfpga/include/plat/smp.h
index 8c5e46c..27822ac 100644
--- a/arch/arc/plat-arcfpga/include/plat/smp.h
+++ b/arch/arc/plat-arcfpga/include/plat/smp.h
@@ -110,6 +110,8 @@ struct idu_irq_status {
 extern void idu_irq_set_tgtcpu(uint8_t irq, uint32_t mask);
 extern void idu_irq_set_mode(uint8_t irq, uint8_t dest_mode, uint8_t trig_mode);
 
+extern void iss_model_init_smp(unsigned int cpu);
+
 #endif	/* CONFIG_SMP */
 
 #endif
diff --git a/arch/arc/plat-arcfpga/irq.c b/arch/arc/plat-arcfpga/irq.c
index 590edd1..0ea43c2 100644
--- a/arch/arc/plat-arcfpga/irq.c
+++ b/arch/arc/plat-arcfpga/irq.c
@@ -11,7 +11,7 @@
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 
-void __init plat_init_IRQ(void)
+void __init plat_fpga_init_IRQ(void)
 {
 	/*
 	 * SMP Hack because UART IRQ hardwired to cpu0 (boot-cpu) but if the
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index b7f63e3..ac85d69 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -18,7 +18,9 @@
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/clk.h>
+#include <asm/mach_desc.h>
 #include <plat/memmap.h>
+#include <plat/smp.h>
 
 /*-----------------------BVCI Latency Unit -----------------------------*/
 
@@ -153,10 +155,7 @@ static void arc_fpga_serial_init(void)
 #endif
 }
 
-/*
- * Early Platform Initialization called from setup_arch()
- */
-void __init arc_platform_early_init(void)
+static void __init plat_fpga_early_init(void)
 {
 	pr_info("[plat-arcfpga]: registering early dev resources\n");
 
@@ -172,7 +171,7 @@ static struct of_dev_auxdata plat_auxdata_lookup[] __initdata = {
 	{}
 };
 
-int __init fpga_plat_init(void)
+static void __init plat_fpga_populate_dev(void)
 {
 	pr_info("[plat-arcfpga]: registering device resources\n");
 
@@ -182,7 +181,42 @@ int __init fpga_plat_init(void)
 	 */
 	of_platform_populate(NULL, of_default_bus_match_table,
 			     plat_auxdata_lookup, NULL);
-
-	return 0;
 }
-arch_initcall(fpga_plat_init);
+
+/*----------------------- Machine Descriptions ------------------------------
+ *
+ * Machine description is simply a set of platform/board specific callbacks
+ * This is not directly related to DeviceTree based dynamic device creation,
+ * however as part of early device tree scan, we also select the right
+ * callback set, by matching the DT compatible name.
+ */
+
+static const char *aa4_compat[] __initdata = {
+	"snps,arc-angel4",
+	NULL,
+};
+
+MACHINE_START(ANGEL4, "angel4")
+	.dt_compat	= aa4_compat,
+	.init_early	= plat_fpga_early_init,
+	.init_machine	= plat_fpga_populate_dev,
+	.init_irq	= plat_fpga_init_IRQ,
+#ifdef CONFIG_SMP
+	.init_smp	= iss_model_init_smp,
+#endif
+MACHINE_END
+
+static const char *ml509_compat[] __initdata = {
+	"snps,arc-ml509",
+	NULL,
+};
+
+MACHINE_START(ML509, "ml509")
+	.dt_compat	= ml509_compat,
+	.init_early	= plat_fpga_early_init,
+	.init_machine	= plat_fpga_populate_dev,
+	.init_irq	= plat_fpga_init_IRQ,
+#ifdef CONFIG_SMP
+	.init_smp	= iss_model_init_smp,
+#endif
+MACHINE_END
diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
index a95fcdb..fec1879 100644
--- a/arch/arc/plat-arcfpga/smp.c
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -63,10 +63,8 @@ void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc)
  * -Master      : init_IRQ()
  * -Other(s)    : start_kernel_secondary()
  */
-void arc_platform_smp_init_cpu(void)
+void iss_model_init_smp(unsigned int cpu)
 {
-	int cpu = smp_processor_id();
-
 	/* Check if CPU is configured for more than 16 interrupts */
 	if (NR_IRQS <= 16 || get_hw_config_num_irq() <= 16)
 		panic("[arcfpga] IRQ system can't support IDU IPI\n");
-- 
1.7.4.1

