Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbbAYIPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:15:39 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60543 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbAYIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:15:23 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH v3 5/5] usb: dwc3: add Fujitsu Specific Glue layer
Date: Sun, 25 Jan 2015 16:13:28 +0800
Message-Id: <1422173608-24355-6-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Synopsis DesignWare USB3 IP Core found
on Fujitsu Socs.

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   33 ++++
 drivers/usb/dwc3/Kconfig                           |   11 ++
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-mb86s70.c                    |  206 ++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
 create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c

diff --git a/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
new file mode 100644
index 0000000..be091eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
@@ -0,0 +1,33 @@
+FUJITSU GLUE COMPONENTS
+
+MB86S7x DWC3 GLUE
+- compatible:	Should be "fujitsu,mb86s70-dwc3"
+- clocks:	from common clock binding, handle to usb clock.
+- clock-names:	Should contain the following:
+  "core"	Master/Core clock needs to run at a minimum of 125 MHz to
+		support a 4 Gbps IN or 4 Gbps OUT
+		transfer at a given time.
+
+Sub-nodes:
+The dwc3 core should be added as subnode to MB86S7x dwc3 glue.
+- dwc3 :
+   The binding details of dwc3 can be found in:
+   Documentation/devicetree/bindings/usb/dwc3.txt
+
+Example device nodes:
+
+	usb3host: mb86s70_usb3host {
+		compatible = "fujitsu,mb86s70-dwc3";
+		clocks = <&clk_alw_1_1>;
+		clock-names = "core";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3@32200000 {
+			compatible = "synopsys,dwc3";
+			reg = <0 0x32300000 0x100000>;
+			interrupts = <0 412 0x4>,
+				<0 414 0x4>;
+		};
+	};
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 58b5b2c..3390d42 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -61,6 +61,17 @@ config USB_DWC3_EXYNOS
 	  Recent Exynos5 SoCs ship with one DesignWare Core USB3 IP inside,
 	  say 'Y' or 'M' if you have one such device.
 
+config USB_DWC3_MB86S70
+	tristate "MB86S70 Designware USB3 Platform code"
+	default USB_DWC3
+	help
+	  MB86S7X SOC ship with DesignWare Core USB3 IP inside,
+	  this implementation also integrated Fujitsu USB PHY inside
+	  this Core USB3 IP.
+
+	  say 'Y' or 'M' if you have one such device.
+
+
 config USB_DWC3_PCI
 	tristate "PCIe-based Platforms"
 	depends on PCI
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index bb34fbc..05d1de2 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
 obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
 obj-$(CONFIG_USB_DWC3_QCOM)		+= dwc3-qcom.o
 obj-$(CONFIG_USB_DWC3_ST)		+= dwc3-st.o
+obj-$(CONFIG_USB_DWC3_MB86S70)		+= dwc3-mb86s70.o
diff --git a/drivers/usb/dwc3/dwc3-mb86s70.c b/drivers/usb/dwc3/dwc3-mb86s70.c
new file mode 100644
index 0000000..301be76
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-mb86s70.c
@@ -0,0 +1,206 @@
+/**
+ * dwc3-mb86s70.c - Fujitsu mb86s70 DWC3 Specific Glue layer
+ *
+ * Copyright (c) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED
+ *		http://jp.fujitsu.com/group/fsl
+ *
+ * Authors: Alice Chan <Alice.Chan@tw.fujitsu.com>
+ *	    Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
+ * based on dwc3-exynos.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+
+struct dwc3_mb86s70 {
+	struct device	*dev;
+	struct clk	*clks[5];
+	u8		clk_cnt;
+};
+
+static int dwc3_mb86s70_clk_control(struct device *dev, bool on)
+{
+	struct dwc3_mb86s70 *priv = dev_get_drvdata(dev);
+	int ret, i = priv->clk_cnt;
+
+	if (!on)
+		goto clock_off;
+
+	for (i = 0; i < priv->clk_cnt; i++) {
+		ret = clk_prepare_enable(priv->clks[i]);
+		if (ret) {
+			dev_err(dev, "failed to enable clock[%d]\n", i);
+			on = ret;
+			goto clock_off;
+		}
+	}
+
+	return 0;
+
+clock_off:
+	for (; i > 0;)
+		clk_disable_unprepare(priv->clks[--i]);
+
+	return on;
+}
+
+static int dwc3_mb86s70_remove_child(struct device *dev, void *unused)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	of_device_unregister(pdev);
+
+	return 0;
+}
+
+static int dwc3_mb86s70_probe(struct platform_device *pdev)
+{
+	struct dwc3_mb86s70	*priv;
+	struct device		*dev = &pdev->dev;
+	struct device_node	*node = dev->of_node;
+	int			ret, i;
+	struct clk		*clk;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, priv);
+	priv->dev = dev;
+
+	dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+
+	for (i = 0; i < ARRAY_SIZE(priv->clks); i++) {
+		clk = of_clk_get(dev->of_node, i);
+		if (IS_ERR(clk))
+			break;
+		priv->clks[i] = clk;
+	}
+	priv->clk_cnt = i;
+	if (!i) {
+		dev_err(dev, "clock not found\n");
+		ret = PTR_ERR(clk);
+		goto err;
+	}
+
+	ret = dwc3_mb86s70_clk_control(dev, true);
+	if (ret)
+		goto err_clk;
+
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get(dev);
+	if (ret < 0) {
+		dev_err(dev, "get_sync failed with err %d\n", ret);
+		ret = -ENODEV;
+		goto err_pm;
+	}
+
+	if (node) {
+		ret = of_platform_populate(node, NULL, NULL, dev);
+		if (!ret)
+			return 0;
+		dev_err(dev, "failed to add dwc3 core\n");
+	}
+	dev_err(dev, "no device node, failed to add dwc3 core\n");
+	ret = -ENODEV;
+
+	pm_runtime_put_sync(dev);
+err_pm:
+	pm_runtime_disable(dev);
+err_clk:
+	for (i = 0; i < priv->clk_cnt; i++)
+		clk_put(priv->clks[i]);
+err:
+
+	return ret;
+}
+
+static int dwc3_mb86s70_remove(struct platform_device *pdev)
+{
+	struct dwc3_mb86s70 *priv = dev_get_drvdata(&pdev->dev);
+	int i;
+
+	device_for_each_child(&pdev->dev, NULL, dwc3_mb86s70_remove_child);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	dwc3_mb86s70_clk_control(&pdev->dev, false);
+
+	for (i = 0; i < priv->clk_cnt ; i++)
+		clk_put(priv->clks[i]);
+
+	return 0;
+}
+
+static const struct of_device_id mb86s70_dwc3_match[] = {
+	{ .compatible = "fujitsu,mb86s70-dwc3" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, mb86s70_dwc3_match);
+
+#ifdef CONFIG_PM_SLEEP
+static int dwc3_mb86s70_suspend(struct device *dev)
+{
+	dwc3_mb86s70_clk_control(dev, false);
+
+	return 0;
+}
+
+static int dwc3_mb86s70_resume(struct device *dev)
+{
+	int ret;
+
+	ret = dwc3_mb86s70_clk_control(dev, true);
+	if (ret)
+		return ret;
+
+	/* runtime set active to reflect active state. */
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops dwc3_mb86s70_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dwc3_mb86s70_suspend, dwc3_mb86s70_resume)
+};
+
+#define DEV_PM_OPS	(&dwc3_mb86s70_dev_pm_ops)
+#else
+#define DEV_PM_OPS	NULL
+#endif /* CONFIG_PM_SLEEP */
+
+static struct platform_driver dwc3_mb86s70_driver = {
+	.probe		= dwc3_mb86s70_probe,
+	.remove		= dwc3_mb86s70_remove,
+	.driver		= {
+		.name	= "mb86s70-dwc3",
+		.of_match_table = of_match_ptr(mb86s70_dwc3_match),
+		.pm	= DEV_PM_OPS,
+	},
+};
+
+module_platform_driver(dwc3_mb86s70_driver);
+
+MODULE_ALIAS("platform:mb86s70-dwc3");
+MODULE_AUTHOR("Alice Chan <Alice.Chan@tw.fujitsu.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DesignWare USB3 mb86s70 Glue Layer");
-- 
1.7.9.5

