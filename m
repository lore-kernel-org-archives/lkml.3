Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3GIP4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:56:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46202 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3GIPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:38 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 7/9] sched: power: Add power driver interface
Date: Tue,  9 Jul 2013 16:55:36 +0100
Message-Id: <1373385338-12983-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:35.0935 (UTC) FILETIME=[C02020F0:01CE7CBC]
X-MC-Unique: 113070916553629201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FuuDk011637

Initial power driver interface. The unified power driver is to
replace freq and idle drivers and more. Currently only frequency
scaling interface is considered. The power scheduler may query the
power driver for information about current the state and provide
hints for state changes.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 include/linux/sched/power.h |   29 +++++++++++++++++++++++++++++
 kernel/sched/power.c        |   42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/sched/power.h

diff --git a/include/linux/sched/power.h b/include/linux/sched/power.h
new file mode 100644
index 0000000..ae11fec
--- /dev/null
+++ b/include/linux/sched/power.h
@@ -0,0 +1,29 @@
+/*
+ * include/linux/sched/power.h
+ *
+ * Copyright (C) 2013 ARM Limited.
+ * Author: Morten Rasmussen <morten.rasmussen@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_SCHED_POWER_H
+#define _LINUX_SCHED_POWER_H
+
+struct sched_power_driver {
+	/* performance scaling:
+	 * get_power returns the average performance (cpu_power) since last call
+	 * get_power_cap returns the max available performance state (cpu_power)
+	 * such that get_power_cap - get_power is the currently available
+	 * capacity.
+	 * req_power (optional) requests driver to change the performance state.
+	 */
+	unsigned long (*get_power)	(int cpu);
+	unsigned long (*get_power_cap)	(int cpu);
+	unsigned long (*req_power)	(int cpu, unsigned long cpu_power);
+};
+
+int sched_power_register_driver(struct sched_power_driver *driver);
+int sched_power_unregister_driver(struct sched_power_driver *driver);
+#endif
diff --git a/kernel/sched/power.c b/kernel/sched/power.c
index 1ff8e4a..9e44c0e 100644
--- a/kernel/sched/power.c
+++ b/kernel/sched/power.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/sched/power.h>
 
 #include "sched.h"
 
@@ -30,6 +31,8 @@ struct power_domain {
 	struct cpumask span;
 	/* current max power supported by platform */
 	unsigned long arch_power;
+	/* current power reported by power driver */
+	unsigned long curr_power;
 	/* cpu power exposed to the scheduler (fair.c) */
 	unsigned long sched_power;
 	/* load ratio (load tracking) */
@@ -38,6 +41,7 @@ struct power_domain {
 };
 
 static struct power_domain power_hierarchy;
+static struct sched_power_driver *power_driver;
 
 DEFINE_PER_CPU(struct power_domain, *cpu_pds);
 
@@ -102,12 +106,26 @@ static void get_arch_cpu_power(void)
 	int i;
 
 	if (sched_feat(ARCH_POWER)) {
-		for_each_online_cpu(i)
+		for_each_online_cpu(i) {
 			cpu_pd(i)->arch_power =
 				arch_scale_freq_power(cpu_rq(i)->sd, i);
+			cpu_pd(i)->curr_power = cpu_pd(i)->arch_power;
+		}
 	} else {
-		for_each_online_cpu(i)
+		for_each_online_cpu(i) {
 			cpu_pd(i)->arch_power = SCHED_POWER_SCALE;
+			cpu_pd(i)->curr_power = cpu_pd(i)->arch_power;
+		}
+	}
+}
+
+static void get_driver_cpu_power(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		cpu_pd(i)->arch_power = power_driver->get_power_cap(i);
+		cpu_pd(i)->curr_power = power_driver->get_power(i);
 	}
 }
 
@@ -167,7 +185,10 @@ static void __power_schedule(void)
 {
 	rcu_read_lock();
 
-	get_arch_cpu_power();
+	if (!power_driver)
+		get_arch_cpu_power();
+	else
+		get_driver_cpu_power();
 	update_cpu_load();
 	calculate_cpu_capacities();
 
@@ -236,6 +257,21 @@ void power_schedule_wq(struct work_struct *work)
 				msecs_to_jiffies(INTERVAL));
 }
 
+int sched_power_register_driver(struct sched_power_driver *driver)
+{
+	if (!driver->get_power || !driver->get_power_cap)
+		return -1;
+
+	power_driver = driver;
+	return 0;
+}
+
+int sched_power_unregister_driver(struct sched_power_driver *driver)
+{
+	power_driver = NULL;
+	return 0;
+}
+
 static int __init sched_power_init(void)
 {
 	init_power_hierarchy();
-- 
1.7.9.5


