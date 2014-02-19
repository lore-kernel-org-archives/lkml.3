Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaBSWQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:16:07 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:33044 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaBSWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:16:04 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC] sched/deadline: Prevent rt_time growth to infinity
MIME-Version: 1.0
Message-Id: <230991392848160@web13m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 20 Feb 2014 02:16:00 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since deadline tasks share rt bandwidth, we must care about
bandwidth timer set. Otherwise rt_time may grow up to infinity
in update_curr_dl(), if there are no other available RT tasks
on top level bandwidth.

I'm going to decide the problem the way below. Almost untested
because of I skipped almost all of recent patches which haveto be applied from lkml.

Please say, if I skipped anything in idea. Maybe better put
start_top_rt_bandwidth() into set_curr_task_dl()?

---
 kernel/sched/deadline.c |  1 +
 kernel/sched/rt.c       | 16 +++++++++++++++-
 kernel/sched/sched.h    |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ed31ef6..f1d2304 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -720,6 +720,7 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 
 	inc_dl_deadline(dl_rq, deadline);
 	inc_dl_migration(dl_se, dl_rq);
+	start_top_rt_bandwidth(rq_of_dl_rq(dl_rq));
 }
 
 static inline
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 72f9ec7..a187eb8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -726,7 +726,7 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
-	int i, idle = 1, throttled = 0;
+	int i, idle = 1, throttled = 0, has_dl_tasks = 0;
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
@@ -781,9 +781,15 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
+
+		if (rt_rq == &rq->rt && rq->dl.dl_nr_running)
+			has_dl_tasks = 1;
 		raw_spin_unlock(&rq->lock);
 	}
 
+	if (has_dl_tasks)
+		return 0;
+
 	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
 		return 1;
 
@@ -1005,6 +1011,10 @@ dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
 }
 
+void start_top_rt_bandwidth(struct rq *rq)
+{
+	start_rt_bandwidth(&rq->rt.tg->rt_bandwidth);
+}
 #else /* CONFIG_RT_GROUP_SCHED */
 
 static void
@@ -1016,6 +1026,10 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 static inline
 void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
 
+void start_top_rt_bandwidth(struct rq *rq)
+{
+	start_rt_bandwidth(&def_rt_bandwidth);
+}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static inline
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c2..a20f8f7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1294,6 +1294,7 @@ static inline void sched_avg_update(struct rq *rq) { }
 #endif
 
 extern void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period);
+extern void start_top_rt_bandwidth(struct rq *rq);
 
 #ifdef CONFIG_SMP
 #ifdef CONFIG_PREEMPT
