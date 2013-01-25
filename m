Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3AYKjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:39:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3AYKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:39:45 -0500
Date: Fri, 25 Jan 2013 02:39:06 -0800
From: tip-bot for Ying Xue <ying.xue@windriver.com>
Message-ID: <tip-57d2aa00dcec67afa52478730f2b524521af14fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, fan.du@windriver.com, ying.xue@windriver.com,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fan.du@windriver.com, ying.xue@windriver.com,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com
In-Reply-To: <1342508623-2887-1-git-send-email-ying.xue@windriver.com>
References: <1342508623-2887-1-git-send-email-ying.xue@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Avoid updating RT entry timeout twice within one tick period
Git-Commit-ID: 57d2aa00dcec67afa52478730f2b524521af14fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:39:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57d2aa00dcec67afa52478730f2b524521af14fb
Gitweb:     http://git.kernel.org/tip/57d2aa00dcec67afa52478730f2b524521af14fb
Author:     Ying Xue <ying.xue@windriver.com>
AuthorDate: Tue, 17 Jul 2012 15:03:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 08:31:54 +0100

sched/rt: Avoid updating RT entry timeout twice within one tick period

The issue below was found in 2.6.34-rt rather than mainline rt
kernel, but the issue still exists upstream as well.

So please let me describe how it was noticed on 2.6.34-rt:

On this version, each softirq has its own thread, it means there
is at least one RT FIFO task per cpu. The priority of these
tasks is set to 49 by default. If user launches an RT FIFO task
with priority lower than 49 of softirq RT tasks, it's possible
there are two RT FIFO tasks enqueued one cpu runqueue at one
moment. By current strategy of balancing RT tasks, when it comes
to RT tasks, we really need to put them off to a CPU that they
can run on as soon as possible. Even if it means a bit of cache
line flushing, we want RT tasks to be run with the least latency.

When the user RT FIFO task which just launched before is
running, the sched timer tick of the current cpu happens. In this
tick period, the timeout value of the user RT task will be
updated once. Subsequently, we try to wake up one softirq RT
task on its local cpu. As the priority of current user RT task
is lower than the softirq RT task, the current task will be
preempted by the higher priority softirq RT task. Before
preemption, we check to see if current can readily move to a
different cpu. If so, we will reschedule to allow the RT push logic
to try to move current somewhere else. Whenever the woken
softirq RT task runs, it first tries to migrate the user FIFO RT
task over to a cpu that is running a task of lesser priority. If
migration is done, it will send a reschedule request to the found
cpu by IPI interrupt. Once the target cpu responds the IPI
interrupt, it will pick the migrated user RT task to preempt its
current task. When the user RT task is running on the new cpu,
the sched timer tick of the cpu fires. So it will tick the user
RT task again. This also means the RT task timeout value will be
updated again. As the migration may be done in one tick period,
it means the user RT task timeout value will be updated twice
within one tick.

If we set a limit on the amount of cpu time for the user RT task
by setrlimit(RLIMIT_RTTIME), the SIGXCPU signal should be posted
upon reaching the soft limit.

But exactly when the SIGXCPU signal should be sent depends on the
RT task timeout value. In fact the timeout mechanism of sending
the SIGXCPU signal assumes the RT task timeout is increased once
every tick.

However, currently the timeout value may be added twice per
tick. So it results in the SIGXCPU signal being sent earlier
than expected.

To solve this issue, we prevent the timeout value from increasing
twice within one tick time by remembering the jiffies value of
last updating the timeout. As long as the RT task's jiffies is
different with the global jiffies value, we allow its timeout to
be updated.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Fan Du <fan.du@windriver.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342508623-2887-1-git-send-email-ying.xue@windriver.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 1 +
 kernel/sched/rt.c     | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..924e42a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1208,6 +1208,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
+	unsigned long watchdog_stamp;
 	unsigned int time_slice;
 
 	struct sched_rt_entity *back;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 29bda5b..2f69ca9 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1988,7 +1988,11 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
 
-		p->rt.timeout++;
+		if (p->rt.watchdog_stamp != jiffies) {
+			p->rt.timeout++;
+			p->rt.watchdog_stamp = jiffies;
+		}
+
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
 			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
