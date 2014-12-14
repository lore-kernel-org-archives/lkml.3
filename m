Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaLNXMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:12:41 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:31327 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLNXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:12:35 -0500
X-ME-Helo: beldin.home
X-ME-Date: Mon, 15 Dec 2014 00:12:33 +0100
X-ME-IP: 86.199.199.51
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: pxa: lubbock: use new cottula driver
Date: Mon, 15 Dec 2014 00:12:18 +0100
Message-Id: <1418598738-21449-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the interrupt handling was transferred to the cottula driver, make
the switch in lubbock platform code.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/include/mach/lubbock.h |   7 +-
 arch/arm/mach-pxa/lubbock.c              | 112 +++++++++----------------------
 2 files changed, 37 insertions(+), 82 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/lubbock.h b/arch/arm/mach-pxa/include/mach/lubbock.h
index 958cd6af..f602e6a 100644
--- a/arch/arm/mach-pxa/include/mach/lubbock.h
+++ b/arch/arm/mach-pxa/include/mach/lubbock.h
@@ -37,7 +37,9 @@
 #define LUB_GP			__LUB_REG(LUBBOCK_FPGA_PHYS + 0x100)
 
 /* Board specific IRQs */
-#define LUBBOCK_IRQ(x)		(IRQ_BOARD_START + (x))
+#define LUBBOCK_NR_IRQS		IRQ_BOARD_START
+
+#define LUBBOCK_IRQ(x)		(LUBBOCK_NR_IRQS + (x))
 #define LUBBOCK_SD_IRQ		LUBBOCK_IRQ(0)
 #define LUBBOCK_SA1111_IRQ	LUBBOCK_IRQ(1)
 #define LUBBOCK_USB_IRQ		LUBBOCK_IRQ(2)  /* usb connect */
@@ -47,8 +49,7 @@
 #define LUBBOCK_USB_DISC_IRQ	LUBBOCK_IRQ(6)  /* usb disconnect */
 #define LUBBOCK_LAST_IRQ	LUBBOCK_IRQ(6)
 
-#define LUBBOCK_SA1111_IRQ_BASE	(IRQ_BOARD_START + 16)
-#define LUBBOCK_NR_IRQS		(IRQ_BOARD_START + 16 + 55)
+#define LUBBOCK_SA1111_IRQ_BASE	(LUBBOCK_NR_IRQS + 16)
 
 #ifndef __ASSEMBLY__
 extern void lubbock_set_misc_wr(unsigned int mask, unsigned int set);
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index d8a1be6..44e35b7 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -12,6 +12,7 @@
  *  published by the Free Software Foundation.
  */
 #include <linux/gpio.h>
+#include <linux/gpio/machine.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -123,84 +124,6 @@ void lubbock_set_misc_wr(unsigned int mask, unsigned int set)
 }
 EXPORT_SYMBOL(lubbock_set_misc_wr);
 
-static unsigned long lubbock_irq_enabled;
-
-static void lubbock_mask_irq(struct irq_data *d)
-{
-	int lubbock_irq = (d->irq - LUBBOCK_IRQ(0));
-	LUB_IRQ_MASK_EN = (lubbock_irq_enabled &= ~(1 << lubbock_irq));
-}
-
-static void lubbock_unmask_irq(struct irq_data *d)
-{
-	int lubbock_irq = (d->irq - LUBBOCK_IRQ(0));
-	/* the irq can be acknowledged only if deasserted, so it's done here */
-	LUB_IRQ_SET_CLR &= ~(1 << lubbock_irq);
-	LUB_IRQ_MASK_EN = (lubbock_irq_enabled |= (1 << lubbock_irq));
-}
-
-static struct irq_chip lubbock_irq_chip = {
-	.name		= "FPGA",
-	.irq_ack	= lubbock_mask_irq,
-	.irq_mask	= lubbock_mask_irq,
-	.irq_unmask	= lubbock_unmask_irq,
-};
-
-static void lubbock_irq_handler(unsigned int irq, struct irq_desc *desc)
-{
-	unsigned long pending = LUB_IRQ_SET_CLR & lubbock_irq_enabled;
-	do {
-		/* clear our parent irq */
-		desc->irq_data.chip->irq_ack(&desc->irq_data);
-		if (likely(pending)) {
-			irq = LUBBOCK_IRQ(0) + __ffs(pending);
-			generic_handle_irq(irq);
-		}
-		pending = LUB_IRQ_SET_CLR & lubbock_irq_enabled;
-	} while (pending);
-}
-
-static void __init lubbock_init_irq(void)
-{
-	int irq;
-
-	pxa25x_init_irq();
-
-	/* setup extra lubbock irqs */
-	for (irq = LUBBOCK_IRQ(0); irq <= LUBBOCK_LAST_IRQ; irq++) {
-		irq_set_chip_and_handler(irq, &lubbock_irq_chip,
-					 handle_level_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-	}
-
-	irq_set_chained_handler(PXA_GPIO_TO_IRQ(0), lubbock_irq_handler);
-	irq_set_irq_type(PXA_GPIO_TO_IRQ(0), IRQ_TYPE_EDGE_FALLING);
-}
-
-#ifdef CONFIG_PM
-
-static void lubbock_irq_resume(void)
-{
-	LUB_IRQ_MASK_EN = lubbock_irq_enabled;
-}
-
-static struct syscore_ops lubbock_irq_syscore_ops = {
-	.resume = lubbock_irq_resume,
-};
-
-static int __init lubbock_irq_device_init(void)
-{
-	if (machine_is_lubbock()) {
-		register_syscore_ops(&lubbock_irq_syscore_ops);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-device_initcall(lubbock_irq_device_init);
-
-#endif
-
 static int lubbock_udc_is_connected(void)
 {
 	return (LUB_MISC_RD & (1 << 9)) == 0;
@@ -383,11 +306,33 @@ static struct platform_device lubbock_flash_device[2] = {
 	},
 };
 
+static struct resource cottula_resources[] = {
+	[0] = {
+		.start	= LUBBOCK_FPGA_PHYS,
+		.end	= LUBBOCK_FPGA_PHYS + 256 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= LUBBOCK_IRQ(0),
+		.end	= LUBBOCK_IRQ(0),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device cottula_device = {
+	.name		= "cottula",
+	.id		= -1,
+	.resource	= &cottula_resources[0],
+	.num_resources	= 2,
+};
+
+
 static struct platform_device *devices[] __initdata = {
 	&sa1111_device,
 	&smc91x_device,
 	&lubbock_flash_device[0],
 	&lubbock_flash_device[1],
+	&cottula_device,
 };
 
 static struct pxafb_mode_info sharp_lm8v31_mode = {
@@ -504,11 +449,20 @@ static struct pxaficp_platform_data lubbock_ficp_platform_data = {
 	.transceiver_mode	= lubbock_irda_transceiver_mode,
 };
 
+static struct gpiod_lookup_table cottula_gpios_table = {
+	.dev_id = "cottula",
+	.table = {
+		GPIO_LOOKUP("gpio-0", 0, "lubbock_irq", GPIO_ACTIVE_HIGH),
+		{ },
+	},
+};
+
 static void __init lubbock_init(void)
 {
 	int flashboot = (LUB_CONF_SWITCHES & 1);
 
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(lubbock_pin_config));
+	gpiod_add_lookup_table(&cottula_gpios_table);
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -648,7 +602,7 @@ MACHINE_START(LUBBOCK, "Intel DBPXA250 Development Platform (aka Lubbock)")
 	/* Maintainer: MontaVista Software Inc. */
 	.map_io		= lubbock_map_io,
 	.nr_irqs	= LUBBOCK_NR_IRQS,
-	.init_irq	= lubbock_init_irq,
+	.init_irq	= pxa25x_init_irq,
 	.handle_irq	= pxa25x_handle_irq,
 	.init_time	= pxa_timer_init,
 	.init_machine	= lubbock_init,
-- 
2.1.0

