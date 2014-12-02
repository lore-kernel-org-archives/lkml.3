Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaLBR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:27:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:22584 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaLBR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:27:51 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/8] ARM: at91: cleanup initilisation code by removing dead code
Date: Tue, 2 Dec 2014 18:27:22 +0100
Message-ID: <865a381223cff0d6d976d9bbe1d57a9288ba147b.1417541118.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <e093d7cf37ec9ff24b0631b0a2e405a7cf7574db.1417541118.git.nicolas.ferre@atmel.com>
References: <e093d7cf37ec9ff24b0631b0a2e405a7cf7574db.1417541118.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The AT91-specific SoC strucutre "struct at91_init_soc" was filled with specific
!DT initilisation functions. Now that we got rid of the !DT board file
description, remove unneeded functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[nicolas.ferre@atmel.com: split patch]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/generic.h | 13 -----------
 arch/arm/mach-at91/setup.c   | 54 --------------------------------------------
 arch/arm/mach-at91/soc.h     |  6 -----
 3 files changed, 73 deletions(-)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index eb81940f9848..6c5e67b0edfe 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -22,19 +22,13 @@ extern void __init at91_init_sram(int bank, unsigned long base,
 
  /* Processors */
 extern void __init at91rm9200_set_type(int type);
-extern void __init at91_initialize(unsigned long main_clock);
 extern void __init at91rm9200_dt_initialize(void);
 extern void __init at91_dt_initialize(void);
 
  /* Interrupts */
-extern void __init at91_init_irq_default(void);
-extern void __init at91_init_interrupts(unsigned int priority[]);
 extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
 extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
- /* Devices */
-extern void __init at91_register_devices(void);
-
  /* Timer */
 extern void __init at91_init_time(void);
 extern void at91rm9200_ioremap_st(u32 addr);
@@ -42,19 +36,12 @@ extern void at91rm9200_timer_init(void);
 extern void at91sam926x_ioremap_pit(u32 addr);
 extern void at91sam926x_pit_init(int irq);
 
- /* Power Management */
-extern void at91_irq_suspend(void);
-extern void at91_irq_resume(void);
-
 /* idle */
 extern void at91sam9_idle(void);
 
 /* Matrix */
 extern void at91_ioremap_matrix(u32 base_addr);
 
-/* Ram Controler */
-extern void at91_ioremap_ramc(int id, u32 addr, u32 size);
-
  /* GPIO */
 #define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
 #define AT91RM9200_BGA		4	/* AT91RM9200 BGA package has 4 banks */
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 6c3013e3309b..ce25e85720fb 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -42,31 +42,9 @@ void __init at91rm9200_set_type(int type)
 		at91_get_soc_subtype(&at91_soc_initdata));
 }
 
-void __init at91_init_irq_default(void)
-{
-	at91_init_interrupts(at91_boot_soc.default_irq_priority);
-}
-
-void __init at91_init_interrupts(unsigned int *priority)
-{
-	/* Enable GPIO interrupts */
-	at91_gpio_irq_setup();
-}
-
 void __iomem *at91_ramc_base[2];
 EXPORT_SYMBOL_GPL(at91_ramc_base);
 
-void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
-{
-	if (id < 0 || id > 1) {
-		pr_emerg("Wrong RAM controller id (%d), cannot continue\n", id);
-		BUG();
-	}
-	at91_ramc_base[id] = ioremap(addr, size);
-	if (!at91_ramc_base[id])
-		panic(pr_fmt("Impossible to ioremap ramc.%d 0x%x\n"), id, addr);
-}
-
 static struct map_desc sram_desc[2] __initdata;
 
 void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
@@ -414,7 +392,6 @@ void __init at91_ioremap_matrix(u32 base_addr)
 		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
 }
 
-#if defined(CONFIG_OF)
 static struct of_device_id ramc_ids[] = {
 	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
 	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
@@ -456,10 +433,6 @@ void __init at91rm9200_dt_initialize(void)
 {
 	at91_dt_ramc();
 
-	/* Register the processor-specific clocks */
-	if (at91_boot_soc.register_clocks)
-		at91_boot_soc.register_clocks();
-
 	at91_boot_soc.init();
 }
 
@@ -467,33 +440,6 @@ void __init at91_dt_initialize(void)
 {
 	at91_dt_ramc();
 
-	/* Register the processor-specific clocks */
-	if (at91_boot_soc.register_clocks)
-		at91_boot_soc.register_clocks();
-
 	if (at91_boot_soc.init)
 		at91_boot_soc.init();
 }
-#endif
-
-void __init at91_initialize(unsigned long main_clock)
-{
-	at91_boot_soc.ioremap_registers();
-
-	/* Register the processor-specific clocks */
-	at91_boot_soc.register_clocks();
-
-	at91_boot_soc.init();
-
-	pinctrl_provide_dummies();
-}
-
-void __init at91_register_devices(void)
-{
-	at91_boot_soc.register_devices();
-}
-
-void __init at91_init_time(void)
-{
-	at91_boot_soc.init_time();
-}
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index 9a8fd97a8bef..ae6c0b2f1146 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -6,14 +6,8 @@
 
 struct at91_init_soc {
 	int builtin;
-	u32 extern_irq;
-	unsigned int *default_irq_priority;
 	void (*map_io)(void);
-	void (*ioremap_registers)(void);
-	void (*register_clocks)(void);
-	void (*register_devices)(void);
 	void (*init)(void);
-	void (*init_time)(void);
 };
 
 extern struct at91_init_soc at91_boot_soc;
-- 
2.1.3

