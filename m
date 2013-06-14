Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3FNJg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:36:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42971 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3FNJg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:36:56 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <avinashphilip@ti.com>
Subject: [PATCH v2 7/7] ARM: davinci: Start using gpiolib API inplace of inline functions
Date: Fri, 14 Jun 2013 15:05:32 +0530
Message-ID: <1371202532-14628-8-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371202532-14628-1-git-send-email-avinashphilip@ti.com>
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NEED_MACH_GPIO_H config select option for ARCH_DAVINCI to start
use gpiolib interface for davinci platforms. However with this software
latencies for gpio_get/set APIs will affect. Latency has increased by 18
microsecond with gpiolib API as compared with inline API's.

Software latency is calculated on da850 EVM for gpio_get_value API by
taking the printk timing for API execution with interrupts disabled.
Experiment has done for inline and gpiolib API interface.

  inline gpio API with interrupt disabled
  [   29.734337] before gpio_get
  [   29.736847] after gpio_get

  Time difference 0.00251

  gpio library with interrupt disabled
  [  272.876763] before gpio_get
  [  272.879291] after gpio_get

  Time difference 0.002528
  Latency increased by (0.002528 -  0.00251) = 18 microsecond.

Also being here
- Moved following definitions from mach folder to include directory
	struct davinci_gpio_controller
	Macro GPIO(x)
	inline function __gpio_mask
- Removed GPIO_TYPE_DAVINCI enum definition as GPIO Davinci is converted
  to Linux device driver model.
- With removal of select option of NEED_MACH_GPIO_H for ARCH_DAVINCI,
  gpio-tnetv107x also start using gpiolib interface. Hence removes
  related header files
	arch/arm/mach-davinci/include/mach/gpio-davinci.h
	arch/arm/mach-davinci/include/mach/gpio.h

  and include linux/platform_data/gpio-davinci.h header file to support
  gpio-davinci platform definitions.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
Changes since v1:
	- Remove inline GPIO API support for tnetv107x platforms
        - Remove gpio header files in mach directory.
	- Remove include of gpio header files from mach directory.
	- Moved enum davinci_gpio_type to include folder
	- Replace __ASM_ARCH_DAVINCI_GPIO_H with __DAVINCI_GPIO_PLATFORM_H

 arch/arm/Kconfig                                  |    1 -
 arch/arm/mach-davinci/da830.c                     |    1 -
 arch/arm/mach-davinci/da850.c                     |    1 -
 arch/arm/mach-davinci/dm355.c                     |    1 -
 arch/arm/mach-davinci/dm365.c                     |    1 -
 arch/arm/mach-davinci/dm644x.c                    |    1 -
 arch/arm/mach-davinci/dm646x.c                    |    1 -
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |   93 ---------------------
 arch/arm/mach-davinci/include/mach/gpio.h         |   88 -------------------
 arch/arm/mach-davinci/tnetv107x.c                 |    2 +-
 drivers/gpio/gpio-tnetv107x.c                     |    1 +
 include/linux/platform_data/gpio-davinci.h        |   34 ++++++++
 12 files changed, 36 insertions(+), 189 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 49d993c..4d099fe 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -839,7 +839,6 @@ config ARCH_DAVINCI
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
 	select HAVE_IDE
-	select NEED_MACH_GPIO_H
 	select USE_OF
 	select ZONE_DMA
 	help
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index e7b79ee..0f2cb28 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -20,7 +20,6 @@
 #include <mach/common.h>
 #include <mach/time.h>
 #include <mach/da8xx.h>
-#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index de8753d..cf62641 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -28,7 +28,6 @@
 #include <mach/da8xx.h>
 #include <mach/cpufreq.h>
 #include <mach/pm.h>
-#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index f7a18ff..9564202 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -27,7 +27,6 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <linux/platform_data/spi-davinci.h>
-#include <mach/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 2c80a6b..8c8c0de 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -31,7 +31,6 @@
 #include <mach/common.h>
 #include <linux/platform_data/keyscan-davinci.h>
 #include <linux/platform_data/spi-davinci.h>
-#include <mach/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 9e23e64..75146b5 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -23,7 +23,6 @@
 #include <mach/time.h>
 #include <mach/serial.h>
 #include <mach/common.h>
-#include <mach/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 1058e7c..d15a36c 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -24,7 +24,6 @@
 #include <mach/time.h>
 #include <mach/serial.h>
 #include <mach/common.h>
-#include <mach/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
deleted file mode 100644
index b325a1d..0000000
--- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
+++ /dev/null
@@ -1,93 +0,0 @@
-/*
- * TI DaVinci GPIO Support
- *
- * Copyright (c) 2006 David Brownell
- * Copyright (c) 2007, MontaVista Software, Inc. <source@mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef	__DAVINCI_DAVINCI_GPIO_H
-#define	__DAVINCI_DAVINCI_GPIO_H
-
-#include <linux/io.h>
-#include <linux/spinlock.h>
-
-#include <asm-generic/gpio.h>
-
-#include <mach/irqs.h>
-#include <mach/common.h>
-
-#define DAVINCI_GPIO_BASE 0x01C67000
-
-enum davinci_gpio_type {
-	GPIO_TYPE_DAVINCI = 0,
-	GPIO_TYPE_TNETV107X,
-};
-
-/*
- * basic gpio routines
- *
- * board-specific init should be done by arch/.../.../board-XXX.c (maybe
- * initializing banks together) rather than boot loaders; kexec() won't
- * go through boot loaders.
- *
- * the gpio clock will be turned on when gpios are used, and you may also
- * need to pay attention to PINMUX registers to be sure those pins are
- * used as gpios, not with other peripherals.
- *
- * On-chip GPIOs are numbered 0..(DAVINCI_N_GPIO-1).  For documentation,
- * and maybe for later updates, code may write GPIO(N).  These may be
- * all 1.8V signals, all 3.3V ones, or a mix of the two.  A given chip
- * may not support all the GPIOs in that range.
- *
- * GPIOs can also be on external chips, numbered after the ones built-in
- * to the DaVinci chip.  For now, they won't be usable as IRQ sources.
- */
-#define	GPIO(X)		(X)		/* 0 <= X <= (DAVINCI_N_GPIO - 1) */
-
-/* Convert GPIO signal to GPIO pin number */
-#define GPIO_TO_PIN(bank, gpio)	(16 * (bank) + (gpio))
-
-struct davinci_gpio_controller {
-	struct gpio_chip	chip;
-	int			irq_base;
-	spinlock_t		lock;
-	void __iomem		*regs;
-	void __iomem		*set_data;
-	void __iomem		*clr_data;
-	void __iomem		*in_data;
-	int			gpio_unbanked;
-	unsigned		gpio_irq;
-};
-
-/* The __gpio_to_controller() and __gpio_mask() functions inline to constants
- * with constant parameters; or in outlined code they execute at runtime.
- *
- * You'd access the controller directly when reading or writing more than
- * one gpio value at a time, and to support wired logic where the value
- * being driven by the cpu need not match the value read back.
- *
- * These are NOT part of the cross-platform GPIO interface
- */
-static inline struct davinci_gpio_controller *
-__gpio_to_controller(unsigned gpio)
-{
-	struct davinci_gpio_controller *ctlrs = davinci_soc_info.gpio_ctlrs;
-	int index = gpio / 32;
-
-	if (!ctlrs || index >= davinci_soc_info.gpio_ctlrs_num)
-		return NULL;
-
-	return ctlrs + index;
-}
-
-static inline u32 __gpio_mask(unsigned gpio)
-{
-	return 1 << (gpio % 32);
-}
-
-#endif	/* __DAVINCI_DAVINCI_GPIO_H */
diff --git a/arch/arm/mach-davinci/include/mach/gpio.h b/arch/arm/mach-davinci/include/mach/gpio.h
deleted file mode 100644
index 960e9de..0000000
--- a/arch/arm/mach-davinci/include/mach/gpio.h
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- * TI DaVinci GPIO Support
- *
- * Copyright (c) 2006 David Brownell
- * Copyright (c) 2007, MontaVista Software, Inc. <source@mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef	__DAVINCI_GPIO_H
-#define	__DAVINCI_GPIO_H
-
-#include <asm-generic/gpio.h>
-
-#define __ARM_GPIOLIB_COMPLEX
-
-/* The inline versions use the static inlines in the driver header */
-#include "gpio-davinci.h"
-
-/*
- * The get/set/clear functions will inline when called with constant
- * parameters referencing built-in GPIOs, for low-overhead bitbanging.
- *
- * gpio_set_value() will inline only on traditional Davinci style controllers
- * with distinct set/clear registers.
- *
- * Otherwise, calls with variable parameters or referencing external
- * GPIOs (e.g. on GPIO expander chips) use outlined functions.
- */
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	if (__builtin_constant_p(value) && gpio < davinci_soc_info.gpio_num) {
-		struct davinci_gpio_controller *ctlr;
-		u32				mask;
-
-		ctlr = __gpio_to_controller(gpio);
-
-		if (ctlr->set_data != ctlr->clr_data) {
-			mask = __gpio_mask(gpio);
-			if (value)
-				__raw_writel(mask, ctlr->set_data);
-			else
-				__raw_writel(mask, ctlr->clr_data);
-			return;
-		}
-	}
-
-	__gpio_set_value(gpio, value);
-}
-
-/* Returns zero or nonzero; works for gpios configured as inputs OR
- * as outputs, at least for built-in GPIOs.
- *
- * NOTE: for built-in GPIOs, changes in reported values are synchronized
- * to the GPIO clock.  This is easily seen after calling gpio_set_value()
- * and then immediately gpio_get_value(), where the gpio_get_value() will
- * return the old value until the GPIO clock ticks and the new value gets
- * latched.
- */
-static inline int gpio_get_value(unsigned gpio)
-{
-	struct davinci_gpio_controller *ctlr;
-
-	if (!__builtin_constant_p(gpio) || gpio >= davinci_soc_info.gpio_num)
-		return __gpio_get_value(gpio);
-
-	ctlr = __gpio_to_controller(gpio);
-	return __gpio_mask(gpio) & __raw_readl(ctlr->in_data);
-}
-
-static inline int gpio_cansleep(unsigned gpio)
-{
-	if (__builtin_constant_p(gpio) && gpio < davinci_soc_info.gpio_num)
-		return 0;
-	else
-		return __gpio_cansleep(gpio);
-}
-
-static inline int irq_to_gpio(unsigned irq)
-{
-	/* don't support the reverse mapping */
-	return -ENOSYS;
-}
-
-#endif				/* __DAVINCI_GPIO_H */
diff --git a/arch/arm/mach-davinci/tnetv107x.c b/arch/arm/mach-davinci/tnetv107x.c
index 3b2a70d..28418ba 100644
--- a/arch/arm/mach-davinci/tnetv107x.c
+++ b/arch/arm/mach-davinci/tnetv107x.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <asm/mach/map.h>
 
@@ -30,7 +31,6 @@
 #include <mach/irqs.h>
 #include <mach/hardware.h>
 #include <mach/tnetv107x.h>
-#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/drivers/gpio/gpio-tnetv107x.c b/drivers/gpio/gpio-tnetv107x.c
index c7ed335..8aaf129 100644
--- a/drivers/gpio/gpio-tnetv107x.c
+++ b/drivers/gpio/gpio-tnetv107x.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <mach/common.h>
 #include <mach/tnetv107x.h>
diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
index 2fcc125..0df700d 100644
--- a/include/linux/platform_data/gpio-davinci.h
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -16,10 +16,44 @@
 #ifndef __DAVINCI_GPIO_PLATFORM_H
 #define __DAVINCI_GPIO_PLATFORM_H
 
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+#include <asm-generic/gpio.h>
+
+enum davinci_gpio_type {
+	GPIO_TYPE_TNETV107X = 0,
+};
+
 struct davinci_gpio_platform_data {
 	u32	ngpio;
 	u32	gpio_unbanked;
 	u32	intc_irq_num;
 };
 
+
+struct davinci_gpio_controller {
+	struct gpio_chip	chip;
+	int			irq_base;
+	spinlock_t		lock;
+	void __iomem		*regs;
+	void __iomem		*set_data;
+	void __iomem		*clr_data;
+	void __iomem		*in_data;
+	int			gpio_unbanked;
+	unsigned		gpio_irq;
+};
+
+/*
+ * basic gpio routines
+ */
+#define	GPIO(X)		(X)	/* 0 <= X <= (DAVINCI_N_GPIO - 1) */
+
+/* Convert GPIO signal to GPIO pin number */
+#define GPIO_TO_PIN(bank, gpio)	(16 * (bank) + (gpio))
+
+static inline u32 __gpio_mask(unsigned gpio)
+{
+	return 1 << (gpio % 32);
+}
 #endif
-- 
1.7.9.5

