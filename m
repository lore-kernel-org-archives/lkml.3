Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaGCCf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:35:58 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44141 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaGCCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:35:57 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: viresh.linux@gmail.com
Cc: shiraz.linux.kernel@gmail.com, linux@arm.linux.org.uk,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mach-spear: New file for 1340 for sata support
Date: Wed,  2 Jul 2014 22:35:52 -0400
Message-Id: <1404354952-7327-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves all sata support for mach-spear 1340 to new file
called spear1340_sata.c as wanted in FIXME message.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-spear/spear1340_sata.c | 120 +++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100644 arch/arm/mach-spear/spear1340_sata.c

diff --git a/arch/arm/mach-spear/spear1340_sata.c b/arch/arm/mach-spear/spear1340_sata.c
new file mode 100644
index 0000000..b8ec6c8
--- /dev/null
+++ b/arch/arm/mach-spear/spear1340_sata.c
@@ -0,0 +1,120 @@
+/*
+ * arch/arm/mach-spear13xx/spear1340.c
+ *
+ * SPEAr1340 machine source file for Sata Support
+ *
+ * Copyright (C) 2012 ST Microelectronics
+ * Viresh Kumar <viresh.linux@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#define pr_fmt(fmt) "SPEAr1340: " fmt
+
+#include <linux/ahci_platform.h>
+#include <linux/amba/serial.h>
+#include <linux/delay.h>
+#include <linux/of_platform.h>
+#include <asm/mach/arch.h>
+#include "generic.h"
+#include <mach/spear.h>
+
+
+/* PCIE - SATA configuration registers */
+#define SPEAR1340_PCIE_SATA_CFG			(VA_MISC_BASE + 0x424)
+	/* PCIE CFG MASks */
+	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
+	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
+	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
+	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
+	#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
+	#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
+	#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
+	#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
+	#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
+	#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
+	#define SPEAR1340_SATA_PCIE_CFG_MASK		0xF1F
+	#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
+			SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
+			SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
+			SPEAR1340_PCIE_CFG_POWERUP_RESET | \
+			SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
+	#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
+			SPEAR1340_SATA_CFG_PM_CLK_EN | \
+			SPEAR1340_SATA_CFG_POWERUP_RESET | \
+			SPEAR1340_SATA_CFG_RX_CLK_EN | \
+			SPEAR1340_SATA_CFG_TX_CLK_EN)
+
+#define SPEAR1340_PCIE_MIPHY_CFG		(VA_MISC_BASE + 0x428)
+	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
+	#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
+			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+			SPEAR1340_MIPHY_CLK_REF_DIV2 | \
+			SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
+			(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
+			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
+
+/* SATA device registration */
+static int sata_miphy_init(struct device *dev, void __iomem *addr)
+{
+	writel(SPEAR1340_SATA_CFG_VAL, SPEAR1340_PCIE_SATA_CFG);
+	writel(SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK,
+			SPEAR1340_PCIE_MIPHY_CFG);
+	/* Switch on sata power domain */
+	writel((readl(SPEAR1340_PCM_CFG) | (0x800)), SPEAR1340_PCM_CFG);
+	msleep(20);
+	/* Disable PCIE SATA Controller reset */
+	writel((readl(SPEAR1340_PERIP1_SW_RST) & (~0x1000)),
+			SPEAR1340_PERIP1_SW_RST);
+	msleep(20);
+
+	return 0;
+}
+
+void sata_miphy_exit(struct device *dev)
+{
+	writel(0, SPEAR1340_PCIE_SATA_CFG);
+	writel(0, SPEAR1340_PCIE_MIPHY_CFG);
+
+	/* Enable PCIE SATA Controller reset */
+	writel((readl(SPEAR1340_PERIP1_SW_RST) | (0x1000)),
+			SPEAR1340_PERIP1_SW_RST);
+	msleep(20);
+	/* Switch off sata power domain */
+	writel((readl(SPEAR1340_PCM_CFG) & (~0x800)), SPEAR1340_PCM_CFG);
+	msleep(20);
+}
+
+int sata_suspend(struct device *dev)
+{
+	if (dev->power.power_state.event == PM_EVENT_FREEZE)
+		return 0;
+
+	sata_miphy_exit(dev);
+
+	return 0;
+}
+
+int sata_resume(struct device *dev)
+{
+	if (dev->power.power_state.event == PM_EVENT_THAW)
+		return 0;
+
+	return sata_miphy_init(dev, NULL);
+}
+
+static struct ahci_platform_data sata_pdata = {
+	.init = sata_miphy_init,
+	.exit = sata_miphy_exit,
+	.suspend = sata_suspend,
+	.resume = sata_resume,
+};
-- 
1.9.1

