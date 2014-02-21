Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbaBUNPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:15:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaBUNCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ying Xue <ying.xue@windriver.com>, Fan Du <fan.du@windriver.com>,
        <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 18/60] sched/rt: Avoid updating RT entry timeout twice within one tick period
Date: Fri, 21 Feb 2014 13:00:45 +0000
Message-Id: <1392987687-15367-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

commit 57d2aa00dcec67afa52478730f2b524521af14fb upstream.

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
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/sched.h | 1 +
 kernel/sched/rt.c     | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index be28098..c980fa7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1203,6 +1203,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
+	unsigned long watchdog_stamp;
 	unsigned int time_slice;
 
 	struct sched_rt_entity *back;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ad4787b..6b46fb1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2004,7 +2004,11 @@ static void watchdog(struct rq *rq, struct task_struct *p)
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
-- 
1.9.0

