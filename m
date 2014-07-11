Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaGKGTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:19:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59634 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaGKGTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
	<1405052287-4744-1-git-send-email-skannan@codeaurora.org>
Date: Fri, 11 Jul 2014 11:49:38 +0530
Message-ID: <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

Thanks for trying this..

On 11 July 2014 09:48, Saravana Kannan <skannan@codeaurora.org> wrote:
> The CPUfreq driver moves the cpufreq policy ownership between CPUs when

s/driver/core

> CPUs within a cluster (CPUs sharing same policy) go ONLINE/OFFLINE. When
> moving policy ownership between CPUs, it also moves the cpufreq sysfs
> directory between CPUs and also fixes up the symlinks of the other CPUs in
> the cluster.
>
> Also, when all the CPUs in a cluster go OFFLINE, all the sysfs nodes and
> directories are deleted, the kobject is released and the policy is freed.
> And when the first CPU in a cluster comes up, the policy is reallocated and
> initialized, kobject is acquired, the sysfs nodes are created or symlinked,
> etc.
>
> All these steps end up creating unnecessarily complicated code and locking.
> There's no real benefit to adding/removing/moving the sysfs nodes and the
> policy between CPUs. Other per CPU sysfs directories like power and cpuidle
> are left alone during hotplug. So there's some precedence to what this
> patch is trying to do.
>
> This patch simplifies a lot of the code and locking by removing the
> adding/removing/moving of policy/sysfs/kobj and just leaves the cpufreq
> directory and policy in place irrespective of whether the CPUs are
> ONLINE/OFFLINE.
>
> Leaving the policy, sysfs and kobject in place also brings these additional
> benefits:
> * Faster suspend/resume.
> * Faster hotplug.
> * Sysfs file permissions maintained across hotplug without userspace
>   workarounds.
> * Policy settings and governor tunables maintained across suspend/resume
>   and hotplug.

Its already maintained during suspend/resume.

> * Cpufreq stats would be maintained across hotplug for all CPUs and can be
>   queried even after CPU goes OFFLINE.
>
> Change-Id: I39c395e1fee8731880c0fd7c8a9c1d83e2e4b8d0

remove these while sending stuff upstream..

> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>
> Preliminary testing has been done. cpufreq directories are getting created
> properly. Online/offline of CPUs work. Policies remain unmodifiable from
> userspace when all policy CPUs are offline.
>
> Error handling code has NOT been updated.
>
> I've added a bunch of FIXME comments next to where I'm not sure about the
> locking in the existing code. I believe most of the try_lock's were present
> to prevent a deadlock between sysfs lock and the cpufreq locks. Now that
> the sysfs entries are not touched after creating them, we should be able to
> replace most/all of these try_lock's with a normal lock.
>
> This patch has more room for code simplification, but I would like to get
> some acks for the functionality and this code before I do further
> simplification.
>
> I should also be able to remove get_online_cpus() in the store function and
> replace it with just a check for policy->governor_enabled. That should
> theoretically reduce some contention between cpufreq stats check and
> hotplug of unrelated CPUs.

Its just too much stuff in a single patch, I can still review it as I
am very much
aware of every bit of code written here. But would be very difficult for others
to review it. These are so many cases, configuration we have to think of
and adding bugs with such a large patch is so so so easy.

>  drivers/cpufreq/cpufreq.c | 331 ++++++++++------------------------------------
>  1 file changed, 69 insertions(+), 262 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62259d2..e350b15 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -859,16 +859,16 @@ void cpufreq_sysfs_remove_file(const struct attribute *attr)
>  }
>  EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
>
> -/* symlink affected CPUs */
> +/* symlink related CPUs */
>  static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>  {
> -       unsigned int j;
> +       unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>         int ret = 0;
>
> -       for_each_cpu(j, policy->cpus) {
> +       for_each_cpu(j, policy->related_cpus) {
>                 struct device *cpu_dev;
>
> -               if (j == policy->cpu)
> +               if (j == first_cpu)

why?

>                         continue;
>
>                 pr_debug("Adding link for CPU: %u\n", j);
> @@ -881,12 +881,16 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>         return ret;
>  }
>
> -static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
> -                                    struct device *dev)
> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>  {
>         struct freq_attr **drv_attr;
> +       struct device *dev;
>         int ret = 0;
>
> +       dev = get_cpu_device(cpumask_first(policy->related_cpus));
> +       if (!dev)
> +               return -EINVAL;
> +

Why?

>         /* prepare interface data */
>         ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
>                                    &dev->kobj, "cpufreq");
> @@ -961,60 +965,53 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>  }
>
>  #ifdef CONFIG_HOTPLUG_CPU
> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
> -                                 unsigned int cpu, struct device *dev)
> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
> +                                 unsigned int cpu, bool add)
>  {
>         int ret = 0;
> -       unsigned long flags;
> +       unsigned int cpus;
>
> -       if (has_target()) {
> +       down_write(&policy->rwsem);
> +       cpus = cpumask_weight(policy->cpus);
> +       if (has_target() && cpus > 0) {
>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>                 if (ret) {
>                         pr_err("%s: Failed to stop governor\n", __func__);
> -                       return ret;
> +                       goto unlock;
>                 }
>         }
>
> -       down_write(&policy->rwsem);
> -
> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -       cpumask_set_cpu(cpu, policy->cpus);
> -       per_cpu(cpufreq_cpu_data, cpu) = policy;
> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +       if (add)
> +               cpumask_set_cpu(cpu, policy->cpus);
> +       else
> +               cpumask_clear_cpu(cpu, policy->cpus);
>
> -       up_write(&policy->rwsem);
> +       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +                                       CPUFREQ_UPDATE_POLICY_CPU, policy);

This should be only called when policy->cpu is updated. And shouldn't
be called anymore and can be dropped as you might not wanna change
policy->cpu after this patch.

>
> -       if (has_target()) {
> +       cpus = cpumask_weight(policy->cpus);
> +       policy->cpu = cpumask_first(policy->cpus);

why update it at all? Also, as per your logic what if cpus == 0?

> +       if (has_target() && cpus > 0) {

Instead of > or < use cpus or !cpus.

>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
>                 if (!ret)
>                         ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>
>                 if (ret) {
>                         pr_err("%s: Failed to start governor\n", __func__);
> -                       return ret;
> +                       goto unlock;
>                 }
>         }
>
> -       return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> -}
> -#endif
> -
> -static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
> -{
> -       struct cpufreq_policy *policy;
> -       unsigned long flags;
> -
> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -       policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
> -
> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +       if (cpus < 1 && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {

Can be made 'else' part of above 'if', just need to move if(target)
inside the cpus > 1
block.

> +               cpufreq_driver->stop_cpu(policy);

Where is ->exit() gone?

> +       }
>
> -       policy->governor = NULL;
> +unlock:
> +       up_write(&policy->rwsem);
>
> -       return policy;
> +       return ret;
>  }
> +#endif
>
>  static struct cpufreq_policy *cpufreq_policy_alloc(void)
>  {
> @@ -1076,22 +1073,6 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
>         kfree(policy);
>  }
>
> -static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> -{
> -       if (WARN_ON(cpu == policy->cpu))
> -               return;
> -
> -       down_write(&policy->rwsem);
> -
> -       policy->last_cpu = policy->cpu;
> -       policy->cpu = cpu;
> -
> -       up_write(&policy->rwsem);
> -
> -       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> -                       CPUFREQ_UPDATE_POLICY_CPU, policy);
> -}
> -
>  static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  {
>         unsigned int j, cpu = dev->id;
> @@ -1099,9 +1080,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         struct cpufreq_policy *policy;
>         unsigned long flags;
>         bool recover_policy = cpufreq_suspended;
> -#ifdef CONFIG_HOTPLUG_CPU
> -       struct cpufreq_policy *tpolicy;
> -#endif
>
>         if (cpu_is_offline(cpu))
>                 return 0;
> @@ -1111,55 +1089,28 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  #ifdef CONFIG_SMP
>         /* check whether a different CPU already registered this
>          * CPU because it is in the same boat. */
> +       /* FIXME: This probably needs fixing to avoid "try lock" from
> +        * returning NULL. Also, change to likely() */

I wanted to give this comment later, but that's fine ..

- First, I couldn't understand the try-lock fixme
- Second likely() would be better
- policy will not be available only while adding first CPU of every cluster on
every driver registration..
- And you aren't freeing 'struct cpufreq_policy' at all now. Would result in
Memory leak cpufreq driver is compiled as a module and inserted/removed
multiple times.

>         policy = cpufreq_cpu_get(cpu);
>         if (unlikely(policy)) {
> +               cpufreq_change_policy_cpus(policy, cpu, true);
>                 cpufreq_cpu_put(policy);
>                 return 0;
>         }

This optimization wasn't for the hotplug case, but for adding non-policy->cpu
cpus for the first time.

In your case policy->cpus would already be updated and so calling
cpufreq_change_policy_cpus() isn't required.

>  #endif
>
> +       /* FIXME: Is returning 0 the right thing to do?! Existing code */
>         if (!down_read_trylock(&cpufreq_rwsem))
>                 return 0;

Yeah, must have a better return value. But as I said, these kind of changes
must be added in separate patches.

>
> -#ifdef CONFIG_HOTPLUG_CPU
> -       /* Check if this cpu was hot-unplugged earlier and has siblings */
> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
> -       list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
> -               if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
> -                       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -                       ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
> -                       up_read(&cpufreq_rwsem);
> -                       return ret;
> -               }
> -       }
> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -#endif

And this one was for the hotplug case which you could have reused.

> -       /*
> -        * Restore the saved policy when doing light-weight init and fall back
> -        * to the full init if that fails.
> -        */
> -       policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
> -       if (!policy) {
> -               recover_policy = false;
> -               policy = cpufreq_policy_alloc();
> -               if (!policy)
> -                       goto nomem_out;
> -       }

You might need to use it somehow.. Currently you are never doing
this:  per_cpu(cpufreq_cpu_data, cpu) = NULL;

which would result in crazy things once you try {un}registering your
driver...

> -       /*
> -        * In the resume path, since we restore a saved policy, the assignment
> -        * to policy->cpu is like an update of the existing policy, rather than
> -        * the creation of a brand new one. So we need to perform this update
> -        * by invoking update_policy_cpu().
> -        */
> -       if (recover_policy && cpu != policy->cpu)
> -               update_policy_cpu(policy, cpu);
> -       else
> -               policy->cpu = cpu;
> +       /* If we get this far, this is the first time we are adding the
> +        * policy */
> +       policy = cpufreq_policy_alloc();
> +       if (!policy)
> +               goto nomem_out;
> +       policy->cpu = cpu;
>
>         cpumask_copy(policy->cpus, cpumask_of(cpu));
> -
>         init_completion(&policy->kobj_unregister);
>         INIT_WORK(&policy->update, handle_update);
>
> @@ -1175,20 +1126,19 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         /* related cpus should atleast have policy->cpus */
>         cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>
> +       /* Weed out impossible CPUs. */
> +       cpumask_and(policy->related_cpus, policy->related_cpus,
> +                       cpu_possible_mask);

why?


Sorry but I am stopping now. I have already pointed out some issues
which make this unusable.

Over that, its way too hard to review all this in a single patch. For every
piece of line you add/remove I have to spend 10 mins thinking about
all the possible cases that were solved with this.. And if the rest of the
patch is going to fix them or not, etc.. To make it simple I did apply
your patch and had a close look at the new state of code, but its getting
tougher and tougher.

Please make sure you take care of these issues:
- suspend/resume
- hotplug
- module insert/remove
- Memory leaks
- multi cluster systems (with one and multiple CPU per cluster)
*by cluster I mean group of CPUs sharing clock line
- single cluster ones, one and multiple CPUs

Will see how V3 goes. Thanks.

--
viresh
