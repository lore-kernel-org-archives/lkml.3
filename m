Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaFLKd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:33:58 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:51872 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbaFLKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:33:54 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 8/9] ARC: [arcfpga] RIP early uart platform device stuff
Date: Thu, 12 Jun 2014 16:01:38 +0530
Message-ID: <1402569099-9900-9-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ARC uart driver switching to generic earlycon, we no longer need
this ugliness. You won't be missed.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/plat-arcfpga/Kconfig    |  7 ---
 arch/arc/plat-arcfpga/platform.c | 97 +---------------------------------------
 2 files changed, 2 insertions(+), 102 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index e27bb5cc3c1e..b9f34cf55acf 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -41,11 +41,4 @@ config ISS_SMP_EXTN
 	  -XTL (To enable CPU start/stop/set-PC for another CPU)
 	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
 
-config ARC_SERIAL_BAUD
-	int "UART Baud rate"
-	default "115200"
-	depends on SERIAL_ARC || SERIAL_ARC_CONSOLE
-	help
-	  Baud rate for the ARC UART
-
 endif
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 61c7e5997387..b8d0d456627f 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -22,115 +22,22 @@
 #include <plat/smp.h>
 #include <plat/irq.h>
 
-/*----------------------- Platform Devices -----------------------------*/
-
-#if IS_ENABLED(CONFIG_SERIAL_ARC)
-static unsigned long arc_uart_info[] = {
-	0,	/* uart->is_emulated (runtime @running_on_hw) */
-	0,	/* uart->port.uartclk */
-	0,	/* uart->baud */
-	0
-};
-
-#if defined(CONFIG_SERIAL_ARC_CONSOLE)
-/*
- * static platform data - but only for early serial
- * TBD: derive this from a special DT node
- */
-static struct resource arc_uart0_res[] = {
-	{
-		.start = UART0_BASE,
-		.end   = UART0_BASE + 0xFF,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = UART0_IRQ,
-		.end   = UART0_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device arc_uart0_dev = {
-	.name = "arc-uart",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(arc_uart0_res),
-	.resource = arc_uart0_res,
-	.dev = {
-		.platform_data = &arc_uart_info,
-	},
-};
-
-static struct platform_device *fpga_early_devs[] __initdata = {
-	&arc_uart0_dev,
-};
-#endif	/* CONFIG_SERIAL_ARC_CONSOLE */
-
-static void arc_fpga_serial_init(void)
-{
-	/* To let driver workaround ISS bug: baudh Reg can't be set to 0 */
-	arc_uart_info[0] = !running_on_hw;
-
-	arc_uart_info[1] = arc_get_core_freq();
-
-	arc_uart_info[2] = CONFIG_ARC_SERIAL_BAUD;
-
-#if defined(CONFIG_SERIAL_ARC_CONSOLE)
-	early_platform_add_devices(fpga_early_devs,
-				   ARRAY_SIZE(fpga_early_devs));
-
-	/*
-	 * ARC console driver registers (build time) as an early platform driver
-	 * of class "earlyprintk". However it needs explicit cmdline toggle
-	 * "earlyprintk=ttyARC0" to be successfuly runtime registered.
-	 * Otherwise the early probe below fails to find the driver
-	 */
-	early_platform_driver_probe("earlyprintk", 1, 0);
-
-	/*
-	 * This is to make sure that arc uart would be preferred console
-	 * despite one/more of following:
-	 *   -command line lacked "console=ttyARC0" or
-	 *   -CONFIG_VT_CONSOLE was enabled (for no reason whatsoever)
-	 * Note that this needs to be done after above early console is reg,
-	 * otherwise the early console never gets a chance to run.
-	 */
-	add_preferred_console("ttyARC", 0, "115200");
-#endif	/* CONFIG_SERIAL_ARC_CONSOLE */
-}
-#else	/* !IS_ENABLED(CONFIG_SERIAL_ARC) */
-static void arc_fpga_serial_init(void)
-{
-}
-#endif
-
 static void __init plat_fpga_early_init(void)
 {
 	pr_info("[plat-arcfpga]: registering early dev resources\n");
 
-	arc_fpga_serial_init();
-
 #ifdef CONFIG_ISS_SMP_EXTN
 	iss_model_init_early_smp();
 #endif
 }
 
-static struct of_dev_auxdata plat_auxdata_lookup[] __initdata = {
-#if IS_ENABLED(CONFIG_SERIAL_ARC)
-	OF_DEV_AUXDATA("snps,arc-uart", UART0_BASE, "arc-uart", arc_uart_info),
-#endif
-	{}
-};
-
 static void __init plat_fpga_populate_dev(void)
 {
-	pr_info("[plat-arcfpga]: registering device resources\n");
-
 	/*
 	 * Traverses flattened DeviceTree - registering platform devices
-	 * complete with their resources
+	 * (if any) complete with their resources
 	 */
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     plat_auxdata_lookup, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
 /*----------------------- Machine Descriptions ------------------------------
-- 
1.8.3.2

