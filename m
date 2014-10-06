Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaJFEpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 00:45:34 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60565 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJFEpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 00:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>
References: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>
Date: Mon, 6 Oct 2014 10:15:31 +0530
Message-ID: <CAKohpon=dwc--SSbwjREdrALfXH=7QCw8UJnyVX5x3TCKB=7Bw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: respect the min/max settings from user space
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vince Hsu <vinceh@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>, dgreid@google.com,
        olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2014 12:25, Vince Hsu <vinceh@nvidia.com> wrote:
> When the user space tries to set scaling_(max|min)_freq through
> sysfs, the cpufreq_set_policy() asks other driver's opinions
> for the max/min frequencies. Some device drivers, like Tegra
> CPU EDP which is not upstreamed yet though, may constrain the
> CPU maximum frequency dynamically because of board design.
> So if the user space access happens and some driver is capping
> the cpu frequency at the same time, the user_policy->(max|min)
> is overridden by the capped value, and that's not expected by
> the user space. And if the user space is not invoked again,
> the CPU will always be capped by the user_policy->(max|min)
> even no drivers limit the CPU frequency any more.
>
> This patch preserves the user specified min/max settings, so that
> every time the cpufreq policy is updated, the new max/min can
> be re-evaluated correctly based on the user's expection and
> the present device drivers' status.
>
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
> Hi,
>
> I'm not sure if any platform that is supported mainlin might have this
> issue, and this patch is complie tested only.

Why only compiled tested? Why haven't you tested it on tegra?

>  drivers/cpufreq/cpufreq.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 24bf76fba141..c007cf2a3d2a 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -524,7 +524,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  static ssize_t store_##file_name                                       \
>  (struct cpufreq_policy *policy, const char *buf, size_t count)         \
>  {                                                                      \
> -       int ret;                                                        \
> +       int ret, temp;                                          \
>         struct cpufreq_policy new_policy;                               \
>                                                                         \
>         ret = cpufreq_get_policy(&new_policy, policy->cpu);             \
> @@ -535,8 +535,10 @@ static ssize_t store_##file_name                                   \
>         if (ret != 1)                                                   \
>                 return -EINVAL;                                         \
>                                                                         \
> +       temp = new_policy.object;                                       \
>         ret = cpufreq_set_policy(policy, &new_policy);          \
> -       policy->user_policy.object = policy->object;                    \
> +       if (!ret)                                                       \
> +               policy->user_policy.object = temp;                      \
>                                                                         \
>         return ret ? ret : count;                                       \
>  }

Looks fine otherwise.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
