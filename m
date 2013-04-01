Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3DAM6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:30 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34518 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3DAM60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/9] cpufreq: cpufreq-cpu0: No need to check cpu number in init()
Date: Mon,  1 Apr 2013 18:27:43 +0530
Message-Id: <e15015fc03add6737b546610c4bcd141f0e8ea7b.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
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
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 6bb88af..4c5a4cf 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -130,9 +130,6 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
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

