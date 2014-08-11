Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHKLfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:35:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56821 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHKLfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:35:48 -0400
Subject: [RFC PATCH V2 06/19] sched: log the cpu utilization at rq
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:05:25 +0530
Message-ID: <20140811113514.31956.53276.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-3532-0000-0000-000003C0A02D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

The cpu's utilization is to measure how busy is the cpu.
        util = cpu_rq(cpu)->avg.runnable_avg_sum * SCHED_POEWR_SCALE
                / cpu_rq(cpu)->avg.runnable_avg_period;

Since the util is no more than 1, we scale its value with 1024, same as
SCHED_POWER_SCALE and set the FULL_UTIL as 1024.

In later power aware scheduling, we are sensitive for how busy of the
cpu. Since as to power consuming, it is tight related with cpu busy
time.

BTW, rq->util can be used for any purposes if needed, not only power
scheduling.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/debug.c |    3 +++
 kernel/sched/fair.c  |   15 +++++++++++++++
 kernel/sched/sched.h |    9 +++++++++
 3 files changed, 27 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 627b3c3..395af7f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -325,6 +325,9 @@ do {									\
 
 	P(ttwu_count);
 	P(ttwu_local);
+#ifdef CONFIG_SCHED_POWER
+	P(util);
+#endif
 
 #undef P
 #undef P64
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f1b0a33..681ad06 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2446,10 +2446,25 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	}
 }
 
+#ifdef CONFIG_SCHED_POWER
+static void update_rq_util(struct rq *rq)
+{
+	if (rq->avg.runnable_avg_period)
+		rq->util = (u64)(rq->avg.runnable_avg_sum << SCHED_CAPACITY_SHIFT)
+				/ rq->avg.runnable_avg_period;
+	else
+		rq->util = (u64)(rq->avg.runnable_avg_sum << SCHED_CAPACITY_SHIFT);
+}
+#else
+static void update_rq_util(struct rq *rq) {}
+#endif
+
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
+
+	update_rq_util(rq);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 95fc013..971b812 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -508,6 +508,11 @@ extern struct root_domain def_root_domain;
 
 #endif /* CONFIG_SMP */
 
+/* full cpu utilization */
+#ifdef CONFIG_SCHED_POWER
+#define FULL_UTIL	SCHED_CAPACITY_SCALE
+#endif
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -556,6 +561,10 @@ struct rq {
 	struct sched_avg avg;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SCHED_POWER
+	unsigned int util;
+#endif /* CONFIG_SCHED_POWER */
+
 	/*
 	 * This is part of a global counter where only the total sum
 	 * over all CPUs matters. A task can increase this counter on

