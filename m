Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3FAWhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 18:37:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3FAWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 18:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] cw1200: fix some obvious mistakes
Date: Sun,  2 Jun 2013 00:37:21 +0200
Message-Id: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:0nTTkSUTTFU6b91lTQrgmOo9WW+tyWzBN8sqpUw1M3l
 3ginDPG9hh2f5zCeJ/1pu9xjKEdnhL5sDdvOtEZNOJ91NeyUoH
 6vFqFl1qogl6PrSwIQjOFZN5jgbKeVYG0lzg+fbPqs9wjXl4km
 28kpCU71q48nwOa19hpLvBx6koX1FHs3Sc6NH+1uz3LdhstcMH
 MQI1YaHFvqdUYKfoU0kdJHDGAAu/soyWNpcPdQ9r7uYd17FB67
 58Xi0WD5xMXK4bQiEYOECd9LucB0ztOgvLibzgcA7PCJxV8VTI
 9QtEIfwwKfjXX6WHnxckTx6FMkOzEGWjN3RUKzAhmtuOsZicX5
 xgivncAwqEBHZLpV4ap5B3IrCmFm339ScYWkfRWeI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got compile errors with the cw1200, which has lead me to take a
closer look. It seems the driver still has a number of issues,
and this addresses some of them and marks others as FIXME:

* The cw1200_sagrad.c file should not be there, hardcoding
  hardware configuration in .c files has been obsolete since
  Linux-2.4, so we should just remove it. Most of that file
  was already commented out since it does not compile.

* Move the parts of cw1200_sagrad.c that actually got used into
  cw1200_sdio.c, because it doesn't build otherwise.

* Make the platform_data for the sdio driver private to
  cw1200_sdio.c. The platform that was referenced here is
  going to use device tree based probing only in the future,
  which means the platform data has to go away anyway.

* Move the platform_data for the spi driver to
  include/linux/platform_data/net-cw1200.h where all other
  drivers have their platform_data.

* Add comments about passing GPIO numbers in platform_data:
  You should not use IORESOURCE_IO, which is for legacy ISA
  I/O ports on PCs, not for GPIOs.

It may actually be easier to remove the sdio driver entirely,
since it clearly doesn't work and requires a lot of cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
Cc: Ajitpal Singh <ajitpal.singh@stericsson.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/cw1200/Kconfig                |   8 --
 drivers/net/wireless/cw1200/Makefile               |   2 -
 drivers/net/wireless/cw1200/cw1200_sagrad.c        | 145 ---------------------
 drivers/net/wireless/cw1200/cw1200_sdio.c          |  72 ++++++++--
 drivers/net/wireless/cw1200/cw1200_spi.c           |   2 +-
 .../net-cw1200.h}                                  |  20 +--
 6 files changed, 62 insertions(+), 187 deletions(-)
 delete mode 100644 drivers/net/wireless/cw1200/cw1200_sagrad.c
 rename include/linux/{cw1200_platform.h => platform_data/net-cw1200.h} (53%)

diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
index 13e3611..c3142d4 100644
--- a/drivers/net/wireless/cw1200/Kconfig
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -20,14 +20,6 @@ config CW1200_WLAN_SPI
 	help
 	  Enables support for the CW1200 connected via a SPI bus.
 
-config CW1200_WLAN_SAGRAD
-	tristate "Support Sagrad SG901-1091/1098 modules"
-	depends on CW1200_WLAN_SDIO
-	help
-	  This provides the platform data glue to support the
-	  Sagrad SG901-1091/1098 modules in their standard SDIO EVK.
-	  It also includes example SPI platform data.
-
 menu "Driver debug features"
 	depends on CW1200 && DEBUG_FS
 
diff --git a/drivers/net/wireless/cw1200/Makefile b/drivers/net/wireless/cw1200/Makefile
index 1aa3682..bc6cbf9 100644
--- a/drivers/net/wireless/cw1200/Makefile
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -16,9 +16,7 @@ cw1200_core-$(CONFIG_PM)	+= pm.o
 
 cw1200_wlan_sdio-y := cw1200_sdio.o
 cw1200_wlan_spi-y := cw1200_spi.o
-cw1200_wlan_sagrad-y := cw1200_sagrad.o
 
 obj-$(CONFIG_CW1200) += cw1200_core.o
 obj-$(CONFIG_CW1200_WLAN_SDIO) += cw1200_wlan_sdio.o
 obj-$(CONFIG_CW1200_WLAN_SPI) += cw1200_wlan_spi.o
-obj-$(CONFIG_CW1200_WLAN_SAGRAD) += cw1200_wlan_sagrad.o
diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
deleted file mode 100644
index a5ada0e..0000000
--- a/drivers/net/wireless/cw1200/cw1200_sagrad.c
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * Platform glue data for ST-Ericsson CW1200 driver
- *
- * Copyright (c) 2013, Sagrad, Inc
- * Author: Solomon Peachy <speachy@sagrad.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/cw1200_platform.h>
-
-MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
-MODULE_DESCRIPTION("ST-Ericsson CW1200 Platform glue driver");
-MODULE_LICENSE("GPL");
-
-/* Define just one of these.  Feel free to customize as needed */
-#define SAGRAD_1091_1098_EVK_SDIO
-/* #define SAGRAD_1091_1098_EVK_SPI */
-
-#ifdef SAGRAD_1091_1098_EVK_SDIO
-#if 0
-static struct resource cw1200_href_resources[] = {
-	{
-		.start = 215,  /* fix me as appropriate */
-		.end = 215,    /* ditto */
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_reset",
-	},
-	{
-		.start = 216,  /* fix me as appropriate */
-		.end = 216,    /* ditto */
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_powerup",
-	},
-	{
-		.start = NOMADIK_GPIO_TO_IRQ(216), /* fix me as appropriate */
-		.end = NOMADIK_GPIO_TO_IRQ(216),   /* ditto */
-		.flags = IORESOURCE_IRQ,
-		.name = "cw1200_wlan_irq",
-	},
-};
-#endif
-
-static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
-			     bool enable)
-{
-	/* Control 3v3 and 1v8 to hardware as appropriate */
-	/* Note this is not needed if it's controlled elsewhere or always on */
-
-	/* May require delay for power to stabilize */
-	return 0;
-}
-
-static int cw1200_clk_ctrl(const struct cw1200_platform_data_sdio *pdata,
-			   bool enable)
-{
-	/* Turn CLK_32K off and on as appropriate. */
-	/* Note this is not needed if it's always on */
-
-	/* May require delay for clock to stabilize */
-	return 0;
-}
-
-static struct cw1200_platform_data_sdio cw1200_platform_data = {
-	.ref_clk = 38400,
-	.have_5ghz = false,
-#if 0
-	.reset = &cw1200_href_resources[0],
-	.powerup = &cw1200_href_resources[1],
-	.irq = &cw1200_href_resources[2],
-#endif
-	.power_ctrl = cw1200_power_ctrl,
-	.clk_ctrl = cw1200_clk_ctrl,
-/*	.macaddr = ??? */
-	.sdd_file = "sdd_sagrad_1091_1098.bin",
-};
-#endif
-
-#ifdef SAGRAD_1091_1098_EVK_SPI
-/* Note that this is an example of integrating into your board support file */
-static struct resource cw1200_href_resources[] = {
-	{
-		.start = GPIO_RF_RESET,
-		.end = GPIO_RF_RESET,
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_reset",
-	},
-	{
-		.start = GPIO_RF_POWERUP,
-		.end = GPIO_RF_POWERUP,
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_powerup",
-	},
-};
-
-static int cw1200_power_ctrl(const struct cw1200_platform_data_spi *pdata,
-			     bool enable)
-{
-	/* Control 3v3 and 1v8 to hardware as appropriate */
-	/* Note this is not needed if it's controlled elsewhere or always on */
-
-	/* May require delay for power to stabilize */
-	return 0;
-}
-static int cw1200_clk_ctrl(const struct cw1200_platform_data_spi *pdata,
-			   bool enable)
-{
-	/* Turn CLK_32K off and on as appropriate. */
-	/* Note this is not needed if it's always on */
-
-	/* May require delay for clock to stabilize */
-	return 0;
-}
-
-static struct cw1200_platform_data_spi cw1200_platform_data = {
-	.ref_clk = 38400,
-	.spi_bits_per_word = 16,
-	.reset = &cw1200_href_resources[0],
-	.powerup = &cw1200_href_resources[1],
-	.power_ctrl = cw1200_power_ctrl,
-	.clk_ctrl = cw1200_clk_ctrl,
-/*	.macaddr = ??? */
-	.sdd_file = "sdd_sagrad_1091_1098.bin",
-};
-static struct spi_board_info myboard_spi_devices[] __initdata = {
-	{
-		.modalias = "cw1200_wlan_spi",
-		.max_speed_hz = 10000000, /* 52MHz Max */
-		.bus_num = 0,
-		.irq = WIFI_IRQ,
-		.platform_data = &cw1200_platform_data,
-		.chip_select = 0,
-	},
-};
-#endif
-
-
-const void *cw1200_get_platform_data(void)
-{
-	return &cw1200_platform_data;
-}
-EXPORT_SYMBOL_GPL(cw1200_get_platform_data);
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index 863510d..721e392 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -20,7 +20,6 @@
 
 #include "cw1200.h"
 #include "sbus.h"
-#include <linux/cw1200_platform.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
@@ -29,6 +28,27 @@ MODULE_LICENSE("GPL");
 
 #define SDIO_BLOCK_SIZE (512)
 
+/* FIXME: include this into sbus_priv */
+struct cw1200_platform_data_sdio {
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+	/* FIXME: just do gpio_to_irq */
+	const struct resource *irq;     /* if using GPIO for IRQ */
+	bool have_5ghz;
+	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
+	/* FIXME: GPIO numbers are not resources */
+	const struct resource *reset;   /* GPIO to RSTn signal */
+	const struct resource *powerup; /* GPIO to POWERUP signal */
+	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			bool enable); /* Control CLK32K */
+	/* FIXME: us of_get_mac_address */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
 struct sbus_priv {
 	struct sdio_func	*func;
 	struct cw1200_common	*core;
@@ -265,6 +285,38 @@ static struct sbus_ops cw1200_sdio_sbus_ops = {
 	.power_mgmt		= cw1200_sdio_pm,
 };
 
+static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			     bool enable)
+{
+	/* Control 3v3 and 1v8 to hardware as appropriate */
+	/* Note this is not needed if it's controlled elsewhere or always on */
+
+	/* May require delay for power to stabilize */
+	return 0;
+}
+
+static int cw1200_clk_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			   bool enable)
+{
+	/* Turn CLK_32K off and on as appropriate. */
+	/* Note this is not needed if it's always on */
+
+	/* May require delay for clock to stabilize */
+	return 0;
+}
+
+/*
+ * FIXME: These are just defaults, the driver needs a proper DT binding
+ * to extract the other values and override these if necessary
+ */
+static struct cw1200_platform_data_sdio cw1200_platform_data = {
+	.ref_clk = 38400,
+	.have_5ghz = false,
+	.power_ctrl = cw1200_power_ctrl,
+	.clk_ctrl = cw1200_clk_ctrl,
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+
 /* Probe Function to be called by SDIO stack when device is discovered */
 static int cw1200_sdio_probe(struct sdio_func *func,
 				       const struct sdio_device_id *id)
@@ -286,7 +338,8 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
-	self->pdata = cw1200_get_platform_data();
+	/* FIXME: get this from DT */
+	self->pdata = &cw1200_platform_data;
 	self->func = func;
 	sdio_set_drvdata(func, self);
 	sdio_claim_host(func);
@@ -377,13 +430,11 @@ static struct sdio_driver sdio_driver = {
 /* Init Module function -> Called by insmod */
 static int __init cw1200_sdio_init(void)
 {
-	const struct cw1200_platform_data_sdio *pdata;
 	int ret;
 
-	pdata = cw1200_get_platform_data();
-
-	if (cw1200_sdio_on(pdata)) {
-		ret = -1;
+	/* FIXME: must not touch hardware until we know the hardware is present */
+	if (cw1200_sdio_on(&cw1200_platform_data)) {
+		ret = -ENODEV;
 		goto err;
 	}
 
@@ -394,19 +445,16 @@ static int __init cw1200_sdio_init(void)
 	return 0;
 
 err:
-	cw1200_sdio_off(pdata);
+	cw1200_sdio_off(&cw1200_platform_data);
 	return ret;
 }
 
 /* Called at Driver Unloading */
 static void __exit cw1200_sdio_exit(void)
 {
-	const struct cw1200_platform_data_sdio *pdata;
-	pdata = cw1200_get_platform_data();
 	sdio_unregister_driver(&sdio_driver);
-	cw1200_sdio_off(pdata);
+	cw1200_sdio_off(&cw1200_platform_data);
 }
 
-
 module_init(cw1200_sdio_init);
 module_exit(cw1200_sdio_exit);
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 75adef0..ef05916 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -25,7 +25,7 @@
 
 #include "cw1200.h"
 #include "sbus.h"
-#include <linux/cw1200_platform.h>
+#include <linux/platform_data/net-cw1200.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
diff --git a/include/linux/cw1200_platform.h b/include/linux/platform_data/net-cw1200.h
similarity index 53%
rename from include/linux/cw1200_platform.h
rename to include/linux/platform_data/net-cw1200.h
index c168fa5..8f006ac 100644
--- a/include/linux/cw1200_platform.h
+++ b/include/linux/platform_data/net-cw1200.h
@@ -14,6 +14,7 @@ struct cw1200_platform_data_spi {
 
 	/* All others are optional */
 	bool have_5ghz;
+	/* FIXME: use simple numbers rather than resources for GPIO */
 	const struct resource *reset;   /* GPIO to RSTn signal */
 	const struct resource *powerup; /* GPIO to POWERUP signal */
 	int (*power_ctrl)(const struct cw1200_platform_data_spi *pdata,
@@ -24,23 +25,4 @@ struct cw1200_platform_data_spi {
 	const char *sdd_file;  /* if NULL, will use default for detected hw type */
 };
 
-struct cw1200_platform_data_sdio {
-	u16 ref_clk;                    /* REQUIRED (in KHz) */
-
-	/* All others are optional */
-	const struct resource *irq;     /* if using GPIO for IRQ */
-	bool have_5ghz;
-	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
-	const struct resource *reset;   /* GPIO to RSTn signal */
-	const struct resource *powerup; /* GPIO to POWERUP signal */
-	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			  bool enable); /* Control 3v3 / 1v8 supply */
-	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			bool enable); /* Control CLK32K */
-	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
-	const char *sdd_file;  /* if NULL, will use default for detected hw type */
-};
-
-const void *cw1200_get_platform_data(void);
-
 #endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.8.1.2

