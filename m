Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaGIO1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:27:24 -0400
Received: from sauhun.de ([89.238.76.85]:48834 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaGIO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:27:23 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] i2c: scx200: drop GPIO based i2c driver
Date: Wed,  9 Jul 2014 16:27:09 +0200
Message-Id: <1404916029-3319-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is marked as deprecated since the pre-git era. Any user
left(?) should really have switched to i2c-gpio meanwhile.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/Kconfig      |  31 ----------
 drivers/i2c/busses/Makefile     |   1 -
 drivers/i2c/busses/scx200_i2c.c | 129 ----------------------------------------
 3 files changed, 161 deletions(-)
 delete mode 100644 drivers/i2c/busses/scx200_i2c.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index d25dd120c011..0a8a5bba4ef9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1008,37 +1008,6 @@ config I2C_CROS_EC_TUNNEL
 	  connected there. This will work whatever the interface used to
 	  talk to the EC (SPI, I2C or LPC).
 
-config SCx200_I2C
-	tristate "NatSemi SCx200 I2C using GPIO pins (DEPRECATED)"
-	depends on SCx200_GPIO
-	select I2C_ALGOBIT
-	help
-	  Enable the use of two GPIO pins of a SCx200 processor as an I2C bus.
-
-	  If you don't know what to do here, say N.
-
-	  This support is also available as a module.  If so, the module
-	  will be called scx200_i2c.
-
-	  This driver is deprecated and will be dropped soon. Use i2c-gpio
-	  (or scx200_acb) instead.
-
-config SCx200_I2C_SCL
-	int "GPIO pin used for SCL"
-	depends on SCx200_I2C
-	default "12"
-	help
-	  Enter the GPIO pin number used for the SCL signal.  This value can
-	  also be specified with a module parameter.
-
-config SCx200_I2C_SDA
-	int "GPIO pin used for SDA"
-	depends on SCx200_I2C
-	default "13"
-	help
-	  Enter the GPIO pin number used for the SSA signal.  This value can
-	  also be specified with a module parameter.
-
 config SCx200_ACB
 	tristate "Geode ACCESS.bus support"
 	depends on X86_32 && PCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 1958b490105e..49bf07e5ef4d 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -100,6 +100,5 @@ obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
-obj-$(CONFIG_SCx200_I2C)	+= scx200_i2c.o
 
 ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
deleted file mode 100644
index 8eadf0f47ad7..000000000000
--- a/drivers/i2c/busses/scx200_i2c.c
+++ /dev/null
@@ -1,129 +0,0 @@
-/* linux/drivers/i2c/busses/scx200_i2c.c
-
-   Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
-
-   National Semiconductor SCx200 I2C bus on GPIO pins
-
-   Based on i2c-velleman.c Copyright (C) 1995-96, 2000 Simon G. Vogl
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-   
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-   
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.		     
-*/
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <linux/io.h>
-
-#include <linux/scx200_gpio.h>
-
-MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
-MODULE_DESCRIPTION("NatSemi SCx200 I2C Driver");
-MODULE_LICENSE("GPL");
-
-static int scl = CONFIG_SCx200_I2C_SCL;
-static int sda = CONFIG_SCx200_I2C_SDA;
-
-module_param(scl, int, 0);
-MODULE_PARM_DESC(scl, "GPIO line for SCL");
-module_param(sda, int, 0);
-MODULE_PARM_DESC(sda, "GPIO line for SDA");
-
-static void scx200_i2c_setscl(void *data, int state)
-{
-	scx200_gpio_set(scl, state);
-}
-
-static void scx200_i2c_setsda(void *data, int state)
-{
-	scx200_gpio_set(sda, state);
-} 
-
-static int scx200_i2c_getscl(void *data)
-{
-	return scx200_gpio_get(scl);
-}
-
-static int scx200_i2c_getsda(void *data)
-{
-	return scx200_gpio_get(sda);
-}
-
-/* ------------------------------------------------------------------------
- * Encapsulate the above functions in the correct operations structure.
- * This is only done when more than one hardware adapter is supported.
- */
-
-static struct i2c_algo_bit_data scx200_i2c_data = {
-	.setsda		= scx200_i2c_setsda,
-	.setscl		= scx200_i2c_setscl,
-	.getsda		= scx200_i2c_getsda,
-	.getscl		= scx200_i2c_getscl,
-	.udelay		= 10,
-	.timeout	= HZ,
-};
-
-static struct i2c_adapter scx200_i2c_ops = {
-	.owner		   = THIS_MODULE,
-	.class             = I2C_CLASS_HWMON | I2C_CLASS_SPD,
-	.algo_data	   = &scx200_i2c_data,
-	.name	= "NatSemi SCx200 I2C",
-};
-
-static int scx200_i2c_init(void)
-{
-	pr_debug("NatSemi SCx200 I2C Driver\n");
-
-	if (!scx200_gpio_present()) {
-		pr_err("no SCx200 gpio pins available\n");
-		return -ENODEV;
-	}
-
-	pr_debug("SCL=GPIO%02u, SDA=GPIO%02u\n", scl, sda);
-
-	if (scl == -1 || sda == -1 || scl == sda) {
-		pr_err("scl and sda must be specified\n");
-		return -EINVAL;
-	}
-
-	/* Configure GPIOs as open collector outputs */
-	scx200_gpio_configure(scl, ~2, 5);
-	scx200_gpio_configure(sda, ~2, 5);
-
-	if (i2c_bit_add_bus(&scx200_i2c_ops) < 0) {
-		pr_err("adapter %s registration failed\n", scx200_i2c_ops.name);
-		return -ENODEV;
-	}
-	
-	return 0;
-}
-
-static void scx200_i2c_cleanup(void)
-{
-	i2c_del_adapter(&scx200_i2c_ops);
-}
-
-module_init(scx200_i2c_init);
-module_exit(scx200_i2c_cleanup);
-
-/*
-    Local variables:
-        compile-command: "make -k -C ../.. SUBDIRS=drivers/i2c modules"
-        c-basic-offset: 8
-    End:
-*/
-- 
2.0.0

