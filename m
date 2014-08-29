Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaH2O2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:28:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:36792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbaH2O1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="473821915"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Derek Basehore <dbasehore@chromium.org>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 2/3] staging: iio: light: isl29018: add support for isl29023 and isl29035
Date: Fri, 29 Aug 2014 17:26:21 +0300
Message-Id: <1409322382-30021-3-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com>
References: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intersil chips ISL29018, ISL29023 and ISL29035 are very similar. They're
all ambience light sensors. The ISL29018, however, is also a proximity
sensor. The registers are similar too:

-------------+----------+----------
AVAILABLE IN | ADDR REG | NAME
   290xx     |          |
-------------+----------+----------
     18/23/35|       00h| COMMANDI
     18/23/35|       01h| COMMANDII (B4-7 are used only in 29018 for proximity)
     18/23/35|       02h| DATALSB
     18/23/35|       03h| DATAMSB
     18/23/35|       04h| INT_LT_LSB
     18/23/35|       05h| INT_LT_MSB
     18/23/35|       06h| INT_HT_LSB
     18/23/35|       07h| INT_HT_MSB
        18/23|       08h| TEST
           35|       0Fh| ID
-------------+----------+-----------

So, this patch will add support for ISL29023 and ISL29035 to the
existing isl29018 driver. Since these 2 chips don't have proximity
detection, the proximity sysfs attribute is not needed.

Also, for ISL29035, since it has an ID register, make use of it in order
to properly detect the chip and clear the brownout bit.

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/staging/iio/light/isl29018.c | 163 ++++++++++++++++++++++++++++++-----
 1 file changed, 141 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 63c70be..b50f126 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -1,5 +1,5 @@
 /*
- * A iio driver for the light sensor ISL 29018.
+ * A iio driver for the light sensor ISL 29018/29023/29035.
  *
  * IIO driver for monitoring ambient light intensity in luxi, proximity
  * sensing and infrared sensing.
@@ -58,10 +58,18 @@
 #define ISL29018_TEST_SHIFT		0
 #define ISL29018_TEST_MASK		(0xFF << ISL29018_TEST_SHIFT)
 
+#define ISL29035_REG_DEVICE_ID		0x0F
+#define ISL29035_DEVICE_ID_SHIFT	0x03
+#define ISL29035_DEVICE_ID_MASK		(0x7 << ISL29035_DEVICE_ID_SHIFT)
+#define ISL29035_DEVICE_ID		0x5
+#define ISL29035_BOUT_SHIFT		0x07
+#define ISL29035_BOUT_MASK		(0x01 << ISL29035_BOUT_SHIFT)
+
 struct isl29018_chip {
 	struct device		*dev;
 	struct regmap		*regmap;
 	struct mutex		lock;
+	int			type;
 	unsigned int		lux_scale;
 	unsigned int		lux_uscale;
 	unsigned int		range;
@@ -407,23 +415,35 @@ static int isl29018_read_raw(struct iio_dev *indio_dev,
 	return ret;
 }
 
+#define ISL29018_LIGHT_CHANNEL {					\
+	.type = IIO_LIGHT,						\
+	.indexed = 1,							\
+	.channel = 0,							\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED) |		\
+	BIT(IIO_CHAN_INFO_CALIBSCALE),					\
+}
+
+#define ISL29018_IR_CHANNEL {						\
+	.type = IIO_INTENSITY,						\
+	.modified = 1,							\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),			\
+	.channel2 = IIO_MOD_LIGHT_IR,					\
+}
+
+#define ISL29018_PROXIMITY_CHANNEL {					\
+	.type = IIO_PROXIMITY,						\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),			\
+}
+
 static const struct iio_chan_spec isl29018_channels[] = {
-	{
-		.type = IIO_LIGHT,
-		.indexed = 1,
-		.channel = 0,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED) |
-		BIT(IIO_CHAN_INFO_CALIBSCALE),
-	}, {
-		.type = IIO_INTENSITY,
-		.modified = 1,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
-		.channel2 = IIO_MOD_LIGHT_IR,
-	}, {
-		/* Unindexed in current ABI.  But perhaps it should be. */
-		.type = IIO_PROXIMITY,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
-	}
+	ISL29018_LIGHT_CHANNEL,
+	ISL29018_IR_CHANNEL,
+	ISL29018_PROXIMITY_CHANNEL,
+};
+
+static const struct iio_chan_spec isl29023_channels[] = {
+	ISL29018_LIGHT_CHANNEL,
+	ISL29018_IR_CHANNEL,
 };
 
 static IIO_DEVICE_ATTR(range, S_IRUGO | S_IWUSR, show_range, store_range, 0);
@@ -447,16 +467,63 @@ static struct attribute *isl29018_attributes[] = {
 	NULL
 };
 
+static struct attribute *isl29023_attributes[] = {
+	ISL29018_DEV_ATTR(range),
+	ISL29018_CONST_ATTR(range_available),
+	ISL29018_DEV_ATTR(adc_resolution),
+	ISL29018_CONST_ATTR(adc_resolution_available),
+	NULL
+};
+
 static const struct attribute_group isl29018_group = {
 	.attrs = isl29018_attributes,
 };
 
+static const struct attribute_group isl29023_group = {
+	.attrs = isl29023_attributes,
+};
+
+static int isl29035_detect(struct isl29018_chip *chip)
+{
+	int status;
+	unsigned int id;
+
+	status = regmap_read(chip->regmap, ISL29035_REG_DEVICE_ID, &id);
+	if (status < 0) {
+		dev_err(chip->dev,
+			"Error reading ID register with error %d\n",
+			status);
+		return status;
+	}
+
+	id = (id & ISL29035_DEVICE_ID_MASK) >> ISL29035_DEVICE_ID_SHIFT;
+
+	if (id != ISL29035_DEVICE_ID)
+		return -ENODEV;
+
+	/* clear out brownout bit */
+	return regmap_update_bits(chip->regmap, ISL29035_REG_DEVICE_ID,
+				  ISL29035_BOUT_MASK, 0);
+}
+
+enum {
+	isl29018,
+	isl29023,
+	isl29035,
+};
+
 static int isl29018_chip_init(struct isl29018_chip *chip)
 {
 	int status;
 	unsigned int new_adc_bit;
 	unsigned int new_range;
 
+	if (chip->type == isl29035) {
+		status = isl29035_detect(chip);
+		if (status < 0)
+			return status;
+	}
+
 	/* Code added per Intersil Application Note 1534:
 	 *     When VDD sinks to approximately 1.8V or below, some of
 	 * the part's registers may change their state. When VDD
@@ -517,6 +584,13 @@ static const struct iio_info isl29018_info = {
 	.write_raw = &isl29018_write_raw,
 };
 
+static const struct iio_info isl29023_info = {
+	.attrs = &isl29023_group,
+	.driver_module = THIS_MODULE,
+	.read_raw = &isl29018_read_raw,
+	.write_raw = &isl29018_write_raw,
+};
+
 static bool is_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -524,6 +598,7 @@ static bool is_volatile_reg(struct device *dev, unsigned int reg)
 	case ISL29018_REG_ADD_DATA_MSB:
 	case ISL29018_REG_ADD_COMMAND1:
 	case ISL29018_REG_TEST:
+	case ISL29035_REG_DEVICE_ID:
 		return true;
 	default:
 		return false;
@@ -543,6 +618,44 @@ static const struct regmap_config isl29018_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+/* isl29035_regmap_config: regmap configuration for ISL29035 */
+static const struct regmap_config isl29035_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.volatile_reg = is_volatile_reg,
+	.max_register = ISL29035_REG_DEVICE_ID,
+	.num_reg_defaults_raw = ISL29035_REG_DEVICE_ID + 1,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+struct chip_info {
+	const struct iio_chan_spec *channels;
+	int num_channels;
+	const struct iio_info *indio_info;
+	const struct regmap_config *regmap_cfg;
+};
+
+static const struct chip_info chip_info_tbl[] = {
+	[isl29018] = {
+		.channels = isl29018_channels,
+		.num_channels = ARRAY_SIZE(isl29018_channels),
+		.indio_info = &isl29018_info,
+		.regmap_cfg = &isl29018_regmap_config,
+	},
+	[isl29023] = {
+		.channels = isl29023_channels,
+		.num_channels = ARRAY_SIZE(isl29023_channels),
+		.indio_info = &isl29023_info,
+		.regmap_cfg = &isl29018_regmap_config,
+	},
+	[isl29035] = {
+		.channels = isl29023_channels,
+		.num_channels = ARRAY_SIZE(isl29023_channels),
+		.indio_info = &isl29023_info,
+		.regmap_cfg = &isl29035_regmap_config,
+	},
+};
+
 static int isl29018_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -562,13 +675,15 @@ static int isl29018_probe(struct i2c_client *client,
 
 	mutex_init(&chip->lock);
 
+	chip->type = id->driver_data;
 	chip->lux_scale = 1;
 	chip->lux_uscale = 0;
 	chip->range = 1000;
 	chip->adc_bit = 16;
 	chip->suspended = false;
 
-	chip->regmap = devm_regmap_init_i2c(client, &isl29018_regmap_config);
+	chip->regmap = devm_regmap_init_i2c(client,
+				chip_info_tbl[id->driver_data].regmap_cfg);
 	if (IS_ERR(chip->regmap)) {
 		err = PTR_ERR(chip->regmap);
 		dev_err(chip->dev, "regmap initialization failed: %d\n", err);
@@ -579,9 +694,9 @@ static int isl29018_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
-	indio_dev->info = &isl29018_info;
-	indio_dev->channels = isl29018_channels;
-	indio_dev->num_channels = ARRAY_SIZE(isl29018_channels);
+	indio_dev->info = chip_info_tbl[id->driver_data].indio_info;
+	indio_dev->channels = chip_info_tbl[id->driver_data].channels;
+	indio_dev->num_channels = chip_info_tbl[id->driver_data].num_channels;
 	indio_dev->name = id->name;
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->modes = INDIO_DIRECT_MODE;
@@ -633,7 +748,9 @@ static SIMPLE_DEV_PM_OPS(isl29018_pm_ops, isl29018_suspend, isl29018_resume);
 #endif
 
 static const struct i2c_device_id isl29018_id[] = {
-	{"isl29018", 0},
+	{"isl29018", isl29018},
+	{"isl29023", isl29023},
+	{"isl29035", isl29035},
 	{}
 };
 
@@ -641,6 +758,8 @@ MODULE_DEVICE_TABLE(i2c, isl29018_id);
 
 static const struct of_device_id isl29018_of_match[] = {
 	{ .compatible = "isil,isl29018", },
+	{ .compatible = "isil,isl29023", },
+	{ .compatible = "isil,isl29035", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, isl29018_of_match);
-- 
1.9.1

