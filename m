Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3BEQVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:21:09 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57990 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3BEQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
Date: Tue, 5 Feb 2013 21:51:06 +0530
Message-ID: <CAKohpomK1jZMy=mQJFysbdeXZAuzWJ3gcStA+imYHouGfmcgLw@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, Borislav Petkov <bp@alien8.de>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 17:08, Viresh Kumar <viresh.kumar@linaro.org> wrote:
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
> This patchset is inclined towards fixing this issue.

After a long & hot discussion over the changes made by this patchset, following
patches came out:

--------------x------------------x-------------------

commit 15b5548c9ccfb8088270f7574710d9d67edfe33b
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Feb 5 21:29:05 2013 +0530

    cpufreq: Make governors directory sysfs location based on
have_multiple_policies

    Until now directory for governors tunables was getting created in
    cpu/cpufreq/<gov-name>. With the introduction of following patch:
    "cpufreq: governor: Implement per policy instances of governors"

    this directory would be created in
cpu/cpu<num>/cpufreq/<gov-name>. This might
    break userspace of existing platforms. Lets do this change only
for platforms
    which need support for multiple policies and thus above mentioned patch.

    From now on, such platforms would be require to do following from
their init()
    routines:

        policy->have_multiple_policies = true;

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_governor.c |  2 +-
 include/linux/cpufreq.h            | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 545ae24..41ee86f 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -300,7 +300,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
                                             dbs_data->cdata->gov_dbs_timer);
                }

-               rc = sysfs_create_group(&policy->kobj,
+               rc = sysfs_create_group(get_governor_parent_kobj(policy),
                                dbs_data->cdata->attr_group);
                if (rc) {
                        mutex_unlock(&dbs_data->mutex);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5dae7e6..6e1abd2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,11 @@ struct cpufreq_policy {
        unsigned int            policy; /* see above */
        struct cpufreq_governor *governor; /* see below */
        void                    *governor_data;
+       /* This should be set by init() of platforms having multiple
+        * clock-domains, i.e.  supporting multiple policies. With this sysfs
+        * directories of governor would be created in cpu/cpu<num>/cpufreq/
+        * directory */
+       bool                    have_multiple_policies;

        struct work_struct      update; /* if update_policy() needs to be
                                         * called, but you're in IRQ context */
@@ -134,6 +139,15 @@ static inline bool policy_is_shared(struct
cpufreq_policy *policy)
        return cpumask_weight(policy->cpus) > 1;
 }

+static inline struct kobject *
+get_governor_parent_kobj(struct cpufreq_policy *policy)
+{
+       if (policy->have_multiple_policies)
+               return &policy->kobj;
+       else
+               return cpufreq_global_kobject;
+}
+
 /******************** cpufreq transition notifiers *******************/

 #define CPUFREQ_PRECHANGE      (0)

--------------x------------------x-------------------

Plus the following patch, though i am still not in favor of this patch.
@Rafael: Please share your opinion too on this one. :)

--------------x------------------x-------------------
commit 1c7e9871fce7388136eda1c86ca75a520e4d3b9d
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Feb 5 21:41:40 2013 +0530

    cpufreq: Add Kconfig option to enable/disable have_multiple_policies

    have_multiple_policies is required by platforms having multiple
clock-domains
    for cpus, i.e. supporting multiple policies for cpus. This patch adds in a
    Kconfig option for enabling execution of this code.

    Requested-by: Borislav Petkov <bp@alien8.de>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig | 3 +++
 include/linux/cpufreq.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index cbcb21e..e6e6939 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -23,6 +23,9 @@ config CPU_FREQ_TABLE
 config CPU_FREQ_GOV_COMMON
        bool

+config CPU_FREQ_HAVE_MULTIPLE_POLICIES
+       bool
+
 config CPU_FREQ_STAT
        tristate "CPU frequency translation statistics"
        select CPU_FREQ_TABLE
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6e1abd2..a092fcb 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,11 +107,13 @@ struct cpufreq_policy {
        unsigned int            policy; /* see above */
        struct cpufreq_governor *governor; /* see below */
        void                    *governor_data;
+#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
        /* This should be set by init() of platforms having multiple
         * clock-domains, i.e.  supporting multiple policies. With this sysfs
         * directories of governor would be created in cpu/cpu<num>/cpufreq/
         * directory */
        bool                    have_multiple_policies;
+#endif

        struct work_struct      update; /* if update_policy() needs to be
                                         * called, but you're in IRQ context */
@@ -142,9 +144,11 @@ static inline bool policy_is_shared(struct
cpufreq_policy *policy)
 static inline struct kobject *
 get_governor_parent_kobj(struct cpufreq_policy *policy)
 {
+#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
        if (policy->have_multiple_policies)
                return &policy->kobj;
        else
+#endif
                return cpufreq_global_kobject;
 }


--------------x------------------x-------------------
