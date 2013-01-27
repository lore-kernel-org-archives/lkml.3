Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3A0Ohj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:37:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3A0Ohg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:37:36 -0500
Date: Sun, 27 Jan 2013 06:37:00 -0800
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-62188451f0d63add7ad0cd2a1ae269d600c1663d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com, sgruszka@redhat.com
In-Reply-To: <1359217182-25184-1-git-send-email-fweisbec@gmail.com>
References: <1359217182-25184-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cputime:
  Avoid multiplication overflow on utime scaling
Git-Commit-ID: 62188451f0d63add7ad0cd2a1ae269d600c1663d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 06:37:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62188451f0d63add7ad0cd2a1ae269d600c1663d
Gitweb:     http://git.kernel.org/tip/62188451f0d63add7ad0cd2a1ae269d600c1663d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 26 Jan 2013 17:19:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 27 Jan 2013 14:04:44 +0100

cputime: Avoid multiplication overflow on utime scaling

We scale stime, utime values based on rtime (sum_exec_runtime
converted to jiffies). During scaling we multiple rtime * utime,
which seems to be fine, since both values are converted to u64,
but it's not.

Let assume HZ is 1000 - 1ms tick. Process consist of 64 threads,
run for 1 day, threads utilize 100% cpu on user space. Machine
has 64 cpus.

Process rtime = utime will be 64 * 24 * 60 * 60 * 1000 jiffies,
which is 0x149970000. Multiplication rtime * utime result is
0x1a855771100000000, which can not be covered in 64 bits.

Result of overflow is stall of utime values visible in user
space (prev_utime in kernel), even if application still consume
lot of CPU time.

A solution to solve this is to perform the multiplication on
stime instead of utime. It's easy to grow the utime value fast
with a CPU bound thread in userspace for example. Now we assume
that doing so with stime is much harder. In most cases a task
shouldn't ever spend much time in kernel space as it tends to
sleep waiting for jobs completion when they take long to
achieve. IO is the typical example of that.

Hence scaling the cputime by performing the multiplication on
stime instead of utime should considerably reduce the chances of
an overflow on most workloads.

This is largely inspired by a patch from Stanislaw Gruszka:
http://lkml.kernel.org/r/20130107113144.GA7544@redhat.com

Inspired-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1359217182-25184-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

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
