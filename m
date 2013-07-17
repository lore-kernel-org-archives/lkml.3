Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab3GQRKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:10:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63390 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab3GQRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:10:44 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/3] arm: zynq: slcr: Clean up #defines
Date: Wed, 17 Jul 2013 10:10:14 -0700
Message-Id: <1374081015-31431-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common naming scheme for register offset #defines:
Some of those used a '_OFFSET' suffix to distinguish them from others.
This scheme is used for all register offsets now.

Separate the register offset #defines from others and sort them in
increasing order.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/slcr.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 232c275..44a4ab6 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -19,17 +19,16 @@
 #include <linux/clk/zynq.h>
 #include "common.h"
 
-#define SLCR_UNLOCK_MAGIC		0xDF0D
-#define SLCR_UNLOCK			0x8   /* SCLR unlock register */
-
+/* register offsets */
+#define SLCR_UNLOCK_OFFSET		0x8   /* SCLR unlock register */
 #define SLCR_PS_RST_CTRL_OFFSET		0x200 /* PS Software Reset Control */
+#define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
+#define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
 
+#define SLCR_UNLOCK_MAGIC		0xDF0D
 #define SLCR_A9_CPU_CLKSTOP		0x10
 #define SLCR_A9_CPU_RST			0x1
 
-#define SLCR_A9_CPU_RST_CTRL		0x244 /* CPU Software Reset Control */
-#define SLCR_REBOOT_STATUS		0x258 /* PS Reboot Status */
-
 void __iomem *zynq_slcr_base;
 
 /**
@@ -44,15 +43,15 @@ void zynq_slcr_system_reset(void)
 	 * Note that this seems to require raw i/o
 	 * functions or there's a lockup?
 	 */
-	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK);
+	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK_OFFSET);
 
 	/*
 	 * Clear 0x0F000000 bits of reboot status register to workaround
 	 * the FSBL not loading the bitstream after soft-reboot
 	 * This is a temporary solution until we know more.
 	 */
-	reboot = readl(zynq_slcr_base + SLCR_REBOOT_STATUS);
-	writel(reboot & 0xF0FFFFFF, zynq_slcr_base + SLCR_REBOOT_STATUS);
+	reboot = readl(zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
+	writel(reboot & 0xF0FFFFFF, zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
 	writel(1, zynq_slcr_base + SLCR_PS_RST_CTRL_OFFSET);
 }
 
@@ -64,9 +63,9 @@ void zynq_slcr_cpu_start(int cpu)
 {
 	/* enable CPUn */
 	writel(SLCR_A9_CPU_CLKSTOP << cpu,
-	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL);
+	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
 	/* enable CLK for CPUn */
-	writel(0x0 << cpu, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL);
+	writel(0x0 << cpu, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
 }
 
 /**
@@ -77,7 +76,7 @@ void zynq_slcr_cpu_stop(int cpu)
 {
 	/* stop CLK and reset CPUn */
 	writel((SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu,
-	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL);
+	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
 }
 
 /**
@@ -103,7 +102,7 @@ int __init zynq_slcr_init(void)
 	}
 
 	/* unlock the SLCR so that registers can be changed */
-	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK);
+	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK_OFFSET);
 
 	pr_info("%s mapped to %p\n", np->name, zynq_slcr_base);
 
-- 
1.8.3.3

