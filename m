Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3GIP52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:57:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46058 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3GIPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:37 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 2/9] sched: Redirect update_cpu_power to sched/power.c
Date: Tue,  9 Jul 2013 16:55:31 +0100
Message-Id: <1373385338-12983-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:31.0716 (UTC) FILETIME=[BD9C5C40:01CE7CBC]
X-MC-Unique: 113070916553506801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FvmEc011653

With CONFIG_SCHED_POWER enabled, update_cpu_power() gets the capacity
managed cpu_power from the power scheduler instead of
arch_scale_freq_power().

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/fair.c  |   19 ++++++++++---------
 kernel/sched/sched.h |   24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..01f1f26 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3214,6 +3214,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 					tsk_cpus_allowed(p)))
 			continue;
 
+		/* Group restricted by power scheduler (cpu_power=1) */
+		if (!power_group_balance(group))
+			continue;
+
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 
@@ -3258,6 +3262,11 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
+
+		/* Skip cpus disabled by power scheduler */
+		if (!power_cpu_balance(i))
+			continue;
+
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -4265,11 +4274,6 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
-{
-	return SCHED_POWER_SCALE;
-}
-
 unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return default_scale_freq_power(sd, cpu);
@@ -4336,10 +4340,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 
 	sdg->sgp->power_orig = power;
 
-	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
-	else
-		power *= default_scale_freq_power(sd, cpu);
+	power *= power_sched_cpu_power(sd, cpu);
 
 	power >>= SCHED_POWER_SHIFT;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..2e62faa 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1377,3 +1377,27 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+static inline unsigned long default_scale_freq_power(struct sched_domain *sd,
+							int cpu)
+{
+	return SCHED_POWER_SCALE;
+}
+
+extern unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu);
+
+#ifdef CONFIG_SCHED_POWER
+extern unsigned long power_sched_cpu_power(struct sched_domain *sd, int cpu);
+#define power_cpu_balance(cpu)		(cpu_rq(cpu)->cpu_power > 1)
+#define power_group_balance(group)	(group->sgp->power > group->group_weight)
+#else
+static inline unsigned long power_sched_cpu_power(struct sched_domain *sd,
+							int cpu)
+{
+	if (sched_feat(ARCH_POWER))
+		return arch_scale_freq_power(sd, cpu);
+	return default_scale_freq_power(sd, cpu);
+}
+#define power_cpu_balance(cpu)		1
+#define power_group_balance(group)	1
+#endif
-- 
1.7.9.5


