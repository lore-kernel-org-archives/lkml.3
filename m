Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3EPOWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:22:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2073 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3EPOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:22:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 May 2013 07:22:34 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 8/8] usb: phy: registering Tegra USB PHY as platform driver
Date: Thu, 16 May 2013 19:43:02 +0530
Message-ID: <1368713582-29038-9-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registered Tegra USB PHY as a separate platform driver.

To synchronize host controller and PHY initialization, used deferred
probe mechanism. As PHY should be initialized before EHCI starts running,
deferred probe of Tegra EHCI driver till PHY probe gets completed.

Got rid of instance number based handling in host driver.

Made use of DT params to get the PHY Pad registers.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v3:
Removed functions pointers to access PORTSC registers from PHY & accessing
them from PHY using exported functions.

delta from v2:
Rebased to TOT and applied same changes as on v2.

delta from v1:
1. Removed extra memory allocation for u_phy->otg
2. Moved ulpi_init code into separate function.
3. Initializing all clk and GPIOs in probe.
4. Used devm_  APIs wherever possible.

 drivers/usb/host/ehci-tegra.c     |  104 +++++-------
 drivers/usb/phy/phy-tegra-usb.c   |  325 ++++++++++++++++++++-----------------
 include/linux/usb/tegra_usb_phy.h |   11 +-
 3 files changed, 230 insertions(+), 210 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 568a6fa..c8ee919 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -611,7 +611,7 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
 /* Bits of PORTSC1, which will get cleared by writing 1 into them */
 #define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
 
-static void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -622,8 +622,9 @@ static void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
 
-static void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -636,6 +637,7 @@ static void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 		val &= ~TEGRA_USB_PORTSC1_PHCD;
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
 
 static u64 tegra_ehci_dma_mask = DMA_BIT_MASK(32);
 
@@ -647,7 +649,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	struct tegra_ehci_platform_data *pdata;
 	int err = 0;
 	int irq;
-	int instance = pdev->id;
+	struct device_node *np_phy;
 	struct usb_phy *u_phy;
 
 	pdata = pdev->dev.platform_data;
@@ -670,38 +672,49 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (!tegra)
 		return -ENOMEM;
 
-	hcd = usb_create_hcd(&tegra_ehci_hc_driver, &pdev->dev,
-					dev_name(&pdev->dev));
-	if (!hcd) {
-		dev_err(&pdev->dev, "Unable to create HCD\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(pdev, tegra);
-
 	tegra->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(tegra->clk)) {
 		dev_err(&pdev->dev, "Can't get ehci clock\n");
-		err = PTR_ERR(tegra->clk);
-		goto fail_clk;
+		return PTR_ERR(tegra->clk);
 	}
 
 	err = clk_prepare_enable(tegra->clk);
 	if (err)
-		goto fail_clk;
+		return err;
 
 	tegra_periph_reset_assert(tegra->clk);
 	udelay(1);
 	tegra_periph_reset_deassert(tegra->clk);
 
+	np_phy = of_parse_phandle(pdev->dev.of_node, "nvidia,phy", 0);
+	if (!np_phy) {
+		err = -ENODEV;
+		goto cleanup_clk;
+	}
+
+	u_phy = tegra_usb_get_phy(np_phy);
+	if (IS_ERR(u_phy)) {
+		err = PTR_ERR(u_phy);
+		goto cleanup_clk;
+	}
+
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
 
+	hcd = usb_create_hcd(&tegra_ehci_hc_driver, &pdev->dev,
+					dev_name(&pdev->dev));
+	if (!hcd) {
+		dev_err(&pdev->dev, "Unable to create HCD\n");
+		err = -ENOMEM;
+		goto cleanup_clk;
+	}
+	hcd->phy = u_phy;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get I/O memory\n");
 		err = -ENXIO;
-		goto fail_io;
+		goto cleanup_hcd_create;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
@@ -709,57 +722,28 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (!hcd->regs) {
 		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
 		err = -ENOMEM;
-		goto fail_io;
-	}
-
-	/* This is pretty ugly and needs to be fixed when we do only
-	 * device-tree probing. Old code relies on the platform_device
-	 * numbering that we lack for device-tree-instantiated devices.
-	 */
-	if (instance < 0) {
-		switch (res->start) {
-		case TEGRA_USB_BASE:
-			instance = 0;
-			break;
-		case TEGRA_USB2_BASE:
-			instance = 1;
-			break;
-		case TEGRA_USB3_BASE:
-			instance = 2;
-			break;
-		default:
-			err = -ENODEV;
-			dev_err(&pdev->dev, "unknown usb instance\n");
-			goto fail_io;
-		}
+		goto cleanup_hcd_create;
 	}
 
-	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
-					pdata->phy_config,
-					tegra_ehci_set_pts,
-					tegra_ehci_set_phcd);
-	if (IS_ERR(tegra->phy)) {
-		dev_err(&pdev->dev, "Failed to open USB phy\n");
-		err = -ENXIO;
-		goto fail_io;
+	err = usb_phy_init(hcd->phy);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize phy\n");
+		goto cleanup_hcd_create;
 	}
 
-	hcd->phy = u_phy = &tegra->phy->u_phy;
-	usb_phy_init(hcd->phy);
-
 	u_phy->otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
 			     GFP_KERNEL);
 	if (!u_phy->otg) {
 		dev_err(&pdev->dev, "Failed to alloc memory for otg\n");
 		err = -ENOMEM;
-		goto fail_io;
+		goto cleanup_phy;
 	}
 	u_phy->otg->host = hcd_to_bus(hcd);
 
 	err = usb_phy_set_suspend(hcd->phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
-		goto fail_phy;
+		goto cleanup_phy;
 	}
 
 	tegra->host_resumed = 1;
@@ -769,7 +753,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (!irq) {
 		dev_err(&pdev->dev, "Failed to get IRQ\n");
 		err = -ENODEV;
-		goto fail_phy;
+		goto cleanup_phy;
 	}
 
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
@@ -781,10 +765,12 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		tegra->transceiver = ERR_PTR(-ENODEV);
 	}
 
+	platform_set_drvdata(pdev, tegra);
+
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto fail;
+		goto cleanup_phy;
 	}
 
 	pm_runtime_set_active(&pdev->dev);
@@ -797,15 +783,15 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	return err;
 
-fail:
+cleanup_phy:
 	if (!IS_ERR(tegra->transceiver))
 		otg_set_host(tegra->transceiver->otg, NULL);
-fail_phy:
+
 	usb_phy_shutdown(hcd->phy);
-fail_io:
-	clk_disable_unprepare(tegra->clk);
-fail_clk:
+cleanup_hcd_create:
 	usb_put_hcd(hcd);
+cleanup_clk:
+	clk_disable_unprepare(tegra->clk);
 	return err;
 }
 
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index f423ae8..4d81b19 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -1,9 +1,11 @@
 /*
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2013 NVIDIA Corporation
  *
  * Author:
  *	Erik Gilling <konkers@google.com>
  *	Benoit Goby <benoit@android.com>
+ *	Venu Byravarasu <vbyravarasu@nvidia.com>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -30,9 +32,7 @@
 #include <linux/usb/ulpi.h>
 #include <asm/mach-types.h>
 #include <linux/usb/tegra_usb_phy.h>
-
-#define TEGRA_USB_BASE		0xC5000000
-#define TEGRA_USB_SIZE		SZ_16K
+#include <linux/module.h>
 
 #define ULPI_VIEWPORT		0x170
 
@@ -198,32 +198,15 @@ static struct tegra_utmip_config utmip_default[] = {
 
 static int utmip_pad_open(struct tegra_usb_phy *phy)
 {
-	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
+	phy->pad_clk = devm_clk_get(phy->dev, "utmi-pads");
 	if (IS_ERR(phy->pad_clk)) {
 		pr_err("%s: can't get utmip pad clock\n", __func__);
 		return PTR_ERR(phy->pad_clk);
 	}
 
-	if (phy->is_legacy_phy) {
-		phy->pad_regs = phy->regs;
-	} else {
-		phy->pad_regs = ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
-		if (!phy->pad_regs) {
-			pr_err("%s: can't remap usb registers\n", __func__);
-			clk_put(phy->pad_clk);
-			return -ENOMEM;
-		}
-	}
 	return 0;
 }
 
-static void utmip_pad_close(struct tegra_usb_phy *phy)
-{
-	if (!phy->is_legacy_phy)
-		iounmap(phy->pad_regs);
-	clk_put(phy->pad_clk);
-}
-
 static void utmip_pad_power_on(struct tegra_usb_phy *phy)
 {
 	unsigned long val, flags;
@@ -299,7 +282,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		phy->set_phcd(&phy->u_phy, true);
+		tegra_ehci_set_phcd(&phy->u_phy, true);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
@@ -321,7 +304,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		phy->set_phcd(&phy->u_phy, false);
+		tegra_ehci_set_phcd(&phy->u_phy, false);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
 						     USB_PHY_CLK_VALID))
@@ -444,7 +427,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	utmi_phy_clk_enable(phy);
 
 	if (!phy->is_legacy_phy)
-		phy->set_pts(&phy->u_phy, 0);
+		tegra_ehci_set_pts(&phy->u_phy, 0);
 
 	return 0;
 }
@@ -614,76 +597,11 @@ static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 	return gpio_direction_output(phy->reset_gpio, 0);
 }
 
-static int	tegra_phy_init(struct usb_phy *x)
-{
-	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-	struct tegra_ulpi_config *ulpi_config;
-	int err;
-
-	if (phy->is_ulpi_phy) {
-		ulpi_config = phy->config;
-		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
-		if (IS_ERR(phy->clk)) {
-			pr_err("%s: can't get ulpi clock\n", __func__);
-			return PTR_ERR(phy->clk);
-		}
-
-		phy->reset_gpio =
-			of_get_named_gpio(phy->dev->of_node,
-					  "nvidia,phy-reset-gpio", 0);
-		if (!gpio_is_valid(phy->reset_gpio)) {
-			dev_err(phy->dev, "invalid gpio: %d\n",
-				phy->reset_gpio);
-			err = phy->reset_gpio;
-			goto cleanup_clk_get;
-		}
-
-		err = gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
-		if (err < 0) {
-			dev_err(phy->dev, "request failed for gpio: %d\n",
-			       phy->reset_gpio);
-			goto cleanup_clk_get;
-		}
-
-		err = gpio_direction_output(phy->reset_gpio, 0);
-		if (err < 0) {
-			dev_err(phy->dev, "gpio %d direction not set to output\n",
-			       phy->reset_gpio);
-			goto cleanup_gpio_req;
-		}
-
-		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
-		if (!phy->ulpi) {
-			dev_err(phy->dev, "otg_ulpi_create returned NULL\n");
-			err = -ENOMEM;
-			goto cleanup_gpio_req;
-		}
-
-		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
-	} else {
-		err = utmip_pad_open(phy);
-		if (err < 0)
-			return err;
-	}
-	return 0;
-cleanup_gpio_req:
-	gpio_free(phy->reset_gpio);
-cleanup_clk_get:
-	clk_put(phy->clk);
-	return err;
-}
-
 static void tegra_usb_phy_close(struct usb_phy *x)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
 
-	if (phy->is_ulpi_phy)
-		clk_put(phy->clk);
-	else
-		utmip_pad_close(phy);
 	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-	kfree(phy);
 }
 
 static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
@@ -711,63 +629,63 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 		return tegra_usb_phy_power_on(phy);
 }
 
-struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config,
-	void (*set_pts)(struct usb_phy *x, u8 pts_val),
-	void (*set_phcd)(struct usb_phy *x, bool enable))
-
+static int ulpi_open(struct tegra_usb_phy *phy)
 {
-	struct tegra_usb_phy *phy;
-	unsigned long parent_rate;
-	int i;
 	int err;
-	struct device_node *np = dev->of_node;
 
-	phy = kzalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
-	if (!phy)
-		return ERR_PTR(-ENOMEM);
+	phy->clk = devm_clk_get(phy->dev, "ulpi-link");
+	if (IS_ERR(phy->clk)) {
+		pr_err("%s: can't get ulpi clock\n", __func__);
+		return PTR_ERR(phy->clk);
+	}
 
-	phy->instance = instance;
-	phy->regs = regs;
-	phy->config = config;
-	phy->dev = dev;
-	phy->is_legacy_phy =
-		of_property_read_bool(np, "nvidia,has-legacy-mode");
-	phy->set_pts = set_pts;
-	phy->set_phcd = set_phcd;
-	err = of_property_match_string(np, "phy_type", "ulpi");
-	if (err < 0)
-		phy->is_ulpi_phy = false;
-	else
-		phy->is_ulpi_phy = true;
+	err = devm_gpio_request(phy->dev, phy->reset_gpio, "ulpi_phy_reset_b");
+	if (err < 0) {
+		dev_err(phy->dev, "request failed for gpio: %d\n",
+		       phy->reset_gpio);
+		return err;
+	}
 
-	err = of_property_match_string(np, "dr_mode", "otg");
+	err = gpio_direction_output(phy->reset_gpio, 0);
 	if (err < 0) {
-		err = of_property_match_string(np, "dr_mode", "peripheral");
-		if (err < 0)
-			phy->mode = TEGRA_USB_PHY_MODE_HOST;
+		dev_err(phy->dev, "gpio %d direction not set to output\n",
+		       phy->reset_gpio);
+		return err;
+	}
+
+	phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
+	if (!phy->ulpi) {
+		dev_err(phy->dev, "otg_ulpi_create returned NULL\n");
+		err = -ENOMEM;
+		return err;
+	}
+
+	phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
+	return 0;
+}
+
+static int tegra_usb_phy_init(struct tegra_usb_phy *phy)
+{
+	unsigned long parent_rate;
+	int i;
+	int err;
+
+	if (!phy->is_ulpi_phy) {
+		if (phy->is_legacy_phy)
+			phy->config = &utmip_default[0];
 		else
-			phy->mode = TEGRA_USB_PHY_MODE_DEVICE;
-	} else
-		phy->mode = TEGRA_USB_PHY_MODE_OTG;
-
-	if (!phy->config) {
-		if (phy->is_ulpi_phy) {
-			pr_err("%s: ulpi phy configuration missing", __func__);
-			err = -EINVAL;
-			goto err0;
-		} else {
-			phy->config = &utmip_default[instance];
-		}
+			phy->config = &utmip_default[2];
 	}
 
-	phy->pll_u = clk_get_sys(NULL, "pll_u");
+	phy->pll_u = devm_clk_get(phy->dev, "pll_u");
 	if (IS_ERR(phy->pll_u)) {
 		pr_err("Can't get pll_u clock\n");
-		err = PTR_ERR(phy->pll_u);
-		goto err0;
+		return PTR_ERR(phy->pll_u);
 	}
-	clk_prepare_enable(phy->pll_u);
+
+	err = clk_prepare_enable(phy->pll_u);
+	if (err)
+		return err;
 
 	parent_rate = clk_get_rate(clk_get_parent(phy->pll_u));
 	for (i = 0; i < ARRAY_SIZE(tegra_freq_table); i++) {
@@ -779,23 +697,22 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	if (!phy->freq) {
 		pr_err("invalid pll_u parent rate %ld\n", parent_rate);
 		err = -EINVAL;
-		goto err1;
+		goto fail;
 	}
 
-	phy->u_phy.init = tegra_phy_init;
-	phy->u_phy.shutdown = tegra_usb_phy_close;
-	phy->u_phy.set_suspend = tegra_usb_phy_suspend;
+	if (phy->is_ulpi_phy)
+		err = ulpi_open(phy);
+	else
+		err = utmip_pad_open(phy);
+	if (err < 0)
+		goto fail;
 
-	return phy;
+	return 0;
 
-err1:
+fail:
 	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-err0:
-	kfree(phy);
-	return ERR_PTR(err);
+	return err;
 }
-EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 void tegra_usb_phy_preresume(struct usb_phy *x)
 {
@@ -834,3 +751,121 @@ void tegra_ehci_phy_restore_end(struct usb_phy *x)
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
 
+static int tegra_usb_phy_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct tegra_usb_phy *tegra_phy = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	int err;
+
+	tegra_phy = devm_kzalloc(&pdev->dev, sizeof(*tegra_phy), GFP_KERNEL);
+	if (!tegra_phy) {
+		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get I/O memory\n");
+		return  -ENXIO;
+	}
+
+	tegra_phy->regs = devm_ioremap(&pdev->dev, res->start,
+		resource_size(res));
+	if (!tegra_phy->regs) {
+		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
+		return -ENOMEM;
+	}
+
+	tegra_phy->is_legacy_phy =
+		of_property_read_bool(np, "nvidia,has-legacy-mode");
+
+	err = of_property_match_string(np, "phy_type", "ulpi");
+	if (err < 0) {
+		tegra_phy->is_ulpi_phy = false;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to get UTMI Pad regs\n");
+			return  -ENXIO;
+		}
+
+		tegra_phy->pad_regs = devm_ioremap(&pdev->dev, res->start,
+			resource_size(res));
+		if (!tegra_phy->regs) {
+			dev_err(&pdev->dev, "Failed to remap UTMI Pad regs\n");
+			return -ENOMEM;
+		}
+	} else {
+		tegra_phy->is_ulpi_phy = true;
+
+		tegra_phy->reset_gpio =
+			of_get_named_gpio(np, "nvidia,phy-reset-gpio", 0);
+		if (!gpio_is_valid(tegra_phy->reset_gpio)) {
+			dev_err(&pdev->dev, "invalid gpio: %d\n",
+				tegra_phy->reset_gpio);
+			return tegra_phy->reset_gpio;
+		}
+	}
+
+	err = of_property_match_string(np, "dr_mode", "otg");
+	if (err < 0) {
+		err = of_property_match_string(np, "dr_mode", "peripheral");
+		if (err < 0)
+			tegra_phy->mode = TEGRA_USB_PHY_MODE_HOST;
+		else
+			tegra_phy->mode = TEGRA_USB_PHY_MODE_DEVICE;
+	} else
+		tegra_phy->mode = TEGRA_USB_PHY_MODE_OTG;
+
+	tegra_phy->dev = &pdev->dev;
+	err = tegra_usb_phy_init(tegra_phy);
+	if (err < 0)
+		return err;
+
+	tegra_phy->u_phy.shutdown = tegra_usb_phy_close;
+	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;
+
+	dev_set_drvdata(&pdev->dev, tegra_phy);
+	return 0;
+}
+
+static struct of_device_id tegra_usb_phy_id_table[] = {
+	{ .compatible = "nvidia,tegra20-usb-phy", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
+
+static struct platform_driver tegra_usb_phy_driver = {
+	.probe		= tegra_usb_phy_probe,
+	.driver		= {
+		.name	= "tegra-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(tegra_usb_phy_id_table),
+	},
+};
+module_platform_driver(tegra_usb_phy_driver);
+
+static int tegra_usb_phy_match(struct device *dev, void *data)
+{
+	struct tegra_usb_phy *tegra_phy = dev_get_drvdata(dev);
+	struct device_node *dn = data;
+
+	return (tegra_phy->dev->of_node == dn) ? 1 : 0;
+}
+
+struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
+{
+	struct device *dev;
+	struct tegra_usb_phy *tegra_phy;
+
+	dev = driver_find_device(&tegra_usb_phy_driver.driver, NULL, dn,
+				 tegra_usb_phy_match);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	tegra_phy = dev_get_drvdata(dev);
+
+	return &tegra_phy->u_phy;
+}
+EXPORT_SYMBOL_GPL(tegra_usb_get_phy);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 97d123c..0cd15d2 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -63,14 +63,9 @@ struct tegra_usb_phy {
 	bool is_legacy_phy;
 	bool is_ulpi_phy;
 	int reset_gpio;
-	void (*set_pts)(struct usb_phy *x, u8 pts_val);
-	void (*set_phcd)(struct usb_phy *x, bool enable);
 };
 
-struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config,
-	void (*set_pts)(struct usb_phy *x, u8 pts_val),
-	void (*set_phcd)(struct usb_phy *x, bool enable));
+struct usb_phy *tegra_usb_get_phy(struct device_node *dn);
 
 void tegra_usb_phy_preresume(struct usb_phy *phy);
 
@@ -81,4 +76,8 @@ void tegra_ehci_phy_restore_start(struct usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct usb_phy *phy);
 
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
+
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable);
+
 #endif /* __TEGRA_USB_PHY_H */
-- 
1.7.0.4

