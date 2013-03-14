Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3CNWMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:12:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3CNWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] ARM: gemini: get platform to build again
Date: Thu, 14 Mar 2013 23:12:03 +0100
Message-Id: <1363299128-8192-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NaKWN3ErV0fEUh/ioJOKS2aQnpo2RPf7ieeveoxLD1x
 T25dFkcMnnjYrQgrUeD2BFJC4ILYmoZMBjDrPI6akXJVsEB2SR
 Xpm8O5n+5Y82JHLbCVKXdVPir/QBPBtyqmrYlMPJfjXpUk4KX+
 pMDUNeau5dlZijEAI24vEJCyzGrzOLmL4s7Mqi7CdVewo5t2aP
 i0OwzVz50Be9otYCFOZLWkQrvaNGzCDYUEa8+kkleP5BswCX4a
 awkjTV7EkdRC3JWQ53KG4z0RAVrD6tM3tb1AQMhHKd/S7YF2yU
 kEMqwsv91Ta2Q4zS8/NfBW01VeKvtGogJr9BNe+g2cLojY/Q17
 WpO9yVR5JqRrn0ZPkL1ZP7aPwanZF4ze1VbXJMetw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no defconfig file for gemini, which has lead to a lot
of bitrot. This makes the broken board files, the gpio implementation
and the reset logic work again, and fixes the build warnings
that got introduced with the changes to the readl/writel prototypes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                                   |  1 +
 arch/arm/mach-gemini/Makefile                      |  2 +-
 arch/arm/mach-gemini/board-nas4220b.c              |  1 +
 arch/arm/mach-gemini/board-rut1xx.c                |  2 ++
 arch/arm/mach-gemini/board-wbd111.c                |  1 +
 arch/arm/mach-gemini/board-wbd222.c                |  1 +
 arch/arm/mach-gemini/common.h                      |  2 ++
 arch/arm/mach-gemini/gpio.c                        | 19 ++++++++++---------
 arch/arm/mach-gemini/include/mach/hardware.h       |  2 +-
 arch/arm/mach-gemini/irq.c                         |  4 ++--
 arch/arm/mach-gemini/mm.c                          | 22 +++++++++++-----------
 .../mach-gemini/{include/mach/system.h => reset.c} |  2 +-
 12 files changed, 34 insertions(+), 25 deletions(-)
 rename arch/arm/mach-gemini/{include/mach/system.h => reset.c} (91%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..78f31a3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -411,6 +411,7 @@ config ARCH_GEMINI
 	bool "Cortina Systems Gemini"
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_USES_GETTIMEOFFSET
+	select NEED_MACH_GPIO_H
 	select CPU_FA526
 	help
 	  Support for the Cortina Systems Gemini family SoCs
diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
index 7355c0b..7963a77 100644
--- a/arch/arm/mach-gemini/Makefile
+++ b/arch/arm/mach-gemini/Makefile
@@ -4,7 +4,7 @@
 
 # Object file lists.
 
-obj-y			:= irq.o mm.o time.o devices.o gpio.o idle.o
+obj-y			:= irq.o mm.o time.o devices.o gpio.o idle.o reset.o
 
 # Board-specific support
 obj-$(CONFIG_MACH_NAS4220B)	+= board-nas4220b.o
diff --git a/arch/arm/mach-gemini/board-nas4220b.c b/arch/arm/mach-gemini/board-nas4220b.c
index 08bd650..ca8a25b 100644
--- a/arch/arm/mach-gemini/board-nas4220b.c
+++ b/arch/arm/mach-gemini/board-nas4220b.c
@@ -103,4 +103,5 @@ MACHINE_START(NAS4220B, "Raidsonic NAS IB-4220-B")
 	.init_irq	= gemini_init_irq,
 	.init_time	= gemini_timer_init,
 	.init_machine	= ib4220b_init,
+	.restart	= gemini_restart,
 MACHINE_END
diff --git a/arch/arm/mach-gemini/board-rut1xx.c b/arch/arm/mach-gemini/board-rut1xx.c
index fa0a363..7a675f8 100644
--- a/arch/arm/mach-gemini/board-rut1xx.c
+++ b/arch/arm/mach-gemini/board-rut1xx.c
@@ -14,6 +14,7 @@
 #include <linux/leds.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/sizes.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -87,4 +88,5 @@ MACHINE_START(RUT100, "Teltonika RUT100")
 	.init_irq	= gemini_init_irq,
 	.init_time	= gemini_timer_init,
 	.init_machine	= rut1xx_init,
+	.restart	= gemini_restart,
 MACHINE_END
diff --git a/arch/arm/mach-gemini/board-wbd111.c b/arch/arm/mach-gemini/board-wbd111.c
index 3321cd6..418188c 100644
--- a/arch/arm/mach-gemini/board-wbd111.c
+++ b/arch/arm/mach-gemini/board-wbd111.c
@@ -130,4 +130,5 @@ MACHINE_START(WBD111, "Wiliboard WBD-111")
 	.init_irq	= gemini_init_irq,
 	.init_time	= gemini_timer_init,
 	.init_machine	= wbd111_init,
+	.restart	= gemini_restart,
 MACHINE_END
diff --git a/arch/arm/mach-gemini/board-wbd222.c b/arch/arm/mach-gemini/board-wbd222.c
index fe33c82..266b265 100644
--- a/arch/arm/mach-gemini/board-wbd222.c
+++ b/arch/arm/mach-gemini/board-wbd222.c
@@ -130,4 +130,5 @@ MACHINE_START(WBD222, "Wiliboard WBD-222")
 	.init_irq	= gemini_init_irq,
 	.init_time	= gemini_timer_init,
 	.init_machine	= wbd222_init,
+	.restart	= gemini_restart,
 MACHINE_END
diff --git a/arch/arm/mach-gemini/common.h b/arch/arm/mach-gemini/common.h
index 7670c39..38a4526 100644
--- a/arch/arm/mach-gemini/common.h
+++ b/arch/arm/mach-gemini/common.h
@@ -26,4 +26,6 @@ extern int platform_register_pflash(unsigned int size,
 				    struct mtd_partition *parts,
 				    unsigned int nr_parts);
 
+extern void gemini_restart(char mode, const char *cmd);
+
 #endif /* __GEMINI_COMMON_H__ */
diff --git a/arch/arm/mach-gemini/gpio.c b/arch/arm/mach-gemini/gpio.c
index fdc7ef1..70bfa57 100644
--- a/arch/arm/mach-gemini/gpio.c
+++ b/arch/arm/mach-gemini/gpio.c
@@ -21,6 +21,7 @@
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
+#include <mach/gpio.h>
 
 #define GPIO_BASE(x)		IO_ADDRESS(GEMINI_GPIO_BASE(x))
 
@@ -44,7 +45,7 @@
 
 #define GPIO_PORT_NUM		3
 
-static void _set_gpio_irqenable(unsigned int base, unsigned int index,
+static void _set_gpio_irqenable(void __iomem *base, unsigned int index,
 				int enable)
 {
 	unsigned int reg;
@@ -57,7 +58,7 @@ static void _set_gpio_irqenable(unsigned int base, unsigned int index,
 static void gpio_ack_irq(struct irq_data *d)
 {
 	unsigned int gpio = irq_to_gpio(d->irq);
-	unsigned int base = GPIO_BASE(gpio / 32);
+	void __iomem *base = GPIO_BASE(gpio / 32);
 
 	__raw_writel(1 << (gpio % 32), base + GPIO_INT_CLR);
 }
@@ -65,7 +66,7 @@ static void gpio_ack_irq(struct irq_data *d)
 static void gpio_mask_irq(struct irq_data *d)
 {
 	unsigned int gpio = irq_to_gpio(d->irq);
-	unsigned int base = GPIO_BASE(gpio / 32);
+	void __iomem *base = GPIO_BASE(gpio / 32);
 
 	_set_gpio_irqenable(base, gpio % 32, 0);
 }
@@ -73,7 +74,7 @@ static void gpio_mask_irq(struct irq_data *d)
 static void gpio_unmask_irq(struct irq_data *d)
 {
 	unsigned int gpio = irq_to_gpio(d->irq);
-	unsigned int base = GPIO_BASE(gpio / 32);
+	void __iomem *base = GPIO_BASE(gpio / 32);
 
 	_set_gpio_irqenable(base, gpio % 32, 1);
 }
@@ -82,7 +83,7 @@ static int gpio_set_irq_type(struct irq_data *d, unsigned int type)
 {
 	unsigned int gpio = irq_to_gpio(d->irq);
 	unsigned int gpio_mask = 1 << (gpio % 32);
-	unsigned int base = GPIO_BASE(gpio / 32);
+	void __iomem *base = GPIO_BASE(gpio / 32);
 	unsigned int reg_both, reg_level, reg_type;
 
 	reg_type = __raw_readl(base + GPIO_INT_TYPE);
@@ -120,7 +121,7 @@ static int gpio_set_irq_type(struct irq_data *d, unsigned int type)
 	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
 	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
 
-	gpio_ack_irq(d->irq);
+	gpio_ack_irq(d);
 
 	return 0;
 }
@@ -153,7 +154,7 @@ static struct irq_chip gpio_irq_chip = {
 static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 				int dir)
 {
-	unsigned int base = GPIO_BASE(offset / 32);
+	void __iomem *base = GPIO_BASE(offset / 32);
 	unsigned int reg;
 
 	reg = __raw_readl(base + GPIO_DIR);
@@ -166,7 +167,7 @@ static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 
 static void gemini_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	unsigned int base = GPIO_BASE(offset / 32);
+	void __iomem *base = GPIO_BASE(offset / 32);
 
 	if (value)
 		__raw_writel(1 << (offset % 32), base + GPIO_DATA_SET);
@@ -176,7 +177,7 @@ static void gemini_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int gemini_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	unsigned int base = GPIO_BASE(offset / 32);
+	void __iomem *base = GPIO_BASE(offset / 32);
 
 	return (__raw_readl(base + GPIO_DATA_IN) >> (offset % 32)) & 1;
 }
diff --git a/arch/arm/mach-gemini/include/mach/hardware.h b/arch/arm/mach-gemini/include/mach/hardware.h
index 8c950e1..98e7b0f 100644
--- a/arch/arm/mach-gemini/include/mach/hardware.h
+++ b/arch/arm/mach-gemini/include/mach/hardware.h
@@ -69,6 +69,6 @@
 /*
  * macro to get at IO space when running virtually
  */
-#define IO_ADDRESS(x)	((((x) & 0xFFF00000) >> 4) | ((x) & 0x000FFFFF) | 0xF0000000)
+#define IO_ADDRESS(x)	IOMEM((((x) & 0xFFF00000) >> 4) | ((x) & 0x000FFFFF) | 0xF0000000)
 
 #endif
diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
index 020852d..30bef11 100644
--- a/arch/arm/mach-gemini/irq.c
+++ b/arch/arm/mach-gemini/irq.c
@@ -65,8 +65,8 @@ static struct irq_chip gemini_irq_chip = {
 
 static struct resource irq_resource = {
 	.name	= "irq_handler",
-	.start	= IO_ADDRESS(GEMINI_INTERRUPT_BASE),
-	.end	= IO_ADDRESS(FIQ_STATUS(GEMINI_INTERRUPT_BASE)) + 4,
+	.start	= GEMINI_INTERRUPT_BASE,
+	.end	= FIQ_STATUS(GEMINI_INTERRUPT_BASE) + 4,
 };
 
 void __init gemini_init_irq(void)
diff --git a/arch/arm/mach-gemini/mm.c b/arch/arm/mach-gemini/mm.c
index 5194824..2c2cd28 100644
--- a/arch/arm/mach-gemini/mm.c
+++ b/arch/arm/mach-gemini/mm.c
@@ -19,57 +19,57 @@
 /* Page table mapping for I/O region */
 static struct map_desc gemini_io_desc[] __initdata = {
 	{
-		.virtual	= IO_ADDRESS(GEMINI_GLOBAL_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GLOBAL_BASE),
 		.pfn		=__phys_to_pfn(GEMINI_GLOBAL_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_UART_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_UART_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_UART_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_TIMER_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_TIMER_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_TIMER_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_INTERRUPT_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_INTERRUPT_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_INTERRUPT_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_POWER_CTRL_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_POWER_CTRL_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_POWER_CTRL_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_GPIO_BASE(0)),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(0)),
 		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(0)),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_GPIO_BASE(1)),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(1)),
 		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(1)),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_GPIO_BASE(2)),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(2)),
 		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(2)),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_FLASH_CTRL_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_FLASH_CTRL_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_FLASH_CTRL_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_DRAM_CTRL_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_DRAM_CTRL_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_DRAM_CTRL_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
 	}, {
-		.virtual	= IO_ADDRESS(GEMINI_GENERAL_DMA_BASE),
+		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GENERAL_DMA_BASE),
 		.pfn		= __phys_to_pfn(GEMINI_GENERAL_DMA_BASE),
 		.length		= SZ_512K,
 		.type 		= MT_DEVICE,
diff --git a/arch/arm/mach-gemini/include/mach/system.h b/arch/arm/mach-gemini/reset.c
similarity index 91%
rename from arch/arm/mach-gemini/include/mach/system.h
rename to arch/arm/mach-gemini/reset.c
index a33b5a1..b266597 100644
--- a/arch/arm/mach-gemini/include/mach/system.h
+++ b/arch/arm/mach-gemini/reset.c
@@ -14,7 +14,7 @@
 #include <mach/hardware.h>
 #include <mach/global_reg.h>
 
-static inline void arch_reset(char mode, const char *cmd)
+void gemini_restart(char mode, const char *cmd)
 {
 	__raw_writel(RESET_GLOBAL | RESET_CPU1,
 		     IO_ADDRESS(GEMINI_GLOBAL_BASE) + GLOBAL_RESET);
-- 
1.8.1.2

