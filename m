Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaJTTFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:00 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:50276 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaJTTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:17 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] clocksource: mips-gic: Use clockevents_config_and_register
Date: Mon, 20 Oct 2014 12:04:05 -0700
Message-Id: <1413831846-32100-19-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clockevents_config_and_register to setup the clock_event_device
based on frequency and min/max ticks instead of doing it ourselves.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clocksource/mips-gic-timer.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 3ce992b..84fbb7a 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -15,8 +15,6 @@
 #include <linux/smp.h>
 #include <linux/time.h>
 
-#include <asm/time.h>
-
 static DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
 static int gic_timer_irq;
 static unsigned int gic_frequency;
@@ -63,19 +61,13 @@ static void gic_clockevent_cpu_init(struct clock_event_device *cd)
 	cd->features		= CLOCK_EVT_FEAT_ONESHOT |
 				  CLOCK_EVT_FEAT_C3STOP;
 
-	clockevent_set_clock(cd, gic_frequency);
-
-	/* Calculate the min / max delta */
-	cd->max_delta_ns	= clockevent_delta2ns(0x7fffffff, cd);
-	cd->min_delta_ns	= clockevent_delta2ns(0x300, cd);
-
 	cd->rating		= 300;
 	cd->irq			= gic_timer_irq;
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= gic_next_event;
 	cd->set_mode		= gic_set_clock_mode;
 
-	clockevents_register_device(cd);
+	clockevents_config_and_register(cd, gic_frequency, 0x300, 0x7fffffff);
 
 	enable_percpu_irq(gic_timer_irq, IRQ_TYPE_NONE);
 }
-- 
2.1.0.rc2.206.gedb03e5

