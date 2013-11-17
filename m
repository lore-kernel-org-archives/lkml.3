Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3KQEN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 23:13:28 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:50066 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3KQENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 23:13:21 -0500
Message-ID: <5288425A.6000501@linaro.org>
Date: Sun, 17 Nov 2013 09:43:14 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across
 system suspend/resume
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan> <1384616184-6197-1-git-send-email-tianyu.lan@intel.com>
In-Reply-To: <1384616184-6197-1-git-send-email-tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2013 21:06, Lan Tianyu <tianyu.lan@intel.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> @@ -1818,9 +1818,13 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>                 mutex_unlock(&cpufreq_governor_lock);
>         }
>
> -       if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
> -                       ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> +       if ((event == CPUFREQ_GOV_POLICY_INIT) && ret) {
> +               module_put(policy->governor->owner);
> +               if (ret == -EALREADY)
> +                       return 0;
> +       } else if ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret) {
>                 module_put(policy->governor->owner);
> +       }

This can still be written more efficiently I believe:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 138ebe9..54e28e1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1866,10 +1866,12 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
        ret = policy->governor->governor(policy, event);

        if (!ret) {
-               if (event == CPUFREQ_GOV_POLICY_INIT)
+               if (event == CPUFREQ_GOV_POLICY_INIT) {
                        policy->governor->initialized++;
-               else if (event == CPUFREQ_GOV_POLICY_EXIT)
+               } else if (event == CPUFREQ_GOV_POLICY_EXIT) {
                        policy->governor->initialized--;
+                       module_put(policy->governor->owner);
+               }
        } else {
                /* Restore original values */
                mutex_lock(&cpufreq_governor_lock);
@@ -1877,13 +1879,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
                        policy->governor_enabled = true;
                else if (event == CPUFREQ_GOV_START)
                        policy->governor_enabled = false;
+               else if (event == CPUFREQ_GOV_POLICY_INIT)
+                       if (ret == -EALREADY) {
+                               module_put(policy->governor->owner);
+                               ret = 0;
+                       }
                mutex_unlock(&cpufreq_governor_lock);
        }

-       if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
-                       ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
-               module_put(policy->governor->owner);
-
        return ret;


>         return ret;
>  }
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 0806c31..ddb93af 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -204,9 +204,20 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>
>         switch (event) {
>         case CPUFREQ_GOV_POLICY_INIT:
> +               /*
> +                * In order to keep governor data across suspend/resume,
> +                * Governor doesn't exit when suspend and will be
> +                * reinitialized when resume. Here check policy governor
> +                * data to determine whether the governor has been exited.
> +                * If not, return EALREADY.
> +                */
>                 if (have_governor_per_policy()) {
> -                       WARN_ON(dbs_data);
> +                       if (dbs_data)
> +                               return -EALREADY;
>                 } else if (dbs_data) {
> +                       if (policy->governor_data == dbs_data)
> +                               return -EALREADY;
> +
>                         dbs_data->usage_count++;
>                         policy->governor_data = dbs_data;
>                         return 0;

But I don't really like the solution here. You are handling frozen for EXIT in
cpufreq-core and for INIT in governor. That doesn't look like the right
approach. There are out of tree governors too (I know we don't care about them
:)), and those also need to adapt with some policy made at cpufreq-core level.

I told you that I had another solution for this problem, pretty similar to
yours. It looked like this:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4fa06de..e70e906 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -408,7 +408,8 @@ show_one(scaling_max_freq, max);
 show_one(scaling_cur_freq, cur);

 static int cpufreq_set_policy(struct cpufreq_policy *policy,
-				struct cpufreq_policy *new_policy);
+				struct cpufreq_policy *new_policy,
+				bool frozen);

 /**
  * cpufreq_per_cpu_attr_write() / store_##file_name() - sysfs write access
@@ -428,7 +429,7 @@ static ssize_t store_##file_name					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
-	ret = cpufreq_set_policy(policy, &new_policy);		\
+	ret = cpufreq_set_policy(policy, &new_policy, false);		\
 	policy->user_policy.object = policy->object;			\
 									\
 	return ret ? ret : count;					\
@@ -486,7 +487,7 @@ static ssize_t store_scaling_governor(struct cpufreq_policy
*policy,
 						&new_policy.governor))
 		return -EINVAL;

-	ret = cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy, false);

 	policy->user_policy.policy = policy->policy;
 	policy->user_policy.governor = policy->governor;
@@ -822,7 +823,7 @@ err_out_kobj_put:
 	return ret;
 }

-static void cpufreq_init_policy(struct cpufreq_policy *policy)
+static void cpufreq_init_policy(struct cpufreq_policy *policy, bool frozen)
 {
 	struct cpufreq_policy new_policy;
 	int ret = 0;
@@ -832,7 +833,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 	policy->governor = NULL;

 	/* set default policy */
-	ret = cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy, frozen);
 	policy->user_policy.policy = policy->policy;
 	policy->user_policy.governor = policy->governor;

@@ -1077,7 +1078,7 @@ static int __cpufreq_add_dev(struct device *dev, struct
subsys_interface *sif,
 	list_add(&policy->policy_list, &cpufreq_policy_list);
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);

-	cpufreq_init_policy(policy);
+	cpufreq_init_policy(policy, frozen);

 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	up_read(&cpufreq_rwsem);
@@ -1239,17 +1240,17 @@ static int __cpufreq_remove_dev_finish(struct device *dev,

 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (has_target()) {
-			ret = __cpufreq_governor(policy,
-					CPUFREQ_GOV_POLICY_EXIT);
-			if (ret) {
-				pr_err("%s: Failed to exit governor\n",
-						__func__);
-				return ret;
+		if (!frozen) {
+			if (has_target()) {
+				ret = __cpufreq_governor(policy,
+						CPUFREQ_GOV_POLICY_EXIT);
+				if (ret) {
+					pr_err("%s: Failed to exit governor\n",
+							__func__);
+					return ret;
+				}
 			}
-		}

-		if (!frozen) {
 			down_read(&policy->rwsem);
 			kobj = &policy->kobj;
 			cmp = &policy->kobj_unregister;
@@ -1920,7 +1921,7 @@ EXPORT_SYMBOL(cpufreq_get_policy);
  * new_policy: policy to be set.
  */
 static int cpufreq_set_policy(struct cpufreq_policy *policy,
-				struct cpufreq_policy *new_policy)
+				struct cpufreq_policy *new_policy, bool frozen)
 {
 	int ret = 0, failed = 1;

@@ -1987,7 +1988,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,

 			/* start new governor */
 			policy->governor = new_policy->governor;
-			if (!__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
+			if (frozen || !__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
 				if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
 					failed = 0;
 				} else {
@@ -2065,7 +2066,7 @@ int cpufreq_update_policy(unsigned int cpu)
 		}
 	}

-	ret = cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy, false);

 	up_write(&policy->rwsem);

-------------------------------

But after the PM notifiers patch I even don't want this to go.. I will make sure
that that patch goes in, in one form or another :)

So, just wait for sometime before posting a new version :) (I know you did it
because Rafael suggested a change)..
