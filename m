Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3AZQTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 11:19:54 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:64608 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3AZQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 11:19:52 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] cputime: Avoid multiplication overflow on utime scaling
Date: Sat, 26 Jan 2013 17:19:42 +0100
Message-Id: <1359217182-25184-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We scale stime, utime values based on rtime (sum_exec_runtime converted
to jiffies). During scaling we multiple rtime * utime, which seems to be
fine, since both values are converted to u64, but it's not.

Let assume HZ is 1000 - 1ms tick. Process consist of 64 threads, run
for 1 day, threads utilize 100% cpu on user space. Machine has 64 cpus.

Process rtime = utime will be 64 * 24 * 60 * 60 * 1000 jiffies, which is
0x149970000. Multiplication rtime * utime result is 0x1a855771100000000,
which can not be covered in 64 bits.

Result of overflow is stall of utime values visible in user space
(prev_utime in kernel), even if application still consume lot of CPU
time.

A solution to solve this is to perform the multiplication on stime
instead of utime. It's easy to grow the utime value fast with a CPU
bound thread in userspace for example. Now we assume that doing so with
stime is much harder. In most cases a task shouldn't ever spend much
time in kernel space as it tends to sleep waiting for jobs completion
when they take long to achieve. IO is the typical example of that.

Hence scaling the cputime by performing the multiplication on stime
instead of utime should considerably reduce the chances of an overflow
on most workloads.

This is largely inspired by a patch from Stanislaw Gruszka:
http://lkml.kernel.org/r/20130107113144.GA7544@redhat.com

Inspired-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/cputime.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..825a956 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -509,11 +509,11 @@ EXPORT_SYMBOL_GPL(vtime_account);
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
-static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
 {
 	u64 temp = (__force u64) rtime;
 
-	temp *= (__force u64) utime;
+	temp *= (__force u64) stime;
 
 	if (sizeof(cputime_t) == 4)
 		temp = div_u64(temp, (__force u32) total);
@@ -531,10 +531,10 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime, total;
+	cputime_t rtime, stime, total;
 
-	utime = curr->utime;
-	total = utime + curr->stime;
+	stime = curr->stime;
+	total = stime + curr->utime;
 
 	/*
 	 * Tick based cputime accounting depend on random scheduling
@@ -549,17 +549,17 @@ static void cputime_adjust(struct task_cputime *curr,
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
 	if (total)
-		utime = scale_utime(utime, rtime, total);
+		stime = scale_stime(stime, rtime, total);
 	else
-		utime = rtime;
+		stime = rtime;
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
 	 */
-	prev->utime = max(prev->utime, utime);
-	prev->stime = max(prev->stime, rtime - prev->utime);
+	prev->stime = max(prev->stime, stime);
+	prev->utime = max(prev->utime, rtime - prev->stime);
 
 	*ut = prev->utime;
 	*st = prev->stime;
-- 
1.7.5.4

