Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaDBT3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:29:47 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58501 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbaDBT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:29:41 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, bcm@fixthebug.org, mporter@linaro.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 4/5] clk: bcm21664: use common clock framework
Date: Wed,  2 Apr 2014 14:30:00 -0500
Message-Id: <1396467001-3551-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396467001-3551-1-git-send-email-elder@linaro.org>
References: <1396467001-3551-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the set of CCUs and provided clocks sufficient to satisfy the
needs of all the existing clock references for BCM21664.  Replace
the "fake" fixed-rate clocks used previously with "real" ones.

Note that only the minimal set of these clocks and CCUs is defined
here.  More clock definitions will need to be added as required by
the addition of additional drivers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/Kconfig              |    2 +-
 drivers/clk/bcm/Makefile             |    1 +
 drivers/clk/bcm/clk-bcm21664.c       |  290 ++++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/bcm21664.h |   62 ++++++++
 4 files changed, 354 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/bcm/clk-bcm21664.c
 create mode 100644 include/dt-bindings/clock/bcm21664.h

diff --git a/drivers/clk/bcm/Kconfig b/drivers/clk/bcm/Kconfig
index a7262fb..75506e5 100644
--- a/drivers/clk/bcm/Kconfig
+++ b/drivers/clk/bcm/Kconfig
@@ -6,4 +6,4 @@ config CLK_BCM_KONA
 	help
 	  Enable common clock framework support for Broadcom SoCs
 	  using "Kona" style clock control units, including those
-	  in the BCM281xx family.
+	  in the BCM281xx and BCM21664 families.
diff --git a/drivers/clk/bcm/Makefile b/drivers/clk/bcm/Makefile
index cf93359..6297d05 100644
--- a/drivers/clk/bcm/Makefile
+++ b/drivers/clk/bcm/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona-setup.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm281xx.o
+obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm21664.o
diff --git a/drivers/clk/bcm/clk-bcm21664.c b/drivers/clk/bcm/clk-bcm21664.c
new file mode 100644
index 0000000..eeae4ca
--- /dev/null
+++ b/drivers/clk/bcm/clk-bcm21664.c
@@ -0,0 +1,290 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ * Copyright 2014 Linaro Limited
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
+#include "clk-kona.h"
+#include "dt-bindings/clock/bcm21664.h"
+
+#define BCM21664_CCU_COMMON(_name, _capname) \
+	KONA_CCU_COMMON(BCM21664, _name, _capname)
+
+/* Root CCU */
+
+static struct peri_clk_data frac_1m_data = {
+	.gate		= HW_SW_GATE(0x214, 16, 0, 1),
+	.clocks		= CLOCKS("ref_crystal"),
+};
+
+static struct ccu_data root_ccu_data = {
+	BCM21664_CCU_COMMON(root, ROOT),
+	/* no policy control */
+	.kona_clks	= {
+		[BCM21664_ROOT_CCU_FRAC_1M] =
+			KONA_CLK(root, frac_1m, peri),
+		[BCM21664_ROOT_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
+};
+
+/* AON CCU */
+
+static struct peri_clk_data hub_timer_data = {
+	.gate		= HW_SW_GATE(0x0414, 16, 0, 1),
+	.hyst		= HYST(0x0414, 8, 9),
+	.clocks		= CLOCKS("bbl_32k",
+				 "frac_1m",
+				 "dft_19_5m"),
+	.sel		= SELECTOR(0x0a10, 0, 2),
+	.trig		= TRIGGER(0x0a40, 4),
+};
+
+static struct ccu_data aon_ccu_data = {
+	BCM21664_CCU_COMMON(aon, AON),
+	.policy		= {
+		.enable		= CCU_LVM_EN(0x0034, 0),
+		.control	= CCU_POLICY_CTL(0x000c, 0, 1, 2),
+	},
+	.kona_clks	= {
+		[BCM21664_AON_CCU_HUB_TIMER] =
+			KONA_CLK(aon, hub_timer, peri),
+		[BCM21664_AON_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
+};
+
+/* Master CCU */
+
+static struct peri_clk_data sdio1_data = {
+	.gate		= HW_SW_GATE(0x0358, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a28, 0, 3),
+	.div		= DIVIDER(0x0a28, 4, 14),
+	.trig		= TRIGGER(0x0afc, 9),
+};
+
+static struct peri_clk_data sdio2_data = {
+	.gate		= HW_SW_GATE(0x035c, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a2c, 0, 3),
+	.div		= DIVIDER(0x0a2c, 4, 14),
+	.trig		= TRIGGER(0x0afc, 10),
+};
+
+static struct peri_clk_data sdio3_data = {
+	.gate		= HW_SW_GATE(0x0364, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a34, 0, 3),
+	.div		= DIVIDER(0x0a34, 4, 14),
+	.trig		= TRIGGER(0x0afc, 12),
+};
+
+static struct peri_clk_data sdio4_data = {
+	.gate		= HW_SW_GATE(0x0360, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_52m",
+				 "ref_52m",
+				 "var_96m",
+				 "ref_96m"),
+	.sel		= SELECTOR(0x0a30, 0, 3),
+	.div		= DIVIDER(0x0a30, 4, 14),
+	.trig		= TRIGGER(0x0afc, 11),
+};
+
+static struct peri_clk_data sdio1_sleep_data = {
+	.clocks		= CLOCKS("ref_32k"),	/* Verify */
+	.gate		= HW_SW_GATE(0x0358, 18, 2, 3),
+};
+
+static struct peri_clk_data sdio2_sleep_data = {
+	.clocks		= CLOCKS("ref_32k"),	/* Verify */
+	.gate		= HW_SW_GATE(0x035c, 18, 2, 3),
+};
+
+static struct peri_clk_data sdio3_sleep_data = {
+	.clocks		= CLOCKS("ref_32k"),	/* Verify */
+	.gate		= HW_SW_GATE(0x0364, 18, 2, 3),
+};
+
+static struct peri_clk_data sdio4_sleep_data = {
+	.clocks		= CLOCKS("ref_32k"),	/* Verify */
+	.gate		= HW_SW_GATE(0x0360, 18, 2, 3),
+};
+
+static struct ccu_data master_ccu_data = {
+	BCM21664_CCU_COMMON(master, MASTER),
+	.policy		= {
+		.enable		= CCU_LVM_EN(0x0034, 0),
+		.control	= CCU_POLICY_CTL(0x000c, 0, 1, 2),
+	},
+	.kona_clks	= {
+		[BCM21664_MASTER_CCU_SDIO1] =
+			KONA_CLK(master, sdio1, peri),
+		[BCM21664_MASTER_CCU_SDIO2] =
+			KONA_CLK(master, sdio2, peri),
+		[BCM21664_MASTER_CCU_SDIO3] =
+			KONA_CLK(master, sdio3, peri),
+		[BCM21664_MASTER_CCU_SDIO4] =
+			KONA_CLK(master, sdio4, peri),
+		[BCM21664_MASTER_CCU_SDIO1_SLEEP] =
+			KONA_CLK(master, sdio1_sleep, peri),
+		[BCM21664_MASTER_CCU_SDIO2_SLEEP] =
+			KONA_CLK(master, sdio2_sleep, peri),
+		[BCM21664_MASTER_CCU_SDIO3_SLEEP] =
+			KONA_CLK(master, sdio3_sleep, peri),
+		[BCM21664_MASTER_CCU_SDIO4_SLEEP] =
+			KONA_CLK(master, sdio4_sleep, peri),
+		[BCM21664_MASTER_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
+};
+
+/* Slave CCU */
+
+static struct peri_clk_data uartb_data = {
+	.gate		= HW_SW_GATE(0x0400, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a10, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a10, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 2),
+};
+
+static struct peri_clk_data uartb2_data = {
+	.gate		= HW_SW_GATE(0x0404, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a14, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a14, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 3),
+};
+
+static struct peri_clk_data uartb3_data = {
+	.gate		= HW_SW_GATE(0x0408, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_156m",
+				 "ref_156m"),
+	.sel		= SELECTOR(0x0a18, 0, 2),
+	.div		= FRAC_DIVIDER(0x0a18, 4, 12, 8),
+	.trig		= TRIGGER(0x0afc, 4),
+};
+
+static struct peri_clk_data bsc1_data = {
+	.gate		= HW_SW_GATE(0x0458, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a64, 0, 3),
+	.trig		= TRIGGER(0x0afc, 23),
+};
+
+static struct peri_clk_data bsc2_data = {
+	.gate		= HW_SW_GATE(0x045c, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a68, 0, 3),
+	.trig		= TRIGGER(0x0afc, 24),
+};
+
+static struct peri_clk_data bsc3_data = {
+	.gate		= HW_SW_GATE(0x0470, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a7c, 0, 3),
+	.trig		= TRIGGER(0x0afc, 18),
+};
+
+static struct peri_clk_data bsc4_data = {
+	.gate		= HW_SW_GATE(0x0474, 18, 2, 3),
+	.clocks		= CLOCKS("ref_crystal",
+				 "var_104m",
+				 "ref_104m",
+				 "var_13m",
+				 "ref_13m"),
+	.sel		= SELECTOR(0x0a80, 0, 3),
+	.trig		= TRIGGER(0x0afc, 19),
+};
+
+static struct ccu_data slave_ccu_data = {
+	BCM21664_CCU_COMMON(slave, SLAVE),
+       .policy		= {
+		.enable		= CCU_LVM_EN(0x0034, 0),
+		.control	= CCU_POLICY_CTL(0x000c, 0, 1, 2),
+	},
+	.kona_clks	= {
+		[BCM21664_SLAVE_CCU_UARTB] =
+			KONA_CLK(slave, uartb, peri),
+		[BCM21664_SLAVE_CCU_UARTB2] =
+			KONA_CLK(slave, uartb2, peri),
+		[BCM21664_SLAVE_CCU_UARTB3] =
+			KONA_CLK(slave, uartb3, peri),
+		[BCM21664_SLAVE_CCU_BSC1] =
+			KONA_CLK(slave, bsc1, peri),
+		[BCM21664_SLAVE_CCU_BSC2] =
+			KONA_CLK(slave, bsc2, peri),
+		[BCM21664_SLAVE_CCU_BSC3] =
+			KONA_CLK(slave, bsc3, peri),
+		[BCM21664_SLAVE_CCU_BSC4] =
+			KONA_CLK(slave, bsc4, peri),
+		[BCM21664_SLAVE_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
+	},
+};
+
+/* Device tree match table callback functions */
+
+static void __init kona_dt_root_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(&root_ccu_data, node);
+}
+
+static void __init kona_dt_aon_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(&aon_ccu_data, node);
+}
+
+static void __init kona_dt_master_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(&master_ccu_data, node);
+}
+
+static void __init kona_dt_slave_ccu_setup(struct device_node *node)
+{
+	kona_dt_ccu_setup(&slave_ccu_data, node);
+}
+
+CLK_OF_DECLARE(bcm21664_root_ccu, BCM21664_DT_ROOT_CCU_COMPAT,
+			kona_dt_root_ccu_setup);
+CLK_OF_DECLARE(bcm21664_aon_ccu, BCM21664_DT_AON_CCU_COMPAT,
+			kona_dt_aon_ccu_setup);
+CLK_OF_DECLARE(bcm21664_master_ccu, BCM21664_DT_MASTER_CCU_COMPAT,
+			kona_dt_master_ccu_setup);
+CLK_OF_DECLARE(bcm21664_slave_ccu, BCM21664_DT_SLAVE_CCU_COMPAT,
+			kona_dt_slave_ccu_setup);
diff --git a/include/dt-bindings/clock/bcm21664.h b/include/dt-bindings/clock/bcm21664.h
new file mode 100644
index 0000000..5a7f0e4
--- /dev/null
+++ b/include/dt-bindings/clock/bcm21664.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ * Copyright 2013 Linaro Limited
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
+#ifndef _CLOCK_BCM21664_H
+#define _CLOCK_BCM21664_H
+
+/*
+ * This file defines the values used to specify clocks provided by
+ * the clock control units (CCUs) on Broadcom BCM21664 family SoCs.
+ */
+
+/* bcm21664 CCU device tree "compatible" strings */
+#define BCM21664_DT_ROOT_CCU_COMPAT	"brcm,bcm21664-root-ccu"
+#define BCM21664_DT_AON_CCU_COMPAT	"brcm,bcm21664-aon-ccu"
+#define BCM21664_DT_MASTER_CCU_COMPAT	"brcm,bcm21664-master-ccu"
+#define BCM21664_DT_SLAVE_CCU_COMPAT	"brcm,bcm21664-slave-ccu"
+
+/* root CCU clock ids */
+
+#define BCM21664_ROOT_CCU_FRAC_1M		0
+#define BCM21664_ROOT_CCU_CLOCK_COUNT		1
+
+/* aon CCU clock ids */
+
+#define BCM21664_AON_CCU_HUB_TIMER		0
+#define BCM21664_AON_CCU_CLOCK_COUNT		1
+
+/* master CCU clock ids */
+
+#define BCM21664_MASTER_CCU_SDIO1		0
+#define BCM21664_MASTER_CCU_SDIO2		1
+#define BCM21664_MASTER_CCU_SDIO3		2
+#define BCM21664_MASTER_CCU_SDIO4		3
+#define BCM21664_MASTER_CCU_SDIO1_SLEEP		4
+#define BCM21664_MASTER_CCU_SDIO2_SLEEP		5
+#define BCM21664_MASTER_CCU_SDIO3_SLEEP		6
+#define BCM21664_MASTER_CCU_SDIO4_SLEEP		7
+#define BCM21664_MASTER_CCU_CLOCK_COUNT		8
+
+/* slave CCU clock ids */
+
+#define BCM21664_SLAVE_CCU_UARTB		0
+#define BCM21664_SLAVE_CCU_UARTB2		1
+#define BCM21664_SLAVE_CCU_UARTB3		2
+#define BCM21664_SLAVE_CCU_BSC1			3
+#define BCM21664_SLAVE_CCU_BSC2			4
+#define BCM21664_SLAVE_CCU_BSC3			5
+#define BCM21664_SLAVE_CCU_BSC4			6
+#define BCM21664_SLAVE_CCU_CLOCK_COUNT		7
+
+#endif /* _CLOCK_BCM21664_H */
-- 
1.7.9.5

