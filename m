Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaGPVHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:07:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:59914 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaGPVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:20 -0400
Message-Id: <20140716205057.302769279@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch V2 60/64] timekeeping: Use tk_read_base as argument for
 timekeeping_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-change-get-ns-arg-to-tkr.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the function needs is in the tk_read_base struct. No functional
change for the current code, just a preparatory patch for the NMI safe
accessor to clock monotonic which will use struct tk_read_base as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/time/timekeeping.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -173,19 +173,19 @@ u32 (*arch_gettimeoffset)(void) = defaul
 static inline u32 arch_gettimeoffset(void) { return 0; }
 #endif
 
-static inline s64 timekeeping_get_ns(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 {
 	cycle_t cycle_now, delta;
 	s64 nsec;
 
 	/* read clocksource: */
-	cycle_now = tk->tkr.read(tk->tkr.clock);
+	cycle_now = tkr->read(tkr->clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
+	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
 
-	nsec = delta * tk->tkr.mult + tk->tkr.xtime_nsec;
-	nsec >>= tk->tkr.shift;
+	nsec = delta * tkr->mult + tkr->xtime_nsec;
+	nsec >>= tkr->shift;
 
 	/* If arch requires, add in get_arch_timeoffset() */
 	return nsec + arch_gettimeoffset();
@@ -372,7 +372,7 @@ int __getnstimeofday64(struct timespec64
 		seq = read_seqcount_begin(&tk_core.seq);
 
 		ts->tv_sec = tk->xtime_sec;
-		nsecs = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -413,7 +413,7 @@ ktime_t ktime_get(void)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		base = tk->tkr.base_mono;
-		nsecs = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -439,7 +439,7 @@ ktime_t ktime_get_with_offset(enum tk_of
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		base = ktime_add(tk->tkr.base_mono, *offset);
-		nsecs = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -509,7 +509,7 @@ void ktime_get_ts64(struct timespec64 *t
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		ts->tv_sec = tk->xtime_sec;
-		nsec = timekeeping_get_ns(tk);
+		nsec = timekeeping_get_ns(&tk->tkr);
 		tomono = tk->wall_to_monotonic;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
@@ -547,7 +547,7 @@ void getnstime_raw_and_real(struct times
 		ts_real->tv_nsec = 0;
 
 		nsecs_raw = timekeeping_get_ns_raw(tk);
-		nsecs_real = timekeeping_get_ns(tk);
+		nsecs_real = timekeeping_get_ns(&tk->tkr);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -1624,7 +1624,7 @@ ktime_t ktime_get_update_offsets_now(kti
 		seq = read_seqcount_begin(&tk_core.seq);
 
 		base = tk->tkr.base_mono;
-		nsecs = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;


