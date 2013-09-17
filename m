Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3IQVP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:15:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:54986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3IQVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:15:25 -0400
Date: Tue, 17 Sep 2013 23:15:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        LKML <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH] clockevents: Sanitize ticks to nsec conversion
In-Reply-To: <20130917130153.GL26819@ludovic.desroches@atmel.com>
Message-ID: <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
 <20130917130153.GL26819@ludovic.desroches@atmel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Kleine-Budde pointed out, that commit 77cc982 "clocksource: use
clockevents_config_and_register() where possible" caused a regression
for some of the converted subarchs.

The reason is, that the clockevents core code converts the minimal
hardware tick delta to a nanosecond value for core internal
usage. This conversion is affected by integer math rounding loss, so
the backwards conversion to hardware ticks will likely result in a
value which is less than the configured hardware limitation. The
affected subarchs used their own workaround (SIGH!) which got lost in
the conversion.

Now instead of fixing the underlying core code problem, Marcs patch
tried to work around the core code issue by increasing the minimal
tick delta at clockevents registration time so the resulting limit in
the core code backwards conversion did not violate the hardware
limits. More SIGH!

The solution for the issue at hand is simple: adding evt->mult - 1 to
the shifted value before the integer divison in the core conversion
function takes care of it.

Though looking closer at the details of that function reveals another
bogosity: The upper bounds check is broken as well. Checking for a
resulting "clc" value greater than KTIME_MAX after the conversion is
pointless. The conversion does:

      u64 clc = (latch << evt->shift) / evt->mult;

So there is no sanity check for (latch << evt->shift) exceeding the
64bit boundary. The latch argument is "unsigned long", so on a 64bit
arch the handed in argument could easily lead to an unnoticed shift
overflow. With the above rounding fix applied the calculation before
the divison is:

       u64 clc = (latch << evt->shift) + evt->mult - 1;

Now we can easily verify whether the whole equation fits into the
64bit boundary. Shifting the "clc" result back by evt->shift MUST
result in "latch". If that's not the case, we have a clear indicator
for boundary violation and can limit "clc" to (1 << 63) - 1 before the
divison by evt->mult. The resulting nsec * evt->mult in the
programming path will therefor always be in the 64bit boundary.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..4fc4826 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -49,13 +49,25 @@ u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
 		WARN_ON(1);
 	}
 
+	/*
+	 * Prevent integer rounding loss, otherwise the backward
+	 * conversion from nsec to ticks could result in a value less
+	 * than evt->min_delta_ticks.
+	 */
+	clc += evt->mult - 1;
+
+	/*
+	 * Upper bound sanity check. If the backwards conversion is
+	 * not equal latch, we know that the above (shift + rounding
+	 * correction) exceeded the 64 bit boundary.
+	 */
+	if ((clc >> evt->shift) != (u64)latch)
+		clc = ((u64)1 << 63) - 1;
+
 	do_div(clc, evt->mult);
-	if (clc < 1000)
-		clc = 1000;
-	if (clc > KTIME_MAX)
-		clc = KTIME_MAX;
 
-	return clc;
+	/* Deltas less than 1usec are pointless noise */
+	return clc > 1000 ? clc : 1000;
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
