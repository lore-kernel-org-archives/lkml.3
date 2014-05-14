Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaENJuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:50:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45071 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbaENJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:49:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] ata: ahci: add AHCI support for the Berlin BG2Q
Date: Wed, 14 May 2014 11:48:59 +0200
Message-Id: <1400060942-10588-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Berlin BG2Q AHCI SATA controller allowing to
interface with devices like external hard drives.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/ata/Kconfig       |  10 +++
 drivers/ata/Makefile      |   1 +
 drivers/ata/ahci_berlin.c | 202 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 drivers/ata/ahci_berlin.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index c2706047337f..37e6817b31f4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -97,6 +97,16 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
+config AHCI_BERLIN
+	tristate "Marvell Berlin AHCI SATA support"
+	depends on ARCH_BERLIN
+	select PHY_BERLIN_SATA
+	help
+	  This option enables support for the Marvell Berlin SoC's
+	  onboard AHCI SATA.
+
+	  If unsure, say N.
+
 config AHCI_DA850
 	tristate "DaVinci DA850 AHCI SATA support"
 	depends on ARCH_DAVINCI_DA850
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 44c8016e565c..7fb78d1e0a44 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
+obj-$(CONFIG_AHCI_BERLIN)	+= ahci_berlin.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
diff --git a/drivers/ata/ahci_berlin.c b/drivers/ata/ahci_berlin.c
new file mode 100644
index 000000000000..973c07e54a6a
--- /dev/null
+++ b/drivers/ata/ahci_berlin.c
@@ -0,0 +1,202 @@
+/*
+ * Marvell Berlin AHCI SATA platform driver
+ *
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ * Jisheng Zhang <jszhang@marvell.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/ahci_platform.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+#include "ahci.h"
+
+#define BERLIN_SATA_NPORTS	2
+
+#define PORT_VSR_ADDR		0x78
+#define PORT_VSR_DATA		0x7c
+
+#define PHY_BASE		0x200
+
+/* register 0x01 */
+#define REF_FREF_SEL_25		BIT(0)
+#define PHY_MODE_SATA		(0x0 << 5)
+
+/* register 0x02 */
+#define USE_MAX_PLL_RATE	BIT(12)
+
+/* register 0x23 */
+#define DATA_BIT_WIDTH_10	(0x0 << 10)
+#define DATA_BIT_WIDTH_20	(0x1 << 10)
+#define DATA_BIT_WIDTH_40	(0x2 << 10)
+
+/* register 0x25 */
+#define PHY_GEN_MAX_1_5		(0x0 << 10)
+#define PHY_GEN_MAX_3_0		(0x1 << 10)
+#define PHY_GEN_MAX_6_0		(0x2 << 10)
+
+struct berlin_ahci_priv {
+	struct ahci_host_priv	*hpriv;
+	struct phy		*phys[BERLIN_SATA_NPORTS];
+};
+
+static inline void ahci_berlin_reg_setbits(void __iomem *ctrl_reg, u32 reg,
+					   u32 mask, u32 val)
+{
+	u32 regval;
+
+	/* select register */
+	writel(PHY_BASE + reg, ctrl_reg + PORT_VSR_ADDR);
+
+	/* set bits */
+	regval = readl(ctrl_reg + PORT_VSR_DATA);
+	regval &= ~mask;
+	regval |= val;
+	writel(regval, ctrl_reg + PORT_VSR_DATA);
+}
+
+static void ahci_berlin_port_init(struct ahci_host_priv *hpriv,
+				  unsigned int port)
+{
+	struct berlin_ahci_priv *berlin_priv = hpriv->plat_data;
+	void __iomem *ctrl_reg = hpriv->mmio + 0x100 + (port * 0x80);
+
+	/* power on the PHY */
+	phy_power_on(berlin_priv->phys[port]);
+
+	/* set PHY mode to SATA, ref freq to 25 MHz */
+	ahci_berlin_reg_setbits(ctrl_reg, 0x1, 0xff, REF_FREF_SEL_25 | PHY_MODE_SATA);
+
+	/* set PHY up to 6 Gbps */
+	ahci_berlin_reg_setbits(ctrl_reg, 0x25, 0xc00, PHY_GEN_MAX_6_0);
+
+	/* set 40 bits width */
+	ahci_berlin_reg_setbits(ctrl_reg, 0x23,  0xc00, DATA_BIT_WIDTH_40);
+
+	/* use max pll rate */
+	ahci_berlin_reg_setbits(ctrl_reg, 0x2, 0x0, USE_MAX_PLL_RATE);
+
+	/* set the controller speed */
+	writel(0x31, ctrl_reg + PORT_SCR_CTL);
+}
+
+static const struct ata_port_info ahci_berlin_port_info = {
+	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_platform_ops,
+};
+
+static int ahci_berlin_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	struct berlin_ahci_priv *berlin_priv;
+	int ret, i = 0;
+	unsigned mask = 0;
+
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv)) {
+		dev_err(dev, "cannot get AHCI resources\n");
+		return PTR_ERR(hpriv);
+	}
+
+	berlin_priv = devm_kzalloc(dev, sizeof(*berlin_priv), GFP_KERNEL);
+	if (!berlin_priv)
+		return -ENOMEM;
+
+	hpriv->plat_data = berlin_priv;
+
+	ret = ahci_platform_enable_resources(hpriv);
+	if (ret) {
+		dev_err(dev, "cannot enable resources: %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < BERLIN_SATA_NPORTS; i++) {
+		char phy_name[6];
+
+		sprintf(phy_name, "port%d", i);
+
+		berlin_priv->phys[i] = devm_phy_get(dev, phy_name);
+		if (IS_ERR(berlin_priv->phys[i])) {
+			dev_warn(dev, "%s not available\n", phy_name);
+			continue;
+		}
+
+		mask |= 1 << i;
+		ahci_berlin_port_init(hpriv, i);
+	}
+
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_berlin_port_info,
+				      0, mask);
+	if (ret) {
+		dev_err(dev, "host init failed: %d\n", ret);
+		goto disable_resources;
+	}
+
+	return 0;
+
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int ahci_berlin_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct berlin_ahci_priv *berlin_priv = hpriv->plat_data;
+	int ret, i;
+
+	ret = ahci_platform_enable_resources(hpriv);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < BERLIN_SATA_NPORTS; i++) {
+		if (!IS_ERR(berlin_priv->phys[i]))
+			ahci_berlin_port_init(hpriv, i);
+	}
+
+	ret = ahci_platform_resume_host(dev);
+	if (ret) {
+		ahci_platform_disable_resources(hpriv);
+		return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(ahci_berlin_pm_ops, ahci_platform_suspend,
+			 ahci_berlin_resume);
+
+static const struct of_device_id ahci_berlin_of_match[] = {
+	{ .compatible = "marvell,berlin-ahci" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ahci_berlin_of_match);
+
+static struct platform_driver ahci_berlin_driver = {
+	.probe	= ahci_berlin_probe,
+	.remove	= ata_platform_remove_one,
+	.driver	= {
+		.name		= "ahci-berlin",
+		.owner		= THIS_MODULE,
+		.of_match_table = ahci_berlin_of_match,
+		.pm		= &ahci_berlin_pm_ops,
+	},
+};
+module_platform_driver(ahci_berlin_driver);
+
+MODULE_DESCRIPTION("Marvell Berlin AHCI SATA driver");
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_LICENSE("GPL");
-- 
1.9.1

