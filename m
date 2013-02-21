Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3BURnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:43:21 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:41126 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3BURnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:43:17 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH] sched: Lower chances of cputime scaling overflow
Date: Thu, 21 Feb 2013 18:43:09 +0100
Message-Id: <1361468589-15857-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users have reported that after running a process with
hundreds of threads on intensive CPU-bound loads, the cputime
of the group started to freeze after a few days.

This is due to how we scale the tick-based cputime against
the scheduler precise execution time value.

We add the values of all threads in the group and we multiply
that against the sum of the scheduler exec runtime of the whole
group.

This easily overflows after a few days/weeks of execution.

A proposed solution to solve this was to compute that multiplication
on stime instead of utime:
   62188451f0d63add7ad0cd2a1ae269d600c1663d
   ("cputime: Avoid multiplication overflow on utime scaling")

The rationale behind that was that it's easy for a thread to
spend most of its time in userspace under intensive CPU-bound workload
but it's much harder to do CPU-bound intensive long run in the kernel.

This postulate got defeated when a user recently reported he was still
seeing cputime freezes after the above patch. The workload that
triggers this issue relates to intensive networking workloads where
most of the cputime is consumed in the kernel.

So now I'm trying to find a solution that works for everyone. The below
proposition tries some trickier maths to perform the cputime scaling.
It should reduce much more the opportunities for multiplication overflow
by reducing the multiplication factors to the remainders of the division
between sched exec runtime and cputime. Assuming the difference between
these shouldn't ever be that large, it could be a viable solution.

This gets the same results as in the upstream scaling code except for
a few cases where the scaled result is one unit off compared to upstream
results. So there must be some rounding tweak to apply somewhere.
This happens when rtime < stime + utime and (stime + utime) % rtime
is non-zero. I just scratched my head too much on this for now so I hope
somebody can come up with an idea. I suck ten juggling balls in maths...

If this solution appears not to be viable in the end, I fear we'll
need to partly revert back to the behaviour prior to commit
     0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
     ("sched, cputime: Introduce thread_group_times()")

Back then, the scaling was done on exit() time before adding the cputime
of an exiting thread to the signal struct. And then we'll need to
scale one-by-one the live threads cputime in thread_group_cputime(). The
drawback may be a slightly slower code.

Tell me your opinion.

Not-Yet-Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/math64.h |   10 ++++++++++
 kernel/sched/cputime.c |   31 +++++++++++++++++++------------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..c0ad184 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -38,6 +38,16 @@ static inline u64 div64_u64(u64 dividend, u64 divisor)
 }
 
 /**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor
+ */
+static inline u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+{
+	/* TODO: implement 32 bit version in lib/div64.c */
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
  * div64_s64 - signed 64bit divide with 64bit divisor
  */
 static inline s64 div64_s64(s64 dividend, s64 divisor)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9857329..6d3f9e4 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -521,18 +521,21 @@ EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
-static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
+static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 {
-	u64 temp = (__force u64) rtime;
+	u64 rem, res, scaled;
 
-	temp *= (__force u64) stime;
-
-	if (sizeof(cputime_t) == 4)
-		temp = div_u64(temp, (__force u32) total);
-	else
-		temp = div64_u64(temp, (__force u64) total);
+	if (rtime >= total) {
+		res = div64_u64_rem(rtime, total, &rem);
+		scaled = stime * res;
+		scaled += div64_u64(stime * rem, total);
+	} else {
+		res = div64_u64_rem(total, rtime, &rem);
+		scaled = div64_u64(stime, res);
+		scaled -= div64_u64(scaled * rem, total);
+	}
 
-	return (__force cputime_t) temp;
+	return (__force cputime_t) scaled;
 }
 
 /*
@@ -560,10 +563,14 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
-	if (total)
-		stime = scale_stime(stime, rtime, total);
-	else
+	if (!rtime) {
+		stime = 0;
+	} else if (!total) {
 		stime = rtime;
+	} else {
+		stime = scale_stime((__force u64)stime,
+				    (__force u64)rtime, (__force u64)total);
+	}
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
-- 
1.7.5.4

