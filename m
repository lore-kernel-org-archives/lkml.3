Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3JKRTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:19:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48719 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JKRTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:33 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 6/7] sched: power: cpufreq: Initial schedpower cpufreq governor/power driver
Date: Fri, 11 Oct 2013 18:19:16 +0100
Message-Id: <1381511957-29776-7-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:30.0301 (UTC) FILETIME=[0BABEAD0:01CEC6A6]
X-MC-Unique: 113101118193102301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHKjbN031580

Adds a 'schedpower' cpufreq governor that acts as a power driver to
cpufreq wrapper. This enables the existing cpufreq drivers to be used
as power driver backends initially until native power drivers have been
implemented.

schedpower currently uses workqueues as a horrible work-around for calling
cpufreq from the late_callback() path. Calling cpufreq from the
late_callback() in its current form is not possible and certainly not
possible from the scheduler context. Suggestions for better solutions
are very welcome.

Native power driver implemented with the locking and context limitations
in mind should be able to avoid such work-arounds.

schedpower has been tested (not thoroughly) on ARM TC2.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/Kconfig              |   11 ++
 drivers/cpufreq/Makefile             |    1 +
 drivers/cpufreq/cpufreq_schedpower.c |  207 ++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_schedpower.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..d832e34 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -184,6 +184,17 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_GOV_SCHEDPOWER
+	bool "'schedpower' governor/power driver"
+	depends on CPU_FREQ
+	depends on SCHED_POWER
+	help
+	  'schedpower' - this governor allows existing cpufreq drivers to be
+	  used as power driver backend. The governor registers itself as a
+	  power driver with the scheduler and uses the existing cpufreq framework
+	  and drivers to do the actual frequency changes. Frequency selection is
+	  based on scheduler hints provided by the power driver interface.
+
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
 	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index d345b5a..e00a17c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
 obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOV_SCHEDPOWER)	+= cpufreq_schedpower.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 # CPUfreq cross-arch helpers
diff --git a/drivers/cpufreq/cpufreq_schedpower.c b/drivers/cpufreq/cpufreq_schedpower.c
new file mode 100644
index 0000000..5952c79
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_schedpower.c
@@ -0,0 +1,207 @@
+/*
+ * schedpower cpufreq governor/power driver
+ *
+ * drivers/cpufreq/cpufreq_schedpower.c
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
+#include <linux/cpufreq.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/hrtimer.h>
+#include <linux/sched/power.h>
+
+struct cpufreq_schedpower_cpuinfo {
+	struct cpufreq_policy *policy;
+	struct work_struct work;
+	unsigned int target_freq;
+	u64 last_change;
+	int cpufreq_call_needed;
+	int governor_enabled;
+};
+
+DEFINE_PER_CPU(struct cpufreq_schedpower_cpuinfo, cpuinfo);
+
+struct cpufreq_driver_data {
+	struct work_struct work;
+	struct cpufreq_policy *policy;
+	unsigned int target_freq;
+};
+
+static struct power_driver pdriver;
+
+static int cpufreq_governor_schedpower(struct cpufreq_policy *policy,
+					unsigned int event)
+{
+	int i;
+	struct cpufreq_schedpower_cpuinfo *pcpu_info;
+
+	switch (event) {
+	case CPUFREQ_GOV_START:
+	case CPUFREQ_GOV_LIMITS:
+		__cpufreq_driver_target(policy, policy->max,
+						CPUFREQ_RELATION_H);
+
+		for_each_cpu(i, policy->cpus) {
+			pcpu_info = &per_cpu(cpuinfo, i);
+			pcpu_info->policy = policy;
+			pcpu_info->last_change = ktime_to_us(ktime_get());
+			pcpu_info->cpufreq_call_needed = 0;
+			pcpu_info->governor_enabled = 1;
+		}
+
+		power_driver_register(&pdriver);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static
+struct cpufreq_governor cpufreq_gov_schedpower = {
+	.name		= "schedpower",
+	.governor	= cpufreq_governor_schedpower,
+	.owner		= THIS_MODULE,
+};
+
+static int __init cpufreq_gov_schedpower_init(void)
+{
+	return cpufreq_register_governor(&cpufreq_gov_schedpower);
+}
+late_initcall(cpufreq_gov_schedpower_init);
+
+#define FREQ_STEP 50	/* % */
+#define CALL_RATE 1000	/* us */
+
+/*
+ * cpufreq_driver_call: Workqueue worker function that calls to cpufreq.
+ * More details at queue_cpufreq_driver_call
+ */
+static void cpufreq_driver_call(struct work_struct *work)
+{
+	struct cpufreq_driver_data *call_data =
+					 (struct cpufreq_driver_data *)work;
+
+	cpufreq_driver_target(call_data->policy, call_data->target_freq,
+							CPUFREQ_RELATION_H);
+	kfree((void *)call_data);
+}
+
+/*
+ * queue_cpufreq_driver_call: cpufreq can't be called from the schedule()
+ * context with rq locks held and irqs disabled. Using workqueues to do the
+ * actual call to cpufreq should solve that problem. But work cannot be queued
+ * with the irq disabled and rq locks held. So this must be postponed to the
+ * late callback.
+ *
+ * Using workqueues is not ideal as it will schedule the kworker task before
+ * the task we actually want to run. To avoid getting power hints for the
+ * kworker and overriding the power hints for the user task, kthreads are
+ * filtered out in fair.c.
+ */
+static void queue_cpufreq_driver_call(int cpu,
+				struct cpufreq_schedpower_cpuinfo *pcpu_info)
+{
+	struct cpufreq_driver_data *call_data;
+	u64 now = ktime_to_us(ktime_get());
+
+	if (now - pcpu_info->last_change < CALL_RATE)
+		return;
+
+	call_data = kmalloc(sizeof(struct cpufreq_driver_data), GFP_KERNEL);
+
+	if (call_data) {
+		INIT_WORK((struct work_struct *)call_data, cpufreq_driver_call);
+		call_data->policy = pcpu_info->policy;
+		call_data->target_freq = pcpu_info->target_freq;
+		schedule_work_on(cpu, (struct work_struct *)call_data);
+		pcpu_info->last_change = now;
+	}
+}
+
+int pdriver_at_max_capacity(int cpu)
+{
+	struct cpufreq_schedpower_cpuinfo *pcpu_info;
+	pcpu_info = &per_cpu(cpuinfo, cpu);
+
+	return (pcpu_info->policy->cur >= pcpu_info->policy->max);
+}
+
+int pdriver_go_faster(int cpu, int hint)
+{
+	struct cpufreq_schedpower_cpuinfo *pcpu_info;
+	pcpu_info = &per_cpu(cpuinfo, cpu);
+
+	if (!pcpu_info->governor_enabled)
+		return 0;
+
+	if (pcpu_info->policy->cur >= pcpu_info->policy->max)
+		return 0;
+
+	pcpu_info->target_freq = min(((100+FREQ_STEP)
+			*pcpu_info->policy->cur)/100, pcpu_info->policy->max);
+
+	pcpu_info->cpufreq_call_needed = 1;
+	return 1;
+}
+
+int pdriver_go_slower(int cpu, int hint)
+{
+	unsigned int other_freq, max_freq = 0;
+	struct cpufreq_schedpower_cpuinfo *pcpu_info, *other_cpu;
+	int i;
+
+	pcpu_info = &per_cpu(cpuinfo, cpu);
+
+	if (!pcpu_info->governor_enabled)
+		return 0;
+
+	if (pcpu_info->policy->cur <= pcpu_info->policy->min)
+		return 0;
+
+	pcpu_info->target_freq = max(((100-FREQ_STEP)
+			*pcpu_info->policy->cur)/100, pcpu_info->policy->min);
+
+	for_each_cpu(i, pcpu_info->policy->cpus) {
+		other_cpu = &per_cpu(cpuinfo, i);
+		other_freq = other_cpu->target_freq;
+		max_freq = max(other_freq, max_freq);
+	}
+
+	if (max_freq >= pcpu_info->policy->cur)
+		return 0;
+
+	pcpu_info->cpufreq_call_needed = 1;
+	return 1;
+}
+
+void pdriver_late_callback(int cpu)
+{
+	struct cpufreq_schedpower_cpuinfo *pcpu_info;
+	pcpu_info = &per_cpu(cpuinfo, cpu);
+
+	if (pcpu_info->cpufreq_call_needed) {
+		queue_cpufreq_driver_call(cpu, pcpu_info);
+		pcpu_info->cpufreq_call_needed = 0;
+	}
+}
+
+static struct power_driver pdriver = {
+	.at_max_capacity	= pdriver_at_max_capacity,
+	.go_faster		= pdriver_go_faster,
+	.go_slower		= pdriver_go_slower,
+	.late_callback		= pdriver_late_callback,
+};
+
-- 
1.7.9.5


