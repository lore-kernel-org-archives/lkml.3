Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaCEOZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbaCEOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 058/131] cpufreq: powernow-k8: Initialize per-cpu data-structures properly
Date: Wed,  5 Mar 2014 14:23:02 +0000
Message-Id: <1394029455-23128-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/powernow-k8.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c39d189..9292f1f 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1100,7 +1100,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
-	int rc;
+	int rc, cpu;
 
 	smp_call_function_single(pol->cpu, check_supported_cpu, &rc, 1);
 	if (rc)
@@ -1169,7 +1169,9 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 	pr_debug("cpu_init done, current fid 0x%x, vid 0x%x\n",
 		 data->currfid, data->currvid);
 
-	per_cpu(powernow_data, pol->cpu) = data;
+	/* Point all the CPUs in this policy to the same data */
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = data;
 
 	return 0;
 
@@ -1184,6 +1186,7 @@ err_out:
 static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
+	int cpu;
 
 	if (!data)
 		return -EINVAL;
@@ -1194,7 +1197,8 @@ static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	kfree(data->powernow_table);
 	kfree(data);
-	per_cpu(powernow_data, pol->cpu) = NULL;
+	for_each_cpu(cpu, pol->cpus)
+		per_cpu(powernow_data, cpu) = NULL;
 
 	return 0;
 }
-- 
1.9.0

