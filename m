Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbaHHWbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:31:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaHHUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 148/259] cpufreq: move policy kobj to policy->cpu at resume
Date: Fri,  8 Aug 2014 13:39:31 -0700
Message-Id: <1407530482-4483-149-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 92c14bd9477a20a83144f08c0ca25b0308bf0730 upstream.

This is only relevant to implementations with multiple clusters, where clusters
have separate clock lines but all CPUs within a cluster share it.

Consider a dual cluster platform with 2 cores per cluster. During suspend we
start hot unplugging CPUs in order 1 to 3. When CPU2 is removed, policy->kobj
would be moved to CPU3 and when CPU3 goes down we wouldn't free policy or its
kobj as we want to retain permissions/values/etc.

Now on resume, we will get CPU2 before CPU3 and will call __cpufreq_add_dev().
We will recover the old policy and update policy->cpu from 3 to 2 from
update_policy_cpu().

But the kobj is still tied to CPU3 and isn't moved to CPU2. We wouldn't create a
link for CPU2, but would try that for CPU3 while bringing it online. Which will
report errors as CPU3 already has kobj assigned to it.

This bug got introduced with commit 42f921a, which overlooked this scenario.

To fix this, lets move kobj to the new policy->cpu while bringing first CPU of a
cluster back. Also do a WARN_ON() if kobject_move failed, as we would reach here
only for the first CPU of a non-boot cluster. And we can't recover from this
situation, if kobject_move() fails.

Fixes: 42f921a6f10c (cpufreq: remove sysfs files for CPUs which failed to come back after resume)
Reported-and-tested-by: Bu Yitian <ybu@qti.qualcomm.com>
Reported-by: Saravana Kannan <skannan@codeaurora.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa@mit.edu>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: backport to 3.13-stable (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 99a443e..c166b4a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1031,10 +1031,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 * the creation of a brand new one. So we need to perform this update
 	 * by invoking update_policy_cpu().
 	 */
-	if (frozen && cpu != policy->cpu)
+	if (frozen && cpu != policy->cpu) {
 		update_policy_cpu(policy, cpu);
-	else
+		WARN_ON(kobject_move(&policy->kobj, &dev->kobj));
+	} else {
 		policy->cpu = cpu;
+	}
 
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
-- 
1.9.1

