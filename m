Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3FEP3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:29:46 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:45610 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab3FEP3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:29:34 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: OMAP: DM816x: add hwmod support for DM81xx
Date: Wed,  5 Jun 2013 19:29:16 +0400
Message-Id: <1370446156-11788-6-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OCP interface data structures were added in order to achieve
successful initialization of hwmods on DM816x.

Required DM81xx family IRQ definitions, offsets of the PRCM clock
control registers and additional OMAP2PLUS DMA channel definitions
were added as they are needed during the hwmod registration.

omap3xxx_hwmod_init() call was substituted by dm81xx_hwmod_init().

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/Makefile                  |    1 +
 arch/arm/mach-omap2/cm_dm81xx.h               |   20 +
 arch/arm/mach-omap2/dm81xx.h                  |   28 +-
 arch/arm/mach-omap2/dma.h                     |   12 +
 arch/arm/mach-omap2/io.c                      |    2 +-
 arch/arm/mach-omap2/omap_hwmod.h              |    1 +
 arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c  | 1209 +++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/dmtimer.h     |    6 +
 arch/arm/plat-omap/include/plat/irqs-dm81xx.h |   43 +
 9 files changed, 1320 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c
 create mode 100644 arch/arm/plat-omap/include/plat/irqs-dm81xx.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 132a1e2..3b5cc8b 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -202,6 +202,7 @@ obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_2xxx_3xxx_ipblock_data.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_2xxx_3xxx_interconnect_data.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_3xxx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= omap_hwmod_am33xx_data.o
+obj-$(CONFIG_SOC_DM81XX)		+= omap_hwmod_dm81xx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= omap_hwmod_44xx_data.o
 
 # EMU peripherals
diff --git a/arch/arm/mach-omap2/cm_dm81xx.h b/arch/arm/mach-omap2/cm_dm81xx.h
index f8988da..d8268cd 100644
--- a/arch/arm/mach-omap2/cm_dm81xx.h
+++ b/arch/arm/mach-omap2/cm_dm81xx.h
@@ -58,4 +58,24 @@
 #define DM816X_CM_DEFAULT_PCI_CLKDM		0x0010
 #define DM816X_CM_DEFAULT_L3_SLOW_CLKDM	0x0014
 
+#define DM81XX_CM_ALWON_UART_0_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0150)
+#define DM81XX_CM_ALWON_UART_1_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0154)
+#define DM81XX_CM_ALWON_UART_2_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0158)
+#define DM81XX_CM_ALWON_GPIO_0_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x015C)
+#define DM81XX_CM_ALWON_GPIO_1_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0160)
+#define DM81XX_CM_ALWON_WDTIMER_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x018C)
+#define DM81XX_CM_ALWON_SPI_CLKCTRL_OFF		(DM81XX_CM_ALWON_MOD + 0x0190)
+#define DM816X_CM_ALWON_I2C_0_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0164)
+#define DM816X_CM_ALWON_I2C_1_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0168)
+#define DM816X_CM_DEFAULT_USB_CLKCTRL_OFF	(DM816X_CM_DEFAULT_MOD + 0x0058)
+#define DM816X_CM_ALWON_TIMER_0_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x016C)
+#define DM816X_CM_ALWON_TIMER_1_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0170)
+#define DM816X_CM_ALWON_TIMER_2_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0174)
+#define DM816X_CM_ALWON_TIMER_3_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0178)
+#define DM816X_CM_ALWON_TIMER_4_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x017C)
+#define DM816X_CM_ALWON_TIMER_5_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0180)
+#define DM816X_CM_ALWON_TIMER_6_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0184)
+#define DM816X_CM_ALWON_TIMER_7_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x0188)
+#define DM816X_CM_ALWON_SDIO_CLKCTRL_OFF	(DM81XX_CM_ALWON_MOD + 0x15B0)
+#define DM81XX_CM_ALWON_SPI_CLKCTRL_OFF		(DM81XX_CM_ALWON_MOD + 0x0190)
 #endif
diff --git a/arch/arm/mach-omap2/dm81xx.h b/arch/arm/mach-omap2/dm81xx.h
index a0b18a6..e92a2d2 100644
--- a/arch/arm/mach-omap2/dm81xx.h
+++ b/arch/arm/mach-omap2/dm81xx.h
@@ -30,7 +30,33 @@
 #define DM81XX_TAP_BASE		(DM81XX_CTRL_BASE + \
 				 DM81XX_CONTROL_DEVICE_ID - 0x204)
 
+#define DM81XX_MAILBOX_BASE		0x480C8000
 
-#define DM81XX_ARM_INTC_BASE	0x48200000
+#define DM816X_WDTIMER1_BASE	0x480C2000
+
+#define DM816X_I2C0_BASE		0x48028000
+#define DM816X_I2C1_BASE		0x4802A000
+
+#define DM81XX_ELM_BASE			0x48080000
+
+#define DM81XX_GPIO0_BASE		0x48032000
+#define DM81XX_GPIO1_BASE		0x4804C000
+
+#define DM81XX_USBSS_BASE		0x47400000
+
+#define DM81XX_USB0_BASE		0x47401000
+#define DM81XX_USB1_BASE		0x47401800
+
+#define DM816X_TIMER0_BASE		0x4802E000
+#define DM816X_TIMER1_BASE		0x48040000
+#define DM816X_TIMER2_BASE		0x48042000
+#define DM816X_TIMER3_BASE		0x48044000
+#define DM816X_TIMER4_BASE		0x48046000
+#define DM816X_TIMER5_BASE		0x48048000
+#define DM816X_TIMER6_BASE		0x4804A000
+
+#define DM816X_MMC0_BASE		0x48060000
+
+#define DM816X_SPI0_BASE		0x48030000
 
 #endif /* __ASM_ARCH_DM81XX_H */
diff --git a/arch/arm/mach-omap2/dma.h b/arch/arm/mach-omap2/dma.h
index 65f80ca..6bd28ee 100644
--- a/arch/arm/mach-omap2/dma.h
+++ b/arch/arm/mach-omap2/dma.h
@@ -36,6 +36,18 @@
 #define OMAP24XX_DMA_I2C1_RX		28	/* S_DMA_27 */
 #define OMAP24XX_DMA_I2C2_TX		29	/* S_DMA_28 */
 #define OMAP24XX_DMA_I2C2_RX		30	/* S_DMA_29 */
+
+#ifdef CONFIG_MACH_DM816X_EVM
+#define OMAP24XX_DMA_SPI1_TX0		16	/* E_DMA_16 */
+#define OMAP24XX_DMA_SPI1_RX0		17	/* E_DMA_17 */
+#define OMAP24XX_DMA_SPI1_TX1		18	/* E_DMA_18 */
+#define OMAP24XX_DMA_SPI1_RX1		19	/* E_DMA_19 */
+#define OMAP24XX_DMA_SPI1_TX2		20	/* E_DMA_20 */
+#define OMAP24XX_DMA_SPI1_RX2		21	/* E_DMA_21 */
+#define OMAP24XX_DMA_SPI1_TX3		22	/* E_DMA_22 */
+#define OMAP24XX_DMA_SPI1_RX3		23	/* E_DMA_23 */
+#endif
+
 #define OMAP24XX_DMA_MMC2_TX		47	/* S_DMA_46 */
 #define OMAP24XX_DMA_MMC2_RX		48	/* S_DMA_47 */
 #define OMAP24XX_DMA_UART1_TX		49	/* S_DMA_48 */
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index f3808ce..6c6e27f 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -518,7 +518,7 @@ void __init dm81xx_init_early(void)
 	omap3xxx_voltagedomains_init();
 	dm81xx_powerdomains_init();
 	dm81xx_clockdomains_init();
-	omap3xxx_hwmod_init();
+	dm81xx_hwmod_init();
 	omap_hwmod_init_postsetup();
 	omap_clk_init = omap3xxx_clk_init;
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.h b/arch/arm/mach-omap2/omap_hwmod.h
index 0c898f5..f05d98d 100644
--- a/arch/arm/mach-omap2/omap_hwmod.h
+++ b/arch/arm/mach-omap2/omap_hwmod.h
@@ -700,6 +700,7 @@ extern int omap2430_hwmod_init(void);
 extern int omap3xxx_hwmod_init(void);
 extern int omap44xx_hwmod_init(void);
 extern int am33xx_hwmod_init(void);
+extern int dm81xx_hwmod_init(void);
 
 extern int __init omap_hwmod_register_links(struct omap_hwmod_ocp_if **ois);
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c b/arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c
new file mode 100644
index 0000000..a428402
--- /dev/null
+++ b/arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c
@@ -0,0 +1,1209 @@
+/*
+ * DM81xx hwmod data.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ * Copyright (C) 2013 SKTB SKiT, http://www.skitlab.ru/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/platform_data/gpio-omap.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+#include <plat/dmtimer.h>
+#include <plat/irqs-dm81xx.h>
+
+#include "dma.h"
+#include "mmc.h"
+#include "omap_hwmod_common_data.h"
+#include "cm_dm81xx.h"
+#include "dm81xx.h"
+
+/*
+ * DM816X hardware modules integration data
+ *
+ * Note: This is incomplete and at present, not generated from h/w database.
+ *
+ * TODO: Add EDMA in the 'user' field wherever applicable.
+ */
+
+static struct omap_hwmod dm816x_mpu_hwmod;
+static struct omap_hwmod dm816x_l3_slow_hwmod;
+static struct omap_hwmod dm816x_l4_slow_hwmod;
+
+/* L3 SLOW -> L4_SLOW Peripheral interface */
+static struct omap_hwmod_ocp_if dm816x_l3_slow__l4_slow = {
+	.master	= &dm816x_l3_slow_hwmod,
+	.slave	= &dm816x_l4_slow_hwmod,
+	.user	= OCP_USER_MPU,
+};
+
+/* MPU -> L3 SLOW interface */
+static struct omap_hwmod_ocp_if dm816x_mpu__l3_slow = {
+	.master = &dm816x_mpu_hwmod,
+	.slave	= &dm816x_l3_slow_hwmod,
+	.user	= OCP_USER_MPU,
+};
+
+/* L3 SLOW */
+static struct omap_hwmod dm816x_l3_slow_hwmod = {
+	.name		= "l3_main",
+	.class		= &l3_hwmod_class,
+	.flags		= HWMOD_NO_IDLEST,
+};
+
+static struct omap_hwmod dm816x_uart1_hwmod;
+static struct omap_hwmod dm816x_uart2_hwmod;
+static struct omap_hwmod dm816x_uart3_hwmod;
+static struct omap_hwmod dm816x_wd_timer2_hwmod;
+static struct omap_hwmod dm81xx_i2c1_hwmod;
+static struct omap_hwmod dm816x_i2c2_hwmod;
+static struct omap_hwmod dm81xx_gpio1_hwmod;
+static struct omap_hwmod dm81xx_gpio2_hwmod;
+static struct omap_hwmod dm81xx_usbss_hwmod;
+static struct omap_hwmod dm81xx_elm_hwmod;
+static struct omap_hwmod dm816x_mmc1_hwmod;
+static struct omap_hwmod dm816x_iva_hwmod;
+static struct omap_hwmod dm816x_mcspi1_hwmod;
+static struct omap_hwmod dm816x_mailbox_hwmod;
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart1;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart2;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart3;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__wd_timer2;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__i2c1;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__i2c2;
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__gpio1;
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__gpio2;
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__elm;
+static struct omap_hwmod_ocp_if dm816x_l4_slow__mmc1;
+static struct omap_hwmod_ocp_if dm816x_l3__iva;
+
+/* L4 SLOW */
+static struct omap_hwmod dm816x_l4_slow_hwmod = {
+	.name		= "l4_slow",
+	.class		= &l4_hwmod_class,
+	.flags		= HWMOD_NO_IDLEST,
+};
+
+/* MPU */
+static struct omap_hwmod dm816x_mpu_hwmod = {
+	.name		= "mpu",
+	.class		= &mpu_hwmod_class,
+	.main_clk	= "arm_fck",
+};
+
+/* UART common */
+
+static struct omap_hwmod_class_sysconfig uart_sysc = {
+	.rev_offs	= 0x50,
+	.sysc_offs	= 0x54,
+	.syss_offs	= 0x58,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE |
+				   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+				   SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class uart_class = {
+	.name = "uart",
+	.sysc = &uart_sysc,
+};
+
+/* UART1 */
+
+/* L4 SLOW -> UART1 interface */
+static struct omap_hwmod_addr_space dm816x_uart1_addr_space[] = {
+	{
+		.pa_start	= DM81XX_UART1_BASE,
+		.pa_end		= DM81XX_UART1_BASE + SZ_8K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_uart1_hwmod,
+	.clk		= "uart1_ick",
+	.addr		= dm816x_uart1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_irq_info uart1_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_UART0, },
+	{ .irq = -1 }
+};
+
+/*
+ * There is no SDMA on DM81XX, instead we have EDMA. Presently using dummy
+ * channel numbers as the omap UART driver (drivers/serial/omap-serial.c)
+ * requires these values to be filled in even if we don't have DMA enabled. Same
+ * applies for other UARTs below.
+ */
+static struct omap_hwmod_dma_info uart1_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 0, },
+	{ .name = "rx",	.dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm816x_uart1_hwmod = {
+	.name		= "uart1",
+	.mpu_irqs	= uart1_mpu_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "uart1_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_UART_0_CLKCTRL_OFF,
+		},
+	},
+	.class		= &uart_class,
+};
+
+/* UART2 */
+
+/* L4 SLOW -> UART2 interface */
+static struct omap_hwmod_addr_space dm816x_uart2_addr_space[] = {
+	{
+		.pa_start	= DM81XX_UART2_BASE,
+		.pa_end		= DM81XX_UART2_BASE + SZ_8K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart2 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_uart2_hwmod,
+	.clk		= "uart2_ick",
+	.addr		= dm816x_uart2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_irq_info uart2_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_UART1, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_dma_info uart2_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 0, },
+	{ .name = "rx",	.dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm816x_uart2_hwmod = {
+	.name		= "uart2",
+	.mpu_irqs	= uart2_mpu_irqs,
+	.sdma_reqs	= uart2_edma_reqs,
+	.main_clk	= "uart2_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_UART_1_CLKCTRL_OFF,
+		},
+	},
+	.class		= &uart_class,
+};
+
+/* UART3 */
+
+/* L4 SLOW -> UART3 interface */
+static struct omap_hwmod_addr_space dm816x_uart3_addr_space[] = {
+	{
+		.pa_start	= DM81XX_UART3_BASE,
+		.pa_end		= DM81XX_UART3_BASE + SZ_8K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__uart3 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_uart3_hwmod,
+	.clk		= "uart3_ick",
+	.addr		= dm816x_uart3_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_irq_info uart3_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_UART2, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_dma_info uart3_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 0, },
+	{ .name = "rx",	.dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm816x_uart3_hwmod = {
+	.name		= "uart3",
+	.mpu_irqs	= uart3_mpu_irqs,
+	.sdma_reqs	= uart3_edma_reqs,
+	.main_clk	= "uart3_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_UART_2_CLKCTRL_OFF,
+		},
+	},
+	.class		= &uart_class,
+};
+
+/* Watchdog */
+
+/*
+ * 'wd_timer' class
+ * 32-bit watchdog upward counter that generates a pulse on the reset pin on
+ * overflow condition
+ */
+
+static struct omap_hwmod_class_sysconfig wd_timer_sysc = {
+	.rev_offs       = 0x0000,
+	.sysc_offs      = 0x0010,
+	.syss_offs      = 0x0014,
+	.sysc_flags     = (SYSC_HAS_SIDLEMODE | SYSC_HAS_EMUFREE |
+					   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+					   SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY),
+	.idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class wd_timer_class = {
+	.name = "wd_timer",
+	.sysc = &wd_timer_sysc,
+};
+
+/* L4 SLOW -> Watchdog */
+static struct omap_hwmod_addr_space dm816x_wd_timer2_addrs[] = {
+	{
+		.pa_start	= DM816X_WDTIMER1_BASE,
+		.pa_end		= DM816X_WDTIMER1_BASE + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__wd_timer2 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_wd_timer2_hwmod,
+	.clk		= "wdt2_ick",
+	.addr		= dm816x_wd_timer2_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod dm816x_wd_timer2_hwmod = {
+	.name		= "wd_timer2",
+	.main_clk	= "wdt2_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_WDTIMER_CLKCTRL_OFF,
+		},
+	},
+	.class		= &wd_timer_class,
+	.flags	  = HWMOD_INIT_NO_RESET,
+};
+
+/* I2C common */
+static struct omap_hwmod_class_sysconfig i2c_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+	.syss_offs	= 0x90,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE |
+				   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+				   SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class i2c_class = {
+	.name = "i2c",
+	.sysc = &i2c_sysc,
+};
+
+/* I2C1 */
+
+/* L4 SLOW -> I2C1 */
+static struct omap_hwmod_addr_space dm816x_i2c1_addr_space[] = {
+	{
+		.pa_start	= DM816X_I2C0_BASE,
+		.pa_end		= DM816X_I2C0_BASE + SZ_4K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__i2c1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm81xx_i2c1_hwmod,
+	.clk		= "i2c1_ick",
+	.addr		= dm816x_i2c1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_irq_info i2c1_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_I2C0, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_dma_info i2c1_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 0, },
+	{ .name = "rx",	.dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm81xx_i2c1_hwmod = {
+	.name		= "i2c1",
+	.mpu_irqs	= i2c1_mpu_irqs,
+	.sdma_reqs	= i2c1_edma_reqs,
+	.main_clk	= "i2c1_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_I2C_0_CLKCTRL_OFF,
+		},
+	},
+	.class		= &i2c_class,
+};
+
+/* I2C2 */
+
+/* L4 SLOW -> I2C2 */
+static struct omap_hwmod_addr_space dm816x_i2c2_addr_space[] = {
+	{
+		.pa_start	= DM816X_I2C1_BASE,
+		.pa_end		= DM816X_I2C1_BASE + SZ_4K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__i2c2 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_i2c2_hwmod,
+	.clk		= "i2c2_ick",
+	.addr		= dm816x_i2c2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_irq_info i2c2_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_I2C1, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_dma_info i2c2_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 0, },
+	{ .name = "rx", .dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm816x_i2c2_hwmod = {
+	.name           = "i2c2",
+	.mpu_irqs       = i2c2_mpu_irqs,
+	.sdma_reqs      = i2c2_edma_reqs,
+	.main_clk       = "i2c2_fck",
+	.prcm           = {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_I2C_1_CLKCTRL_OFF,
+		},
+	},
+	.class          = &i2c_class,
+};
+
+/* ELM */
+static struct omap_hwmod_class_sysconfig dm81xx_elm_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+				SYSC_HAS_SOFTRESET |
+				SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+/* 'elm' class */
+static struct omap_hwmod_class dm81xx_elm_hwmod_class = {
+	.name = "elm",
+	.sysc = &dm81xx_elm_sysc,
+};
+
+static struct omap_hwmod_irq_info dm81xx_elm_irqs[] = {
+	{ .irq = DM81XX_IRQ_ELM },
+	{ .irq = -1 }
+};
+
+struct omap_hwmod_addr_space dm81xx_elm_addr_space[] = {
+	{
+		.pa_start	= DM81XX_ELM_BASE,
+		.pa_end		= DM81XX_ELM_BASE + SZ_8K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__elm = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm81xx_elm_hwmod,
+	.addr		= dm81xx_elm_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* elm */
+static struct omap_hwmod dm81xx_elm_hwmod = {
+	.name           = "elm",
+	.class          = &dm81xx_elm_hwmod_class,
+	.main_clk       = "elm_fck",
+	.mpu_irqs		= dm81xx_elm_irqs,
+};
+
+/*
+ * 'gpio' class
+ * general purpose io module
+ */
+static struct omap_hwmod_class_sysconfig dm81xx_gpio_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0114,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_ENAWAKEUP |
+				   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+				   SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+				   SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm81xx_gpio_hwmod_class = {
+	.name	= "gpio",
+	.sysc	= &dm81xx_gpio_sysc,
+	.rev	= 2,
+};
+
+/* gpio dev_attr */
+static struct omap_gpio_dev_attr gpio_dev_attr = {
+	.bank_width	= 32,
+	.dbck_flag	= true,
+};
+
+/* GPIO1 DM81XX */
+
+/* L4 SLOW -> GPIO1 */
+static struct omap_hwmod_addr_space dm81xx_gpio1_addrs[] = {
+	{
+		.pa_start	= DM81XX_GPIO0_BASE,
+		.pa_end		= DM81XX_GPIO0_BASE + SZ_4K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__gpio1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm81xx_gpio1_hwmod,
+	.addr		= dm81xx_gpio1_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_irq_info dm81xx_gpio1_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPIO_0A },
+	{ .irq = DM81XX_IRQ_GPIO_0B },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_opt_clk gpio1_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio1_dbck" },
+};
+
+static struct omap_hwmod dm81xx_gpio1_hwmod = {
+	.name		= "gpio1",
+	.class		= &dm81xx_gpio_hwmod_class,
+	.mpu_irqs	= dm81xx_gpio1_irqs,
+	.main_clk	= "gpio1_ick",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_GPIO_0_CLKCTRL_OFF,
+		},
+	},
+	.opt_clks	= gpio1_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio1_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* GPIO2 DM81XX*/
+
+/* L4 SLOW -> GPIO2 */
+static struct omap_hwmod_addr_space dm81xx_gpio2_addrs[] = {
+	{
+		.pa_start	= DM81XX_GPIO1_BASE,
+		.pa_end		= DM81XX_GPIO1_BASE + SZ_4K - 1,
+		.flags		= ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm81xx_l4_slow__gpio2 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm81xx_gpio2_hwmod,
+	.addr		= dm81xx_gpio2_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_irq_info dm81xx_gpio2_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPIO_1A },
+	{ .irq = DM81XX_IRQ_GPIO_1B },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_opt_clk gpio2_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio2_dbck" },
+};
+
+static struct omap_hwmod dm81xx_gpio2_hwmod = {
+	.name		= "gpio2",
+	.class		= &dm81xx_gpio_hwmod_class,
+	.mpu_irqs	= dm81xx_gpio2_irqs,
+	.main_clk	= "gpio2_ick",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_GPIO_1_CLKCTRL_OFF,
+		},
+	},
+	.opt_clks	= gpio2_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio2_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* L3 SLOW -> USBSS interface */
+static struct omap_hwmod_addr_space dm81xx_usbss_addr_space[] = {
+	{
+		.name		= "usbss",
+		.pa_start	= DM81XX_USBSS_BASE,
+		.pa_end		= DM81XX_USBSS_BASE + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "musb0",
+		.pa_start	= DM81XX_USB0_BASE,
+		.pa_end		= DM81XX_USB0_BASE + SZ_2K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "musb1",
+		.pa_start	= DM81XX_USB1_BASE,
+		.pa_end		= DM81XX_USB1_BASE + SZ_2K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_class_sysconfig dm81xx_usbhsotg_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+};
+
+static struct omap_hwmod_class dm81xx_usbotg_class = {
+	.name = "usbotg",
+	.sysc = &dm81xx_usbhsotg_sysc,
+};
+
+static struct omap_hwmod_irq_info dm81xx_usbss_mpu_irqs[] = {
+	{ .name = "usbss-irq", .irq = DM81XX_IRQ_USBSS, },
+	{ .name = "musb0-irq", .irq = DM81XX_IRQ_USB0, },
+	{ .name = "musb1-irq", .irq = DM81XX_IRQ_USB1, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_ocp_if dm81xx_l3_slow__usbss = {
+	.master		= &dm816x_l3_slow_hwmod,
+	.slave		= &dm81xx_usbss_hwmod,
+	.clk		= "usb_ick",
+	.addr		= dm81xx_usbss_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod dm81xx_usbss_hwmod = {
+	.name		= "usb_otg_hs",
+	.mpu_irqs	= dm81xx_usbss_mpu_irqs,
+	.main_clk	= "usb_ick",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_DEFAULT_USB_CLKCTRL_OFF,
+		},
+	},
+	.class		= &dm81xx_usbotg_class,
+};
+
+/* timer class */
+static struct omap_hwmod_class_sysconfig dm816x_timer_1ms_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_CLOCKACTIVITY |
+				   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+				   SYSC_HAS_EMUFREE | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm816x_timer_1ms_hwmod_class = {
+	.name = "timer",
+	.sysc = &dm816x_timer_1ms_sysc,
+	.rev = OMAP_TIMER_IP_VERSION_1,
+};
+
+static struct omap_hwmod_class_sysconfig dm816x_timer_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
+				   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm816x_timer_hwmod_class = {
+	.name = "timer",
+	.sysc = &dm816x_timer_sysc,
+	.rev =  OMAP_TIMER_IP_VERSION_1,
+};
+
+/* always-on timers dev attribute */
+static struct omap_timer_capability_dev_attr capability_alwon_dev_attr = {
+	.timer_capability       = OMAP_TIMER_ALWON,
+};
+
+/* timer1 */
+static struct omap_hwmod dm816x_timer1_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer1_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER0_BASE,
+		.pa_end		= DM816X_TIMER0_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer1_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT1, },
+	{ .irq = -1 }
+};
+
+/* l4_wkup -> timer1 */
+static struct omap_hwmod_ocp_if dm816x_l4_wkup__timer1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer1_hwmod,
+	.clk		= "gpt1_ick",
+	.addr		= dm816x_timer1_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer1 hwmod */
+static struct omap_hwmod dm816x_timer1_hwmod = {
+	.name		= "timer1",
+	.mpu_irqs	= dm816x_timer1_mpu_irqs,
+	.main_clk	= "gpt1_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_0_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_1ms_hwmod_class,
+};
+
+/* timer2 */
+static struct omap_hwmod dm816x_timer2_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer2_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER1_BASE,
+		.pa_end		= DM816X_TIMER1_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer2_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT2, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer2 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer2 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer2_hwmod,
+	.clk		= "gpt2_ick",
+	.addr		= dm816x_timer2_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer2 hwmod */
+static struct omap_hwmod dm816x_timer2_hwmod = {
+	.name		= "timer2",
+	.mpu_irqs	= dm816x_timer2_mpu_irqs,
+	.main_clk	= "gpt2_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_1_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_1ms_hwmod_class,
+};
+
+/* timer3 */
+static struct omap_hwmod dm816x_timer3_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer3_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER2_BASE,
+		.pa_end		= DM816X_TIMER2_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer3_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT3, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer3 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer3 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer3_hwmod,
+	.clk		= "gpt3_ick",
+	.addr		= dm816x_timer3_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer3 hwmod */
+static struct omap_hwmod dm816x_timer3_hwmod = {
+	.name		= "timer3",
+	.mpu_irqs	= dm816x_timer3_mpu_irqs,
+	.main_clk	= "gpt3_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_2_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_hwmod_class,
+};
+
+/* timer4 */
+static struct omap_hwmod dm816x_timer4_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer4_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER3_BASE,
+		.pa_end		= DM816X_TIMER3_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer4_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT4, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer4 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer4 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer4_hwmod,
+	.clk		= "gpt4_ick",
+	.addr		= dm816x_timer4_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer4 hwmod */
+static struct omap_hwmod dm816x_timer4_hwmod = {
+	.name		= "timer4",
+	.mpu_irqs	= dm816x_timer4_mpu_irqs,
+	.main_clk	= "gpt4_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_3_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_hwmod_class,
+};
+
+/* timer5 */
+static struct omap_hwmod dm816x_timer5_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer5_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER4_BASE,
+		.pa_end		= DM816X_TIMER4_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer5_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT5, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer5 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer5 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer5_hwmod,
+	.clk		= "gpt5_ick",
+	.addr		= dm816x_timer5_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer5 hwmod */
+static struct omap_hwmod dm816x_timer5_hwmod = {
+	.name		= "timer5",
+	.mpu_irqs	= dm816x_timer5_mpu_irqs,
+	.main_clk	= "gpt5_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_4_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_hwmod_class,
+};
+
+/* timer6 */
+static struct omap_hwmod dm816x_timer6_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer6_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER5_BASE,
+		.pa_end		= DM816X_TIMER5_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer6_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT6, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer6 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer6 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer6_hwmod,
+	.clk		= "gpt6_ick",
+	.addr		= dm816x_timer6_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer6 hwmod */
+static struct omap_hwmod dm816x_timer6_hwmod = {
+	.name		= "timer6",
+	.mpu_irqs	= dm816x_timer6_mpu_irqs,
+	.main_clk	= "gpt6_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_5_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_hwmod_class,
+};
+
+/* timer7 */
+static struct omap_hwmod dm816x_timer7_hwmod;
+
+static struct omap_hwmod_addr_space dm816x_timer7_addrs[] = {
+	{
+		.pa_start	= DM816X_TIMER6_BASE,
+		.pa_end		= DM816X_TIMER6_BASE + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+struct omap_hwmod_irq_info dm816x_timer7_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_GPT7, },
+	{ .irq = -1 }
+};
+
+/* l4_per -> timer7 */
+static struct omap_hwmod_ocp_if dm816x_l4_per__timer7 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_timer7_hwmod,
+	.clk		= "gpt7_ick",
+	.addr		= dm816x_timer7_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* timer7 hwmod */
+static struct omap_hwmod dm816x_timer7_hwmod = {
+	.name		= "timer7",
+	.mpu_irqs	= dm816x_timer7_mpu_irqs,
+	.main_clk	= "gpt7_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_TIMER_6_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &capability_alwon_dev_attr,
+	.class		= &dm816x_timer_hwmod_class,
+};
+
+/* MMC/SD/SDIO common */
+
+static struct omap_hwmod_class_sysconfig dm816x_mmc_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x110,
+	.syss_offs	= 0x114,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+				   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+				   SYSC_HAS_AUTOIDLE | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm816x_mmc_class = {
+	.name = "mmc",
+	.sysc = &dm816x_mmc_sysc,
+};
+
+/* MMC/SD/SDIO1 */
+
+static struct omap_hwmod_irq_info dm816x_mmc1_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_SD, },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_dma_info dm816x_mmc1_sdma_reqs[] = {
+	{ .name = "tx",	.dma_req = OMAP24XX_DMA_MMC1_TX, },
+	{ .name = "rx",	.dma_req = OMAP24XX_DMA_MMC1_RX, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod_opt_clk dm816x_mmc1_opt_clks[] = {
+	{ .role = "dbck", .clk = "sys_32k_ck", },
+};
+
+struct omap_hwmod_addr_space dm816x_mmc1_addr_space[] = {
+	{
+		.pa_start	= DM816X_MMC0_BASE,
+		.pa_end		= DM816X_MMC0_BASE + SZ_64K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if dm816x_l4_slow__mmc1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_mmc1_hwmod,
+	.clk		= "mmchs1_ick",
+	.addr		= dm816x_mmc1_addr_space,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+	.flags		= OMAP_FIREWALL_L4
+};
+
+static struct omap_mmc_dev_attr mmc1_dev_attr = {
+	.flags = OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
+};
+
+static struct omap_hwmod dm816x_mmc1_hwmod = {
+	.name		= "mmc1",
+	.mpu_irqs	= dm816x_mmc1_mpu_irqs,
+	.sdma_reqs	= dm816x_mmc1_sdma_reqs,
+	.opt_clks	= dm816x_mmc1_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(dm816x_mmc1_opt_clks),
+	.main_clk	= "mmchs1_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM816X_CM_ALWON_SDIO_CLKCTRL_OFF,
+		},
+	},
+	.dev_attr	= &mmc1_dev_attr,
+	.class		= &dm816x_mmc_class,
+};
+
+/*
+ * IVA2_2 interface data
+ */
+
+/* IVA2 <- L3 interface */
+static struct omap_hwmod_ocp_if dm816x_l3__iva = {
+	.master		= &dm816x_l3_slow_hwmod,
+	.slave		= &dm816x_iva_hwmod,
+	.clk		= "iva2_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* IVA2 (IVA2) */
+
+static struct omap_hwmod dm816x_iva_hwmod = {
+	.name		= "iva",
+	.class		= &iva_hwmod_class,
+};
+
+/* MCSPI */
+
+struct omap_hwmod_addr_space dm816x_mcspi1_addr_space[] = {
+	{
+		.pa_start	= DM816X_SPI0_BASE + 0x100,
+		.pa_end		= DM816X_SPI0_BASE - 0x100 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l4 core -> mcspi1 interface */
+static struct omap_hwmod_ocp_if dm816x_l4_core__mcspi1 = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_mcspi1_hwmod,
+	.clk		= "mcspi1_ick",
+	.addr		= dm816x_mcspi1_addr_space,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_class_sysconfig dm816x_mcspi_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+				   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+				   SYSC_HAS_AUTOIDLE | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm816x_mcspi_class = {
+	.name = "mcspi",
+	.sysc = &dm816x_mcspi_sysc,
+	.rev = OMAP3_MCSPI_REV,
+};
+
+static struct omap2_mcspi_dev_attr dm816x_mcspi1_dev_attr = {
+	.num_chipselect = 4,
+};
+
+struct omap_hwmod_irq_info dm816x_mcspi1_mpu_irqs[] = {
+	{ .irq = DM81XX_IRQ_SPI },
+	{ .irq = -1 }
+};
+
+struct omap_hwmod_dma_info dm816x_mcspi1_sdma_reqs[] = {
+	{ .name = "tx0", .dma_req = OMAP24XX_DMA_SPI1_TX0 },
+	{ .name = "rx0", .dma_req = OMAP24XX_DMA_SPI1_RX0 },
+	{ .name = "tx1", .dma_req = OMAP24XX_DMA_SPI1_TX1 },
+	{ .name = "rx1", .dma_req = OMAP24XX_DMA_SPI1_RX1 },
+	{ .name = "tx2", .dma_req = OMAP24XX_DMA_SPI1_TX2 },
+	{ .name = "rx2", .dma_req = OMAP24XX_DMA_SPI1_RX2 },
+	{ .name = "tx3", .dma_req = OMAP24XX_DMA_SPI1_TX3 },
+	{ .name = "rx3", .dma_req = OMAP24XX_DMA_SPI1_RX3 },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod dm816x_mcspi1_hwmod = {
+	.name		= "mcspi1",
+	.mpu_irqs	= dm816x_mcspi1_mpu_irqs,
+	.sdma_reqs	= dm816x_mcspi1_sdma_reqs,
+	.main_clk	= "mcspi1_fck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DM81XX_CM_ALWON_SPI_CLKCTRL_OFF,
+		},
+	},
+	.class		= &dm816x_mcspi_class,
+	.dev_attr   = &dm816x_mcspi1_dev_attr,
+};
+
+/*
+ * 'mailbox' class
+ * mailbox module allowing communication between the on-chip processors
+ * using a queued mailbox-interrupt mechanism.
+ */
+
+static struct omap_hwmod_class_sysconfig dm816x_mailbox_sysc = {
+	.rev_offs	= 0x000,
+	.sysc_offs	= 0x010,
+	.syss_offs	= 0x014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+				   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dm816x_mailbox_hwmod_class = {
+	.name = "mailbox",
+	.sysc = &dm816x_mailbox_sysc,
+};
+
+static struct omap_hwmod_irq_info dm816x_mailbox_irqs[] = {
+	{ .irq = DM81XX_IRQ_MBOX },
+	{ .irq = -1 }
+};
+
+#define DM81XX_MBOX_REG_SIZE            0x144
+static struct omap_hwmod_addr_space dm816x_mailbox_addrs[] = {
+	{
+		.pa_start	= DM81XX_MAILBOX_BASE,
+		.pa_end		= DM81XX_MAILBOX_BASE + DM81XX_MBOX_REG_SIZE - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+/* l4_core -> mailbox */
+static struct omap_hwmod_ocp_if dm816x_l4_core__mailbox = {
+	.master		= &dm816x_l4_slow_hwmod,
+	.slave		= &dm816x_mailbox_hwmod,
+	.addr		= dm816x_mailbox_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod dm816x_mailbox_hwmod = {
+	.name		= "mailbox",
+	.class		= &dm816x_mailbox_hwmod_class,
+	.mpu_irqs	= dm816x_mailbox_irqs,
+	.main_clk	= "mailbox_ick",
+	.prcm		= {
+		.omap4 = {
+		},
+	},
+};
+
+static struct omap_hwmod_ocp_if *dm816x_hwmod_ocp_ifs[] __initdata = {
+	&dm816x_mpu__l3_slow,
+	&dm816x_l3_slow__l4_slow,
+	&dm816x_l4_slow__uart1,
+	&dm816x_l4_slow__uart2,
+	&dm816x_l4_slow__uart3,
+	&dm816x_l4_slow__wd_timer2,
+	&dm816x_l4_slow__i2c1,
+	&dm816x_l4_slow__i2c2,
+	&dm81xx_l4_slow__gpio1,
+	&dm81xx_l4_slow__gpio2,
+	&dm81xx_l4_slow__elm,
+	&dm816x_l4_slow__mmc1,
+	&dm81xx_l3_slow__usbss,
+	&dm816x_l4_wkup__timer1,
+	&dm816x_l4_per__timer2,
+	&dm816x_l4_per__timer3,
+	&dm816x_l4_per__timer4,
+	&dm816x_l4_per__timer5,
+	&dm816x_l4_per__timer6,
+	&dm816x_l4_per__timer7,
+	&dm816x_l4_core__mcspi1,
+	&dm816x_l4_core__mailbox,
+	&dm816x_l3__iva,
+	NULL,
+};
+
+int __init dm81xx_hwmod_init(void)
+{
+	omap_hwmod_init();
+	return omap_hwmod_register_links(dm816x_hwmod_ocp_ifs);
+}
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index fb92abb..dd66663 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -58,6 +58,12 @@
 #define OMAP_TIMER_NONPOSTED			0x00
 #define OMAP_TIMER_POSTED			0x01
 
+/*
+ * IP revision identifier so that Highlander IP
+ * in OMAP4 can be distinguished.
+ */
+#define OMAP_TIMER_IP_VERSION_1                        0x1
+
 /* timer capabilities used in hwmod database */
 #define OMAP_TIMER_SECURE				0x80000000
 #define OMAP_TIMER_ALWON				0x40000000
diff --git a/arch/arm/plat-omap/include/plat/irqs-dm81xx.h b/arch/arm/plat-omap/include/plat/irqs-dm81xx.h
new file mode 100644
index 0000000..2a44864
--- /dev/null
+++ b/arch/arm/plat-omap/include/plat/irqs-dm81xx.h
@@ -0,0 +1,43 @@
+/*
+ * DM81xx family interrupts.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ * Copyright (C) 2013 SKTB SKiT, http://www.skitlab.ru/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_DM81XX_IRQS_H
+#define __ARCH_ARM_MACH_OMAP2_DM81XX_IRQS_H
+
+#define DM81XX_IRQ_ELM		4
+#define DM81XX_IRQ_USBSS	17
+#define DM81XX_IRQ_USB0		18
+#define DM81XX_IRQ_USB1		19
+#define DM81XX_IRQ_SD		64
+#define DM81XX_IRQ_SPI		65
+#define DM81XX_IRQ_GPT1		67
+#define DM81XX_IRQ_GPT2		68
+#define DM81XX_IRQ_GPT3		69
+#define DM81XX_IRQ_I2C0		70
+#define DM81XX_IRQ_I2C1		71
+#define DM81XX_IRQ_UART0	72
+#define DM81XX_IRQ_UART1	73
+#define DM81XX_IRQ_UART2	74
+#define DM81XX_IRQ_MBOX		77
+#define DM81XX_IRQ_GPT4		92
+#define DM81XX_IRQ_GPT5		93
+#define DM81XX_IRQ_GPT6		94
+#define DM81XX_IRQ_GPT7		95
+#define DM81XX_IRQ_GPIO_0A	96
+#define DM81XX_IRQ_GPIO_0B	97
+#define DM81XX_IRQ_GPIO_1A	98
+#define DM81XX_IRQ_GPIO_1B	99
+#endif
-- 
1.7.10.4



