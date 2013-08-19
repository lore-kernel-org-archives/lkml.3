Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab3HSKMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:12:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38241 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3HSKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:12:51 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-e5-5211efa06bcf
From: Andrzej Hajda <a.hajda@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND] max77693: added device tree support
Date: Mon, 19 Aug 2013 12:12:00 +0200
Message-id: <1376907121-13815-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xK7oL3wsGGXxWtri17hyrxfwjQOLA
	nx2MFm96O1gsOs8+YbY42/SG3eL+16OMFpd3zWGzWHr9IpPFhOlrWSwOrzjAZLHu5XQg6007
	q8XpblaLVwfbWBz4PdbMW8PoseDzFXaP15MnMHq8Wj2T1ePOtT1sHvNOBnr0bVnF6PF5k5zH
	xrmhAZxRXDYpqTmZZalF+nYJXBlNq7YzFiyVr2heq9zAuE+yi5GTQ0LAROLJnDXMELaYxIV7
	69m6GLk4hASWMkrMmdLBAuH0MUlcetvIAlLFJqAp8XfzTaAqDg4RARWJc2/MQWqYBU6xSMxt
	vc0EUiMsYC1x+VgfmM0ioCrxbWcrO4jNK+Assf/2bkaIbQoSPy+fYJvAyL2AkWEVo2hqaXJB
	cVJ6rpFecWJucWleul5yfu4mRkhQft3BuPSY1SFGAQ5GJR5eCzfBICHWxLLiytxDjBIczEoi
	vCxqQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mrn+frLyT2XTs8b+uzm3c79dbtx4SUsljmdNi
	8dNY4q6V8j6+wPb1mz/2v95400C9OX7i28inp7+5hfIYlXGf2L9nxsmazf+cP/7Y7WTQFMIk
	vI7Dsn1bz4qAxvtsv1Z+ZTQWl+iKuszEdULXW+7VEhOLANX0jLZDWuWi3gezE1ceuRx2R71K
	iaU4I9FQi7moOBEANs0XPygCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max77693 mfd main device uses only wakeup field
from max77693_platform_data. This field is mapped
to wakeup-source common property in device tree.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi Lee,

This is the patch for max77693 DT support rebased onto v3.11-rc5.

Regards
Andrzej
---

 Documentation/devicetree/bindings/mfd/max77693.txt |  2 +
 drivers/mfd/max77693.c                             | 50 ++++++++++++++++------
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..4138ad4 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -19,6 +19,8 @@ Required properties:
 Optional properties:
 - regulators : The regulators of max77693 have to be instantiated under subnod
   named "regulators" using the following format.
+- wakeup-source : Indicates if the device can wakeup the system from the sleep
+  state.
 
 	regulators {
 		regualtor-compatible = ESAFEOUT1/ESAFEOUT2/CHARGER
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9e60fed..6045706 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -106,29 +106,41 @@ static const struct regmap_config max77693_regmap_config = {
 	.max_register = MAX77693_PMIC_REG_END,
 };
 
+static int max77693_get_platform_data(struct max77693_dev *max77693,
+				      struct device *dev)
+{
+	struct device_node *node = dev->of_node;
+	struct max77693_platform_data *pdata = dev->platform_data;
+
+	if (node) {
+		max77693->wakeup = of_property_read_bool(node, "wakeup-source");
+		return 0;
+	}
+
+	if (pdata) {
+		max77693->wakeup = pdata->wakeup;
+		return 0;
+	}
+
+	dev_err(dev, "No platform data found.\n");
+	return -EINVAL;
+}
+
 static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77693_dev *max77693;
-	struct max77693_platform_data *pdata = i2c->dev.platform_data;
 	u8 reg_data;
 	int ret = 0;
 
-	if (!pdata) {
-		dev_err(&i2c->dev, "No platform data found.\n");
-		return -EINVAL;
-	}
-
 	max77693 = devm_kzalloc(&i2c->dev,
 			sizeof(struct max77693_dev), GFP_KERNEL);
 	if (max77693 == NULL)
 		return -ENOMEM;
 
-	i2c_set_clientdata(i2c, max77693);
-	max77693->dev = &i2c->dev;
-	max77693->i2c = i2c;
-	max77693->irq = i2c->irq;
-	max77693->type = id->driver_data;
+	ret = max77693_get_platform_data(max77693, &i2c->dev);
+	if (ret < 0)
+		return ret;
 
 	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
 	if (IS_ERR(max77693->regmap)) {
@@ -138,7 +150,11 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	max77693->wakeup = pdata->wakeup;
+	i2c_set_clientdata(i2c, max77693);
+	max77693->dev = &i2c->dev;
+	max77693->i2c = i2c;
+	max77693->irq = i2c->irq;
+	max77693->type = id->driver_data;
 
 	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
 				&reg_data);
@@ -179,7 +195,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
-	device_init_wakeup(max77693->dev, pdata->wakeup);
+	device_init_wakeup(max77693->dev, max77693->wakeup);
 
 	return ret;
 
@@ -235,11 +251,19 @@ static const struct dev_pm_ops max77693_pm = {
 	.resume = max77693_resume,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id max77693_dt_match[] = {
+	{.compatible = "maxim,max77693"},
+	{},
+};
+#endif
+
 static struct i2c_driver max77693_i2c_driver = {
 	.driver = {
 		   .name = "max77693",
 		   .owner = THIS_MODULE,
 		   .pm = &max77693_pm,
+		   .of_match_table = of_match_ptr(max77693_dt_match),
 	},
 	.probe = max77693_i2c_probe,
 	.remove = max77693_i2c_remove,
-- 
1.8.1.2

