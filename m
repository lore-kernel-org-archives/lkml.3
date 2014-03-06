Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaCFJ04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:26:56 -0500
Received: from smtp1.macau.ctm.net ([202.175.3.59]:47703 "EHLO
	smtp1.macau.ctm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaCFJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:18:42 -0500
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
Cc: Device Tree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH v2 2/3] ARM: bcm21664: Add board support.
Date: Thu,  6 Mar 2014 17:18:13 +0800
Message-Id: <1394097494-29899-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394097494-29899-1-git-send-email-markus.mayer@linaro.org>
References: <1394097494-29899-1-git-send-email-markus.mayer@linaro.org>
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSS-7.1.0.1392-7.5.0.1017-20548.005
X-TM-AS-Result: No--17.900-7.0-31-10
X-imss-scan-details: No--17.900-7.0-31-10;No--17.900-7.0-31-10
X-TMASE-MatchedRID: 9nkzMtsPLI44Yc1OODXsU37siEtWY367f2g6KJZtxl0BOMBsCslSyJkC
	erFMaabiCM3xCXbfIgLzbylrK86ZaulVfYNOXGqmHOx1Vder/0uWWNQZZplrArt4BAaULwAVeR3
	t+BJt1Fk6FnBjnFmaspaZO/nIoe7vBrU1duOq6zSiI3xhOar5y+gVdBvdmCRRRi9INZ1ZpGHCe/
	czMaGEHuXj/YyU9oG67qEZpoAUsFSB3AuymGAHROKXavbHY/C1JD5ItWH4fSJ+YesuCgkiXI35b
	htr3DJimt59lr1z+lCkJtuPrq1VVUsKIxV/Fggw3fn7n/ZHGqb4uJ1REX4MHRcYcP1TU65HpQps
	xy6nnn4NWdlmVcmSLYAy6p60ZV62fJ5/bZ6npdiQZS2ujCtcuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Broadcom BCM21664 mobile SoC. It has two Cortex-A9
cores like the BCM281xx family of chips. BCM21664 and BCM281xx share
many IP blocks in addition to the ARM cores.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/Makefile         |  6 ++-
 arch/arm/mach-bcm/board_bcm21664.c | 78 ++++++++++++++++++++++++++++++++++++++
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
index 0000000..acc1573
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
+static void bcm21664_restart(enum reboot_mode mode, const char *cmd)
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
+static void __init bcm21664_init(void)
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
+	.init_machine = bcm21664_init,
+	.restart = bcm21664_restart,
+	.dt_compat = bcm21664_dt_compat,
+MACHINE_END
-- 
1.9.0

