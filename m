Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaEZPed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:34:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49635 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEZPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:34:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pawel Moll <pawel.moll@arm.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: vexpress: refine dependencies for new code
Date: Mon, 26 May 2014 17:34:24 +0200
Message-ID: <6862654.ZzBrnrRESe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yUPeQRPeWNEChrvfjofjEYWgVNbaE/wv1jaXw35DxT5
 LlyaJ/RljaKeus0vpA4jYMqjW+dmWTC/hlsuYGEKRdtnw608hK
 VzLBlxmhJGYZcTEgqxgyw1OqlmMVu8l/xUZ/S+7GDb57onGt4e
 7fgrKMwDNVh5nyjX63OL0H1j6vI08/6Cj3q4ppy8+f10WE8dtp
 I+Vb3N9G6LwlH8/naSU1UVbFPhjBqHb4yxnXL2pn6GNKAdIAaF
 CnQGzDCeiQn+mD4Q8wEJLZxyL59udKyFpzZEBcYrlgGboRGTqc
 szR+scoe60GxqtalWZSdtdx2ScFaXNNkLoBePbqYsvRLWSjuoV
 yjRncm/Zg6wm/77arKd0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The versatile express changes for 3.16 introduced a number of
build regressions for randconfig kernels by not tracking dependencies
between the components right.

This patch tries to rectify that:

* the mach-vexpress code cannot link without the syscfg driver,
  which in turn needs MFD_VEXPRESS_SYSREG
* various drivers call devm_regmap_init_vexpress_config(), which
  has to be exported so it can be used by loadable modules
* the configuration bus uses OF DT helper functions that are not
  available to platforms disable CONFIG_OF
* The sysreg driver exports GPIOs through gpiolib, which can
  be disabled on some platforms.
* The clocksource code cannot be built on platforms that don't
  use modern timekeeping but rely on gettimeoffset.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index e0726e4..2cc994e 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -18,6 +18,8 @@ menuconfig ARCH_VEXPRESS
 	select POWER_SUPPLY
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select VEXPRESS_CONFIG
+	select VEXPRESS_SYSCFG
+	select MFD_VEXPRESS_SYSREG
 	help
 	  This option enables support for systems using Cortex processor based
 	  ARM core and logic (FPGA) tiles on the Versatile Express motherboard,
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 827f8a5..1f37d98 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -54,6 +54,7 @@ config VEXPRESS_CONFIG
 	bool "Versatile Express configuration bus"
 	default y if ARCH_VEXPRESS
 	depends on ARM || ARM64
+	depends on OF
 	select REGMAP
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
diff --git a/drivers/bus/vexpress-config.c b/drivers/bus/vexpress-config.c
index 27a07df..a64763b 100644
--- a/drivers/bus/vexpress-config.c
+++ b/drivers/bus/vexpress-config.c
@@ -118,7 +118,7 @@ struct regmap *devm_regmap_init_vexpress_config(struct device *dev)
 
 	return regmap;
 }
-
+EXPORT_SYMBOL_GPL(devm_regmap_init_vexpress_config);
 
 struct device *vexpress_config_bridge_register(struct device *parent,
 		struct vexpress_config_bridge_ops *ops, void *context)
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 2c27b02..43f1acf 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -194,7 +194,7 @@ config CLKSRC_QCOM
 
 config CLKSRC_VERSATILE
 	bool "ARM Versatile (Express) reference platforms clock source"
-	depends on GENERIC_SCHED_CLOCK
+	depends on GENERIC_SCHED_CLOCK && !ARCH_USES_GETTIMEOFFSET
 	select CLKSRC_OF
 	default y if MFD_VEXPRESS_SYSREG
 	help
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a3987af..6cc4b6a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1261,7 +1261,7 @@ endmenu
 
 config MFD_VEXPRESS_SYSREG
 	bool "Versatile Express System Registers"
-	depends on VEXPRESS_CONFIG
+	depends on VEXPRESS_CONFIG && GPIOLIB
 	default y
 	select CLKSRC_MMIO
 	select GPIO_GENERIC_PLATFORM

