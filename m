Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3GaX6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:58:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49614 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3GaX6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:58:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Subject: [RFC][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Thu, 01 Aug 2013 02:08:15 +0200
Message-ID: <2362640.pUofnXyzOi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The cpufreq core is a little inconsistent in the way it uses the
driver module refcount.

Namely, if __cpufreq_add_dev() is called for a CPU without siblings
or generally a CPU for which a new policy object has to be created,
it grabs a reference to the driver module to start with, but drops
that reference before returning.  As a result, the driver module
refcount is then equal to 0 after __cpufreq_add_dev() has returned.

On the other hand, if the given CPU is a sibling of some other
CPU already having a policy, cpufreq_add_policy_cpu() is called
to link the new CPU to the existing policy.  In that case,
cpufreq_cpu_get() is called to obtain that policy and grabs a
reference to the driver module, but that reference is not
released and the module refcount will be different from 0 after
__cpufreq_add_dev() returns (unless there is an error).  That
prevents the driver module from being unloaded until
__cpufreq_remove_dev() is called for all the CPUs that
cpufreq_add_policy_cpu() was called for previously.

To remove that inconsistency make cpufreq_add_policy_cpu() execute
cpufreq_cpu_put() for the given policy before returning, which
decrements the driver module refcount so that it will be 0 after
__cpufreq_add_dev() returns, but also make it take a reference to
the policy itself using kobject_get() and do not release that
reference (unless there's an error or system resume is under way),
which again is consistent with the "raw" __cpufreq_add_dev()
behavior.

Accordingly, modify __cpufreq_remove_dev() to use kobject_put() to
drop policy references taken by cpufreq_add_policy_cpu().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of current linux-pm.git/linux-next.

Thanks,
Rafael

---
 drivers/cpufreq/cpufreq.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/cpufreq.c
+++ linux-pm/drivers/cpufreq/cpufreq.c
@@ -908,8 +908,10 @@ static int cpufreq_add_policy_cpu(unsign
 	unsigned long flags;
 
 	policy = cpufreq_cpu_get(sibling);
-	WARN_ON(!policy);
+	if (WARN_ON_ONCE(!policy))
+		return -ENODATA;
 
+	kobject_get(&policy->kobj);
 	if (has_target)
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
@@ -932,14 +934,14 @@ static int cpufreq_add_policy_cpu(unsign
 	/* Don't touch sysfs links during light-weight init */
 	if (frozen) {
 		/* Drop the extra refcount that we took above */
-		cpufreq_cpu_put(policy);
-		return 0;
+		kobject_put(&policy->kobj);
+	} else {
+		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
+		if (ret)
+			kobject_put(&policy->kobj);
 	}
 
-	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
-	if (ret)
-		cpufreq_cpu_put(policy);
-
+	cpufreq_cpu_put(policy);
 	return ret;
 }
 #endif
@@ -1298,10 +1300,14 @@ static int __cpufreq_remove_dev(struct d
 		if (!frozen)
 			cpufreq_policy_free(data);
 	} else {
-
+		/*
+		 * There are more CPUs using the same policy, so only drop the
+		 * reference taken by cpufreq_add_policy_cpu() (unless the
+		 * system is suspending).
+		 */
 		if (!frozen) {
 			pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
-			cpufreq_cpu_put(data);
+			kobject_put(&data->kobj);
 		}
 
 		if (cpufreq_driver->target) {

