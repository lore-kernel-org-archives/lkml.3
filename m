Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbaGAQfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:35:08 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50434 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbaGAQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:35:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/14] cpufreq: cpu0: try regulators with name "cpu-supply"
Date: Tue,  1 Jul 2014 22:02:39 +0530
Message-Id: <cd7a14fb8fba515010184f26f277f36a1ef8e8fd.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we expect regulator name to be "cpu0", but as we are going to support
multiple cpu-blocks (all CPUs in a block share clock/voltage) later, we need to
pass some generic string instead of that.

For backwards compatibility try for "cpu0" first and if it fails, then try for
"cpu".

Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 15b8e7a..17001a8 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -113,6 +113,7 @@ static int allocate_resources(struct device **cdev,
 	struct regulator *cpu_reg;
 	struct clk *cpu_clk;
 	int ret = 0;
+	char *reg_cpu0 = "cpu0", *reg_cpu = "cpu", *reg;
 
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
@@ -120,7 +121,11 @@ static int allocate_resources(struct device **cdev,
 		return -ENODEV;
 	}
 
-	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
+	/* Try "cpu0" for older DTs */
+	reg = reg_cpu0;
+
+try_again:
+	cpu_reg = regulator_get_optional(cpu_dev, reg);
 	if (IS_ERR(cpu_reg)) {
 		/*
 		 * If cpu0 regulator supply node is present, but regulator is
@@ -130,6 +135,13 @@ static int allocate_resources(struct device **cdev,
 			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
 			return -EPROBE_DEFER;
 		}
+
+		/* Try with "cpu-supply" */
+		if (reg == reg_cpu0) {
+			reg = reg_cpu;
+			goto try_again;
+		}
+
 		dev_warn(cpu_dev, "failed to get cpu0 regulator: %ld\n",
 			 PTR_ERR(cpu_reg));
 	}
-- 
2.0.0.rc2

