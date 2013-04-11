Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab3DKIFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:05:13 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:38077 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3DKIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:05:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Call __cpufreq_governor() with correct policy->cpus mask
Date: Thu, 11 Apr 2013 13:34:53 +0530
Message-Id: <e3001264b4d7328b41130857adbb51e93d224c26.1365667475.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_governor() must be called with correct policy->cpus mask. In
__cpufreq_remove_dev() we initially clear policy->cpus with cpumask_clear_cpu()
and then call __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT). In case
governor is doing some per-cpu stuff in EXIT callback, this can create uncertain
behavior.

Generic governors in drivers/cpufreq/ doesn't do any per-cpu stuff in EXIT
callback and so we don't face any issues currently. But its better to keep the
code clean, so we don't face any issues in future.

Now, we call cpumask_clear_cpu() only when multiple cpus are managed by policy.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fd97a62..3564947 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1105,7 +1105,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	WARN_ON(lock_policy_rwsem_write(cpu));
 	cpus = cpumask_weight(data->cpus);
-	cpumask_clear_cpu(cpu, data->cpus);
+
+	if (cpus > 1)
+		cpumask_clear_cpu(cpu, data->cpus);
 	unlock_policy_rwsem_write(cpu);
 
 	if (cpu != data->cpu) {
-- 
1.7.12.rc2.18.g61b472e

