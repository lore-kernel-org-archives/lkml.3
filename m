Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3DPEIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 00:08:55 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39658 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3DPEIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 00:08:54 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, heiko@sntech.de,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ben Dooks <ben-linux@fluff.org>, Mark Brown <broonie@kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [REPOST PATCH] spi: s3c64xx: let device core setup the default pin configuration
Date: Mon, 15 Apr 2013 20:42:57 -0700
Message-Id: <1366083777-9118-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362570130-14084-1-git-send-email-thomas.abraham@linaro.org>
References: <1362570130-14084-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.abraham@linaro.org>

With device core now able to setup the default pin configuration,
the pin configuration code based on the deprecated Samsung specific
gpio bindings is removed.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---
 .../devicetree/bindings/spi/spi-samsung.txt        |  8 +--
 drivers/spi/spi-s3c64xx.c                          | 66 ++--------------------
 2 files changed, 6 insertions(+), 68 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-samsung.txt b/Documentation/devicetree/bindings/spi/spi-samsung.txt
index a15ffed..86aa061 100644
--- a/Documentation/devicetree/bindings/spi/spi-samsung.txt
+++ b/Documentation/devicetree/bindings/spi/spi-samsung.txt
@@ -31,9 +31,6 @@ Required Board Specific Properties:
 
 - #address-cells: should be 1.
 - #size-cells: should be 0.
-- gpios: The gpio specifier for clock, mosi and miso interface lines (in the
-  order specified). The format of the gpio specifier depends on the gpio
-  controller.
 
 Optional Board Specific Properties:
 
@@ -86,9 +83,8 @@ Example:
 	spi_0: spi@12d20000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		gpios = <&gpa2 4 2 3 0>,
-			<&gpa2 6 2 3 0>,
-			<&gpa2 7 2 3 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
 
 		w25q80bw@0 {
 			#address-cells = <1>;
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 4989aeb..4ab992b 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1148,41 +1148,6 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
 }
 
 #ifdef CONFIG_OF
-static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
-{
-	struct device *dev = &sdd->pdev->dev;
-	int idx, gpio, ret;
-
-	/* find gpios for mosi, miso and clock lines */
-	for (idx = 0; idx < 3; idx++) {
-		gpio = of_get_gpio(dev->of_node, idx);
-		if (!gpio_is_valid(gpio)) {
-			dev_err(dev, "invalid gpio[%d]: %d\n", idx, gpio);
-			goto free_gpio;
-		}
-		sdd->gpios[idx] = gpio;
-		ret = gpio_request(gpio, "spi-bus");
-		if (ret) {
-			dev_err(dev, "gpio [%d] request failed: %d\n",
-				gpio, ret);
-			goto free_gpio;
-		}
-	}
-	return 0;
-
-free_gpio:
-	while (--idx >= 0)
-		gpio_free(sdd->gpios[idx]);
-	return -EINVAL;
-}
-
-static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
-{
-	unsigned int idx;
-	for (idx = 0; idx < 3; idx++)
-		gpio_free(sdd->gpios[idx]);
-}
-
 static struct s3c64xx_spi_info *s3c64xx_spi_parse_dt(struct device *dev)
 {
 	struct s3c64xx_spi_info *sci;
@@ -1215,15 +1180,6 @@ static struct s3c64xx_spi_info *s3c64xx_spi_parse_dt(struct device *dev)
 {
 	return dev->platform_data;
 }
-
-static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
-{
-	return -EINVAL;
-}
-
-static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
-{
-}
 #endif
 
 static const struct of_device_id s3c64xx_spi_dt_match[];
@@ -1344,10 +1300,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	if (!sci->cfg_gpio && pdev->dev.of_node) {
-		if (s3c64xx_spi_parse_dt_gpio(sdd))
-			return -EBUSY;
-	} else if (sci->cfg_gpio == NULL || sci->cfg_gpio()) {
+	if (sci->cfg_gpio && sci->cfg_gpio()) {
 		dev_err(&pdev->dev, "Unable to config gpio\n");
 		ret = -EBUSY;
 		goto err0;
@@ -1358,13 +1311,13 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	if (IS_ERR(sdd->clk)) {
 		dev_err(&pdev->dev, "Unable to acquire clock 'spi'\n");
 		ret = PTR_ERR(sdd->clk);
-		goto err1;
+		goto err0;
 	}
 
 	if (clk_prepare_enable(sdd->clk)) {
 		dev_err(&pdev->dev, "Couldn't enable clock 'spi'\n");
 		ret = -EBUSY;
-		goto err1;
+		goto err0;
 	}
 
 	sprintf(clk_name, "spi_busclk%d", sci->src_clk_nr);
@@ -1421,9 +1374,6 @@ err3:
 	clk_disable_unprepare(sdd->src_clk);
 err2:
 	clk_disable_unprepare(sdd->clk);
-err1:
-	if (!sdd->cntrlr_info->cfg_gpio && pdev->dev.of_node)
-		s3c64xx_spi_dt_gpio_free(sdd);
 err0:
 	platform_set_drvdata(pdev, NULL);
 	spi_master_put(master);
@@ -1446,9 +1396,6 @@ static int s3c64xx_spi_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(sdd->clk);
 
-	if (!sdd->cntrlr_info->cfg_gpio && pdev->dev.of_node)
-		s3c64xx_spi_dt_gpio_free(sdd);
-
 	platform_set_drvdata(pdev, NULL);
 	spi_master_put(master);
 
@@ -1467,9 +1414,6 @@ static int s3c64xx_spi_suspend(struct device *dev)
 	clk_disable_unprepare(sdd->src_clk);
 	clk_disable_unprepare(sdd->clk);
 
-	if (!sdd->cntrlr_info->cfg_gpio && dev->of_node)
-		s3c64xx_spi_dt_gpio_free(sdd);
-
 	sdd->cur_speed = 0; /* Output Clock is stopped */
 
 	return 0;
@@ -1481,9 +1425,7 @@ static int s3c64xx_spi_resume(struct device *dev)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
 
-	if (!sci->cfg_gpio && dev->of_node)
-		s3c64xx_spi_parse_dt_gpio(sdd);
-	else
+	if (sci->cfg_gpio)
 		sci->cfg_gpio();
 
 	/* Enable the clock */
-- 
1.8.1.3

