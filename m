Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3ILF13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:27:29 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33795 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3ILF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:27:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, swarren@wwwdotorg.org, srivatsa.bhat@linux.vnet.ibm.com
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/5] cpufreq: don't update policy->cpu while removing while removing other CPUs
Date: Thu, 12 Sep 2013 10:55:47 +0530
Message-Id: <0475c234b6ca2849c8a69dad0446d82b065b4161.1378963070.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1378963070.git.viresh.kumar@linaro.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1378963070.git.viresh.kumar@linaro.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a recent change the logic here is changed a bit and I just figured out it
is something we don't want.

Consider we have four CPUs (0,1,2,3) managed by a policy and policy->cpu is set
to 0. Now we are suspending and hence we call __cpufreq_remove_dev_prepare() for
cpu 1, 2 & 3..

With the current code we always call cpufreq_nominate_new_policy_cpu() for cpu
1, 2 & 3 whereas we should skipped most of __cpufreq_remove_dev_prepare()
routine.

Lets fix it by moving the check for !frozen inside the first if block.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5e0a82e..0e11fcb 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1182,8 +1182,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		cpumask_clear_cpu(cpu, policy->cpus);
 	unlock_policy_rwsem_write(cpu);
 
-	if (cpu != policy->cpu && !frozen) {
-		sysfs_remove_link(&dev->kobj, "cpufreq");
+	if (cpu != policy->cpu) {
+		if (!frozen)
+			sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
 		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
 		if (new_cpu >= 0) {
-- 
1.7.12.rc2.18.g61b472e

