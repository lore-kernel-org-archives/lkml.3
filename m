Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3BGAfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:35:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54886 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab3BGAfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:35:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at kernel/workqueue.c:2811
Date: Thu, 07 Feb 2013 01:41:57 +0100
Message-ID: <1873989.qC1mdEKIl9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1543919.ZBNJa64WB5@vostro.rjw.lan>
References: <20130206202513.GA5626@thinkpad.lan> <1543919.ZBNJa64WB5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 10:11:25 PM Rafael J. Wysocki wrote:
> On Thursday, February 07, 2013 12:25:13 AM Artem Savkov wrote:
> > I get the following BUG on suspend using systemd-sleep(this doesn't
> > happen with pm-suspend). This seems to be introduced by some of the
> > Viresh's patches.
> 
> Which branch from which day?

OK, I've reproduced it and the appended patch fixes it for me.  Can you please
try it and report back?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: cpufreq: Move sysfs_remove_link() from under a spinlock

Commit 73bf0fc "cpufreq: Don't remove sysfs link for policy->cpu"
attempted to fix a bug in __cpufreq_remove_dev() by avoiding to
remove the link to the "cpufreq" directory for policy->cpu, but it
rearranged the code in such a way that sysfs_remove_link() ended up
under a spinlock, which caused complaints about sleeping in atomic
context to be emitted into the kernel log during system suspend.

To fix this, revert commit 73bf0fc partially and move the
sysfs_remove_link() in question to a separate block executed for
cpus > 1 outside of the spinlock.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/cpufreq.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: test/drivers/cpufreq/cpufreq.c
===================================================================
--- test.orig/drivers/cpufreq/cpufreq.c
+++ test/drivers/cpufreq/cpufreq.c
@@ -1058,9 +1058,7 @@ static int __cpufreq_remove_dev(struct d
 	cpus = cpumask_weight(data->cpus);
 	cpumask_clear_cpu(cpu, data->cpus);
 
-	if (cpu != data->cpu) {
-		sysfs_remove_link(&dev->kobj, "cpufreq");
-	} else if (cpus > 1) {
+	if (unlikely(cpu == data->cpu && cpus > 1)) {
 		/* first sibling now owns the new sysfs dir */
 		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
 		sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
@@ -1085,9 +1083,14 @@ static int __cpufreq_remove_dev(struct d
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
 	unlock_policy_rwsem_write(cpu);
-
-	/* If cpu is last user of policy, free policy */
-	if (cpus == 1) {
+	if (cpus > 1) {
+		sysfs_remove_link(&dev->kobj, "cpufreq");
+		if (cpufreq_driver->target) {
+			__cpufreq_governor(data, CPUFREQ_GOV_START);
+			__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+		}
+	} else {
+		/* If cpu is the last user of policy, free policy */
 		lock_policy_rwsem_write(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
@@ -1110,9 +1113,6 @@ static int __cpufreq_remove_dev(struct d
 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);
 		kfree(data);
-	} else if (cpufreq_driver->target) {
-		__cpufreq_governor(data, CPUFREQ_GOV_START);
-		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
 	}
 
 	return 0;


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
