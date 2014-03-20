Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbaCTS1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:27:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56185 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbaCTS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:27:49 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-d7-532b33242ac1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v2 3/3] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
Date: Thu, 20 Mar 2014 19:27:06 +0100
Message-id: <1395340026-3969-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jQV0VY+1gg4UzOCw2zljPanHuVgOr
	xZvj05ks7qxgttj0+BqrxbEdj5gsLu+aw2axv3cDk0VDdw+7xZwZm1ktfi0/ymix8uJfZgce
	j+uv/jN57Jx1l91j06pONo8505pYPE5eOMnisXlJvcf7fVfZPPq2rGL0ePpjL7PH8RvbmTw+
	b5IL4I7isklJzcksSy3St0vgyljbYlcw26vi/bQDjA2MfbZdjBwcEgImErNac7oYOYFMMYkL
	99azdTFycQgJTGeU2PHuBCOE08Uk8XbFHXaQKjYBK4mJ7asYQWwRAVmJK9MeghUxC3QxSyyZ
	vQUsISyQLPHweTsriM0ioCrx9l8XWDOvgLvE7QUb2SDWKUp0P5sAZnMKeEj875/EDGILAdWc
	7z7FNoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4PB9Jr2DcVWDxSFGAQ5GJR7e
	Ck7tYCHWxLLiytxDjBIczEoivNd0gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeW
	pGanphakFsFkmTg4pRoYg3NKM1mPibJZsEpGV91pkTw9Z8HH3aWejEa31PZdfpBxxZqvxLgk
	hHPH052eCkmcS9+8mXu7KLDBxrOkQDeuOrf2veg0lpktdwOedS5YarV7ayHDEcn8oBWbXp76
	9ftuyt19Knq8b00WHt/Wmb3h+JlYQYVI6WVdX82O9k/YfHGadqzjc51mJZbijERDLeai4kQA
	OzVURVsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new ahci_da850 host driver and remove the deprecated
ahci_platform_data platform code.

Please note that the new driver doesn't have the superfluous
clock control code as clock is already handled by the generic
AHCI platform library code.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v2:
- dropped the experimental tag from the config option help
- fixed SYSCFG1 memory resource handling
- hardcoded the multiplier data and added a note about it
- used readl()/writel() instead of __raw_readl()/__raw_writel()
- dropped the superflous clock control
- cleaned up da850_sata_init()
- changed the platform device name and removed the platform ids table
- removed the deprecated ahci_platform_data platform code
- updated the patch description

 arch/arm/mach-davinci/devices-da8xx.c |  99 +++--------------------------
 drivers/ata/Kconfig                   |   9 +++
 drivers/ata/Makefile                  |   1 +
 drivers/ata/ahci_da850.c              | 116 ++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+), 91 deletions(-)
 create mode 100644 drivers/ata/ahci_da850.c

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 0486cdf2..72bb8d6 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -1020,7 +1020,6 @@ int __init da8xx_register_spi_bus(int instance, unsigned num_chipselect)
 }
 
 #ifdef CONFIG_ARCH_DAVINCI_DA850
-
 static struct resource da850_sata_resources[] = {
 	{
 		.start	= DA850_SATA_BASE,
@@ -1028,103 +1027,22 @@ static struct resource da850_sata_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	{
+		.start	= DA8XX_SYSCFG1_BASE,
+		.end	= DA8XX_SYSCFG1_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
 		.start	= IRQ_DA850_SATAINT,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
 
-/* SATA PHY Control Register offset from AHCI base */
-#define SATA_P0PHYCR_REG	0x178
-
-#define SATA_PHY_MPY(x)		((x) << 0)
-#define SATA_PHY_LOS(x)		((x) << 6)
-#define SATA_PHY_RXCDR(x)	((x) << 10)
-#define SATA_PHY_RXEQ(x)	((x) << 13)
-#define SATA_PHY_TXSWING(x)	((x) << 19)
-#define SATA_PHY_ENPLL(x)	((x) << 31)
-
-static struct clk *da850_sata_clk;
-static unsigned long da850_sata_refclkpn;
-
-/* Supported DA850 SATA crystal frequencies */
-#define KHZ_TO_HZ(freq) ((freq) * 1000)
-static unsigned long da850_sata_xtal[] = {
-	KHZ_TO_HZ(300000),
-	KHZ_TO_HZ(250000),
-	0,			/* Reserved */
-	KHZ_TO_HZ(187500),
-	KHZ_TO_HZ(150000),
-	KHZ_TO_HZ(125000),
-	KHZ_TO_HZ(120000),
-	KHZ_TO_HZ(100000),
-	KHZ_TO_HZ(75000),
-	KHZ_TO_HZ(60000),
-};
-
-static int da850_sata_init(struct device *dev, void __iomem *addr)
-{
-	int i, ret;
-	unsigned int val;
-
-	da850_sata_clk = clk_get(dev, NULL);
-	if (IS_ERR(da850_sata_clk))
-		return PTR_ERR(da850_sata_clk);
-
-	ret = clk_prepare_enable(da850_sata_clk);
-	if (ret)
-		goto err0;
-
-	/* Enable SATA clock receiver */
-	val = __raw_readl(DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
-	val &= ~BIT(0);
-	__raw_writel(val, DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
-
-	/* Get the multiplier needed for 1.5GHz PLL output */
-	for (i = 0; i < ARRAY_SIZE(da850_sata_xtal); i++)
-		if (da850_sata_xtal[i] == da850_sata_refclkpn)
-			break;
-
-	if (i == ARRAY_SIZE(da850_sata_xtal)) {
-		ret = -EINVAL;
-		goto err1;
-	}
-
-	val = SATA_PHY_MPY(i + 1) |
-		SATA_PHY_LOS(1) |
-		SATA_PHY_RXCDR(4) |
-		SATA_PHY_RXEQ(1) |
-		SATA_PHY_TXSWING(3) |
-		SATA_PHY_ENPLL(1);
-
-	__raw_writel(val, addr + SATA_P0PHYCR_REG);
-
-	return 0;
-
-err1:
-	clk_disable_unprepare(da850_sata_clk);
-err0:
-	clk_put(da850_sata_clk);
-	return ret;
-}
-
-static void da850_sata_exit(struct device *dev)
-{
-	clk_disable_unprepare(da850_sata_clk);
-	clk_put(da850_sata_clk);
-}
-
-static struct ahci_platform_data da850_sata_pdata = {
-	.init	= da850_sata_init,
-	.exit	= da850_sata_exit,
-};
-
 static u64 da850_sata_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device da850_sata_device = {
-	.name	= "ahci",
+	.name	= "ahci_da850",
 	.id	= -1,
 	.dev	= {
-		.platform_data		= &da850_sata_pdata,
 		.dma_mask		= &da850_sata_dmamask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
@@ -1134,9 +1052,8 @@ static struct platform_device da850_sata_device = {
 
 int __init da850_register_sata(unsigned long refclkpn)
 {
-	da850_sata_refclkpn = refclkpn;
-	if (!da850_sata_refclkpn)
-		return -EINVAL;
+	/* please see comment in drivers/ata/ahci_da850.c */
+	BUG_ON(refclkpn != 100 * 1000 * 1000);
 
 	return platform_device_register(&da850_sata_device);
 }
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 371e8890..4b71e73 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
+config AHCI_DA850
+	tristate "DaVinci DA850 AHCI SATA support"
+	depends on ARCH_DAVINCI_DA850
+	help
+	  This option enables support for the DaVinci DA850 SoC's
+	  onboard AHCI SATA.
+
+	  If unsure, say N.
+
 config AHCI_ST
 	tristate "ST AHCI SATA support"
 	depends on ARCH_STI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 6123e64..0646d83 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
+obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
new file mode 100644
index 0000000..899270a
--- /dev/null
+++ b/drivers/ata/ahci_da850.c
@@ -0,0 +1,116 @@
+/*
+ * DaVinci DA850 AHCI SATA platform driver
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
+#define DA8XX_PWRDN_REG		0x18
+
+/* SATA PHY Control Register offset from AHCI base */
+#define SATA_P0PHYCR_REG	0x178
+
+#define SATA_PHY_MPY(x)		((x) << 0)
+#define SATA_PHY_LOS(x)		((x) << 6)
+#define SATA_PHY_RXCDR(x)	((x) << 10)
+#define SATA_PHY_RXEQ(x)	((x) << 13)
+#define SATA_PHY_TXSWING(x)	((x) << 19)
+#define SATA_PHY_ENPLL(x)	((x) << 31)
+
+/*
+ * The multiplier needed for 1.5GHz PLL output.
+ *
+ * NOTE: This is currently hardcoded to be suitable for 100MHz crystal
+ * frequency (which is used by DA850 EVM board) and may need to be changed
+ * if you would like to use this driver on some other board.
+ */
+#define DA850_SATA_CLK_MULTIPLIER	7
+
+static void da850_sata_init(struct device *dev, void __iomem *syscfg1_base,
+			    void __iomem *ahci_base)
+{
+	unsigned int val;
+
+	/* Enable SATA clock receiver */
+	val = readl(syscfg1_base + DA8XX_PWRDN_REG);
+	val &= ~BIT(0);
+	writel(val, syscfg1_base + DA8XX_PWRDN_REG);
+
+	val = SATA_PHY_MPY(DA850_SATA_CLK_MULTIPLIER + 1) | SATA_PHY_LOS(1) |
+	      SATA_PHY_RXCDR(4) | SATA_PHY_RXEQ(1) | SATA_PHY_TXSWING(3) |
+	      SATA_PHY_ENPLL(1);
+
+	writel(val, ahci_base + SATA_P0PHYCR_REG);
+}
+
+static const struct ata_port_info ahci_da850_port_info = {
+	.flags		= AHCI_FLAG_COMMON,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_platform_ops,
+};
+
+static int ahci_da850_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	struct resource *res;
+	void __iomem *syscfg1_base;
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
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res)
+		goto disable_resources;
+
+	syscfg1_base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!syscfg1_base)
+		goto disable_resources;
+
+	da850_sata_init(dev, syscfg1_base, hpriv->mmio);
+
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
+	if (rc)
+		goto disable_resources;
+
+	return 0;
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+	return rc;
+}
+
+static SIMPLE_DEV_PM_OPS(ahci_da850_pm_ops, ahci_platform_suspend,
+			 ahci_platform_resume);
+
+static struct platform_driver ahci_da850_driver = {
+	.probe = ahci_da850_probe,
+	.remove = ata_platform_remove_one,
+	.driver = {
+		.name = "ahci_da850",
+		.owner = THIS_MODULE,
+		.pm = &ahci_da850_pm_ops,
+	},
+};
+module_platform_driver(ahci_da850_driver);
+
+MODULE_DESCRIPTION("DaVinci DA850 AHCI SATA platform driver");
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.2.3

