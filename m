Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaGAJfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33620 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932201AbaGAJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:18 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 07/14] AT91: PIT: Use consistent exit path in probe
Date: Tue,  1 Jul 2014 11:33:20 +0200
Message-Id: <1404207208-14513-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current probe code is, whenever it fails to retrieve a resource, either
panicing, silently returning, or returning and displaying an error.

Make the code consistent by always panicing whenever it fails to grab any
resource.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index f6c44539af6e..641e860e83e7 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -208,7 +208,7 @@ static void __init at91sam926x_pit_common_init(void)
 	/* Set up irq handler */
 	ret = setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 	if (ret)
-		pr_crit("AT91: PIT: Unable to setup IRQ\n");
+		panic("AT91: PIT: Unable to setup IRQ\n");
 
 	/* Set up and register clockevents */
 	pit_clkevt.mult = div_sc(pit_rate, NSEC_PER_SEC, pit_clkevt.shift);
@@ -222,7 +222,7 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 
 	pit_base_addr = of_iomap(node, 0);
 	if (!pit_base_addr)
-		return;
+		panic("AT91: PIT: Could not map PIT address\n");
 
 	mck = of_clk_get(node, 0);
 	if (IS_ERR(mck))
@@ -234,18 +234,12 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
 
 	/* Get the interrupts property */
 	irq = irq_of_parse_and_map(node, 0);
-	if (!irq) {
-		pr_crit("AT91: PIT: Unable to get IRQ from DT\n");
-		goto clk_err;
-	}
+	if (!irq)
+		panic("AT91: PIT: Unable to get IRQ from DT\n");
 
 	at91sam926x_pit_irq.irq = irq;
 
 	at91sam926x_pit_common_init();
-
-clk_err:
-	clk_put(mck);
-	iounmap(pit_base_addr);
 }
 CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
 		       at91sam926x_pit_dt_init);
@@ -256,7 +250,7 @@ void __init at91sam926x_pit_init(void)
 	if (IS_ERR(mck))
 		panic("AT91: PIT: Unable to get mck clk\n");
 
-	at91sam926x_pit_irq.irq = NR_IRQS_LEGACY + AT91_ID_SYS,
+	at91sam926x_pit_irq.irq = NR_IRQS_LEGACY + AT91_ID_SYS;
 
 	at91sam926x_pit_common_init();
 }
-- 
2.0.0

