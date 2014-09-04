Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaIDHdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:33:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:53400 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbaIDHdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="381246196"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, luto@amacapital.net, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com, chuansheng.liu@intel.com
Subject: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the idle cpu
Date: Thu,  4 Sep 2014 15:17:53 +0800
Message-Id: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing one new API wake_up_if_idle(), which is used to
wake up the idle CPU.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..3f89ac1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
 extern struct sched_domain_topology_level *sched_domain_topology;
 
 extern void set_sched_topology(struct sched_domain_topology_level *tl);
+extern void wake_up_if_idle(int cpu);
 
 #ifdef CONFIG_SCHED_DEBUG
 # define SD_INIT_NAME(type)		.name = #type
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575..b818548 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1620,6 +1620,25 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 	}
 }
 
+void wake_up_if_idle(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	if (!is_idle_task(rq->curr))
+		return;
+
+	if (set_nr_if_polling(rq->idle)) {
+		trace_sched_wake_idle_without_ipi(cpu);
+	} else {
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		if (is_idle_task(rq->curr))
+			smp_send_reschedule(cpu);
+		/* Else cpu is not in idle, do nothing here */
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
-- 
1.7.9.5

