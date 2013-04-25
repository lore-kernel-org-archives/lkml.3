Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab3DYRZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:25:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53143 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014Ab3DYRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:25:01 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 06/14] sched: add a knob to choose the packing level
Date: Thu, 25 Apr 2013 19:23:22 +0200
Message-Id: <1366910611-20048-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 packing levels:
- the default one only packs the small tasks when the system is not busy
- the none level doesn't pack anything
- the full level uses as few as possible number of CPUs based on the current
  activity of the system

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched/sysctl.h |    8 ++++++++
 kernel/sched/fair.c          |   12 ++++++++++++
 kernel/sysctl.c              |   13 +++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..b72a8b8 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -44,6 +44,14 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+enum sched_tunable_packing {
+	SCHED_PACKING_NONE,
+	SCHED_PACKING_DEFAULT,
+	SCHED_PACKING_FULL,
+};
+
+extern enum sched_tunable_packing __read_mostly sysctl_sched_packing_mode;
+
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a985c98..98166aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -113,6 +113,18 @@ unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
+#ifdef CONFIG_SMP
+/*
+ * The packing policy of the scheduler
+ *
+ * Options are:
+ * SCHED_PACKING_NONE - No buddy is used for packing some tasks
+ * SCHED_PACKING_DEFAULT - The small tasks are packed on a not busy CPUs
+ * SCHED_PACKING_FULL - All Tasks are packed in a minimum number of CPUs
+ */
+enum sched_tunable_packing sysctl_sched_packing_mode = SCHED_PACKING_DEFAULT;
+
+#endif
 /*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index afc1dc6..ca22f59 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -265,6 +265,8 @@ static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #ifdef CONFIG_SMP
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
+static int min_sched_packing_mode = SCHED_PACKING_NONE;
+static int max_sched_packing_mode = SCHED_PACKING_FULL-1;
 #endif /* CONFIG_SMP */
 #endif /* CONFIG_SCHED_DEBUG */
 
@@ -281,6 +283,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_packing_mode",
+		.data		= &sysctl_sched_packing_mode,
+		.maxlen		= sizeof(enum sched_tunable_packing),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &min_sched_packing_mode,
+		.extra2		= &max_sched_packing_mode,
+	},
+#endif
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.procname	= "sched_min_granularity_ns",
-- 
1.7.9.5

