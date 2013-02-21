Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3BUWwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:52:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:53441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3BUWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:41 -0500
Message-Id: <20130221224231.174700473@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 7/8] timekeeping: Implement a shadow timekeeper
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-implement-shadow-timekeeper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the shadow timekeeper to do the update_wall_time() adjustments and
then copy it over to the real timekeeper.

Keep the shadow timekeeper in sync when updating stuff outside of
update_wall_time().

This allows us to limit the timekeeper_seq hold time to the update of
the real timekeeper and the vsyscall data in the next patch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

Index: linux-3.6/kernel/time/timekeeping.c
===================================================================
--- linux-3.6.orig/kernel/time/timekeeping.c
+++ linux-3.6/kernel/time/timekeeping.c
@@ -28,6 +28,7 @@
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static seqcount_t timekeeper_seq;
+static struct timekeeper shadow_timekeeper;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -224,7 +225,7 @@ int pvclock_gtod_unregister_notifier(str
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp)
+static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
 {
 	if (clearntp) {
 		tk->ntp_error = 0;
@@ -232,6 +233,9 @@ static void timekeeping_update(struct ti
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk);
+
+	if (mirror)
+		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
 /**
@@ -444,7 +448,7 @@ int do_settimeofday(const struct timespe
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -488,7 +492,7 @@ int timekeeping_inject_offset(struct tim
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -523,7 +527,7 @@ static int change_clocksource(void *data
 		if (old->disable)
 			old->disable(old);
 	}
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -704,6 +708,8 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
+	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
@@ -760,7 +766,7 @@ void timekeeping_inject_sleeptime(struct
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true);
+	timekeeping_update(tk, true, true);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -798,7 +804,7 @@ static void timekeeping_resume(void)
 	tk->clock->cycle_last = tk->clock->read(tk->clock);
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false);
+	timekeeping_update(tk, false, true);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1177,7 +1183,8 @@ static inline void old_vsyscall_fixup(st
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *real_tk = &timekeeper;
+	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
@@ -1189,16 +1196,16 @@ static void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = tk->clock;
+	clock = real_tk->clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = tk->cycle_interval;
+	offset = real_tk->cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
 	/* Check if there's really nothing to do */
-	if (offset < tk->cycle_interval)
+	if (offset < real_tk->cycle_interval)
 		goto out;
 
 	/*
@@ -1237,12 +1244,22 @@ static void update_wall_time(void)
 
 	/* Update clock->cycle_last with the new value */
 	clock->cycle_last = tk->cycle_last;
-	timekeeping_update(tk, false);
+	/*
+	 * Update the real timekeeper.
+	 *
+	 * We could avoid this memcpy by switching pointers, but that
+	 * requires changes to all other timekeeper usage sites as
+	 * well, i.e. move the timekeeper pointer getter into the
+	 * spinlocked/seqcount protected sections. And we trade this
+	 * memcpy under the timekeeper_seq against one before we start
+	 * updating.
+	 */
+	memcpy(real_tk, tk, sizeof(*tk));
+	timekeeping_update(real_tk, false, false);
 
 out:
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-
 }
 
 /**


