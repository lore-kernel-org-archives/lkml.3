Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab3DAQ2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:28:50 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46487 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3DAQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:28:48 -0400
MIME-Version: 1.0
In-Reply-To: <1364830382-1271-1-git-send-email-nzimmer@sgi.com>
References: <5140E6A1.20107@sgi.com>
	<1364830382-1271-1-git-send-email-nzimmer@sgi.com>
Date: Mon, 1 Apr 2013 21:58:47 +0530
Message-ID: <CAKohpokv46CZEqGPx7AeJagyVx87L1RKhA9O2Ef=qAm24WUqtw@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: split the cpufreq_driver_lock and use the rcu
 (was cpufreq: cpufreq_driver_lock is hot on large systems)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

Welcome back :)

On 1 April 2013 21:03, Nathan Zimmer <nzimmer@sgi.com> wrote:

You need to resent this patch as we don't want current mail subject as commit
subject.. You could have used the area after three dashes "-" inside the
commit for logs which you don't want to commit.

> The cpufreq_driver_lock is hot with some configs.
> This lock covers both cpufreq_driver and cpufreq_cpu_data so part one of the

s/ so/, so/

> proposed fix is to split up the lock abit.

s/abit/a bit/

What's the other part?

> cpufreq_cpu_data is now covered by the cpufreq_data_lock.
> cpufreq_driver is now covered by the cpufreq_driver lock and the rcu.
>
> This means that the cpufreq_driver_lock is no longer hot.
> There remains some measurable heat on the cpufreq_data_lock it is significantly

s/it/but it/

> less then previous measured though.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/cpufreq/cpufreq.c | 305 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 222 insertions(+), 83 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> @@ -329,11 +339,23 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
>                                 struct cpufreq_governor **governor)
>  {
>         int err = -EINVAL;
> -
> -       if (!cpufreq_driver)
> +       struct cpufreq_driver *driver;
> +       int (*setpolicy)(struct cpufreq_policy *policy);
> +       int (*target)(struct cpufreq_policy *policy,
> +                     unsigned int target_freq,
> +                     unsigned int relation);

You can keep bools here instead of complex function pointers.
setpolicy_supported and target_supported

> +       rcu_read_lock();
> +       driver = rcu_dereference(cpufreq_driver);
> +       if (!driver) {
> +               rcu_read_unlock();
>                 goto out;
> +       }
> +       setpolicy = driver->setpolicy;
> +       target = driver->target;
> +       rcu_read_unlock();
>
> -       if (cpufreq_driver->setpolicy) {
> +       if (setpolicy) {
>                 if (!strnicmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
>                         *policy = CPUFREQ_POLICY_PERFORMANCE;
>                         err = 0;
> @@ -342,7 +364,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
>                         *policy = CPUFREQ_POLICY_POWERSAVE;
>                         err = 0;
>                 }
> -       } else if (cpufreq_driver->target) {
> +       } else if (target) {
>                 struct cpufreq_governor *t;
>
>                 mutex_lock(&cpufreq_governor_mutex);

> @@ -731,6 +766,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>  {
>         struct cpufreq_policy new_policy;
>         struct freq_attr **drv_attr;
> +       struct cpufreq_driver *driver;
> +       int (*exit)(struct cpufreq_policy *policy);

Declare it in the block which used it.

>         if (ret) {
>                 pr_debug("setting policy failed\n");
> -               if (cpufreq_driver->exit)
> -                       cpufreq_driver->exit(policy);
> +               rcu_read_lock();
> +               exit = rcu_dereference(cpufreq_driver)->exit;
> +               if (exit)
> +                       exit(policy);
> +               rcu_read_unlock();
> +
>         }

> @@ -1002,32 +1059,42 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>         unsigned int cpu = dev->id, ret, cpus;
>         unsigned long flags;
>         struct cpufreq_policy *data;
> +       struct cpufreq_driver *driver;
>         struct kobject *kobj;
>         struct completion *cmp;
>         struct device *cpu_dev;
> +       int (*target)(struct cpufreq_policy *policy,
> +                      unsigned int target_freq,
> +                      unsigned int relation);

can be bool?

> +       int (*exit)(struct cpufreq_policy *policy);
>


One more generic comment: What about a reader-writer lock for
cpufreq_data_lock??
