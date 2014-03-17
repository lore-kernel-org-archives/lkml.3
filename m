Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaCQScd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:32:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26774 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbaCQSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:32:30 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6c-53273fbd4b5e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH 4/4] ata: add new-style AHCI platform driver for ST SPEAr1340
 AHCI controller
Date: Mon, 17 Mar 2014 19:31:58 +0100
Message-id: <1395081118-15248-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd299urBBi23xS02zljPanHuVgOr
	xZ0VzBabHl9jtTi24xGTxeVdc9gs9vduYLJo6O5ht5gzYzOrxa/lRxktVl78y+zA7XH91X8m
	j52z7rJ7bFrVyeYxZ1oTi8fJCydZPDYvqffo27KK0ePpj73MHsdvbGfy+LxJLoArissmJTUn
	syy1SN8ugStj2/I9bAXbXSpud+Q3MF617GLk5JAQMJGYsbSDFcIWk7hwbz1bFyMXh5DAdEaJ
	fT0PmCGcLiaJI9uWs4NUsQlYSUxsX8UIYosIyEpcmfaQEaSIWeAxk8TOlVPAioQF4iVaJ59l
	ArFZBFQltt/9B7aCV8BD4vPiJcwQ6xQlup9NYAOxOQU8JVb/+A4WFwKqadrxjHkCI+8CRoZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHB+kxqB+PKBotDjAIcjEo8vC/Y1IOFWBPLiitz
	DzFKcDArifBKmACFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJx
	cEo1MHq+vj+l0aFk0c778rs6T7nu9WvZb9s26VjV2ojZkza03jstdD3b1HblQQGhR5dmTCoP
	N9rGnOeV92mXHcse7ouCPXrf/ve+2KYjfmYTu+25lTb+pd8EPvxZ1PFRY5ntSiHRcBbXZgGZ
	n/N7DrzOnuQX8eF5pvUbLhHx60YSc5uKuE6ZsExT0VJiKc5INNRiLipOBACbupy1UgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new driver is named ahci_spear1340 and is only compile tested.  Once
it is tested on the real hardware and verified to work correctly, the legacy
platform code (which depends on the deprecated struct ahci_platform_data)
can be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig          |   9 ++
 drivers/ata/Makefile         |   1 +
 drivers/ata/ahci_spear1340.c | 222 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+)
 create mode 100644 drivers/ata/ahci_spear1340.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 6379a00..32046d4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -106,6 +106,15 @@ config AHCI_DA850
 
 	  If unsure, say N.
 
+config AHCI_SPEAR1340
+	tristate "ST SPEAr1340 AHCI SATA support (experimental)"
+	depends on MACH_SPEAR1340
+	help
+	  This option enables support for the ST SPEAr1340 SoC's
+	  onboard AHCI SATA.
+
+	  If unsure, say N.
+
 config AHCI_ST
 	tristate "ST AHCI SATA support"
 	depends on ARCH_STI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 0646d83..45e8df9 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
+obj-$(CONFIG_AHCI_SPEAR1340)	+= ahci_spear1340.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
 
 # SFF w/ custom DMA
diff --git a/drivers/ata/ahci_spear1340.c b/drivers/ata/ahci_spear1340.c
new file mode 100644
index 0000000..f1d798e
--- /dev/null
+++ b/drivers/ata/ahci_spear1340.c
@@ -0,0 +1,222 @@
+/*
+ * ST SPEAr1340 AHCI SATA platform driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/libata.h>
+#include <linux/ahci_platform.h>
+#include "ahci.h"
+
+#define VA_MISC_BASE				IOMEM(0xFD700000)
+
+/* Power Management Registers */
+#define SPEAR1340_PCM_CFG			(VA_MISC_BASE + 0x100)
+#define SPEAR1340_PCM_WKUP_CFG			(VA_MISC_BASE + 0x104)
+#define SPEAR1340_SWITCH_CTR			(VA_MISC_BASE + 0x108)
+
+#define SPEAR1340_PERIP1_SW_RST			(VA_MISC_BASE + 0x318)
+#define SPEAR1340_PERIP2_SW_RST			(VA_MISC_BASE + 0x31C)
+#define SPEAR1340_PERIP3_SW_RST			(VA_MISC_BASE + 0x320)
+
+/* PCIE - SATA configuration registers */
+#define SPEAR1340_PCIE_SATA_CFG			(VA_MISC_BASE + 0x424)
+/* PCIE CFG MASks */
+#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
+#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
+#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
+#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
+#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
+#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
+#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
+#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
+#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
+#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
+#define SPEAR1340_SATA_PCIE_CFG_MASK		0xF1F
+#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
+				 SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
+				 SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
+				 SPEAR1340_PCIE_CFG_POWERUP_RESET | \
+				 SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
+#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
+				 SPEAR1340_SATA_CFG_PM_CLK_EN | \
+				 SPEAR1340_SATA_CFG_POWERUP_RESET | \
+				 SPEAR1340_SATA_CFG_RX_CLK_EN | \
+				 SPEAR1340_SATA_CFG_TX_CLK_EN)
+
+#define SPEAR1340_PCIE_MIPHY_CFG		(VA_MISC_BASE + 0x428)
+#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
+#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
+#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
+#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
+#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
+#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
+		(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+		 SPEAR1340_MIPHY_CLK_REF_DIV2 | \
+		 SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
+#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
+		(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
+#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
+		(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+		 SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
+
+static void ahci_spear1340_miphy_init(struct device *dev, void __iomem *addr)
+{
+	writel(SPEAR1340_SATA_CFG_VAL, SPEAR1340_PCIE_SATA_CFG);
+	writel(SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK,
+	       SPEAR1340_PCIE_MIPHY_CFG);
+	/* Switch on sata power domain */
+	writel(readl(SPEAR1340_PCM_CFG) | 0x800, SPEAR1340_PCM_CFG);
+	msleep(20);
+	/* Disable PCIE SATA Controller reset */
+	writel(readl(SPEAR1340_PERIP1_SW_RST) & ~0x1000,
+	       SPEAR1340_PERIP1_SW_RST);
+	msleep(20);
+}
+
+static void ahci_spear1340_miphy_exit(struct device *dev)
+{
+	writel(0, SPEAR1340_PCIE_SATA_CFG);
+	writel(0, SPEAR1340_PCIE_MIPHY_CFG);
+
+	/* Enable PCIE SATA Controller reset */
+	writel(readl(SPEAR1340_PERIP1_SW_RST) | 0x1000,
+	       SPEAR1340_PERIP1_SW_RST);
+	msleep(20);
+	/* Switch off sata power domain */
+	writel(readl(SPEAR1340_PCM_CFG) & ~0x800, SPEAR1340_PCM_CFG);
+	msleep(20);
+}
+
+static void ahci_spear1340_host_stop(struct ata_host *host)
+{
+	struct device *dev = host->dev;
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	ahci_spear1340_miphy_exit(dev);
+
+	ahci_platform_disable_resources(hpriv);
+}
+
+static struct ata_port_operations ahci_spear1340_port_ops = {
+	.inherits	= &ahci_platform_ops,
+	.host_stop	= ahci_spear1340_host_stop,
+};
+
+static const struct ata_port_info ahci_spear1340_port_info = {
+	.flags		= AHCI_FLAG_COMMON,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_spear1340_port_ops,
+};
+
+static int ahci_spear1340_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	int rc;
+
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv))
+		return PTR_ERR(hpriv);
+
+	rc = ahci_platform_enable_resources(hpriv);
+	if (rc)
+		return rc;
+
+	ahci_spear1340_miphy_init(dev, hpriv->mmio);
+
+	rc = ahci_platform_init_host(pdev, hpriv,
+				     &ahci_spear1340_port_info, 0, 0);
+	if (rc)
+		goto miphy_exit;
+
+	return 0;
+miphy_exit:
+	ahci_spear1340_miphy_exit(dev);
+	ahci_platform_disable_resources(hpriv);
+	return rc;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int ahci_spear1340_suspend(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	rc = ahci_platform_suspend_host(dev);
+	if (rc)
+		return rc;
+
+	if (dev->power.power_state.event != PM_EVENT_FREEZE)
+		ahci_spear1340_miphy_exit(dev);
+
+	ahci_platform_disable_resources(hpriv);
+
+	return 0;
+}
+
+static int ahci_spear1340_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	rc = ahci_platform_enable_resources(hpriv);
+	if (rc)
+		return rc;
+
+	if (dev->power.power_state.event != PM_EVENT_THAW)
+		ahci_spear1340_miphy_init(dev, NULL);
+
+	rc = ahci_platform_resume_host(dev);
+	if (rc)
+		goto disable_resources;
+
+	/* We resumed so update PM runtime state */
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
+
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+
+	return rc;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(ahci_spear1340_pm_ops, ahci_spear1340_suspend,
+			 ahci_spear1340_resume);
+
+static struct of_device_id ahci_spear1340_of_match[] = {
+	{ .compatible = "snps,spear-ahci" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ahci_spear1340_of_match);
+
+static struct platform_driver ahci_spear1340_driver = {
+	.probe = ahci_spear1340_probe,
+	.remove = ata_platform_remove_one,
+	.driver = {
+		.name = "ahci_spear1340",
+		.owner = THIS_MODULE,
+		.of_match_table = ahci_spear1340_of_match,
+		.pm = &ahci_spear1340_pm_ops,
+	},
+};
+module_platform_driver(ahci_spear1340_driver);
+
+MODULE_DESCRIPTION("ST SPEAr1340 AHCI SATA platform driver");
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.2.3

