Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaLPCLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:11:32 -0500
Received: from mail-pd0-f195.google.com ([209.85.192.195]:35266 "EHLO pdbft15"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbaLPCL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:11:28 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Date: Tue, 16 Dec 2014 10:10:27 +0800
Message-Id: <1418695828-605-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Synopsis DesignWare USB3 IP Core found
on Fujitsu Socs.

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   25 +++
 drivers/usb/dwc3/Kconfig                           |   11 ++
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-mb86s70.c                    |  194 ++++++++++++++++++++
 4 files changed, 231 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
 create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c

diff --git a/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
new file mode 100644
index 0000000..df77f91
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
@@ -0,0 +1,25 @@
+FUJITSU GLUE COMPONENTS
+
+MB86S7x DWC3 GLUE
+ - compatible : Should be "fujitsu,mb86s70-dwc3"
+ - clocks: from common clock binding, handle to usb clock.
+ - clock-names: from common clock binding.
+ - #address-cells, #size-cells : Must be present if the device has sub-nodes
+ - ranges: the child address space are mapped 1:1 onto the parent address space
+ - #stream-id-cells : handle to use "arm,mmu-400" ARM IOMMU driver
+
+Sub-nodes:
+The dwc3 core should be added as subnode to MB86S7x dwc3 glue.
+- dwc3 :
+   The binding details of dwc3 can be found in:
+   Documentation/devicetree/bindings/usb/dwc3.txt
+
+usb3host: mb86s70_usb3host {
+	compatible = "fujitsu,mb86s70-dwc3";
+	clocks = <&clk_alw_1_1>;
+	clock-names = "bus_clk";
+	#address-cells = <2>;
+	#size-cells = <1>;
+	ranges;
+	#stream-id-cells = <0>;
+};
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
index 0000000..241c5bd
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-mb86s70.c
@@ -0,0 +1,194 @@
+/**
+ * dwc3-mb86s70.c - Fujitsu mb86s70 DWC3 Specific Glue layer
+ *
+ * Copyright (c) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED
+ *		http://jp.fujitsu.com/group/fsl
+ *
+ * Author: Alice Chan <Alice.Chan@tw.fujitsu.com>
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
+	struct clk		**clk_table;
+};
+
+/* return 0 means successful */
+static int dwc3_mb86s70_clk_control(struct device *dev, bool on)
+{
+	int ret, i;
+	struct clk *clk;
+
+	if (!on)
+		goto clock_off;
+
+	for (i = 0;; i++) {
+		clk = of_clk_get(dev->of_node, i);
+		if (IS_ERR(clk))
+			break;
+
+		ret = clk_prepare_enable(clk);
+		if (ret) {
+			dev_err(dev, "failed to enable clock[%d]\n", i);
+			goto clock_off;
+		}
+	}
+
+	return 0;
+
+clock_off:
+	for (i = 0;; i++) {
+		clk = of_clk_get(dev->of_node, i);
+		if (IS_ERR(clk))
+			break;
+
+		clk_disable_unprepare(clk);
+	}
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
+static u64 dwc3_mb86s70_dma_mask = DMA_BIT_MASK(32);
+
+static int dwc3_mb86s70_probe(struct platform_device *pdev)
+{
+	struct dwc3_mb86s70	*mb86s70;
+	struct device		*dev = &pdev->dev;
+	struct device_node	*node = dev->of_node;
+	int			ret;
+
+	mb86s70 = devm_kzalloc(dev, sizeof(*mb86s70), GFP_KERNEL);
+	if (!mb86s70) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->dma_mask = &dwc3_mb86s70_dma_mask;
+
+	platform_set_drvdata(pdev, mb86s70);
+
+	mb86s70->dev = dev;
+
+	/* resume driver for clock, power */
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "get_sync failed with err %d\n", ret);
+		goto err;
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
+err:
+	return ret;
+}
+
+static int dwc3_mb86s70_remove(struct platform_device *pdev)
+{
+	device_for_each_child(&pdev->dev, NULL, dwc3_mb86s70_remove_child);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
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
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_RUNTIME
+static int dwc3_mb86s70_runtime_suspend(struct device *dev)
+{
+	dwc3_mb86s70_clk_control(dev, false);
+
+	return 0;
+}
+
+static int  dwc3_mb86s70_runtime_resume(struct device *dev)
+{
+	dwc3_mb86s70_clk_control(dev, true);
+
+	return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+static int dwc3_mb86s70_suspend(struct device *dev)
+{
+	if (pm_runtime_status_suspended(dev))
+		return 0;
+
+	return dwc3_mb86s70_runtime_suspend(dev);
+}
+
+static int dwc3_mb86s70_resume(struct device *dev)
+{
+	if (pm_runtime_status_suspended(dev))
+		return 0;
+
+	return dwc3_mb86s70_runtime_resume(dev);
+}
+
+static const struct dev_pm_ops dwc3_mb86s70_dev_pm_ops = {
+	.suspend = dwc3_mb86s70_suspend,
+	.resume = dwc3_mb86s70_resume,
+	SET_RUNTIME_PM_OPS(
+		dwc3_mb86s70_runtime_suspend,
+		dwc3_mb86s70_runtime_resume, NULL)
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

