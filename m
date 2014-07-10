Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaGJRPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:15:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57602 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541AbaGJROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:14:36 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 5/7] ARM: at91: enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
Date: Thu, 10 Jul 2014 19:14:20 +0200
Message-Id: <1405012462-766-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks in
order to prepare migration to the new AIC driver.

In the new AIC driver the suspend/resume functions are called by the
generic irq framework and are no longer needed in the PM specific code.

Moreover, the new AIC driver no longer exposes the at91_aic_base variable
which is used by the at91_aic_read functions.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/pm.c    | 32 ++++++++++++++++++++------------
 arch/arm/mach-at91/setup.c |  3 ++-
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index e955545..5920373 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -206,16 +206,19 @@ static int at91_pm_enter(suspend_state_t state)
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
@@ -280,12 +283,17 @@ static int at91_pm_enter(suspend_state_t state)
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
index f7a07a5..0bf893a 100644
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
1.8.3.2

