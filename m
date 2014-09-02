Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaIBKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:51:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:60224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaIBKvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:51:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="585011313"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Denis CIOCCA <denis.ciocca@st.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH] iio: gyro: bmi055 gyro sensor driver
Date: Tue,  2 Sep 2014 13:59:57 +0300
Message-Id: <1409655597-28781-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the BMI055 gyroscope sensor. BMI055 is a package
consisting of an acceleration sensor and a gyroscope. This patch
adds support for the gyroscope only.

Spec downloaded from:
http://ae-bst.resource.bosch.com/media/products/dokumente/bmi055/BST-BMI055-DS000-06.pdf

The BMI055 gyroscope uses the same register definition as BMG160,
but does not specify a temp register. However, the temp register
seems to be working in the same way as for BMG160, so this patch
does not remove the temp channel for BMI055.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/gyro/Kconfig  |    2 +-
 drivers/iio/gyro/bmg160.c |   39 +++++++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
index d630ae9..b3d0e94 100644
--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -56,7 +56,7 @@ config BMG160
 	select IIO_TRIGGERED_BUFFER if IIO_BUFFER
 	help
 	  Say yes here to build support for Bosch BMG160 Tri-axis Gyro Sensor
-	  driver.
+	  driver. This driver also supports BMI055 gyroscope.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called bmg160.
diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
index 80f92a6..7524698 100644
--- a/drivers/iio/gyro/bmg160.c
+++ b/drivers/iio/gyro/bmg160.c
@@ -947,10 +947,10 @@ static irqreturn_t bmg160_data_rdy_trig_poll(int irq, void *private)
 
 }
 
-static int bmg160_acpi_gpio_probe(struct i2c_client *client,
-				  struct bmg160_data *data)
+static int bmg160_gpio_probe(struct i2c_client *client,
+			     struct bmg160_data *data)
+
 {
-	const struct acpi_device_id *id;
 	struct device *dev;
 	struct gpio_desc *gpio;
 	int ret;
@@ -959,12 +959,6 @@ static int bmg160_acpi_gpio_probe(struct i2c_client *client,
 		return -EINVAL;
 
 	dev = &client->dev;
-	if (!ACPI_HANDLE(dev))
-		return -ENODEV;
-
-	id = acpi_match_device(dev->driver->acpi_match_table, dev);
-	if (!id)
-		return -ENODEV;
 
 	/* data ready gpio interrupt pin */
 	gpio = devm_gpiod_get_index(dev, BMG160_GPIO_NAME, 0);
@@ -984,12 +978,24 @@ static int bmg160_acpi_gpio_probe(struct i2c_client *client,
 	return ret;
 }
 
+static const char *bmg160_match_acpi_device(struct device *dev)
+{
+	const struct acpi_device_id *id;
+
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+	if (!id)
+		return NULL;
+
+	return dev_name(dev);
+}
+
 static int bmg160_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct bmg160_data *data;
 	struct iio_dev *indio_dev;
 	int ret;
+	const char *name = NULL;
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
 	if (!indio_dev)
@@ -1005,15 +1011,21 @@ static int bmg160_probe(struct i2c_client *client,
 
 	mutex_init(&data->mutex);
 
+	if (id)
+		name = id->name;
+
+	if (ACPI_HANDLE(&client->dev))
+		name = bmg160_match_acpi_device(&client->dev);
+
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->channels = bmg160_channels;
 	indio_dev->num_channels = ARRAY_SIZE(bmg160_channels);
-	indio_dev->name = BMG160_DRV_NAME;
+	indio_dev->name = name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &bmg160_info;
 
 	if (client->irq <= 0)
-		client->irq = bmg160_acpi_gpio_probe(client, data);
+		client->irq = bmg160_gpio_probe(client, data);
 
 	if (client->irq > 0) {
 		ret = devm_request_threaded_irq(&client->dev,
@@ -1183,12 +1195,15 @@ static const struct dev_pm_ops bmg160_pm_ops = {
 
 static const struct acpi_device_id bmg160_acpi_match[] = {
 	{"BMG0160", 0},
-	{ },
+	{"BMI055B", 0},
+	{},
 };
+
 MODULE_DEVICE_TABLE(acpi, bmg160_acpi_match);
 
 static const struct i2c_device_id bmg160_id[] = {
 	{"bmg160", 0},
+	{"bmi055_gyro", 0},
 	{}
 };
 
-- 
1.7.9.5

