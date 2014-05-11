Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbaELCWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:22:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:8842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbaELCWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="530200701"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 04/12 v2] CPU ConCurrency tracking
Date: Mon, 12 May 2014 02:16:53 +0800
Message-Id: <1399832221-8314-5-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC can only be modified when enqueue and dequeue the CPU rq. And we also
track it in scheduler tick and idle enter/exit in case we may not have
enqueue and dequeue for a long time.

Therefore, we track CC in and only in these four points:

1. dequeue
2. enqueue
3. scheduler tick
4. idle enter and exit

TODO: use existing load tracking framework

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/core.c |    3 +++
 kernel/sched/fair.c |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7958a47..0236455 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -767,6 +767,7 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_queued(rq, p);
 	p->sched_class->enqueue_task(rq, p, flags);
+	update_cpu_concurrency(rq);
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -774,6 +775,7 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_dequeued(rq, p);
 	p->sched_class->dequeue_task(rq, p, flags);
+	update_cpu_concurrency(rq);
 }
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
@@ -2428,6 +2430,7 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	update_cpu_load_active(rq);
+	update_cpu_concurrency(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..e7153ff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2563,6 +2563,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 void idle_enter_fair(struct rq *this_rq)
 {
 	update_rq_runnable_avg(this_rq, 1);
+	update_cpu_concurrency(this_rq);
 }
 
 /*
@@ -2573,6 +2574,7 @@ void idle_enter_fair(struct rq *this_rq)
 void idle_exit_fair(struct rq *this_rq)
 {
 	update_rq_runnable_avg(this_rq, 0);
+	update_cpu_concurrency(this_rq);
 }
 
 static int idle_balance(struct rq *this_rq);
-- 
1.7.9.5

