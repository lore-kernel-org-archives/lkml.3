Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3K1IKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:10:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18940 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3K1IJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:09:58 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-b0-5296fa54b1db
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/5] mfd/rtc: s5m: Fix register updating by adding regmap
 for RTC
Date: Thu, 28 Nov 2013 09:09:39 +0100
Message-id: <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xK7ohv6YFGex6Jm2x5OJVdoupD5+w
	WTy7tZfJ4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YHHg8
	ds66y+6xZ+JJNo9NqzrZPO5c28PmcehwB6PHvJOBHn1bVjF6TJ/3k8nj8ya5AM4oLpuU1JzM
	stQifbsEroz/R7cxFcw1qDi2r7yBsU+ji5GTQ0LAROLRw5ssELaYxIV769m6GLk4hASWMkps
	n76QFcLpY5Jo/fSCFaSKTcBYYvPyJWBVIgJzmSSmvz3LCOIwC+xilHj7cxcjSJWwQJjE7o+L
	mEBsFgFViQe3m8C6eQXcJQ4cmg9kcwDtU5CYM8kGJMwp4CGxZ/4+sBIhoJKfn+ewTWDkXcDI
	sIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJFS/7mBceszqEKMAB6MSD6+C8bQgIdbEsuLK
	3EOMEhzMSiK8CsVAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwpXl+aNY5p/9AKds1kSwrbWM14
	0WRplHdYVO7UbTGzlmfcEN+vcqd6xrHfk0JsZPQ3/jjp8nuzi4kp27RTPp4/xRb84TV0uFiV
	xs15XiicfZGryCzmeR7b9pbH827b07XRl8VTZu67Za8d/ZvOX1uy7JzRjNW/xWatEIpymv96
	9svNPhVbBUOVWIozEg21mIuKEwHJqu2IMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename old regmap field of "struct sec_pmic_dev" to "regmap_pmic" and
add new regmap for RTC.

On S5M8767A registers were not properly updated and read due to usage of
the same regmap as the PMIC. This could be observed in various hangs,
e.g. in infinite loop during waiting for UDR field change.

On this chip family the RTC has different I2C address than PMIC so
additional regmap is needed.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/sec-core.c           |   30 ++++++++++++++++++++++--------
 drivers/mfd/sec-irq.c            |    6 +++---
 drivers/regulator/s5m8767.c      |    2 +-
 drivers/rtc/rtc-s5m.c            |    2 +-
 include/linux/mfd/samsung/core.h |    3 ++-
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 34c18fb..54cc255 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -81,31 +81,31 @@ static struct of_device_id sec_dt_match[] = {
 
 int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
-	return regmap_read(sec_pmic->regmap, reg, dest);
+	return regmap_read(sec_pmic->regmap_pmic, reg, dest);
 }
 EXPORT_SYMBOL_GPL(sec_reg_read);
 
 int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_bulk_read(sec_pmic->regmap, reg, buf, count);
+	return regmap_bulk_read(sec_pmic->regmap_pmic, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(sec_bulk_read);
 
 int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value)
 {
-	return regmap_write(sec_pmic->regmap, reg, value);
+	return regmap_write(sec_pmic->regmap_pmic, reg, value);
 }
 EXPORT_SYMBOL_GPL(sec_reg_write);
 
 int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_raw_write(sec_pmic->regmap, reg, buf, count);
+	return regmap_raw_write(sec_pmic->regmap_pmic, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(sec_bulk_write);
 
 int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
 {
-	return regmap_update_bits(sec_pmic->regmap, reg, mask, val);
+	return regmap_update_bits(sec_pmic->regmap_pmic, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(sec_reg_update);
 
@@ -166,6 +166,11 @@ static struct regmap_config s5m8767_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct regmap_config sec_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 #ifdef CONFIG_OF
 /*
  * Only the common platform data elements for s5m8767 are parsed here from the
@@ -266,9 +271,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		break;
 	}
 
-	sec_pmic->regmap = devm_regmap_init_i2c(i2c, regmap);
-	if (IS_ERR(sec_pmic->regmap)) {
-		ret = PTR_ERR(sec_pmic->regmap);
+	sec_pmic->regmap_pmic = devm_regmap_init_i2c(i2c, regmap);
+	if (IS_ERR(sec_pmic->regmap_pmic)) {
+		ret = PTR_ERR(sec_pmic->regmap_pmic);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
 		return ret;
@@ -277,6 +282,15 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
+	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,
+			&sec_rtc_regmap_config);
+	if (IS_ERR(sec_pmic->regmap_rtc)) {
+		ret = PTR_ERR(sec_pmic->regmap_rtc);
+		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
+			ret);
+		return ret;
+	}
+
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 0dd84e9..b441b1b 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -280,19 +280,19 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
 	switch (type) {
 	case S5M8763X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s5m8763_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
 	case S5M8767X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s5m8767_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
 	case S2MPS11X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s2mps11_irq_chip,
 				  &sec_pmic->irq_data);
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index cbf91e2..aeb40aa 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -925,7 +925,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.dev = s5m8767->dev;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s5m8767;
-		config.regmap = iodev->regmap;
+		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
 
 		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 1dfa488..088cf3a 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -542,7 +542,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->regmap = s5m87xx->regmap;
+	info->regmap = s5m87xx->regmap_rtc;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 2d0c907..cab2dd2 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -39,7 +39,8 @@ enum sec_device_type {
 struct sec_pmic_dev {
 	struct device *dev;
 	struct sec_platform_data *pdata;
-	struct regmap *regmap;
+	struct regmap *regmap_pmic;
+	struct regmap *regmap_rtc;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
 
-- 
1.7.9.5

