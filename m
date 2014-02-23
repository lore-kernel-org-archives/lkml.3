Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaBWACT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 19:02:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:49263 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBWACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 19:02:18 -0500
Date: Sun, 23 Feb 2014 01:02:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] timer fixes for 3.14
Message-ID: <alpine.DEB.2.02.1402230100570.21251@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
timers-urgent-for-linus

Short summary:

      * Serialize the registration of a new sched_clock in the
        currently ARM only generic sched_clock facilty to avoid
        sched_clock havoc

Thanks,

        tglx

------------------>
Stephen Boyd (1):
      sched_clock: Prevent callers from seeing half-updated data


 kernel/time/sched_clock.c |   46 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 0abb364..4d23dc4 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -116,20 +116,42 @@ static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 void __init sched_clock_register(u64 (*read)(void), int bits,
 				 unsigned long rate)
 {
+	u64 res, wrap, new_mask, new_epoch, cyc, ns;
+	u32 new_mult, new_shift;
+	ktime_t new_wrap_kt;
 	unsigned long r;
-	u64 res, wrap;
 	char r_unit;
 
 	if (cd.rate > rate)
 		return;
 
 	WARN_ON(!irqs_disabled());
-	read_sched_clock = read;
-	sched_clock_mask = CLOCKSOURCE_MASK(bits);
-	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
-	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
+	clocks_calc_mult_shift(&new_mult, &new_shift, rate, NSEC_PER_SEC, 3600);
+
+	new_mask = CLOCKSOURCE_MASK(bits);
+
+	/* calculate how many ns until we wrap */
+	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
+	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+
+	/* update epoch for new counter and update epoch_ns from old counter*/
+	new_epoch = read();
+	cyc = read_sched_clock();
+	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
+			  cd.mult, cd.shift);
+
+	raw_write_seqcount_begin(&cd.seq);
+	read_sched_clock = read;
+	sched_clock_mask = new_mask;
+	cd.rate = rate;
+	cd.wrap_kt = new_wrap_kt;
+	cd.mult = new_mult;
+	cd.shift = new_shift;
+	cd.epoch_cyc = new_epoch;
+	cd.epoch_ns = ns;
+	raw_write_seqcount_end(&cd.seq);
 
 	r = rate;
 	if (r >= 4000000) {
@@ -141,22 +163,12 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	} else
 		r_unit = ' ';
 
-	/* calculate how many ns until we wrap */
-	wrap = clocks_calc_max_nsecs(cd.mult, cd.shift, 0, sched_clock_mask);
-	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
-
 	/* calculate the ns resolution of this counter */
-	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
+	res = cyc_to_ns(1ULL, new_mult, new_shift);
+
 	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lluns\n",
 		bits, r, r_unit, res, wrap);
 
-	update_sched_clock();
-
-	/*
-	 * Ensure that sched_clock() starts off at 0ns
-	 */
-	cd.epoch_ns = 0;
-
 	/* Enable IRQ time accounting if we have a fast enough sched_clock */
 	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
 		enable_sched_clock_irqtime();
