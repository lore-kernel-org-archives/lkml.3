Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3IKKRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:17:03 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37364 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3IKKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:17:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] cpufreq: Optimize cpufreq_frequency_table_verify()
Date: Wed, 11 Sep 2013 15:43:07 +0530
Message-Id: <cbeb2e464791283c5a987ff01f66f027785d9453.1378893296.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_frequency_table_verify() is a bit rewritten here to make it more logical
and optimal.
- merge multiple lines for variable declarations together.
- quit early if any frequency between min/max is found.
- don't call cpufreq_verify_within_limits() in case any valid freq is found as
  it is of no use.
- count renamed as found and made a boolean.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/freq_table.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index f111454a..53a2f1a 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -54,9 +54,8 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_cpuinfo);
 int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table)
 {
-	unsigned int next_larger = ~0;
-	unsigned int i;
-	unsigned int count = 0;
+	unsigned int next_larger = ~0, freq, i = 0;
+	bool found = false;
 
 	pr_debug("request for verification of policy (%u - %u kHz) for cpu %u\n",
 					policy->min, policy->max, policy->cpu);
@@ -64,21 +63,23 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
 				     policy->cpuinfo.max_freq);
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		unsigned int freq = table[i].frequency;
+	for (; freq = table[i].frequency, freq != CPUFREQ_TABLE_END; i++) {
 		if (freq == CPUFREQ_ENTRY_INVALID)
 			continue;
-		if ((freq >= policy->min) && (freq <= policy->max))
-			count++;
-		else if ((next_larger > freq) && (freq > policy->max))
+		if ((freq >= policy->min) && (freq <= policy->max)) {
+			found = true;
+			break;
+		}
+
+		if ((next_larger > freq) && (freq > policy->max))
 			next_larger = freq;
 	}
 
-	if (!count)
+	if (!found) {
 		policy->max = next_larger;
-
-	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
-				     policy->cpuinfo.max_freq);
+		cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
+				policy->cpuinfo.max_freq);
+	}
 
 	pr_debug("verification lead to (%u - %u kHz) for cpu %u\n",
 				policy->min, policy->max, policy->cpu);
-- 
1.7.12.rc2.18.g61b472e

