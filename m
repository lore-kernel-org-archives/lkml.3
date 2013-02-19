Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3BSPht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:37:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37480 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3BSPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:37:00 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-ca-51239c1a8451
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v2 1/2] max77693: added device tree support
Date: Tue, 19 Feb 2013 16:36:16 +0100
Message-id: <1361288177-14452-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
References: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t/xy7pSc5QDDfY8YLW4vGsOm0XPhq2s
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcXNbCWnBVvOLb28WsDYwLhbsYOTkkBEwkPh/tZIew
	xSQu3FvP1sXIxSEksJRR4nzjElYIp49J4s/JDWwgVWwCmhJ/N98Es0UE5CWe9N4A62AWmMEk
	sfr9IhaQhLCAvcTFGx3MIDaLgKpE39e9YHFeAWeJpy+mMkKsU5TofjYBbBCngIvEwn9XwOqF
	gGpaL05mmsDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGiP+/7mBceszqEKMAB6MS
	D6+Hi1KgEGtiWXFl7iFGCQ5mJRHe+ZbKgUK8KYmVValF+fFFpTmpxYcYmTg4pRoY+08+ipmz
	ytfSSnTOx0KPexVTd+jVTbCwUxD4d7ou9rPYQ5MIS9nrzBtqw/cw7ihprlWSnPz57qWzC6MD
	de8d/188YYGr7fxXGTM89uz6nVlqyG4RcumlS/M/a7cryfu/ZT1kftKht6gk1CbI3unMtFKN
	SV5zAhgyet++8+belW/OWBY37xWvEktxRqKhFnNRcSIAeAB0VN0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max77693 mfd main device uses only wakeup field
from max77693_platform_data. This field is mapped
to wakeup-source property in device tree.
Device tree bindings doc will be added in max77693-led patch.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max77693.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index cc5155e..46223da 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -106,11 +106,30 @@ static const struct regmap_config max77693_regmap_config = {
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
 
@@ -119,6 +138,10 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	if (max77693 == NULL)
 		return -ENOMEM;
 
+	ret = max77693_get_platform_data(max77693, &i2c->dev);
+	if (ret < 0)
+		return ret;
+
 	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
 	if (IS_ERR(max77693->regmap)) {
 		ret = PTR_ERR(max77693->regmap);
@@ -133,11 +156,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	max77693->irq = i2c->irq;
 	max77693->type = id->driver_data;
 
-	if (!pdata)
-		goto err_regmap;
-
-	max77693->wakeup = pdata->wakeup;
-
 	if (max77693_read_reg(max77693->regmap,
 				MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
 		dev_err(max77693->dev, "device not found on this channel\n");
@@ -177,7 +195,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
-	device_init_wakeup(max77693->dev, pdata->wakeup);
+	device_init_wakeup(max77693->dev, max77693->wakeup);
 
 	return ret;
 
@@ -233,11 +251,19 @@ static const struct dev_pm_ops max77693_pm = {
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
1.7.10.4

