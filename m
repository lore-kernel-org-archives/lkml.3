Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaDUXBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:01:06 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48633 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755091AbaDUXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:00:59 -0400
Message-ID: <5355A327.3020308@semaphore.gr>
Date: Tue, 22 Apr 2014 02:00:55 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 2/8] cpufreq: Use cpufreq_for_each_* macros for frequency
 table iteration
References: <534DB1EB.1080401@semaphore.gr>
In-Reply-To: <534DB1EB.1080401@semaphore.gr>
X-Forwarded-Message-Id: <534DB1EB.1080401@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core now supports the cpufreq_for_each_entry and
cpufreq_for_each_valid_entry macros helpers for iteration over the
cpufreq_frequency_table, so use them.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/acpi-cpufreq.c       |  9 +++---
 drivers/cpufreq/arm_big_little.c     | 16 +++++------
 drivers/cpufreq/cpufreq_stats.c      | 24 ++++++----------
 drivers/cpufreq/dbx500-cpufreq.c     |  8 ++----
 drivers/cpufreq/elanfreq.c           |  9 +++---
 drivers/cpufreq/exynos-cpufreq.c     | 11 ++++---
 drivers/cpufreq/exynos5440-cpufreq.c | 30 +++++++++----------
 drivers/cpufreq/freq_table.c         | 56 ++++++++++++++++--------------------
 drivers/cpufreq/longhaul.c           | 13 ++++-----
 drivers/cpufreq/pasemi-cpufreq.c     | 10 +++----
 drivers/cpufreq/powernow-k6.c        | 14 ++++-----
 drivers/cpufreq/ppc_cbe_cpufreq.c    |  9 +++---
 drivers/cpufreq/s3c2416-cpufreq.c    | 40 +++++++++++---------------
 drivers/cpufreq/s3c64xx-cpufreq.c    | 15 ++++------
 14 files changed, 117 insertions(+), 147 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 000e4e0..b0c18ed 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -213,7 +213,7 @@ static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
 
 static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	struct acpi_processor_performance *perf;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
@@ -223,10 +223,9 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 
 	perf = data->acpi_data;
 
-	for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (msr == perf->states[data->freq_table[i].driver_data].status)
-			return data->freq_table[i].frequency;
-	}
+	cpufreq_for_each_entry(pos, data->freq_table)
+		if (msr == perf->states[pos->driver_data].status)
+			return pos->frequency;
 	return data->freq_table[0].frequency;
 }
 
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index bad2ed3..1f4d4e3 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -226,22 +226,22 @@ static inline u32 get_table_count(struct cpufreq_frequency_table *table)
 /* get the minimum frequency in the cpufreq_frequency_table */
 static inline u32 get_table_min(struct cpufreq_frequency_table *table)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	uint32_t min_freq = ~0;
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++)
-		if (table[i].frequency < min_freq)
-			min_freq = table[i].frequency;
+	cpufreq_for_each_entry(pos, table)
+		if (pos->frequency < min_freq)
+			min_freq = pos->frequency;
 	return min_freq;
 }
 
 /* get the maximum frequency in the cpufreq_frequency_table */
 static inline u32 get_table_max(struct cpufreq_frequency_table *table)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	uint32_t max_freq = 0;
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++)
-		if (table[i].frequency > max_freq)
-			max_freq = table[i].frequency;
+	cpufreq_for_each_entry(pos, table)
+		if (pos->frequency > max_freq)
+			max_freq = pos->frequency;
 	return max_freq;
 }
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index ecaaebf..0cd9b4d 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -182,11 +182,11 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 
 static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 {
-	unsigned int i, j, count = 0, ret = 0;
+	unsigned int i, count = 0, ret = 0;
 	struct cpufreq_stats *stat;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
-	struct cpufreq_frequency_table *table;
+	struct cpufreq_frequency_table *pos, *table;
 
 	table = cpufreq_frequency_get_table(cpu);
 	if (unlikely(!table))
@@ -205,12 +205,8 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 	stat->cpu = cpu;
 	per_cpu(cpufreq_stats_table, cpu) = stat;
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table)
 		count++;
-	}
 
 	alloc_size = count * sizeof(int) + count * sizeof(u64);
 
@@ -228,15 +224,11 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	stat->trans_table = stat->freq_table + count;
 #endif
-	j = 0;
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
-		if (freq_table_get_index(stat, freq) == -1)
-			stat->freq_table[j++] = freq;
-	}
-	stat->state_num = j;
+	i = 0;
+	cpufreq_for_each_valid_entry(pos, table)
+		if (freq_table_get_index(stat, pos->frequency) == -1)
+			stat->freq_table[i++] = pos->frequency;
+	stat->state_num = i;
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 412a78b..4bebc1b 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -45,7 +45,7 @@ static struct cpufreq_driver dbx500_cpufreq_driver = {
 
 static int dbx500_cpufreq_probe(struct platform_device *pdev)
 {
-	int i = 0;
+	struct cpufreq_frequency_table *pos;
 
 	freq_table = dev_get_platdata(&pdev->dev);
 	if (!freq_table) {
@@ -60,10 +60,8 @@ static int dbx500_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	pr_info("dbx500-cpufreq: Available frequencies:\n");
-	while (freq_table[i].frequency != CPUFREQ_TABLE_END) {
-		pr_info("  %d Mhz\n", freq_table[i].frequency/1000);
-		i++;
-	}
+	cpufreq_for_each_entry(pos, freq_table)
+		pr_info("  %d Mhz\n", pos->frequency / 1000);
 
 	return cpufreq_register_driver(&dbx500_cpufreq_driver);
 }
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 7f5d2a6..1c06e78 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -147,7 +147,7 @@ static int elanfreq_target(struct cpufreq_policy *policy,
 static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	unsigned int i;
+	struct cpufreq_frequency_table *pos;
 
 	/* capability check */
 	if ((c->x86_vendor != X86_VENDOR_AMD) ||
@@ -159,10 +159,9 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 		max_freq = elanfreq_get_cpu_frequency(0);
 
 	/* table init */
-	for (i = 0; (elanfreq_table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		if (elanfreq_table[i].frequency > max_freq)
-			elanfreq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
-	}
+	cpufreq_for_each_entry(pos, elanfreq_table)
+		if (pos->frequency > max_freq)
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f99cfe2..9c13255 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -29,17 +29,16 @@ static unsigned int locking_frequency;
 static int exynos_cpufreq_get_index(unsigned int freq)
 {
 	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
-	int index;
+	struct cpufreq_frequency_table *pos;
 
-	for (index = 0;
-		freq_table[index].frequency != CPUFREQ_TABLE_END; index++)
-		if (freq_table[index].frequency == freq)
+	cpufreq_for_each_entry(pos, freq_table)
+		if (pos->frequency == freq)
 			break;
 
-	if (freq_table[index].frequency == CPUFREQ_TABLE_END)
+	if (pos->frequency == CPUFREQ_TABLE_END)
 		return -EINVAL;
 
-	return index;
+	return pos - freq_table;
 }
 
 static int exynos_cpufreq_scale(unsigned int target_freq)
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index a6b8214..f33f25b 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -114,25 +114,23 @@ static struct cpufreq_freqs freqs;
 
 static int init_div_table(void)
 {
-	struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
+	struct cpufreq_frequency_table *pos, *freq_tbl = dvfs_info->freq_table;
 	unsigned int tmp, clk_div, ema_div, freq, volt_id;
-	int i = 0;
 	struct dev_pm_opp *opp;
 
 	rcu_read_lock();
-	for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
-
+	cpufreq_for_each_entry(pos, freq_tbl) {
 		opp = dev_pm_opp_find_freq_exact(dvfs_info->dev,
-					freq_tbl[i].frequency * 1000, true);
+					pos->frequency * 1000, true);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			dev_err(dvfs_info->dev,
 				"failed to find valid OPP for %u KHZ\n",
-				freq_tbl[i].frequency);
+				pos->frequency);
 			return PTR_ERR(opp);
 		}
 
-		freq = freq_tbl[i].frequency / 1000; /* In MHZ */
+		freq = pos->frequency / 1000; /* In MHZ */
 		clk_div = ((freq / CPU_DIV_FREQ_MAX) & P0_7_CPUCLKDEV_MASK)
 					<< P0_7_CPUCLKDEV_SHIFT;
 		clk_div |= ((freq / CPU_ATB_FREQ_MAX) & P0_7_ATBCLKDEV_MASK)
@@ -157,7 +155,8 @@ static int init_div_table(void)
 		tmp = (clk_div | ema_div | (volt_id << P0_7_VDD_SHIFT)
 			| ((freq / FREQ_UNIT) << P0_7_FREQ_SHIFT));
 
-		__raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
+		__raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 *
+						(pos - freq_tbl));
 	}
 
 	rcu_read_unlock();
@@ -166,8 +165,9 @@ static int init_div_table(void)
 
 static void exynos_enable_dvfs(unsigned int cur_frequency)
 {
-	unsigned int tmp, i, cpu;
+	unsigned int tmp, cpu;
 	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
+	struct cpufreq_frequency_table *pos;
 	/* Disable DVFS */
 	__raw_writel(0,	dvfs_info->base + XMU_DVFS_CTRL);
 
@@ -182,15 +182,15 @@ static void exynos_enable_dvfs(unsigned int cur_frequency)
 	 __raw_writel(tmp, dvfs_info->base + XMU_PMUIRQEN);
 
 	/* Set initial performance index */
-	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
-		if (freq_table[i].frequency == cur_frequency)
+	cpufreq_for_each_entry(pos, freq_table)
+		if (pos->frequency == cur_frequency)
 			break;
 
-	if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
+	if (pos->frequency == CPUFREQ_TABLE_END) {
 		dev_crit(dvfs_info->dev, "Boot up frequency not supported\n");
 		/* Assign the highest frequency */
-		i = 0;
-		cur_frequency = freq_table[i].frequency;
+		pos = freq_table;
+		cur_frequency = pos->frequency;
 	}
 
 	dev_info(dvfs_info->dev, "Setting dvfs initial frequency = %uKHZ",
@@ -199,7 +199,7 @@ static void exynos_enable_dvfs(unsigned int cur_frequency)
 	for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
 		tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
 		tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
-		tmp |= (i << C0_3_PSTATE_NEW_SHIFT);
+		tmp |= ((pos - freq_table) << C0_3_PSTATE_NEW_SHIFT);
 		__raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
 	}
 
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 08e7bbc..cf004a5 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -21,22 +21,19 @@
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table)
 {
+	struct cpufreq_frequency_table *pos;
 	unsigned int min_freq = ~0;
 	unsigned int max_freq = 0;
-	unsigned int i;
+	unsigned int freq;
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID) {
-			pr_debug("table entry %u is invalid, skipping\n", i);
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
 
-			continue;
-		}
 		if (!cpufreq_boost_enabled()
-		    && (table[i].flags & CPUFREQ_BOOST_FREQ))
+		    && (pos->flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
-		pr_debug("table entry %u: %u kHz\n", i, freq);
+		pr_debug("table entry %lu: %u kHz\n", pos - table, freq);
 		if (freq < min_freq)
 			min_freq = freq;
 		if (freq > max_freq)
@@ -57,7 +54,8 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_cpuinfo);
 int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table)
 {
-	unsigned int next_larger = ~0, freq, i = 0;
+	struct cpufreq_frequency_table *pos;
+	unsigned int freq, next_larger = ~0;
 	bool found = false;
 
 	pr_debug("request for verification of policy (%u - %u kHz) for cpu %u\n",
@@ -65,9 +63,9 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 
 	cpufreq_verify_within_cpu_limits(policy);
 
-	for (; freq = table[i].frequency, freq != CPUFREQ_TABLE_END; i++) {
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
+
 		if ((freq >= policy->min) && (freq <= policy->max)) {
 			found = true;
 			break;
@@ -118,7 +116,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		.driver_data = ~0,
 		.frequency = 0,
 	};
-	unsigned int i;
+	struct cpufreq_frequency_table *pos;
+	unsigned int freq, i = 0;
 
 	pr_debug("request for target %u kHz (relation: %u) for cpu %u\n",
 					target_freq, relation, policy->cpu);
@@ -132,10 +131,10 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		break;
 	}
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
+
+		i = pos - table;
 		if ((freq < policy->min) || (freq > policy->max))
 			continue;
 		switch (relation) {
@@ -184,8 +183,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		unsigned int freq)
 {
-	struct cpufreq_frequency_table *table;
-	int i;
+	struct cpufreq_frequency_table *pos, *table;
 
 	table = cpufreq_frequency_get_table(policy->cpu);
 	if (unlikely(!table)) {
@@ -193,10 +191,9 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		return -ENOENT;
 	}
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (table[i].frequency == freq)
-			return i;
-	}
+	cpufreq_for_each_valid_entry(pos, table)
+		if (pos->frequency == freq)
+			return pos - table;
 
 	return -EINVAL;
 }
@@ -208,16 +205,13 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
 static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 				    bool show_boost)
 {
-	unsigned int i = 0;
 	ssize_t count = 0;
-	struct cpufreq_frequency_table *table = policy->freq_table;
+	struct cpufreq_frequency_table *pos, *table = policy->freq_table;
 
 	if (!table)
 		return -ENODEV;
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
 		/*
 		 * show_boost = true and driver_data = BOOST freq
 		 * display BOOST freqs
@@ -229,10 +223,10 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 		 * show_boost = false and driver_data != BOOST freq
 		 * display NON BOOST freqs
 		 */
-		if (show_boost ^ (table[i].flags & CPUFREQ_BOOST_FREQ))
+		if (show_boost ^ (pos->flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
-		count += sprintf(&buf[count], "%d ", table[i].frequency);
+		count += sprintf(&buf[count], "%d ", pos->frequency);
 	}
 	count += sprintf(&buf[count], "\n");
 
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index d00e5d1..5e12646 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -528,6 +528,7 @@ static int longhaul_get_ranges(void)
 
 static void longhaul_setup_voltagescaling(void)
 {
+	struct cpufreq_frequency_table *freq_pos;
 	union msr_longhaul longhaul;
 	struct mV_pos minvid, maxvid, vid;
 	unsigned int j, speed, pos, kHz_step, numvscales;
@@ -606,18 +607,16 @@ static void longhaul_setup_voltagescaling(void)
 	/* Calculate kHz for one voltage step */
 	kHz_step = (highest_speed - min_vid_speed) / numvscales;
 
-	j = 0;
-	while (longhaul_table[j].frequency != CPUFREQ_TABLE_END) {
-		speed = longhaul_table[j].frequency;
+	cpufreq_for_each_entry(freq_pos, longhaul_table) {
+		speed = freq_pos->frequency;
 		if (speed > min_vid_speed)
 			pos = (speed - min_vid_speed) / kHz_step + minvid.pos;
 		else
 			pos = minvid.pos;
-		longhaul_table[j].driver_data |= mV_vrm_table[pos] << 8;
+		freq_pos->driver_data |= mV_vrm_table[pos] << 8;
 		vid = vrm_mV_table[mV_vrm_table[pos]];
-		printk(KERN_INFO PFX "f: %d kHz, index: %d, vid: %d mV\n",
-				speed, j, vid.mV);
-		j++;
+		printk(KERN_INFO PFX "f: %u kHz, index: %u, vid: %d mV\n",
+				speed, freq_pos - longhaul_table, vid.mV);
 	}
 
 	can_scale_voltage = 1;
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 84c84b5..9a64492 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -136,9 +136,10 @@ void restore_astate(int cpu)
 
 static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	struct cpufreq_frequency_table *pos;
 	const u32 *max_freqp;
 	u32 max_freq;
-	int i, cur_astate;
+	int cur_astate;
 	struct resource res;
 	struct device_node *cpu, *dn;
 	int err = -ENODEV;
@@ -197,10 +198,9 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	pr_debug("initializing frequency table\n");
 
 	/* initialize frequency table */
-	for (i=0; pas_freqs[i].frequency!=CPUFREQ_TABLE_END; i++) {
-		pas_freqs[i].frequency =
-			get_astate_freq(pas_freqs[i].driver_data) * 100000;
-		pr_debug("%d: %d\n", i, pas_freqs[i].frequency);
+	cpufreq_for_each_entry(pos, pas_freqs) {
+		pos->frequency = get_astate_freq(pos->driver_data) * 100000;
+		pr_debug("%lu: %d\n", pos - pas_freqs, pos->frequency);
 	}
 
 	cur_astate = get_cur_astate(policy->cpu);
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 49f120e..a133236 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -159,6 +159,7 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
 
 static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 {
+	struct cpufreq_frequency_table *pos;
 	unsigned int i, f;
 	unsigned khz;
 
@@ -176,12 +177,11 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 		}
 	}
 	if (param_max_multiplier) {
-		for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
-			if (clock_ratio[i].driver_data == param_max_multiplier) {
+		cpufreq_for_each_entry(pos, clock_ratio)
+			if (pos->driver_data == param_max_multiplier) {
 				max_multiplier = param_max_multiplier;
 				goto have_max_multiplier;
 			}
-		}
 		printk(KERN_ERR "powernow-k6: invalid max_multiplier parameter, valid parameters 20, 30, 35, 40, 45, 50, 55, 60\n");
 		return -EINVAL;
 	}
@@ -209,12 +209,12 @@ have_busfreq:
 	param_busfreq = busfreq * 10;
 
 	/* table init */
-	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
-		f = clock_ratio[i].driver_data;
+	cpufreq_for_each_entry(pos, clock_ratio) {
+		f = pos->driver_data;
 		if (f > max_multiplier)
-			clock_ratio[i].frequency = CPUFREQ_ENTRY_INVALID;
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 		else
-			clock_ratio[i].frequency = busfreq * f;
+			pos->frequency = busfreq * f;
 	}
 
 	/* cpuinfo and default policy values */
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 5be8a48..b550d5c 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -67,9 +67,10 @@ static int set_pmode(unsigned int cpu, unsigned int slow_mode)
 
 static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	struct cpufreq_frequency_table *pos;
 	const u32 *max_freqp;
 	u32 max_freq;
-	int i, cur_pmode;
+	int cur_pmode;
 	struct device_node *cpu;
 
 	cpu = of_get_cpu_node(policy->cpu, NULL);
@@ -102,9 +103,9 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	pr_debug("initializing frequency table\n");
 
 	/* initialize frequency table */
-	for (i=0; cbe_freqs[i].frequency!=CPUFREQ_TABLE_END; i++) {
-		cbe_freqs[i].frequency = max_freq / cbe_freqs[i].driver_data;
-		pr_debug("%d: %d\n", i, cbe_freqs[i].frequency);
+	cpufreq_for_each_entry(pos, cbe_freqs) {
+		pos->frequency = max_freq / pos->driver_data;
+		pr_debug("%lu: %d\n", pos - cbe_freqs, pos->frequency);
 	}
 
 	/* if DEBUG is enabled set_pmode() measures the latency
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4626f90..2fd53ea 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -266,7 +266,7 @@ out:
 static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 {
 	int count, v, i, found;
-	struct cpufreq_frequency_table *freq;
+	struct cpufreq_frequency_table *pos;
 	struct s3c2416_dvfs *dvfs;
 
 	count = regulator_count_voltages(s3c_freq->vddarm);
@@ -275,12 +275,11 @@ static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 		return;
 	}
 
-	freq = s3c_freq->freq_table;
-	while (count > 0 && freq->frequency != CPUFREQ_TABLE_END) {
-		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	if (!count)
+		goto out;
 
-		dvfs = &s3c2416_dvfs_table[freq->driver_data];
+	cpufreq_for_each_valid_entry(pos, s3c_freq->freq_table) {
+		dvfs = &s3c2416_dvfs_table[pos->driver_data];
 		found = 0;
 
 		/* Check only the min-voltage, more is always ok on S3C2416 */
@@ -292,13 +291,12 @@ static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 
 		if (!found) {
 			pr_debug("cpufreq: %dkHz unsupported by regulator\n",
-				 freq->frequency);
-			freq->frequency = CPUFREQ_ENTRY_INVALID;
+				 pos->frequency);
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
+out:
 	/* Guessed */
 	s3c_freq->regulator_latency = 1 * 1000 * 1000;
 }
@@ -338,7 +336,7 @@ static struct notifier_block s3c2416_cpufreq_reboot_notifier = {
 static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-	struct cpufreq_frequency_table *freq;
+	struct cpufreq_frequency_table *pos;
 	struct clk *msysclk;
 	unsigned long rate;
 	int ret;
@@ -427,31 +425,27 @@ static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 	s3c_freq->regulator_latency = 0;
 #endif
 
-	freq = s3c_freq->freq_table;
-	while (freq->frequency != CPUFREQ_TABLE_END) {
+	cpufreq_for_each_entry(pos, s3c_freq->freq_table) {
 		/* special handling for dvs mode */
-		if (freq->driver_data == 0) {
+		if (pos->driver_data == 0) {
 			if (!s3c_freq->hclk) {
 				pr_debug("cpufreq: %dkHz unsupported as it would need unavailable dvs mode\n",
-					 freq->frequency);
-				freq->frequency = CPUFREQ_ENTRY_INVALID;
+					 pos->frequency);
+				pos->frequency = CPUFREQ_ENTRY_INVALID;
 			} else {
-				freq++;
 				continue;
 			}
 		}
 
 		/* Check for frequencies we can generate */
 		rate = clk_round_rate(s3c_freq->armdiv,
-				      freq->frequency * 1000);
+				      pos->frequency * 1000);
 		rate /= 1000;
-		if (rate != freq->frequency) {
+		if (rate != pos->frequency) {
 			pr_debug("cpufreq: %dkHz unsupported by clock (clk_round_rate return %lu)\n",
-				 freq->frequency, rate);
-			freq->frequency = CPUFREQ_ENTRY_INVALID;
+				pos->frequency, rate);
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
 	/* Datasheet says PLL stabalisation time must be at least 300us,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index ff7d3ec..176e84c 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -118,11 +118,10 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
 		pr_err("Unable to check supported voltages\n");
 	}
 
-	freq = s3c64xx_freq_table;
-	while (count > 0 && freq->frequency != CPUFREQ_TABLE_END) {
-		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	if (!count)
+		goto out;
 
+	cpufreq_for_each_valid_entry(freq, s3c64xx_freq_table) {
 		dvfs = &s3c64xx_dvfs_table[freq->driver_data];
 		found = 0;
 
@@ -137,10 +136,9 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
 				 freq->frequency);
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
+out:
 	/* Guess based on having to do an I2C/SPI write; in future we
 	 * will be able to query the regulator performance here. */
 	regulator_latency = 1 * 1000 * 1000;
@@ -179,8 +177,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 	}
 #endif
 
-	freq = s3c64xx_freq_table;
-	while (freq->frequency != CPUFREQ_TABLE_END) {
+	cpufreq_for_each_entry(freq, s3c64xx_freq_table) {
 		unsigned long r;
 
 		/* Check for frequencies we can generate */
@@ -196,8 +193,6 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		 * frequency is the maximum we can support. */
 		if (!vddarm && freq->frequency > clk_get_rate(policy->clk) / 1000)
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
-
-		freq++;
 	}
 
 	/* Datasheet says PLL stabalisation time (if we were to use
-- 
1.9.0
