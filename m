Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3GAMeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:34:16 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:60780 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab3GAMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:34:15 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Lei Wen <leiwen@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [V2 1/2] sched: add trace events for task and rq usage tracking
Date: Mon, 1 Jul 2013 20:33:21 +0800
Message-ID: <1372682002-15373-2-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372682002-15373-1-git-send-email-leiwen@marvell.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
 <1372682002-15373-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we could track task in the entity level now, we may want to
investigate tasks' running status by recording the trace info, so that
could make some tuning if needed.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 include/trace/events/sched.h |   57 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |   29 +++++++++++++++++++--
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e5586ca..effe047 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -430,6 +430,63 @@ TRACE_EVENT(sched_pi_setprio,
 			__entry->oldprio, __entry->newprio)
 );
 
+TRACE_EVENT(sched_task_weighted_load,
+
+	TP_PROTO(struct task_struct *tsk, unsigned long load, unsigned long weight),
+
+	TP_ARGS(tsk, load, weight),
+
+	TP_STRUCT__entry(
+		__field(pid_t, pid)
+		__field(int, cpu)
+		__field(unsigned long, load)
+		__field(unsigned long, weight)
+	),
+
+	TP_fast_assign(
+		__entry->pid   = tsk->pid;
+		__entry->cpu   = task_thread_info(tsk)->cpu;
+		__entry->load  = load;
+		__entry->weight= weight;
+	),
+
+	TP_printk("cpu=%d pid=%d load=%lu weight=%lu",
+			__entry->cpu, __entry->pid,
+			__entry->load, __entry->weight)
+);
+
+DECLARE_EVENT_CLASS(sched_cfs_rq_load_contri_template,
+
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+
+	TP_ARGS(cpu, load, total),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+		__field(unsigned long, load)
+		__field(unsigned long, total)
+	),
+
+	TP_fast_assign(
+		__entry->cpu   = cpu;
+		__entry->load  = load;
+		__entry->total = total;
+	),
+
+	TP_printk("cpu=%d avg=%lu total=%lu",
+		__entry->cpu,
+		__entry->load,
+		__entry->total)
+	);
+
+DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_runnable_load,
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+	TP_ARGS(cpu, load, total));
+
+DEFINE_EVENT(sched_cfs_rq_load_contri_template, sched_cfs_rq_blocked_load,
+	TP_PROTO(int cpu, unsigned long load, unsigned long total),
+	TP_ARGS(cpu, load, total));
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f77f9c5..07bd74c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1346,6 +1346,7 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);
 	se->avg.decay_count = 0;
 
 	return decays;
@@ -1445,6 +1446,7 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+	trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
@@ -1498,10 +1500,16 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	if (!update_cfs_rq)
 		return;
 
-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
-	else
+		trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->runnable_load_avg, cfs_rq->load.weight);
+	} else {
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->blocked_load_avg,
+				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
+	}
 }
 
 /*
@@ -1531,6 +1539,9 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	}
 
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+			cfs_rq->blocked_load_avg,
+			cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1584,10 +1595,15 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	/* migrated tasks did not contribute to our blocked load */
 	if (wakeup) {
 		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->blocked_load_avg,
+				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
 		update_entity_load_avg(se, 0);
 	}
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
+			cfs_rq->runnable_load_avg, cfs_rq->load.weight);
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -1608,6 +1624,9 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->blocked_load_avg,
+				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
@@ -5894,6 +5913,9 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		__synchronize_entity_decay(&p->se);
 		subtract_blocked_load_contrib(cfs_rq,
 				p->se.avg.load_avg_contrib);
+		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->blocked_load_avg,
+				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
 	}
 #endif
 }
@@ -5994,6 +6016,9 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 		 */
 		p->se.avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 		cfs_rq->blocked_load_avg += p->se.avg.load_avg_contrib;
+		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
+				cfs_rq->blocked_load_avg,
+				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
 #endif
 	}
 }
-- 
1.7.10.4

