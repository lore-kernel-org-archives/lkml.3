Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaCYR1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:27:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42701 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaCYR0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:26:51 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-73-5331bc5a2e4e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v3 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
Date: Tue, 25 Mar 2014 18:26:14 +0100
Message-id: <1395768375-21123-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395768375-21123-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395768375-21123-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd2oPYbBBl+eiFhsnLGe1eLcrQZW
	izfHpzNZ3FnBbLHp8TVWi2M7HjFZXN41h81if+8GJouG7h52izkzNrNa/Fp+lNFi5cW/zA48
	Htdf/Wfy2DnrLrvHplWdbB5zpjWxeJy8cJLFY/OSeo/3+66yefRtWcXo8fTHXmaP4ze2M3l8
	3iQXwB3FZZOSmpNZllqkb5fAlfHwzC+Wgt16FdePfGFtYDyq1sXIySEhYCIx6/Z+RghbTOLC
	vfVsXYxcHEICixgluv/3s4EkhAS6mCRevNIEsdkErCQmtq8CaxARkJW4Mu0hI0gDs0AXs8SS
	2VvAEsICyRIPDuwHa2YRUJX4efo0E4jNK+Ahcar5FhPENkWJ7mcTwGo4BTwlDn66yA6xzENi
	5YK5TBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7gZ1I7GFc2WBxiFOBgVOLh
	nTDBMFiINbGsuDL3EKMEB7OSCK/CBqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGxhrjXD7ZkquJkTM42Rd/Y76bbphyo/LZm8UnXZ98MOSNr17R7Prs
	TkF55tN18wVeZv+0Mb7e/u+yRfudIzJ5IdIh3+3aVtT9Wu9mwa63KbT8Cpu18x7jR7Z366xm
	eaxaWmhk+PWLZvLnrso0lxfs680MJuete7U8obXTY65dcnT3TpZyhe3LlViKMxINtZiLihMB
	NKaS01wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new ahci_da850 host driver.

Platform changes needed to make DaVinci DA850 SATA AHCI support
fully functional are in the separate "ARM: davinci: da850: update
SATA AHCI support" commit.

Please note that this driver doesn't have the superfluous clock
control code as clock is already handled by the generic AHCI
platform library code.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v3:
- merged changes from Sekhar
- splitted out platform changes into separate patch
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

 drivers/ata/Kconfig      |   9 ++++
 drivers/ata/Makefile     |   1 +
 drivers/ata/ahci_da850.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)
 create mode 100644 drivers/ata/ahci_da850.c

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
index 0000000..2c83613
--- /dev/null
+++ b/drivers/ata/ahci_da850.c
@@ -0,0 +1,114 @@
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
+static void da850_sata_init(struct device *dev, void __iomem *pwrdn_reg,
+			    void __iomem *ahci_base)
+{
+	unsigned int val;
+
+	/* Enable SATA clock receiver */
+	val = readl(pwrdn_reg);
+	val &= ~BIT(0);
+	writel(val, pwrdn_reg);
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
+	void __iomem *pwrdn_reg;
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
+	pwrdn_reg = devm_ioremap(dev, res->start, resource_size(res));
+	if (!pwrdn_reg)
+		goto disable_resources;
+
+	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
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

