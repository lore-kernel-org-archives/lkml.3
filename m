Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaB0Ncr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:32:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaB0Ncn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:32:43 -0500
Date: Thu, 27 Feb 2014 05:32:07 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-faa5993736d9b44b508cab4f1f3a77d66641c6f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tkhai@yandex.ru,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, tkhai@yandex.ru,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <20140225151515.617714e2f2cd6c558531ba61@gmail.com>
References: <20140225151515.617714e2f2cd6c558531ba61@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline:
  Prevent rt_time growth to infinity
Git-Commit-ID: faa5993736d9b44b508cab4f1f3a77d66641c6f4
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

Commit-ID:  faa5993736d9b44b508cab4f1f3a77d66641c6f4
Gitweb:     http://git.kernel.org/tip/faa5993736d9b44b508cab4f1f3a77d66641c6f4
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Fri, 21 Feb 2014 11:37:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:29:41 +0100

sched/deadline: Prevent rt_time growth to infinity

Kirill Tkhai noted:

  Since deadline tasks share rt bandwidth, we must care about
  bandwidth timer set. Otherwise rt_time may grow up to infinity
  in update_curr_dl(), if there are no other available RT tasks
  on top level bandwidth.

RT task were in fact throttled right after they got enqueued,
and never executed again (rt_time never again went below rt_runtime).

Peter then proposed to accrue DL execution on rt_time only when
rt timer is active, and proposed a patch (this patch is a slight
modification of that) to implement that behavior. While this
solves Kirill problem, it has a drawback.

Indeed, Kirill noted again:

  It looks we may get into a situation, when all CPU time is shared
  between RT and DL tasks:

  rt_runtime = n
  rt_period  = 2n

  | RT working, DL sleeping  | DL working, RT sleeping      |
  -----------------------------------------------------------
  | (1)     duration = n     | (2)     duration = n         | (repeat)
  |--------------------------|------------------------------|
  | (rt_bw timer is running) | (rt_bw timer is not running) |

  No time for fair tasks at all.

While this can happen during the first period, if rq is always backlogged,
RT tasks won't have the opportunity to execute anymore: rt_time reached
rt_runtime during (1), suppose after (2) RT is enqueued back, it gets
throttled since rt timer didn't fire, replenishment is from now on eaten up
by DL tasks that accrue their execution on rt_time (while rt timer is
active - we have an RT task waiting for replenishment). FAIR tasks are
not touched after this first period. Ok, this is not ideal, and the situation
is even worse!

What above (the nice case), practically never happens in reality, where
your rt timer is not aligned to tasks periods, tasks are in general not
periodic, etc.. Long story short, you always risk to overload your system.

This patch is based on Peter's idea, but exploits an additional fact:
if you don't have RT tasks enqueued, it makes little sense to continue
incrementing rt_time once you reached the upper limit (DL tasks have their
own mechanism for throttling).

This cures both problems:

 - no matter how many DL instances in the past, you'll have an rt_time
   slightly above rt_runtime when an RT task is enqueued, and from that
   point on (after the first replenishment), the task will normally execute;

 - you can still eat up all bandwidth during the first period, but not
   anymore after that, remember that DL execution will increment rt_time
   till the upper limit is reached.

The situation is still not perfect! But, we have a simple solution for now,
that limits how much you can jeopardize your system, as we keep working
towards the right answer: RT groups scheduled using deadline servers.

Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140225151515.617714e2f2cd6c558531ba61@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 8 ++++++--
 kernel/sched/rt.c       | 8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aecf930..6e79b3f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -562,6 +562,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 	return 1;
 }
 
+extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
+
 /*
  * Update the current task's runtime statistics (provided it is still
  * a -deadline task and has not been removed from the dl_rq).
@@ -625,11 +627,13 @@ static void update_curr_dl(struct rq *rq)
 		struct rt_rq *rt_rq = &rq->rt;
 
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
 		/*
 		 * We'll let actual RT tasks worry about the overflow here, we
-		 * have our own CBS to keep us inline -- see above.
+		 * have our own CBS to keep us inline; only account when RT
+		 * bandwidth is relevant.
 		 */
+		if (sched_rt_bandwidth_account(rt_rq))
+			rt_rq->rt_time += delta_exec;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a2740b7..1999021 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -538,6 +538,14 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+	return (hrtimer_active(&rt_b->rt_period_timer) ||
+		rt_rq->rt_time < rt_b->rt_runtime);
+}
+
 #ifdef CONFIG_SMP
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
