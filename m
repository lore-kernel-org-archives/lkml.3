Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3IMNER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:04:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44664 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3IMNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:04:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 010/228] cpufreq: pxa: call cpufreq_frequency_table_get_attr()
Date: Fri, 13 Sep 2013 18:29:16 +0530
Message-Id: <44ca549f392bb5fbf3536918cfa0cc4f7a09f891.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exposes frequency table of driver to cpufreq core and is required for core
to guess what the index for a target frequency is, when it calls
cpufreq_frequency_table_target(). And so this driver needs to expose it.

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 6 +++++-
 drivers/cpufreq/pxa3xx-cpufreq.c | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 8749eaf18..5b8ce9a 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -453,10 +453,14 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		find_freq_tables(&pxa255_freq_table, &pxa255_freqs);
 		pr_info("PXA255 cpufreq using %s frequency table\n",
 			pxa255_turbo_table ? "turbo" : "run");
+
 		cpufreq_frequency_table_cpuinfo(policy, pxa255_freq_table);
+		cpufreq_frequency_table_get_attr(pxa255_freq_table, policy->cpu);
 	}
-	else if (cpu_is_pxa27x())
+	else if (cpu_is_pxa27x()) {
 		cpufreq_frequency_table_cpuinfo(policy, pxa27x_freq_table);
+		cpufreq_frequency_table_get_attr(pxa27x_freq_table, policy->cpu);
+	}
 
 	printk(KERN_INFO "PXA CPU frequency change support initialized\n");
 
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index d26306f..8f14234 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -91,7 +91,7 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 			     struct pxa3xx_freq_info *freqs, int num)
 {
 	struct cpufreq_frequency_table *table;
-	int i;
+	int i, ret;
 
 	table = kzalloc((num + 1) * sizeof(*table), GFP_KERNEL);
 	if (table == NULL)
@@ -108,7 +108,11 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 	pxa3xx_freqs_num = num;
 	pxa3xx_freqs_table = table;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, table);
+	if (!ret)
+		cpufreq_frequency_table_get_attr(table, policy->cpu);
+
+	return ret;
 }
 
 static void __update_core_freq(struct pxa3xx_freq_info *info)
-- 
1.7.12.rc2.18.g61b472e

