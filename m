Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3JMTch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:32:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3JMTcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:32:35 -0400
Message-ID: <525AF4B8.8030005@infradead.org>
Date: Sun, 13 Oct 2013 12:30:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kbuild-all@01.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: [PATCH v2] staging/olpc_dcon: fix kconfig to fix build errors
References: <524a3b76.oejnG6gfqBFdWbl/%fengguang.wu@intel.com>
In-Reply-To: <524a3b76.oejnG6gfqBFdWbl/%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when GPIO_CS5535=m and FB_OLPC_DCON=y
by preventing that kconfig combination.

These build errors are caused by having a kconfig bool symbol
(FB_OLPC_DCON_1) that depend on a tristate symbol (GPIO_CS5535),
but when the tristate symbol is =m, the bool symbol is =y.

  drivers/built-in.o: In function `dcon_read_status_xo_1':
  olpc_dcon_xo_1.c:(.text+0x359531): undefined reference to `cs5535_gpio_set'
  drivers/built-in.o: In function `dcon_wiggle_xo_1':
  olpc_dcon_xo_1.c:(.text+0x35959f): undefined reference to `cs5535_gpio_set'
  olpc_dcon_xo_1.c:(.text+0x359610): undefined reference to `cs5535_gpio_clear'
  drivers/built-in.o:olpc_dcon_xo_1.c:(.text+0x3596a1): more undefined references to `cs5535_gpio_clear' follow
  drivers/built-in.o: In function `dcon_wiggle_xo_1':
  olpc_dcon_xo_1.c:(.text+0x359708): undefined reference to `cs5535_gpio_set'
  drivers/built-in.o: In function `dcon_init_xo_1':
  olpc_dcon_xo_1.c:(.text+0x35989b): undefined reference to `cs5535_gpio_clear'
  olpc_dcon_xo_1.c:(.text+0x3598b5): undefined reference to `cs5535_gpio_isset'
  olpc_dcon_xo_1.c:(.text+0x359963): undefined reference to `cs5535_gpio_setup_event'
  olpc_dcon_xo_1.c:(.text+0x359980): undefined reference to `cs5535_gpio_set_irq'
  olpc_dcon_xo_1.c:(.text+0x359a36): undefined reference to `cs5535_gpio_set'

However, adding GPIO_CS5535 to the Kconfig dependencies also creates
a kconfig recursive dependency error on powerpc:
  drivers/i2c/Kconfig:5:error: recursive dependency detected!
  drivers/i2c/Kconfig:5:	symbol I2C is selected by FB_OLPC_DCON
  drivers/staging/olpc_dcon/Kconfig:1:	symbol FB_OLPC_DCON depends on GPIO_CS5535
  drivers/gpio/Kconfig:577:	symbol GPIO_CS5535 depends on GPIOLIB
  drivers/gpio/Kconfig:38:	symbol GPIOLIB is selected by ARCH_REQUIRE_GPIOLIB
  drivers/gpio/Kconfig:23:	symbol ARCH_REQUIRE_GPIOLIB is selected by MCU_MPC8349EMITX
  arch/powerpc/platforms/Kconfig:351:	symbol MCU_MPC8349EMITX depends on I2C

This is due to FB_OLPC_DCON selecting I2C instead of depending on it,
so change the select to a dependency.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Daniel Drake <dsd@laptop.org>
Cc:	Jens Frederich <jfrederich@gmail.com>
Cc:	Jon Nettleton <jon.nettleton@gmail.com>
---
 drivers/staging/olpc_dcon/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-312-rc4.orig/drivers/staging/olpc_dcon/Kconfig
+++ lnx-312-rc4/drivers/staging/olpc_dcon/Kconfig
@@ -1,7 +1,8 @@
 config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
 	depends on OLPC && FB
-	select I2C
+	depends on I2C
+	depends on (GPIO_CS5535 || GPIO_CS5535=n)
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  In order to support very low power operation, the XO laptop uses a
