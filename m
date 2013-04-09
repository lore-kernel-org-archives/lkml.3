Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685Ab3DILDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:03:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49472 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762938Ab3DILDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:03:37 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-5b-5163f587e1e4
From: Andrzej Hajda <a.hajda@samsung.com>
To: sameo@linux.intel.com
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] max77693: added device tree support
Date: Tue, 09 Apr 2013 13:03:05 +0200
Message-id: <1365505385-24946-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xq7rtX5MDDWZNF7W4te4cq8WB2Q9Z
	Lc42vWG3uLxrDptFz4atrBaH37SzWpzuZnVg95h3MtDj/IyFjB59W1YxenzeJBfAEsVlk5Ka
	k1mWWqRvl8CVsWFHL1vBXJWKrc83sjcwHpLtYuTkkBAwkXg46wkzhC0mceHeerYuRi4OIYGl
	jBKPns5mBUkICfQxSbw9AdbAJqAp8XfzTTYQW0RAUuLZ43WMIA3MAvsYJRq7zjF1MXJwCANN
	fTtTGKSGRUBVYtWBW2ALeAWcJR4f2g61TFGi+9kEtgmM3AsYGVYxiqaWJhcUJ6XnGukVJ+YW
	l+al6yXn525ihITF1x2MS49ZHWIU4GBU4uGteJQUKMSaWFZcmXuIUYKDWUmEt+VOcqAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGxmsBIcL5Nl6vl7sJlbZbNsz76GK1Uf3D/73Xey74/9u6vXDv
	pKtxS9f57z4Rw9rK+sF1UckN7vefL/7/+Wp6ZFl5Z+gnpTaVR/mXTv+KKmI8e07quvy2R3of
	ZhuVt4tZM7eIxDpx9ZQVaTj9MagInsF998/Ey5WPD6gvPnBu4dLEgofahV9uximxFGckGmox
	FxUnAgBBD7Jq6QEAAA==
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
Hi Samuel,

This is "max77693: added device tree support" patch rebased to mfd-next/master.
I have added Documentation/devicetree/bindings/mfd/max77693.txt.
Thanks for the review.

Regards
Andrzej

 Documentation/devicetree/bindings/mfd/max77693.txt |   31 ++++++++++++
 drivers/mfd/max77693.c                             |   50 +++++++++++++++-----
 2 files changed, 68 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77693.txt

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
new file mode 100644
index 0000000..a7213b7
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -0,0 +1,31 @@
+Maxim MAX77693 multi-function device
+
+MAX77686 is a Mulitifunction device with the following submodules:
+- PMIC,
+- Charger,
+- LED,
+- MUIC,
+- HAPTIC.
+
+It is interfaced to host controller using i2c.
+This document describes the bindings for the mfd device.
+
+Required properties:
+- compatible : Must be "maxim,max77693".
+- reg : Specifies the i2c slave address of PMIC block.
+- interrupts : This i2c device has an IRQ line connected to the main SoC.
+- interrupt-parent : The parent interrupt controller.
+
+Optional properties:
+- wakeup-source : Indicates if the device can wakeup the system from the sleep
+	state.
+
+Example:
+max77693@66 {
+	compatible = "maxim,max77693";
+	reg = <0x66>;
+	interrupt-parent = <&gpx1>;
+	interrupts = <5 0>;
+	wakeup-source;
+	};
+};
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
1.7.10.4

