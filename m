Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaLPCLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:11:25 -0500
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34259 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaLPCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:11:21 -0500
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
Subject: [PATCH 1/3] usb: host: f_usb20ho: add support for Fujitsu ehci/ohci USB 2.0 host controller
Date: Tue, 16 Dec 2014 10:10:26 +0800
Message-Id: <1418695828-605-2-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for EHCI compliant Host controller found
on Fujitsu Socs.

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 .../devicetree/bindings/usb/fujitsu-ehci.txt       |   22 ++
 drivers/usb/host/Kconfig                           |   11 +
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/f_usb20ho_hcd.c                   |  306 ++++++++++++++++++++
 drivers/usb/host/f_usb20ho_hcd.h                   |   35 +++
 5 files changed, 375 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-ehci.txt
 create mode 100644 drivers/usb/host/f_usb20ho_hcd.c
 create mode 100644 drivers/usb/host/f_usb20ho_hcd.h

diff --git a/Documentation/devicetree/bindings/usb/fujitsu-ehci.txt b/Documentation/devicetree/bindings/usb/fujitsu-ehci.txt
new file mode 100644
index 0000000..e180860
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/fujitsu-ehci.txt
@@ -0,0 +1,22 @@
+FUJITSU GLUE COMPONENTS
+
+MB86S7x EHCI GLUE
+ - compatible : Should be "fujitsu,f_usb20ho_hcd"
+ - reg : Address and length of the register set for the device.
+ - interrupts : The irq number of this device that is used to interrupt the
+   CPU
+ - clocks: from common clock binding, handle to usb clock.
+ - clock-names: from common clock binding.
+ - #stream-id-cells : handle to use "arm,mmu-400" ARM IOMMU driver
+ - fujitsu,power-domain : pd_usb2h node has to be builded, details can be
+   found in:
+   Documentation/devicetree/bindings/
+
+hcd21: f_usb20ho_hcd {
+	compatible = "fujitsu,f_usb20ho_hcd";
+	reg = <0 0x34200000 0x80000>;
+	interrupts = <0 419 0x4>;
+	clocks = <&clk_main_2_4>, <&clk_main_4_5>, <&clk_usb_0_0>;
+	clock-names = "h_clk", "p_clk", "p_cryclk";
+	#stream-id-cells = <0>;
+};
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index fafc628..9482140 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -786,6 +786,17 @@ config USB_HCD_SSB
 
 	  If unsure, say N.
 
+config USB_F_USB20HO_HCD
+	tristate "F_USB20HO USB Host Controller"
+	depends on USB && ARCH_MB86S7X
+	default y
+	help
+	  This driver enables support for USB20HO USB Host Controller,
+	  the driver supports High, Full and Low Speed USB.
+
+	  To compile this driver a module, choose M here: the module
+	  will be called "f_usb20ho-hcd".
+
 config USB_HCD_TEST_MODE
 	bool "HCD test mode support"
 	---help---
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index d6216a4..b89e536 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
 obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
 obj-$(CONFIG_USB_FOTG210_HCD)	+= fotg210-hcd.o
 obj-$(CONFIG_USB_MAX3421_HCD)	+= max3421-hcd.o
+obj-$(CONFIG_USB_F_USB20HO_HCD)+= f_usb20ho_hcd.o
diff --git a/drivers/usb/host/f_usb20ho_hcd.c b/drivers/usb/host/f_usb20ho_hcd.c
new file mode 100644
index 0000000..d665487
--- /dev/null
+++ b/drivers/usb/host/f_usb20ho_hcd.c
@@ -0,0 +1,306 @@
+/**
+ * f_usb20ho_hcd.c - Fujitsu EHCI platform driver
+ *
+ * Copyright (c) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED
+ *		http://jp.fujitsu.com/group/fsl
+ *
+ * based on bcma-hcd.c
+ *
+ * Author: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/ohci_pdriver.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include "f_usb20ho_hcd.h"
+
+static int f_usb20ho_clk_control(struct device *dev, bool on)
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
+static struct platform_device *f_usb20ho_hcd_create_pdev(
+		struct platform_device *pdev, bool ohci)
+{
+	struct resource *resource;
+	struct platform_device *hci_dev;
+	struct resource hci_res[2];
+	int ret = -ENOMEM;
+	int irq;
+	resource_size_t resource_size;
+
+	memset(hci_res, 0, sizeof(hci_res));
+
+	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!resource) {
+		dev_err(&pdev->dev, "%s() platform_get_resource() failed\n"
+			, __func__);
+		ret = -ENODEV;
+		goto err_res;
+	}
+	resource_size = resource->end - resource->start + 1;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev,
+			"%s() platform_get_irq() for F_USB20HO failed at %d\n",
+			__func__, irq);
+		ret = -ENODEV;
+		goto err_res;
+	}
+
+	hci_res[0].start = ohci ? resource->start + F_OHCI_OFFSET :
+		resource->start + F_EHCI_OFFSET;
+	hci_res[0].end = ohci ?
+			resource->start + F_OHCI_OFFSET + F_OHCI_SIZE - 1 :
+			resource->start + F_EHCI_OFFSET + F_EHCI_SIZE - 1;
+	hci_res[0].flags = IORESOURCE_MEM;
+
+	hci_res[1].start = irq;
+	hci_res[1].flags = IORESOURCE_IRQ;
+
+	hci_dev = platform_device_alloc(ohci ? "ohci-platform" :
+					"ehci-platform", 0);
+	if (!hci_dev) {
+		dev_err(&pdev->dev, "platform_device_alloc() failed\n");
+		ret = -ENODEV;
+		goto err_res;
+	}
+
+	dma_set_coherent_mask(&hci_dev->dev, pdev->dev.coherent_dma_mask);
+	hci_dev->dev.parent = &pdev->dev;
+	hci_dev->dev.dma_mask = pdev->dev.dma_mask;
+
+	ret = platform_device_add_resources(hci_dev, hci_res,
+					    ARRAY_SIZE(hci_res));
+	if (ret) {
+		dev_err(&pdev->dev
+			, "platform_device_add_resources() failed\n");
+		goto err_alloc;
+	}
+
+	ret = platform_device_add(hci_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "platform_device_add() failed\n");
+		goto err_alloc;
+	}
+
+	return hci_dev;
+
+err_alloc:
+	platform_device_put(hci_dev);
+err_res:
+	return ERR_PTR(ret);
+}
+
+static u64 f_usb20ho_dma_mask =  DMA_BIT_MASK(32);
+
+static int f_usb20ho_hcd_probe(struct platform_device *pdev)
+{
+	int err;
+	struct f_usb20ho_hcd *usb_dev;
+	struct device *dev = &pdev->dev;
+
+	dev->dma_mask = &f_usb20ho_dma_mask;
+	if (!dev->coherent_dma_mask)
+		dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	usb_dev = kzalloc(sizeof(*usb_dev), GFP_KERNEL);
+	if (!usb_dev)
+		return -ENOMEM;
+
+	usb_dev->dev = &pdev->dev;
+	platform_set_drvdata(pdev, usb_dev);
+
+	usb_dev->irq = platform_get_irq(pdev, 0);
+	if (usb_dev->irq < 0) {
+		dev_err(&pdev->dev,
+			"%s() platform_get_irq() for F_USB20HO failed at %d\n",
+			__func__, usb_dev->irq);
+		err = -ENODEV;
+		goto err_free_usb_dev;
+	}
+	disable_irq(usb_dev->irq);
+
+	/* resume driver for clock, power, irq */
+	pm_runtime_enable(&pdev->dev);
+	err = pm_runtime_get_sync(&pdev->dev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "get_sync failed with err %d\n", err);
+		goto err_unregister_ohci_dev;
+	}
+
+	usb_dev->ehci_dev = f_usb20ho_hcd_create_pdev(pdev, false);
+	if (IS_ERR(usb_dev->ehci_dev)) {
+		dev_err(&pdev->dev, "failed to create EHCI driver\n");
+		err = -ENODEV;
+		goto err_free_usb_dev;
+	}
+
+	usb_dev->ohci_dev = f_usb20ho_hcd_create_pdev(pdev, true);
+	if (IS_ERR(usb_dev->ohci_dev)) {
+		dev_err(&pdev->dev, "failed to create OHCI driver\n");
+		err = -ENODEV;
+		goto err_unregister_ehci_dev;
+	}
+
+	return 0;
+
+err_unregister_ohci_dev:
+	platform_device_unregister(usb_dev->ohci_dev);
+err_unregister_ehci_dev:
+	platform_device_unregister(usb_dev->ehci_dev);
+	pm_runtime_put_sync(&pdev->dev);
+err_free_usb_dev:
+	kfree(usb_dev);
+
+	return err;
+}
+
+static int f_usb20ho_hcd_remove(struct platform_device *pdev)
+{
+	struct f_usb20ho_hcd *usb_dev = platform_get_drvdata(pdev);
+	struct platform_device *ohci_dev = usb_dev->ohci_dev;
+	struct platform_device *ehci_dev = usb_dev->ehci_dev;
+
+	if (ohci_dev)
+		platform_device_unregister(ohci_dev);
+	if (ehci_dev)
+		platform_device_unregister(ehci_dev);
+
+	/* disable power,clock,irq */
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_RUNTIME
+static int  f_usb20ho_runtime_suspend(struct device *dev)
+{
+	struct f_usb20ho_hcd *usb_dev = dev_get_drvdata(dev);
+
+	disable_irq(usb_dev->irq);
+	f_usb20ho_clk_control(dev, false);
+
+	return 0;
+}
+
+static int  f_usb20ho_runtime_resume(struct device *dev)
+{
+	struct f_usb20ho_hcd *usb_dev = dev_get_drvdata(dev);
+
+	f_usb20ho_clk_control(dev, true);
+	enable_irq(usb_dev->irq);
+
+	return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+static int f_usb20ho_hcd_suspend(struct device *dev)
+{
+	if (pm_runtime_status_suspended(dev))
+		return 0;
+
+	return f_usb20ho_runtime_suspend(dev);
+}
+
+static int f_usb20ho_hcd_resume(struct device *dev)
+{
+	if (pm_runtime_status_suspended(dev))
+		return 0;
+
+	return f_usb20ho_runtime_resume(dev);
+}
+
+static const struct dev_pm_ops f_usb20ho_hcd_ops = {
+	.suspend =  f_usb20ho_hcd_suspend,
+	.resume = f_usb20ho_hcd_resume,
+	SET_RUNTIME_PM_OPS(f_usb20ho_runtime_suspend
+		, f_usb20ho_runtime_resume, NULL)
+};
+
+#define DEV_PM (&f_usb20ho_hcd_ops)
+#else /* !CONFIG_PM */
+#define DEV_PM	NULL
+#endif /* CONFIG_PM */
+
+static void f_usb20ho_hcd_shutdown(struct platform_device *pdev)
+{
+#ifdef CONFIG_PM
+	 f_usb20ho_hcd_suspend(&pdev->dev);
+#endif
+}
+
+static const struct of_device_id f_usb20ho_hcd_dt_ids[] = {
+	{ .compatible = "fujitsu,f_usb20ho_hcd" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, f_usb20ho_hcd_dt_ids);
+
+static struct platform_driver f_usb20ho_hcd_driver = {
+	.probe		= f_usb20ho_hcd_probe,
+	.remove		= __exit_p(f_usb20ho_hcd_remove),
+	.shutdown	= f_usb20ho_hcd_shutdown,
+	.driver = {
+		.name = "f_usb20ho_hcd",
+		.owner = THIS_MODULE,
+		.pm = DEV_PM,
+		.of_match_table = f_usb20ho_hcd_dt_ids,
+	},
+};
+
+module_platform_driver(f_usb20ho_hcd_driver);
+
+MODULE_ALIAS("platform:f_usb20ho_hcd");
+MODULE_AUTHOR("Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("USB platform driver for f_usb20ho_lap IP ");
diff --git a/drivers/usb/host/f_usb20ho_hcd.h b/drivers/usb/host/f_usb20ho_hcd.h
new file mode 100644
index 0000000..046c636
--- /dev/null
+++ b/drivers/usb/host/f_usb20ho_hcd.h
@@ -0,0 +1,35 @@
+/*
+ * linux/drivers/usb/host/f_usb20ho_hcd.h - F_USB20HDC USB
+ * host controller driver
+ *
+ * Copyright (C) FUJITSU ELECTRONICS INC. 2011. All rights reserved.
+ * Copyright (C) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _F_USB20HO_HCD_H
+#define _F_USB20HO_HCD_H
+
+#define F_EHCI_OFFSET	0x40000
+#define F_EHCI_SIZE		0x1000
+#define F_OHCI_OFFSET	0x41000
+#define F_OHCI_SIZE		0x1000
+#define F_OTHER_OFFSET	0x42000
+#define F_OTHER_SIZE		0x1000
+
+struct f_usb20ho_hcd {
+	struct device *dev;
+	struct platform_device *ehci_dev;
+	struct platform_device *ohci_dev;
+	int irq;
+};
+#endif
-- 
1.7.9.5

