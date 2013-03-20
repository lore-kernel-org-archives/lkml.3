Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab3CTF3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:29:16 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49217 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3CTF3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
Date: Wed, 20 Mar 2013 10:59:13 +0530
Message-ID: <CAKohponTZ29BX6CrUvFMy9RXV==0wRFu4C-W1xd6t1RmLASTvQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 13:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Currently, there can't be multiple instances of single governor_type. If we have
> a multi-package system, where we have multiple instances of struct policy (per
> package), we can't have multiple instances of same governor. i.e. We can't have
> multiple instances of ondemand governor for multiple packages.
>
> Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
> governor-name/. Which again reflects that there can be only one instance of a
> governor_type in the system.
>
> This is a bottleneck for multicluster system, where we want different packages
> to use same governor type, but with different tunables.
>
> This patch uses the infrastructure provided by earlier patch and implements
> init/exit routines for ondemand and conservative governors.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

As discussed in other patch thread, i dropped "cpufreq: Add Kconfig option
to enable/disable have_multiple_policies" patch and following is the fixup
to this patch:

I have queued all patches i had for 3.10 here:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-3.10

commit f02fca9a2478088c4f7dadf82d998ae007a56285
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Mar 20 10:50:33 2013 +0530

    fixup! cpufreq: governor: Implement per policy instances of governors
---
 drivers/cpufreq/cpufreq.c |  8 ++++++++
 include/linux/cpufreq.h   | 22 ++++++++--------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a843855..3d83b02 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -128,6 +128,14 @@ void disable_cpufreq(void)
 static LIST_HEAD(cpufreq_governor_list);
 static DEFINE_MUTEX(cpufreq_governor_mutex);

+struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy)
+{
+       if (cpufreq_driver->have_multiple_policies)
+               return &policy->kobj;
+       else
+               return cpufreq_global_kobject;
+}
+
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
        struct cpufreq_policy *data;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6e1abd2..805c4d3 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,11 +107,6 @@ struct cpufreq_policy {
        unsigned int            policy; /* see above */
        struct cpufreq_governor *governor; /* see below */
        void                    *governor_data;
-       /* This should be set by init() of platforms having multiple
-        * clock-domains, i.e.  supporting multiple policies. With this sysfs
-        * directories of governor would be created in cpu/cpu<num>/cpufreq/
-        * directory */
-       bool                    have_multiple_policies;

        struct work_struct      update; /* if update_policy() needs to be
                                         * called, but you're in IRQ context */
@@ -139,15 +134,6 @@ static inline bool policy_is_shared(struct
cpufreq_policy *policy)
        return cpumask_weight(policy->cpus) > 1;
 }

-static inline struct kobject *
-get_governor_parent_kobj(struct cpufreq_policy *policy)
-{
-       if (policy->have_multiple_policies)
-               return &policy->kobj;
-       else
-               return cpufreq_global_kobject;
-}
-
 /******************** cpufreq transition notifiers *******************/

 #define CPUFREQ_PRECHANGE      (0)
@@ -245,6 +231,13 @@ struct cpufreq_driver {
        struct module           *owner;
        char                    name[CPUFREQ_NAME_LEN];
        u8                      flags;
+       /*
+        * This should be set by init() of platforms having multiple
+        * clock-domains, i.e.  supporting multiple policies. With this sysfs
+        * directories of governor would be created in cpu/cpu<num>/cpufreq/
+        * directory
+        */
+       bool                    have_multiple_policies;

        /* needed by all drivers */
        int     (*init)         (struct cpufreq_policy *policy);
@@ -329,6 +322,7 @@ const char *cpufreq_get_current_driver(void);
  *********************************************************************/
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
+struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy);

 #ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq
couldn't detect it */
