Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3HWPyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:54:43 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60962 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3HWPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:54:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 13/16] cpufreq: s5pv210: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:48 +0530
Message-Id: <221200ddbecf6044b3dc4044d9422b39ad713f9a.1377272740.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

We don't need a global variable to hold clock anymore.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index e3973da..da0e291 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -23,7 +23,6 @@
 #include <mach/map.h>
 #include <mach/regs-clock.h>
 
-static struct clk *cpu_clk;
 static struct clk *dmc0_clk;
 static struct clk *dmc1_clk;
 static DEFINE_MUTEX(set_freq_lock);
@@ -164,14 +163,6 @@ static void s5pv210_set_refresh(enum s5pv210_dmc_port ch, unsigned long freq)
 	__raw_writel(tmp1, reg);
 }
 
-static unsigned int s5pv210_getspeed(unsigned int cpu)
-{
-	if (cpu)
-		return 0;
-
-	return clk_get_rate(cpu_clk) / 1000;
-}
-
 static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned long reg;
@@ -193,7 +184,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		goto exit;
 	}
 
-	old_freq = s5pv210_getspeed(0);
+	old_freq = policy->cur;
 	new_freq = s5pv210_freq_table[index].frequency;
 
 	/* Finding current running level index */
@@ -471,9 +462,9 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	unsigned long mem_type;
 	int ret;
 
-	cpu_clk = clk_get(NULL, "armclk");
-	if (IS_ERR(cpu_clk))
-		return PTR_ERR(cpu_clk);
+	policy->clk = clk_get(NULL, "armclk");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 
 	dmc0_clk = clk_get(NULL, "sclk_dmc0");
 	if (IS_ERR(dmc0_clk)) {
@@ -516,7 +507,7 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 out_dmc1:
 	clk_put(dmc0_clk);
 out_dmc0:
-	clk_put(cpu_clk);
+	clk_put(policy->clk);
 	return ret;
 }
 
@@ -563,7 +554,7 @@ static struct cpufreq_driver s5pv210_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s5pv210_target,
-	.get		= s5pv210_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= s5pv210_cpu_init,
 	.name		= "s5pv210",
 #ifdef CONFIG_PM
-- 
1.7.12.rc2.18.g61b472e

