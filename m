Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3JWK72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:59:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3JWK70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:59:26 -0400
Date: Wed, 23 Oct 2013 03:56:03 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-97b9410643475d6557d2517c2aff9fd2221141a9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, mkl@pengutronix.de,
        ludovic.desroches@atmel.com, linux@arm.linux.org.uk,
        marc.pignat@hevs.ch, u.kleine-koenig@pengutronix.de,
        tglx@linutronix.de, ronald.wahl@raritan.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mkl@pengutronix.de,
        ludovic.desroches@atmel.com, linux@arm.linux.org.uk,
        marc.pignat@hevs.ch, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, ronald.wahl@raritan.com
In-Reply-To: <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clockevents:
  Sanitize ticks to nsec conversion
Git-Commit-ID: 97b9410643475d6557d2517c2aff9fd2221141a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 03:56:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97b9410643475d6557d2517c2aff9fd2221141a9
Gitweb:     http://git.kernel.org/tip/97b9410643475d6557d2517c2aff9fd2221141a9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 24 Sep 2013 21:50:23 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Oct 2013 12:51:21 +0200

clockevents: Sanitize ticks to nsec conversion

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 kernel/time/clockevents.c | 65 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..662c579 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -33,29 +33,64 @@ struct ce_unbind {
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
 
@@ -380,8 +415,8 @@ void clockevents_config(struct clock_event_device *dev, u32 freq)
 		sec = 600;
 
 	clockevents_calc_mult_shift(dev, freq, sec);
-	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
-	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
+	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
+	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
 }
 
 /**
