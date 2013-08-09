Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030388Ab3HICIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:08:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967461Ab3HIB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [ 068/102] cpufreq: Fix cpufreq driver module refcount balance after suspend/resume
Date: Thu,  8 Aug 2013 18:57:44 -0700
Message-Id: <20130809015026.242310229@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 2a99859932281ed6c2ecdd988855f8f6838f6743 upstream.

Since cpufreq_cpu_put() called by __cpufreq_remove_dev() drops the
driver module refcount, __cpufreq_remove_dev() causes that refcount
to become negative for the cpufreq driver after a suspend/resume
cycle.

This is not the only bad thing that happens there, however, because
kobject_put() should only be called for the policy kobject at this
point if the CPU is not the last one for that policy.

Namely, if the given CPU is the last one for that policy, the
policy kobject's refcount should be 1 at this point, as set by
cpufreq_add_dev_interface(), and only needs to be dropped once for
the kobject to go away.  This actually happens under the cpu == 1
check, so it need not be done before by cpufreq_cpu_put().

On the other hand, if the given CPU is not the last one for that
policy, this means that cpufreq_add_policy_cpu() has been called
at least once for that policy and cpufreq_cpu_get() has been
called for it too.  To balance that cpufreq_cpu_get(), we need to
call cpufreq_cpu_put() in that case.

Thus, to fix the described problem and keep the reference
counters balanced in both cases, move the cpufreq_cpu_get() call
in __cpufreq_remove_dev() to the code path executed only for
CPUs that share the policy with other CPUs.

Reported-and-tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1075,14 +1075,11 @@ static int __cpufreq_remove_dev(struct d
 				__func__, cpu_dev->id, cpu);
 	}
 
-	if ((cpus == 1) && (cpufreq_driver->target))
-		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
-
-	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
-	cpufreq_cpu_put(data);
-
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
+		if (cpufreq_driver->target)
+			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+
 		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
@@ -1103,9 +1100,13 @@ static int __cpufreq_remove_dev(struct d
 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);
 		kfree(data);
-	} else if (cpufreq_driver->target) {
-		__cpufreq_governor(data, CPUFREQ_GOV_START);
-		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+	} else {
+		pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
+		cpufreq_cpu_put(data);
+		if (cpufreq_driver->target) {
+			__cpufreq_governor(data, CPUFREQ_GOV_START);
+			__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+		}
 	}
 
 	per_cpu(cpufreq_policy_cpu, cpu) = -1;


