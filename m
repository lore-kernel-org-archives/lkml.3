Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3DDCC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:30857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab3DDCCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534181"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 07/21] sched: move sg/sd_lb_stats struct ahead
Date: Thu,  4 Apr 2013 10:00:48 +0800
Message-Id: <1365040862-8390-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power aware fork/exec/wake balancing needs both of structs in incoming
patches. So move ahead before it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 99 +++++++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b7917b..a0bd2f3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3301,6 +3301,56 @@ done:
 }
 
 /*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+	unsigned int  this_has_capacity;
+	unsigned int  this_idle_cpus;
+
+	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+	unsigned long busiest_group_capacity;
+	unsigned int  busiest_has_capacity;
+	unsigned int  busiest_group_weight;
+
+	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned int  sd_util;	/* sum utilization of this domain */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+};
+
+/*
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
+	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
+	unsigned int group_util;	/* sum utilization of group */
+};
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -4175,55 +4225,6 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
-/*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-	unsigned long this_has_capacity;
-	unsigned int  this_idle_cpus;
-
-	/* Statistics of the busiest group */
-	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-	unsigned long busiest_group_capacity;
-	unsigned long busiest_has_capacity;
-	unsigned int  busiest_group_weight;
-
-	int group_imb; /* Is there imbalance in this sd */
-
-	/* Varibles of power awaring scheduling */
-	unsigned int  sd_util;	/* sum utilization of this domain */
-	struct sched_group *group_leader; /* Group which relieves group_min */
-};
-
-/*
- * sg_lb_stats - stats of a sched_group required for load_balancing
- */
-struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
-	unsigned long idle_cpus;
-	unsigned long group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
-	unsigned int group_util;	/* sum utilization of group */
-};
 
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
-- 
1.7.12

