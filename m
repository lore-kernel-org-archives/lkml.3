Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3EAFFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:05:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48457 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3EAFEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:04:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        shawn.guo@linaro.org, nm@ti.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: cpu0: Free parent node for error cases
Date: Wed,  1 May 2013 10:34:43 +0530
Message-Id: <ad5f8a25684dbdd6fcb385fb420da0b4709e7392.1367384647.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are freeing parent node in success cases but not in failure cases. Lets do
it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 3ab8294..c025714 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	if (!np) {
 		pr_err("failed to find cpu0 node\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out_put_parent;
 	}
 
 	cpu_dev = &pdev->dev;
@@ -199,7 +200,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	if (IS_ERR(cpu_clk)) {
 		ret = PTR_ERR(cpu_clk);
 		pr_err("failed to get cpu0 clock: %d\n", ret);
-		goto out_put_node;
+		goto out_put_np;
 	}
 
 	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
@@ -211,13 +212,13 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	ret = of_init_opp_table(cpu_dev);
 	if (ret) {
 		pr_err("failed to init OPP table: %d\n", ret);
-		goto out_put_node;
+		goto out_put_np;
 	}
 
 	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		pr_err("failed to init cpufreq table: %d\n", ret);
-		goto out_put_node;
+		goto out_put_np;
 	}
 
 	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
@@ -262,8 +263,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 out_free_table:
 	opp_free_cpufreq_table(cpu_dev, &freq_table);
-out_put_node:
+out_put_np:
 	of_node_put(np);
+out_put_parent:
+	of_node_put(parent);
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e

