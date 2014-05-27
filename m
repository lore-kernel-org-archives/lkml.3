Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaE0LxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:53:20 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57718 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaE0LxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:53:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 6/8] cpufreq: imx6q: don't initialize opp table
Date: Tue, 27 May 2014 17:20:55 +0530
Message-Id: <65d800de10bded80443852af0b36959e1d9ddf33.1401191054.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1401191054.git.viresh.kumar@linaro.org>
References: <cover.1401191054.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1401191054.git.viresh.kumar@linaro.org>
References: <cover.1401191054.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU OPP tables are already initialized by CPU core and we don't need to
reinitialize them from imx6q specific code.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-imx/mach-imx6q.c  | 36 ++++++++----------------------------
 drivers/cpufreq/imx6q-cpufreq.c | 20 +-------------------
 2 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index e60456d..03819e7 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -290,12 +290,18 @@ static void __init imx6q_init_machine(void)
 #define OCOTP_CFG3_SPEED_996MHZ		0x2
 #define OCOTP_CFG3_SPEED_852MHZ		0x1
 
-static void __init imx6q_opp_check_speed_grading(struct device *cpu_dev)
+static void __init imx6q_opp_check_speed_grading(void)
 {
+	struct device *cpu_dev = get_cpu_device(0);
 	struct device_node *np;
 	void __iomem *base;
 	u32 val;
 
+	if (!cpu_dev) {
+		pr_warn("failed to get cpu0 device\n");
+		return;
+	}
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-ocotp");
 	if (!np) {
 		pr_warn("failed to find ocotp node\n");
@@ -336,32 +342,6 @@ put_node:
 	of_node_put(np);
 }
 
-static void __init imx6q_opp_init(void)
-{
-	struct device_node *np;
-	struct device *cpu_dev = get_cpu_device(0);
-
-	if (!cpu_dev) {
-		pr_warn("failed to get cpu0 device\n");
-		return;
-	}
-	np = of_node_get(cpu_dev->of_node);
-	if (!np) {
-		pr_warn("failed to find cpu0 node\n");
-		return;
-	}
-
-	if (of_init_opp_table(cpu_dev)) {
-		pr_warn("failed to init OPP table\n");
-		goto put_node;
-	}
-
-	imx6q_opp_check_speed_grading(cpu_dev);
-
-put_node:
-	of_node_put(np);
-}
-
 static struct platform_device imx6q_cpufreq_pdev = {
 	.name = "imx6q-cpufreq",
 };
@@ -376,7 +356,7 @@ static void __init imx6q_init_late(void)
 		imx6q_cpuidle_init();
 
 	if (IS_ENABLED(CONFIG_ARM_IMX6Q_CPUFREQ)) {
-		imx6q_opp_init();
+		imx6q_opp_check_speed_grading();
 		platform_device_register(&imx6q_cpufreq_pdev);
 	}
 }
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index af366c2..b72e94f 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -190,26 +190,8 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		goto put_reg;
 	}
 
-	/*
-	 * We expect an OPP table supplied by platform.
-	 * Just, incase the platform did not supply the OPP
-	 * table, it will try to get it.
-	 */
 	num = dev_pm_opp_get_opp_count(cpu_dev);
-	if (num < 0) {
-		ret = of_init_opp_table(cpu_dev);
-		if (ret < 0) {
-			dev_err(cpu_dev, "failed to init OPP table: %d\n", ret);
-			goto put_reg;
-		}
-
-		num = dev_pm_opp_get_opp_count(cpu_dev);
-		if (num < 0) {
-			ret = num;
-			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
-			goto put_reg;
-		}
-	}
+	WARN_ON(num < 0);
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
-- 
2.0.0.rc2

