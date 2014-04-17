Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaDQJlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:41:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54795 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbaDQJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:40:17 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 2/2] regmap: i2c: fallback to SMBus if the adapter does not support standard I2C
Date: Thu, 17 Apr 2014 11:40:12 +0200
Message-Id: <1397727612-32103-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some I2C adapters are only compatible with the SMBus protocol and do not
support standard I2C transfers.

Fallback to SMBus transfers if we encounter such kind of adapters.
The transfer type is chosen according to the val_bits field in the regmap
config.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/base/regmap/regmap-i2c.c | 104 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index ebd1895..d82830b 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -14,6 +14,79 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 
+
+static int regmap_smbus_byte_reg_read(void *context, unsigned int reg,
+				      unsigned int *val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+	int ret;
+
+	if (reg > 0xff)
+		return -EINVAL;
+
+	ret = i2c_smbus_read_byte_data(i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = ret;
+
+	return 0;
+}
+
+static int regmap_smbus_byte_reg_write(void *context, unsigned int reg,
+				       unsigned int val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (val > 0xff || reg > 0xff)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(i2c, reg, val);
+}
+
+static struct regmap_bus regmap_smbus_byte = {
+	.reg_write = regmap_smbus_byte_reg_write,
+	.reg_read = regmap_smbus_byte_reg_read,
+};
+
+static int regmap_smbus_word_reg_read(void *context, unsigned int reg,
+				      unsigned int *val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+	int ret;
+
+	if (reg > 0xffff)
+		return -EINVAL;
+
+	ret = i2c_smbus_read_word_data(i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	*val = ret;
+
+	return 0;
+}
+
+static int regmap_smbus_word_reg_write(void *context, unsigned int reg,
+				       unsigned int val)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (val > 0xffff || reg > 0xffff)
+		return -EINVAL;
+
+	return i2c_smbus_write_word_data(i2c, reg, val);
+}
+
+static struct regmap_bus regmap_smbus_word = {
+	.reg_write = regmap_smbus_word_reg_write,
+	.reg_read = regmap_smbus_word_reg_read,
+};
+
 static int regmap_i2c_write(void *context, const void *data, size_t count)
 {
 	struct device *dev = context;
@@ -97,6 +170,23 @@ static struct regmap_bus regmap_i2c = {
 	.read = regmap_i2c_read,
 };
 
+const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
+					    const struct regmap_config *config)
+{
+	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C))
+		return &regmap_i2c;
+	else if (config->val_bits == 16 &&
+		 i2c_check_functionality(i2c->adapter,
+					 I2C_FUNC_SMBUS_WORD_DATA))
+		return &regmap_smbus_word;
+	else if (config->val_bits == 8 &&
+		 i2c_check_functionality(i2c->adapter,
+					 I2C_FUNC_SMBUS_BYTE_DATA))
+		return &regmap_smbus_byte;
+
+	return ERR_PTR(-ENOTSUPP);
+}
+
 /**
  * regmap_init_i2c(): Initialise register map
  *
@@ -109,7 +199,12 @@ static struct regmap_bus regmap_i2c = {
 struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config)
 {
-	return regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
+	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, config);
+
+	if (IS_ERR(bus))
+		return ERR_PTR(PTR_ERR(bus));
+
+	return regmap_init(&i2c->dev, bus, &i2c->dev, config);
 }
 EXPORT_SYMBOL_GPL(regmap_init_i2c);
 
@@ -126,7 +221,12 @@ EXPORT_SYMBOL_GPL(regmap_init_i2c);
 struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config)
 {
-	return devm_regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
+	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, config);
+
+	if (IS_ERR(bus))
+		return ERR_PTR(PTR_ERR(bus));
+
+	return devm_regmap_init(&i2c->dev, bus, &i2c->dev, config);
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_i2c);
 
-- 
1.8.3.2

