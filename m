Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196Ab3HJGxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:53:16 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57844 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161181Ab3HJGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:53:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 44/44] cpufreq: pass suitable index instead of freq to cpufreq_driver->target()
Date: Sat, 10 Aug 2013 12:14:40 +0530
Message-Id: <149222df041360bac7bb58a9f9baa5f5b8277445.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tries to remove code redundancy from cpufreq driver by moving some common
part of them to the core. Each driver calls cpufreq_frequency_table_target() to
get a suitable index for a target frequency and then works on it. Its better to
do this at core level before calling cpufreq driver and hence passing "index"
instead of "target_freq and relation" to cpufreq_driver->target() routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c         | 19 +++++--------------
 drivers/cpufreq/arm_big_little.c       | 15 ++++-----------
 drivers/cpufreq/blackfin-cpufreq.c     | 14 +++-----------
 drivers/cpufreq/cpufreq-cpu0.c         | 14 +-------------
 drivers/cpufreq/cpufreq.c              | 30 +++++++++++++++++++++++++++---
 drivers/cpufreq/cris-artpec3-cpufreq.c | 18 +++---------------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 16 ++--------------
 drivers/cpufreq/davinci-cpufreq.c      | 15 +++------------
 drivers/cpufreq/dbx500-cpufreq.c       | 13 ++-----------
 drivers/cpufreq/e_powersaver.c         | 13 ++-----------
 drivers/cpufreq/elanfreq.c             | 21 +++------------------
 drivers/cpufreq/exynos-cpufreq.c       | 17 ++---------------
 drivers/cpufreq/exynos5440-cpufreq.c   |  9 ++-------
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 15 ++-------------
 drivers/cpufreq/imx6q-cpufreq.c        | 16 ++--------------
 drivers/cpufreq/kirkwood-cpufreq.c     | 18 +++---------------
 drivers/cpufreq/longhaul.c             | 11 +----------
 drivers/cpufreq/loongson2_cpufreq.c    | 18 ++++--------------
 drivers/cpufreq/maple-cpufreq.c        | 14 +++-----------
 drivers/cpufreq/omap-cpufreq.c         | 27 ++-------------------------
 drivers/cpufreq/p4-clockmod.c          | 14 +++-----------
 drivers/cpufreq/pasemi-cpufreq.c       |  9 +--------
 drivers/cpufreq/pmac32-cpufreq.c       |  9 ++-------
 drivers/cpufreq/pmac64-cpufreq.c       | 14 +++-----------
 drivers/cpufreq/powernow-k6.c          | 10 ++--------
 drivers/cpufreq/powernow-k7.c          | 22 +++++-----------------
 drivers/cpufreq/powernow-k8.c          | 16 ++++++----------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 13 +++----------
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  9 +--------
 drivers/cpufreq/pxa2xx-cpufreq.c       |  9 +--------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 13 ++-----------
 drivers/cpufreq/s3c2416-cpufreq.c      | 29 +++++++++++++----------------
 drivers/cpufreq/s3c24xx-cpufreq.c      | 28 ++++------------------------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 15 +++------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 14 ++------------
 drivers/cpufreq/sc520_freq.c           | 19 +++----------------
 drivers/cpufreq/sparc-us2e-cpufreq.c   | 11 ++---------
 drivers/cpufreq/sparc-us3-cpufreq.c    | 13 ++-----------
 drivers/cpufreq/spear-cpufreq.c        | 10 +++-------
 drivers/cpufreq/speedstep-centrino.c   | 20 ++++++--------------
 drivers/cpufreq/speedstep-ich.c        | 18 +++++-------------
 drivers/cpufreq/speedstep-smi.c        | 16 ++++------------
 drivers/cpufreq/tegra-cpufreq.c        |  8 ++------
 include/linux/cpufreq.h                |  2 +-
 44 files changed, 155 insertions(+), 519 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index cd5badb..a1adbb59 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -424,17 +424,17 @@ static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 }
 
 static int acpi_cpufreq_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq, unsigned int relation)
+			       unsigned int index, unsigned int relation)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
 	struct drv_cmd cmd;
-	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	int result = 0;
 
-	pr_debug("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
+	pr_debug("acpi_cpufreq_target %d (%d)\n",
+			data->freq_table[index].frequency, policy->cpu);
 
 	if (unlikely(data == NULL ||
 	     data->acpi_data == NULL || data->freq_table == NULL)) {
@@ -442,16 +442,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	}
 
 	perf = data->acpi_data;
-	result = cpufreq_frequency_table_target(policy,
-						data->freq_table,
-						target_freq,
-						relation, &next_state);
-	if (unlikely(result)) {
-		result = -ENODEV;
-		goto out;
-	}
-
-	next_perf_state = data->freq_table[next_state].driver_data;
+	next_perf_state = data->freq_table[index].driver_data;
 	if (perf->state == next_perf_state) {
 		if (unlikely(data->resume)) {
 			pr_debug("Called after resume, resetting to P%d\n",
@@ -493,7 +484,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		cmd.mask = cpumask_of(policy->cpu);
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
-	freqs.new = data->freq_table[next_state].frequency;
+	freqs.new = data->freq_table[index].frequency;
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	drv_write(&cmd);
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 7e92586..7ecb829 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -49,28 +49,21 @@ static unsigned int bL_cpufreq_get(unsigned int cpu)
 
 /* Set clock frequency */
 static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	u32 cpu = policy->cpu, freq_tab_idx, cur_cluster;
+	u32 cpu = policy->cpu, cur_cluster;
 	int ret = 0;
 
 	cur_cluster = cpu_to_cluster(policy->cpu);
 
 	freqs.old = bL_cpufreq_get(policy->cpu);
-
-	/* Determine valid target frequency using freq_table */
-	cpufreq_frequency_table_target(policy, freq_table[cur_cluster],
-			target_freq, relation, &freq_tab_idx);
-	freqs.new = freq_table[cur_cluster][freq_tab_idx].frequency;
+	freqs.new = freq_table[cur_cluster][index].frequency;
 
 	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
-			__func__, cpu, cur_cluster, freqs.old, target_freq,
+			__func__, cpu, cur_cluster, freqs.old, freqs.new,
 			freqs.new);
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 48888cf..133ce85 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -128,13 +128,11 @@ unsigned long cpu_set_cclk(int cpu, unsigned long new)
 #endif
 
 static int bfin_target(struct cpufreq_policy *policy,
-			unsigned int target_freq, unsigned int relation)
+			unsigned int index, unsigned int relation)
 {
 #ifndef CONFIG_BF60x
 	unsigned int plldiv;
 #endif
-	unsigned int index;
-	unsigned long cclk_hz;
 	struct cpufreq_freqs freqs;
 	static unsigned long lpj_ref;
 	static unsigned int  lpj_ref_freq;
@@ -144,17 +142,11 @@ static int bfin_target(struct cpufreq_policy *policy,
 	cycles_t cycles;
 #endif
 
-	if (cpufreq_frequency_table_target(policy, bfin_freq_table, target_freq,
-				relation, &index))
-		return -EINVAL;
-
-	cclk_hz = bfin_freq_table[index].frequency;
-
 	freqs.old = bfin_getfreq_khz(0);
-	freqs.new = cclk_hz;
+	freqs.new = bfin_freq_table[index].frequency;
 
 	pr_debug("cpufreq: changing cclk to %lu; target = %u, oldfreq = %u\n",
-			cclk_hz, target_freq, freqs.old);
+			freqs.new, bfin_freq_table[index].frequency, freqs.old);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 #ifndef CONFIG_BF60x
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 3d24e7b..5caecd0 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -35,23 +35,14 @@ static unsigned int cpu0_get_speed(unsigned int cpu)
 }
 
 static int cpu0_set_target(struct cpufreq_policy *policy,
-			   unsigned int target_freq, unsigned int relation)
+			   unsigned int index, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
 	long freq_Hz, freq_exact;
-	unsigned int index;
 	int ret;
 
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					     relation, &index);
-	if (ret) {
-		pr_err("failed to match target freqency %d: %d\n",
-		       target_freq, ret);
-		return ret;
-	}
-
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
 	if (freq_Hz < 0)
 		freq_Hz = freq_table[index].frequency * 1000;
@@ -59,9 +50,6 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	freqs.new = freq_Hz / 1000;
 	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	if (cpu_reg) {
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 06f8671..4bf023d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1628,7 +1628,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
 {
-	int retval = -EINVAL;
+	int retval = -EINVAL, index;
 	unsigned int old_target_freq = target_freq;
 
 	if (cpufreq_disabled())
@@ -1645,11 +1645,35 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
 			policy->cpu, target_freq, relation, old_target_freq);
 
+	/*
+	 * This might look like a redundant call as we are checking it again
+	 * after finding index. But it is left intentionally for cases where
+	 * same freq is called again and so we can save on few function calls.
+	 */
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpufreq_driver->target)
-		retval = cpufreq_driver->target(policy, target_freq, relation);
+	if (cpufreq_driver->target) {
+		struct cpufreq_frequency_table *freq_table;
+
+		freq_table = cpufreq_frequency_get_table(policy->cpu);
+		if (unlikely(!freq_table)) {
+			pr_err("%s: Unable to find freq_table\n", __func__);
+			return retval;
+		}
+
+		retval = cpufreq_frequency_table_target(policy, freq_table,
+				target_freq, relation, &index);
+		if (unlikely(retval)) {
+			pr_err("%s: Unable to find matching freq\n", __func__);
+			return retval;
+		}
+
+		if (freq_table[index].frequency == policy->cur)
+			return 0;
+
+		retval = cpufreq_driver->target(policy, index, relation);
+	}
 
 	return retval;
 }
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index d26f4e4..f1fc446 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -27,8 +27,9 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 	return clk_ctrl.pll ? 200000 : 6000;
 }
 
-static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int cris_freq_target(struct cpufreq_policy *policy,
+			    unsigned int state,
+			    unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	reg_clkgen_rw_clk_ctrl clk_ctrl;
@@ -52,19 +53,6 @@ static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int cris_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, cris_freq_table,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	cris_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index d384e63..53f77a4 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -27,8 +27,8 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 	return clk_ctrl.pll ? 200000 : 6000;
 }
 
-static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state,
+			    unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	reg_config_rw_clk_ctrl clk_ctrl;
@@ -52,18 +52,6 @@ static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int cris_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target
-	    (policy, cris_freq_table, target_freq, relation, &newstate))
-		return -EINVAL;
-
-	cris_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 33e9460..b08fe3f 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -68,28 +68,19 @@ static unsigned int davinci_getspeed(unsigned int cpu)
 	return clk_get_rate(cpufreq.armclk) / 1000;
 }
 
-static int davinci_target(struct cpufreq_policy *policy,
-				unsigned int target_freq, unsigned int relation)
+static int davinci_target(struct cpufreq_policy *policy, unsigned int idx,
+				unsigned int relation)
 {
 	int ret = 0;
-	unsigned int idx;
 	struct cpufreq_freqs freqs;
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
 	struct clk *armclk = cpufreq.armclk;
 
 	freqs.old = davinci_getspeed(0);
-	freqs.new = clk_round_rate(armclk, target_freq * 1000) / 1000;
-
-	if (freqs.old == freqs.new)
-		return ret;
+	freqs.new = pdata->freq_table[idx].frequency;
 
 	dev_dbg(cpufreq.dev, "transition: %u --> %u\n", freqs.old, freqs.new);
 
-	ret = cpufreq_frequency_table_target(policy, pdata->freq_table,
-						freqs.new, relation, &idx);
-	if (ret)
-		return -EINVAL;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	/* if moving to higher frequency, up the voltage beforehand */
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 7e2f9c0..5d46a5e 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -20,23 +20,14 @@ static struct cpufreq_frequency_table *freq_table;
 static struct clk *armss_clk;
 
 static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
-				unsigned int target_freq,
+				unsigned int index,
 				unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int idx;
 	int ret;
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					relation, &idx))
-		return -EINVAL;
-
 	freqs.old = policy->cur;
-	freqs.new = freq_table[idx].frequency;
-
-	if (freqs.old == freqs.new)
-		return 0;
+	freqs.new = freq_table[index].frequency;
 
 	/* pre-change notification */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index a8cbbd0..460e4ed 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -169,11 +169,10 @@ postchange:
 }
 
 static int eps_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq,
+			       unsigned int index,
 			       unsigned int relation)
 {
 	struct eps_cpu_data *centaur;
-	unsigned int newstate = 0;
 	unsigned int cpu = policy->cpu;
 	unsigned int dest_state;
 	int ret;
@@ -182,16 +181,8 @@ static int eps_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 	centaur = eps_cpu[cpu];
 
-	if (unlikely(cpufreq_frequency_table_target(policy,
-			&eps_cpu[cpu]->freq_table[0],
-			target_freq,
-			relation,
-			&newstate))) {
-		return -EINVAL;
-	}
-
 	/* Make frequency transition */
-	dest_state = centaur->freq_table[newstate].driver_data & 0xffff;
+	dest_state = centaur->freq_table[index].driver_data & 0xffff;
 	ret = eps_set_state(centaur, policy, dest_state);
 	if (ret)
 		printk(KERN_ERR "eps: Timeout!\n");
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index fe7053c..a50a700 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -117,8 +117,9 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
  *	There is no return value.
  */
 
-static void elanfreq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int elanfreq_set_cpu_state(struct cpufreq_policy *policy,
+			    unsigned int state,
+			    unsigned int relation)
 {
 	struct cpufreq_freqs    freqs;
 
@@ -162,25 +163,9 @@ static void elanfreq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-
-static int elanfreq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, &elanfreq_table[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
-	elanfreq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
-
-
 /*
  *	Module init and exit code
  */
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7663a96..5105bcd 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -65,9 +65,6 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 
-	if (freqs.new == freqs.old)
-		goto out;
-
 	/*
 	 * The policy max have been changed so that we cannot get proper
 	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
@@ -152,12 +149,10 @@ out:
 }
 
 static int exynos_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int index,
 			  unsigned int relation)
 {
 	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
-	unsigned int index;
-	unsigned int new_freq;
 	int ret = 0;
 
 	mutex_lock(&cpufreq_lock);
@@ -165,15 +160,7 @@ static int exynos_target(struct cpufreq_policy *policy,
 	if (frequency_locked)
 		goto out;
 
-	if (cpufreq_frequency_table_target(policy, freq_table,
-					   target_freq, relation, &index)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	new_freq = freq_table[index].frequency;
-
-	ret = exynos_cpufreq_scale(new_freq);
+	ret = exynos_cpufreq_scale(freq_table[index].frequency);
 
 out:
 	mutex_unlock(&cpufreq_lock);
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index f139b3b..359ddd8 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -215,20 +215,15 @@ static unsigned int exynos_getspeed(unsigned int cpu)
 }
 
 static int exynos_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int index,
 			  unsigned int relation)
 {
-	unsigned int index, tmp;
+	unsigned int tmp;
 	int ret = 0, i;
 	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
 
 	mutex_lock(&cpufreq_lock);
 
-	ret = cpufreq_frequency_table_target(policy, freq_table,
-					   target_freq, relation, &index);
-	if (ret)
-		goto out;
-
 	freqs.old = dvfs_info->cur_frequency;
 	freqs.new = freq_table[index].frequency;
 
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index b958bdb..d2bce53 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -227,23 +227,12 @@ acpi_cpufreq_get (
 static int
 acpi_cpufreq_target (
 	struct cpufreq_policy   *policy,
-	unsigned int target_freq,
+	unsigned int index,
 	unsigned int relation)
 {
-	struct cpufreq_acpi_io *data = acpi_io_data[policy->cpu];
-	unsigned int next_state = 0;
-	unsigned int result = 0;
-
 	pr_debug("acpi_cpufreq_setpolicy\n");
 
-	result = cpufreq_frequency_table_target(policy,
-			data->freq_table, target_freq, relation, &next_state);
-	if (result)
-		return (result);
-
-	result = processor_set_freq(data, policy, next_state);
-
-	return (result);
+	return processor_set_freq(acpi_io_data[policy->cpu], policy, index);
 }
 
 
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 81d1727..3076e3c 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -39,30 +39,18 @@ static unsigned int imx6q_get_speed(unsigned int cpu)
 	return clk_get_rate(arm_clk) / 1000;
 }
 
-static int imx6q_set_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index,
+			    unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long freq_hz, volt, volt_old;
-	unsigned int index;
 	int ret;
 
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					     relation, &index);
-	if (ret) {
-		dev_err(cpu_dev, "failed to match target frequency %d: %d\n",
-			target_freq, ret);
-		return ret;
-	}
-
 	freqs.new = freq_table[index].frequency;
 	freq_hz = freqs.new * 1000;
 	freqs.old = clk_get_rate(arm_clk) / 1000;
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	rcu_read_lock();
 	opp = opp_find_freq_ceil(cpu_dev, &freq_hz);
 	if (IS_ERR(opp)) {
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 9018c4d..a38b0f9 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -55,8 +55,9 @@ static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 	return kirkwood_freq_table[0].frequency;
 }
 
-static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int index)
+static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
+			    unsigned int index,
+			    unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	unsigned int state = kirkwood_freq_table[index].driver_data;
@@ -100,19 +101,6 @@ static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
 		local_irq_enable();
 	}
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int index = 0;
-
-	if (cpufreq_frequency_table_target(policy, kirkwood_freq_table,
-				target_freq, relation, &index))
-		return -EINVAL;
-
-	kirkwood_cpufreq_set_cpu_state(policy, index);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 57d7b02..926999a 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -626,21 +626,12 @@ static void longhaul_setup_voltagescaling(void)
 
 
 static int longhaul_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+			    unsigned int table_index, unsigned int relation)
 {
-	unsigned int table_index = 0;
 	unsigned int i;
 	unsigned int dir = 0;
 	u8 vid, current_vid;
 
-	if (cpufreq_frequency_table_target(policy, longhaul_table, target_freq,
-				relation, &table_index))
-		return -EINVAL;
-
-	/* Don't set same frequency again */
-	if (longhaul_index == table_index)
-		return 0;
-
 	if (!can_scale_voltage)
 		longhaul_setstate(policy, table_index);
 	else {
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index ed7fbe2..3e9480c 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -53,11 +53,10 @@ static unsigned int loongson2_cpufreq_get(unsigned int cpu)
  * Here we notify other drivers of the proposed change and the final change.
  */
 static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
-				     unsigned int target_freq,
+				     unsigned int index,
 				     unsigned int relation)
 {
 	unsigned int cpu = policy->cpu;
-	unsigned int newstate = 0;
 	cpumask_t cpus_allowed;
 	struct cpufreq_freqs freqs;
 	unsigned int freq;
@@ -65,26 +64,17 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	cpus_allowed = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
-	if (cpufreq_frequency_table_target
-	    (policy, &loongson2_clockmod_table[0], target_freq, relation,
-	     &newstate))
-		return -EINVAL;
-
 	freq =
 	    ((cpu_clock_freq / 1000) *
-	     loongson2_clockmod_table[newstate].driver_data) / 8;
-	if (freq < policy->min || freq > policy->max)
-		return -EINVAL;
+	     loongson2_clockmod_table[index].driver_data) / 8;
 
-	pr_debug("cpufreq: requested frequency %u Hz\n", target_freq * 1000);
+	pr_debug("cpufreq: requested frequency %u Hz\n",
+			loongson2_clockmod_table[index].frequency * 1000);
 
 	freqs.old = loongson2_cpufreq_get(cpu);
 	freqs.new = freq;
 	freqs.flags = 0;
 
-	if (freqs.new == freqs.old)
-		return 0;
-
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 7720670..384d83b 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -131,26 +131,18 @@ static int maple_scom_query_freq(void)
  */
 
 static int maple_cpufreq_target(struct cpufreq_policy *policy,
-	unsigned int target_freq, unsigned int relation)
+	unsigned int index, unsigned int relation)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 	int rc;
 
-	if (cpufreq_frequency_table_target(policy, maple_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	if (maple_pmode_cur == newstate)
-		return 0;
-
 	mutex_lock(&maple_switch_mutex);
 
 	freqs.old = maple_cpu_freqs[maple_pmode_cur].frequency;
-	freqs.new = maple_cpu_freqs[newstate].frequency;
+	freqs.new = maple_cpu_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = maple_scom_switch_freq(newstate);
+	rc = maple_scom_switch_freq(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	mutex_unlock(&maple_switch_mutex);
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 48020b5..4008494 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -52,39 +52,16 @@ static unsigned int omap_getspeed(unsigned int cpu)
 }
 
 static int omap_target(struct cpufreq_policy *policy,
-		       unsigned int target_freq,
+		       unsigned int index,
 		       unsigned int relation)
 {
-	unsigned int i;
 	int r, ret = 0;
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 
-	if (!freq_table) {
-		dev_err(mpu_dev, "%s: cpu%d: no freq table!\n", __func__,
-				policy->cpu);
-		return -EINVAL;
-	}
-
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-			relation, &i);
-	if (ret) {
-		dev_dbg(mpu_dev, "%s: cpu%d: no freq match for %d(ret=%d)\n",
-			__func__, policy->cpu, target_freq, ret);
-		return ret;
-	}
-	freqs.new = freq_table[i].frequency;
-	if (!freqs.new) {
-		dev_err(mpu_dev, "%s: cpu%d: no match for freq %d\n", __func__,
-			policy->cpu, target_freq);
-		return -EINVAL;
-	}
-
 	freqs.old = omap_getspeed(policy->cpu);
-
-	if (freqs.old == freqs.new && policy->cur == freqs.new)
-		return ret;
+	freqs.new = freq_table[index].frequency;
 
 	freq = freqs.new * 1000;
 	ret = clk_round_rate(mpu_clk, freq);
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 4fe6d4c..06383c4 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -106,22 +106,14 @@ static struct cpufreq_frequency_table p4clockmod_table[] = {
 
 
 static int cpufreq_p4_target(struct cpufreq_policy *policy,
-			     unsigned int target_freq,
+			     unsigned int index,
 			     unsigned int relation)
 {
-	unsigned int    newstate = DC_RESV;
 	struct cpufreq_freqs freqs;
 	int i;
 
-	if (cpufreq_frequency_table_target(policy, &p4clockmod_table[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	freqs.old = cpufreq_p4_get(policy->cpu);
-	freqs.new = stock_freq * p4clockmod_table[newstate].driver_data / 8;
-
-	if (freqs.new == freqs.old)
-		return 0;
+	freqs.new = stock_freq * p4clockmod_table[index].driver_data / 8;
 
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
@@ -131,7 +123,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	 * Developer's Manual, Volume 3
 	 */
 	for_each_cpu(i, policy->cpus)
-		cpufreq_p4_setdc(i, p4clockmod_table[newstate].driver_data);
+		cpufreq_p4_setdc(i, p4clockmod_table[index].driver_data);
 
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 16f2508..5977d8c 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -247,19 +247,12 @@ static int pas_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static int pas_cpufreq_target(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
+			      unsigned int pas_astate_new,
 			      unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	int pas_astate_new;
 	int i;
 
-	cpufreq_frequency_table_target(policy,
-				       pas_freqs,
-				       target_freq,
-				       relation,
-				       &pas_astate_new);
-
 	freqs.old = policy->cur;
 	freqs.new = pas_freqs[pas_astate_new].frequency;
 
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3f8efd2..17bc3da 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -373,17 +373,12 @@ static unsigned int pmac_cpufreq_get_speed(unsigned int cpu)
 }
 
 static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
-					unsigned int target_freq,
+					unsigned int index,
 					unsigned int relation)
 {
-	unsigned int    newstate = 0;
 	int		rc;
 
-	if (cpufreq_frequency_table_target(policy, pmac_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	rc = do_set_cpu_speed(policy, newstate, 1);
+	rc = do_set_cpu_speed(policy, index, 1);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 	return rc;
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 0eb9313..6a9c850 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -312,26 +312,18 @@ static int g5_pfunc_query_freq(void)
  */
 
 static int g5_cpufreq_target(struct cpufreq_policy *policy,
-	unsigned int target_freq, unsigned int relation)
+	unsigned int index, unsigned int relation)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 	int rc;
 
-	if (cpufreq_frequency_table_target(policy, g5_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	if (g5_pmode_cur == newstate)
-		return 0;
-
 	mutex_lock(&g5_switch_mutex);
 
 	freqs.old = g5_cpu_freqs[g5_pmode_cur].frequency;
-	freqs.new = g5_cpu_freqs[newstate].frequency;
+	freqs.new = g5_cpu_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = g5_switch_freq(newstate);
+	rc = g5_switch_freq(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	mutex_unlock(&g5_switch_mutex);
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ff05d28..984689e 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -114,16 +114,10 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
  * sets a new CPUFreq policy
  */
 static int powernow_k6_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq,
+			       unsigned int index,
 			       unsigned int relation)
 {
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, &clock_ratio[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
-	powernow_k6_set_state(policy, newstate);
+	powernow_k6_set_state(policy, index);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 14cd98f..5b25d8d 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -248,7 +248,9 @@ static void change_VID(int vid)
 }
 
 
-static void change_speed(struct cpufreq_policy *policy, unsigned int index)
+static int powernow_target(struct cpufreq_policy *policy,
+			    unsigned int index,
+			    unsigned int relation)
 {
 	u8 fid, vid;
 	struct cpufreq_freqs freqs;
@@ -291,6 +293,8 @@ static void change_speed(struct cpufreq_policy *policy, unsigned int index)
 		local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+
+	return 0;
 }
 
 
@@ -533,22 +537,6 @@ static int powernow_decode_bios(int maxfid, int startvid)
 }
 
 
-static int powernow_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate;
-
-	if (cpufreq_frequency_table_target(policy, powernow_table, target_freq,
-				relation, &newstate))
-		return -EINVAL;
-
-	change_speed(policy, newstate);
-
-	return 0;
-}
-
-
 /*
  * We use the fact that the bus frequency is somehow
  * a multiple of 100000/3 khz, then we compute sgtc according
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 1e6f68a..cdf0eb3 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -977,7 +977,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 
 struct powernowk8_target_arg {
 	struct cpufreq_policy		*pol;
-	unsigned			targfreq;
+	unsigned			newstate;
 	unsigned			relation;
 };
 
@@ -985,12 +985,11 @@ static long powernowk8_target_fn(void *arg)
 {
 	struct powernowk8_target_arg *pta = arg;
 	struct cpufreq_policy *pol = pta->pol;
-	unsigned targfreq = pta->targfreq;
+	unsigned newstate = pta->newstate;
 	unsigned relation = pta->relation;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
-	unsigned int newstate;
 	int ret;
 
 	if (!data)
@@ -1005,7 +1004,8 @@ static long powernowk8_target_fn(void *arg)
 	}
 
 	pr_debug("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
-		pol->cpu, targfreq, pol->min, pol->max, relation);
+		pol->cpu, data->powernow_table[newstate].frequency, pol->min,
+		pol->max, relation);
 
 	if (query_current_values_with_pending_wait(data))
 		return -EIO;
@@ -1021,10 +1021,6 @@ static long powernowk8_target_fn(void *arg)
 		       checkvid, data->currvid);
 	}
 
-	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
-		return -EIO;
-
 	mutex_lock(&fidvid_mutex);
 
 	powernow_k8_acpi_pst_values(data, newstate);
@@ -1045,9 +1041,9 @@ static long powernowk8_target_fn(void *arg)
 
 /* Driver entry point to switch to the target frequency */
 static int powernowk8_target(struct cpufreq_policy *pol,
-		unsigned targfreq, unsigned relation)
+		unsigned index, unsigned relation)
 {
-	struct powernowk8_target_arg pta = { .pol = pol, .targfreq = targfreq,
+	struct powernowk8_target_arg pta = { .pol = pol, .newstate = index,
 					     .relation = relation };
 
 	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index befd489..a7c1d98 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -253,27 +253,20 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static int corenet_cpufreq_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int new;
 	struct clk *parent;
 	int ret;
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 
-	cpufreq_frequency_table_target(policy, data->table,
-			target_freq, relation, &new);
-
-	if (policy->cur == data->table[new].frequency)
-		return 0;
-
 	freqs.old = policy->cur;
-	freqs.new = data->table[new].frequency;
+	freqs.new = data->table[index].frequency;
 
 	mutex_lock(&cpufreq_lock);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	parent = of_clk_get(data->parent, data->table[new].driver_data);
+	parent = of_clk_get(data->parent, data->table[index].driver_data);
 	ret = clk_set_parent(data->clk, parent);
 	if (ret)
 		freqs.new = freqs.old;
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 38540d1..8dd1798 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -129,18 +129,11 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static int cbe_cpufreq_target(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
+			      unsigned int cbe_pmode_new,
 			      unsigned int relation)
 {
 	int rc;
 	struct cpufreq_freqs freqs;
-	unsigned int cbe_pmode_new;
-
-	cpufreq_frequency_table_target(policy,
-				       cbe_freqs,
-				       target_freq,
-				       relation,
-				       &cbe_pmode_new);
 
 	freqs.old = policy->cur;
 	freqs.new = cbe_freqs[cbe_pmode_new].frequency;
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 5a72bf3..d7cd5ff 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -268,13 +268,12 @@ static unsigned int pxa_cpufreq_get(unsigned int cpu)
 }
 
 static int pxa_set_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int idx,
 			  unsigned int relation)
 {
 	struct cpufreq_frequency_table *pxa_freqs_table;
 	pxa_freqs_t *pxa_freq_settings;
 	struct cpufreq_freqs freqs;
-	unsigned int idx;
 	unsigned long flags;
 	unsigned int new_freq_cpu, new_freq_mem;
 	unsigned int unused, preset_mdrefr, postset_mdrefr, cclkcfg;
@@ -283,12 +282,6 @@ static int pxa_set_target(struct cpufreq_policy *policy,
 	/* Get the current policy */
 	find_freq_tables(&pxa_freqs_table, &pxa_freq_settings);
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, pxa_freqs_table,
-					   target_freq, relation, &idx)) {
-		return -EINVAL;
-	}
-
 	new_freq_cpu = pxa_freq_settings[idx].khz;
 	new_freq_mem = pxa_freq_settings[idx].membus;
 	freqs.old = policy->cur;
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 2837fd6..ac35fba 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -156,23 +156,17 @@ static unsigned int pxa3xx_cpufreq_get(unsigned int cpu)
 }
 
 static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
+			      unsigned int index,
 			      unsigned int relation)
 {
 	struct pxa3xx_freq_info *next;
 	struct cpufreq_freqs freqs;
 	unsigned long flags;
-	int idx;
 
 	if (policy->cpu != 0)
 		return -EINVAL;
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, pxa3xx_freqs_table,
-				target_freq, relation, &idx))
-		return -EINVAL;
-
-	next = &pxa3xx_freqs[idx];
+	next = &pxa3xx_freqs[index];
 
 	freqs.old = policy->cur;
 	freqs.new = next->cpufreq_mhz * 1000;
@@ -181,9 +175,6 @@ static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy,
 			freqs.old / 1000, freqs.new / 1000,
 			(freqs.old == freqs.new) ? " (skipped)" : "");
 
-	if (freqs.old == target_freq)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	local_irq_save(flags);
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 8c57f10..77cb7c5 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -217,24 +217,19 @@ static int s3c2416_cpufreq_leave_dvs(struct s3c2416_data *s3c_freq, int idx)
 }
 
 static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
-				      unsigned int target_freq,
+				      unsigned int index,
 				      unsigned int relation)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
 	struct cpufreq_freqs freqs;
 	int idx, ret, to_dvs = 0;
-	unsigned int i;
 
 	mutex_lock(&cpufreq_lock);
 
-	pr_debug("cpufreq: to %dKHz, relation %d\n", target_freq, relation);
+	pr_debug("cpufreq: to %dKHz, relation %d\n",
+			s3c_freq->freq_table[index].frequency, relation);
 
-	ret = cpufreq_frequency_table_target(policy, s3c_freq->freq_table,
-					     target_freq, relation, &i);
-	if (ret != 0)
-		goto out;
-
-	idx = s3c_freq->freq_table[i].driver_data;
+	idx = s3c_freq->freq_table[index].driver_data;
 
 	if (idx == SOURCE_HCLK)
 		to_dvs = 1;
@@ -256,13 +251,10 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 	 */
 	freqs.new = (s3c_freq->is_dvs && !to_dvs)
 				? clk_get_rate(s3c_freq->hclk) / 1000
-				: s3c_freq->freq_table[i].frequency;
+				: s3c_freq->freq_table[index].frequency;
 
 	pr_debug("cpufreq: Transition %d-%dkHz\n", freqs.old, freqs.new);
 
-	if (!to_dvs && freqs.old == freqs.new)
-		goto out;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	if (to_dvs) {
@@ -330,7 +322,6 @@ static int s3c2416_cpufreq_reboot_notifier_evt(struct notifier_block *this,
 					       unsigned long event, void *ptr)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-	int ret;
 
 	mutex_lock(&cpufreq_lock);
 
@@ -344,9 +335,15 @@ static int s3c2416_cpufreq_reboot_notifier_evt(struct notifier_block *this,
 	 * Therefore we always leave the DVS mode on reboot.
 	 */
 	if (s3c_freq->is_dvs) {
+		struct cpufreq_policy *policy = cpufreq_cpu_get(0);
+		int i;
+
+		cpufreq_cpu_put(policy);
 		pr_debug("cpufreq: leave dvs on reboot\n");
-		ret = cpufreq_driver_target(cpufreq_cpu_get(0), FREQ_SLEEP, 0);
-		if (ret < 0)
+
+		if (cpufreq_frequency_table_target(policy,
+				s3c_freq->freq_table, FREQ_SLEEP, 0, &i) ||
+				cpufreq_driver_target(policy, i, 0))
 			return NOTIFY_BAD;
 	}
 
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 93fcdde..6204d2b 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -38,7 +38,6 @@ static struct cpufreq_driver s3c24xx_driver;
 static struct s3c_cpufreq_config cpu_cur;
 static struct s3c_iotimings s3c24xx_iotiming;
 static struct cpufreq_frequency_table *pll_reg;
-static unsigned int last_target = ~0;
 static unsigned int ftab_size;
 static struct cpufreq_frequency_table *ftab;
 
@@ -278,35 +277,18 @@ static int s3c_cpufreq_settarget(struct cpufreq_policy *policy,
  */
 
 static int s3c_cpufreq_target(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
+			      unsigned int index,
 			      unsigned int relation)
 {
 	struct cpufreq_frequency_table *pll;
-	unsigned int index;
-
-	/* avoid repeated calls which cause a needless amout of duplicated
-	 * logging output (and CPU time as the calculation process is
-	 * done) */
-	if (target_freq == last_target)
-		return 0;
-
-	last_target = target_freq;
+	unsigned int target_freq = 0;
 
 	s3c_freq_dbg("%s: policy %p, target %u, relation %u\n",
 		     __func__, policy, target_freq, relation);
 
-	if (ftab) {
-		if (cpufreq_frequency_table_target(policy, ftab,
-						   target_freq, relation,
-						   &index)) {
-			s3c_freq_dbg("%s: table failed\n", __func__);
-			return -EINVAL;
-		}
-
-		s3c_freq_dbg("%s: adjust %d to entry %d (%u)\n", __func__,
-			     target_freq, index, ftab[index].frequency);
+	/* FIXME: When can ftab be NULL? */
+	if (ftab)
 		target_freq = ftab[index].frequency;
-	}
 
 	target_freq *= 1000;  /* convert target to Hz */
 
@@ -435,8 +417,6 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 
 	s3c_freq_dbg("%s: resuming with policy %p\n", __func__, policy);
 
-	last_target = ~0;	/* invalidate last_target setting */
-
 	/* first, find out what speed we resumed at. */
 	s3c_cpufreq_resume_clocks();
 
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 99fbc49..7995886 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -63,26 +63,17 @@ static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
 }
 
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
-				      unsigned int target_freq,
+				      unsigned int index,
 				      unsigned int relation)
 {
 	int ret;
-	unsigned int i;
 	struct cpufreq_freqs freqs;
 	struct s3c64xx_dvfs *dvfs;
 
-	ret = cpufreq_frequency_table_target(policy, s3c64xx_freq_table,
-					     target_freq, relation, &i);
-	if (ret != 0)
-		return ret;
-
 	freqs.old = clk_get_rate(armclk) / 1000;
-	freqs.new = s3c64xx_freq_table[i].frequency;
+	freqs.new = s3c64xx_freq_table[index].frequency;
 	freqs.flags = 0;
-	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[i].driver_data];
-
-	if (freqs.old == freqs.new)
-		return 0;
+	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
 	pr_debug("Transition %d-%dkHz\n", freqs.old, freqs.new);
 
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 0eafc52..5ac1dd4 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -183,11 +183,11 @@ static unsigned int s5pv210_getspeed(unsigned int cpu)
 }
 
 static int s5pv210_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int index,
 			  unsigned int relation)
 {
 	unsigned long reg;
-	unsigned int index, priv_index;
+	unsigned int priv_index;
 	unsigned int pll_changing = 0;
 	unsigned int bus_speed_changing = 0;
 	int arm_volt, int_volt;
@@ -213,18 +213,8 @@ static int s5pv210_target(struct cpufreq_policy *policy,
 	relation &= ~(ENABLE_FURTHER_CPUFREQ | DISABLE_FURTHER_CPUFREQ);
 
 	freqs.old = s5pv210_getspeed(0);
-
-	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
-					   target_freq, relation, &index)) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	freqs.new = s5pv210_freq_table[index].frequency;
 
-	if (freqs.new == freqs.old)
-		goto exit;
-
 	/* Finding current running level index */
 	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
 					   freqs.old, relation, &priv_index)) {
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 8556225..1053111 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -53,8 +53,9 @@ static unsigned int sc520_freq_get_cpu_frequency(unsigned int cpu)
 	}
 }
 
-static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int sc520_freq_target(struct cpufreq_policy *policy,
+			    unsigned int state,
+			    unsigned int relation)
 {
 
 	struct cpufreq_freqs	freqs;
@@ -76,24 +77,10 @@ static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int sc520_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, sc520_freq_table,
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
-	sc520_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
 
-
 /*
  *	Module init and exit code
  */
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 291688c..0e63736 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -280,17 +280,10 @@ static void us2e_set_cpu_divider_index(struct cpufreq_policy *policy,
 }
 
 static int us2e_freq_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int index,
 			  unsigned int relation)
 {
-	unsigned int new_index = 0;
-
-	if (cpufreq_frequency_table_target(policy,
-					   &us2e_freq_table[policy->cpu].table[0],
-					   target_freq, relation, &new_index))
-		return -EINVAL;
-
-	us2e_set_cpu_divider_index(policy, new_index);
+	us2e_set_cpu_divider_index(policy, index);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 9b3dbd3..89e2cb0 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -139,19 +139,10 @@ static void us3_set_cpu_divider_index(struct cpufreq_policy *policy,
 }
 
 static int us3_freq_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
+			  unsigned int index,
 			  unsigned int relation)
 {
-	unsigned int new_index = 0;
-
-	if (cpufreq_frequency_table_target(policy,
-					   &us3_freq_table[policy->cpu].table[0],
-					   target_freq,
-					   relation,
-					   &new_index))
-		return -EINVAL;
-
-	us3_set_cpu_divider_index(policy, new_index);
+	us3_set_cpu_divider_index(policy, index);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index d31accc..dbac68c 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -105,20 +105,16 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 }
 
 static int spear_cpufreq_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
 	unsigned long newfreq;
 	struct clk *srcclk;
-	int index, ret, mult = 1;
-
-	if (cpufreq_frequency_table_target(policy, spear_cpufreq.freq_tbl,
-				target_freq, relation, &index))
-		return -EINVAL;
+	int ret, mult = 1;
 
 	freqs.old = spear_cpufreq_get(0);
-
 	newfreq = spear_cpufreq.freq_tbl[index].frequency * 1000;
+
 	if (of_machine_is_compatible("st,spear1340")) {
 		/*
 		 * SPEAr1340 is special in the sense that due to the possibility
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index c7c14ae..4270548 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -422,21 +422,21 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 /**
  * centrino_setpolicy - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: the target frequency
+ * @index: index of target frequency
  * @relation: how that frequency relates to achieved frequency
  *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
  *
  * Sets a new CPUFreq policy.
  */
 static int centrino_target (struct cpufreq_policy *policy,
-			    unsigned int target_freq,
+			    unsigned int index,
 			    unsigned int relation)
 {
-	unsigned int    newstate = 0;
 	unsigned int	msr, oldmsr = 0, h = 0, cpu = policy->cpu;
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, first_cpu, tmp;
+	struct cpufreq_frequency_table *op_points;
 	cpumask_var_t covered_cpus;
 
 	if (unlikely(!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL)))
@@ -447,16 +447,8 @@ static int centrino_target (struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	if (unlikely(cpufreq_frequency_table_target(policy,
-			per_cpu(centrino_model, cpu)->op_points,
-			target_freq,
-			relation,
-			&newstate))) {
-		retval = -EINVAL;
-		goto out;
-	}
-
 	first_cpu = 1;
+	op_points = &per_cpu(centrino_model, cpu)->op_points[index];
 	for_each_cpu(j, policy->cpus) {
 		int good_cpu;
 
@@ -480,7 +472,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 		}
 
-		msr = per_cpu(centrino_model, cpu)->op_points[newstate].driver_data;
+		msr = op_points->driver_data;
 
 		if (first_cpu) {
 			rdmsr_on_cpu(good_cpu, MSR_IA32_PERF_CTL, &oldmsr, &h);
@@ -495,7 +487,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			freqs.new = extract_clock(msr, cpu, 0);
 
 			pr_debug("target=%dkHz old=%d new=%d msr=%04x\n",
-				target_freq, freqs.old, freqs.new, msr);
+				op_points->frequency, freqs.old, freqs.new, msr);
 
 			cpufreq_notify_transition(policy, &freqs,
 					CPUFREQ_PRECHANGE);
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 929a4f0..872347c 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -251,36 +251,28 @@ static unsigned int speedstep_get(unsigned int cpu)
 /**
  * speedstep_target - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: the target frequency
+ * @index: index of target frequency
  * @relation: how that frequency relates to achieved frequency
  *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
  *
  * Sets a new CPUFreq policy.
  */
 static int speedstep_target(struct cpufreq_policy *policy,
-			     unsigned int target_freq,
+			     unsigned int index,
 			     unsigned int relation)
 {
-	unsigned int newstate = 0, policy_cpu;
+	unsigned int policy_cpu;
 	struct cpufreq_freqs freqs;
 
-	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
 	freqs.old = speedstep_get(policy_cpu);
-	freqs.new = speedstep_freqs[newstate].frequency;
+	freqs.new = speedstep_freqs[index].frequency;
 
 	pr_debug("transiting from %u to %u kHz\n", freqs.old, freqs.new);
 
-	/* no transition necessary */
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	smp_call_function_single(policy_cpu, _speedstep_set_state, &newstate,
+	smp_call_function_single(policy_cpu, _speedstep_set_state, &index,
 				 true);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index b3dfba0..ec0951f 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -235,29 +235,21 @@ static void speedstep_set_state(unsigned int state)
 /**
  * speedstep_target - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: new freq
+ * @index: index of new freq
  * @relation:
  *
  * Sets a new CPUFreq policy/freq.
  */
 static int speedstep_target(struct cpufreq_policy *policy,
-			unsigned int target_freq, unsigned int relation)
+			unsigned int index, unsigned int relation)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 
-	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	freqs.old = speedstep_freqs[speedstep_get_state()].frequency;
-	freqs.new = speedstep_freqs[newstate].frequency;
-
-	if (freqs.old == freqs.new)
-		return 0;
+	freqs.new = speedstep_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	speedstep_set_state(newstate);
+	speedstep_set_state(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return 0;
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index affb294..6eef51b 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -151,10 +151,9 @@ static unsigned long tegra_cpu_highest_speed(void)
 }
 
 static int tegra_target(struct cpufreq_policy *policy,
-		       unsigned int target_freq,
+		       unsigned int index,
 		       unsigned int relation)
 {
-	unsigned int idx;
 	unsigned int freq;
 	int ret = 0;
 
@@ -165,10 +164,7 @@ static int tegra_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	cpufreq_frequency_table_target(policy, freq_table, target_freq,
-		relation, &idx);
-
-	freq = freq_table[idx].frequency;
+	freq = freq_table[index].frequency;
 
 	target_cpu_speed[policy->cpu] = freq;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4907eb2..a0a9f38 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -196,7 +196,7 @@ struct cpufreq_driver {
 	/* define one out of two */
 	int	(*setpolicy)	(struct cpufreq_policy *policy);
 	int	(*target)	(struct cpufreq_policy *policy,
-				 unsigned int target_freq,
+				 unsigned int index,
 				 unsigned int relation);
 
 	/* should be defined, if possible */
-- 
1.7.12.rc2.18.g61b472e

