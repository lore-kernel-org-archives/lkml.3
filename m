Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3DAM67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54102 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3DAM6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 6/9] cpufreq: Don't check if cpu is online/offline for cpufreq callbacks
Date: Mon,  1 Apr 2013 18:27:46 +0530
Message-Id: <cd771cb37feb4e79172548ed342ad194ee31a384.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq layer doesn't call cpufreq driver's callback for any offline cpu and so
checking that isn't useful.

Lets get rid of it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: linux-mips@linux-mips.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c | 6 ------
 arch/sh/kernel/cpufreq.c                     | 6 ------
 arch/sparc/kernel/us2e_cpufreq.c             | 6 ------
 arch/sparc/kernel/us3_cpufreq.c              | 6 ------
 drivers/cpufreq/p4-clockmod.c                | 3 +--
 drivers/cpufreq/powernow-k8.c                | 3 ---
 drivers/cpufreq/speedstep-centrino.c         | 4 ----
 7 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
index bafda70..8488957 100644
--- a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
+++ b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
@@ -61,9 +61,6 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	struct cpufreq_freqs freqs;
 	unsigned int freq;
 
-	if (!cpu_online(cpu))
-		return -ENODEV;
-
 	cpus_allowed = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
@@ -109,9 +106,6 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	unsigned long rate;
 	int ret;
 
-	if (!cpu_online(policy->cpu))
-		return -ENODEV;
-
 	cpuclk = clk_get(NULL, "cpu_clk");
 	if (IS_ERR(cpuclk)) {
 		printk(KERN_ERR "cpufreq: couldn't get CPU clk\n");
diff --git a/arch/sh/kernel/cpufreq.c b/arch/sh/kernel/cpufreq.c
index 2c7bd94..0fdf64b 100644
--- a/arch/sh/kernel/cpufreq.c
+++ b/arch/sh/kernel/cpufreq.c
@@ -51,9 +51,6 @@ static int sh_cpufreq_target(struct cpufreq_policy *policy,
 	struct device *dev;
 	long freq;
 
-	if (!cpu_online(cpu))
-		return -ENODEV;
-
 	cpus_allowed = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
@@ -111,9 +108,6 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	struct cpufreq_frequency_table *freq_table;
 	struct device *dev;
 
-	if (!cpu_online(cpu))
-		return -ENODEV;
-
 	dev = get_cpu_device(cpu);
 
 	cpuclk = clk_get(dev, "cpu_clk");
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
index abe963d..306ae46 100644
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -234,9 +234,6 @@ static unsigned int us2e_freq_get(unsigned int cpu)
 	cpumask_t cpus_allowed;
 	unsigned long clock_tick, estar;
 
-	if (!cpu_online(cpu))
-		return 0;
-
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
@@ -257,9 +254,6 @@ static void us2e_set_cpu_divider_index(struct cpufreq_policy *policy,
 	cpumask_t cpus_allowed;
 	struct cpufreq_freqs freqs;
 
-	if (!cpu_online(cpu))
-		return;
-
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
index 7ceb9c8..c71ee14 100644
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -82,9 +82,6 @@ static unsigned int us3_freq_get(unsigned int cpu)
 	unsigned long reg;
 	unsigned int ret;
 
-	if (!cpu_online(cpu))
-		return 0;
-
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
@@ -104,9 +101,6 @@ static void us3_set_cpu_divider_index(struct cpufreq_policy *policy,
 	cpumask_t cpus_allowed;
 	struct cpufreq_freqs freqs;
 
-	if (!cpu_online(cpu))
-		return;
-
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 4b2e773..421ef37 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -58,8 +58,7 @@ static int cpufreq_p4_setdc(unsigned int cpu, unsigned int newstate)
 {
 	u32 l, h;
 
-	if (!cpu_online(cpu) ||
-	    (newstate > DC_DISABLE) || (newstate == DC_RESV))
+	if ((newstate > DC_DISABLE) || (newstate == DC_RESV))
 		return -EINVAL;
 
 	rdmsr_on_cpu(cpu, MSR_IA32_THERM_STATUS, &l, &h);
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 52137a3..b828efe 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1102,9 +1102,6 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	struct init_on_cpu init_on_cpu;
 	int rc;
 
-	if (!cpu_online(pol->cpu))
-		return -ENODEV;
-
 	smp_call_function_single(pol->cpu, check_supported_cpu, &rc, 1);
 	if (rc)
 		return -ENODEV;
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 3dbbcc3..618e6f4 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -481,10 +481,6 @@ static int centrino_target (struct cpufreq_policy *policy,
 	for_each_cpu(j, policy->cpus) {
 		int good_cpu;
 
-		/* cpufreq holds the hotplug lock, so we are safe here */
-		if (!cpu_online(j))
-			continue;
-
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
-- 
1.7.12.rc2.18.g61b472e

