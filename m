Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246AbaGEKoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:44:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179AbaGEKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:44:34 -0400
Date: Sat, 5 Jul 2014 03:43:44 -0700
From: tip-bot for Mike Galbraith <tipbot@zytor.com>
Message-ID: <tip-4036ac1567834222fc763ab18e3e17df93b4eaaf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, umgwanakikbuti@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, umgwanakikbuti@gmail.com
In-Reply-To: <1403588980.29711.11.camel@marge.simpson.net>
References: <1403588980.29711.11.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix clock_gettime(CLOCK_[PROCESS/THREAD]
 _CPUTIME_ID) monotonicity
Git-Commit-ID: 4036ac1567834222fc763ab18e3e17df93b4eaaf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4036ac1567834222fc763ab18e3e17df93b4eaaf
Gitweb:     http://git.kernel.org/tip/4036ac1567834222fc763ab18e3e17df93b4eaaf
Author:     Mike Galbraith <umgwanakikbuti@gmail.com>
AuthorDate: Tue, 24 Jun 2014 07:49:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:30 +0200

sched: Fix clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity

If a task has been dequeued, it has been accounted.  Do not project
cycles that may or may not ever be accounted to a dequeued task, as
that may make clock_gettime() both inaccurate and non-monotonic.

Protect update_rq_clock() from slight TSC skew while at it.

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: kosaki.motohiro@jp.fujitsu.com
Cc: pjt@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403588980.29711.11.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 866d840..e50234b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -139,6 +139,8 @@ void update_rq_clock(struct rq *rq)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	if (delta < 0)
+		return;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
 }
@@ -2431,7 +2433,12 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 {
 	u64 ns = 0;
 
-	if (task_current(rq, p)) {
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && p->on_rq) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2474,8 +2481,10 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
 	 * If we race with it entering cpu, unaccounted time is 0. This is
 	 * indistinguishable from the read occurring a few cycles earlier.
+	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
+	 * been accounted, so we're correct here as well.
 	 */
-	if (!p->on_cpu)
+	if (!p->on_cpu || !p->on_rq)
 		return p->se.sum_exec_runtime;
 #endif
 
