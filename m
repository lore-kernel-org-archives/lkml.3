Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaFPJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:16:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47544 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:16:55 -0400
Message-ID: <1402910212.16584.4.camel@marge.simpson.net>
Subject: [patch] sched: Fix clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID)
 monotonicity
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 16 Jun 2014 11:16:52 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(disregard patch of same name from that enterprise weenie;)

If a task has been dequeued, it has been accounted.  Do not project
cycles that may or may not ever be accounted to a dequeued task, as
that may make clock_gettime() both inaccurate and non-monotonic.

Protect update_rq_clock() from slight TSC skew while at it.

Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
---
 kernel/sched/core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -144,6 +144,8 @@ void update_rq_clock(struct rq *rq)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	if (delta < 0)
+		return;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
 }
@@ -2533,7 +2535,12 @@ static u64 do_task_delta_exec(struct tas
 {
 	u64 ns = 0;
 
-	if (task_current(rq, p)) {
+	/*
+	 * Must be ->curr, ->on_cpu _and_ ->on_rq.  If dequeued, we
+	 * would project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && p->on_cpu && p->on_rq) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2576,8 +2583,10 @@ unsigned long long task_sched_runtime(st
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
 


