Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbaGNSw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:52:57 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaGNSws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:52:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicholas Krause <xerofoify@gmail.com>, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        tomasz.figa@gmail.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Subject: Re: [PATCH] mach-s3c64xx: Remove all defintions not related to regs-clocks
Date: Mon, 14 Jul 2014 20:51:57 +0200
Message-ID: <4917052.gqu5hca4lr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405361664-5210-1-git-send-email-xerofoify@gmail.com>
References: <1405361664-5210-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r0wkR/ROhPniZha7v9APNJUvim2WnxcV7rkHlfEMZXr
 O8DbTC063/ndahRW5aLEujCtacnLdFxiYQIDeIaxp7/0xFIETZ
 V7N0ALBayqyVdJcoe8uAJdxR4A5aY2+apgl8f55FZGJ/3wC6Gn
 cpraMUE3m/eCsIAMvoiNKB1zQQrs83fVa4DTAeuwIzkFPDq4RQ
 4G1t/vYrEFmxb0RMyFxMpa85wi7fBZXAR4UAT+Mt6xY426jGcw
 0gONwu2U/9gNBLwnQBGGJNjAkKqzBhm0zjJJxJHK0JqEDww8TH
 EWe0egeWhvNL0iYxTN+O/8hRs7Rcryxkaz62vjnvAbXTQCgsXm
 zKQu6KBAErOZ6FjhfL5Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2014 14:14:24 Nicholas Krause wrote:
> This patch addresses the fix me message in this file that states to
> remove all definitions not related to reg-clocks in this header
> file.

I believe the comment is meant to change the code still using those
definitions so they are no longer needed. Just removing them
would of course break e.g. s3c_pm_debug_init_uart().

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/include/mach/regs-clock.h | 22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)

I have actually got a patch to move s3c64xx into multiplatform, following
the s5pv210 work that Tomasz did, see patch below. Related to that would
be a move of all header files that are not included by plat-samsung/*
from arch/arm/mach-s3c64xx/include/mach/ to arch/arm/mach-s3c64xx/.

The most significant change in my patch set is the move of gpio-samsung.c
back from the drivers directory into plat-samsung. I have discussed this
with Linus Walleij as the gpio maintainer, and the conclusion is that this
would be the least invasive way to deal with the problem. The driver
is expected to eventually go away, and it is not used by DT-base machines.

The S3C_ADC is the one remaining show-stopper at this point, because
the existing board files rely on this for hwmon (smartq only)
and for the touchscreen (mini6410, real6410, smartq and smdk6410)
and need to be converted to use the iio driver instead.

	Arnd

commit ac0839aaf5042547ab11f5ce77c4e1cc28b4e84d
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Jul 7 14:25:15 2014 +0200

    ARM: s3c64xx experimental multiplatform support
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 arch/arm/Kconfig                                   | 26 ----------------------
 arch/arm/configs/multi_v7_defconfig                |  3 +++
 arch/arm/mach-s3c64xx/Kconfig                      | 23 +++++++++++++++++++
 arch/arm/mach-s3c64xx/Makefile                     |  3 +++
 arch/arm/mach-s3c64xx/common.c                     |  1 +
 arch/arm/mach-s3c64xx/dev-uart.c                   |  1 +
 arch/arm/mach-s3c64xx/include/mach/irqs.h          |  2 +-
 arch/arm/mach-s3c64xx/include/mach/pm-core.h       |  1 +
 arch/arm/mach-s3c64xx/mach-anw6410.c               |  1 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |  2 ++
 arch/arm/mach-s3c64xx/mach-crag6410.c              |  1 +
 arch/arm/mach-s3c64xx/mach-mini6410.c              |  1 +
 arch/arm/mach-s3c64xx/mach-real6410.c              |  1 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |  1 +
 arch/arm/plat-samsung/Kconfig                      |  5 ++++-
 arch/arm/plat-samsung/Makefile                     |  5 ++++-
 .../gpio => arch/arm/plat-samsung}/gpio-samsung.c  |  1 +
 drivers/gpio/Kconfig                               |  7 ------
 drivers/gpio/Makefile                              |  1 -
 19 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 37a3a0947e4e..fceb014c54a1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -609,32 +609,6 @@ config ARCH_S3C24XX
 	  (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or the
 	  Samsung SMDK2410 development board (and derivatives).
 
-config ARCH_S3C64XX
-	bool "Samsung S3C64XX"
-	select ARCH_REQUIRE_GPIOLIB
-	select ARM_AMBA
-	select ARM_VIC
-	select ATAGS
-	select CLKDEV_LOOKUP
-	select CLKSRC_SAMSUNG_PWM
-	select COMMON_CLK_SAMSUNG
-	select CPU_V6K
-	select GENERIC_CLOCKEVENTS
-	select GPIO_SAMSUNG
-	select HAVE_S3C2410_I2C if I2C
-	select HAVE_S3C2410_WATCHDOG if WATCHDOG
-	select HAVE_TCM
-	select NO_IOPORT_MAP
-	select PLAT_SAMSUNG
-	select PM_GENERIC_DOMAINS if PM
-	select S3C_DEV_NAND
-	select S3C_GPIO_TRACK
-	select SAMSUNG_ATAGS
-	select SAMSUNG_WAKEMASK if PM
-	select SAMSUNG_WDT_RESET
-	help
-	  Samsung S3C64XX series based systems
-
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select ARCH_HAS_HOLES_MEMORYMODEL
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 58f40f123316..f5af8242358d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -9,6 +9,9 @@ CONFIG_PERF_EVENTS=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_PARTITION_ADVANCED=y
+CONFIG_ARCH_MULTI_V7=y
+# CONFIG_ARCH_MULTI_V5 if not set
+# CONFIG_ARCH_MULTI_V4 if not set
 CONFIG_ARCH_VIRT=y
 CONFIG_ARCH_MVEBU=y
 CONFIG_MACH_ARMADA_370=y
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index eff95e950d81..77dc554435ce 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -2,6 +2,29 @@
 #	Simtec Electronics, Ben Dooks <ben@simtec.co.uk>
 #
 # Licensed under GPLv2
+menuconfig ARCH_S3C64XX
+	bool "Samsung S3C64XX" if ARCH_MULTI_V6
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_AMBA
+	select ARM_VIC
+	select ATAGS
+	select CLKSRC_SAMSUNG_PWM
+	select COMMON_CLK_SAMSUNG
+	select CPU_V6K
+	select GENERIC_CLOCKEVENTS
+	select GPIO_SAMSUNG
+	select HAVE_S3C2410_I2C if I2C
+	select HAVE_S3C2410_WATCHDOG if WATCHDOG
+	select HAVE_TCM
+	select PLAT_SAMSUNG
+	select PM_GENERIC_DOMAINS if PM
+	select S3C_DEV_NAND
+	select S3C_GPIO_TRACK
+	select SAMSUNG_ATAGS
+	select SAMSUNG_WAKEMASK if PM
+	select SAMSUNG_WDT_RESET
+	help
+	  Samsung S3C64XX series based systems
 
 if ARCH_S3C64XX
 
diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-s3c64xx/Makefile
index 811593ae54b2..2e4537fc73a8 100644
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@ -5,6 +5,9 @@
 #
 # Licensed under GPLv2
 
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include -I$(srctree)/arch/arm/plat-samsung/include
+asflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include -I$(srctree)/arch/arm/plat-samsung/include
+
 obj-y				:=
 obj-m				:=
 obj-n				:=
diff --git a/arch/arm/mach-s3c64xx/common.c b/arch/arm/mach-s3c64xx/common.c
index 5c45aae675b6..5776355ede24 100644
--- a/arch/arm/mach-s3c64xx/common.c
+++ b/arch/arm/mach-s3c64xx/common.c
@@ -40,6 +40,7 @@
 #include <asm/system_misc.h>
 
 #include <mach/map.h>
+#include <mach/irqs.h>
 #include <mach/hardware.h>
 #include <mach/regs-gpio.h>
 #include <mach/gpio-samsung.h>
diff --git a/arch/arm/mach-s3c64xx/dev-uart.c b/arch/arm/mach-s3c64xx/dev-uart.c
index 46e18d77ea93..a0b4f0329811 100644
--- a/arch/arm/mach-s3c64xx/dev-uart.c
+++ b/arch/arm/mach-s3c64xx/dev-uart.c
@@ -23,6 +23,7 @@
 #include <asm/mach/irq.h>
 #include <mach/hardware.h>
 #include <mach/map.h>
+#include <mach/irqs.h>
 
 #include <plat/devs.h>
 
diff --git a/arch/arm/mach-s3c64xx/include/mach/irqs.h b/arch/arm/mach-s3c64xx/include/mach/irqs.h
index 67bbd1dd04c2..97a3d25a325e 100644
--- a/arch/arm/mach-s3c64xx/include/mach/irqs.h
+++ b/arch/arm/mach-s3c64xx/include/mach/irqs.h
@@ -174,7 +174,7 @@
 
 /* Set the default NR_IRQS */
 
-#define NR_IRQS	(IRQ_BOARD_END + 1)
+#define S3C64XX_NR_IRQS	(IRQ_BOARD_END + 1)
 
 /* Compatibility */
 
diff --git a/arch/arm/mach-s3c64xx/include/mach/pm-core.h b/arch/arm/mach-s3c64xx/include/mach/pm-core.h
index a30a1e3ffc6a..32d2ff54f82d 100644
--- a/arch/arm/mach-s3c64xx/include/mach/pm-core.h
+++ b/arch/arm/mach-s3c64xx/include/mach/pm-core.h
@@ -18,6 +18,7 @@
 #include <linux/serial_s3c.h>
 
 #include <mach/regs-gpio.h>
+#include <mach/regs-clock.h>
 
 static inline void s3c_pm_debug_init_uart(void)
 {
diff --git a/arch/arm/mach-s3c64xx/mach-anw6410.c b/arch/arm/mach-s3c64xx/mach-anw6410.c
index 60576dfbea8d..4fe7e96be3e2 100644
--- a/arch/arm/mach-s3c64xx/mach-anw6410.c
+++ b/arch/arm/mach-s3c64xx/mach-anw6410.c
@@ -47,6 +47,7 @@
 
 #include <plat/devs.h>
 #include <plat/cpu.h>
+#include <mach/irqs.h>
 #include <mach/regs-gpio.h>
 #include <mach/gpio-samsung.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410-module.c b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
index 9c00d83f7151..1c8e2c30fe3d 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410-module.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
@@ -29,6 +29,8 @@
 
 #include <linux/platform_data/spi-s3c64xx.h>
 
+#include <mach/irqs.h>
+
 #include "crag6410.h"
 
 static struct s3c64xx_spi_csinfo wm0010_spi_csinfo = {
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index fe116334afda..d947c38e8307 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -51,6 +51,7 @@
 #include <mach/map.h>
 #include <mach/regs-gpio.h>
 #include <mach/gpio-samsung.h>
+#include <mach/irqs.h>
 
 #include <plat/fb.h>
 #include <plat/sdhci.h>
diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c b/arch/arm/mach-s3c64xx/mach-mini6410.c
index 9cbc07602ef3..1b04c9e24a60 100644
--- a/arch/arm/mach-s3c64xx/mach-mini6410.c
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@ -41,6 +41,7 @@
 #include <linux/platform_data/mmc-sdhci-s3c.h>
 #include <plat/sdhci.h>
 #include <linux/platform_data/touchscreen-s3c2410.h>
+#include <mach/irqs.h>
 
 #include <video/platform_lcd.h>
 #include <video/samsung_fimd.h>
diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-s3c64xx/mach-real6410.c
index fbad2af1ef16..b809f64e84d8 100644
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@ -33,6 +33,7 @@
 #include <mach/map.h>
 #include <mach/regs-gpio.h>
 #include <mach/gpio-samsung.h>
+#include <mach/irqs.h>
 
 #include <plat/adc.h>
 #include <plat/cpu.h>
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c b/arch/arm/mach-s3c64xx/mach-smdk6410.c
index 1dc86d76b530..3f63b7de1fb5 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -51,6 +51,7 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/irqs.h>
 #include <mach/map.h>
 
 #include <asm/irq.h>
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 3f9bb1e8431d..342ae002a0c9 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -43,7 +43,6 @@ config S3C_LOWLEVEL_UART_PORT
 
 config SAMSUNG_ATAGS
 	def_bool n
-	depends on !ARCH_MULTIPLATFORM
 	depends on ATAGS
 	help
 	   This option enables ATAGS based boot support code for
@@ -74,6 +73,7 @@ config S3C_GPIO_TRACK
 
 config S3C_ADC
 	bool "ADC common driver support"
+	depends on !ARCH_MULTIPLATFORM
 	help
 	  Core support for the ADC block found in the Samsung SoC systems
 	  for drivers such as the touchscreen and hwmon to use to share
@@ -289,6 +289,9 @@ config SAMSUNG_WDT_RESET
 	  Compile support for system restart by triggering watchdog reset.
 	  Used on SoCs that do not provide dedicated reset control.
 
+config GPIO_SAMSUNG
+	def_bool SAMSUNG_ATAGS
+
 config DEBUG_S3C_UART
 	depends on PLAT_SAMSUNG
 	int
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 3270842653ee..e7eeebdfa39d 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -4,7 +4,8 @@
 #
 # Licensed under GPLv2
 
-ccflags-$(CONFIG_ARCH_MULTI_V7) += -I$(srctree)/$(src)/include
+ccflags-$(CONFIG_ARCH_S3C64XX) := -I$(srctree)/arch/arm/mach-s3c64xx/include
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include
 
 obj-y				:=
 obj-m				:=
@@ -37,6 +38,8 @@ obj-$(CONFIG_S3C_DMA)		+= dma.o s3c-dma-ops.o
 
 obj-$(CONFIG_SAMSUNG_DMADEV)	+= dma-ops.o
 
+obj-$(CONFIG_GPIO_SAMSUNG)	+= gpio-samsung.o
+
 # PM support
 
 samsung-pm-$(CONFIG_SAMSUNG_PM)	+= pm.o
diff --git a/drivers/gpio/gpio-samsung.c b/arch/arm/plat-samsung/gpio-samsung.c
similarity index 99%
rename from drivers/gpio/gpio-samsung.c
rename to arch/arm/plat-samsung/gpio-samsung.c
index 27298fd212d7..e2b0160c909c 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/arch/arm/plat-samsung/gpio-samsung.c
@@ -30,6 +30,7 @@
 
 #include <asm/irq.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 #include <mach/regs-gpio.h>
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 88691efa5f1a..d262e7cdbef7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -273,13 +273,6 @@ config GPIO_RCAR
 	help
 	  Say yes here to support GPIO on Renesas R-Car SoCs.
 
-config GPIO_SAMSUNG
-	bool
-	depends on PLAT_SAMSUNG
-	help
-	  Legacy GPIO support. Use only for platforms without support for
-	  pinctrl.
-
 config GPIO_SCH311X
 	tristate "SMSC SCH311x SuperI/O GPIO"
 	help
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d024e396622..53a86f3c8623 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -70,7 +70,6 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
-obj-$(CONFIG_GPIO_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_SCH311X)	+= gpio-sch311x.o

