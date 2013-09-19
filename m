Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3ISOao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:30:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:36127 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3ISOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:30:43 -0400
Date: Thu, 19 Sep 2013 16:30:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        LKML <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
In-Reply-To: <20130919124805.GU24802@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de>
References: <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com> <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de> <20130918150958.GO24802@pengutronix.de> <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de> <20130919100239.GS24802@pengutronix.de> <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de>
 <20130919124805.GU24802@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
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

The solution for the issue at hand is simple: adding evt->mult - 1 to
the shifted value before the integer divison in the core conversion
function takes care of it. But this only works for the case where for
the scaled math mult/shift pair "mult <= 1 << shift" is true. For the
case where "mult > 1 << shift" we can apply the rounding add only for
the minimum delta value to make sure that the backward conversion is
not less than the given hardware limit. For the upper bound we need to
omit the rounding add, because the backwards conversion is always
larger than the original latch value. That would violate the upper
bound of the hardware device.

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

So we need to make sure, that neither the shift nor the rounding add
is overflowing the u64 boundary.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: nicolas.ferre@atmel.com
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: john.stultz@linaro.org
Cc: kernel@pengutronix.de
Cc: Ronald Wahl <ronald.wahl@raritan.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: u.kleine-koenig@pengutronix.de
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>

---
 kernel/time/clockevents.c |   64 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/time/clockevents.c
===================================================================
--- linux-2.6.orig/kernel/time/clockevents.c
+++ linux-2.6/kernel/time/clockevents.c
@@ -33,29 +33,63 @@ struct ce_unbind {
 	int res;
 };
 
-/**
- * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
- * @latch:	value to convert
- * @evt:	pointer to clock event device descriptor
- *
- * Math helper, returns latch value converted to nanoseconds (bound checked)
- */
-u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
+static u64 cev_delta2ns(unsigned long latch, struct clock_event_device *evt,
+			bool ismax)
 {
 	u64 clc = (u64) latch << evt->shift;
+	u64 rnd = (u64) evt->mult - 1;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
 		WARN_ON(1);
 	}
 
+	/*
+	 * Upper bound sanity check. If the backwards conversion is
+	 * not equal latch, we know that the above shift overflowed.
+	 */
+	if (clc >> evt->shift) != (u64)latch)
+		clc = ~0ULL;
+
+	/*
+	 * Scaled math oddities:
+	 *
+	 * For mult <= (1 << shift) we can safely add mult - 1 to
+	 * prevent integer rounding loss. So the backwards conversion
+	 * from nsec to device ticks will be correct.
+	 *
+	 * For mult > (1 << shift), i.e. device frequency is > 1GHz we
+	 * need to be careful. Adding mult - 1 will result in a value
+	 * which when converted back to device ticks will be larger
+	 * than latch by (mult / (1 << shift)) - 1. For the min_delta
+	 * calculation we still want to apply this in order to stay
+	 * above the minimum device ticks limit. For the upper limit
+	 * we would end up with a latch value larger than the upper
+	 * limit of the device, so we omit the add to stay below the
+	 * device upper boundary.
+	 *
+	 * Also omit the add if it would overflow the u64 boundary.
+	 */
+	if ((~0ULL - clc > rnd) &&
+	    (!ismax || evt->mult <= (1U << evt->shift)))
+		clc += rnd;
+
 	do_div(clc, evt->mult);
-	if (clc < 1000)
-		clc = 1000;
-	if (clc > KTIME_MAX)
-		clc = KTIME_MAX;
 
-	return clc;
+	/* Deltas less than 1usec are pointless noise */
+	return clc > 1000 ? clc : 1000;
+}
+
+/**
+ * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
+ * @latch:	value to convert
+ * @evt:	pointer to clock event device descriptor
+ *
+ * Math helper, returns latch value converted to nanoseconds (bound checked)
+ */
+u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
+{
+	return cev_delta2ns(latch, evt, false);
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
@@ -380,8 +414,8 @@ void clockevents_config(struct clock_eve
 		sec = 600;
 
 	clockevents_calc_mult_shift(dev, freq, sec);
-	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
-	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
+	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
+	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
 }
 
 /**
