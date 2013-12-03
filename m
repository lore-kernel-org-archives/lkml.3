Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3LCT7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:59:33 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:55159 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3LCT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:59:28 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
Cc: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v3 1/3] mfd: tps6586x: add version detection
Date: Tue,  3 Dec 2013 20:57:27 +0100
Message-Id: <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386100296.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1386100296.git.stefan@agner.ch>
References: <cover.1386100296.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the VERSIONCRC to determine the exact device version. According to
the datasheet this register can be used as device identifier. The
identification is needed since some tps6586x regulators use a different
voltage table.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
Since the struct tps6586x is inside the c file, I could not easily
move the tps6586x_get_version function as inline to the header file.

Changes since v2:
  - Avoid moving devm_kzalloc
---
 drivers/mfd/tps6586x.c       | 43 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/mfd/tps6586x.h |  7 +++++++
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index ee61fd7..56a8422 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -124,6 +124,7 @@ struct tps6586x {
 	struct device		*dev;
 	struct i2c_client	*client;
 	struct regmap		*regmap;
+	int			version;
 
 	int			irq;
 	struct irq_chip		irq_chip;
@@ -208,6 +209,14 @@ int tps6586x_irq_get_virq(struct device *dev, int irq)
 }
 EXPORT_SYMBOL_GPL(tps6586x_irq_get_virq);
 
+int tps6586x_get_version(struct device *dev)
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
@@ -472,6 +481,31 @@ static void tps6586x_power_off(void)
 	tps6586x_set_bits(tps6586x_dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
 }
 
+static void tps6586x_print_version(struct i2c_client *client, int version)
+{
+	const char *name;
+
+	switch (version) {
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
+	}
+
+	dev_info(&client->dev, "Found %s, VERSIONCRC is %02x\n", name, version);
+}
+
 static int tps6586x_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -493,13 +527,12 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
-
 	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
-	if (tps6586x == NULL) {
-		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
+	if (!tps6586x)
 		return -ENOMEM;
-	}
+
+	tps6586x->version = ret;
+	tps6586x_print_version(client, tps6586x->version);
 
 	tps6586x->client = client;
 	tps6586x->dev = &client->dev;
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 8799454..cbecec2 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -13,6 +13,12 @@
 #define TPS6586X_SLEW_RATE_SET		0x08
 #define TPS6586X_SLEW_RATE_MASK         0x07
 
+/* VERSION CRC */
+#define TPS658621A	0x15
+#define TPS658621CD	0x2c
+#define TPS658623	0x1b
+#define TPS658643	0x03
+
 enum {
 	TPS6586X_ID_SYS,
 	TPS6586X_ID_SM_0,
@@ -97,5 +103,6 @@ extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
 			   uint8_t mask);
 extern int tps6586x_irq_get_virq(struct device *dev, int irq);
+extern int tps6586x_get_version(struct device *dev);
 
 #endif /*__LINUX_MFD_TPS6586X_H */
-- 
1.8.4.2

