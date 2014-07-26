Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaGZTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:24:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaGZTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 093/109] cpufreq: move policy kobj to policy->cpu at resume
Date: Sat, 26 Jul 2014 12:02:55 -0700
Message-Id: <20140726190226.655268502@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1139,10 +1139,12 @@ static int __cpufreq_add_dev(struct devi
 	 * the creation of a brand new one. So we need to perform this update
 	 * by invoking update_policy_cpu().
 	 */
-	if (recover_policy && cpu != policy->cpu)
+	if (recover_policy && cpu != policy->cpu) {
 		update_policy_cpu(policy, cpu);
-	else
+		WARN_ON(kobject_move(&policy->kobj, &dev->kobj));
+	} else {
 		policy->cpu = cpu;
+	}
 
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 


