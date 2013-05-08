Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3EHOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:46:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58031 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3EHOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:46:10 -0400
Message-ID: <1368024363.9329.1.camel@phoenix>
Subject: [PATCH v2] iio: dac: Fix build error when CONFIG_SPI_MASTER=y &&
 CONFIG_I2C=m
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Date: Wed, 08 May 2013 22:46:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m:

drivers/built-in.o: In function `ad5064_i2c_write':
drivers/iio/dac/ad5064.c:608: undefined reference to `i2c_master_send'
drivers/built-in.o: In function `ad5064_i2c_register_driver':
drivers/iio/dac/ad5064.c:646: undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `ad5064_i2c_unregister_driver':
drivers/iio/dac/ad5064.c:651: undefined reference to `i2c_del_driver'
make: *** [vmlinux] Error 1

Add config IIO_DAC_I2C_AND_SPI to handle such case:
When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
Thus don't allow the drivers to be compiled as built-in.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iio/dac/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index f4a6f08..b61160b 100644
--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -5,7 +5,7 @@ menu "Digital to analog converters"
 
 config AD5064
 	tristate "Analog Devices AD5064 and similar multi-channel DAC driver"
-	depends on (SPI_MASTER || I2C)
+	depends on (SPI_MASTER && I2C!=m) || I2C
 	help
 	  Say yes here to build support for Analog Devices AD5024, AD5025, AD5044,
 	  AD5045, AD5064, AD5064-1, AD5065, AD5628, AD5629R, AD5648, AD5666, AD5668,
@@ -27,7 +27,7 @@ config AD5360
 
 config AD5380
 	tristate "Analog Devices AD5380/81/82/83/84/90/91/92 DAC driver"
-	depends on (SPI_MASTER || I2C)
+	depends on (SPI_MASTER && I2C!=m) || I2C
 	select REGMAP_I2C if I2C
 	select REGMAP_SPI if SPI_MASTER
 	help
@@ -57,7 +57,7 @@ config AD5624R_SPI
 
 config AD5446
 	tristate "Analog Devices AD5446 and similar single channel DACs driver"
-	depends on (SPI_MASTER || I2C)
+	depends on (SPI_MASTER && I2C!=m) || I2C
 	help
 	  Say yes here to build support for Analog Devices AD5300, AD5301, AD5310,
 	  AD5311, AD5320, AD5321, AD5444, AD5446, AD5450, AD5451, AD5452, AD5453,
-- 
1.8.1.2



