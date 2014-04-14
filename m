Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaDNVJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:09:25 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54745 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755595AbaDNVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:09:22 -0400
Message-ID: <534C4E7E.4090806@semaphore.gr>
Date: Tue, 15 Apr 2014 00:09:18 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/20] cpufreq: exynos5440: Use cpufreq_for_each_entry macro
 for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/exynos5440-cpufreq.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index a6b8214..3e3dd0c 100644
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
+	cpufreq_for_each_entry(pos, freq_table) {
+		if (pos->frequency == cur_frequency)
 			break;
+	}
 
-	if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
+	if (pos->frequency == CPUFREQ_TABLE_END) {
 		dev_crit(dvfs_info->dev, "Boot up frequency not supported\n");
 		/* Assign the highest frequency */
-		i = 0;
-		cur_frequency = freq_table[i].frequency;
+		cur_frequency = freq_table->frequency;
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
 
-- 
1.9.0
