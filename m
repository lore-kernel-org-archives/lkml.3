Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153Ab3IMNYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:24:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55800 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3IMNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:24:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 182/228] cpufreq: acpi: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:08 +0530
Message-Id: <14622306cc87b9a0819318b9a4a51cf9da15b6fd.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 7536e7d..6b00cd8 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -428,14 +428,10 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 	struct acpi_processor_performance *perf;
-	struct cpufreq_freqs freqs;
 	struct drv_cmd cmd;
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	int result = 0;
 
-	pr_debug("acpi_cpufreq_target %d (%d)\n",
-			data->freq_table[index].frequency, policy->cpu);
-
 	if (unlikely(data == NULL ||
 	     data->acpi_data == NULL || data->freq_table == NULL)) {
 		return -ENODEV;
@@ -483,23 +479,17 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	else
 		cmd.mask = cpumask_of(policy->cpu);
 
-	freqs.old = perf->states[perf->state].core_frequency * 1000;
-	freqs.new = data->freq_table[index].frequency;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(cmd.mask, freqs.new, data)) {
+		if (!check_freqs(cmd.mask, data->freq_table[index].frequency,
+					data)) {
 			pr_debug("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
 			result = -EAGAIN;
-			freqs.new = freqs.old;
 		}
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	if (!result)
 		perf->state = next_perf_state;
 
-- 
1.7.12.rc2.18.g61b472e

