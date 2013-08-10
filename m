Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031986Ab3HJGvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:51:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40451 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030526Ab3HJGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:51:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 27/44] cpufreq: p4-clockmod: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:23 +0530
Message-Id: <73040a9b18c94d03b6501815b5aa62d069e8fd6b.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 03478bf..4fe6d4c 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -140,12 +140,6 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 }
 
 
-static int cpufreq_p4_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &p4clockmod_table[0]);
-}
-
-
 static unsigned int cpufreq_p4_get_frequency(struct cpuinfo_x86 *c)
 {
 	if (c->x86 == 0x06) {
@@ -242,12 +236,6 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 }
 
 
-static int cpufreq_p4_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
 static unsigned int cpufreq_p4_get(unsigned int cpu)
 {
 	u32 l, h;
@@ -266,19 +254,14 @@ static unsigned int cpufreq_p4_get(unsigned int cpu)
 	return stock_freq;
 }
 
-static struct freq_attr *p4clockmod_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver p4clockmod_driver = {
-	.verify		= cpufreq_p4_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
-	.exit		= cpufreq_p4_cpu_exit,
+	.exit		= cpufreq_generic_exit,
 	.get		= cpufreq_p4_get,
 	.name		= "p4-clockmod",
-	.attr		= p4clockmod_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id cpufreq_p4_id[] = {
-- 
1.7.12.rc2.18.g61b472e

