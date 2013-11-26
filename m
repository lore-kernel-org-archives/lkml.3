Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3KZXzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:55:10 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:40335 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3KZXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:55:05 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de
Cc: mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 1/3] mfd: tps6586x: add version detection
Date: Wed, 27 Nov 2013 00:45:43 +0100
Message-Id: <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1385508112.git.stefan@agner.ch>
References: <cover.1385508112.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the VERSIONCRC to determine the exact device version. According to
the datasheet this register can be used as device identifier. The
identification is needed since some tps6586x regulators use a different
voltage table.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/mfd/tps6586x.c       | 41 +++++++++++++++++++++++++++++++++++------
 include/linux/mfd/tps6586x.h |  9 +++++++++
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index ee61fd7..a3ba9c1 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -124,6 +124,7 @@ struct tps6586x {
 	struct device		*dev;
 	struct i2c_client	*client;
 	struct regmap		*regmap;
+	enum tps6586x_version	version;
 
 	int			irq;
 	struct irq_chip		irq_chip;
@@ -208,6 +209,14 @@ int tps6586x_irq_get_virq(struct device *dev, int irq)
 }
 EXPORT_SYMBOL_GPL(tps6586x_irq_get_virq);
 
+enum tps6586x_version tps6586x_get_version(struct device *dev)
+{
+	struct tps6586x *tps6586x = dev_get_drvdata(dev);
+
+	return tps6586x->version;
+}
+EXPORT_SYMBOL_GPL(tps6586x_get_version);
+
 static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
@@ -477,6 +486,7 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
 {
 	struct tps6586x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct tps6586x *tps6586x;
+	const char *name = "";
 	int ret;
 
 	if (!pdata && client->dev.of_node)
@@ -487,20 +497,39 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
 		return -ENOTSUPP;
 	}
 
+	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
+	if (tps6586x == NULL) {
+		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
+		return -ENOMEM;
+	}
+
 	ret = i2c_smbus_read_byte_data(client, TPS6586X_VERSIONCRC);
 	if (ret < 0) {
 		dev_err(&client->dev, "Chip ID read failed: %d\n", ret);
 		return -EIO;
 	}
 
-	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
-
-	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
-	if (tps6586x == NULL) {
-		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
-		return -ENOMEM;
+	tps6586x->version = (enum tps6586x_version)ret;
+	switch (ret) {
+	case TPS658621A:
+		name = "TPS658621A";
+		break;
+	case TPS658621CD:
+		name = "TPS658621C/D";
+		break;
+	case TPS658623:
+		name = "TPS658623";
+		break;
+	case TPS658643:
+		name = "TPS658643";
+		break;
+	default:
+		name = "TPS6586X";
+		break;
 	}
 
+	dev_info(&client->dev, "Found %s, VERSIONCRC is %02x\n", name, ret);
+
 	tps6586x->client = client;
 	tps6586x->dev = &client->dev;
 	i2c_set_clientdata(client, tps6586x);
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 8799454..40a36a0 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -62,6 +62,14 @@ enum {
 	TPS6586X_INT_RTC_ALM2,
 };
 
+enum tps6586x_version {
+	TPS658621A	= 0x15,
+	TPS658621CD	= 0x2c,
+	TPS658623	= 0x1b,
+	TPS658643	= 0x03,
+	TPS6586X_ANY	= -1,
+};
+
 struct tps6586x_settings {
 	int slew_rate;
 };
@@ -97,5 +105,6 @@ extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
 			   uint8_t mask);
 extern int tps6586x_irq_get_virq(struct device *dev, int irq);
+extern enum tps6586x_version tps6586x_get_version(struct device *dev);
 
 #endif /*__LINUX_MFD_TPS6586X_H */
-- 
1.8.4.2

