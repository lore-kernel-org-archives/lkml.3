Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaEQEwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:52:09 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52115 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbaEQEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:52:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 4/4] cpufreq: Tegra: implement intermediate frequency callbacks
Date: Sat, 17 May 2014 10:21:23 +0530
Message-Id: <0fcd08cda4001198c02fb41f3e6437bf758417d1.1400302114.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra had always been switching to intermediate frequency (pll_p_clk) since
ever. CPUFreq core has better support for handling notifications for these
frequencies and so we can adapt Tegra's driver to it.

Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 71 +++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 6e774c6..fc66442 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -46,10 +46,19 @@ static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static int tegra_cpu_clk_set_rate(unsigned long rate)
+static unsigned int
+tegra_get_intermediate(struct cpufreq_policy *policy, unsigned int index)
+{
+	return clk_get_rate(pll_p_clk) / 1000; /* kHz */
+}
+
+static int
+tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int frequency)
 {
 	int ret;
 
+	WARN_ON(frequency != clk_get_rate(pll_p_clk) / 1000);
+
 	/*
 	 * Take an extra reference to the main pll so it doesn't turn
 	 * off when we move the cpu off of it
@@ -57,28 +66,9 @@ static int tegra_cpu_clk_set_rate(unsigned long rate)
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
 
@@ -98,10 +88,21 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 	else
 		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
 
-	ret = tegra_cpu_clk_set_rate(rate * 1000);
+	if (rate == clk_get_rate(pll_p_clk))
+		goto out;
+
+	ret = clk_set_rate(pll_x_clk, rate * 1000);
+	if (ret) {
+		pr_err("Failed to change pll_x to %lu\n", rate);
+		goto out;
+	}
+
+	ret = clk_set_parent(cpu_clk, pll_x_clk);
 	if (ret)
-		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
-			rate);
+		pr_err("Failed to switch cpu to clock pll_x\n");
+
+out:
+	clk_disable_unprepare(pll_x_clk);
 
 	return ret;
 }
@@ -137,16 +138,18 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
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

