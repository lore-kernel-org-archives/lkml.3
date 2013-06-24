Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3FXQaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:30:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:50441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FXQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:30:29 -0400
Date: Mon, 24 Jun 2013 18:30:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
In-Reply-To: <51C824A8.1080305@citrix.com>
Message-ID: <alpine.DEB.2.02.1306241753080.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com> <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de>
 <51C824A8.1080305@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, David Vrabel wrote:
> On 22/06/13 00:06, Thomas Gleixner wrote:
> This patch set is fixing the rare case where a guest is started before
> NTP has synced and thus sees an incorrect wallclock time which may cause
> the guest to fail to boot.

You're not fixing it, you are just making the window smaller.

clock_was_set() is called outside of the timekeeper_lock protected
regions, so what prevents the guest to start before the notifier is
invoked?

We already have a synchronous notifier in place and the notifier call
itself is not expensive. What's expensive is the hypercall and there
is no way at the moment to figure out whether the update is relevant
for you or just a tick. Though that's trivial information to provide
without imposing another notifier including the surrounding mess on
the core code.

Completely untested patch below.

Thanks,

	tglx
---
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..6e9f838 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -200,9 +200,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
-static void update_pvclock_gtod(struct timekeeper *tk)
+static void update_pvclock_gtod(struct timekeeper *tk, bool cws)
 {
-	raw_notifier_call_chain(&pvclock_gtod_chain, 0, tk);
+	raw_notifier_call_chain(&pvclock_gtod_chain, cws, tk);
 }
 
 /**
@@ -216,7 +216,7 @@ int pvclock_gtod_register_notifier(struct notifier_block *nb)
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, true);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -241,14 +241,15 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
+static void timekeeping_update(struct timekeeper *tk, bool clearntp,
+			       bool mirror, bool cws)
 {
 	if (clearntp) {
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
 	update_vsyscall(tk);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, cws);
 
 	if (mirror)
 		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
@@ -508,7 +509,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, true, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -552,7 +553,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, true, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -633,7 +634,7 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, true, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -872,7 +873,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, true, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -954,7 +955,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false, true);
+	timekeeping_update(tk, false, true, true);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1236,9 +1237,10 @@ out_adjust:
  * It also calls into the NTP code to handle leapsecond processing.
  *
  */
-static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
+static inline bool accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	bool ret = false;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1261,8 +1263,10 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
 			clock_was_set_delayed();
+			ret = true;
 		}
 	}
+	return ret;
 }
 
 /**
@@ -1348,6 +1352,7 @@ static void update_wall_time(void)
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
+	bool cws;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 
@@ -1399,7 +1404,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	accumulate_nsecs_to_secs(tk);
+	cws = accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1415,7 +1420,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, false, false);
+	timekeeping_update(real_tk, false, false, cws);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -1677,6 +1682,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
+		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
