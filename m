Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaCNGlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:41:12 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47487 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaCNGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:41:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xin.wang@arm.com, arvind.chauhan@arm.com, Sudeep.Holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: arm_big_little: set 'physical_cluster' for each cpu
Date: Fri, 14 Mar 2014 12:10:55 +0530
Message-Id: <354da516ba1facd6764bfc416ef13a59f9681d1c.1394779110.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
References: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
In-Reply-To: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
References: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a per-cpu variable for managing which cluster does a CPU belong to.
Currently physical_cluster is set only for the policy->cpu. And that results in
following on some SoC's:

- There are two clusters:
  - Cluster 0 has four ARM Cortex A7 CPUs (slower ones): 0,1,2,3
  - Cluster 1 has four ARM Cortex A15 CPUs (faster ones): 4,5,6,7
- CPUs are booted in order 0,1..7 and so initially policy->cpu for A7 cluster
  would be 0 and for A15 cluster would be 4.
- Now CPU4 (i.e. A15_0) is hotplugged out and so policy->cpu for A15 cluster
  becomes 5 (i.e. A15_1).
- But physical cluster is only set for CPU0 and CPU4 in ARM big LITTLE driver
  and isn't updated.
- Now freq change request comes for A15 cluster and we would try to update freq
  of physical_cluster of CPU5, i.e. A15_1. And it is currently set to zero
  (default value of uninitialized global variables).
- And so we actually try to change freq of A7 cluster instead of A15.
- This also results in kernel crash as sometimes we might request freq above
  A7's limit and CPU may behave badly..

Fix this by initializing physical_cluster for all CPUs of a policy.

(Adding signed-off by Xin as he reported this issue and provided this diff)

Signed-off-by: Xin Wang <xin.wang@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 3d87078..bad2ed3 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -446,9 +446,12 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 	}
 
 	if (cur_cluster < MAX_CLUSTERS) {
+		int cpu;
+
 		cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
 
-		per_cpu(physical_cluster, policy->cpu) = cur_cluster;
+		for_each_cpu(cpu, policy->cpus)
+			per_cpu(physical_cluster, cpu) = cur_cluster;
 	} else {
 		/* Assumption: during init, we are always running on A15 */
 		per_cpu(physical_cluster, policy->cpu) = A15_CLUSTER;
-- 
1.7.12.rc2.18.g61b472e

