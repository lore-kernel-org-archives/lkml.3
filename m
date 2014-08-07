Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaHGLGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:06:43 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:45591 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaHGLGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:06:40 -0400
MIME-Version: 1.0
In-Reply-To: <1406250448-470-6-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
	<1406250448-470-6-git-send-email-skannan@codeaurora.org>
Date: Thu, 7 Aug 2014 16:36:39 +0530
Message-ID: <CAKohpokrkRRBLcpWD8fc1LXYjT8AbxsD9x_x5akgtN_6=zEocg@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] cpufreq: Delete dead code related to policy save/restore
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
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

On 25 July 2014 06:37, Saravana Kannan <skannan@codeaurora.org> wrote:
> @@ -1142,31 +1124,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>
>         /* If we get this far, this is the first time we are adding the
>          * policy */

We don't need this comment as well..

> -       recover_policy = false;
> -
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
> -
> -       /*
> -        * In the resume path, since we restore a saved policy, the assignment
> -        * to policy->cpu is like an update of the existing policy, rather than
> -        * the creation of a brand new one. So we need to perform this update
> -        * by invoking update_policy_cpu().
> -        */
> -       if (recover_policy && cpu != policy->cpu)
> -               update_policy_cpu(policy, cpu);

Since we don't do this anymore, what will happen to policy->cpu after
all CPUs of a policy are hotplugged-out and then brought back in?

> -       else
> -               policy->cpu = cpu;
> +       policy = cpufreq_policy_alloc();
> +       if (!policy)
> +               goto nomem_out;
>
> +       policy->cpu = cpu;
>         cpumask_copy(policy->cpus, cpumask_of(cpu));
>
>         init_completion(&policy->kobj_unregister);
> @@ -1190,10 +1152,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>          */
>         cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
>
> -       if (!recover_policy) {
> -               policy->user_policy.min = policy->min;
> -               policy->user_policy.max = policy->max;
> -       }
> +       policy->user_policy.min = policy->min;
> +       policy->user_policy.max = policy->max;
>
>         down_write(&policy->rwsem);
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
> @@ -1252,13 +1212,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>                                      CPUFREQ_START, policy);
>
> -       if (!recover_policy) {
> -               ret = cpufreq_add_dev_interface(policy, dev);
> -               if (ret)
> -                       goto err_out_unregister;
> -               blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> -                               CPUFREQ_CREATE_POLICY, policy);
> -       }
> +       ret = cpufreq_add_dev_interface(policy, dev);
> +       if (ret)
> +               goto err_out_unregister;
> +       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +                       CPUFREQ_CREATE_POLICY, policy);
>
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
>         list_add(&policy->policy_list, &cpufreq_policy_list);
> @@ -1266,10 +1224,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>
>         cpufreq_init_policy(policy);
>
> -       if (!recover_policy) {
> -               policy->user_policy.policy = policy->policy;
> -               policy->user_policy.governor = policy->governor;
> -       }
> +       policy->user_policy.policy = policy->policy;
> +       policy->user_policy.governor = policy->governor;
>         up_write(&policy->rwsem);
>
>         kobject_uevent(&policy->kobj, KOBJ_ADD);
> @@ -1289,13 +1245,7 @@ err_get_freq:
>         if (cpufreq_driver->exit)
>                 cpufreq_driver->exit(policy);
>  err_set_policy_cpu:
> -       if (recover_policy) {
> -               /* Do not leave stale fallback data behind. */
> -               per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
> -               cpufreq_policy_put_kobj(policy);
> -       }
>         cpufreq_policy_free(policy);
> -
>  nomem_out:
>         up_read(&cpufreq_rwsem);
>
> @@ -1442,8 +1392,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>                         }
>                 }
>
> -               if (!cpufreq_suspended)
> -                       cpufreq_policy_put_kobj(policy);
> +               cpufreq_policy_put_kobj(policy);

Sure? This will free kobject.

>                 /*
>                  * Perform the ->exit() even during light-weight tear-down,
> @@ -1458,8 +1407,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>                 list_del(&policy->policy_list);
>                 write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> -               if (!cpufreq_suspended)
> -                       cpufreq_policy_free(policy);
> +               cpufreq_policy_free(policy);

Same here.

>         }
>
>         per_cpu(cpufreq_cpu_data, cpu) = NULL;
> --
> 1.8.2.1
>
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
