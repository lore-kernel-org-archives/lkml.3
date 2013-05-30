Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3E3VIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:08:01 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58316 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755821Ab3E3VHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:07:53 -0400
Message-ID: <51A7BFA6.3070800@semaphore.gr>
Date: Fri, 31 May 2013 00:07:50 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondemand calculates load in terms of frequency and increases it only
if the load_freq is greater than up_threshold multiplied by current
or average frequency. This seems to produce oscillations of frequency
between min and max because, for example, a relatively small load can
easily saturate minimum frequency and lead the CPU to max. Then, the
CPU will decrease back to min due to a small load_freq.

This patch changes the calculation method of load and target frequency
considering 2 points:
- Load computation should be independent from current or average
measured frequency. For example an absolute load 80% at 100MHz is not
necessarily equivalent to 8% at 1000MHz in the next sampling interval.
- Target frequency should be increased to any value of frequency table
proportional to absolute load, instead to only the max.

The patch also removes the unused code as a result of the above changes.

Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
that middle frequencies are used more, with this patch. Highest
and lowest frequencies were used less by ~9%

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 arch/x86/include/asm/processor.h   | 29 ----------------------
 drivers/cpufreq/Makefile           |  2 +-
 drivers/cpufreq/acpi-cpufreq.c     |  5 ----
 drivers/cpufreq/cpufreq.c          | 21 ----------------
 drivers/cpufreq/cpufreq_governor.c | 10 +-------
 drivers/cpufreq/cpufreq_governor.h |  1 -
 drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++-----------------------
 drivers/cpufreq/mperf.c            | 51 --------------------------------------
 drivers/cpufreq/mperf.h            |  9 -------
 include/linux/cpufreq.h            |  6 -----
 10 files changed, 9 insertions(+), 164 deletions(-)
 delete mode 100644 drivers/cpufreq/mperf.c
 delete mode 100644 drivers/cpufreq/mperf.h

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22224b3..2874a3b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -941,35 +941,6 @@ extern int set_tsc_mode(unsigned int val);
 
 extern u16 amd_get_nb_id(int cpu);
 
-struct aperfmperf {
-	u64 aperf, mperf;
-};
-
-static inline void get_aperfmperf(struct aperfmperf *am)
-{
-	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
-
-	rdmsrl(MSR_IA32_APERF, am->aperf);
-	rdmsrl(MSR_IA32_MPERF, am->mperf);
-}
-
-#define APERFMPERF_SHIFT 10
-
-static inline
-unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
-				    struct aperfmperf *new)
-{
-	u64 aperf = new->aperf - old->aperf;
-	u64 mperf = new->mperf - old->mperf;
-	unsigned long ratio = aperf;
-
-	mperf >>= APERFMPERF_SHIFT;
-	if (mperf)
-		ratio = div64_u64(aperf, mperf);
-
-	return ratio;
-}
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 315b923..4519fb1 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
 # powernow-k8 can load then. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 11b8b4b..0025cdd 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -45,7 +45,6 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
-#include "mperf.h"
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
@@ -842,10 +841,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	/* Check for APERF/MPERF support in hardware */
-	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
-		acpi_cpufreq_driver.getavg = cpufreq_get_measured_perf;
-
 	pr_debug("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
 		pr_debug("     %cP%d: %d MHz, %d mW, %d uS\n",
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..04ceddc 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1502,27 +1502,6 @@ no_policy:
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
-int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
-{
-	int ret = 0;
-
-	if (cpufreq_disabled())
-		return ret;
-
-	if (!cpufreq_driver->getavg)
-		return 0;
-
-	policy = cpufreq_cpu_get(policy->cpu);
-	if (!policy)
-		return -EINVAL;
-
-	ret = cpufreq_driver->getavg(policy, cpu);
-
-	cpufreq_cpu_put(policy);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(__cpufreq_driver_getavg);
-
 /*
  * when "event" is CPUFREQ_GOV_LIMITS
  */
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad..eeab30a 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -97,7 +97,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 	policy = cdbs->cur_policy;
 
-	/* Get Absolute Load (in terms of freq for ondemand gov) */
+	/* Get Absolute Load */
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_common_info *j_cdbs;
 		u64 cur_wall_time, cur_idle_time;
@@ -148,14 +148,6 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 		load = 100 * (wall_time - idle_time) / wall_time;
 
-		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
-			int freq_avg = __cpufreq_driver_getavg(policy, j);
-			if (freq_avg <= 0)
-				freq_avg = policy->cur;
-
-			load *= freq_avg;
-		}
-
 		if (load > max_load)
 			max_load = load;
 	}
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..e899c11 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -169,7 +169,6 @@ struct od_dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int sampling_down_factor;
 	unsigned int up_threshold;
-	unsigned int adj_up_threshold;
 	unsigned int powersave_bias;
 	unsigned int io_is_busy;
 };
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 4b9bb5d..c1e6d3e 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -29,11 +29,9 @@
 #include "cpufreq_governor.h"
 
 /* On-demand governor macros */
-#define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(100000)
-#define MICRO_FREQUENCY_DOWN_DIFFERENTIAL	(3)
 #define MICRO_FREQUENCY_UP_THRESHOLD		(95)
 #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
@@ -159,14 +157,10 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 
 /*
  * Every sampling_rate, we check, if current idle time is less than 20%
- * (default), then we try to increase frequency. Every sampling_rate, we look
- * for the lowest frequency which can sustain the load while keeping idle time
- * over 30%. If such a frequency exist, we try to decrease to this frequency.
- *
- * Any frequency increase takes it to the maximum frequency. Frequency reduction
- * happens at minimum steps of 5% (default) of current frequency
+ * (default), then we try to increase frequency. Else, we adjust the frequency
+ * proportional to load.
  */
-static void od_check_cpu(int cpu, unsigned int load_freq)
+static void od_check_cpu(int cpu, unsigned int load)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
@@ -176,29 +170,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	dbs_info->freq_lo = 0;
 
 	/* Check for frequency increase */
-	if (load_freq > od_tuners->up_threshold * policy->cur) {
+	if (load > od_tuners->up_threshold) {
 		/* If switching to max speed, apply sampling_down_factor */
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
 				od_tuners->sampling_down_factor;
 		dbs_freq_increase(policy, policy->max);
 		return;
-	}
-
-	/* Check for frequency decrease */
-	/* if we cannot reduce the frequency anymore, break out early */
-	if (policy->cur == policy->min)
-		return;
-
-	/*
-	 * The optimal frequency is the frequency that is the lowest that can
-	 * support the current CPU usage without triggering the up policy. To be
-	 * safe, we focus 10 points under the threshold.
-	 */
-	if (load_freq < od_tuners->adj_up_threshold
-			* policy->cur) {
+	} else {
+		/* Calculate the next frequency proportional to load */
 		unsigned int freq_next;
-		freq_next = load_freq / od_tuners->adj_up_threshold;
+		freq_next = load * policy->max / 100;
 
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
@@ -372,9 +354,6 @@ static ssize_t store_up_threshold(struct dbs_data *dbs_data, const char *buf,
 			input < MIN_FREQUENCY_UP_THRESHOLD) {
 		return -EINVAL;
 	}
-	/* Calculate the new adj_up_threshold */
-	od_tuners->adj_up_threshold += input;
-	od_tuners->adj_up_threshold -= od_tuners->up_threshold;
 
 	od_tuners->up_threshold = input;
 	return count;
@@ -523,8 +502,6 @@ static int od_init(struct dbs_data *dbs_data)
 	if (idle_time != -1ULL) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		tuners->up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
-		tuners->adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
-			MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
 		/*
 		 * In nohz/micro accounting case we set the minimum frequency
 		 * not depending on HZ, but fixed (very low). The deferred
@@ -533,8 +510,6 @@ static int od_init(struct dbs_data *dbs_data)
 		dbs_data->min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
 	} else {
 		tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
-		tuners->adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
-			DEF_FREQUENCY_DOWN_DIFFERENTIAL;
 
 		/* For correct statistics, we need 10 ticks for each measure */
 		dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
diff --git a/drivers/cpufreq/mperf.c b/drivers/cpufreq/mperf.c
deleted file mode 100644
index 911e193..0000000
--- a/drivers/cpufreq/mperf.c
+++ /dev/null
@@ -1,51 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
-#include <linux/slab.h>
-
-#include "mperf.h"
-
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
-					unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(cpufreq_get_measured_perf);
-MODULE_LICENSE("GPL");
diff --git a/drivers/cpufreq/mperf.h b/drivers/cpufreq/mperf.h
deleted file mode 100644
index 5dbf295..0000000
--- a/drivers/cpufreq/mperf.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- *  (c) 2010 Advanced Micro Devices, Inc.
- *  Your use of this code is subject to the terms and conditions of the
- *  GNU general public license version 2. See "COPYING" or
- *  http://www.gnu.org/licenses/gpl.html
- */
-
-unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
-					unsigned int cpu);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..60fcb42 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -211,10 +211,6 @@ extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation);
 
-
-extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
-				   unsigned int cpu);
-
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
@@ -254,8 +250,6 @@ struct cpufreq_driver {
 	unsigned int	(*get)	(unsigned int cpu);
 
 	/* optional */
-	unsigned int (*getavg)	(struct cpufreq_policy *policy,
-				 unsigned int cpu);
 	int	(*bios_limit)	(int cpu, unsigned int *limit);
 
 	int	(*exit)		(struct cpufreq_policy *policy);
-- 
1.8.1.4

