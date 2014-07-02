Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbaGBEDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:03:42 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:32827 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaGBEDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:03:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 07/14] cpufreq: cpu0: OPPs can be populated at runtime
Date: Wed,  2 Jul 2014 09:33:23 +0530
Message-Id: <e0680f66383f71400f0caa7032620b82c7b3af83.1404273178.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPPs can be populated statically, via DT, or added at run time with
dev_pm_opp_add().

While this driver handles the first case correctly, it would fail to populate
OPPs added at runtime. Because call to of_init_opp_table() would fail as there
are no OPPs in DT and probe will return early.

To fix this, remove error checking and call dev_pm_opp_init_cpufreq_table()
unconditionally.

Update bindings as well.

Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V2 Resend: Update bindings as well

 Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt | 6 ++++--
 drivers/cpufreq/cpufreq-cpu0.c                             | 7 ++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index f055515..366690c 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -8,10 +8,12 @@ Both required and optional properties listed below must be defined
 under node /cpus/cpu@0.
 
 Required properties:
-- operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
-  for details
+- None
 
 Optional properties:
+- operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt for
+  details. OPPs *must* be supplied either via DT, i.e. this property, or
+  populated at runtime.
 - clock-latency: Specify the possible maximum transition latency for clock,
   in unit of nanoseconds.
 - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index b5b8e1c..f47f703 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -164,11 +164,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_reg;
 	}
 
-	ret = of_init_opp_table(cpu_dev);
-	if (ret) {
-		pr_err("failed to init OPP table: %d\n", ret);
-		goto out_put_clk;
-	}
+	/* OPPs might be populated at runtime, don't check for error here */
+	of_init_opp_table(cpu_dev);
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
-- 
2.0.0.rc2

