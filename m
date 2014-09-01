Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaIAJV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:21:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:12523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaIAJVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379706241"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Derek Basehore <dbasehore@chromium.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] staging: iio: light: isl29018: add ACPI support
Date: Mon,  1 Sep 2014 12:20:34 +0300
Message-Id: <1409563234-13746-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409322382-30021-4-git-send-email-laurentiu.palcu@intel.com>
References: <1409322382-30021-4-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for enumerating the device through ACPI.

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---

Changes in v2:
 * fix the unnecessary casting from const char * to char * and back;

Thank you Jonathan for the reviews,
laurentiu

 drivers/staging/iio/light/isl29018.c | 46 +++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index b50f126..65a35da 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
+#include <linux/acpi.h>
 
 #define CONVERSION_TIME_MS		100
 
@@ -656,12 +657,28 @@ static const struct chip_info chip_info_tbl[] = {
 	},
 };
 
+static const char *isl29018_match_acpi_device(struct device *dev, int *data)
+{
+	const struct acpi_device_id *id;
+
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+
+	if (!id)
+		return NULL;
+
+	*data = (int) id->driver_data;
+
+	return dev_name(dev);
+}
+
 static int isl29018_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct isl29018_chip *chip;
 	struct iio_dev *indio_dev;
 	int err;
+	const char *name = NULL;
+	int dev_id = 0;
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*chip));
 	if (indio_dev == NULL) {
@@ -673,9 +690,17 @@ static int isl29018_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, indio_dev);
 	chip->dev = &client->dev;
 
+	if (id) {
+		name = id->name;
+		dev_id = id->driver_data;
+	}
+
+	if (ACPI_HANDLE(&client->dev))
+		name = isl29018_match_acpi_device(&client->dev, &dev_id);
+
 	mutex_init(&chip->lock);
 
-	chip->type = id->driver_data;
+	chip->type = dev_id;
 	chip->lux_scale = 1;
 	chip->lux_uscale = 0;
 	chip->range = 1000;
@@ -683,7 +708,7 @@ static int isl29018_probe(struct i2c_client *client,
 	chip->suspended = false;
 
 	chip->regmap = devm_regmap_init_i2c(client,
-				chip_info_tbl[id->driver_data].regmap_cfg);
+				chip_info_tbl[dev_id].regmap_cfg);
 	if (IS_ERR(chip->regmap)) {
 		err = PTR_ERR(chip->regmap);
 		dev_err(chip->dev, "regmap initialization failed: %d\n", err);
@@ -694,10 +719,10 @@ static int isl29018_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
-	indio_dev->info = chip_info_tbl[id->driver_data].indio_info;
-	indio_dev->channels = chip_info_tbl[id->driver_data].channels;
-	indio_dev->num_channels = chip_info_tbl[id->driver_data].num_channels;
-	indio_dev->name = id->name;
+	indio_dev->info = chip_info_tbl[dev_id].indio_info;
+	indio_dev->channels = chip_info_tbl[dev_id].channels;
+	indio_dev->num_channels = chip_info_tbl[dev_id].num_channels;
+	indio_dev->name = name;
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	err = devm_iio_device_register(&client->dev, indio_dev);
@@ -747,6 +772,14 @@ static SIMPLE_DEV_PM_OPS(isl29018_pm_ops, isl29018_suspend, isl29018_resume);
 #define ISL29018_PM_OPS NULL
 #endif
 
+static const struct acpi_device_id isl29018_acpi_match[] = {
+	{"ISL29018", isl29018},
+	{"ISL29023", isl29023},
+	{"ISL29035", isl29035},
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, isl29018_acpi_match);
+
 static const struct i2c_device_id isl29018_id[] = {
 	{"isl29018", isl29018},
 	{"isl29023", isl29023},
@@ -768,6 +801,7 @@ static struct i2c_driver isl29018_driver = {
 	.class	= I2C_CLASS_HWMON,
 	.driver	 = {
 			.name = "isl29018",
+			.acpi_match_table = ACPI_PTR(isl29018_acpi_match),
 			.pm = ISL29018_PM_OPS,
 			.owner = THIS_MODULE,
 			.of_match_table = isl29018_of_match,
-- 
1.9.1

