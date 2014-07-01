Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbaGAQe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:34:27 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64340 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433AbaGAQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:34:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't registered yet
Date: Tue,  1 Jul 2014 22:02:35 +0530
Message-Id: <eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we defer probe if regulator_get() returned -EPROBE_DEFER, i.e.
regulator isn't registered yet.

The same is true for clock as well, so lets defer in that case as well.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4273a5f..b5b8e1c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -150,8 +150,17 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	cpu_clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
-		ret = PTR_ERR(cpu_clk);
-		pr_err("failed to get cpu0 clock: %d\n", ret);
+		/*
+		 * If cpu's clk node is present, but clock is not yet
+		 * registered, we should try defering probe.
+		 */
+		if (PTR_ERR(cpu_clk) == -EPROBE_DEFER) {
+			dev_err(cpu_dev, "cpu0 clock not ready, retry\n");
+			ret = -EPROBE_DEFER;
+		} else {
+			ret = PTR_ERR(cpu_clk);
+			dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
+		}
 		goto out_put_reg;
 	}
 
-- 
2.0.0.rc2

