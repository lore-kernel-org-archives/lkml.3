Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbaE3Ok6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:40:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:29655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461AbaE3Ok4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:40:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548946775"
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
Subject: [RFC PATCH 02/16 v3] Define and initialize CPU ConCurrency in struct rq
Date: Fri, 30 May 2014 14:35:58 +0800
Message-Id: <1401431772-14320-3-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This struct is in CPU's rq and updated with rq->lock held.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |   18 ++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..69623f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6881,6 +6881,7 @@ void __init sched_init(void)
 #ifdef CONFIG_NO_HZ_FULL
 		rq->last_sched_tick = 0;
 #endif
+		init_cpu_concurrency(rq);
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7a0d91..2c1f453 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7688,3 +7688,25 @@ __init void init_sched_fair_class(void)
 #endif /* SMP */
 
 }
+
+#ifdef CONFIG_SMP
+
+/*
+ * CPU ConCurrency (CC) measures the CPU load by averaging
+ * the number of running tasks. Using CC, the scheduler can
+ * evaluate the load of CPUs to improve load balance for power
+ * efficiency without sacrificing performance.
+ */
+
+void init_cpu_concurrency(struct rq *rq)
+{
+	rq->concurrency.sum = 0;
+	rq->concurrency.sum_now = 0;
+	rq->concurrency.contrib = 0;
+	rq->concurrency.nr_running = 0;
+	rq->concurrency.sum_timestamp = ULLONG_MAX;
+	rq->concurrency.contrib_timestamp = ULLONG_MAX;
+	rq->concurrency.unload = 0;
+}
+
+#endif /* CONFIG_SMP */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5a66776..898127b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -506,6 +506,18 @@ struct root_domain {
 
 extern struct root_domain def_root_domain;
 
+struct cpu_concurrency_t {
+	u64 sum;
+	u64 sum_now;
+	u64 contrib;
+	u64 sum_timestamp;
+	u64 contrib_timestamp;
+	unsigned int nr_running;
+	int unload;
+	int dst_cpu;
+	struct cpu_stop_work unload_work;
+};
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -640,6 +652,8 @@ struct rq {
 
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
+
+	struct cpu_concurrency_t concurrency;
 #endif
 };
 
@@ -1182,11 +1196,15 @@ extern void trigger_load_balance(struct rq *rq);
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
+extern void init_cpu_concurrency(struct rq *rq);
+
 #else
 
 static inline void idle_enter_fair(struct rq *rq) { }
 static inline void idle_exit_fair(struct rq *rq) { }
 
+static inline void init_cpu_concurrency(struct rq *rq) {}
+
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

