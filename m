Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3IMNEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:04:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55804 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab3IMNEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:04:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 009/228] cpufreq: Add new helper cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:15 +0530
Message-Id: <f5f37153b1933b4fb9be2df2f3c62fda3b399e9d.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost every cpufreq driver is required to validate its frequency table with:
cpufreq_frequency_table_cpuinfo() and then expose it to cpufreq core with:
cpufreq_frequency_table_get_attr().

This patch creates another helper routine cpufreq_table_validate_and_show() that
will do both these steps in a single call and will return 0 for success, error
otherwise.

This also fixes potential bugs in cpufreq drivers where people have called
cpufreq_frequency_table_get_attr() before calling
cpufreq_frequency_table_cpuinfo(), as the later may fail.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/freq_table.c | 12 ++++++++++++
 include/linux/cpufreq.h      |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 29ff77f..b9336ed 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -218,6 +218,18 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu)
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);
 
+int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
+				      struct cpufreq_frequency_table *table)
+{
+	int ret = cpufreq_frequency_table_cpuinfo(policy, table);
+
+	if (!ret)
+		cpufreq_frequency_table_get_attr(table, policy->cpu);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cpufreq_table_validate_and_show);
+
 void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy)
 {
 	pr_debug("Updating show_table for new_cpu %u from last_cpu %u\n",
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 21f6543..e257407 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -433,5 +433,7 @@ extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
+int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
+				      struct cpufreq_frequency_table *table);
 
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e

