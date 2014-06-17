Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966447AbaFQVtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:49:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966392AbaFQVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lucas Stach <l.stach@pengutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 172/212] cpufreq: cpu0: drop wrong devm usage
Date: Tue, 17 Jun 2014 14:44:26 -0700
Message-Id: <1403041506-13646-173-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit e3beb0ac521d50d158a9d253373eae8421ac3998 upstream.

This driver is using devres managed calls incorrectly, giving the cpu0
device as first parameter instead of the cpufreq platform device.
This results in resources not being freed if the cpufreq platform device
is unbound, for example if probing has to be deferred for a missing
regulator.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/cpufreq-cpu0.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index d4585ce..27b5ba6 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -131,7 +131,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	cpu_reg = devm_regulator_get_optional(cpu_dev, "cpu0");
+	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
 	if (IS_ERR(cpu_reg)) {
 		/*
 		 * If cpu0 regulator supply node is present, but regulator is
@@ -146,23 +146,23 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 			PTR_ERR(cpu_reg));
 	}
 
-	cpu_clk = devm_clk_get(cpu_dev, NULL);
+	cpu_clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
 		ret = PTR_ERR(cpu_clk);
 		pr_err("failed to get cpu0 clock: %d\n", ret);
-		goto out_put_node;
+		goto out_put_reg;
 	}
 
 	ret = of_init_opp_table(cpu_dev);
 	if (ret) {
 		pr_err("failed to init OPP table: %d\n", ret);
-		goto out_put_node;
+		goto out_put_clk;
 	}
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		pr_err("failed to init cpufreq table: %d\n", ret);
-		goto out_put_node;
+		goto out_put_clk;
 	}
 
 	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
@@ -206,6 +206,12 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 out_free_table:
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
+out_put_clk:
+	if (!IS_ERR(cpu_clk))
+		clk_put(cpu_clk);
+out_put_reg:
+	if (!IS_ERR(cpu_reg))
+		regulator_put(cpu_reg);
 out_put_node:
 	of_node_put(np);
 	return ret;
-- 
1.9.1

