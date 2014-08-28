Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaH1L7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:59:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29387 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaH1L7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:59:14 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7f-53ff198f53f7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3] usb: phy: samsung: remove old common USB PHY code
Date: Thu, 28 Aug 2014 13:58:53 +0200
Message-id: <1409227133-1410-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xoG6/5P9gg+OLRSw2zljPanHwfr3F
	puvXWS3arhxkt/jx+gKbRe+Cq2wWF572sFmcbXrDbnF51xw2ixnn9zFZLFrWyuzA7XHn2h42
	j74tqxg9jt/YzuTxeZNcAEsUl01Kak5mWWqRvl0CV0bDlFmsBT/mMVbsbZ3C2sB4r4mxi5GT
	Q0LAROLv6i5WCFtM4sK99WxdjFwcQgLTGSW271rODOF0MUk8/d8J1sEmYCUxsX0VmC0iIC8x
	6c9CVpAiZoFnTBLtbcfZQBLCAq4SDxd3MIHYLAKqEq8mfQQq4uDgFXCX6LwqDrFNUaL72QS2
	CYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh9Ez6R2MqxosDjEKcDAq8fA6xP0L
	FmJNLCuuzD3EKMHBrCTCO+0PUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU
	1ILUIpgsEwenVANja2bdr4vTpoZ+SWpZmq07LepOAjuDpqvFJQv3m983b3iWrruh+Ikeu2fG
	WYEb87N8r0ScvS2uvXlTTU5OrhnjV659IQvP/8nZo+Lr9+/5K6lL006/DqvhWXG/2Erv0tnE
	s+z5Vab3bXrtvdMf632uubb74WreacuVp75k3S2VyC/Rc8RSkjFSiaU4I9FQi7moOBEAVT5N
	rR8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb[2,3] drivers got replaced by
drivers/phy/phy-samsung-usb[2,3] ones and the old common Samsung
USB PHY code is no longer used.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
v3:
- rebased on testing/next branch of balbi/usb.git tree

 drivers/usb/phy/phy-samsung-usb.c            | 241 --------------------
 drivers/usb/phy/phy-samsung-usb.h            | 317 ---------------------------
 include/linux/platform_data/samsung-usbphy.h |  27 ---
 3 files changed, 585 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.h
 delete mode 100644 include/linux/platform_data/samsung-usbphy.h

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
deleted file mode 100644
index ac025ca..0000000
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/* linux/drivers/usb/phy/phy-samsung-usb.c
- *
- * Copyright (c) 2012 Samsung Electronics Co., Ltd.
- *              http://www.samsung.com
- *
- * Author: Praveen Paneri <p.paneri@samsung.com>
- *
- * Samsung USB-PHY helper driver with common function calls;
- * interacts with Samsung USB 2.0 PHY controller driver and later
- * with Samsung USB 3.0 PHY driver.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/usb/samsung_usb_phy.h>
-
-#include "phy-samsung-usb.h"
-
-int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
-{
-	struct device_node *usbphy_sys;
-
-	/* Getting node for system controller interface for usb-phy */
-	usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
-	if (!usbphy_sys) {
-		dev_err(sphy->dev, "No sys-controller interface for usb-phy\n");
-		return -ENODEV;
-	}
-
-	sphy->pmuregs = of_iomap(usbphy_sys, 0);
-
-	if (sphy->pmuregs == NULL) {
-		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
-		goto err0;
-	}
-
-	sphy->sysreg = of_iomap(usbphy_sys, 1);
-
-	/*
-	 * Not returning error code here, since this situation is not fatal.
-	 * Few SoCs may not have this switch available
-	 */
-	if (sphy->sysreg == NULL)
-		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
-
-	of_node_put(usbphy_sys);
-
-	return 0;
-
-err0:
-	of_node_put(usbphy_sys);
-	return -ENXIO;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
-
-/*
- * Set isolation here for phy.
- * Here 'on = true' would mean USB PHY block is isolated, hence
- * de-activated and vice-versa.
- */
-void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
-{
-	void __iomem *reg = NULL;
-	u32 reg_val;
-	u32 en_mask = 0;
-
-	if (!sphy->pmuregs) {
-		dev_warn(sphy->dev, "Can't set pmu isolation\n");
-		return;
-	}
-
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
-		reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
-		en_mask = sphy->drv_data->devphy_en_mask;
-	} else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
-		reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
-		en_mask = sphy->drv_data->hostphy_en_mask;
-	}
-
-	reg_val = readl(reg);
-
-	if (on)
-		reg_val &= ~en_mask;
-	else
-		reg_val |= en_mask;
-
-	writel(reg_val, reg);
-
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
-	}
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
-
-/*
- * Configure the mode of working of usb-phy here: HOST/DEVICE.
- */
-void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
-{
-	u32 reg;
-
-	if (!sphy->sysreg) {
-		dev_warn(sphy->dev, "Can't configure specified phy mode\n");
-		return;
-	}
-
-	reg = readl(sphy->sysreg);
-
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE)
-		reg &= ~EXYNOS_USB20PHY_CFG_HOST_LINK;
-	else if (sphy->phy_type == USB_PHY_TYPE_HOST)
-		reg |= EXYNOS_USB20PHY_CFG_HOST_LINK;
-
-	writel(reg, sphy->sysreg);
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_cfg_sel);
-
-/*
- * PHYs are different for USB Device and USB Host.
- * This make sure that correct PHY type is selected before
- * any operation on PHY.
- */
-int samsung_usbphy_set_type(struct usb_phy *phy,
-				enum samsung_usb_phy_type phy_type)
-{
-	struct samsung_usbphy *sphy = phy_to_sphy(phy);
-
-	sphy->phy_type = phy_type;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_set_type);
-
-int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
-							unsigned long rate)
-{
-	unsigned int clksel;
-
-	switch (rate) {
-	case 12 * MHZ:
-		clksel = PHYCLK_CLKSEL_12M;
-		break;
-	case 24 * MHZ:
-		clksel = PHYCLK_CLKSEL_24M;
-		break;
-	case 48 * MHZ:
-		clksel = PHYCLK_CLKSEL_48M;
-		break;
-	default:
-		dev_err(sphy->dev,
-			"Invalid reference clock frequency: %lu\n", rate);
-		return -EINVAL;
-	}
-
-	return clksel;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_rate_to_clksel_64xx);
-
-int samsung_usbphy_rate_to_clksel_4x12(struct samsung_usbphy *sphy,
-							unsigned long rate)
-{
-	unsigned int clksel;
-
-	switch (rate) {
-	case 9600 * KHZ:
-		clksel = FSEL_CLKSEL_9600K;
-		break;
-	case 10 * MHZ:
-		clksel = FSEL_CLKSEL_10M;
-		break;
-	case 12 * MHZ:
-		clksel = FSEL_CLKSEL_12M;
-		break;
-	case 19200 * KHZ:
-		clksel = FSEL_CLKSEL_19200K;
-		break;
-	case 20 * MHZ:
-		clksel = FSEL_CLKSEL_20M;
-		break;
-	case 24 * MHZ:
-		clksel = FSEL_CLKSEL_24M;
-		break;
-	case 50 * MHZ:
-		clksel = FSEL_CLKSEL_50M;
-		break;
-	default:
-		dev_err(sphy->dev,
-			"Invalid reference clock frequency: %lu\n", rate);
-		return -EINVAL;
-	}
-
-	return clksel;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_rate_to_clksel_4x12);
-
-/*
- * Returns reference clock frequency selection value
- */
-int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
-{
-	struct clk *ref_clk;
-	unsigned long rate;
-	int refclk_freq;
-
-	/*
-	 * In exynos5250 USB host and device PHY use
-	 * external crystal clock XXTI
-	 */
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
-		ref_clk = clk_get(sphy->dev, "ext_xtal");
-	else
-		ref_clk = clk_get(sphy->dev, "xusbxti");
-	if (IS_ERR(ref_clk)) {
-		dev_err(sphy->dev, "Failed to get reference clock\n");
-		return PTR_ERR(ref_clk);
-	}
-
-	rate = clk_get_rate(ref_clk);
-	refclk_freq = sphy->drv_data->rate_to_clksel(sphy, rate);
-
-	clk_put(ref_clk);
-
-	return refclk_freq;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_get_refclk_freq);
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
deleted file mode 100644
index 4eef455..0000000
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ /dev/null
@@ -1,317 +0,0 @@
-/* linux/drivers/usb/phy/phy-samsung-usb.h
- *
- * Copyright (c) 2012 Samsung Electronics Co., Ltd.
- *              http://www.samsung.com
- *
- * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
- * OHCI-EXYNOS controllers.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/usb/phy.h>
-
-/* Register definitions */
-
-#define SAMSUNG_PHYPWR				(0x00)
-#define PHYPWR_NORMAL_MASK			(0x19 << 0)
-#define PHYPWR_OTG_DISABLE			(0x1 << 4)
-#define PHYPWR_ANALOG_POWERDOWN			(0x1 << 3)
-#define PHYPWR_FORCE_SUSPEND			(0x1 << 1)
-/* For Exynos4 */
-#define PHYPWR_NORMAL_MASK_PHY0			(0x39 << 0)
-#define PHYPWR_SLEEP_PHY0			(0x1 << 5)
-
-#define SAMSUNG_PHYCLK				(0x04)
-#define PHYCLK_MODE_USB11			(0x1 << 6)
-#define PHYCLK_EXT_OSC				(0x1 << 5)
-#define PHYCLK_COMMON_ON_N			(0x1 << 4)
-#define PHYCLK_ID_PULL				(0x1 << 2)
-#define PHYCLK_CLKSEL_MASK			(0x3 << 0)
-#define PHYCLK_CLKSEL_48M			(0x0 << 0)
-#define PHYCLK_CLKSEL_12M			(0x2 << 0)
-#define PHYCLK_CLKSEL_24M			(0x3 << 0)
-
-#define SAMSUNG_RSTCON				(0x08)
-#define RSTCON_PHYLINK_SWRST			(0x1 << 2)
-#define RSTCON_HLINK_SWRST			(0x1 << 1)
-#define RSTCON_SWRST				(0x1 << 0)
-
-/* EXYNOS4X12 */
-#define EXYNOS4X12_PHY_HSIC_CTRL0		(0x04)
-#define EXYNOS4X12_PHY_HSIC_CTRL1		(0x08)
-#define PHYPWR_NORMAL_MASK_HSIC1		(0x7 << 12)
-#define PHYPWR_NORMAL_MASK_HSIC0		(0x7 << 9)
-#define PHYPWR_NORMAL_MASK_PHY1			(0x7 << 6)
-#define RSTCON_HOSTPHY_SWRST			(0xf << 3)
-
-/* EXYNOS5 */
-#define EXYNOS5_PHY_HOST_CTRL0			(0x00)
-#define HOST_CTRL0_PHYSWRSTALL			(0x1 << 31)
-#define HOST_CTRL0_REFCLKSEL_MASK		(0x3 << 19)
-#define HOST_CTRL0_REFCLKSEL_XTAL		(0x0 << 19)
-#define HOST_CTRL0_REFCLKSEL_EXTL		(0x1 << 19)
-#define HOST_CTRL0_REFCLKSEL_CLKCORE		(0x2 << 19)
-#define HOST_CTRL0_FSEL_MASK			(0x7 << 16)
-#define HOST_CTRL0_FSEL(_x)			((_x) << 16)
-#define FSEL_CLKSEL_50M				(0x7)
-#define FSEL_CLKSEL_24M				(0x5)
-#define FSEL_CLKSEL_20M				(0x4)
-#define FSEL_CLKSEL_19200K			(0x3)
-#define FSEL_CLKSEL_12M				(0x2)
-#define FSEL_CLKSEL_10M				(0x1)
-#define FSEL_CLKSEL_9600K			(0x0)
-#define HOST_CTRL0_TESTBURNIN			(0x1 << 11)
-#define HOST_CTRL0_RETENABLE			(0x1 << 10)
-#define HOST_CTRL0_COMMONON_N			(0x1 << 9)
-#define HOST_CTRL0_SIDDQ			(0x1 << 6)
-#define HOST_CTRL0_FORCESLEEP			(0x1 << 5)
-#define HOST_CTRL0_FORCESUSPEND			(0x1 << 4)
-#define HOST_CTRL0_WORDINTERFACE		(0x1 << 3)
-#define HOST_CTRL0_UTMISWRST			(0x1 << 2)
-#define HOST_CTRL0_LINKSWRST			(0x1 << 1)
-#define HOST_CTRL0_PHYSWRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_HOST_TUNE0			(0x04)
-
-#define EXYNOS5_PHY_HSIC_CTRL1			(0x10)
-
-#define EXYNOS5_PHY_HSIC_TUNE1			(0x14)
-
-#define EXYNOS5_PHY_HSIC_CTRL2			(0x20)
-
-#define EXYNOS5_PHY_HSIC_TUNE2			(0x24)
-#define HSIC_CTRL_REFCLKSEL_MASK		(0x3 << 23)
-#define HSIC_CTRL_REFCLKSEL			(0x2 << 23)
-#define HSIC_CTRL_REFCLKDIV_MASK		(0x7f << 16)
-#define HSIC_CTRL_REFCLKDIV(_x)			((_x) << 16)
-#define HSIC_CTRL_REFCLKDIV_12			(0x24 << 16)
-#define HSIC_CTRL_REFCLKDIV_15			(0x1c << 16)
-#define HSIC_CTRL_REFCLKDIV_16			(0x1a << 16)
-#define HSIC_CTRL_REFCLKDIV_19_2		(0x15 << 16)
-#define HSIC_CTRL_REFCLKDIV_20			(0x14 << 16)
-#define HSIC_CTRL_SIDDQ				(0x1 << 6)
-#define HSIC_CTRL_FORCESLEEP			(0x1 << 5)
-#define HSIC_CTRL_FORCESUSPEND			(0x1 << 4)
-#define HSIC_CTRL_WORDINTERFACE			(0x1 << 3)
-#define HSIC_CTRL_UTMISWRST			(0x1 << 2)
-#define HSIC_CTRL_PHYSWRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_HOST_EHCICTRL		(0x30)
-#define HOST_EHCICTRL_ENAINCRXALIGN		(0x1 << 29)
-#define HOST_EHCICTRL_ENAINCR4			(0x1 << 28)
-#define HOST_EHCICTRL_ENAINCR8			(0x1 << 27)
-#define HOST_EHCICTRL_ENAINCR16			(0x1 << 26)
-
-#define EXYNOS5_PHY_HOST_OHCICTRL		(0x34)
-#define HOST_OHCICTRL_SUSPLGCY			(0x1 << 3)
-#define HOST_OHCICTRL_APPSTARTCLK		(0x1 << 2)
-#define HOST_OHCICTRL_CNTSEL			(0x1 << 1)
-#define HOST_OHCICTRL_CLKCKTRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_OTG_SYS			(0x38)
-#define OTG_SYS_PHYLINK_SWRESET			(0x1 << 14)
-#define OTG_SYS_LINKSWRST_UOTG			(0x1 << 13)
-#define OTG_SYS_PHY0_SWRST			(0x1 << 12)
-#define OTG_SYS_REFCLKSEL_MASK			(0x3 << 9)
-#define OTG_SYS_REFCLKSEL_XTAL			(0x0 << 9)
-#define OTG_SYS_REFCLKSEL_EXTL			(0x1 << 9)
-#define OTG_SYS_REFCLKSEL_CLKCORE		(0x2 << 9)
-#define OTG_SYS_IDPULLUP_UOTG			(0x1 << 8)
-#define OTG_SYS_COMMON_ON			(0x1 << 7)
-#define OTG_SYS_FSEL_MASK			(0x7 << 4)
-#define OTG_SYS_FSEL(_x)			((_x) << 4)
-#define OTG_SYS_FORCESLEEP			(0x1 << 3)
-#define OTG_SYS_OTGDISABLE			(0x1 << 2)
-#define OTG_SYS_SIDDQ_UOTG			(0x1 << 1)
-#define OTG_SYS_FORCESUSPEND			(0x1 << 0)
-
-#define EXYNOS5_PHY_OTG_TUNE			(0x40)
-
-/* EXYNOS5: USB 3.0 DRD */
-#define EXYNOS5_DRD_LINKSYSTEM			(0x04)
-#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
-#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
-#define LINKSYSTEM_XHCI_VERSION_CONTROL		(0x1 << 27)
-
-#define EXYNOS5_DRD_PHYUTMI			(0x08)
-#define PHYUTMI_OTGDISABLE			(0x1 << 6)
-#define PHYUTMI_FORCESUSPEND			(0x1 << 1)
-#define PHYUTMI_FORCESLEEP			(0x1 << 0)
-
-#define EXYNOS5_DRD_PHYPIPE			(0x0c)
-
-#define EXYNOS5_DRD_PHYCLKRST			(0x10)
-#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
-#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
-#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
-#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
-#define PHYCLKRST_SSC_EN			(0x1 << 20)
-#define PHYCLKRST_REF_SSP_EN			(0x1 << 19)
-#define PHYCLKRST_REF_CLKDIV2			(0x1 << 18)
-#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x02 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
-#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
-#define PHYCLKRST_FSEL_MASK			(0x3f << 5)
-#define PHYCLKRST_FSEL(_x)			((_x) << 5)
-#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
-#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
-#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
-#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
-#define PHYCLKRST_RETENABLEN			(0x1 << 4)
-#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
-#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
-#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
-#define PHYCLKRST_PORTRESET			(0x1 << 1)
-#define PHYCLKRST_COMMONONN			(0x1 << 0)
-
-#define EXYNOS5_DRD_PHYREG0			(0x14)
-
-#define EXYNOS5_DRD_PHYREG1			(0x18)
-
-#define EXYNOS5_DRD_PHYPARAM0			(0x1c)
-#define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
-#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
-#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
-
-#define EXYNOS5_DRD_PHYPARAM1			(0x20)
-#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
-#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
-
-#define EXYNOS5_DRD_PHYTERM			(0x24)
-
-#define EXYNOS5_DRD_PHYTEST			(0x28)
-#define PHYTEST_POWERDOWN_SSP			(0x1 << 3)
-#define PHYTEST_POWERDOWN_HSP			(0x1 << 2)
-
-#define EXYNOS5_DRD_PHYADP			(0x2c)
-
-#define EXYNOS5_DRD_PHYBATCHG			(0x30)
-#define PHYBATCHG_UTMI_CLKSEL			(0x1 << 2)
-
-#define EXYNOS5_DRD_PHYRESUME			(0x34)
-
-#define EXYNOS5_DRD_LINKPORT			(0x44)
-
-#ifndef MHZ
-#define MHZ (1000*1000)
-#endif
-
-#ifndef KHZ
-#define KHZ (1000)
-#endif
-
-#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
-#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
-#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
-#define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
-
-enum samsung_cpu_type {
-	TYPE_S3C64XX,
-	TYPE_EXYNOS4210,
-	TYPE_EXYNOS4X12,
-	TYPE_EXYNOS5250,
-};
-
-struct samsung_usbphy;
-
-/*
- * struct samsung_usbphy_drvdata - driver data for various SoC variants
- * @cpu_type: machine identifier
- * @devphy_en_mask: device phy enable mask for PHY CONTROL register
- * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
- * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
- *		       mapped address of system controller.
- * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
- *		       mapped address of system controller.
- *
- *	Here we have a separate mask for device type phy.
- *	Having different masks for host and device type phy helps
- *	in setting independent masks in case of SoCs like S5PV210,
- *	in which PHY0 and PHY1 enable bits belong to same register
- *	placed at position 0 and 1 respectively.
- *	Although for newer SoCs like exynos these bits belong to
- *	different registers altogether placed at position 0.
- */
-struct samsung_usbphy_drvdata {
-	int cpu_type;
-	int devphy_en_mask;
-	int hostphy_en_mask;
-	u32 devphy_reg_offset;
-	u32 hostphy_reg_offset;
-	int (*rate_to_clksel)(struct samsung_usbphy *, unsigned long);
-	void (*set_isolation)(struct samsung_usbphy *, bool);
-	void (*phy_enable)(struct samsung_usbphy *);
-	void (*phy_disable)(struct samsung_usbphy *);
-};
-
-/*
- * struct samsung_usbphy - transceiver driver state
- * @phy: transceiver structure
- * @plat: platform data
- * @dev: The parent device supplied to the probe function
- * @clk: usb phy clock
- * @regs: usb phy controller registers memory base
- * @pmuregs: USB device PHY_CONTROL register memory base
- * @sysreg: USB2.0 PHY_CFG register memory base
- * @ref_clk_freq: reference clock frequency selection
- * @drv_data: driver data available for different SoCs
- * @phy_type: Samsung SoCs specific phy types:	#HOST
- *						#DEVICE
- * @phy_usage: usage count for phy
- * @lock: lock for phy operations
- */
-struct samsung_usbphy {
-	struct usb_phy	phy;
-	struct samsung_usbphy_data *plat;
-	struct device	*dev;
-	struct clk	*clk;
-	void __iomem	*regs;
-	void __iomem	*pmuregs;
-	void __iomem	*sysreg;
-	int		ref_clk_freq;
-	const struct samsung_usbphy_drvdata *drv_data;
-	enum samsung_usb_phy_type phy_type;
-	atomic_t	phy_usage;
-	spinlock_t	lock;
-};
-
-#define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
-
-static const struct of_device_id samsung_usbphy_dt_match[];
-
-static inline const struct samsung_usbphy_drvdata
-*samsung_usbphy_get_driver_data(struct platform_device *pdev)
-{
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(samsung_usbphy_dt_match,
-							pdev->dev.of_node);
-		return match->data;
-	}
-
-	return (struct samsung_usbphy_drvdata *)
-				platform_get_device_id(pdev)->driver_data;
-}
-
-extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
-extern void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy,
-								bool on);
-extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_set_type(struct usb_phy *phy,
-					enum samsung_usb_phy_type phy_type);
-extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
-							unsigned long rate);
-extern int samsung_usbphy_rate_to_clksel_4x12(struct samsung_usbphy *sphy,
-							unsigned long rate);
diff --git a/include/linux/platform_data/samsung-usbphy.h b/include/linux/platform_data/samsung-usbphy.h
deleted file mode 100644
index 1bd24cb..0000000
--- a/include/linux/platform_data/samsung-usbphy.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2012 Samsung Electronics Co.Ltd
- *		http://www.samsung.com/
- * Author: Praveen Paneri <p.paneri@samsung.com>
- *
- * Defines platform data for samsung usb phy driver.
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef __SAMSUNG_USBPHY_PLATFORM_H
-#define __SAMSUNG_USBPHY_PLATFORM_H
-
-/**
- * samsung_usbphy_data - Platform data for USB PHY driver.
- * @pmu_isolation: Function to control usb phy isolation in PMU.
- */
-struct samsung_usbphy_data {
-	void (*pmu_isolation)(int on);
-};
-
-extern void samsung_usbphy_set_pdata(struct samsung_usbphy_data *pd);
-
-#endif /* __SAMSUNG_USBPHY_PLATFORM_H */
-- 
1.8.2.3

