Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaJGKTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:19:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57152 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaJGKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:19:45 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on Exynos7
Date: Tue,  7 Oct 2014 15:49:33 +0530
Message-Id: <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
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
index 3951a65..7dc6a98 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -35,6 +35,7 @@ struct dwc3_exynos {
 	struct device		*dev;
 
 	struct clk		*clk;
+	struct clk		*sclk;
 	struct regulator	*vdd33;
 	struct regulator	*vdd10;
 };
@@ -139,10 +140,21 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/*
+	 * Exynos7 has a special gate clock going to this IP,
+	 * which in earlier SoCs was probably concealed.
+	 */
+	exynos->sclk = devm_clk_get(dev, "usbdrd30_sclk");
+	if (IS_ERR(exynos->sclk)) {
+		dev_info(dev, "no sclk specified\n");
+		exynos->sclk = NULL;
+	}
+
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
 	clk_prepare_enable(exynos->clk);
+	clk_prepare_enable(exynos->sclk);
 
 	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
 	if (IS_ERR(exynos->vdd33)) {
@@ -185,6 +197,7 @@ err4:
 err3:
 	regulator_disable(exynos->vdd33);
 err2:
+	clk_disable_unprepare(exynos->sclk);
 	clk_disable_unprepare(clk);
 	return ret;
 }
@@ -197,6 +210,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
+	clk_disable_unprepare(exynos->sclk);
 	clk_disable_unprepare(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
@@ -218,6 +232,7 @@ static int dwc3_exynos_suspend(struct device *dev)
 {
 	struct dwc3_exynos *exynos = dev_get_drvdata(dev);
 
+	clk_disable(exynos->sclk);
 	clk_disable(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
@@ -243,6 +258,7 @@ static int dwc3_exynos_resume(struct device *dev)
 	}
 
 	clk_enable(exynos->clk);
+	clk_enable(exynos->sclk);
 
 	/* runtime set active to reflect active state. */
 	pm_runtime_disable(dev);
-- 
1.7.10.4

