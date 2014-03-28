Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaC1R7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:59:44 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43228 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaC1R7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:32 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 04/10] ARM: at91: enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
Date: Fri, 28 Mar 2014 18:59:02 +0100
Message-Id: <1396029548-10928-5-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks in
order to prepare the migration to the new AIC driver.

In the new AIC driver the suspend/resume functions are called by the
generic irq framework and are no longer needed in the PM specific code.

Moreover, the new AIC driver no longer exposes the at91_aic_base variable
which is used by the at91_aic_read functions.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/mach-at91/pm.c    |   32 ++++++++++++++++++++------------
 arch/arm/mach-at91/setup.c |    3 ++-
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 590b52d..b9f4c5c 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -204,16 +204,19 @@ static int at91_pm_enter(suspend_state_t state)
 		at91_pinctrl_gpio_suspend();
 	else
 		at91_gpio_suspend();
-	at91_irq_suspend();
 
-	pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
-			/* remember all the always-wake irqs */
-			(at91_pmc_read(AT91_PMC_PCSR)
-					| (1 << AT91_ID_FIQ)
-					| (1 << AT91_ID_SYS)
-					| (at91_get_extern_irq()))
-				& at91_aic_read(AT91_AIC_IMR),
-			state);
+	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base) {
+		at91_irq_suspend();
+
+		pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
+				/* remember all the always-wake irqs */
+				(at91_pmc_read(AT91_PMC_PCSR)
+						| (1 << AT91_ID_FIQ)
+						| (1 << AT91_ID_SYS)
+						| (at91_get_extern_irq()))
+					& at91_aic_read(AT91_AIC_IMR),
+				state);
+	}
 
 	switch (state) {
 		/*
@@ -278,12 +281,17 @@ static int at91_pm_enter(suspend_state_t state)
 			goto error;
 	}
 
-	pr_debug("AT91: PM - wakeup %08x\n",
-			at91_aic_read(AT91_AIC_IPR) & at91_aic_read(AT91_AIC_IMR));
+	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base)
+		pr_debug("AT91: PM - wakeup %08x\n",
+			 at91_aic_read(AT91_AIC_IPR) &
+			 at91_aic_read(AT91_AIC_IMR));
 
 error:
 	target_state = PM_SUSPEND_ON;
-	at91_irq_resume();
+
+	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base)
+		at91_irq_resume();
+
 	if (of_have_populated_dt())
 		at91_pinctrl_gpio_resume();
 	else
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f7ca97b..1d8a6c8 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -49,7 +49,8 @@ void __init at91_init_irq_default(void)
 void __init at91_init_interrupts(unsigned int *priority)
 {
 	/* Initialize the AIC interrupt controller */
-	at91_aic_init(priority, at91_boot_soc.extern_irq);
+	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91))
+		at91_aic_init(priority, at91_boot_soc.extern_irq);
 
 	/* Enable GPIO interrupts */
 	at91_gpio_irq_setup();
-- 
1.7.9.5

