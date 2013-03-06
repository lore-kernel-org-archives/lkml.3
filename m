Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3CFQHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:07:34 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47639 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3CFQH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:07:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] sched: Lower chances of cputime scaling overflow
Date: Wed,  6 Mar 2013 17:06:55 +0100
Message-Id: <1362586015-27951-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
References: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
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

To reduce much more the opportunities for multiplication overflow,
lets reduce the multiplication factors to the remainders of the division
between sched exec runtime and cputime. Assuming the difference between
these shouldn't ever be that large, it could work on many situations.

This gets the same results as in the upstream scaling code except for
a small difference: the upstream code always rounds the results to
the nearest integer not greater to what would be the precise result.
The new code rounds to the nearest integer either greater or not
greater. In practice this difference probably shouldn't matter but
it's worth mentioning.

If this solution appears not to be enough in the end, we'll
need to partly revert back to the behaviour prior to commit
     0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
     ("sched, cputime: Introduce thread_group_times()")

Back then, the scaling was done on exit() time before adding the cputime
of an exiting thread to the signal struct. And then we'll need to
scale one-by-one the live threads cputime in thread_group_cputime(). The
drawback may be a slightly slower code on exit time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sched/cputime.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..7272b87 100644
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

