Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3J2N0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:26:41 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55507 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab3J2N0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:26:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 2/2] cpufreq: move freq change notifications to cpufreq core
Date: Tue, 29 Oct 2013 18:56:07 +0530
Message-Id: <bdf186a90415948235c14fcffed8f321fd1fbf4c.1383052613.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383052613.git.viresh.kumar@linaro.org>
References: <cover.1383052613.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383052613.git.viresh.kumar@linaro.org>
References: <cover.1383052613.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

There are few special cases though, like exynos5440, which doesn't do everything
on the call to ->target_index() routine and call some kind of bottom halves for
doing this work, work/tasklet/etc..

They may continue doing notification from their own code as flag:
CPUFREQ_ASYNC_NOTIFICATION is already set for them.

All drivers are also modified in this patch to avoid breaking 'git bisect', as
double notification would happen otherwise.

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Russell King <linux@arm.linux.org.uk>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c         | 14 ++-------
 drivers/cpufreq/arm_big_little.c       | 25 ++--------------
 drivers/cpufreq/at32ap-cpufreq.c       | 22 ++++++--------
 drivers/cpufreq/blackfin-cpufreq.c     | 22 +++++---------
 drivers/cpufreq/cpufreq-cpu0.c         | 33 ++++++++-------------
 drivers/cpufreq/cpufreq.c              | 40 +++++++++++++++++++++++--
 drivers/cpufreq/cris-artpec3-cpufreq.c |  8 -----
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  8 -----
 drivers/cpufreq/davinci-cpufreq.c      | 30 +++++++------------
 drivers/cpufreq/dbx500-cpufreq.c       | 22 +-------------
 drivers/cpufreq/e_powersaver.c         | 23 ++-------------
 drivers/cpufreq/elanfreq.c             | 13 --------
 drivers/cpufreq/exynos-cpufreq.c       | 28 +++++-------------
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 19 ------------
 drivers/cpufreq/imx6q-cpufreq.c        | 37 ++++++++++-------------
 drivers/cpufreq/kirkwood-cpufreq.c     | 54 +++++++++++++---------------------
 drivers/cpufreq/loongson2_cpufreq.c    | 16 ----------
 drivers/cpufreq/maple-cpufreq.c        | 18 +-----------
 drivers/cpufreq/omap-cpufreq.c         | 38 ++++++++----------------
 drivers/cpufreq/p4-clockmod.c          | 10 -------
 drivers/cpufreq/pasemi-cpufreq.c       | 14 +--------
 drivers/cpufreq/pmac32-cpufreq.c       | 20 +++----------
 drivers/cpufreq/pmac64-cpufreq.c       | 18 +-----------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 19 +-----------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 19 +-----------
 drivers/cpufreq/pxa2xx-cpufreq.c       | 27 ++++-------------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 12 --------
 drivers/cpufreq/s3c2416-cpufreq.c      | 21 +++----------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 48 ++++++++++--------------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 16 ++++------
 drivers/cpufreq/sa1100-cpufreq.c       | 17 ++++-------
 drivers/cpufreq/sa1110-cpufreq.c       | 12 ++------
 drivers/cpufreq/sc520_freq.c           | 11 -------
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  7 -----
 drivers/cpufreq/sparc-us3-cpufreq.c    |  7 -----
 drivers/cpufreq/spear-cpufreq.c        | 13 +-------
 drivers/cpufreq/speedstep-centrino.c   | 21 +------------
 drivers/cpufreq/speedstep-ich.c        |  9 ------
 drivers/cpufreq/speedstep-smi.c        |  7 -----
 drivers/cpufreq/tegra-cpufreq.c        | 25 ++++------------
 40 files changed, 196 insertions(+), 627 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index e4bc195..caf41eb 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -428,14 +428,10 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 	struct acpi_processor_performance *perf;
-	struct cpufreq_freqs freqs;
 	struct drv_cmd cmd;
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	int result = 0;
 
-	pr_debug("acpi_cpufreq_target %d (%d)\n",
-			data->freq_table[index].frequency, policy->cpu);
-
 	if (unlikely(data == NULL ||
 	     data->acpi_data == NULL || data->freq_table == NULL)) {
 		return -ENODEV;
@@ -483,23 +479,17 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	else
 		cmd.mask = cpumask_of(policy->cpu);
 
-	freqs.old = perf->states[perf->state].core_frequency * 1000;
-	freqs.new = data->freq_table[index].frequency;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(cmd.mask, freqs.new, data)) {
+		if (!check_freqs(cmd.mask, data->freq_table[index].frequency,
+					data)) {
 			pr_debug("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
 			result = -EAGAIN;
-			freqs.new = freqs.old;
 		}
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	if (!result)
 		perf->state = next_perf_state;
 
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 163e337..6197868 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -51,30 +51,11 @@ static unsigned int bL_cpufreq_get(unsigned int cpu)
 static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	u32 cpu = policy->cpu, cur_cluster;
-	int ret = 0;
+	u32 cur_cluster;
 
 	cur_cluster = cpu_to_cluster(policy->cpu);
-
-	freqs.old = bL_cpufreq_get(policy->cpu);
-	freqs.new = freq_table[cur_cluster][index].frequency;
-
-	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
-			__func__, cpu, cur_cluster, freqs.old, freqs.new,
-			freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
-	if (ret) {
-		pr_err("clk_set_rate failed: %d\n", ret);
-		freqs.new = freqs.old;
-	}
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return clk_set_rate(clk[cur_cluster],
+			freq_table[cur_cluster][index].frequency * 1000);
 }
 
 static void put_cluster_clk_and_freq_table(struct device *cpu_dev)
diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 81d0752..856ad80 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -37,27 +37,23 @@ static unsigned long	loops_per_jiffy_ref;
 
 static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
+	unsigned int old_freq, new_freq;
 
-	freqs.old = at32_get_speed(0);
-	freqs.new = freq_table[index].frequency;
+	old_freq = at32_get_speed(0);
+	new_freq = freq_table[index].frequency;
 
 	if (!ref_freq) {
-		ref_freq = freqs.old;
+		ref_freq = old_freq;
 		loops_per_jiffy_ref = boot_cpu_data.loops_per_jiffy;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	if (freqs.old < freqs.new)
+	if (old_freq < new_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
-				loops_per_jiffy_ref, ref_freq, freqs.new);
-	clk_set_rate(cpuclk, freqs.new * 1000);
-	if (freqs.new < freqs.old)
+				loops_per_jiffy_ref, ref_freq, new_freq);
+	clk_set_rate(cpuclk, new_freq * 1000);
+	if (new_freq < old_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
-				loops_per_jiffy_ref, ref_freq, freqs.new);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: set frequency %u Hz\n", freqs.new * 1000);
+				loops_per_jiffy_ref, ref_freq, new_freq);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 12528b2..e9e63fc 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -132,27 +132,23 @@ static int bfin_target(struct cpufreq_policy *policy, unsigned int index)
 #ifndef CONFIG_BF60x
 	unsigned int plldiv;
 #endif
-	struct cpufreq_freqs freqs;
 	static unsigned long lpj_ref;
 	static unsigned int  lpj_ref_freq;
+	unsigned int old_freq, new_freq;
 	int ret = 0;
 
 #if defined(CONFIG_CYCLES_CLOCKSOURCE)
 	cycles_t cycles;
 #endif
 
-	freqs.old = bfin_getfreq_khz(0);
-	freqs.new = bfin_freq_table[index].frequency;
+	old_freq = bfin_getfreq_khz(0);
+	new_freq = bfin_freq_table[index].frequency;
 
-	pr_debug("cpufreq: changing cclk to %lu; target = %u, oldfreq = %u\n",
-			freqs.new, freqs.new, freqs.old);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 #ifndef CONFIG_BF60x
 	plldiv = (bfin_read_PLL_DIV() & SSEL) | dpm_state_table[index].csel;
 	bfin_write_PLL_DIV(plldiv);
 #else
-	ret = cpu_set_cclk(policy->cpu, freqs.new * 1000);
+	ret = cpu_set_cclk(policy->cpu, new_freq * 1000);
 	if (ret != 0) {
 		WARN_ONCE(ret, "cpufreq set freq failed %d\n", ret);
 		return ret;
@@ -168,17 +164,13 @@ static int bfin_target(struct cpufreq_policy *policy, unsigned int index)
 #endif
 	if (!lpj_ref_freq) {
 		lpj_ref = loops_per_jiffy;
-		lpj_ref_freq = freqs.old;
+		lpj_ref_freq = old_freq;
 	}
-	if (freqs.new != freqs.old) {
+	if (new_freq != old_freq) {
 		loops_per_jiffy = cpufreq_scale(lpj_ref,
-				lpj_ref_freq, freqs.new);
+				lpj_ref_freq, new_freq);
 	}
 
-	/* TODO: just test case for cycles clock source, remove later */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: done\n");
 	return ret;
 }
 
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4dbe7ef..d4585ce 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -37,20 +37,19 @@ static unsigned int cpu0_get_speed(unsigned int cpu)
 
 static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct dev_pm_opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
+	unsigned int old_freq, new_freq;
 	long freq_Hz, freq_exact;
 	int ret;
 
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
 	if (freq_Hz < 0)
 		freq_Hz = freq_table[index].frequency * 1000;
-	freq_exact = freq_Hz;
-	freqs.new = freq_Hz / 1000;
-	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	freq_exact = freq_Hz;
+	new_freq = freq_Hz / 1000;
+	old_freq = clk_get_rate(cpu_clk) / 1000;
 
 	if (!IS_ERR(cpu_reg)) {
 		rcu_read_lock();
@@ -58,9 +57,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
-			freqs.new = freqs.old;
-			ret = PTR_ERR(opp);
-			goto post_notify;
+			return PTR_ERR(opp);
 		}
 		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
@@ -69,16 +66,15 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	}
 
 	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",
-		 freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
-		 freqs.new / 1000, volt ? volt / 1000 : -1);
+		 old_freq / 1000, volt_old ? volt_old / 1000 : -1,
+		 new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
-	if (!IS_ERR(cpu_reg) && freqs.new > freqs.old) {
+	if (!IS_ERR(cpu_reg) && new_freq > old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
@@ -87,23 +83,18 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (!IS_ERR(cpu_reg))
 			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
-		freqs.new = freqs.old;
-		goto post_notify;
+		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
-	if (!IS_ERR(cpu_reg) && freqs.new < freqs.old) {
+	if (!IS_ERR(cpu_reg) && new_freq < old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage down: %d\n", ret);
-			clk_set_rate(cpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
+			clk_set_rate(cpu_clk, old_freq * 1000);
 		}
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return ret;
 }
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6c9cbb9..02d534d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1669,6 +1669,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 	else if (cpufreq_driver->target_index) {
 		struct cpufreq_frequency_table *freq_table;
+		struct cpufreq_freqs freqs;
+		bool notify;
 		int index;
 
 		freq_table = cpufreq_frequency_get_table(policy->cpu);
@@ -1684,10 +1686,42 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			goto out;
 		}
 
-		if (freq_table[index].frequency == policy->cur)
+		if (freq_table[index].frequency == policy->cur) {
 			retval = 0;
-		else
-			retval = cpufreq_driver->target_index(policy, index);
+			goto out;
+		}
+
+		notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
+
+		if (notify) {
+			freqs.old = policy->cur;
+			freqs.new = freq_table[index].frequency;
+			freqs.flags = 0;
+
+			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
+					__func__, policy->cpu, freqs.old,
+					freqs.new);
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_PRECHANGE);
+		}
+
+		retval = cpufreq_driver->target_index(policy, index);
+		if (retval)
+			pr_err("%s: Failed to change cpu frequency: %d\n",
+					__func__, retval);
+
+		if (notify) {
+			/*
+			 * Notify with old freq in case we failed to change
+			 * frequency
+			 */
+			if (retval)
+				freqs.new = freqs.old;
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_POSTCHANGE);
+		}
 	}
 
 out:
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index 841857c..8655904 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -29,15 +29,9 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 
 static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
-	struct cpufreq_freqs freqs;
 	reg_clkgen_rw_clk_ctrl clk_ctrl;
 	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
 
-	freqs.old = cris_freq_get_cpu_frequency(policy->cpu);
-	freqs.new = cris_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_disable();
 
 	/* Even though we may be SMP they will share the same clock
@@ -50,8 +44,6 @@ static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index c58811a..26d940d 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -29,15 +29,9 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 
 static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
-	struct cpufreq_freqs freqs;
 	reg_config_rw_clk_ctrl clk_ctrl;
 	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
 
-	freqs.old = cris_freq_get_cpu_frequency(policy->cpu);
-	freqs.new = cris_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_disable();
 
 	/* Even though we may be SMP they will share the same clock
@@ -50,8 +44,6 @@ static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 1f5d8a5..5e8a854 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -68,46 +68,36 @@ static unsigned int davinci_getspeed(unsigned int cpu)
 
 static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 {
-	int ret = 0;
-	struct cpufreq_freqs freqs;
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
 	struct clk *armclk = cpufreq.armclk;
+	unsigned int old_freq, new_freq;
+	int ret = 0;
 
-	freqs.old = davinci_getspeed(0);
-	freqs.new = pdata->freq_table[idx].frequency;
-
-	dev_dbg(cpufreq.dev, "transition: %u --> %u\n", freqs.old, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	old_freq = davinci_getspeed(0);
+	new_freq = pdata->freq_table[idx].frequency;
 
 	/* if moving to higher frequency, up the voltage beforehand */
-	if (pdata->set_voltage && freqs.new > freqs.old) {
+	if (pdata->set_voltage && new_freq > old_freq) {
 		ret = pdata->set_voltage(idx);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	ret = clk_set_rate(armclk, idx);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (cpufreq.asyncclk) {
 		ret = clk_set_rate(cpufreq.asyncclk, cpufreq.asyncrate);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	/* if moving to lower freq, lower the voltage after lowering freq */
-	if (pdata->set_voltage && freqs.new < freqs.old)
+	if (pdata->set_voltage && new_freq < old_freq)
 		pdata->set_voltage(idx);
 
-out:
-	if (ret)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return 0;
 }
 
 static int davinci_cpu_init(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 238b169..0e67ab9 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -22,28 +22,8 @@ static struct clk *armss_clk;
 static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
 				unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	int ret;
-
-	freqs.old = policy->cur;
-	freqs.new = freq_table[index].frequency;
-
-	/* pre-change notification */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* update armss clk frequency */
-	ret = clk_set_rate(armss_clk, freqs.new * 1000);
-
-	if (ret) {
-		pr_err("dbx500-cpufreq: Failed to set armss_clk to %d Hz: error %d\n",
-		       freqs.new * 1000, ret);
-		freqs.new = freqs.old;
-	}
-
-	/* post change notification */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return clk_set_rate(armss_clk, freq_table[index].frequency * 1000);
 }
 
 static unsigned int dbx500_cpufreq_getspeed(unsigned int cpu)
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index b39c4ef..9012b8b 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -107,15 +107,9 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 			 struct cpufreq_policy *policy,
 			 u32 dest_state)
 {
-	struct cpufreq_freqs freqs;
 	u32 lo, hi;
-	int err = 0;
 	int i;
 
-	freqs.old = eps_get(policy->cpu);
-	freqs.new = centaur->fsb * ((dest_state >> 8) & 0xff);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* Wait while CPU is busy */
 	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 	i = 0;
@@ -124,8 +118,7 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 		i++;
 		if (unlikely(i > 64)) {
-			err = -ENODEV;
-			goto postchange;
+			return -ENODEV;
 		}
 	}
 	/* Set new multiplier and voltage */
@@ -137,16 +130,10 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 		i++;
 		if (unlikely(i > 64)) {
-			err = -ENODEV;
-			goto postchange;
+			return -ENODEV;
 		}
 	} while (lo & ((1 << 16) | (1 << 17)));
 
-	/* Return current frequency */
-postchange:
-	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-	freqs.new = centaur->fsb * ((lo >> 8) & 0xff);
-
 #ifdef DEBUG
 	{
 	u8 current_multiplier, current_voltage;
@@ -161,11 +148,7 @@ postchange:
 		current_multiplier);
 	}
 #endif
-	if (err)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	return err;
+	return 0;
 }
 
 static int eps_target(struct cpufreq_policy *policy, unsigned int index)
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 4ab4153..de08acf 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -108,17 +108,6 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
 static int elanfreq_target(struct cpufreq_policy *policy,
 			    unsigned int state)
 {
-	struct cpufreq_freqs    freqs;
-
-	freqs.old = elanfreq_get_cpu_frequency(0);
-	freqs.new = elan_multiplier[state].clock;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	printk(KERN_INFO "elanfreq: attempting to set frequency to %i kHz\n",
-			elan_multiplier[state].clock);
-
-
 	/*
 	 * Access to the Elan's internal registers is indexed via
 	 * 0x22: Chip Setup & Control Register Index Register (CSCI)
@@ -149,8 +138,6 @@ static int elanfreq_target(struct cpufreq_policy *policy,
 	udelay(10000);
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 /*
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 9982fcb..7b6dc06 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -25,7 +25,6 @@
 static struct exynos_dvfs_info *exynos_info;
 
 static struct regulator *arm_regulator;
-static struct cpufreq_freqs freqs;
 
 static unsigned int locking_frequency;
 static bool frequency_locked;
@@ -59,18 +58,18 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	unsigned int arm_volt, safe_arm_volt = 0;
 	unsigned int mpll_freq_khz = exynos_info->mpll_freq_khz;
+	unsigned int old_freq;
 	int index, old_index;
 	int ret = 0;
 
-	freqs.old = policy->cur;
-	freqs.new = target_freq;
+	old_freq = policy->cur;
 
 	/*
 	 * The policy max have been changed so that we cannot get proper
 	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
 	 * policy and get the index from the raw freqeuncy table.
 	 */
-	old_index = exynos_cpufreq_get_index(freqs.old);
+	old_index = exynos_cpufreq_get_index(old_freq);
 	if (old_index < 0) {
 		ret = old_index;
 		goto out;
@@ -95,17 +94,14 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	}
 	arm_volt = volt_table[index];
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* When the new frequency is higher than current frequency */
-	if ((freqs.new > freqs.old) && !safe_arm_volt) {
+	if ((target_freq > old_freq) && !safe_arm_volt) {
 		/* Firstly, voltage up to increase frequency */
 		ret = regulator_set_voltage(arm_regulator, arm_volt, arm_volt);
 		if (ret) {
 			pr_err("%s: failed to set cpu voltage to %d\n",
 				__func__, arm_volt);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
@@ -115,22 +111,15 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 		if (ret) {
 			pr_err("%s: failed to set cpu voltage to %d\n",
 				__func__, safe_arm_volt);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
 	exynos_info->set_freq(old_index, index);
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	if (ret)
-		goto out;
-
 	/* When the new frequency is lower than current frequency */
-	if ((freqs.new < freqs.old) ||
-	   ((freqs.new > freqs.old) && safe_arm_volt)) {
+	if ((target_freq < old_freq) ||
+	   ((target_freq > old_freq) && safe_arm_volt)) {
 		/* down the voltage after frequency change */
 		ret = regulator_set_voltage(arm_regulator, arm_volt,
 				arm_volt);
@@ -142,7 +131,6 @@ post_notify:
 	}
 
 out:
-
 	cpufreq_cpu_put(policy);
 
 	return ret;
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 4695fa2..53c6ac6 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -141,7 +141,6 @@ processor_set_freq (
 {
 	int			ret = 0;
 	u32			value = 0;
-	struct cpufreq_freqs    cpufreq_freqs;
 	cpumask_t		saved_mask;
 	int			retval;
 
@@ -168,13 +167,6 @@ processor_set_freq (
 	pr_debug("Transitioning from P%d to P%d\n",
 		data->acpi_data.state, state);
 
-	/* cpufreq frequency struct */
-	cpufreq_freqs.old = data->freq_table[data->acpi_data.state].frequency;
-	cpufreq_freqs.new = data->freq_table[state].frequency;
-
-	/* notify cpufreq */
-	cpufreq_notify_transition(policy, &cpufreq_freqs, CPUFREQ_PRECHANGE);
-
 	/*
 	 * First we write the target state's 'control' value to the
 	 * control_register.
@@ -186,22 +178,11 @@ processor_set_freq (
 
 	ret = processor_set_pstate(value);
 	if (ret) {
-		unsigned int tmp = cpufreq_freqs.new;
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_POSTCHANGE);
-		cpufreq_freqs.new = cpufreq_freqs.old;
-		cpufreq_freqs.old = tmp;
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_PRECHANGE);
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_POSTCHANGE);
 		printk(KERN_WARNING "Transition failed with error %d\n", ret);
 		retval = -ENODEV;
 		goto migrate_end;
 	}
 
-	cpufreq_notify_transition(policy, &cpufreq_freqs, CPUFREQ_POSTCHANGE);
-
 	data->acpi_data.state = state;
 
 	retval = 0;
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 07af3b0..4b3f18e 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -42,14 +42,14 @@ static unsigned int imx6q_get_speed(unsigned int cpu)
 
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct dev_pm_opp *opp;
 	unsigned long freq_hz, volt, volt_old;
+	unsigned int old_freq, new_freq;
 	int ret;
 
-	freqs.new = freq_table[index].frequency;
-	freq_hz = freqs.new * 1000;
-	freqs.old = clk_get_rate(arm_clk) / 1000;
+	new_freq = freq_table[index].frequency;
+	freq_hz = new_freq * 1000;
+	old_freq = clk_get_rate(arm_clk) / 1000;
 
 	rcu_read_lock();
 	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_hz);
@@ -64,26 +64,23 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 	volt_old = regulator_get_voltage(arm_reg);
 
 	dev_dbg(cpu_dev, "%u MHz, %ld mV --> %u MHz, %ld mV\n",
-		freqs.old / 1000, volt_old / 1000,
-		freqs.new / 1000, volt / 1000);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		old_freq / 1000, volt_old / 1000,
+		new_freq / 1000, volt / 1000);
 
 	/* scaling up?  scale voltage before frequency */
-	if (freqs.new > freqs.old) {
+	if (new_freq > old_freq) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
 		if (ret) {
 			dev_err(cpu_dev,
 				"failed to scale vddarm up: %d\n", ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 
 		/*
 		 * Need to increase vddpu and vddsoc for safety
 		 * if we are about to run at 1.2 GHz.
 		 */
-		if (freqs.new == FREQ_1P2_GHZ / 1000) {
+		if (new_freq == FREQ_1P2_GHZ / 1000) {
 			regulator_set_voltage_tol(pu_reg,
 					PU_SOC_VOLTAGE_HIGH, 0);
 			regulator_set_voltage_tol(soc_reg,
@@ -103,21 +100,20 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 	clk_set_parent(step_clk, pll2_pfd2_396m_clk);
 	clk_set_parent(pll1_sw_clk, step_clk);
 	if (freq_hz > clk_get_rate(pll2_pfd2_396m_clk)) {
-		clk_set_rate(pll1_sys_clk, freqs.new * 1000);
+		clk_set_rate(pll1_sys_clk, new_freq * 1000);
 		clk_set_parent(pll1_sw_clk, pll1_sys_clk);
 	}
 
 	/* Ensure the arm clock divider is what we expect */
-	ret = clk_set_rate(arm_clk, freqs.new * 1000);
+	ret = clk_set_rate(arm_clk, new_freq * 1000);
 	if (ret) {
 		dev_err(cpu_dev, "failed to set clock rate: %d\n", ret);
 		regulator_set_voltage_tol(arm_reg, volt_old, 0);
-		freqs.new = freqs.old;
-		goto post_notify;
+		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
-	if (freqs.new < freqs.old) {
+	if (new_freq < old_freq) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
 		if (ret) {
 			dev_warn(cpu_dev,
@@ -125,7 +121,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 			ret = 0;
 		}
 
-		if (freqs.old == FREQ_1P2_GHZ / 1000) {
+		if (old_freq == FREQ_1P2_GHZ / 1000) {
 			regulator_set_voltage_tol(pu_reg,
 					PU_SOC_VOLTAGE_NORMAL, 0);
 			regulator_set_voltage_tol(soc_reg,
@@ -133,10 +129,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return 0;
 }
 
 static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 0ae4dd7..0767a4e 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -58,48 +58,34 @@ static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
 			    unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	unsigned int state = kirkwood_freq_table[index].driver_data;
 	unsigned long reg;
 
-	freqs.old = kirkwood_cpufreq_get_cpu_frequency(0);
-	freqs.new = kirkwood_freq_table[index].frequency;
+	local_irq_disable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	/* Disable interrupts to the CPU */
+	reg = readl_relaxed(priv.base);
+	reg |= CPU_SW_INT_BLK;
+	writel_relaxed(reg, priv.base);
 
-	dev_dbg(priv.dev, "Attempting to set frequency to %i KHz\n",
-		kirkwood_freq_table[index].frequency);
-	dev_dbg(priv.dev, "old frequency was %i KHz\n",
-		kirkwood_cpufreq_get_cpu_frequency(0));
-
-	if (freqs.old != freqs.new) {
-		local_irq_disable();
-
-		/* Disable interrupts to the CPU */
-		reg = readl_relaxed(priv.base);
-		reg |= CPU_SW_INT_BLK;
-		writel_relaxed(reg, priv.base);
-
-		switch (state) {
-		case STATE_CPU_FREQ:
-			clk_disable(priv.powersave_clk);
-			break;
-		case STATE_DDR_FREQ:
-			clk_enable(priv.powersave_clk);
-			break;
-		}
+	switch (state) {
+	case STATE_CPU_FREQ:
+		clk_disable(priv.powersave_clk);
+		break;
+	case STATE_DDR_FREQ:
+		clk_enable(priv.powersave_clk);
+		break;
+	}
 
-		/* Wait-for-Interrupt, while the hardware changes frequency */
-		cpu_do_idle();
+	/* Wait-for-Interrupt, while the hardware changes frequency */
+	cpu_do_idle();
 
-		/* Enable interrupts to the CPU */
-		reg = readl_relaxed(priv.base);
-		reg &= ~CPU_SW_INT_BLK;
-		writel_relaxed(reg, priv.base);
+	/* Enable interrupts to the CPU */
+	reg = readl_relaxed(priv.base);
+	reg &= ~CPU_SW_INT_BLK;
+	writel_relaxed(reg, priv.base);
 
-		local_irq_enable();
-	}
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	local_irq_enable();
 
 	return 0;
 }
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index 41a8e2c..a436092 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -57,7 +57,6 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 {
 	unsigned int cpu = policy->cpu;
 	cpumask_t cpus_allowed;
-	struct cpufreq_freqs freqs;
 	unsigned int freq;
 
 	cpus_allowed = current->cpus_allowed;
@@ -67,26 +66,11 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	    ((cpu_clock_freq / 1000) *
 	     loongson2_clockmod_table[index].driver_data) / 8;
 
-	pr_debug("cpufreq: requested frequency %u Hz\n",
-			loongson2_clockmod_table[index].frequency * 1000);
-
-	freqs.old = loongson2_cpufreq_get(cpu);
-	freqs.new = freq;
-	freqs.flags = 0;
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
 	clk_set_rate(cpuclk, freq);
 
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: set frequency %u kHz\n", freq);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 4e2da08..c4dfa42 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -69,8 +69,6 @@ static struct cpufreq_frequency_table maple_cpu_freqs[] = {
  */
 static int maple_pmode_cur;
 
-static DEFINE_MUTEX(maple_switch_mutex);
-
 static const u32 *maple_pmode_data;
 static int maple_pmode_max;
 
@@ -133,21 +131,7 @@ static int maple_scom_query_freq(void)
 static int maple_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	int rc;
-
-	mutex_lock(&maple_switch_mutex);
-
-	freqs.old = maple_cpu_freqs[maple_pmode_cur].frequency;
-	freqs.new = maple_cpu_freqs[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = maple_scom_switch_freq(index);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	mutex_unlock(&maple_switch_mutex);
-
-	return rc;
+	return maple_scom_switch_freq(index);
 }
 
 static unsigned int maple_cpufreq_get_speed(unsigned int cpu)
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index b551271..be6d143 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -53,15 +53,14 @@ static unsigned int omap_getspeed(unsigned int cpu)
 
 static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	int r, ret = 0;
-	struct cpufreq_freqs freqs;
 	struct dev_pm_opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
+	unsigned int old_freq, new_freq;
 
-	freqs.old = omap_getspeed(policy->cpu);
-	freqs.new = freq_table[index].frequency;
+	old_freq = omap_getspeed(policy->cpu);
+	new_freq = freq_table[index].frequency;
 
-	freq = freqs.new * 1000;
+	freq = new_freq * 1000;
 	ret = clk_round_rate(mpu_clk, freq);
 	if (IS_ERR_VALUE(ret)) {
 		dev_warn(mpu_dev,
@@ -77,7 +76,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			dev_err(mpu_dev, "%s: unable to find MPU OPP for %d\n",
-				__func__, freqs.new);
+				__func__, new_freq);
 			return -EINVAL;
 		}
 		volt = dev_pm_opp_get_voltage(opp);
@@ -87,43 +86,32 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 	}
 
 	dev_dbg(mpu_dev, "cpufreq-omap: %u MHz, %ld mV --> %u MHz, %ld mV\n", 
-		freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
-		freqs.new / 1000, volt ? volt / 1000 : -1);
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		old_freq / 1000, volt_old ? volt_old / 1000 : -1,
+		new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
-	if (mpu_reg && (freqs.new > freqs.old)) {
+	if (mpu_reg && (new_freq > old_freq)) {
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
 				 __func__);
-			freqs.new = freqs.old;
-			goto done;
+			return r;
 		}
 	}
 
-	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
+	ret = clk_set_rate(mpu_clk, new_freq * 1000);
 
 	/* scaling down?  scale voltage after frequency */
-	if (mpu_reg && (freqs.new < freqs.old)) {
+	if (mpu_reg && (new_freq < old_freq)) {
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
 				 __func__);
-			ret = clk_set_rate(mpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
-			goto done;
+			clk_set_rate(mpu_clk, old_freq * 1000);
+			return r;
 		}
 	}
 
-	freqs.new = omap_getspeed(policy->cpu);
-
-done:
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return ret;
 }
 
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 3c23053..3d1cba9 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -107,15 +107,8 @@ static struct cpufreq_frequency_table p4clockmod_table[] = {
 
 static int cpufreq_p4_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	int i;
 
-	freqs.old = cpufreq_p4_get(policy->cpu);
-	freqs.new = stock_freq * p4clockmod_table[index].driver_data / 8;
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* run on each logical CPU,
 	 * see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
@@ -123,9 +116,6 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy, unsigned int index)
 	for_each_cpu(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[index].driver_data);
 
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 17424dd..1c33136 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -51,8 +51,6 @@
 static void __iomem *sdcpwr_mapbase;
 static void __iomem *sdcasr_mapbase;
 
-static DEFINE_MUTEX(pas_switch_mutex);
-
 /* Current astate, is used when waking up from power savings on
  * one core, in case the other core has switched states during
  * the idle time.
@@ -242,15 +240,8 @@ static int pas_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 static int pas_cpufreq_target(struct cpufreq_policy *policy,
 			      unsigned int pas_astate_new)
 {
-	struct cpufreq_freqs freqs;
 	int i;
 
-	freqs.old = policy->cur;
-	freqs.new = pas_freqs[pas_astate_new].frequency;
-
-	mutex_lock(&pas_switch_mutex);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	pr_debug("setting frequency for cpu %d to %d kHz, 1/%d of max frequency\n",
 		 policy->cpu,
 		 pas_freqs[pas_astate_new].frequency,
@@ -261,10 +252,7 @@ static int pas_cpufreq_target(struct cpufreq_policy *policy,
 	for_each_online_cpu(i)
 		set_astate(i, pas_astate_new);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&pas_switch_mutex);
-
-	ppc_proc_freq = freqs.new * 1000ul;
+	ppc_proc_freq = pas_freqs[pas_astate_new].frequency * 1000ul;
 	return 0;
 }
 
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 05f705e..cf55d20 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -331,21 +331,11 @@ static int pmu_set_cpu_speed(int low_speed)
 	return 0;
 }
 
-static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode,
-		int notify)
+static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode)
 {
-	struct cpufreq_freqs freqs;
 	unsigned long l3cr;
 	static unsigned long prev_l3cr;
 
-	freqs.old = cur_freq;
-	freqs.new = (speed_mode == CPUFREQ_HIGH) ? hi_freq : low_freq;
-
-	if (freqs.old == freqs.new)
-		return 0;
-
-	if (notify)
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 	if (speed_mode == CPUFREQ_LOW &&
 	    cpu_has_feature(CPU_FTR_L3CR)) {
 		l3cr = _get_L3CR();
@@ -361,8 +351,6 @@ static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode,
 		if ((prev_l3cr & L3CR_L3E) && l3cr != prev_l3cr)
 			_set_L3CR(prev_l3cr);
 	}
-	if (notify)
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	cur_freq = (speed_mode == CPUFREQ_HIGH) ? hi_freq : low_freq;
 
 	return 0;
@@ -378,7 +366,7 @@ static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
 {
 	int		rc;
 
-	rc = do_set_cpu_speed(policy, index, 1);
+	rc = do_set_cpu_speed(policy, index);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 	return rc;
@@ -420,7 +408,7 @@ static int pmac_cpufreq_suspend(struct cpufreq_policy *policy)
 	no_schedule = 1;
 	sleep_freq = cur_freq;
 	if (cur_freq == low_freq && !is_pmu_based)
-		do_set_cpu_speed(policy, CPUFREQ_HIGH, 0);
+		do_set_cpu_speed(policy, CPUFREQ_HIGH);
 	return 0;
 }
 
@@ -437,7 +425,7 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 	 * probably high speed due to our suspend() routine
 	 */
 	do_set_cpu_speed(policy, sleep_freq == low_freq ?
-			 CPUFREQ_LOW : CPUFREQ_HIGH, 0);
+			 CPUFREQ_LOW : CPUFREQ_HIGH);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 234b598..6a338f8 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -79,8 +79,6 @@ static void (*g5_switch_volt)(int speed_mode);
 static int (*g5_switch_freq)(int speed_mode);
 static int (*g5_query_freq)(void);
 
-static DEFINE_MUTEX(g5_switch_mutex);
-
 static unsigned long transition_latency;
 
 #ifdef CONFIG_PMAC_SMU
@@ -314,21 +312,7 @@ static int g5_pfunc_query_freq(void)
 
 static int g5_cpufreq_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	int rc;
-
-	mutex_lock(&g5_switch_mutex);
-
-	freqs.old = g5_cpu_freqs[g5_pmode_cur].frequency;
-	freqs.new = g5_cpu_freqs[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = g5_switch_freq(index);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	mutex_unlock(&g5_switch_mutex);
-
-	return rc;
+	return g5_switch_freq(index);
 }
 
 static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 79d8e9c..3f7be46 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -69,8 +69,6 @@ static const struct soc_data sdata[] = {
 static u32 min_cpufreq;
 static const u32 *fmask;
 
-/* serialize frequency changes  */
-static DEFINE_MUTEX(cpufreq_lock);
 static DEFINE_PER_CPU(struct cpu_data *, cpu_data);
 
 /* cpumask in a cluster */
@@ -253,26 +251,11 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 static int corenet_cpufreq_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct clk *parent;
-	int ret;
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 
-	freqs.old = policy->cur;
-	freqs.new = data->table[index].frequency;
-
-	mutex_lock(&cpufreq_lock);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	parent = of_clk_get(data->parent, data->table[index].driver_data);
-	ret = clk_set_parent(data->clk, parent);
-	if (ret)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&cpufreq_lock);
-
-	return ret;
+	return clk_set_parent(data->clk, parent);
 }
 
 static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 52f707d..e42ca9c 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -30,9 +30,6 @@
 
 #include "ppc_cbe_cpufreq.h"
 
-static DEFINE_MUTEX(cbe_switch_mutex);
-
-
 /* the CBE supports an 8 step frequency scaling */
 static struct cpufreq_frequency_table cbe_freqs[] = {
 	{1,	0},
@@ -131,27 +128,13 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 			      unsigned int cbe_pmode_new)
 {
-	int rc;
-	struct cpufreq_freqs freqs;
-
-	freqs.old = policy->cur;
-	freqs.new = cbe_freqs[cbe_pmode_new].frequency;
-
-	mutex_lock(&cbe_switch_mutex);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	pr_debug("setting frequency for cpu %d to %d kHz, " \
 		 "1/%d of max frequency\n",
 		 policy->cpu,
 		 cbe_freqs[cbe_pmode_new].frequency,
 		 cbe_freqs[cbe_pmode_new].driver_data);
 
-	rc = set_pmode(policy->cpu, cbe_pmode_new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&cbe_switch_mutex);
-
-	return rc;
+	return set_pmode(policy->cpu, cbe_pmode_new);
 }
 
 static struct cpufreq_driver cbe_cpufreq_driver = {
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 183bc13..0a0f436 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -271,7 +271,6 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	struct cpufreq_frequency_table *pxa_freqs_table;
 	pxa_freqs_t *pxa_freq_settings;
-	struct cpufreq_freqs freqs;
 	unsigned long flags;
 	unsigned int new_freq_cpu, new_freq_mem;
 	unsigned int unused, preset_mdrefr, postset_mdrefr, cclkcfg;
@@ -282,24 +281,17 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 
 	new_freq_cpu = pxa_freq_settings[idx].khz;
 	new_freq_mem = pxa_freq_settings[idx].membus;
-	freqs.old = policy->cur;
-	freqs.new = new_freq_cpu;
 
 	if (freq_debug)
 		pr_debug("Changing CPU frequency to %d Mhz, (SDRAM %d Mhz)\n",
-			 freqs.new / 1000, (pxa_freq_settings[idx].div2) ?
+			 new_freq_cpu / 1000, (pxa_freq_settings[idx].div2) ?
 			 (new_freq_mem / 2000) : (new_freq_mem / 1000));
 
-	if (vcc_core && freqs.new > freqs.old)
+	if (vcc_core && new_freq_cpu > policy->cur) {
 		ret = pxa_cpufreq_change_voltage(&pxa_freq_settings[idx]);
-	if (ret)
-		return ret;
-	/*
-	 * Tell everyone what we're about to do...
-	 * you should add a notify client with any platform specific
-	 * Vcc changing capability
-	 */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		if (ret)
+			return ret;
+	}
 
 	/* Calculate the next MDREFR.  If we're slowing down the SDRAM clock
 	 * we need to preset the smaller DRI before the change.	 If we're
@@ -350,13 +342,6 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 	local_irq_restore(flags);
 
 	/*
-	 * Tell everyone what we've just done...
-	 * you should add a notify client with any platform specific
-	 * SDRAM refresh timer adjustments
-	 */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	/*
 	 * Even if voltage setting fails, we don't report it, as the frequency
 	 * change succeeded. The voltage reduction is not a critical failure,
 	 * only power savings will suffer from this.
@@ -365,7 +350,7 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 	 * bug is triggered (seems a deadlock). Should anybody find out where,
 	 * the "return 0" should become a "return ret".
 	 */
-	if (vcc_core && freqs.new < freqs.old)
+	if (vcc_core && new_freq_cpu < policy->cur)
 		ret = pxa_cpufreq_change_voltage(&pxa_freq_settings[idx]);
 
 	return 0;
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 132e37d..9384004 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -158,7 +158,6 @@ static unsigned int pxa3xx_cpufreq_get(unsigned int cpu)
 static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct pxa3xx_freq_info *next;
-	struct cpufreq_freqs freqs;
 	unsigned long flags;
 
 	if (policy->cpu != 0)
@@ -166,22 +165,11 @@ static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy, unsigned int index)
 
 	next = &pxa3xx_freqs[index];
 
-	freqs.old = policy->cur;
-	freqs.new = next->cpufreq_mhz * 1000;
-
-	pr_debug("CPU frequency from %d MHz to %d MHz%s\n",
-			freqs.old / 1000, freqs.new / 1000,
-			(freqs.old == freqs.new) ? " (skipped)" : "");
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_save(flags);
 	__update_core_freq(next);
 	__update_bus_freq(next);
 	local_irq_restore(flags);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4188acc..8d904a0 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -220,7 +220,7 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-	struct cpufreq_freqs freqs;
+	unsigned int new_freq;
 	int idx, ret, to_dvs = 0;
 
 	mutex_lock(&cpufreq_lock);
@@ -237,25 +237,14 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	freqs.flags = 0;
-	freqs.old = s3c_freq->is_dvs ? FREQ_DVS
-				     : clk_get_rate(s3c_freq->armclk) / 1000;
-
 	/* When leavin dvs mode, always switch the armdiv to the hclk rate
 	 * The S3C2416 has stability issues when switching directly to
 	 * higher frequencies.
 	 */
-	freqs.new = (s3c_freq->is_dvs && !to_dvs)
+	new_freq = (s3c_freq->is_dvs && !to_dvs)
 				? clk_get_rate(s3c_freq->hclk) / 1000
 				: s3c_freq->freq_table[index].frequency;
 
-	pr_debug("cpufreq: Transition %d-%dkHz\n", freqs.old, freqs.new);
-
-	if (!to_dvs && freqs.old == freqs.new)
-		goto out;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	if (to_dvs) {
 		pr_debug("cpufreq: enter dvs\n");
 		ret = s3c2416_cpufreq_enter_dvs(s3c_freq, idx);
@@ -263,12 +252,10 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 		pr_debug("cpufreq: leave dvs\n");
 		ret = s3c2416_cpufreq_leave_dvs(s3c_freq, idx);
 	} else {
-		pr_debug("cpufreq: change armdiv to %dkHz\n", freqs.new);
-		ret = s3c2416_cpufreq_set_armdiv(s3c_freq, freqs.new);
+		pr_debug("cpufreq: change armdiv to %dkHz\n", new_freq);
+		ret = s3c2416_cpufreq_set_armdiv(s3c_freq, new_freq);
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 out:
 	mutex_unlock(&cpufreq_lock);
 
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 8bdcf32..67e302e 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -65,54 +65,46 @@ static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
-	int ret;
-	struct cpufreq_freqs freqs;
 	struct s3c64xx_dvfs *dvfs;
+	unsigned int old_freq, new_freq;
+	int ret;
 
-	freqs.old = clk_get_rate(armclk) / 1000;
-	freqs.new = s3c64xx_freq_table[index].frequency;
-	freqs.flags = 0;
+	old_freq = clk_get_rate(armclk) / 1000;
+	new_freq = s3c64xx_freq_table[index].frequency;
 	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
-	pr_debug("Transition %d-%dkHz\n", freqs.old, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 #ifdef CONFIG_REGULATOR
-	if (vddarm && freqs.new > freqs.old) {
+	if (vddarm && new_freq > old_freq) {
 		ret = regulator_set_voltage(vddarm,
 					    dvfs->vddarm_min,
 					    dvfs->vddarm_max);
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
-			       freqs.new, ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			       new_freq, ret);
+			return ret;
 		}
 	}
 #endif
 
-	ret = clk_set_rate(armclk, freqs.new * 1000);
+	ret = clk_set_rate(armclk, new_freq * 1000);
 	if (ret < 0) {
 		pr_err("Failed to set rate %dkHz: %d\n",
-		       freqs.new, ret);
-		freqs.new = freqs.old;
+		       new_freq, ret);
+		return ret;
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	if (ret)
-		goto err;
-
 #ifdef CONFIG_REGULATOR
-	if (vddarm && freqs.new < freqs.old) {
+	if (vddarm && new_freq < old_freq) {
 		ret = regulator_set_voltage(vddarm,
 					    dvfs->vddarm_min,
 					    dvfs->vddarm_max);
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
-			       freqs.new, ret);
-			goto err_clk;
+			       new_freq, ret);
+			if (clk_set_rate(armclk, old_freq * 1000) < 0)
+				pr_err("Failed to restore original clock rate\n");
+
+			return ret;
 		}
 	}
 #endif
@@ -121,14 +113,6 @@ post_notify:
 		 clk_get_rate(armclk) / 1000);
 
 	return 0;
-
-err_clk:
-	if (clk_set_rate(armclk, freqs.old * 1000) < 0)
-		pr_err("Failed to restore original clock rate\n");
-err:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
 }
 
 #ifdef CONFIG_REGULATOR
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 5978b94..e3973da 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -26,7 +26,6 @@
 static struct clk *cpu_clk;
 static struct clk *dmc0_clk;
 static struct clk *dmc1_clk;
-static struct cpufreq_freqs freqs;
 static DEFINE_MUTEX(set_freq_lock);
 
 /* APLL M,P,S values for 1G/800Mhz */
@@ -179,6 +178,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	unsigned int priv_index;
 	unsigned int pll_changing = 0;
 	unsigned int bus_speed_changing = 0;
+	unsigned int old_freq, new_freq;
 	int arm_volt, int_volt;
 	int ret = 0;
 
@@ -193,12 +193,12 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		goto exit;
 	}
 
-	freqs.old = s5pv210_getspeed(0);
-	freqs.new = s5pv210_freq_table[index].frequency;
+	old_freq = s5pv210_getspeed(0);
+	new_freq = s5pv210_freq_table[index].frequency;
 
 	/* Finding current running level index */
 	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
-					   freqs.old, CPUFREQ_RELATION_H,
+					   old_freq, CPUFREQ_RELATION_H,
 					   &priv_index)) {
 		ret = -EINVAL;
 		goto exit;
@@ -207,7 +207,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	arm_volt = dvs_conf[index].arm_volt;
 	int_volt = dvs_conf[index].int_volt;
 
-	if (freqs.new > freqs.old) {
+	if (new_freq > old_freq) {
 		ret = regulator_set_voltage(arm_regulator,
 				arm_volt, arm_volt_max);
 		if (ret)
@@ -219,8 +219,6 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 			goto exit;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* Check if there need to change PLL */
 	if ((index == L0) || (priv_index == L0))
 		pll_changing = 1;
@@ -431,9 +429,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	if (freqs.new < freqs.old) {
+	if (new_freq < old_freq) {
 		regulator_set_voltage(int_regulator,
 				int_volt, int_volt_max);
 
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index b0da1fe..623da74 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -180,22 +180,17 @@ static void sa1100_update_dram_timings(int current_speed, int new_speed)
 static int sa1100_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	unsigned int cur = sa11x0_getspeed(0);
-	struct cpufreq_freqs freqs;
+	unsigned int new_freq;
 
-	freqs.old = cur;
-	freqs.new = sa11x0_freq_table[ppcr].frequency;
+	new_freq = sa11x0_freq_table[ppcr].frequency;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	if (freqs.new > cur)
-		sa1100_update_dram_timings(cur, freqs.new);
+	if (new_freq > cur)
+		sa1100_update_dram_timings(cur, new_freq);
 
 	PPCR = ppcr;
 
-	if (freqs.new < cur)
-		sa1100_update_dram_timings(cur, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	if (new_freq < cur)
+		sa1100_update_dram_timings(cur, new_freq);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 55b1818c..2c2b2e6 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -232,15 +232,11 @@ sdram_update_refresh(u_int cpu_khz, struct sdram_params *sdram)
 static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	struct sdram_params *sdram = &sdram_params;
-	struct cpufreq_freqs freqs;
 	struct sdram_info sd;
 	unsigned long flags;
 	unsigned int unused;
 
-	freqs.old = sa11x0_getspeed(0);
-	freqs.new = sa11x0_freq_table[ppcr].frequency;
-
-	sdram_calculate_timing(&sd, freqs.new, sdram);
+	sdram_calculate_timing(&sd, sa11x0_freq_table[ppcr].frequency, sdram);
 
 #if 0
 	/*
@@ -259,8 +255,6 @@ static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 	sd.mdcas[2] = 0xaaaaaaaa;
 #endif
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/*
 	 * The clock could be going away for some time.  Set the SDRAMs
 	 * to refresh rapidly (every 64 memory clock cycles).  To get
@@ -305,9 +299,7 @@ static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 	/*
 	 * Now, return the SDRAM refresh back to normal.
 	 */
-	sdram_update_refresh(freqs.new, sdram);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	sdram_update_refresh(sa11x0_freq_table[ppcr].frequency, sdram);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 6c86452..6adb354 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -56,17 +56,8 @@ static unsigned int sc520_freq_get_cpu_frequency(unsigned int cpu)
 static int sc520_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
 
-	struct cpufreq_freqs	freqs;
 	u8 clockspeed_reg;
 
-	freqs.old = sc520_freq_get_cpu_frequency(0);
-	freqs.new = sc520_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	pr_debug("attempting to set frequency to %i kHz\n",
-			sc520_freq_table[state].frequency);
-
 	local_irq_disable();
 
 	clockspeed_reg = *cpuctl & ~0x03;
@@ -74,8 +65,6 @@ static int sc520_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 3bf5b8f..62aa23e 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -251,7 +251,6 @@ static int us2e_freq_target(struct cpufreq_policy *policy, unsigned int index)
 	unsigned long new_bits, new_freq;
 	unsigned long clock_tick, divisor, old_divisor, estar;
 	cpumask_t cpus_allowed;
-	struct cpufreq_freqs freqs;
 
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
@@ -265,16 +264,10 @@ static int us2e_freq_target(struct cpufreq_policy *policy, unsigned int index)
 
 	old_divisor = estar_to_divisor(estar);
 
-	freqs.old = clock_tick / old_divisor;
-	freqs.new = new_freq;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	if (old_divisor != divisor)
 		us2e_transition(estar, new_bits, clock_tick * 1000,
 				old_divisor, divisor);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return 0;
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 2e54d55..724ffbd 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -98,7 +98,6 @@ static int us3_freq_target(struct cpufreq_policy *policy, unsigned int index)
 	unsigned int cpu = policy->cpu;
 	unsigned long new_bits, new_freq, reg;
 	cpumask_t cpus_allowed;
-	struct cpufreq_freqs freqs;
 
 	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
@@ -124,16 +123,10 @@ static int us3_freq_target(struct cpufreq_policy *policy, unsigned int index)
 
 	reg = read_safari_cfg();
 
-	freqs.old = get_current_freq(cpu, reg);
-	freqs.new = new_freq;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	reg &= ~SAFARI_CFG_DIV_MASK;
 	reg |= new_bits;
 	write_safari_cfg(reg);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return 0;
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 11a65be..d02ccd1 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -107,12 +107,10 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 static int spear_cpufreq_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	long newfreq;
 	struct clk *srcclk;
 	int ret, mult = 1;
 
-	freqs.old = spear_cpufreq_get(0);
 	newfreq = spear_cpufreq.freq_tbl[index].frequency * 1000;
 
 	if (of_machine_is_compatible("st,spear1340")) {
@@ -145,23 +143,14 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 		return newfreq;
 	}
 
-	freqs.new = newfreq / 1000;
-	freqs.new /= mult;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	if (mult == 2)
 		ret = spear1340_set_cpu_rate(srcclk, newfreq);
 	else
 		ret = clk_set_rate(spear_cpufreq.clk, newfreq);
 
-	/* Get current rate after clk_set_rate, in case of failure */
-	if (ret) {
+	if (ret)
 		pr_err("CPU Freq: cpu clk_set_rate failed: %d\n", ret);
-		freqs.new = clk_get_rate(spear_cpufreq.clk) / 1000;
-	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	return ret;
 }
 
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index c51ec8c..4e1daca 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -423,9 +423,8 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 static int centrino_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int	msr, oldmsr = 0, h = 0, cpu = policy->cpu;
-	struct cpufreq_freqs	freqs;
 	int			retval = 0;
-	unsigned int		j, first_cpu, tmp;
+	unsigned int		j, first_cpu;
 	struct cpufreq_frequency_table *op_points;
 	cpumask_var_t covered_cpus;
 
@@ -473,16 +472,6 @@ static int centrino_target(struct cpufreq_policy *policy, unsigned int index)
 				goto out;
 			}
 
-			freqs.old = extract_clock(oldmsr, cpu, 0);
-			freqs.new = extract_clock(msr, cpu, 0);
-
-			pr_debug("target=%dkHz old=%d new=%d msr=%04x\n",
-				op_points->frequency, freqs.old, freqs.new,
-				msr);
-
-			cpufreq_notify_transition(policy, &freqs,
-					CPUFREQ_PRECHANGE);
-
 			first_cpu = 0;
 			/* all but 16 LSB are reserved, treat them with care */
 			oldmsr &= ~0xffff;
@@ -497,8 +486,6 @@ static int centrino_target(struct cpufreq_policy *policy, unsigned int index)
 		cpumask_set_cpu(j, covered_cpus);
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	if (unlikely(retval)) {
 		/*
 		 * We have failed halfway through the frequency change.
@@ -509,12 +496,6 @@ static int centrino_target(struct cpufreq_policy *policy, unsigned int index)
 
 		for_each_cpu(j, covered_cpus)
 			wrmsr_on_cpu(j, MSR_IA32_PERF_CTL, oldmsr, h);
-
-		tmp = freqs.new;
-		freqs.new = freqs.old;
-		freqs.old = tmp;
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	}
 	retval = 0;
 
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 707721e..7639b2b 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -258,21 +258,12 @@ static unsigned int speedstep_get(unsigned int cpu)
 static int speedstep_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int policy_cpu;
-	struct cpufreq_freqs freqs;
 
 	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
-	freqs.old = speedstep_get(policy_cpu);
-	freqs.new = speedstep_freqs[index].frequency;
-
-	pr_debug("transiting from %u to %u kHz\n", freqs.old, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	smp_call_function_single(policy_cpu, _speedstep_set_state, &index,
 				 true);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 19446e4..0f5326d 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -241,14 +241,7 @@ static void speedstep_set_state(unsigned int state)
  */
 static int speedstep_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-
-	freqs.old = speedstep_freqs[speedstep_get_state()].frequency;
-	freqs.new = speedstep_freqs[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 	speedstep_set_state(index);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index bd7d89c..f42df7e 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -102,12 +102,8 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 		unsigned long rate)
 {
 	int ret = 0;
-	struct cpufreq_freqs freqs;
 
-	freqs.old = tegra_getspeed(0);
-	freqs.new = rate;
-
-	if (freqs.old == freqs.new)
+	if (tegra_getspeed(0) == rate)
 		return ret;
 
 	/*
@@ -121,21 +117,10 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	else
 		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-#ifdef CONFIG_CPU_FREQ_DEBUG
-	printk(KERN_DEBUG "cpufreq-tegra: transition: %u --> %u\n",
-	       freqs.old, freqs.new);
-#endif
-
-	ret = tegra_cpu_clk_set_rate(freqs.new * 1000);
-	if (ret) {
-		pr_err("cpu-tegra: Failed to set cpu frequency to %d kHz\n",
-			freqs.new);
-		freqs.new = freqs.old;
-	}
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	ret = tegra_cpu_clk_set_rate(rate * 1000);
+	if (ret)
+		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
+			rate);
 
 	return ret;
 }
-- 
1.7.12.rc2.18.g61b472e

