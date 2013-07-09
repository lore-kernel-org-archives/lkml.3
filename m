Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3GIPzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:55:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45895 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GIPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:35 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 1/9] sched: Introduce power scheduler
Date: Tue,  9 Jul 2013 16:55:30 +0100
Message-Id: <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:30.0888 (UTC) FILETIME=[BD1E0480:01CE7CBC]
X-MC-Unique: 113070916553211201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69Fu8Io011621

Proof of concept capacity managing power scheduler. Supports simple
packing without any consideration of power topology. The power scheduler
is meant to use a platform specific power driver to obtain information
about power topology and select idle states and frequency/P-states.

For now, the power scheduler is called periodically on cpu0. This will be
replaced by calls from the scheduler in the future. Thresholds and other
defined constants will be configurable, possibly set by the power driver,
in the future. Iterations over all cpus will be also be optimized to
ensure scalability.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/Kconfig      |    2 +
 kernel/Kconfig.power  |    3 +
 kernel/sched/Makefile |    1 +
 kernel/sched/power.c  |  161 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 167 insertions(+)
 create mode 100644 kernel/Kconfig.power
 create mode 100644 kernel/sched/power.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2651b1d..04076ab 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1805,6 +1805,8 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+source "kernel/Kconfig.power"
+
 endmenu
 
 menu "Boot options"
diff --git a/kernel/Kconfig.power b/kernel/Kconfig.power
new file mode 100644
index 0000000..4fdaa13
--- /dev/null
+++ b/kernel/Kconfig.power
@@ -0,0 +1,3 @@
+config SCHED_POWER
+	bool "(EXPERIMENTAL) Power scheduler"
+	default n
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index deaf90e..67b01b2 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_SCHED_POWER) += power.o
diff --git a/kernel/sched/power.c b/kernel/sched/power.c
new file mode 100644
index 0000000..ddf249f
--- /dev/null
+++ b/kernel/sched/power.c
@@ -0,0 +1,161 @@
+/*
+ * kernel/sched/power.c
+ *
+ * Copyright (C) 2013 ARM Limited.
+ * Author: Morten Rasmussen <morten.rasmussen@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+
+#include "sched.h"
+
+#define INTERVAL 5 /* ms */
+#define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
+
+struct cpu_stats_struct {
+	int load;
+	int nr_tasks;
+};
+
+static unsigned long power_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_power;
+}
+
+DEFINE_PER_CPU(struct cpu_stats_struct, cpu_stats);
+
+/*
+ * update_cpu_load fetches runqueue statistics from the scheduler should
+ * only be called with approitate locks held.
+ */
+static void update_cpu_load(void)
+{
+	int i;
+
+	for_each_online_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+		int load = 0;
+		u32 sum = rq->avg.runnable_avg_sum;
+		u32 period = rq->avg.runnable_avg_period;
+
+		load = (sum * power_of(i)) / (period+1);
+		per_cpu(cpu_stats, i).load = load;
+		per_cpu(cpu_stats, i).nr_tasks = rq->nr_running;
+
+		/* Take power scheduler kthread into account */
+		if (smp_processor_id() == i)
+			per_cpu(cpu_stats, i).nr_tasks--;
+	}
+}
+
+extern unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu);
+DEFINE_PER_CPU(unsigned long, arch_cpu_power);
+
+static void get_arch_cpu_power(void)
+{
+	int i;
+
+	if (sched_feat(ARCH_POWER)) {
+		for_each_online_cpu(i)
+			per_cpu(arch_cpu_power, i) =
+				arch_scale_freq_power(cpu_rq(i)->sd, i);
+	} else {
+		for_each_online_cpu(i)
+			per_cpu(arch_cpu_power, i) = SCHED_POWER_SCALE;
+	}
+}
+
+DEFINE_PER_CPU(unsigned long, cpu_power);
+
+/*
+ * power_sched_cpu_power is called from fair.c to get the power scheduler
+ * cpu capacities. We can't use arch_scale_freq_power() as this may already
+ * be defined by the platform.
+ */
+unsigned long power_sched_cpu_power(struct sched_domain *sd, int cpu)
+{
+	return per_cpu(cpu_power, cpu);
+}
+
+/*
+ * calculate_cpu_capacities figures out how many cpus that are necessary
+ * to handle the current load. The current algorithm is very simple and
+ * does not take power topology into account and it does not scale the cpu
+ * capacity. It is either on or off. Plenty of potential for improvements!
+ */
+static void calculate_cpu_capacities(void)
+{
+	int i, spare_cap = 0;
+	struct cpu_stats_struct *stats;
+
+	/*
+	 * spare_cap keeps track of the total available capacity across
+	 * all cpus
+	 */
+
+	for_each_online_cpu(i) {
+		int t_cap = 0;
+		int arch_power = per_cpu(arch_cpu_power, i);
+
+		stats = &per_cpu(cpu_stats, i);
+		t_cap = arch_power - stats->load;
+
+		if (t_cap < (arch_power * (100-CPU_FULL)) / 100) {
+			/* Potential for spreading load */
+			if (stats->nr_tasks > 1)
+				t_cap = -(stats->load / stats->nr_tasks);
+		}
+
+		/* Do we have enough capacity already? */
+		if (spare_cap + t_cap > arch_power) {
+			per_cpu(cpu_power, i) = 1;
+		} else {
+			per_cpu(cpu_power, i) = arch_power;
+			spare_cap += t_cap;
+		}
+	}
+}
+
+static void __power_schedule(void)
+{
+	rcu_read_lock();
+
+	get_arch_cpu_power();
+	update_cpu_load();
+	calculate_cpu_capacities();
+
+	rcu_read_unlock();
+}
+
+struct delayed_work dwork;
+
+/* Periodic power schedule target cpu */
+static int schedule_cpu(void)
+{
+	return 0;
+}
+
+void power_schedule_wq(struct work_struct *work)
+{
+	__power_schedule();
+	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
+				msecs_to_jiffies(INTERVAL));
+}
+
+static int __init sched_power_init(void)
+{
+	INIT_DELAYED_WORK(&dwork, power_schedule_wq);
+	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
+				msecs_to_jiffies(INTERVAL));
+	return 0;
+}
+late_initcall(sched_power_init);
-- 
1.7.9.5


