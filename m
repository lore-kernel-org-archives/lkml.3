Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3KYNXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:23:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3KYNIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        Marc Pignat <marc.pignat@hevs.ch>, john.stultz@linaro.org,
        kernel@pengutronix.de, Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 21/78] clockevents: Sanitize ticks to nsec conversion
Date: Mon, 25 Nov 2013 13:06:08 +0000
Message-Id: <1385384825-21681-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 97b9410643475d6557d2517c2aff9fd2221141a9 upstream.

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

[ukl: move assignment to rnd after eventually changing mult, fix build
 issue and correct comment with the right math]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: nicolas.ferre@atmel.com
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: john.stultz@linaro.org
Cc: kernel@pengutronix.de
Cc: Ronald Wahl <ronald.wahl@raritan.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Link: http://lkml.kernel.org/r/1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/clockevents.c | 65 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 7e1ce01..9b7a7fb 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -30,29 +30,64 @@ static RAW_NOTIFIER_HEAD(clockevents_chain);
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
 
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
+	u64 rnd;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
 		WARN_ON(1);
 	}
+	rnd = (u64) evt->mult - 1;
+
+	/*
+	 * Upper bound sanity check. If the backwards conversion is
+	 * not equal latch, we know that the above shift overflowed.
+	 */
+	if ((clc >> evt->shift) != (u64)latch)
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
+	 * which when converted back to device ticks can be larger
+	 * than latch by up to (mult - 1) >> shift. For the min_delta
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
 
@@ -317,8 +352,8 @@ void clockevents_config(struct clock_event_device *dev, u32 freq)
 		sec = 600;
 
 	clockevents_calc_mult_shift(dev, freq, sec);
-	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
-	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
+	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
+	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
 }
 
 /**
-- 
1.8.3.2

