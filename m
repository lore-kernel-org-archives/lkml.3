Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaBQFVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:21:19 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50816 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaBQFVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <3582112.BRVGbkstFm@vostro.rjw.lan>
References: <3582112.BRVGbkstFm@vostro.rjw.lan>
Date: Mon, 17 Feb 2014 10:51:17 +0530
Message-ID: <CAKohpo=W+5cFRBfdL=dubXn_AJtN3_Ghx0+9AYdMR-CQe+sD8w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Refactor cpufreq_set_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2014 06:36, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Reduce the rampant usage of goto and the indentation level in
> cpufreq_set_policy() to improve the readability of that code.
>
> No functional changes should result from that.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |  102 ++++++++++++++++++++--------------------------
>  1 file changed, 45 insertions(+), 57 deletions(-)
>
> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -2018,22 +2018,21 @@ EXPORT_SYMBOL(cpufreq_get_policy);
>  static int cpufreq_set_policy(struct cpufreq_policy *policy,
>                                 struct cpufreq_policy *new_policy)
>  {
> -       int ret = 0, failed = 1;
> +       struct cpufreq_governor *old_gov;
> +       int ret;
>
>         pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
>                 new_policy->min, new_policy->max);
>
>         memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
>
> -       if (new_policy->min > policy->max || new_policy->max < policy->min) {
> -               ret = -EINVAL;
> -               goto error_out;
> -       }
> +       if (new_policy->min > policy->max || new_policy->max < policy->min)
> +               return -EINVAL;
>
>         /* verify the cpu speed can be set within this limit */
>         ret = cpufreq_driver->verify(new_policy);
>         if (ret)
> -               goto error_out;
> +               return ret;
>
>         /* adjust if necessary - all reasons */
>         blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> @@ -2049,7 +2048,7 @@ static int cpufreq_set_policy(struct cpu
>          */
>         ret = cpufreq_driver->verify(new_policy);
>         if (ret)
> -               goto error_out;
> +               return ret;
>
>         /* notification of the new policy */
>         blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> @@ -2064,58 +2063,47 @@ static int cpufreq_set_policy(struct cpu
>         if (cpufreq_driver->setpolicy) {
>                 policy->policy = new_policy->policy;
>                 pr_debug("setting range\n");
> -               ret = cpufreq_driver->setpolicy(new_policy);
> -       } else {
> -               if (new_policy->governor != policy->governor) {
> -                       /* save old, working values */
> -                       struct cpufreq_governor *old_gov = policy->governor;
> -
> -                       pr_debug("governor switch\n");
> -
> -                       /* end old governor */
> -                       if (policy->governor) {
> -                               __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -                               up_write(&policy->rwsem);
> -                               __cpufreq_governor(policy,
> -                                               CPUFREQ_GOV_POLICY_EXIT);
> -                               down_write(&policy->rwsem);
> -                       }
> -
> -                       /* start new governor */
> -                       policy->governor = new_policy->governor;
> -                       if (!__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
> -                               if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
> -                                       failed = 0;
> -                               } else {
> -                                       up_write(&policy->rwsem);
> -                                       __cpufreq_governor(policy,
> -                                                       CPUFREQ_GOV_POLICY_EXIT);
> -                                       down_write(&policy->rwsem);
> -                               }
> -                       }
> -
> -                       if (failed) {
> -                               /* new governor failed, so re-start old one */
> -                               pr_debug("starting governor %s failed\n",
> -                                                       policy->governor->name);
> -                               if (old_gov) {
> -                                       policy->governor = old_gov;
> -                                       __cpufreq_governor(policy,
> -                                                       CPUFREQ_GOV_POLICY_INIT);
> -                                       __cpufreq_governor(policy,
> -                                                          CPUFREQ_GOV_START);
> -                               }
> -                               ret = -EINVAL;
> -                               goto error_out;
> -                       }
> -                       /* might be a policy change, too, so fall through */
> -               }
> -               pr_debug("governor: change or update limits\n");
> -               ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +               return cpufreq_driver->setpolicy(new_policy);
>         }

Maybe a blank line here..

> +       if (new_policy->governor == policy->governor)
> +               goto out;

Otherwise: Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
