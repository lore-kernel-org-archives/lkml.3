Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaESGSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:18:23 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39711 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaESGSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:18:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/5] cpufreq: imx6q: don't initialize opp table
Date: Mon, 19 May 2014 11:47:23 +0530
Message-Id: <bd2796f2fb9550e7daa1e1d6e0d2c479a3efbc84.1400480033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP tables are already initialized for CPU0 by cpufreq core and so we don't need
to reinitialize them from imx6q specific code.

Cc: Shawn Guo <shawn.guo@linaro.org>
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
index e27fca8..c4c4e70 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -191,26 +191,8 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		goto put_node;
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
-			goto put_node;
-		}
-
-		num = dev_pm_opp_get_opp_count(cpu_dev);
-		if (num < 0) {
-			ret = num;
-			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
-			goto put_node;
-		}
-	}
+	WARN_ON(num < 0);
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
-- 
2.0.0.rc2

