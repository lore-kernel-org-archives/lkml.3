Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaJHG05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:26:57 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37962 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaJHG0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:26:40 -0400
From: Mike Turquette <mturquette@linaro.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>, peterz@infradead.org,
        mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 2/2] cpufreq: arm_big_little: provide cpu capacity
Date: Tue,  7 Oct 2014 23:26:12 -0700
Message-Id: <1412749572-29449-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412749572-29449-1-git-send-email-mturquette@linaro.org>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cpu capacity bits out of arch/arm/ and into the CPUfreq driver.
Not all ARM devices will use CPUfreq and it is unsafe to assume as such
in topology.c.

Instead, use the new capacity_ops introduced into CFS. If this code is
generic enough then it could be factored and shared via a header to make
it easier for other CPUfreq drivers to take advantage of it.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
This approach simply builds on top of Morten's series. I am not sure
that the per-cpu method is the best way to go in the future. And if so I
imagine that the CPUfreq core could provide everything except for the
cpu_eff part.

In general I think that the overlap between CPUfreq drivers and
arch/arm/kernel/topology.c is something that needs to addresssed soon,
as both pieces of code are re-inventing parts of each other.

 arch/arm/include/asm/topology.h  |  2 ++
 arch/arm/kernel/topology.c       | 42 ++-------------------------------
 drivers/cpufreq/arm_big_little.c | 51 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 2fe85ff..3951232 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -14,6 +14,8 @@ struct cputopo_arm {
 };
 
 extern struct cputopo_arm cpu_topology[NR_CPUS];
+extern unsigned long max_raw_capacity;
+DECLARE_PER_CPU(unsigned long, cpu_raw_capacity);
 
 #define topology_physical_package_id(cpu)	(cpu_topology[cpu].socket_id)
 #define topology_core_id(cpu)		(cpu_topology[cpu].core_id)
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 5f049ec..a2c9b5f 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -79,8 +79,8 @@ static unsigned long *__cpu_capacity;
 
 static unsigned long middle_capacity = 1;
 
-static unsigned long max_raw_capacity = 1;
-static DEFINE_PER_CPU(unsigned long, cpu_raw_capacity);
+unsigned long max_raw_capacity = 1;
+DEFINE_PER_CPU(unsigned long, cpu_raw_capacity);
 
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
@@ -175,44 +175,6 @@ static void update_cpu_capacity(unsigned int cpu)
 		cpu, arch_scale_freq_capacity(NULL, cpu));
 }
 
-/*
- * Scheduler load-tracking scale-invariance
- *
- * Provides the scheduler with a scale-invariance correction factor that
- * compensates for frequency scaling and micro-architecture differences between
- * cpus.
- */
-
-static DEFINE_PER_CPU(atomic_long_t, cpu_curr_freq);
-static DEFINE_PER_CPU(atomic_long_t, cpu_max_freq);
-
-/* cpufreq callback function setting current cpu frequency */
-void arch_scale_set_curr_freq(int cpu, unsigned long freq)
-{
-	atomic_long_set(&per_cpu(cpu_curr_freq, cpu), freq);
-}
-
-/* cpufreq callback function setting max cpu frequency */
-void arch_scale_set_max_freq(int cpu, unsigned long freq)
-{
-	atomic_long_set(&per_cpu(cpu_max_freq, cpu), freq);
-}
-
-unsigned long arch_scale_load_capacity(int cpu)
-{
-	unsigned long curr = atomic_long_read(&per_cpu(cpu_curr_freq, cpu));
-	unsigned long max = atomic_long_read(&per_cpu(cpu_max_freq, cpu));
-	unsigned long ret;
-
-	if (!max || !per_cpu(cpu_raw_capacity, cpu))
-		return SCHED_CAPACITY_SCALE;
-
-	ret = (curr * SCHED_CAPACITY_SCALE) / max;
-	ret = (ret * per_cpu(cpu_raw_capacity, cpu)) / max_raw_capacity;
-
-	return ret;
-}
-
 #else
 static inline void parse_dt_topology(void) {}
 static inline void update_cpu_capacity(unsigned int cpuid) {}
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index a46c223..5baffbd 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -31,7 +31,10 @@
 #include <linux/slab.h>
 #include <linux/topology.h>
 #include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
 #include <asm/bL_switcher.h>
+#include <asm/topology.h>
 
 #include "arm_big_little.h"
 
@@ -533,9 +536,52 @@ static struct notifier_block bL_switcher_notifier = {
 	.notifier_call = bL_cpufreq_switcher_notifier,
 };
 
+/*
+ * Scheduler load-tracking scale-invariance
+ *
+ * Provides the scheduler with a scale-invariance correction factor that
+ * compensates for frequency scaling and micro-architecture differences between
+ * cpus.
+ */
+
+static DEFINE_PER_CPU(atomic_long_t, cpu_curr_freq);
+static DEFINE_PER_CPU(atomic_long_t, cpu_max_freq);
+
+/* cpufreq callback function setting current cpu frequency */
+void arch_scale_set_curr_freq(int cpu, unsigned long freq)
+{
+	atomic_long_set(&per_cpu(cpu_curr_freq, cpu), freq);
+}
+
+/* cpufreq callback function setting max cpu frequency */
+void arch_scale_set_max_freq(int cpu, unsigned long freq)
+{
+	atomic_long_set(&per_cpu(cpu_max_freq, cpu), freq);
+}
+
+/*
+ * scale_load_capacity returns the current capacity for a given cpu, adjusted
+ * for micro-architectural differences and taking into accout cpu frequency
+ */
+unsigned long scale_load_capacity(int cpu)
+{
+	unsigned long curr = atomic_long_read(&per_cpu(cpu_curr_freq, cpu));
+	unsigned long max = atomic_long_read(&per_cpu(cpu_max_freq, cpu));
+	unsigned long ret;
+
+	if (!max || !per_cpu(cpu_raw_capacity, cpu))
+		return SCHED_CAPACITY_SCALE;
+
+	ret = (curr * SCHED_CAPACITY_SCALE) / max;
+	ret = (ret * per_cpu(cpu_raw_capacity, cpu)) / max_raw_capacity;
+
+	return ret;
+}
+
 int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops)
 {
 	int ret, i;
+	unsigned long flags;
 
 	if (arm_bL_ops) {
 		pr_debug("%s: Already registered: %s, exiting\n", __func__,
@@ -550,6 +596,11 @@ int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops)
 
 	arm_bL_ops = ops;
 
+	spin_lock_irqsave(&cfs_capacity_ops.lock, flags);
+	cfs_capacity_ops.get_capacity = scale_load_capacity;
+	spin_unlock_irqrestore(&cfs_capacity_ops.lock, flags);
+	synchronize_rcu();
+
 	ret = bL_switcher_get_enabled();
 	set_switching_enabled(ret);
 
-- 
1.8.3.2

