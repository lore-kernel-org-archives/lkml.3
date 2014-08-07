Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaHGJCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:02:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35427 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaHGJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <1406250448-470-3-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
	<1406250448-470-3-git-send-email-skannan@codeaurora.org>
Date: Thu, 7 Aug 2014 14:32:03 +0530
Message-ID: <CAKohpomN_shuNTAkHEs-1+rqjM21RRZmeg41PNWY3AnSQOEGzA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] cpufreq: Keep track of which CPU owns the
 kobj/sysfs nodes separately
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
> The ownership of the kobj doesn't need to match policy->cpu or change as
> frequently. So, keep track of it separately.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/cpufreq/cpufreq.c | 4 +++-
>  include/linux/cpufreq.h   | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index ee0eb7b..af4f291 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -868,7 +868,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>         for_each_cpu(j, policy->cpus) {
>                 struct device *cpu_dev;
>
> -               if (j == policy->cpu)
> +               if (j == policy->kobj_cpu)
>                         continue;
>
>                 pr_debug("Adding link for CPU: %u\n", j);
> @@ -917,6 +917,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>                         goto err_out_kobj_put;
>         }
>
> +       policy->kobj_cpu = policy->cpu;

Not here but in __cpufreq_add_dev()..

>         ret = cpufreq_add_dev_symlink(policy);
>         if (ret)
>                 goto err_out_kobj_put;
> @@ -1330,6 +1331,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,

This doesn't exist anymore.

>
>                 return -EINVAL;
>         }
> +       policy->kobj_cpu = cpu_dev->id;
>
>         return cpu_dev->id;
>  }
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index ec4112d..91c2e38 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -68,6 +68,7 @@ struct cpufreq_policy {
>         unsigned int            cpu;    /* cpu nr of CPU managing this policy */
>         unsigned int            last_cpu; /* cpu nr of previous CPU that managed
>                                            * this policy */
> +       unsigned int            kobj_cpu; /* Tracks which CPU own the kobj */
>         struct clk              *clk;
>         struct cpufreq_cpuinfo  cpuinfo;/* see above */
>
> --
> 1.8.2.1
>
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
