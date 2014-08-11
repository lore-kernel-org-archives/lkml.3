Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaHKLgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:36:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55730 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHKLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:36:47 -0400
Subject: [RFC PATCH V2 08/19] sched: move sg/sd_lb_stats struct ahead
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
Date: Mon, 11 Aug 2014 17:06:26 +0530
Message-ID: <20140811113616.31956.17605.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-1344-0000-0000-00000361AADA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

Power aware fork/exec/wake balancing needs both of structs in incoming
patches. So move ahead before it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |   89 ++++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3d6d081..031d115 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4505,6 +4505,51 @@ done:
 }
 
 /*
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long load_per_task;
+	unsigned long group_capacity;
+	unsigned int sum_nr_running; /* Nr tasks running in the group */
+	unsigned int group_capacity_factor;
+	unsigned int idle_cpus;
+	unsigned int group_weight;
+	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_free_capacity;
+#ifdef CONFIG_NUMA_BALANCING
+	unsigned int nr_numa_running;
+	unsigned int nr_preferred_running;
+#endif
+#ifdef CONFIG_SCHED_POWER
+	unsigned int group_util;	/* sum utilization of group */
+#endif
+};
+
+/*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		 during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest;	/* Busiest group in this sd */
+	struct sched_group *local;	/* Local group in this sd */
+	unsigned long total_load;	/* Total load of all groups in sd */
+	unsigned long total_capacity;	/* Total capacity of all groups in sd */
+	unsigned long avg_load;	/* Average load across all groups in sd */
+
+	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
+	struct sg_lb_stats local_stat;	/* Statistics of the local group */
+
+#ifdef CONFIG_SCHED_POWER
+        /* Varibles of power aware scheduling */
+        unsigned int  sd_util;  /* sum utilization of this domain */
+        struct sched_group *group_leader; /* Group which relieves group_min */
+#endif
+};
+
+/*
  * select_task_rq_fair: Select target runqueue for the waking task in domains
  * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
  * SD_BALANCE_FORK, or SD_BALANCE_EXEC.
@@ -5574,50 +5619,6 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
-/*
- * sg_lb_stats - stats of a sched_group required for load_balancing
- */
-struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long load_per_task;
-	unsigned long group_capacity;
-	unsigned int sum_nr_running; /* Nr tasks running in the group */
-	unsigned int group_capacity_factor;
-	unsigned int idle_cpus;
-	unsigned int group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_free_capacity;
-#ifdef CONFIG_NUMA_BALANCING
-	unsigned int nr_numa_running;
-	unsigned int nr_preferred_running;
-#endif
-#ifdef CONFIG_SCHED_POWER
-	unsigned int group_util;	/* sum utilization of group */
-#endif
-};
-
-/*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- *		 during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest;	/* Busiest group in this sd */
-	struct sched_group *local;	/* Local group in this sd */
-	unsigned long total_load;	/* Total load of all groups in sd */
-	unsigned long total_capacity;	/* Total capacity of all groups in sd */
-	unsigned long avg_load;	/* Average load across all groups in sd */
-
-	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
-	struct sg_lb_stats local_stat;	/* Statistics of the local group */
-
-#ifdef CONFIG_SCHED_POWER
-        /* Varibles of power aware scheduling */
-        unsigned int  sd_util;  /* sum utilization of this domain */
-        struct sched_group *group_leader; /* Group which relieves group_min */
-#endif
-};
 
 static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 {

