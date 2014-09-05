Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaIEHkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:40:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37961 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaIEHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:40:22 -0400
Subject: [PATCH V2 1/2] cpufreq: Allow stop CPU callback to be used by all
 cpufreq drivers
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: viresh.kumar@linaro.org, rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org, dirk.j.brandewie@intel.com,
        shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        patrick.marlier@gmail.com, linuxppc-dev@ozlabs.org,
        dirk.brandewie@gmail.com, svaidy@linux.vnet.ibm.com
Date: Fri, 05 Sep 2014 13:10:11 +0530
Message-ID: <20140905073944.3629.5923.stgit@preeti.in.ibm.com>
In-Reply-To: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
References: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090507-0928-0000-0000-0000049641EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 367dc4aa932bfb3 ("cpufreq: Add stop CPU callback to
cpufreq_driver interface") introduced the stop CPU callback for
intel_pstate drivers. During the CPU_DOWN_PREPARE stage, this
callback is invoked so that drivers can take some action on the
pstate of the cpu before it is taken offline. This callback was
assumed to be useful only for those drivers which have implemented
the set_policy CPU callback because they have no other way to take
action about the cpufreq of a CPU which is being hotplugged out
except in the exit callback which is called very late in the offline
process.

The drivers which implement the target/target_index callbacks were
expected to take care of requirements like the ones that commit
367dc4aa addresses in the GOV_STOP notification event. But there
are disadvantages to restricting the usage of stop CPU callback
to cpufreq drivers that implement the set_policy callbacks and who
want to take explicit action on the setting the cpufreq during a
hotplug operation.

1.GOV_STOP gets called for every CPU offline and drivers would usually
want to take action when the last cpu in the policy->cpus mask
is taken offline. As long as there is more than one cpu in the
policy->cpus mask, cpufreq core itself makes sure that the freq
for the other cpus in this mask is set according to the maximum load.
This is sensible and drivers which implement the target_index callback
would mostly not want to modify that. However the cpufreq core leaves a
loose end when the cpu in the policy->cpus mask is the last one to go offline;
it does nothing explicit to the frequency of the core. Drivers may need
a way to take some action here and stop CPU callback mechanism is the
best way to do it today.

2. We cannot implement driver specific actions in the GOV_STOP mechanism.
So we will need another driver callback which is invoked from here which is
unnecessary.

Therefore this patch extends the usage of stop CPU callback to be used
by all cpufreq drivers as long as they have this callback implemented
and irrespective of whether they are set_policy/target_index drivers.
The assumption is if the drivers find the GOV_STOP path to be a suitable
way of implementing what they want to do with the freq of the cpu
going offine,they will not implement the stop CPU callback at all.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d9fdedd..6463f35 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1380,7 +1380,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		if (!cpufreq_suspended)
 			pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 				 __func__, new_cpu, cpu);
-	} else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
+	} else if (cpufreq_driver->stop_cpu) {
 		cpufreq_driver->stop_cpu(policy);
 	}
 

