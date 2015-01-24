Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbbAXPGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:06:16 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:31056 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbbAXPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:05:56 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 24 Jan 2015 16:05:55 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v4 3/4] ARM: pxa: lubbock: use new lubbock_cplds driver
Date: Sat, 24 Jan 2015 16:05:02 +0100
Message-Id: <1422111903-22176-3-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
References: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the interrupt handling was transferred to the lubbock_cplds driver,
make the switch in lubbock platform code.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v1: change the name from cottula to lubbock_io
            Dmitry pointed out the Cottula was the pxa25x family name,
	    lubbock was the pxa25x development board name. Therefore the
	    name was changed to lubbock_io (lubbock IO board)
	  change the resources to bi-irq ioresource
	    Discussion between Arnd and Robert to change the gpio
	    request by a irq request.
Since v3: rename lubbock_io into lubbock_cplds
---
 arch/arm/mach-pxa/include/mach/lubbock.h |   7 +-
 arch/arm/mach-pxa/lubbock.c              | 108 +++++++++----------------------
 2 files changed, 33 insertions(+), 82 deletions(-)

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
index d8a1be6..a0c91d8 100644
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
@@ -383,11 +306,38 @@ static struct platform_device lubbock_flash_device[2] = {
 	},
 };
 
+static struct resource lubbock_cplds_resources[] = {
+	[0] = {
+		.start	= LUBBOCK_FPGA_PHYS,
+		.end	= LUBBOCK_FPGA_PHYS + 256 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= PXA_GPIO_TO_IRQ(0),
+		.end	= LUBBOCK_IRQ(0),
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_LOWEDGE,
+	},
+	[2] = {
+		.start	= LUBBOCK_IRQ(0),
+		.end	= LUBBOCK_IRQ(0),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device lubbock_cplds_device = {
+	.name		= "lubbock_cplds",
+	.id		= -1,
+	.resource	= &lubbock_cplds_resources[0],
+	.num_resources	= 3,
+};
+
+
 static struct platform_device *devices[] __initdata = {
 	&sa1111_device,
 	&smc91x_device,
 	&lubbock_flash_device[0],
 	&lubbock_flash_device[1],
+	&lubbock_cplds_device,
 };
 
 static struct pxafb_mode_info sharp_lm8v31_mode = {
@@ -648,7 +598,7 @@ MACHINE_START(LUBBOCK, "Intel DBPXA250 Development Platform (aka Lubbock)")
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

