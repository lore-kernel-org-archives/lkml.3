Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3JZM1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:27:13 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64008 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3JZM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:27:11 -0400
Date: Sat, 26 Oct 2013 14:27:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20131026122708.GA25259@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   # HEAD: 97b9410643475d6557d2517c2aff9fd2221141a9 clockevents: Sanitize ticks to nsec conversion

This tree contains a clockevents regression fix for certain ARM 
subarchitectures.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion


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
