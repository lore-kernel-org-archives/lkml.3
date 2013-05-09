Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3EIHt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:49:26 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49163 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3EIHtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:49:25 -0400
Message-ID: <1368085759.3454.0.camel@phoenix>
Subject: [PATCH v3] iio: dac: Fix build error when CONFIG_SPI_MASTER=y &&
 CONFIG_I2C=m
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Date: Thu, 09 May 2013 15:49:19 +0800
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

When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
Thus don't allow the drivers to be compiled as built-in when CONFIG_I2C=m.

The real fix though is to break the driver apart into a SPI part, an I2C part
and a common part. But that's something for 3.11 while this is something for
3.10/stable.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v3: Update comment

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



