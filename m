Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3ARMd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:33:58 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58887 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3ARMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:33:56 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 59/76] ARC: [plat-arfpga] BVCI Latency Unit setup
Date: Fri, 18 Jan 2013 17:55:13 +0530
Message-ID: <1358511930-7424-60-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/plat-arcfpga/Kconfig    |   32 +++++++++++++++++++++
 arch/arc/plat-arcfpga/platform.c |   56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 8a1334c..86b7377 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -43,4 +43,36 @@ config ARC_SERIAL_BAUD
 	help
 	  Baud rate for the ARC UART
 
+menuconfig ARC_HAS_BVCI_LAT_UNIT
+	bool "BVCI Bus Latency Unit"
+	depends on ARC_BOARD_ML509 || ARC_BOARD_ANGEL4
+	help
+	  IP to add artifical latency to BVCI Bus Based FPGA builds.
+	  The default latency (even worst case) for FPGA is non-realistic
+	  (~10 SDRAM, ~5 SSRAM).
+
+config BVCI_LAT_UNITS
+	hex "Latency Unit(s) Bitmap"
+	default "0x0"
+	depends on ARC_HAS_BVCI_LAT_UNIT
+	help
+	  There are multiple Latency Units corresponding to the many
+	  interfaces of the system bus arbiter (both CPU side as well as
+	  the peripheral side).
+	  To add latency to ALL memory transaction, choose Unit 0, otherwise
+	  for finer grainer - interface wise latency, specify a bitmap (1 bit
+	  per unit) of all units. e.g. 1,2,12 will be 0x1003
+
+	  Unit  0 - System Arb and Mem Controller
+	  Unit  1 - I$ and System Bus
+	  Unit  2 - D$ and System Bus
+	  ..
+	  Unit 12 - IDE Disk controller and System Bus
+
+config BVCI_LAT_CYCLES
+	int "Latency Value in cycles"
+	range 0 63
+	default "30"
+	depends on ARC_HAS_BVCI_LAT_UNIT
+
 endif
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index d98028c..c07636e 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
 #include <linux/console.h>
 #include <linux/of_platform.h>
 #include <asm/setup.h>
@@ -19,6 +20,59 @@
 #include <asm/clk.h>
 #include <plat/memmap.h>
 
+/*-----------------------BVCI Latency Unit -----------------------------*/
+
+#ifdef CONFIG_ARC_HAS_BVCI_LAT_UNIT
+
+int lat_cycles = CONFIG_BVCI_LAT_CYCLES;
+
+/* BVCI Bus Profiler: Latency Unit */
+static void __init setup_bvci_lat_unit(void)
+{
+#define MAX_BVCI_UNITS 12
+
+	unsigned int i;
+	unsigned int *base = (unsigned int *)BVCI_LAT_UNIT_BASE;
+	const unsigned long units_req = CONFIG_BVCI_LAT_UNITS;
+	const unsigned int REG_UNIT = 21;
+	const unsigned int REG_VAL = 22;
+
+	/*
+	 * There are multiple Latency Units corresponding to the many
+	 * interfaces of the system bus arbiter (both CPU side as well as
+	 * the peripheral side).
+	 *
+	 * Unit  0 - System Arb and Mem Controller - adds latency to all
+	 *	    memory trasactions
+	 * Unit  1 - I$ and System Bus
+	 * Unit  2 - D$ and System Bus
+	 * ..
+	 * Unit 12 - IDE Disk controller and System Bus
+	 *
+	 * The programmers model requires writing to lat_unit reg first
+	 * and then the latency value (cycles) to lat_value reg
+	 */
+
+	if (CONFIG_BVCI_LAT_UNITS == 0) {
+		writel(0, base + REG_UNIT);
+		writel(lat_cycles, base + REG_VAL);
+		pr_info("BVCI Latency for all Memory Transactions %d cycles\n",
+			lat_cycles);
+	} else {
+		for_each_set_bit(i, &units_req, MAX_BVCI_UNITS) {
+			writel(i + 1, base + REG_UNIT); /* loop is 0 based */
+			writel(lat_cycles, base + REG_VAL);
+			pr_info("BVCI Latency for Unit[%d] = %d cycles\n",
+				(i + 1), lat_cycles);
+		}
+	}
+}
+#else
+static void __init setup_bvci_lat_unit(void)
+{
+}
+#endif
+
 /*----------------------- Platform Devices -----------------------------*/
 
 #if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
@@ -115,6 +169,8 @@ void __init arc_platform_early_init(void)
 {
 	pr_info("[plat-arcfpga]: registering early dev resources\n");
 
+	setup_bvci_lat_unit();
+
 	arc_fpga_serial_init();
 }
 
-- 
1.7.4.1

