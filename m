Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3HaLEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:04:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39601 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3HaLEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:04:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:03:17 +0100
Message-Id: <1377947000-5746-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/4] regulator: wm831x-dcdc: Convert to devm_gpio_request_one()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Saves code in the unwind path.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-dcdc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 11861cb..8f62750 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -387,8 +387,9 @@ static struct regulator_ops wm831x_buckv_ops = {
  * Set up DVS control.  We just log errors since we can still run
  * (with reduced performance) if we fail.
  */
-static void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
-					    struct wm831x_buckv_pdata *pdata)
+static void wm831x_buckv_dvs_init(struct platform_device *pdev,
+				  struct wm831x_dcdc *dcdc,
+				  struct wm831x_buckv_pdata *pdata)
 {
 	struct wm831x *wm831x = dcdc->wm831x;
 	int ret;
@@ -402,9 +403,9 @@ static void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 	 */
 	dcdc->dvs_gpio_state = pdata->dvs_init_state;
 
-	ret = gpio_request_one(pdata->dvs_gpio,
-			       dcdc->dvs_gpio_state ? GPIOF_INIT_HIGH : 0,
-			       "DCDC DVS");
+	ret = devm_gpio_request_one(&pdev->dev, pdata->dvs_gpio,
+				    dcdc->dvs_gpio_state ? GPIOF_INIT_HIGH : 0,
+				    "DCDC DVS");
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to get %s DVS GPIO: %d\n",
 			dcdc->name, ret);
@@ -513,7 +514,8 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	dcdc->dvs_vsel = ret & WM831X_DC1_DVS_VSEL_MASK;
 
 	if (pdata && pdata->dcdc[id])
-		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
+		wm831x_buckv_dvs_init(pdev, dcdc,
+				      pdata->dcdc[id]->driver_data);
 
 	config.dev = pdev->dev.parent;
 	if (pdata)
@@ -557,8 +559,6 @@ err_uv:
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
-	if (dcdc->dvs_gpio)
-		gpio_free(dcdc->dvs_gpio);
 	return ret;
 }
 
@@ -572,8 +572,6 @@ static int wm831x_buckv_remove(struct platform_device *pdev)
 	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
 			    dcdc);
 	regulator_unregister(dcdc->regulator);
-	if (dcdc->dvs_gpio)
-		gpio_free(dcdc->dvs_gpio);
 
 	return 0;
 }
-- 
1.8.4.rc3

