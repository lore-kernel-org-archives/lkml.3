Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JKRTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:19:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48765 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3JKRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:34 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 7/7] sched: power: Let the power driver choose the best wake-up cpu
Date: Fri, 11 Oct 2013 18:19:17 +0100
Message-Id: <1381511957-29776-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:31.0129 (UTC) FILETIME=[0C2A4290:01CEC6A6]
X-MC-Unique: 113101118193200201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHKLTD031573

Adds best_wake_cpu() to the power driver interface allowing the power
driver to influence which cpu will be woken up when additional cpus
are needed. Currently only a place holder until idle interface is in
place.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/cpufreq_schedpower.c |   11 +++++++++++
 include/linux/sched/power.h          |    2 ++
 kernel/sched/fair.c                  |    5 ++++-
 kernel/sched/power.c                 |    9 +++++++++
 kernel/sched/sched.h                 |    6 ++++++
 5 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_schedpower.c b/drivers/cpufreq/cpufreq_schedpower.c
index 5952c79..62847ca 100644
--- a/drivers/cpufreq/cpufreq_schedpower.c
+++ b/drivers/cpufreq/cpufreq_schedpower.c
@@ -187,6 +187,16 @@ int pdriver_go_slower(int cpu, int hint)
 	return 1;
 }
 
+int pdriver_best_wake_cpu(void)
+{
+	/*
+	 * Place holder. Should ideally determine the best cpu to wake up
+	 * when more cpus are needed. This may be based on coupled C-states,
+	 * power domains, and other platform specific factors.
+	 */
+	return nr_cpu_ids;
+}
+
 void pdriver_late_callback(int cpu)
 {
 	struct cpufreq_schedpower_cpuinfo *pcpu_info;
@@ -202,6 +212,7 @@ static struct power_driver pdriver = {
 	.at_max_capacity	= pdriver_at_max_capacity,
 	.go_faster		= pdriver_go_faster,
 	.go_slower		= pdriver_go_slower,
+	.best_wake_cpu		= pdriver_best_wake_cpu,
 	.late_callback		= pdriver_late_callback,
 };
 
diff --git a/include/linux/sched/power.h b/include/linux/sched/power.h
index aba5f47..5d76f44 100644
--- a/include/linux/sched/power.h
+++ b/include/linux/sched/power.h
@@ -25,6 +25,8 @@ struct power_driver {
 	int (*go_faster)	(int cpu, int hint);
 	/* Decrease cpu capacity hint */
 	int (*go_slower)	(int cpu, int hint);
+	/* Best cpu to wake up */
+	int (*best_wake_cpu)	(void);
 
 	/* Scheduler call-back without rq lock held and with irq enabled */
 	void (*late_callback)	(int cpu);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ee87e65..d32fb97 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5458,7 +5458,10 @@ static struct {
 
 static inline int find_new_ilb(int call_cpu)
 {
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int ilb = best_wake_cpu();
+
+	if (ilb >= nr_cpu_ids)
+		ilb = cpumask_first(nohz.idle_cpus_mask);
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
diff --git a/kernel/sched/power.c b/kernel/sched/power.c
index f70b563..e1357d2 100644
--- a/kernel/sched/power.c
+++ b/kernel/sched/power.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/cpumask.h>
 #include <linux/sched/power.h>
 
 static struct power_driver *power_driver;
@@ -56,6 +57,14 @@ int go_slower(int cpu, int hint)
 	return power_driver->go_slower(cpu, hint);
 }
 
+int best_wake_cpu(void)
+{
+	if (!power_driver)
+		return nr_cpu_ids;
+
+	return power_driver->best_wake_cpu();
+}
+
 void power_late_callback(int cpu)
 {
 	if (!power_driver)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88e7968..a368734 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1370,6 +1370,7 @@ extern void power_late_callback(int cpu);
 extern int at_max_capacity(int cpu);
 extern int go_faster(int cpu, int hint);
 extern int go_slower(int cpu, int hint);
+extern int best_wake_cpu(void);
 #else
 static inline void power_late_callback(int cpu)
 {
@@ -1389,4 +1390,9 @@ static inline int go_slower(int cpu, int hint)
 {
 	return 0;
 }
+
+static inline int best_wake_cpu(void)
+{
+	return nr_cpu_ids;
+}
 #endif /* CONFIG_SCHED_POWER */
-- 
1.7.9.5


