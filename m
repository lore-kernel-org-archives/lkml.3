Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3LTKp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:45:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:60159 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3LTKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:45:54 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?UTF-8?q?Sami=20Pietik=C3=A4inen?= <Sami.Pietikainen@wapice.com>,
        tglx@linutronix.de, Benedikt Spranger <b.spranger@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] ARM: AT91: PIT: Remove irq handler when clock event is unused
Date: Fri, 20 Dec 2013 11:45:40 +0100
Message-Id: <1387536341-7452-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de>
References: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedikt Spranger <b.spranger@linutronix.de>

Setup and remove the interrupt handler in clock event mode selection.
This avoids calling the (shared) interrupt handler when the device is
not used.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: redo the patch with NR_IRQS_LEGACY which is probably required since
commit 8fe82a55 ("ARM: at91: sparse irq support") which is included since v3.6.
Patch based on what Sami Pietikäinen <Sami.Pietikainen@wapice.com> suggested].
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/mach-at91/at91rm9200_time.c  | 1 +
 arch/arm/mach-at91/at91sam926x_time.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index bc7b363..fd34d55 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -134,6 +134,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
+		remove_irq(NR_IRQS_LEGACY + AT91_ID_SYS, &at91rm9200_timer_irq);
 	case CLOCK_EVT_MODE_RESUME:
 		irqmask = 0;
 		break;
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index bb39232..1c4c487 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -77,7 +77,7 @@ static struct clocksource pit_clk = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-
+static struct irqaction at91sam926x_pit_irq;
 /*
  * Clockevent device:  interrupts every 1/HZ (== pit_cycles * MCK/16)
  */
@@ -86,6 +86,8 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		/* Set up irq handler */
+		setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 		/* update clocksource counter */
 		pit_cnt += pit_cycle * PIT_PICNT(pit_read(AT91_PIT_PIVR));
 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN
@@ -98,6 +100,7 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	case CLOCK_EVT_MODE_UNUSED:
 		/* disable irq, leaving the clocksource active */
 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
+		remove_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		break;
-- 
1.8.5.1

