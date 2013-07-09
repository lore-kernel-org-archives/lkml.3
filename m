Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3GIP4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:56:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46283 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3GIPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:41 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 9/9] sched: power: cpufreq: Initial schedpower cpufreq governor
Date: Tue,  9 Jul 2013 16:55:38 +0100
Message-Id: <1373385338-12983-10-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:37.0825 (UTC) FILETIME=[C1408510:01CE7CBC]
X-MC-Unique: 113070916553900901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FuMif011625

Adds a 'schedpower' cpufreq governor that acts as a cpufreq driver
wrapper for the power scheduler. This enables the power scheduler
to initially use existing cpufreq drivers during development.
The long term plan is platform specific unified power drivers.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/cpufreq/Kconfig              |    8 +++
 drivers/cpufreq/Makefile             |    1 +
 drivers/cpufreq/cpufreq_schedpower.c |  119 ++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_schedpower.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..f0d168d 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -184,6 +184,14 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_GOV_SCHEDPOWER
+	bool "'schedpower' governor/power driver"
+	depends on CPU_FREQ
+	depends on SCHED_POWER
+	help
+	  'schedpower' - this governor acts as a wrapper power driver for the
+	  power scheduler.
+
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
 	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 315b923..6ff50ad 100644
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
index 0000000..1b20adb
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_schedpower.c
@@ -0,0 +1,119 @@
+/*
+ * Power driver to cpufreq wrapper for power scheduler
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
+#include <linux/sched/power.h>
+
+static struct cpufreq_policy *cur_policy;
+
+DEFINE_PER_CPU(unsigned int, freq_req);
+
+static int cpufreq_governor_schedpower(struct cpufreq_policy *policy,
+					unsigned int event)
+{
+	int i;
+
+	switch (event) {
+	case CPUFREQ_GOV_START:
+	case CPUFREQ_GOV_LIMITS:
+		pr_debug("setting to %u kHz because of event %u\n",
+						policy->max, event);
+		__cpufreq_driver_target(policy, policy->max,
+						CPUFREQ_RELATION_H);
+
+		for_each_cpu(i, policy->cpus)
+			per_cpu(freq_req, i) = policy->max;
+
+		break;
+	default:
+		break;
+	}
+
+	cur_policy = policy;
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
+static struct sched_power_driver pdriver;
+
+static int __init cpufreq_gov_schedpower_init(void)
+{
+	int freq_reg;
+
+	cur_policy = NULL;
+
+	freq_reg = cpufreq_register_governor(&cpufreq_gov_schedpower);
+	if (freq_reg)
+		return freq_reg;
+	return sched_power_register_driver(&pdriver);
+}
+late_initcall(cpufreq_gov_schedpower_init);
+
+unsigned long pdriver_get_power(int cpu)
+{
+	if (!cur_policy)
+		return 1024;
+	return (cur_policy->cur * 1024)/cur_policy->max;
+}
+
+unsigned long pdriver_get_power_cap(int cpu)
+{
+	return 1024;
+}
+
+static unsigned long max_freq_req(void)
+{
+	int i;
+	int max = 0;
+
+	for_each_cpu(i, cur_policy->cpus) {
+		if (per_cpu(freq_req, i) > max)
+			max = per_cpu(freq_req, i);
+	}
+
+	if (max < cur_policy->min)
+		return cur_policy->min;
+	return max;
+}
+
+unsigned long pdriver_req_power(int cpu, unsigned long cpu_power)
+{
+	unsigned int target;
+	if (!cur_policy)
+		return 1024;
+	target = (cur_policy->max * cpu_power)/1024;
+
+	per_cpu(freq_req, cpu) = target;
+
+	cpufreq_driver_target(cur_policy, max_freq_req(), CPUFREQ_RELATION_H);
+
+	return (cur_policy->cur * 1024)/cur_policy->max;
+}
+
+static struct sched_power_driver pdriver = {
+	.get_power	= pdriver_get_power,
+	.get_power_cap	= pdriver_get_power_cap,
+	.req_power	= pdriver_req_power,
+};
+
-- 
1.7.9.5


