Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3EVHLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:11:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36547 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3EVHLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:11:51 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 08/11] ARM: davinci: start using gpiolib support
Date: Wed, 22 May 2013 12:40:31 +0530
Message-ID: <1369206634-6778-9-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove NEED_MACH_GPIO_H config option for Davinci platforms to start
  using common gpio library interface.
- Added struct davinci_gpio_controller definitions in platform_data
  directory for Davinci gpio devices.
- Removed GPIO_TYPE_DAVINCI enum definition as GPIO Davinci is converted
  to Linux device driver model.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/Kconfig                                  |    1 -
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |    6 +++--
 include/linux/platform_data/gpio-davinci.h        |   27 +++++++++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..74d3e85 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -955,7 +955,6 @@ config ARCH_DAVINCI
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
 	select HAVE_IDE
-	select NEED_MACH_GPIO_H
 	select USE_OF
 	select ZONE_DMA
 	help
diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
index b325a1d..18140e0 100644
--- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
+++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
@@ -23,9 +23,10 @@
 
 #define DAVINCI_GPIO_BASE 0x01C67000
 
+#ifdef CONFIG_ARCH_DAVINCI_TNETV107X
+
 enum davinci_gpio_type {
-	GPIO_TYPE_DAVINCI = 0,
-	GPIO_TYPE_TNETV107X,
+	GPIO_TYPE_TNETV107X = 0,
 };
 
 /*
@@ -90,4 +91,5 @@ static inline u32 __gpio_mask(unsigned gpio)
 	return 1 << (gpio % 32);
 }
 
+#endif	/* CONFIG_ARCH_DAVINCI_TNETV107X */
 #endif	/* __DAVINCI_DAVINCI_GPIO_H */
diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
index f1c8277..75805d4 100644
--- a/include/linux/platform_data/gpio-davinci.h
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -18,10 +18,37 @@
 #ifndef __ASM_ARCH_DAVINCI_GPIO_H
 #define __ASM_ARCH_DAVINCI_GPIO_H
 
+#include <asm-generic/gpio.h>
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

