Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaGAJf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33620 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932203AbaGAJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 09/14] AT91: PIT: use request_irq instead of setup_irq
Date: Tue,  1 Jul 2014 11:33:22 +0200
Message-Id: <1404207208-14513-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the generic request_irq now to register a timer interrupt handler,
instead of the more complex setup_irq.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 0abdcb36c555..e476474cb05e 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -173,16 +173,10 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static struct irqaction at91sam926x_pit_irq = {
-	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= at91sam926x_pit_interrupt,
-};
-
 /*
  * Set up both clocksource and clockevent support.
  */
-static void __init at91sam926x_pit_common_init(void)
+static void __init at91sam926x_pit_common_init(unsigned int pit_irq)
 {
 	unsigned long	pit_rate;
 	unsigned	bits;
@@ -208,7 +202,9 @@ static void __init at91sam926x_pit_common_init(void)
 	clocksource_register_hz(&pit_clk, pit_rate);
 
 	/* Set up irq handler */
-	ret = setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
+	ret = request_irq(pit_irq, at91sam926x_pit_interrupt,
+			  IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
+			  "at91_tick", pit_base_addr);
 	if (ret)
 		panic(pr_fmt("Unable to setup IRQ\n"));
 
@@ -239,9 +235,7 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 	if (!irq)
 		panic(pr_fmt("Unable to get IRQ from DT\n"));
 
-	at91sam926x_pit_irq.irq = irq;
-
-	at91sam926x_pit_common_init();
+	at91sam926x_pit_common_init(irq);
 }
 CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
 		       at91sam926x_pit_dt_init);
@@ -252,9 +246,7 @@ void __init at91sam926x_pit_init(void)
 	if (IS_ERR(mck))
 		panic(pr_fmt("Unable to get mck clk\n"));
 
-	at91sam926x_pit_irq.irq = NR_IRQS_LEGACY + AT91_ID_SYS;
-
-	at91sam926x_pit_common_init();
+	at91sam926x_pit_common_init(NR_IRQS_LEGACY + AT91_ID_SYS);
 }
 
 void __init at91sam926x_ioremap_pit(u32 addr)
-- 
2.0.0

