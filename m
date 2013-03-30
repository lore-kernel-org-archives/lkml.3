Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3C3M4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:56:44 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52437 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab3C3M4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:56:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, shawn.guo@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: cpufreq-cpu0: No need to check cpu number in init()
Date: Sat, 30 Mar 2013 18:26:29 +0530
Message-Id: <3f6e2ec11acfe89c192735f357c830d968daa0fd.1364648083.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not possible for init() to be called for any cpu other than cpu0. During
bootup whatever cpu is used to boot system will be assigned as cpu0. And later
on policy->cpu can only change if we hotunplug all cpus first and then hotplug
them back in different order, which isn't possible (system requires atleast one
cpu to be up always :)).

Though I can see one situation where policy->cpu can be different then zero.
- Hot-unplug cpu 0.
- rmmod cpufreq-cpu0 module
- insmod it back
- hotplug cpu 0 again.

Here, policy->cpu would be different. But the driver doesn't have any dependency
on cpu0 as such. We don't mind which cpu of a system is policy->cpu and so this
check is just not required.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 0f16267..1cab820 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -124,9 +124,6 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	if (policy->cpu != 0)
-		return -EINVAL;
-
 	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table);
 	if (ret) {
 		pr_err("invalid frequency table: %d\n", ret);
-- 
1.7.12.rc2.18.g61b472e

