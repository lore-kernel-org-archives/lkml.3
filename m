Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaDNHoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:44:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45698 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaDNHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:57 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-0c-534b91073493
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH resend] mfd/rtc: s5m: Do not allocate RTC I2C dummy and regmap
 for unsupported chipsets
Date: Mon, 14 Apr 2014 09:40:45 +0200
Message-id: <1397461245-818-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xy7rsE72DDRZu4bRYcvEqu8XGGetZ
	LV6/MLQ42/SG3eL+16OMFpd3zWGzmHF+H5PF2iN32S32d3YwWpzuZrW4uOILkwO3x56JJ9k8
	7lzbw+Yx72SgR9+WVYwe0+f9ZPL4vEkugC2KyyYlNSezLLVI3y6BK2PpzdSCr+4V69e0sDQw
	dlh1MXJySAiYSNz6cZERwhaTuHBvPVsXIxeHkMBSRonXb7czQzh9TBL3zl4Dq2ITMJbYvHwJ
	WJWIwC9GiRNH5oE5zAJHGSWm975lAqkSFsiU6Grdww5iswioSsxYdYMNxOYVcJVYO/EoC8Q+
	BYllX9YyT2DkXsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJKi+7GBcfMzqEKMAB6MS
	D2/Cds9gIdbEsuLK3EOMEhzMSiK82zK8goV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw9u5iYo9e
	HxSqoRkeUMfoW5gl+P6v4+Ivy3z2pCa+k+D6/1lgS9qRHp3pSqEau3NuqL2ay3X+xse1ocuk
	3+gfEtkWMiPTW+GDU5ZmxLLSi8o7bkxdci7onpKxq9C36VM0bT9FMK+fr3FvkeaGiZ1WSZcn
	2HPN3bLsUs13pYMZfulnGZuay3sdlFiKMxINtZiLihMBWDhqVAgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-s5m driver does not support all of S2M and S5M chipsets
supported by main MFD sec-core driver. For such chipsets unsupported by
rtc-s5m, the MFD sec-core driver initialized regmap with default config.
This config in such cases wouldn't work at all.

The main MFD sec-core driver shouldn't initialize regmap for child
drivers which is not used by them and even not valid.

Move the allocation of RTC I2C dummy device and initialization of RTC
regmap from main MFD sec-core driver to the rtc-s5m driver. The rtc-s5m
driver will use proper regmap config for supported devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c           | 53 +---------------------------
 drivers/rtc/rtc-s5m.c            | 75 +++++++++++++++++++++++++++++++++++++---
 include/linux/mfd/samsung/core.h |  3 --
 3 files changed, 71 insertions(+), 60 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 1cf27521fff4..d4682c6cbff5 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -25,7 +25,6 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
-#include <linux/mfd/samsung/rtc.h>
 #include <linux/mfd/samsung/s2mpa01.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
@@ -196,20 +195,6 @@ static const struct regmap_config s5m8767_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
-static const struct regmap_config s5m_rtc_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-
-	.max_register = SEC_RTC_REG_MAX,
-};
-
-static const struct regmap_config s2mps14_rtc_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-
-	.max_register = S2MPS_RTC_REG_MAX,
-};
-
 #ifdef CONFIG_OF
 /*
  * Only the common platform data elements for s5m8767 are parsed here from the
@@ -264,7 +249,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
-	const struct regmap_config *regmap, *regmap_rtc;
+	const struct regmap_config *regmap;
 	struct sec_pmic_dev *sec_pmic;
 	int ret;
 
@@ -298,39 +283,21 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	switch (sec_pmic->device_type) {
 	case S2MPA01:
 		regmap = &s2mpa01_regmap_config;
-		/*
-		 * The rtc-s5m driver does not support S2MPA01 and there
-		 * is no mfd_cell for S2MPA01 RTC device.
-		 * However we must pass something to devm_regmap_init_i2c()
-		 * so use S5M-like regmap config even though it wouldn't work.
-		 */
-		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	case S2MPS11X:
 		regmap = &s2mps11_regmap_config;
-		/*
-		 * The rtc-s5m driver does not support S2MPS11 and there
-		 * is no mfd_cell for S2MPS11 RTC device.
-		 * However we must pass something to devm_regmap_init_i2c()
-		 * so use S5M-like regmap config even though it wouldn't work.
-		 */
-		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	case S2MPS14X:
 		regmap = &s2mps14_regmap_config;
-		regmap_rtc = &s2mps14_rtc_regmap_config;
 		break;
 	case S5M8763X:
 		regmap = &s5m8763_regmap_config;
-		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	case S5M8767X:
 		regmap = &s5m8767_regmap_config;
-		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	default:
 		regmap = &sec_regmap_config;
-		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	}
 
@@ -342,21 +309,6 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
-	if (!sec_pmic->rtc) {
-		dev_err(&i2c->dev, "Failed to allocate I2C for RTC\n");
-		return -ENODEV;
-	}
-	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
-
-	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc, regmap_rtc);
-	if (IS_ERR(sec_pmic->regmap_rtc)) {
-		ret = PTR_ERR(sec_pmic->regmap_rtc);
-		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
-			ret);
-		goto err_regmap_rtc;
-	}
-
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
@@ -403,8 +355,6 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 
 err_mfd:
 	sec_irq_exit(sec_pmic);
-err_regmap_rtc:
-	i2c_unregister_device(sec_pmic->rtc);
 	return ret;
 }
 
@@ -414,7 +364,6 @@ static int sec_pmic_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(sec_pmic->dev);
 	sec_irq_exit(sec_pmic);
-	i2c_unregister_device(sec_pmic->rtc);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 476af93543f6..8ec2d6a1dbe1 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -40,6 +40,7 @@
 
 struct s5m_rtc_info {
 	struct device *dev;
+	struct i2c_client *i2c;
 	struct sec_pmic_dev *s5m87xx;
 	struct regmap *regmap;
 	struct rtc_device *rtc_dev;
@@ -49,6 +50,20 @@ struct s5m_rtc_info {
 	bool wtsr_smpl;
 };
 
+static const struct regmap_config s5m_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = SEC_RTC_REG_MAX,
+};
+
+static const struct regmap_config s2mps14_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPS_RTC_REG_MAX,
+};
+
 static void s5m8767_data_to_tm(u8 *data, struct rtc_time *tm,
 			       int rtc_24hr_mode)
 {
@@ -554,6 +569,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	struct sec_pmic_dev *s5m87xx = dev_get_drvdata(pdev->dev.parent);
 	struct sec_platform_data *pdata = s5m87xx->pdata;
 	struct s5m_rtc_info *info;
+	const struct regmap_config *regmap_cfg;
 	int ret;
 
 	if (!pdata) {
@@ -565,9 +581,37 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	switch (pdata->device_type) {
+	case S2MPS14X:
+		regmap_cfg = &s2mps14_rtc_regmap_config;
+		break;
+	case S5M8763X:
+		regmap_cfg = &s5m_rtc_regmap_config;
+		break;
+	case S5M8767X:
+		regmap_cfg = &s5m_rtc_regmap_config;
+		break;
+	default:
+		dev_err(&pdev->dev, "Device type is not supported by RTC driver\n");
+		return -ENODEV;
+	}
+
+	info->i2c = i2c_new_dummy(s5m87xx->i2c->adapter, RTC_I2C_ADDR);
+	if (!info->i2c) {
+		dev_err(&pdev->dev, "Failed to allocate I2C for RTC\n");
+		return -ENODEV;
+	}
+
+	info->regmap = devm_regmap_init_i2c(info->i2c, regmap_cfg);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(&pdev->dev, "Failed to allocate RTC register map: %d\n",
+				ret);
+		goto err;
+	}
+
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->regmap = s5m87xx->regmap_rtc;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
@@ -585,7 +629,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	default:
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "Unsupported device type: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, info);
@@ -602,15 +646,24 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "s5m-rtc",
 						 &s5m_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(info->rtc_dev))
-		return PTR_ERR(info->rtc_dev);
+	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
+		goto err;
+	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
 					s5m_rtc_alarm_irq, 0, "rtc-alarm0",
 					info);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	i2c_unregister_device(info->i2c);
 
 	return ret;
 }
@@ -639,6 +692,17 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	s5m_rtc_enable_smpl(info, false);
 }
 
+static int s5m_rtc_remove(struct platform_device *pdev)
+{
+	struct s5m_rtc_info *info = platform_get_drvdata(pdev);
+
+	/* Perform also all shutdown steps when removing */
+	s5m_rtc_shutdown(pdev);
+	i2c_unregister_device(info->i2c);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int s5m_rtc_resume(struct device *dev)
 {
@@ -676,6 +740,7 @@ static struct platform_driver s5m_rtc_driver = {
 		.pm	= &s5m_rtc_pm_ops,
 	},
 	.probe		= s5m_rtc_probe,
+	.remove		= s5m_rtc_remove,
 	.shutdown	= s5m_rtc_shutdown,
 	.id_table	= s5m_rtc_id,
 };
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 157e32b6ca28..84aaf6c25794 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -28,7 +28,6 @@ enum sec_device_type {
  * @dev: master device of the chip (can be used to access platform data)
  * @pdata: pointer to private data used to pass platform data to child
  * @i2c: i2c client private data for regulator
- * @rtc: i2c client private data for rtc
  * @iolock: mutex for serializing io access
  * @irqlock: mutex for buslock
  * @irq_base: base IRQ number for sec-pmic, required for IRQs
@@ -42,9 +41,7 @@ struct sec_pmic_dev {
 	struct device *dev;
 	struct sec_platform_data *pdata;
 	struct regmap *regmap_pmic;
-	struct regmap *regmap_rtc;
 	struct i2c_client *i2c;
-	struct i2c_client *rtc;
 
 	int device_type;
 	int irq_base;
-- 
1.8.3.2

