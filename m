Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3JBMft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:35:49 -0400
Received: from 16.mo4.mail-out.ovh.net ([188.165.55.104]:42070 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753449Ab3JBMfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:35:47 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 2/3] ARM: at91/tc/clocksource: improve driver robustness
Date: Wed,  2 Oct 2013 14:35:41 +0200
Message-Id: <1380717341-6612-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 1377538536832661612
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check function return values to avoid false positive driver init.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clocksource/tcb_clksrc.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 0481562..10a5d9e 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -184,11 +184,18 @@ static struct irqaction tc_irqaction = {
 	.handler	= ch2_irq,
 };
 
-static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
+	int ret;
 	struct clk *t2_clk = tc->clk[2];
 	int irq = tc->irq[2];
 
+	/* try to enable t2 clk to avoid future errors in mode change */
+	ret = clk_prepare_enable(t2_clk);
+	if (ret)
+		return ret;
+	clk_disable_unprepare(t2_clk);
+
 	clkevt.regs = tc->regs;
 	clkevt.clk = t2_clk;
 	tc_irqaction.dev_id = &clkevt;
@@ -197,16 +204,21 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
+	ret = setup_irq(irq, &tc_irqaction);
+	if (ret)
+		return ret;
+
 	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
-	setup_irq(irq, &tc_irqaction);
+	return ret;
 }
 
 #else /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
 	/* NOTHING */
+	return 0;
 }
 
 #endif
@@ -328,13 +340,24 @@ static int __init tcb_clksrc_init(void)
 	}
 
 	/* and away we go! */
-	clocksource_register_hz(&clksrc, divided_rate);
+	ret = clocksource_register_hz(&clksrc, divided_rate);
+	if (ret)
+		goto err_disable_t1;
 
 	/* channel 2:  periodic and oneshot timer support */
-	setup_clkevents(tc, clk32k_divisor_idx);
+	ret = setup_clkevents(tc, clk32k_divisor_idx);
+	if (ret)
+		goto err_unregister_clksrc;
 
 	return 0;
 
+err_unregister_clksrc:
+	clocksource_unregister(&clksrc);
+
+err_disable_t1:
+	if (!tc->tcb_config || tc->tcb_config->counter_width != 32)
+		clk_disable_unprepare(tc->clk[1]);
+
 err_disable_t0:
 	clk_disable_unprepare(t0_clk);
 
-- 
1.7.9.5

