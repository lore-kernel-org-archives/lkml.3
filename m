Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaLEWyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:54:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaLEWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Byshko <rbyshko@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3.17 031/122] clockevent: sun4i: Fix race condition in the probe code
Date: Fri,  5 Dec 2014 14:43:25 -0800
Message-Id: <20141205223310.156614216@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 6bab4a8a1888729f17f4923cc5867e4674f66333 upstream.

The interrupts were activated and the handler registered before the clockevent
was registered in the probe function.

The interrupt handler, however, was making the assumption that the clockevent
device was registered.

That could cause a null pointer dereference if the timer interrupt was firing
during this narrow window.

Fix that by moving the clockevent registration before the interrupt is enabled.

Reported-by: Roman Byshko <rbyshko@gmail.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/sun4i_timer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -182,6 +182,12 @@ static void __init sun4i_timer_init(stru
 	/* Make sure timer is stopped before playing with interrupts */
 	sun4i_clkevt_time_stop(0);
 
+	sun4i_clockevent.cpumask = cpu_possible_mask;
+	sun4i_clockevent.irq = irq;
+
+	clockevents_config_and_register(&sun4i_clockevent, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
+
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
@@ -189,12 +195,6 @@ static void __init sun4i_timer_init(stru
 	/* Enable timer0 interrupt */
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
-
-	sun4i_clockevent.cpumask = cpu_possible_mask;
-	sun4i_clockevent.irq = irq;
-
-	clockevents_config_and_register(&sun4i_clockevent, rate,
-					TIMER_SYNC_TICKS, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-a10-timer",
 		       sun4i_timer_init);


