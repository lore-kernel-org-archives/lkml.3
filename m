Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbaCQSc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:32:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbaCQSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:32:26 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-9d-53273fb9b4da
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci DA850
 AHCI controller
Date: Mon, 17 Mar 2014 19:31:57 +0100
Message-id: <1395081118-15248-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd2d9urBBn/X81psnLGe1eLcrQZW
	izsrmC02Pb7GanFsxyMmi8u75rBZ7O/dwGTR0N3DbjFnxmZWi1/LjzJarLz4l9mB2+P6q/9M
	Hjtn3WX32LSqk81jzrQmFo+TF06yeGxeUu/Rt2UVo8fTH3uZPY7f2M7k8XmTXABXFJdNSmpO
	Zllqkb5dAlfGwjkHmQu6jCv+X7zP1MB4RquLkZNDQsBE4t7p94wQtpjEhXvr2boYuTiEBKYz
	Suxr/cEE4XQxSRzpPMwGUsUmYCUxsX0VWIeIgKzElWkPGUGKmAUeM0nsXDmFvYuRg0NYIEFi
	6gmwDSwCqhL3HjSzgNi8Ah4SO5cegdqmKNH9bALYTE4BT4nVP74zg9hCQDVNO54xT2DkXcDI
	sIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOFifSe9gXNVgcYhRgINRiYf3BZt6sBBrYllx
	Ze4hRgkOZiURXgkToBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZ
	Jg5OqQbGgCjV4/9uiAtv5xQrnmpWr2K8alrh2ZaY9rmBbyyvaTNfXRm2aNbc/4Yf5LpS9j5y
	v7fA0sn8zZ/ajJ7GtjbB63EbHpX8YXQw3hU3QbU47Ng1Ue4/O5fFT3B9+3BCjYGj3txfC3Ov
	OLwo3+KxgX89C9umVraLqwKL83PFZJncDtTOv+t931VIiaU4I9FQi7moOBEA4W5EWlICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new driver is named ahci_da850 and is only compile tested.  Once it
is tested on the real hardware and verified to work correctly, the legacy
platform code (which depends on the deprecated struct ahci_platform_data)
can be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig      |   9 +++
 drivers/ata/Makefile     |   1 +
 drivers/ata/ahci_da850.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)
 create mode 100644 drivers/ata/ahci_da850.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 371e8890..6379a00 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
+config AHCI_DA850
+	tristate "DaVinci DA850 AHCI SATA support (experimental)"
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
index 0000000..da874699
--- /dev/null
+++ b/drivers/ata/ahci_da850.c
@@ -0,0 +1,178 @@
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
+extern void __iomem *da8xx_syscfg1_base;
+#define DA8XX_SYSCFG1_VIRT(x)	(da8xx_syscfg1_base + (x))
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
+static struct clk *da850_sata_clk;
+static unsigned long da850_sata_refclkpn = 100 * 1000 * 1000;
+
+/* Supported DA850 SATA crystal frequencies */
+#define KHZ_TO_HZ(freq) ((freq) * 1000)
+static unsigned long da850_sata_xtal[] = {
+	KHZ_TO_HZ(300000),
+	KHZ_TO_HZ(250000),
+	0,			/* Reserved */
+	KHZ_TO_HZ(187500),
+	KHZ_TO_HZ(150000),
+	KHZ_TO_HZ(125000),
+	KHZ_TO_HZ(120000),
+	KHZ_TO_HZ(100000),
+	KHZ_TO_HZ(75000),
+	KHZ_TO_HZ(60000),
+};
+
+static int da850_sata_init(struct device *dev, void __iomem *addr)
+{
+	int i, ret;
+	unsigned int val;
+
+	da850_sata_clk = clk_get(dev, NULL);
+	if (IS_ERR(da850_sata_clk))
+		return PTR_ERR(da850_sata_clk);
+
+	ret = clk_prepare_enable(da850_sata_clk);
+	if (ret)
+		goto err0;
+
+	/* Enable SATA clock receiver */
+	val = __raw_readl(DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
+	val &= ~BIT(0);
+	__raw_writel(val, DA8XX_SYSCFG1_VIRT(DA8XX_PWRDN_REG));
+
+	/* Get the multiplier needed for 1.5GHz PLL output */
+	for (i = 0; i < ARRAY_SIZE(da850_sata_xtal); i++)
+		if (da850_sata_xtal[i] == da850_sata_refclkpn)
+			break;
+
+	if (i == ARRAY_SIZE(da850_sata_xtal)) {
+		ret = -EINVAL;
+		goto err1;
+	}
+
+	val = SATA_PHY_MPY(i + 1) |
+		SATA_PHY_LOS(1) |
+		SATA_PHY_RXCDR(4) |
+		SATA_PHY_RXEQ(1) |
+		SATA_PHY_TXSWING(3) |
+		SATA_PHY_ENPLL(1);
+
+	__raw_writel(val, addr + SATA_P0PHYCR_REG);
+
+	return 0;
+
+err1:
+	clk_disable_unprepare(da850_sata_clk);
+err0:
+	clk_put(da850_sata_clk);
+	return ret;
+}
+
+static void da850_sata_exit(struct device *dev)
+{
+	clk_disable_unprepare(da850_sata_clk);
+	clk_put(da850_sata_clk);
+}
+
+static void ahci_da850_host_stop(struct ata_host *host)
+{
+	struct device *dev = host->dev;
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	da850_sata_exit(dev);
+
+	ahci_platform_disable_resources(hpriv);
+}
+
+static struct ata_port_operations ahci_da850_port_ops = {
+	.inherits	= &ahci_platform_ops,
+	.host_stop	= ahci_da850_host_stop,
+};
+
+static const struct ata_port_info ahci_da850_port_info = {
+	.flags		= AHCI_FLAG_COMMON,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_da850_port_ops,
+};
+
+static int ahci_da850_probe(struct platform_device *pdev)
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
+	rc = da850_sata_init(dev, hpriv->mmio);
+	if (rc)
+		goto disable_resources;
+
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
+	if (rc)
+		goto sata_exit;
+
+	return 0;
+sata_exit:
+	da850_sata_exit(dev);
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+	return rc;
+}
+
+static SIMPLE_DEV_PM_OPS(ahci_da850_pm_ops, ahci_platform_suspend,
+			 ahci_platform_resume);
+
+static struct platform_device_id ahci_da850_platform_ids[] = {
+	{ .name = "ahci" },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, ahci_da850_platform_ids);
+
+static struct platform_driver ahci_da850_driver = {
+	.probe = ahci_da850_probe,
+	.remove = ata_platform_remove_one,
+	.driver = {
+		.name = "ahci_da850",
+		.owner = THIS_MODULE,
+		.pm = &ahci_da850_pm_ops,
+	},
+	.id_table = ahci_da850_platform_ids,
+};
+module_platform_driver(ahci_da850_driver);
+
+MODULE_DESCRIPTION("DaVinci DA850 AHCI SATA platform driver");
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.2.3

