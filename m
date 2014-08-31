Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaHaTLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:11:10 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:44083 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHaTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:11:06 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sun, 31 Aug 2014 21:11:05 +0200
X-ME-IP: 90.38.41.55
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 RESEND 1/2] regulator: max1586 add device-tree support
Date: Sun, 31 Aug 2014 21:10:51 +0200
Message-Id: <1409512253-15738-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree support to max1586.
The driver can still be used with the legacy platform data, or the new
device-tree way.

This work is heavily inspired by the device-tree support of its cousin
max8660 driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

---
Since V1: added the comment about regulator not being able to be
          queried.
          See https://lkml.org/lkml/2014/6/24/899
---
 drivers/regulator/max1586.c       | 81 ++++++++++++++++++++++++++++++++++++++-
 include/linux/regulator/max1586.h |  2 +-
 2 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index d23d057..5c04a71 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -24,6 +24,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/slab.h>
 #include <linux/regulator/max1586.h>
+#include <linux/of_device.h>
+#include <linux/regulator/of_regulator.h>
 
 #define MAX1586_V3_MAX_VSEL 31
 #define MAX1586_V6_MAX_VSEL 3
@@ -157,13 +159,87 @@ static struct regulator_desc max1586_reg[] = {
 	},
 };
 
+int of_get_max1586_platform_data(struct device *dev,
+				 struct max1586_platform_data *pdata)
+{
+	struct max1586_subdev_data *sub;
+	struct of_regulator_match rmatch[ARRAY_SIZE(max1586_reg)];
+	struct device_node *np = dev->of_node;
+	int i, matched;
+
+	if (of_property_read_u32(np, "v3-gain",
+				 &pdata->v3_gain) < 0) {
+		dev_err(dev, "%s has no 'v3-gain' property\n", np->full_name);
+		return -EINVAL;
+	}
+
+	np = of_get_child_by_name(np, "regulators");
+	if (!np) {
+		dev_err(dev, "missing 'regulators' subnode in DT\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rmatch); i++)
+		rmatch[i].name = max1586_reg[i].name;
+
+	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
+	of_node_put(np);
+	/*
+	 * If matched is 0, ie. neither Output_V3 nor Output_V6 have been found,
+	 * return 0, which signals the normal situation where no subregulator is
+	 * available. This is normal because the max1586 doesn't provide any
+	 * readback support, so the subregulators can't report any status
+	 * anyway.  If matched < 0, return the error.
+	 */
+	if (matched <= 0)
+		return matched;
+
+	pdata->subdevs = devm_kzalloc(dev, sizeof(struct max1586_subdev_data) *
+						matched, GFP_KERNEL);
+	if (!pdata->subdevs)
+		return -ENOMEM;
+
+	pdata->num_subdevs = matched;
+	sub = pdata->subdevs;
+
+	for (i = 0; i < matched; i++) {
+		sub->id = i;
+		sub->name = rmatch[i].of_node->name;
+		sub->platform_data = rmatch[i].init_data;
+		sub++;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id max1586_of_match[] = {
+	{ .compatible = "maxim,max1586", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, max1586_of_match);
+
 static int max1586_pmic_probe(struct i2c_client *client,
 					const struct i2c_device_id *i2c_id)
 {
-	struct max1586_platform_data *pdata = dev_get_platdata(&client->dev);
+	struct max1586_platform_data *pdata, pdata_of;
 	struct regulator_config config = { };
 	struct max1586_data *max1586;
-	int i, id;
+	int i, id, ret;
+	const struct of_device_id *match;
+
+	pdata = dev_get_platdata(&client->dev);
+	if (client->dev.of_node && !pdata) {
+		match = of_match_device(of_match_ptr(max1586_of_match),
+					&client->dev);
+		if (!match) {
+			dev_err(&client->dev, "Error: No device match found\n");
+			return -ENODEV;
+		}
+		ret = of_get_max1586_platform_data(&client->dev, &pdata_of);
+		if (ret < 0)
+			return ret;
+		pdata = &pdata_of;
+	}
 
 	max1586 = devm_kzalloc(&client->dev, sizeof(struct max1586_data),
 			GFP_KERNEL);
@@ -229,6 +305,7 @@ static struct i2c_driver max1586_pmic_driver = {
 	.driver		= {
 		.name	= "max1586",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(max1586_of_match),
 	},
 	.id_table	= max1586_id,
 };
diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
index de9a7fa..cedd0fe 100644
--- a/include/linux/regulator/max1586.h
+++ b/include/linux/regulator/max1586.h
@@ -40,7 +40,7 @@
  */
 struct max1586_subdev_data {
 	int				id;
-	char				*name;
+	const char			*name;
 	struct regulator_init_data	*platform_data;
 };
 
-- 
2.0.0.rc2

