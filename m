Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbaD3Ikr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:40:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32594 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaD3Ikp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:40:45 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-29-5360b70b4402
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] regulator: s5m8767: Allow GPIO 0 to be used as external
 control
Date: Wed, 30 Apr 2014 10:40:41 +0200
Message-id: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xK7rc2xOCDe4dk7PYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eLblQ4mi8u75rBZrD1yl93i5J9eRouLK74wOXB67Jx1l91j06pONo871/aw
	efRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG8rkpBcsEK3ad6WVsYDzG18XIySEhYCJxYt5e
	VghbTOLCvfVsXYxcHEICSxklTux+xATh9DFJPP3bzARSxSZgLLF5+RKwKhGBHkaJl1s/M4M4
	zALvGSXOPFzKCFIlLBAmMfP0dLC5LAKqEkdnPAGzeQXcJB5t2cEGsU9O4uSxyawTGLkXMDKs
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJnS87GBcfszrEKMDBqMTDK7A1PliINbGsuDL3
	EKMEB7OSCG9GR0KwEG9KYmVValF+fFFpTmrxIUYmDk6pBsacz1/f8j+O/2mbOCvXxUnl2IUE
	valSDafW3DjcvnEBY3pQ1dG1HBlRwR+PHXf3D9F/Gal/1zxRR/bNp0XM9m/1FTOfXF/3YMey
	K6lPpki1urZ/ENuSuPBDRkQTg30v05e3k1fG3dsQ8innwLmGBaZfUtcp1vxUuK3z30S7MSHd
	2Lqv+UVqrqsSS3FGoqEWc1FxIgBhijyg+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO 0 is a valid GPIO so allow using it as external control for
regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s5m8767.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 5daa06626f16..c79af943a5c0 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -528,16 +528,6 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
-static void s5m8767_pmic_dt_parse_ext_control_gpio(struct sec_pmic_dev *iodev,
-		struct sec_regulator_data *rdata,
-		struct device_node *reg_np)
-{
-	rdata->ext_control_gpio = of_get_named_gpio(reg_np,
-			"s5m8767,pmic-ext-control-gpios", 0);
-	if (!gpio_is_valid(rdata->ext_control_gpio))
-		rdata->ext_control_gpio = 0;
-}
-
 static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
@@ -586,7 +576,8 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			continue;
 		}
 
-		s5m8767_pmic_dt_parse_ext_control_gpio(iodev, rdata, reg_np);
+		rdata->ext_control_gpio = of_get_named_gpio(reg_np,
+			"s5m8767,pmic-ext-control-gpios", 0);
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
@@ -959,8 +950,9 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.driver_data = s5m8767;
 		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
-		config.ena_gpio = config.ena_gpio_flags = 0;
-		if (pdata->regulators[i].ext_control_gpio)
+		config.ena_gpio = -EINVAL;
+		config.ena_gpio_flags = 0;
+		if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
 			s5m8767_regulator_config_ext_control(s5m8767,
 					&pdata->regulators[i], &config);
 
@@ -973,7 +965,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 			return ret;
 		}
 
-		if (pdata->regulators[i].ext_control_gpio) {
+		if (gpio_is_valid(pdata->regulators[i].ext_control_gpio)) {
 			ret = s5m8767_enable_ext_control(s5m8767, rdev);
 			if (ret < 0) {
 				dev_err(s5m8767->dev,
-- 
1.9.1

