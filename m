Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaIFRxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:53:44 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63723 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaIFRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:53:03 -0400
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
Subject: [PATCHv4 4/4] clocksource: tcb_clksrc: sanitize IRQ request
Date: Sat,  6 Sep 2014 19:52:37 +0200
Message-Id: <1410025957-5952-5-git-send-email-gael.portay@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410025957-5952-1-git-send-email-gael.portay@gmail.com>
References: <1410025957-5952-1-git-send-email-gael.portay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock is not unprepared in case of the request IRQ fails.

Also update to request_irq.

Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/clocksource/tcb_clksrc.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index f922e81..8bdbc45 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -178,12 +178,6 @@ static irqreturn_t ch2_irq(int irq, void *handle)
 	return IRQ_NONE;
 }
 
-static struct irqaction tc_irqaction = {
-	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER,
-	.handler	= ch2_irq,
-};
-
 static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
 	int ret;
@@ -198,15 +192,16 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	clkevt.regs = tc->regs;
 	clkevt.clk = t2_clk;
-	tc_irqaction.dev_id = &clkevt;
 
 	timer_clock = clk32k_divisor_idx;
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	ret = setup_irq(irq, &tc_irqaction);
-	if (ret)
+	ret = request_irq(irq, ch2_irq, IRQF_TIMER, "tc_clkevt", &clkevt);
+	if (ret) {
+		clk_disable_unprepare(t2_clk);
 		return ret;
+	}
 
 	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
-- 
1.9.3

