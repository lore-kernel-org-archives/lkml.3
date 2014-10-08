Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaJHG0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:26:42 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39412 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaJHG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:26:38 -0400
From: Mike Turquette <mturquette@linaro.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>, peterz@infradead.org,
        mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 1/2] sched: cfs: introduce capacity_ops
Date: Tue,  7 Oct 2014 23:26:11 -0700
Message-Id: <1412749572-29449-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412749572-29449-1-git-send-email-mturquette@linaro.org>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler needs to know the current capacity of a cpu taking into
account micro-architectural differences as well as current cpu
frequency. The method for determining this may vary not only from
architecture to architecture, but also within differnt platforms of the
same architectures.

struct capacity_ops allows for a machine-specific backend to provide
this data. Access to the ops is protected by rcu_read_lock(). This is to
prevent a loadable module that provides capacity_ops callbacks from
pulling the rug out from under us while the scheduler is still using the
function.

A weak arch function used to be responsible for this, but that approach
is too limiting. For example various ARM SoCs may have wildly different
methods for determining the current cpu capacity. capacity_ops allows
many methods to be compiled into the kernel and then selects one at
run-time.

The default ops require no knowledge of hardware and do nothing. This
patch only includes .get_capacity, but future ops for updating and
setting the capacity in the works.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
Note that struct capacity_ops should have other members in it in the
future. I have an additional patch that I plan to post soon which adds
.eval_capacity as a way to for the scheduler to initiate a change in cpu
capacity (e.g. scale cpu frequency).

 include/linux/sched.h | 28 ++++++++++++++++++++++++++++
 kernel/sched/fair.c   | 41 +++++++++++++++++++++++++++++++++++------
 2 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fa0b121..4b69000 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -846,6 +846,34 @@ enum cpu_idle_type {
 	CPU_MAX_IDLE_TYPES
 };
 
+/**
+ * capacity_ops -  helpers for understanding and changing scalable cpu capacity
+ * @get_capacity:  returns current capacity of cpu, accounting for
+ * 		   micro-architecture and frequency variability
+ *
+ * capacity_ops contains machine-specific callbacks for retreiving
+ * power-adjusted capacity and updating capacity on a set of cpus.
+ *
+ * The default ops do not interact with hardware.
+ *
+ * Using these ops requires holding rcu_read_lock() across the function call to
+ * protect against function pointers disappearing during use. This can happen
+ * if a loadable module provides the callbacks and is unloaded during execution
+ * of the callback.
+ *
+ * Updates to the ops (such as implementations based on a CPUfreq backend)
+ * requires acquring capacity_ops.lock during the change, followed by a call to
+ * synchronize_rcu().
+ */
+struct capacity_ops {
+	unsigned long (*get_capacity)(int cpu);
+	spinlock_t lock;
+};
+
+extern struct capacity_ops cfs_capacity_ops;
+
+unsigned long default_scale_load_capacity(int cpu);
+
 /*
  * Increase resolution of cpu_capacity calculations
  */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 025bf3c..8124c7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2264,8 +2264,6 @@ static u32 __compute_runnable_contrib(u64 n)
 	return contrib + runnable_avg_yN_sum[n];
 }
 
-unsigned long arch_scale_load_capacity(int cpu);
-
 /*
  * We can represent the historical contribution to runnable average as the
  * coefficients of a geometric series.  To do this we sub-divide our runnable
@@ -2302,7 +2300,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 	u64 delta, periods;
 	u32 runnable_contrib;
 	int delta_w, decayed = 0;
-	u32 scale_cap = arch_scale_load_capacity(cpu);
+	u32 scale_cap = cfs_get_capacity(cpu);
 
 	delta = now - sa->last_runnable_update;
 	/*
@@ -5795,14 +5793,44 @@ unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
 	return default_scale_smt_capacity(sd, cpu);
 }
 
-static unsigned long default_scale_load_capacity(int cpu)
+unsigned long default_scale_load_capacity(int cpu)
 {
 	return SCHED_CAPACITY_SCALE;
 }
 
-unsigned long __weak arch_scale_load_capacity(int cpu)
+struct capacity_ops cfs_capacity_ops = {
+	.get_capacity = default_scale_load_capacity,
+};
+
+static unsigned long cfs_get_capacity(int cpu)
 {
-	return default_scale_load_capacity(cpu);
+	unsigned long ret;
+
+	rcu_read_lock();
+	ret = cfs_capacity_ops.get_capacity(cpu);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/**
+ * set_default_capacity_ops - reset capacity ops to their default
+ * @eops - capacity_ops we are reseting
+ *
+ * Useful for loadable modules that supply custom capacity_ops callbacks.  When
+ * unloading these modules need to restore the originals before the custom
+ * callbacks disappear.
+ *
+ * FIXME - belongs in kernel/sched/core.c?
+ */
+void set_default_capacity_ops(struct capacity_ops *eops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&eops->lock, flags);
+	eops->get_capacity = default_scale_load_capacity;
+	spin_unlock_irqrestore(&eops->lock, flags);
+	synchronize_rcu();
 }
 
 static unsigned long scale_rt_capacity(int cpu)
@@ -8026,6 +8054,7 @@ void print_cfs_stats(struct seq_file *m, int cpu)
 __init void init_sched_fair_class(void)
 {
 #ifdef CONFIG_SMP
+	spin_lock_init(&cfs_capacity_ops.lock);
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ_COMMON
-- 
1.8.3.2

