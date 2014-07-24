Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaGXLAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:00:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62799 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaGXLAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:00:44 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org
Subject: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Date: Thu, 24 Jul 2014 12:00:14 +0100
Message-Id: <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the USB HCD present in STi
SoC's from STMicroelectronics. It has been tested on the
stih416-b2020 board.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/usb/host/Kconfig  |  12 ++
 drivers/usb/host/Makefile |   1 +
 drivers/usb/host/st-hcd.c | 460 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 473 insertions(+)
 create mode 100644 drivers/usb/host/st-hcd.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 61b7817..a5e7f71 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -753,6 +753,18 @@ config USB_HCD_SSB
 
 	  If unsure, say N.
 
+config USB_HCD_ST
+	tristate "STMicroelectronics STi family HCD support"
+	depends on ARCH_STI && OF
+	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
+	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
+	select GENERIC_PHY
+	help
+	  Enable support for the EHCI and OHCI host controller on ST
+	  consumer electronics SoCs.
+
+	  If unsure, say N.
+
 config USB_HCD_TEST_MODE
 	bool "HCD test mode support"
 	---help---
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index af89a90..af0b81d 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -74,3 +74,4 @@ obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
 obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
 obj-$(CONFIG_USB_FOTG210_HCD)	+= fotg210-hcd.o
 obj-$(CONFIG_USB_MAX3421_HCD)	+= max3421-hcd.o
+obj-$(CONFIG_USB_HCD_ST)	+= st-hcd.o
diff --git a/drivers/usb/host/st-hcd.c b/drivers/usb/host/st-hcd.c
new file mode 100644
index 0000000..eaec345
--- /dev/null
+++ b/drivers/usb/host/st-hcd.c
@@ -0,0 +1,460 @@
+/*
+ * STMicroelectronics HCD (Host Controller Driver) for USB 2.0 and 1.1.
+ *
+ * Copyright (c) 2013 STMicroelectronics (R&D) Ltd.
+ * Authors: Stephen Gallimore <stephen.gallimore@st.com>
+ *          Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
+#include <linux/delay.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/reset.h>
+#include <linux/phy/phy.h>
+#include <linux/usb/ohci_pdriver.h>
+#include <linux/usb/ehci_pdriver.h>
+
+#include "ohci.h"
+
+#define EHCI_CAPS_SIZE 0x10
+#define AHB2STBUS_INSREG01 (EHCI_CAPS_SIZE + 0x84)
+
+struct st_hcd_dev {
+	int port_nr;
+	struct platform_device *ehci_device;
+	struct platform_device *ohci_device;
+	struct clk *ic_clk;
+	struct clk *ohci_clk;
+	struct reset_control *pwr;
+	struct reset_control *rst;
+	struct phy *phy;
+};
+
+static inline void st_ehci_configure_bus(void __iomem *regs)
+{
+	/* Set EHCI packet buffer IN/OUT threshold to 128 bytes */
+	u32 threshold = 128 | (128 << 16);
+
+	writel(threshold, regs + AHB2STBUS_INSREG01);
+}
+
+static int st_hcd_enable_clocks(struct device *dev,
+				struct st_hcd_dev *hcd_dev)
+{
+	int err;
+
+	/*
+	 * The interconnect input clock have either a fixed
+	 * rate or the rate is defined on boot, so we are only concerned about
+	 * enabling any gates for this clock.
+	 */
+	err = clk_prepare_enable(hcd_dev->ic_clk);
+	if (err) {
+		dev_err(dev, "can't enable ic clock\n");
+		return err;
+	}
+
+	/*
+	 * The 48MHz OHCI clock is usually provided by a programmable
+	 * frequency synthesizer, which is often not programmed on boot/chip
+	 * reset, so we set its rate here to ensure it is correct.
+	 *
+	 * However not all SoC's have a dedicated OHCI clock so it isn't fatal
+	 * for this not to exist.
+	 */
+	if (!hcd_dev->ohci_clk)
+		return 0;
+
+	err = clk_set_rate(hcd_dev->ohci_clk, 48000000);
+	if (err) {
+		dev_err(dev, "can't set OHCI clock rate\n");
+		goto error;
+	}
+	err = clk_prepare_enable(hcd_dev->ohci_clk);
+	if (err) {
+		dev_err(dev, "can't enable OHCI clock\n");
+		goto error;
+	}
+
+	return 0;
+error:
+	clk_disable_unprepare(hcd_dev->ic_clk);
+	return err;
+}
+
+static void st_hcd_disable_clocks(struct st_hcd_dev *hcd_dev)
+{
+	clk_disable_unprepare(hcd_dev->ohci_clk);
+	clk_disable_unprepare(hcd_dev->ic_clk);
+}
+
+static void st_hcd_assert_resets(struct device *dev,
+				struct st_hcd_dev *hcd_dev)
+{
+	int err;
+
+	err = reset_control_assert(hcd_dev->pwr);
+	if (err)
+		dev_err(dev, "unable to put into powerdown\n");
+
+	err = reset_control_assert(hcd_dev->rst);
+	if (err)
+		dev_err(dev, "unable to put into softreset\n");
+}
+
+static int st_hcd_deassert_resets(struct device *dev,
+				struct st_hcd_dev *hcd_dev)
+{
+	int err;
+
+	err = reset_control_deassert(hcd_dev->pwr);
+	if (err) {
+		dev_err(dev, "unable to bring out of powerdown\n");
+		return err;
+	}
+
+	err = reset_control_deassert(hcd_dev->rst);
+	if (err) {
+		dev_err(dev, "unable to bring out of softreset\n");
+		reset_control_assert(hcd_dev->pwr);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct usb_ehci_pdata ehci_pdata = {
+};
+
+static const struct usb_ohci_pdata ohci_pdata = {
+};
+
+static struct platform_device *st_hcd_device_create(const char *name, int id,
+		struct platform_device *parent)
+{
+	struct platform_device *pdev;
+	const char *platform_name;
+	struct resource *res;
+	struct resource hcd_res[2];
+	int ret;
+
+	res = platform_get_resource_byname(parent, IORESOURCE_MEM, name);
+	if (!res)
+		return ERR_PTR(-ENODEV);
+
+	hcd_res[0] = *res;
+
+	res = platform_get_resource_byname(parent, IORESOURCE_IRQ, name);
+	if (!res)
+		return ERR_PTR(-ENODEV);
+
+	hcd_res[1] = *res;
+
+	platform_name = kasprintf(GFP_KERNEL, "%s-platform", name);
+	if (!platform_name)
+		return ERR_PTR(-ENOMEM);
+
+	pdev = platform_device_alloc(platform_name, id);
+
+	kfree(platform_name);
+
+	if (!pdev)
+		return ERR_PTR(-ENOMEM);
+
+	pdev->dev.parent = &parent->dev;
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
+	ret = platform_device_add_resources(pdev, hcd_res, ARRAY_SIZE(hcd_res));
+	if (ret)
+		goto error;
+
+	if (!strcmp(name, "ohci"))
+		ret = platform_device_add_data(pdev, &ohci_pdata,
+					       sizeof(ohci_pdata));
+	else
+		ret = platform_device_add_data(pdev, &ehci_pdata,
+					       sizeof(ehci_pdata));
+
+	if (ret)
+		goto error;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto error;
+
+	return pdev;
+
+error:
+	platform_device_put(pdev);
+	return ERR_PTR(ret);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int st_hcd_resume(struct device *dev)
+{
+	struct st_hcd_dev *hcd_dev = dev_get_drvdata(dev);
+	struct usb_hcd *ehci_hcd = platform_get_drvdata(hcd_dev->ehci_device);
+	int err;
+
+	pinctrl_pm_select_default_state(dev);
+
+	err = st_hcd_enable_clocks(dev, hcd_dev);
+	if (err)
+		return err;
+
+	err = phy_init(hcd_dev->phy);
+	if (err) {
+		dev_err(dev, "phy initialization failed\n");
+		goto err_disable_clocks;
+	}
+
+	err = phy_power_on(hcd_dev->phy);
+	if (err && (err != -ENOTSUPP)) {
+		dev_err(dev, "phy power on failed\n");
+		goto err_phy_exit;
+	}
+
+	err = st_hcd_deassert_resets(dev, hcd_dev);
+	if (err)
+		goto err_phy_off;
+
+	st_ehci_configure_bus(ehci_hcd->regs);
+
+	return 0;
+
+err_phy_off:
+	phy_power_off(hcd_dev->phy);
+err_phy_exit:
+	phy_exit(hcd_dev->phy);
+err_disable_clocks:
+	st_hcd_disable_clocks(hcd_dev);
+
+	return err;
+}
+
+static int st_hcd_suspend(struct device *dev)
+{
+	struct st_hcd_dev *hcd_dev = dev_get_drvdata(dev);
+	int err;
+
+	err = reset_control_assert(hcd_dev->pwr);
+	if (err) {
+		dev_err(dev, "unable to put into powerdown\n");
+		return err;
+	}
+
+	err = reset_control_assert(hcd_dev->rst);
+	if (err) {
+		dev_err(dev, "unable to put into softreset\n");
+		return err;
+	}
+
+	err = phy_power_off(hcd_dev->phy);
+	if (err && (err != -ENOTSUPP)) {
+		dev_err(dev, "phy power off failed\n");
+		return err;
+	}
+
+	phy_exit(hcd_dev->phy);
+
+	st_hcd_disable_clocks(hcd_dev);
+
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(st_hcd_pm, st_hcd_suspend, st_hcd_resume);
+
+static int st_hcd_probe_clocks(struct device *dev,
+				struct st_hcd_dev *hcd_dev)
+{
+	hcd_dev->ic_clk = devm_clk_get(dev, "ic");
+	if (IS_ERR(hcd_dev->ic_clk)) {
+		dev_err(dev, "ic clock not found\n");
+		return PTR_ERR(hcd_dev->ic_clk);
+	}
+
+	/* Some SoCs don't have a dedicated ohci clk */
+	hcd_dev->ohci_clk = devm_clk_get(dev, "ohci");
+	if (IS_ERR(hcd_dev->ohci_clk)) {
+		hcd_dev->ohci_clk = NULL;
+		dev_info(dev, "48MHz OHCI clock not found\n");
+	}
+
+	return st_hcd_enable_clocks(dev, hcd_dev);
+}
+
+
+static int st_hcd_probe_resets(struct device *dev,
+				struct st_hcd_dev *hcd_dev)
+{
+	hcd_dev->pwr = devm_reset_control_get(dev, "powerdown");
+	if (IS_ERR(hcd_dev->pwr)) {
+		dev_err(dev, "power reset control not found\n");
+		return PTR_ERR(hcd_dev->pwr);
+	}
+
+	hcd_dev->rst = devm_reset_control_get(dev, "softreset");
+	if (IS_ERR(hcd_dev->rst)) {
+		dev_err(dev, "soft reset control not found\n");
+		return PTR_ERR(hcd_dev->rst);
+	}
+
+	return st_hcd_deassert_resets(dev, hcd_dev);
+}
+
+static int st_hcd_probe_ehci_setup(struct platform_device *pdev)
+{
+	struct resource *res;
+	void __iomem *ehci_regs;
+
+	/*
+	 * We need to do some integration specific setup in the EHCI
+	 * controller, which the EHCI platform driver does not provide any
+	 * hooks to allow us to do during its initialisation.
+	 */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ehci");
+	ehci_regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ehci_regs))
+		return PTR_ERR(ehci_regs);
+
+	st_ehci_configure_bus(ehci_regs);
+	devm_iounmap(&pdev->dev, ehci_regs);
+
+	return 0;
+}
+
+static int st_hcd_remove(struct platform_device *pdev)
+{
+	struct st_hcd_dev *hcd_dev = platform_get_drvdata(pdev);
+
+	platform_device_unregister(hcd_dev->ehci_device);
+	platform_device_unregister(hcd_dev->ohci_device);
+
+	phy_power_off(hcd_dev->phy);
+
+	phy_exit(hcd_dev->phy);
+
+	st_hcd_assert_resets(&pdev->dev, hcd_dev);
+
+	st_hcd_disable_clocks(hcd_dev);
+
+	return 0;
+}
+
+static int st_hcd_probe(struct platform_device *pdev)
+{
+	struct st_hcd_dev *hcd_dev;
+	int id;
+	int err;
+
+	id = of_alias_get_id(pdev->dev.of_node, "usb");
+	if (id < 0) {
+		dev_err(&pdev->dev, "No ID specified via DT alias\n");
+		return -ENODEV;
+	}
+
+	hcd_dev = devm_kzalloc(&pdev->dev, sizeof(*hcd_dev), GFP_KERNEL);
+	if (!hcd_dev)
+		return -ENOMEM;
+
+	hcd_dev->port_nr = id;
+
+	err = st_hcd_probe_clocks(&pdev->dev, hcd_dev);
+	if (err)
+		return err;
+
+	err = st_hcd_probe_resets(&pdev->dev, hcd_dev);
+	if (err)
+		goto err_disable_clocks;
+
+	err = st_hcd_probe_ehci_setup(pdev);
+	if (err)
+		goto err_assert_resets;
+
+	hcd_dev->phy = devm_phy_get(&pdev->dev, "usb2-phy");
+	if (IS_ERR(hcd_dev->phy)) {
+		dev_err(&pdev->dev, "no PHY configured\n");
+		err = PTR_ERR(hcd_dev->phy);
+		goto err_assert_resets;
+	}
+
+	err = phy_init(hcd_dev->phy);
+	if (err) {
+		dev_err(&pdev->dev, "phy initialization failed\n");
+		goto err_assert_resets;
+	}
+
+	err = phy_power_on(hcd_dev->phy);
+	if (err && (err != -ENOTSUPP)) {
+		dev_err(&pdev->dev, "phy power on failed\n");
+		goto err_phy_exit;
+	}
+
+	hcd_dev->ehci_device = st_hcd_device_create("ehci", id, pdev);
+	if (IS_ERR(hcd_dev->ehci_device)) {
+		err = PTR_ERR(hcd_dev->ehci_device);
+		goto err_phy_off;
+	}
+
+	hcd_dev->ohci_device = st_hcd_device_create("ohci", id, pdev);
+	if (IS_ERR(hcd_dev->ohci_device)) {
+		err = PTR_ERR(hcd_dev->ohci_device);
+		goto err_remove_ehci;
+	}
+
+	platform_set_drvdata(pdev, hcd_dev);
+
+	return 0;
+
+err_remove_ehci:
+	platform_device_del(hcd_dev->ehci_device);
+err_phy_off:
+	phy_power_off(hcd_dev->phy);
+err_phy_exit:
+	phy_exit(hcd_dev->phy);
+err_assert_resets:
+	st_hcd_assert_resets(&pdev->dev, hcd_dev);
+err_disable_clocks:
+	st_hcd_disable_clocks(hcd_dev);
+
+	return err;
+}
+
+static const struct of_device_id st_hcd_match[] = {
+	{ .compatible = "st,usb-300x" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, st_hcd_match);
+
+static struct platform_driver st_hcd_driver = {
+	.probe = st_hcd_probe,
+	.remove = st_hcd_remove,
+	.driver = {
+		.name = "st-hcd",
+		.pm = &st_hcd_pm,
+		.of_match_table = st_hcd_match,
+	},
+};
+
+module_platform_driver(st_hcd_driver);
+
+MODULE_DESCRIPTION("STMicroelectronics On-Chip USB Host Controller");
+MODULE_AUTHOR("Stephen Gallimore <stephen.gallimore@st.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

