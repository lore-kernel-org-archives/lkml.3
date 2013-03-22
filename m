Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3CVLNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:13:00 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63299 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3CVLM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
Date: Fri, 22 Mar 2013 16:42:57 +0530
Message-ID: <CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Robin Randhawa <robin.randhawa@arm.com>,
        linux-pm@vger.kernel.org, Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 3:43 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
> with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
> zero.

Rafael,

Since this prevents booting on our hardware (we unregister and
re-register the cpufreq driver to account for virtual cores), will
this be considered as a hotfix for 3.9?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  drivers/cpufreq/cpufreq_stats.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 2fd779e..bfd6273 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -180,15 +180,19 @@ static void cpufreq_stats_free_sysfs(unsigned int cpu)
>  {
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>
> -       if (!cpufreq_frequency_get_table(cpu))
> +       if (!policy)
>                 return;
>
> -       if (policy && !policy_is_shared(policy)) {
> +       if (!cpufreq_frequency_get_table(cpu))
> +               goto put_ref;
> +
> +       if (!policy_is_shared(policy)) {
>                 pr_debug("%s: Free sysfs stat\n", __func__);
>                 sysfs_remove_group(&policy->kobj, &stats_attr_group);
>         }
> -       if (policy)
> -               cpufreq_cpu_put(policy);
> +
> +put_ref:
> +       cpufreq_cpu_put(policy);
>  }
>
>  static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
> --
> 1.7.12.rc2.18.g61b472e
>
