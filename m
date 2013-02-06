Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3BFXCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:02:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab3BFXCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:02:37 -0500
Date: Thu, 7 Feb 2013 00:02:20 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
Message-ID: <20130206230220.GA18329@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <1360112748.2621.25.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 05-02-13 20:05:48, Steven Rostedt wrote:
> [ I sent this in a reply to another thread, but wanted a bit more attention to it ]
> 
> To prevent deadlocks with doing a printk inside the scheduler,
> printk_sched() was created. The issue is that printk has a console_sem
> that it can grab and release. The release does a wake up if there's a
> task pending on the sem, and this wake up grabs the rq locks that is
> held in the scheduler. This leads to a possible deadlock if the wake up
> uses the same rq as the one with the rq lock held already.
> 
> What printk_sched() does is to save the printk write in a per cpu buffer
> and sets the PRINTK_PENDING_SCHED flag. On a timer tick, if this flag is
> set, the printk() is done against the buffer.
> 
> There's a couple of issues with this approach.
> 
> 1) If two printk_sched()s are called before the tick, the second one
> will overwrite the first one.
> 
> 2) The temporary buffer is 512 bytes and is per cpu. This is a quite a
> bit of space wasted for something that is seldom used.
> 
> In order to remove this, the printk_sched() can instead use the printk
> buffer instead, and delay the console_trylock()/console_unlock() to the
> tick.
> 
> Because printk_sched() would then be taking the logbuf_lock, the
> logbuf_lock must not be held while doing anything that may call into the
> scheduler functions, which includes wake ups. Unfortunately, printk()
> also has a console_sem that it uses, and on release, the
> up(&console_sem) may do a wake up of any pending waiters. This must be
> avoided while holding the logbuf_lock.
> 
> Luckily, there's not many places that do the unlock, or hold the
> logbuf_lock. By moving things around a little, the console_sem can be
> released without ever holding the logbuf_lock, and we can safely have
> printk_sched() use the printk buffer directly.
  So after quite some experiments and some hair tearing I have a patch that
uses PRINTK_PENDING_OUTPUT and makes the machine survive my heavy-printk
test. The first patch I attach is actually a small improvement of your
patch which I think can be folded in it. I was also wondering whether we
still need printk_needs_cpu(). I left it in since I don't know about a
better way of keeping at least one CPU ticking. But maybe others do?

The second patch then makes use of PRINTK_PENDING_OUTPUT to handle the
printing when console_unlock() would take too long. If you wonder whether
the last_printing_cpu in printk_tick() is necessary - it is... Without it
we keep printing on one CPU and the machine complains, looses drives,
etc... (I guess I should add this comment somewhere to the code).

Anyway, what do you guys think about this version?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--zhXaljGHf11kAtnf
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-printk-Remove-per-cpu-printk-flags.patch"

>From bda93cfa4133c41e8f10dcd371d1f025d94b85dc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Feb 2013 19:15:30 +0100
Subject: [PATCH 2/3] printk: Remove per-cpu printk flags

There's no need to have printk flags percpu. Just make a single variable
operated by atomic operations from it. It also has an advantage that any
cpu can do the printing / wakeup work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index ed630fa..2fe917d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1986,28 +1986,24 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-/*
- * Delayed printk version, for scheduler-internal messages:
- */
-#define PRINTK_BUF_SIZE		512
+#define PRINTK_PENDING_WAKEUP	1
+#define PRINTK_PENDING_OUTPUT	2
 
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_OUTPUT	0x02
-
-static DEFINE_PER_CPU(int, printk_pending);
+static unsigned long printk_pending;
 
 void printk_tick(void)
 {
-	if (__this_cpu_read(printk_pending)) {
-		int pending = __this_cpu_xchg(printk_pending, 0);
-		if (pending & PRINTK_PENDING_OUTPUT) {
+	if (printk_pending) {
+		unsigned long pending = xchg(&printk_pending, 0);
+
+		if (test_bit(PRINTK_PENDING_OUTPUT, &pending)) {
 			if (console_trylock())
 				console_unlock();
 			else
 				/* Try again later */
-				__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+				set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 		}
-		if (pending & PRINTK_PENDING_WAKEUP)
+		if (test_bit(PRINTK_PENDING_WAKEUP, &pending))
 			wake_up_interruptible(&log_wait);
 	}
 }
@@ -2016,13 +2012,13 @@ int printk_needs_cpu(int cpu)
 {
 	if (cpu_is_offline(cpu))
 		printk_tick();
-	return __this_cpu_read(printk_pending);
+	return printk_pending;
 }
 
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		set_bit(PRINTK_PENDING_WAKEUP, &printk_pending);
 }
 
 static void console_cont_flush(char *text, size_t size)
@@ -2497,7 +2493,7 @@ int printk_sched(const char *fmt, ...)
 	r = vprintk_emit(0, -2, NULL, 0, fmt, args);
 	va_end(args);
 
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+	set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 
 	return r;
 }
-- 
1.7.1


--zhXaljGHf11kAtnf
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-printk-Avoid-softlockups-in-console_unlock.patch"

>From 4d44b91477c73a29dd16a032bc431227d159f1bf Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Jan 2013 15:15:06 +0100
Subject: [PATCH 3/3] printk: Avoid softlockups in console_unlock()

A CPU can be caught in console_unlock() for a long time (tens of seconds are
reported by our customers) when other CPUs are using printk heavily and serial
console makes printing slow. Despite serial console drivers are calling
touch_nmi_watchdog() this triggers softlockup warnings because
interrupts are disabled for the whole time console_unlock() runs (e.g.
vprintk() calls console_unlock() with interrupts disabled). Thus IPIs
cannot be processed and other CPUs get stuck spinning in calls like
smp_call_function_many(). Also RCU eventually starts reporting lockups.

In my artifical testing I also managed to trigger a situation when disk
disappeared from the system apparently because commands to / from it
could not be delivered for long enough. This is why just silencing
watchdogs isn't a reliable solution to the problem and we simply have to
avoid spending too long in console_unlock().

We fix the issue by limiting the time we spend in console_unlock() to
watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
happening). The rest of the buffer will be printed either by further
callers to printk() or during next timer tick.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/nmi.h |   18 +++++++++++++
 kernel/printk.c     |   70 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 13 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..ce32959 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -51,6 +51,24 @@ extern int watchdog_thresh;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
+/*
+ * Return the maximum number of nanosecond for which interrupts may be disabled
+ * on the current CPU
+ */
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/*
+	 * We give us some headroom because timers need time to fire before the
+	 * watchdog period expires.
+	 */
+	return ((u64)watchdog_thresh) * NSEC_PER_SEC / 2;
+}
+#else
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/* About the value we'd get with the default watchdog setting */
+	return 5ULL * NSEC_PER_SEC;
+}
 #endif
 
 #endif
diff --git a/kernel/printk.c b/kernel/printk.c
index 2fe917d..c4f7f6f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1990,17 +1990,31 @@ int is_console_locked(void)
 #define PRINTK_PENDING_OUTPUT	2
 
 static unsigned long printk_pending;
+static int last_printing_cpu = -1;
+
+static bool __console_unlock(void);
 
 void printk_tick(void)
 {
 	if (printk_pending) {
-		unsigned long pending = xchg(&printk_pending, 0);
+		unsigned long pending;
+		int cpu = smp_processor_id();
+
+		/*
+		 * Did we last print? Give other cpus a chance to do it but
+		 * reset the variable so that we do printing in the next tick
+		 * if noone else got to it.
+		 */
+		if (cmpxchg(&last_printing_cpu, cpu, -1))
+			return;
 
+		pending = xchg(&printk_pending, 0);
 		if (test_bit(PRINTK_PENDING_OUTPUT, &pending)) {
+			bool more_work = true;
+
 			if (console_trylock())
-				console_unlock();
-			else
-				/* Try again later */
+				more_work = __console_unlock();
+			if (more_work)
 				set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 		}
 		if (test_bit(PRINTK_PENDING_WAKEUP, &pending))
@@ -2051,33 +2065,46 @@ out:
 }
 
 /**
- * console_unlock - unlock the console system
+ * __console_unlock - unlock the console system
  *
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. Function returns true, if there's more
+ * data that needs printing in the buffer.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
- * console_unlock(); may be called from any context.
+ * __console_unlock() may be called from any context.
  */
-void console_unlock(void)
+static bool __console_unlock(void)
 {
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	u64 end_time, now;
+	int cur_cpu;
 
 	if (console_suspended) {
 		up(&console_sem);
-		return;
+		return false;
 	}
 
 	console_may_schedule = 0;
+	preempt_disable();
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = cpu_clock(cur_cpu) +
+				max_interrupt_disabled_duration() / 2;
+	preempt_enable();
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2100,7 +2127,9 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq ||
+		    (now > end_time && !oops_in_progress))
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2143,6 +2172,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
+	last_printing_cpu = cur_cpu;
 	up(&console_sem);
 
 	/*
@@ -2155,11 +2185,25 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
+	if (retry && (now <= end_time || oops_in_progress) &&
+	    console_trylock())
 		goto again;
 
 	if (wake_klogd)
 		wake_up_klogd();
+	return retry;
+}
+
+/*
+ * This is a wrapper against __console_unlock() that makes sure the rest of
+ * buffer is printed in future.
+ */
+void console_unlock(void)
+{
+	if (__console_unlock()) {
+		/* Leave the rest of printing for a timer tick */
+		set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
+	}
 }
 EXPORT_SYMBOL(console_unlock);
 
-- 
1.7.1


--zhXaljGHf11kAtnf--
