Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3IMNUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:20:37 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64951 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757Ab3IMNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:20:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 148/228] cpufreq: acpi: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:34 +0530
Message-Id: <40776b7be5e8ec5300b83298e0bf967bc3bf61a0.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 372febf..7536e7d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -424,17 +424,17 @@ static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 }
 
 static int acpi_cpufreq_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq, unsigned int relation)
+			       unsigned int index)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
 	struct drv_cmd cmd;
-	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	int result = 0;
 
-	pr_debug("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
+	pr_debug("acpi_cpufreq_target %d (%d)\n",
+			data->freq_table[index].frequency, policy->cpu);
 
 	if (unlikely(data == NULL ||
 	     data->acpi_data == NULL || data->freq_table == NULL)) {
@@ -442,16 +442,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	}
 
 	perf = data->acpi_data;
-	result = cpufreq_frequency_table_target(policy,
-						data->freq_table,
-						target_freq,
-						relation, &next_state);
-	if (unlikely(result)) {
-		result = -ENODEV;
-		goto out;
-	}
-
-	next_perf_state = data->freq_table[next_state].driver_data;
+	next_perf_state = data->freq_table[index].driver_data;
 	if (perf->state == next_perf_state) {
 		if (unlikely(data->resume)) {
 			pr_debug("Called after resume, resetting to P%d\n",
@@ -493,7 +484,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		cmd.mask = cpumask_of(policy->cpu);
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
-	freqs.new = data->freq_table[next_state].frequency;
+	freqs.new = data->freq_table[index].frequency;
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	drv_write(&cmd);
@@ -918,7 +909,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= acpi_cpufreq_target,
+	.target_index	= acpi_cpufreq_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e

