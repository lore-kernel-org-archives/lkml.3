Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaHFRDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:03:33 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36877 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaHFRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:03:27 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 3/6] usb: host: ohci-st: Add OHCI driver support for ST STB devices
Date: Wed,  6 Aug 2014 18:03:06 +0100
Message-Id: <1407344589-24863-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the glue code required to ensure the on-chip OHCI
controller works on STi consumer electronics SoC's from STMicroelectronics.

It mainly manages the setting and enabling of the relevant clocks and manages
the reset / power signals to the IP block.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/usb/host/Kconfig   |   7 ++
 drivers/usb/host/Makefile  |   1 +
 drivers/usb/host/ohci-st.c | 302 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 310 insertions(+)
 create mode 100644 drivers/usb/host/ohci-st.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 800969a..339aed9 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -529,6 +529,13 @@ config USB_OHCI_EXYNOS
 	help
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 
+config USB_OHCI_ST
+	tristate "OHCI support for ST SoC Series"
+	depends on ARCH_STI && OF
+	help
+	 Enable support for the on-chip OHCI controller found on
+	 STMicroelectronics consumer electronics SoC's.
+
 config USB_CNS3XXX_OHCI
 	bool "Cavium CNS3XXX OHCI Module (DEPRECATED)"
 	depends on ARCH_CNS3XXX
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 877f7e2..12f7afd 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD_PCI)	+= ohci-pci.o
 obj-$(CONFIG_USB_OHCI_HCD_PLATFORM)	+= ohci-platform.o
 obj-$(CONFIG_USB_OHCI_EXYNOS)	+= ohci-exynos.o
+obj-$(CONFIG_USB_OHCI_ST)		+= ohci-st.o usb-st-common.o
 obj-$(CONFIG_USB_OHCI_HCD_OMAP1)	+= ohci-omap.o
 obj-$(CONFIG_USB_OHCI_HCD_OMAP3)	+= ohci-omap3.o
 obj-$(CONFIG_USB_OHCI_HCD_SPEAR)	+= ohci-spear.o
diff --git a/drivers/usb/host/ohci-st.c b/drivers/usb/host/ohci-st.c
new file mode 100644
index 0000000..dfaa616
--- /dev/null
+++ b/drivers/usb/host/ohci-st.c
@@ -0,0 +1,302 @@
+/*
+ * ST OHCI driver
+ *
+ * Copyright (C) 2014 STMicroelectronics – All Rights Reserved
+ *
+ * Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ * Derived from ohci-platform.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/hrtimer.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/usb/ohci_pdriver.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include "ohci.h"
+#include "usb-st-common.h"
+
+#define DRIVER_DESC "OHCI STMicroelectronics driver"
+
+#define hcd_to_ohci_priv(h) ((struct st_platform_priv *)hcd_to_ohci(h)->priv)
+
+static const char hcd_name[] = "ohci-st";
+
+static int st_ohci_platform_power_on(struct platform_device *dev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(dev);
+	struct st_platform_priv *priv = hcd_to_ohci_priv(hcd);
+
+	return st_usb_platform_power_on(priv);
+}
+
+static void st_ohci_platform_power_off(struct platform_device *dev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(dev);
+	struct st_platform_priv *priv = hcd_to_ohci_priv(hcd);
+
+	return st_usb_platform_power_off(priv);
+}
+
+static struct hc_driver __read_mostly ohci_platform_hc_driver;
+
+static const struct ohci_driver_overrides platform_overrides __initconst = {
+	.product_desc =		"ST OHCI controller",
+	.extra_priv_size =	sizeof(struct st_platform_priv),
+};
+
+static struct usb_ohci_pdata ohci_platform_defaults = {
+	.power_on =		st_ohci_platform_power_on,
+	.power_suspend =	st_ohci_platform_power_off,
+	.power_off =		st_ohci_platform_power_off,
+};
+
+static int st_ohci_platform_probe(struct platform_device *dev)
+{
+	struct usb_hcd *hcd;
+	struct resource *res_mem;
+	struct usb_ohci_pdata *pdata = dev_get_platdata(&dev->dev);
+	struct st_platform_priv *priv;
+	struct ohci_hcd *ohci;
+	int err, irq, clk = 0;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	/*
+	 * Use reasonable defaults so platforms don't have to provide these
+	 * with DT probing on ARM.
+	 */
+	if (!pdata)
+		pdata = &ohci_platform_defaults;
+
+	err = dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
+
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0) {
+		dev_err(&dev->dev, "no irq provided");
+		return irq;
+	}
+
+	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res_mem) {
+		dev_err(&dev->dev, "no memory resource provided");
+		return -ENXIO;
+	}
+
+	hcd = usb_create_hcd(&ohci_platform_hc_driver, &dev->dev,
+			dev_name(&dev->dev));
+	if (!hcd)
+		return -ENOMEM;
+
+	platform_set_drvdata(dev, hcd);
+	dev->dev.platform_data = pdata;
+	priv = hcd_to_ohci_priv(hcd);
+	ohci = hcd_to_ohci(hcd);
+
+	if (pdata == &ohci_platform_defaults && dev->dev.of_node) {
+
+		priv->phy = devm_phy_get(&dev->dev, "usb");
+		if (IS_ERR(priv->phy)) {
+			err = PTR_ERR(priv->phy);
+			if (err == -EPROBE_DEFER)
+				goto err_put_hcd;
+			priv->phy = NULL;
+		}
+
+		for (clk = 0; clk < USB_MAX_CLKS; clk++) {
+			priv->clks[clk] = of_clk_get(dev->dev.of_node, clk);
+			if (IS_ERR(priv->clks[clk])) {
+				err = PTR_ERR(priv->clks[clk]);
+				if (err == -EPROBE_DEFER)
+					goto err_put_clks;
+				priv->clks[clk] = NULL;
+				break;
+			}
+		}
+
+		/* some SoCs don't have a dedicated 48Mhz clock, but those that
+		   do need the rate to be explicitly set */
+		priv->clk48 = devm_clk_get(&dev->dev, "clk48");
+		if (IS_ERR(priv->clk48)) {
+			dev_info(&dev->dev, "48MHz clk not found\n");
+			priv->clk48 = NULL;
+		}
+	}
+
+	priv->rst = devm_reset_control_get_optional(&dev->dev, "power");
+	if (IS_ERR(priv->pwr)) {
+		err = PTR_ERR(priv->pwr);
+		if (err == -EPROBE_DEFER)
+			goto err_put_clks;
+		priv->rst = NULL;
+	}
+
+	priv->rst = devm_reset_control_get_optional(&dev->dev, "softreset");
+	if (IS_ERR(priv->rst)) {
+		err = PTR_ERR(priv->rst);
+		if (err == -EPROBE_DEFER)
+			goto err_put_clks;
+		priv->rst = NULL;
+	}
+
+	if (pdata->power_on) {
+		err = pdata->power_on(dev);
+		if (err < 0)
+			goto err_power;
+	}
+
+	hcd->rsrc_start = res_mem->start;
+	hcd->rsrc_len = resource_size(res_mem);
+
+	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
+	if (IS_ERR(hcd->regs)) {
+		err = PTR_ERR(hcd->regs);
+		goto err_power;
+	}
+	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (err)
+		goto err_power;
+
+	device_wakeup_enable(hcd->self.controller);
+
+	platform_set_drvdata(dev, hcd);
+
+	return err;
+
+err_power:
+	if (pdata->power_off)
+		pdata->power_off(dev);
+
+err_put_clks:
+	while (--clk >= 0)
+		clk_put(priv->clks[clk]);
+err_put_hcd:
+	if (pdata == &ohci_platform_defaults)
+		dev->dev.platform_data = NULL;
+
+	usb_put_hcd(hcd);
+
+	return err;
+}
+
+static int st_ohci_platform_remove(struct platform_device *dev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(dev);
+	struct usb_ohci_pdata *pdata = dev_get_platdata(&dev->dev);
+	struct st_platform_priv *priv = hcd_to_ohci_priv(hcd);
+	int clk;
+
+	usb_remove_hcd(hcd);
+
+	if (pdata->power_off)
+		pdata->power_off(dev);
+
+
+	for (clk = 0; clk < USB_MAX_CLKS && priv->clks[clk]; clk++)
+		clk_put(priv->clks[clk]);
+
+	usb_put_hcd(hcd);
+
+	if (pdata == &ohci_platform_defaults)
+		dev->dev.platform_data = NULL;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int st_ohci_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct usb_ohci_pdata *pdata = dev->platform_data;
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	bool do_wakeup = device_may_wakeup(dev);
+	int ret;
+
+	ret = ohci_suspend(hcd, do_wakeup);
+	if (ret)
+		return ret;
+
+	if (pdata->power_suspend)
+		pdata->power_suspend(pdev);
+
+	return ret;
+}
+
+static int st_ohci_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct usb_ohci_pdata *pdata = dev_get_platdata(dev);
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	int err;
+
+	if (pdata->power_on) {
+		err = pdata->power_on(pdev);
+		if (err < 0)
+			return err;
+	}
+
+	ohci_resume(hcd, false);
+	return 0;
+}
+
+#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(st_ohci_pm_ops, st_ohci_suspend, st_ohci_resume);
+
+static const struct of_device_id st_ohci_platform_ids[] = {
+	{ .compatible = "st,st-ohci-300x", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, st_ohci_platform_ids);
+
+static struct platform_driver ohci_platform_driver = {
+	.probe		= st_ohci_platform_probe,
+	.remove		= st_ohci_platform_remove,
+	.shutdown	= usb_hcd_platform_shutdown,
+	.driver		= {
+		.name	= "st-ohci",
+		.pm	= &st_ohci_pm_ops,
+		.of_match_table = st_ohci_platform_ids,
+	}
+};
+
+static int __init ohci_platform_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+
+	ohci_init_driver(&ohci_platform_hc_driver, &platform_overrides);
+	return platform_driver_register(&ohci_platform_driver);
+}
+module_init(ohci_platform_init);
+
+static void __exit ohci_platform_cleanup(void)
+{
+	platform_driver_unregister(&ohci_platform_driver);
+}
+module_exit(ohci_platform_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Peter Griffin <peter.griffin@linaro.org>");
+MODULE_LICENSE("GPL");
-- 
1.9.1

