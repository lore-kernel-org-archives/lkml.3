Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3ESGK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 02:10:58 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59380 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3ESGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 02:10:57 -0400
Message-ID: <1368943851.3455.8.camel@phoenix>
Subject: [PATCH] gpio: mcp23s08: Fix build error when CONFIG_SPI_MASTER=y &&
 CONFIG_I2C=m
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Lars Poeschel <poeschel@lemonage.de>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Date: Sun, 19 May 2013 14:10:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m &&
CONFIG_GPIO_MCP23S08=y.

  LD      init/built-in.o
drivers/built-in.o: In function `mcp23017_write':
clkdev.c:(.text+0x1e14): undefined reference to `i2c_smbus_write_word_data'
drivers/built-in.o: In function `mcp23017_read':
clkdev.c:(.text+0x1e24): undefined reference to `i2c_smbus_read_word_data'
drivers/built-in.o: In function `mcp23008_write':
clkdev.c:(.text+0x1e8c): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `mcp23008_read':
clkdev.c:(.text+0x1e98): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `mcp23008_read_regs':
clkdev.c:(.text+0x1ed0): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `mcp23s08_init':
clkdev.c:(.init.text+0x30): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `mcp23s08_exit':
clkdev.c:(.exit.text+0x30): undefined reference to `i2c_del_driver'
make: *** [vmlinux] Error 1

When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
Thus don't allow the drivers to be compiled as built-in when CONFIG_I2C=m.

The real fix though is to break the driver apart into a SPI part, an I2C part
and a common part. But that's something for 3.11 while this is something for
3.10/stable.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 87d5670..6575d77 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -636,7 +636,7 @@ config GPIO_MAX7301
 
 config GPIO_MCP23S08
 	tristate "Microchip MCP23xxx I/O expander"
-	depends on SPI_MASTER || I2C
+	depends on (SPI_MASTER && I2C!=m) || I2C
 	help
 	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
 	  I/O expanders.
-- 
1.8.1.2



