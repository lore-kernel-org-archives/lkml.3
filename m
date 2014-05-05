Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaEEUsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:48:12 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63562 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaEEUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:48:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Date: Mon,  5 May 2014 13:47:44 -0700
Message-Id: <1399322864-22861-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
References: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Bohac pointed out that there are rare but potential deadlock
possibilities when calling printk while holding the timekeeping
seqlock.

This is due to printk() triggering console sem wakeup, which can
cause scheduling code to trigger hrtimers which may try to read
the time.

Specifically, as Jiri pointed out, that path is:
  printk
    vprintk_emit
      console_unlock
        up(&console_sem)
          __up
	    wake_up_process
	      try_to_wake_up
	        ttwu_do_activate
		  ttwu_activate
		    activate_task
		      enqueue_task
		        enqueue_task_fair
			  hrtick_update
			    hrtick_start_fair
			      hrtick_start_fair
			        get_time
				  ktime_get
				    --> endless loop on
				    read_seqcount_retry(&timekeeper_seq, ...)

This patch tries to avoid this issue by using printk_deferred (previously
named printk_sched) which should defer printing via a irq_work_queue.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Jiri Bohac <jbohac@suse.cz>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c         | 15 +++++++++------
 kernel/time/timekeeping.c |  7 ++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 419a52c..5b0ac4d 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -786,8 +786,9 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 		time_status |= STA_PPSERROR;
 		pps_errcnt++;
 		pps_dec_freq_interval();
-		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
-				freq_norm.sec);
+		printk_deferred(KERN_ERR
+			"hardpps: PPSERROR: interval too long - %ld s\n",
+			freq_norm.sec);
 		return 0;
 	}
 
@@ -800,7 +801,8 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
 	pps_freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
-		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
+		printk_deferred(KERN_WARNING
+				"hardpps: PPSWANDER: change=%ld\n", delta);
 		time_status |= STA_PPSWANDER;
 		pps_stbcnt++;
 		pps_dec_freq_interval();
@@ -844,8 +846,9 @@ static void hardpps_update_phase(long error)
 	 * the time offset is updated.
 	 */
 	if (jitter > (pps_jitter << PPS_POPCORN)) {
-		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (pps_jitter << PPS_POPCORN));
+		printk_deferred(KERN_WARNING
+				"hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
+				jitter, (pps_jitter << PPS_POPCORN));
 		time_status |= STA_PPSJITTER;
 		pps_jitcnt++;
 	} else if (time_status & STA_PPSTIME) {
@@ -902,7 +905,7 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		pr_err("hardpps: PPSJITTER: bad pulse\n");
+		printk_deferred(KERN_ERR "hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7df8ea..32d8d6a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -852,8 +852,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 							struct timespec *delta)
 {
 	if (!timespec_valid_strict(delta)) {
-		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
-					"sleep delta value!\n");
+		printk_deferred(KERN_WARNING
+				"__timekeeping_inject_sleeptime: Invalid "
+				"sleep delta value!\n");
 		return;
 	}
 	tk_xtime_add(tk, delta);
@@ -1157,7 +1158,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 
 	if (unlikely(tk->clock->maxadj &&
 		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
-		printk_once(KERN_WARNING
+		printk_deferred_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			tk->clock->name, (long)tk->mult + adj,
 			(long)tk->clock->mult + tk->clock->maxadj);
-- 
1.9.1

