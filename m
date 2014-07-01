Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbaGAJfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757812AbaGAJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 13/14] AT91: PIT: Convert to an early_platform_device
Date: Tue,  1 Jul 2014 11:33:26 +0200
Message-Id: <1404207208-14513-14-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the legacy probing mechanism to the early_platform_driver probe.

This will allow a clear separation between the driver and the machine setup
code, which will in turn ease the move out of mach-at91.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c      | 30 ++++++++++++++++++++++++--
 arch/arm/mach-at91/at91sam9261.c      | 30 ++++++++++++++++++++++++--
 arch/arm/mach-at91/at91sam9263.c      | 30 ++++++++++++++++++++++++--
 arch/arm/mach-at91/at91sam926x_time.c | 40 ++++++++++++++++++++---------------
 arch/arm/mach-at91/at91sam9g45.c      | 31 +++++++++++++++++++++++++--
 arch/arm/mach-at91/at91sam9rl.c       | 30 ++++++++++++++++++++++++--
 arch/arm/mach-at91/generic.h          |  2 --
 7 files changed, 164 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index d5141af1947c..a64ecaf905c0 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -341,7 +341,6 @@ static void __init at91sam9260_ioremap_registers(void)
 	at91_ioremap_shdwc(AT91SAM9260_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9260_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9260_BASE_SDRAMC, 512);
-	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9260_BASE_MATRIX);
 	at91_pm_set_standby(at91sam9_sdram_standby);
@@ -400,9 +399,36 @@ static unsigned int at91sam9260_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static struct resource pit_resources[] = {
+	[0] = {
+		.start	= AT91SAM9260_BASE_PIT,
+		.end	= AT91SAM9260_BASE_PIT + SZ_16 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pit_device = {
+	.name		= "at91_pit",
+	.resource	= pit_resources,
+	.num_resources	= ARRAY_SIZE(pit_resources),
+};
+
+static struct platform_device *at91sam9260_early_devices[] __initdata = {
+	&pit_device,
+};
+
 static void __init at91sam9260_init_time(void)
 {
-	at91sam926x_pit_init();
+	early_platform_add_devices(at91sam9260_early_devices,
+				   ARRAY_SIZE(at91sam9260_early_devices));
+
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 1, 0);
 }
 
 AT91_SOC_START(at91sam9260)
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 5416fe4d5a0b..c8f85ace7f33 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -304,7 +304,6 @@ static void __init at91sam9261_ioremap_registers(void)
 	at91_ioremap_shdwc(AT91SAM9261_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9261_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9261_BASE_SDRAMC, 512);
-	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9261_BASE_MATRIX);
 	at91_pm_set_standby(at91sam9_sdram_standby);
@@ -363,9 +362,36 @@ static unsigned int at91sam9261_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static struct resource pit_resources[] = {
+	[0] = {
+		.start	= AT91SAM9261_BASE_PIT,
+		.end	= AT91SAM9261_BASE_PIT + SZ_16 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pit_device = {
+	.name		= "at91_pit",
+	.resource	= pit_resources,
+	.num_resources	= ARRAY_SIZE(pit_resources),
+};
+
+static struct platform_device *at91sam9261_early_devices[] __initdata = {
+	&pit_device,
+};
+
 static void __init at91sam9261_init_time(void)
 {
-	at91sam926x_pit_init();
+	early_platform_add_devices(at91sam9261_early_devices,
+				   ARRAY_SIZE(at91sam9261_early_devices));
+
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 1, 0);
 }
 
 AT91_SOC_START(at91sam9261)
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 20b46118338c..b4bdfc20e0df 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -320,7 +320,6 @@ static void __init at91sam9263_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9263_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9263_BASE_SDRAMC0, 512);
 	at91_ioremap_ramc(1, AT91SAM9263_BASE_SDRAMC1, 512);
-	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
 	at91_ioremap_matrix(AT91SAM9263_BASE_MATRIX);
@@ -381,9 +380,36 @@ static unsigned int at91sam9263_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller (IRQ1) */
 };
 
+static struct resource pit_resources[] = {
+	[0] = {
+		.start	= AT91SAM9263_BASE_PIT,
+		.end	= AT91SAM9263_BASE_PIT + SZ_16 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pit_device = {
+	.name		= "at91_pit",
+	.resource	= pit_resources,
+	.num_resources	= ARRAY_SIZE(pit_resources),
+};
+
+static struct platform_device *at91sam9263_early_devices[] __initdata = {
+	&pit_device,
+};
+
 static void __init at91sam9263_init_time(void)
 {
-	at91sam926x_pit_init();
+	early_platform_add_devices(at91sam9263_early_devices,
+				   ARRAY_SIZE(at91sam9263_early_devices));
+
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 1, 0);
 }
 
 AT91_SOC_START(at91sam9263)
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 9abb289dce72..6fd97875bb5c 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -15,15 +15,15 @@
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
+#include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
-
 #define AT91_PIT_MR		0x00			/* Mode Register */
 #define AT91_PIT_PITIEN			BIT(25)			/* Timer Interrupt Enable */
 #define AT91_PIT_PITEN			BIT(24)			/* Timer Enabled */
@@ -265,34 +265,40 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
 		       at91sam926x_pit_dt_init);
 
-static void __iomem *pit_base_addr;
-
-void __init at91sam926x_pit_init(void)
+static int __init pit_early_probe(struct platform_device *pdev)
 {
 	struct pit_data *data;
+	struct resource *res;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		panic(pr_fmt("Unable to allocate memory\n"));
 
-	data->base = pit_base_addr;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!request_mem_region(res->start, resource_size(res),	"at91_pit"))
+		panic(pr_fmt("Unable to request memory region\n"));
+
+	data->base = ioremap(res->start, resource_size(res));
+	if (!data->base)
+		panic(pr_fmt("Impossible to ioremap PIT\n"));
 
 	data->mck = clk_get(NULL, "mck");
 	if (IS_ERR(data->mck))
 		panic(pr_fmt("Unable to get mck clk\n"));
 
-	data->irq = NR_IRQS_LEGACY + AT91_ID_SYS;
+	data->irq = platform_get_irq(pdev, 0);
+	if (data->irq < 0)
+		panic(pr_fmt("Unable to get IRQ from resources\n"));
 
 	at91sam926x_pit_common_init(data);
-}
 
-void __init at91sam926x_ioremap_pit(u32 addr)
-{
-	if (of_have_populated_dt())
-		return;
-
-	pit_base_addr = ioremap(addr, 16);
-
-	if (!pit_base_addr)
-		panic(pr_fmt("Impossible to ioremap PIT\n"));
+	return 0;
 }
+
+static struct platform_driver pit_driver __initdata = {
+	.probe		= pit_early_probe,
+	.driver		= {
+		.name	= "at91_pit",
+	},
+};
+early_platform_init("earlytimer", &pit_driver);
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 924d362121ef..b7ab0998afce 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk/at91_pmc.h>
+#include <linux/platform_device.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -370,7 +371,6 @@ static void __init at91sam9g45_ioremap_registers(void)
 	at91_ioremap_rstc(AT91SAM9G45_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9G45_BASE_DDRSDRC1, 512);
 	at91_ioremap_ramc(1, AT91SAM9G45_BASE_DDRSDRC0, 512);
-	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9G45_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9G45_BASE_MATRIX);
 	at91_pm_set_standby(at91_ddr_standby);
@@ -430,9 +430,36 @@ static unsigned int at91sam9g45_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller (IRQ0) */
 };
 
+static struct resource pit_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_PIT,
+		.end	= AT91SAM9G45_BASE_PIT + SZ_16 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pit_device = {
+	.name		= "at91_pit",
+	.resource	= pit_resources,
+	.num_resources	= ARRAY_SIZE(pit_resources),
+};
+
+static struct platform_device *at91sam9g45_early_devices[] __initdata = {
+	&pit_device,
+};
+
 static void __init at91sam9g45_init_time(void)
 {
-	at91sam926x_pit_init();
+	early_platform_add_devices(at91sam9g45_early_devices,
+				   ARRAY_SIZE(at91sam9g45_early_devices));
+
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 1, 0);
 }
 
 AT91_SOC_START(at91sam9g45)
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index dd4a8deb5b36..664c29efdf3e 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -313,7 +313,6 @@ static void __init at91sam9rl_ioremap_registers(void)
 	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9RL_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9RL_BASE_SDRAMC, 512);
-	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9RL_BASE_MATRIX);
 	at91_pm_set_standby(at91sam9_sdram_standby);
@@ -373,9 +372,36 @@ static unsigned int at91sam9rl_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static struct resource pit_resources[] = {
+	[0] = {
+		.start	= AT91SAM9RL_BASE_PIT,
+		.end	= AT91SAM9RL_BASE_PIT + SZ_16 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pit_device = {
+	.name		= "at91_pit",
+	.resource	= pit_resources,
+	.num_resources	= ARRAY_SIZE(pit_resources),
+};
+
+static struct platform_device *at91sam9rl_early_devices[] __initdata = {
+	&pit_device,
+};
+
 static void __init at91sam9rl_init_time(void)
 {
-	at91sam926x_pit_init();
+	early_platform_add_devices(at91sam9rl_early_devices,
+				   ARRAY_SIZE(at91sam9rl_early_devices));
+
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 1, 0);
 }
 
 AT91_SOC_START(at91sam9rl)
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index eb5512c3d717..2269d5fb83a9 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -45,8 +45,6 @@ extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 extern void __init at91_init_time(void);
 extern void at91rm9200_ioremap_st(u32 addr);
 extern void at91rm9200_timer_init(void);
-extern void at91sam926x_ioremap_pit(u32 addr);
-extern void at91sam926x_pit_init(void);
 extern void at91x40_timer_init(void);
 
  /* Clocks */
-- 
2.0.0

