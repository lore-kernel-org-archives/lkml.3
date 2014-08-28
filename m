Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348AbaH1ICi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:02:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51759 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936282AbaH1ICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:31 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 1/5] usb: dwc3: exynos: Add support for SCLK present on Exynos7
Date: Thu, 28 Aug 2014 13:31:56 +0530
Message-Id: <1409212920-28526-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos7 also has a separate special gate clock going to the IP
apart from the usual AHB clock. So add support for the same.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index f9fb8ad..bab6395 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -35,6 +35,7 @@ struct dwc3_exynos {
 	struct device		*dev;
 
 	struct clk		*clk;
+	struct clk		*sclk;
 	struct regulator	*vdd33;
 	struct regulator	*vdd10;
 };
@@ -141,10 +142,17 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* Exynos7 has a special gate clock going to this IP */
+	exynos->sclk = devm_clk_get(dev, "usbdrd30_sclk");
+	if (IS_ERR(exynos->sclk))
+		dev_warn(dev, "couldn't get sclk\n");
+
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
 	clk_prepare_enable(exynos->clk);
+	if (!IS_ERR(exynos->sclk))
+		clk_prepare_enable(exynos->sclk);
 
 	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
 	if (IS_ERR(exynos->vdd33)) {
@@ -187,6 +195,8 @@ err4:
 err3:
 	regulator_disable(exynos->vdd33);
 err2:
+	if (!IS_ERR(exynos->sclk))
+		clk_disable_unprepare(exynos->sclk);
 	clk_disable_unprepare(clk);
 	return ret;
 }
@@ -199,6 +209,8 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
+	if (!IS_ERR(exynos->sclk))
+		clk_disable_unprepare(exynos->sclk);
 	clk_disable_unprepare(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
@@ -220,6 +232,8 @@ static int dwc3_exynos_suspend(struct device *dev)
 {
 	struct dwc3_exynos *exynos = dev_get_drvdata(dev);
 
+	if (!IS_ERR(exynos->sclk))
+		clk_disable(exynos->sclk);
 	clk_disable(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
@@ -245,6 +259,8 @@ static int dwc3_exynos_resume(struct device *dev)
 	}
 
 	clk_enable(exynos->clk);
+	if (!IS_ERR(exynos->sclk))
+		clk_enable(exynos->sclk);
 
 	/* runtime set active to reflect active state. */
 	pm_runtime_disable(dev);
-- 
1.7.10.4

