Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaE3OoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:44:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:55008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964809AbaE3OlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548946914"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 05/16 v3] Update CPU CC in fair
Date: Fri, 30 May 2014 14:36:01 +0800
Message-Id: <1401431772-14320-6-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC can only be modified when enqueue and dequeue the CPU rq. We also
update it in scheduler tick, load balancing, and idle enter/exit
in case we may not have enqueue and dequeue for a long time.

Therefore, we update/track CC in and only in these points:

we update cpu concurrency at:
1) enqueue task, which increases concurrency
2) dequeue task, which decreases concurrency
3) periodic scheduler tick, in case no en/dequeue for long
4) enter and exit idle
5) update_blocked_averages

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f7910cf..96d6f64 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2558,6 +2558,7 @@ static inline void update_cpu_concurrency(struct rq *rq);
  */
 void idle_enter_fair(struct rq *this_rq)
 {
+	update_cpu_concurrency(this_rq);
 }
 
 /*
@@ -2567,6 +2568,7 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
+	update_cpu_concurrency(this_rq);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -3877,8 +3879,10 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se)
+	if (!se) {
 		inc_nr_running(rq);
+		update_cpu_concurrency(rq);
+	}
 
 	hrtick_update(rq);
 }
@@ -3937,8 +3941,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se)
+	if (!se) {
 		dec_nr_running(rq);
+		update_cpu_concurrency(rq);
+	}
 
 	hrtick_update(rq);
 }
@@ -5381,6 +5387,8 @@ static void update_blocked_averages(int cpu)
 		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 	}
 
+	update_cpu_concurrency(rq);
+
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -7233,6 +7241,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
+
+	update_cpu_concurrency(rq);
 }
 
 /*
-- 
1.7.9.5

