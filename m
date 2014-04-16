Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaDPIQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:16:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46220 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750913AbaDPIQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:16:16 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] regmap: i2c: fallback to SMBus if the adapter does not support standard I2C
Date: Wed, 16 Apr 2014 10:16:10 +0200
Message-Id: <1397636170-664-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140415223849.GJ12304@sirena.org.uk>
References: <20140415223849.GJ12304@sirena.org.uk>
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
Hello Mark, Lars,

Would this patch be acceptable ?

I'm still not convinced that we can decide which kind of protocol should
be used based only on the adapter functionalities and the val_bytes field.

But doing this as a first step should work in my case (my adapter only
supports SMBus byte transfers :-)).

Note that this patch has not been tested yet. I'll test it and resend a
proper version, if you agree on the implementation.

Best Regards,

Boris

 drivers/base/regmap/regmap-i2c.c | 101 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index ebd1895..80051c5 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -14,6 +14,69 @@
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
 static int regmap_i2c_write(void *context, const void *data, size_t count)
 {
 	struct device *dev = context;
@@ -97,6 +160,28 @@ static struct regmap_bus regmap_i2c = {
 	.read = regmap_i2c_read,
 };
 
+const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
+					    struct regmap_config *config)
+{
+	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C)) {
+		return &regmap_i2c;
+	} else if (config->val_bits == 16 &&
+		   i2c_check_functionality(i2c->adapter,
+					   I2C_FUNC_SMBUS_WORD_DATA)) {
+                config->reg_read = regmap_smbus_word_reg_read;
+                config->reg_write = regmap_smbus_word_reg_write;
+		return NULL;
+	} else if (config->val_bits == 8 &&
+		   i2c_check_functionality(i2c->adapter,
+					   I2C_FUNC_SMBUS_BYTE_DATA)) {
+                config->reg_read = regmap_smbus_byte_reg_read;
+                config->reg_write = regmap_smbus_byte_reg_write;
+		return NULL;
+	}
+
+	return ERR_PTR(-ENOTSUPP);
+}
+
 /**
  * regmap_init_i2c(): Initialise register map
  *
@@ -109,7 +194,13 @@ static struct regmap_bus regmap_i2c = {
 struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config)
 {
-	return regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
+	struct regmap_config upd_conf = *config;
+	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, &upd_conf);
+
+	if (IS_ERR(bus))
+		return ERR_PTR(PTR_ERR(bus));
+
+	return regmap_init(&i2c->dev, bus, &i2c->dev, &upd_conf);
 }
 EXPORT_SYMBOL_GPL(regmap_init_i2c);
 
@@ -126,7 +217,13 @@ EXPORT_SYMBOL_GPL(regmap_init_i2c);
 struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config)
 {
-	return devm_regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
+	struct regmap_config upd_conf = *config;
+	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, &upd_conf);
+
+	if (IS_ERR(bus))
+		return ERR_PTR(PTR_ERR(bus));
+
+	return devm_regmap_init(&i2c->dev, bus, &i2c->dev, &upd_conf);
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_i2c);
 
-- 
1.8.3.2

