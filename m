Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3JKRVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:21:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48607 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JKRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:31 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 3/7] sched: power: go_faster/slower power driver hints
Date: Fri, 11 Oct 2013 18:19:13 +0100
Message-Id: <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:27.0489 (UTC) FILETIME=[09FED710:01CEC6A6]
X-MC-Unique: 113101118192901101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHLgUe031602

Adds power driver hints at task enqueue/dequeue and at the sched tick if
the new cpu load doesn't match the current cpu capacity. The optional hint
argument of go_faster/slower calls is currently unused. It is meant to
give the power driver a rough estimate of how much more/less cpu capacity
is needed. The power driver may ignore this and the go_faster/slower call
completely.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c  |   30 ++++++++++++++++++++++++++++++
 kernel/sched/sched.h |   18 ++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index edba1bb..50ae0ce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2852,6 +2852,31 @@ static inline void hrtick_update(struct rq *rq)
 }
 #endif
 
+#ifdef CONFIG_SCHED_POWER
+static unsigned long weighted_cpuload(const int cpu);
+static unsigned long power_of(int cpu);
+
+static inline void inc_cpu_capacity(int cpu)
+{
+	if (weighted_cpuload(cpu) > power_of(cpu))
+		go_faster(cpu, 0);
+}
+
+static inline void dec_cpu_capacity(int cpu)
+{
+	if (weighted_cpuload(cpu) < power_of(cpu))
+		go_slower(cpu, 0);
+}
+#else
+static inline void inc_cpu_capacity(int cpu)
+{
+}
+
+static inline void dec_cpu_capacity(int cpu)
+{
+}
+#endif
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
@@ -2897,6 +2922,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_rq_runnable_avg(rq, rq->nr_running);
 		inc_nr_running(rq);
 	}
+
+	inc_cpu_capacity(task_cpu(p));
 	hrtick_update(rq);
 }
 
@@ -2958,6 +2985,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		dec_nr_running(rq);
 		update_rq_runnable_avg(rq, 1);
 	}
+
+	dec_cpu_capacity(task_cpu(p));
 	hrtick_update(rq);
 }
 
@@ -5743,6 +5772,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 */
 	nohz_idle_balance(this_cpu, idle);
 
+	inc_cpu_capacity(this_cpu);
 	power_late_callback(this_cpu);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 907a967..88e7968 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1367,8 +1367,26 @@ static inline u64 irq_time_read(int cpu)
 
 #ifdef CONFIG_SCHED_POWER
 extern void power_late_callback(int cpu);
+extern int at_max_capacity(int cpu);
+extern int go_faster(int cpu, int hint);
+extern int go_slower(int cpu, int hint);
 #else
 static inline void power_late_callback(int cpu)
 {
 }
+
+static inline int at_max_capacity(int cpu)
+{
+	return 1;
+}
+
+static inline int go_faster(int cpu, int hint)
+{
+	return 0;
+}
+
+static inline int go_slower(int cpu, int hint)
+{
+	return 0;
+}
 #endif /* CONFIG_SCHED_POWER */
-- 
1.7.9.5


