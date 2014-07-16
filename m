Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835AbaGPNJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:09:38 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:34146 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964800AbaGPNJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:09:34 -0400
Date: Wed, 16 Jul 2014 15:09:35 +0200
From: Josef Gajdusek <atx@atalax.net>
To: linux-iio@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, jic23@kernel.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: [PATCH v4 (staging-next) 5/5] staging:iio:hmc5843: Add support for
 spi hmc5983
Message-ID: <20140716130935.GF3315@dashie>
References: <20140716130635.GA3315@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716130635.GA3315@dashie>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the hmc5983 spi interface.
This chip is almost identical to the hmc5883. The difference being added
temperature compensation, additional available sample rate (220Hz) and an SPI
interface.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
 drivers/staging/iio/magnetometer/Kconfig       | 15 ++++++
 drivers/staging/iio/magnetometer/Makefile      |  1 +
 drivers/staging/iio/magnetometer/hmc5843_spi.c | 73 ++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c

diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
index c086f33..dec814a 100644
--- a/drivers/staging/iio/magnetometer/Kconfig
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -22,4 +22,19 @@ config SENSORS_HMC5843_I2C
 	  - hmc5843_core (core functions)
 	  - hmc5843_i2c (support for HMC5843, HMC5883, HMC5883L and HMC5983)
 
+config SENSORS_HMC5843_SPI
+	tristate "Honeywell HMC5983 3-Axis Magnetometer (SPI)"
+	depends on SPI_MASTER
+	select SENSORS_HMC5843
+	select REGMAP_SPI
+	help
+	  Say Y here to add support for the Honeywell HMC5983 3-Axis Magnetometer
+	  (digital compass).
+
+	  This driver can also be compiled as a set of modules.
+	  If so, these modules will be created:
+	  - hmc5843_core (core functions)
+	  - hmc5843_spi (support for HMC5983)
+
+
 endmenu
diff --git a/drivers/staging/iio/magnetometer/Makefile b/drivers/staging/iio/magnetometer/Makefile
index 65baf1c..33761a1 100644
--- a/drivers/staging/iio/magnetometer/Makefile
+++ b/drivers/staging/iio/magnetometer/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_SENSORS_HMC5843)		+= hmc5843_core.o
 obj-$(CONFIG_SENSORS_HMC5843_I2C)	+= hmc5843_i2c.o
+obj-$(CONFIG_SENSORS_HMC5843_SPI)	+= hmc5843_spi.o
diff --git a/drivers/staging/iio/magnetometer/hmc5843_spi.c b/drivers/staging/iio/magnetometer/hmc5843_spi.c
new file mode 100644
index 0000000..62964a4
--- /dev/null
+++ b/drivers/staging/iio/magnetometer/hmc5843_spi.c
@@ -0,0 +1,73 @@
+/*
+ * SPI driver for hmc5983
+ *
+ * Copyright (C) Josef Gajdusek <atx@atx.name>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * */
+
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/iio/iio.h>
+
+#include "hmc5843.h"
+
+static struct regmap_config hmc5843_spi_regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+
+		.rd_table = &hmc5843_readable_table,
+		.wr_table = &hmc5843_writable_table,
+		.volatile_table = &hmc5843_volatile_table,
+
+		/* Autoincrement address pointer */
+		.read_flag_mask = 0xc0,
+
+		.cache_type = REGCACHE_RBTREE,
+};
+
+static int hmc5843_spi_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->mode = SPI_MODE_3;
+	spi->max_speed_hz = 8000000;
+	spi->bits_per_word = 8;
+	ret = spi_setup(spi);
+	if (ret)
+		return ret;
+
+	return hmc5843_common_probe(&spi->dev,
+			devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config),
+			HMC5983_ID);
+}
+
+static int hmc5843_spi_remove(struct spi_device *spi)
+{
+	return hmc5843_common_remove(&spi->dev);
+}
+
+static const struct spi_device_id hmc5843_id[] = {
+	{ "hmc5983", HMC5983_ID },
+	{ }
+};
+
+static struct spi_driver hmc5843_driver = {
+		.driver = {
+				.name = "hmc5843",
+				.pm = HMC5843_PM_OPS,
+				.owner = THIS_MODULE,
+		},
+		.id_table = hmc5843_id,
+		.probe = hmc5843_spi_probe,
+		.remove = hmc5843_spi_remove,
+};
+
+module_spi_driver(hmc5843_driver);
+
+MODULE_AUTHOR("Josef Gajdusek <atx@atx.name>");
+MODULE_DESCRIPTION("HMC5983 SPI driver");
+MODULE_LICENSE("GPL");
-- 
1.8.5.5

