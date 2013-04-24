Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3DXLqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:46:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42701 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab3DXLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:46:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT for power oriented workqueues
Date: Wed, 24 Apr 2013 17:12:53 +0530
Message-Id: <480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues can be performance or power oriented. For performance we may want to
keep them running on a single cpu, so that it remains cache hot. For power we
can give scheduler the liberty to choose target cpu for running work handler.

Later one (Power oriented WQ) can be achieved if the workqueue is allocated with
WQ_UNBOUND flag. Enabling CONFIG_WQ_POWER_EFFICIENT will set
'wq_power_efficient' to 'true'. Setting 'power_efficient' boot param will
override value of 'wq_power_efficient' variable. When 'wq_power_efficient' is
set to 'true', we will convert WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq
allocation. And so scheduler will have the liberty to choose where to run this
work.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/kernel-parameters.txt | 17 +++++++++++++++++
 include/linux/workqueue.h           |  3 +++
 kernel/power/Kconfig                | 19 +++++++++++++++++++
 kernel/workqueue.c                  | 11 +++++++++++
 4 files changed, 50 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c4fa000..a9040fa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3312,6 +3312,23 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that this also can be controlled per-workqueue for
 			workqueues visible under /sys/bus/workqueue/.
 
+	workqueue.power_efficient
+			Workqueues can be performance or power oriented. For
+			performance we may want to keep them running on a single
+			cpu, so that it remains cache hot. For power we can give
+			scheduler the liberty to choose target cpu for running
+			work handler.
+
+			Later one (Power oriented WQ) can be achieved if the
+			workqueue is allocated with WQ_UNBOUND flag. Enabling
+			CONFIG_WQ_POWER_EFFICIENT will set 'wq_power_efficient'
+			to 'true'. Setting 'power_efficient' boot param will
+			override value of 'wq_power_efficient' variable. When
+			'wq_power_efficient' is set to 'true', we will convert
+			WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq allocation.
+			And so scheduler will have the liberty to choose where
+			to run this work.
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..83fa570 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -302,6 +302,9 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
+	WQ_POWER_EFFICIENT	= 1 << 7, /* WQ_UNBOUND, for power
+					   * saving, if wq_power_efficient is
+					   * enabled. Unused otherwise. */
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5dfdc9e..e1e9c8b 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -263,6 +263,25 @@ config PM_GENERIC_DOMAINS
 	bool
 	depends on PM
 
+config WQ_POWER_EFFICIENT
+	bool "Workqueue allocated as UNBOUND (by default) for power efficiency"
+	depends on PM
+	help
+	  Workqueues can be performance or power oriented. For performance we
+	  may want to keep them running on a single cpu, so that it remains
+	  cache hot. For power we can give scheduler the liberty to choose
+	  target cpu for running work handler.
+
+	  Later one (Power oriented WQ) can be achieved if the workqueue is
+	  allocated with WQ_UNBOUND flag. Enabling CONFIG_WQ_POWER_EFFICIENT
+	  will set 'wq_power_efficient' to 'true'. Setting 'power_efficient'
+	  boot param will override value of 'wq_power_efficient' variable. When
+	  'wq_power_efficient' is set to 'true', we will convert
+	  WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq allocation. And so
+	  scheduler will have the liberty to choose where to run this work.
+
+	  If in doubt, say N.
+
 config PM_GENERIC_DOMAINS_SLEEP
 	def_bool y
 	depends on PM_SLEEP && PM_GENERIC_DOMAINS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4aa9f5b..a327027 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -272,6 +272,14 @@ static cpumask_var_t *wq_numa_possible_cpumask;
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);
 
+#ifdef CONFIG_WQ_POWER_EFFICIENT
+static bool wq_power_efficient = true;
+#else
+static bool wq_power_efficient;
+#endif
+
+module_param_named(power_efficient, wq_power_efficient, bool, 0444);
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
@@ -4085,6 +4093,9 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
+	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
+		flags |= WQ_UNBOUND;
+
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
 		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
-- 
1.7.12.rc2.18.g61b472e

