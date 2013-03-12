Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab3CLXOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:14:03 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39940 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933989Ab3CLXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:13:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH 2/4] iio: adc: Add dt support for turning on the phy in exynos-adc
Date: Tue, 12 Mar 2013 16:13:12 -0700
Message-Id: <1363129994-10438-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363129994-10438-1-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this change the exynos adc controller needed to have its phy
enabled in some out-of-driver C code.  Add support for specifying the
phy enable register by listing it in the reg list.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt         |  4 ++--
 drivers/iio/adc/exynos_adc.c                               | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 96db940..05be151 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -15,7 +15,7 @@ Required properties:
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
 - reg:			Contains ADC register address range (base address and
-			length).
+			length) and the address of the phy enable register.
 - interrupts: 		Contains the interrupt information for the timer. The
 			format is being dependent on which interrupt controller
 			the Samsung device uses.
@@ -30,7 +30,7 @@ Example: adding device info in dtsi file
 
 adc: adc@12D10000 {
 	compatible = "samsung,exynos-adc-v1";
-	reg = <0x12D10000 0x100>;
+	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
 	interrupts = <0 106 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index ed6fdd7..5ab0dfd 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -85,6 +85,7 @@ enum adc_version {
 
 struct exynos_adc {
 	void __iomem		*regs;
+	void __iomem		*enable_reg;
 	struct clk		*clk;
 	unsigned int		irq;
 	struct regulator	*vdd;
@@ -269,13 +270,19 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	info = iio_priv(indio_dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
 	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!info->regs) {
 		ret = -ENOMEM;
 		goto err_iio;
 	}
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	info->enable_reg = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!info->enable_reg) {
+		ret = -ENOMEM;
+		goto err_iio;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no irq resource?\n");
@@ -295,6 +302,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_iio;
 	}
 
+	writel(1, info->enable_reg);
+
 	info->clk = devm_clk_get(&pdev->dev, "adc");
 	if (IS_ERR(info->clk)) {
 		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
@@ -370,6 +379,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
+	writel(0, info->enable_reg);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
 	iio_device_free(indio_dev);
@@ -395,6 +405,7 @@ static int exynos_adc_suspend(struct device *dev)
 	}
 
 	clk_disable_unprepare(info->clk);
+	writel(0, info->enable_reg);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -410,6 +421,7 @@ static int exynos_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	writel(1, info->enable_reg);
 	clk_prepare_enable(info->clk);
 
 	exynos_adc_hw_init(info);
-- 
1.8.1.3

