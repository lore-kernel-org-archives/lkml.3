Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaEUJFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:05:03 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:43487 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEUJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:04:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
Date: Wed, 21 May 2014 14:29:31 +0530
Message-Id: <dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra had always been switching to intermediate frequency (pll_p_clk) since
ever. CPUFreq core has better support for handling notifications for these
frequencies and so we can adapt Tegra's driver to it.

Also do a WARN() if clk_set_parent() fails while moving back to pll_x as we
should have atleast restored to earlier frequency on error.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 81 ++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 6e774c6..a64b970 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -46,7 +46,24 @@ static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static int tegra_cpu_clk_set_rate(unsigned long rate)
+static unsigned int
+tegra_get_intermediate(struct cpufreq_policy *policy, unsigned int index)
+{
+	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
+
+	/*
+	 * Don't switch to intermediate freq if:
+	 * - we are already at it, i.e. policy->cur == ifreq
+	 * - index corresponds to ifreq
+	 */
+	if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
+		return 0;
+
+	return ifreq;
+}
+
+static int
+tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int index)
 {
 	int ret;
 
@@ -57,28 +74,9 @@ static int tegra_cpu_clk_set_rate(unsigned long rate)
 	clk_prepare_enable(pll_x_clk);
 
 	ret = clk_set_parent(cpu_clk, pll_p_clk);
-	if (ret) {
-		pr_err("Failed to switch cpu to clock pll_p\n");
-		goto out;
-	}
-
-	if (rate == clk_get_rate(pll_p_clk))
-		goto out;
-
-	ret = clk_set_rate(pll_x_clk, rate);
-	if (ret) {
-		pr_err("Failed to change pll_x to %lu\n", rate);
-		goto out;
-	}
-
-	ret = clk_set_parent(cpu_clk, pll_x_clk);
-	if (ret) {
-		pr_err("Failed to switch cpu to clock pll_x\n");
-		goto out;
-	}
+	if (ret)
+		clk_disable_unprepare(pll_x_clk);
 
-out:
-	clk_disable_unprepare(pll_x_clk);
 	return ret;
 }
 
@@ -98,10 +96,23 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 	else
 		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
 
-	ret = tegra_cpu_clk_set_rate(rate * 1000);
+	/* target freq == pll_p */
+	if (rate * 1000 == clk_get_rate(pll_p_clk)) {
+		ret = tegra_target_intermediate(policy, index);
+		goto disable_pll_x;
+	}
+
+	ret = clk_set_rate(pll_x_clk, rate * 1000);
+	/* Restore to earlier frequency on error, i.e. pll_x */
 	if (ret)
-		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
-			rate);
+		pr_err("Failed to change pll_x to %lu\n", rate);
+
+	ret = clk_set_parent(cpu_clk, pll_x_clk);
+	/* This shouldn't fail while changing or restoring */
+	WARN_ON(ret);
+
+disable_pll_x:
+	clk_disable_unprepare(pll_x_clk);
 
 	return ret;
 }
@@ -137,16 +148,18 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver tegra_cpufreq_driver = {
-	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
-	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_index	= tegra_target,
-	.get		= cpufreq_generic_get,
-	.init		= tegra_cpu_init,
-	.exit		= tegra_cpu_exit,
-	.name		= "tegra",
-	.attr		= cpufreq_generic_attr,
+	.flags			= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
+	.verify			= cpufreq_generic_frequency_table_verify,
+	.get_intermediate	= tegra_get_intermediate,
+	.target_intermediate	= tegra_target_intermediate,
+	.target_index		= tegra_target,
+	.get			= cpufreq_generic_get,
+	.init			= tegra_cpu_init,
+	.exit			= tegra_cpu_exit,
+	.name			= "tegra",
+	.attr			= cpufreq_generic_attr,
 #ifdef CONFIG_PM
-	.suspend	= cpufreq_generic_suspend,
+	.suspend		= cpufreq_generic_suspend,
 #endif
 };
 
-- 
2.0.0.rc2

