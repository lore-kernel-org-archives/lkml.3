Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaCYRWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:22:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaCYRWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:22:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/81] cpufreq: powernow-k8: Initialize per-cpu data-structures properly
Date: Tue, 25 Mar 2014 10:15:55 -0700
Message-Id: <1395767794-5012-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit c3274763bfc3bf1ececa269ed6e6c4d7ec1c3e5e upstream.

The powernow-k8 driver maintains a per-cpu data-structure called
powernow_data that is used to perform the frequency transitions.
It initializes this data structure only for the policy->cpu. So,
accesses to this data structure by other CPUs results in various
problems because they would have been uninitialized.

Specifically, if a cpu (!= policy->cpu) invokes the drivers' ->get()
function, it returns 0 as the KHz value, since its per-cpu memory
doesn't point to anything valid. This causes problems during
suspend/resume since cpufreq_update_policy() tries to enforce this
(0 KHz) as the current frequency of the CPU, and this madness gets
propagated to adjust_jiffies() as well. Eventually, lots of things
start breaking down, including the r8169 ethernet card, in one
particularly interesting case reported by Pierre Ossman.

Fix this by initializing the per-cpu data-structures of all the CPUs
in the policy appropriately.

References: https://bugzilla.kernel.org/show_bug.cgi?id=70311
Reported-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/powernow-k8.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 056faf6..69bf037 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1102,7 +1102,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
-	int rc;
+	int rc, cpu;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1174,7 +1174,9 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	pr_debug("cpu_init done, current fid 0x%x, vid 0x%x\n",
 		 data->currfid, data->currvid);
 
-	per_cpu(powernow_data, pol->cpu) = data;
+	/* Point all the CPUs in this policy to the same data */
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = data;
 
 	return 0;
 
@@ -1189,6 +1191,7 @@ err_out:
 static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
+	int cpu;
 
 	if (!data)
 		return -EINVAL;
@@ -1199,7 +1202,8 @@ static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	kfree(data->powernow_table);
 	kfree(data);
-	per_cpu(powernow_data, pol->cpu) = NULL;
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = NULL;
 
 	return 0;
 }
-- 
1.8.3.2

