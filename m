Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbaELCWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:22:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:53169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422AbaELCWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="530200581"
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
Subject: [RFC PATCH 02/12 v2] Init CPU ConCurrency
Date: Mon, 12 May 2014 02:16:51 +0800
Message-Id: <1399832221-8314-3-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU ConCurrency (CC) is inserted as a member in each CPU's rq, and
initiated the same time as rq. Updating CC is protected by rq's lock.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/Makefile      |    1 +
 kernel/sched/concurrency.c |   22 ++++++++++++++++++++++
 kernel/sched/core.c        |    2 ++
 kernel/sched/sched.h       |   21 +++++++++++++++++++++
 4 files changed, 46 insertions(+)
 create mode 100644 kernel/sched/concurrency.c

diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index ab32b7b..e67f7e3 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_CPU_CONCURRENCY) += concurrency.o
diff --git a/kernel/sched/concurrency.c b/kernel/sched/concurrency.c
new file mode 100644
index 0000000..50e08a2
--- /dev/null
+++ b/kernel/sched/concurrency.c
@@ -0,0 +1,22 @@
+/*
+ * CPU ConCurrency (CC) measures the CPU load by averaging
+ * the number of running tasks. Using CC, the scheduler can
+ * evaluate the load of CPUs to improve load balance for power
+ * efficiency without sacrificing performance.
+ *
+ */
+
+#ifdef CONFIG_CPU_CONCURRENCY
+
+#include "sched.h"
+
+void init_cpu_concurrency(struct rq *rq)
+{
+	rq->concurrency.sum = 0;
+	rq->concurrency.sum_now = 0;
+	rq->concurrency.contrib = 0;
+	rq->concurrency.nr_running = 0;
+	rq->concurrency.sum_timestamp = ULLONG_MAX;
+	rq->concurrency.contrib_timestamp = ULLONG_MAX;
+}
+#endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..7958a47 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6884,6 +6884,8 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+
+		init_cpu_concurrency(rq);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..f1c9235 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -508,6 +508,17 @@ extern struct root_domain def_root_domain;
 
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_CPU_CONCURRENCY
+struct cpu_concurrency_t {
+	u64 sum;
+	u64 sum_now;
+	u64 contrib;
+	u64 sum_timestamp;
+	u64 contrib_timestamp;
+	unsigned int nr_running;
+};
+#endif
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -643,6 +654,10 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+#ifdef CONFIG_CPU_CONCURRENCY
+	struct cpu_concurrency_t concurrency;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
@@ -1203,6 +1218,12 @@ extern void init_sched_dl_class(void);
 extern void resched_task(struct task_struct *p);
 extern void resched_cpu(int cpu);
 
+#ifdef CONFIG_CPU_CONCURRENCY
+extern void init_cpu_concurrency(struct rq *rq);
+#else
+static inline void init_cpu_concurrency(struct rq *rq) {}
+#endif
+
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
-- 
1.7.9.5

