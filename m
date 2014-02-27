Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaB0V4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:56:36 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32841 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaB0V4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:56:34 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="16754901"
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <matt.porter@linaro.org>
CC: Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 2/3] ARM: bcm21664: Add board support.
Date: Thu, 27 Feb 2014 13:56:05 -0800
Message-ID: <1393538166-22868-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
References: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Broadcom BCM21664 mobile SoC. It has two Cortex-A9
cores like the BCM281xx family of chips. BCM21664 and BCM281xx share
many IP blocks in addition to the ARM cores.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/Makefile         |    6 ++-
 arch/arm/mach-bcm/board_bcm21664.c |   78 ++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-bcm/board_bcm21664.c

diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index c2ccd5a..0e2e52e 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2012-2013 Broadcom Corporation
+# Copyright (C) 2012-2014 Broadcom Corporation
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -10,6 +10,8 @@
 # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 
-obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
+obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o board_bcm21664.o \
+				bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
+
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/mach-bcm/board_bcm21664.c b/arch/arm/mach-bcm/board_bcm21664.c
new file mode 100644
index 0000000..d3ef7e5
--- /dev/null
+++ b/arch/arm/mach-bcm/board_bcm21664.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clocksource.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+
+#include "bcm_kona_smc.h"
+#include "kona.h"
+
+#define RSTMGR_DT_STRING		"brcm,bcm21664-resetmgr"
+
+#define RSTMGR_REG_WR_ACCESS_OFFSET	0
+#define RSTMGR_REG_CHIP_SOFT_RST_OFFSET	4
+
+#define RSTMGR_WR_PASSWORD		0xa5a5
+#define RSTMGR_WR_PASSWORD_SHIFT	8
+#define RSTMGR_WR_ACCESS_ENABLE		1
+
+static void bcm21644_restart(enum reboot_mode mode, const char *cmd)
+{
+	void __iomem *base;
+	struct device_node *resetmgr;
+
+	resetmgr = of_find_compatible_node(NULL, NULL, RSTMGR_DT_STRING);
+	if (!resetmgr) {
+		pr_emerg("Couldn't find " RSTMGR_DT_STRING "\n");
+		return;
+	}
+	base = of_iomap(resetmgr, 0);
+	if (!base) {
+		pr_emerg("Couldn't map " RSTMGR_DT_STRING "\n");
+		return;
+	}
+
+	/*
+	 * A soft reset is triggered by writing a 0 to bit 0 of the soft reset
+	 * register. To write to that register we must first write the password
+	 * and the enable bit in the write access enable register.
+	 */
+	writel((RSTMGR_WR_PASSWORD << RSTMGR_WR_PASSWORD_SHIFT) |
+		RSTMGR_WR_ACCESS_ENABLE,
+		base + RSTMGR_REG_WR_ACCESS_OFFSET);
+	writel(0, base + RSTMGR_REG_CHIP_SOFT_RST_OFFSET);
+
+	/* Wait for reset */
+	while (1);
+}
+
+static void __init bcm21644_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL,
+		&platform_bus);
+	kona_l2_cache_init();
+}
+
+static const char * const bcm21664_dt_compat[] = {
+	"brcm,bcm21664",
+	NULL,
+};
+
+DT_MACHINE_START(BCM21664_DT, "BCM21664 Broadcom Application Processor")
+	.init_machine = bcm21644_init,
+	.restart = bcm21644_restart,
+	.dt_compat = bcm21664_dt_compat,
+MACHINE_END
-- 
1.7.9.5

