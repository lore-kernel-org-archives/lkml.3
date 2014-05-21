Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaEULfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:35:30 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:46686 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEULf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:35:28 -0400
MIME-Version: 1.0
In-Reply-To: <2c310ea534ac3cc181937bc8adf87c4695d6eb70.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
	<2c310ea534ac3cc181937bc8adf87c4695d6eb70.1400670427.git.viresh.kumar@linaro.org>
Date: Wed, 21 May 2014 17:05:27 +0530
X-Google-Sender-Auth: LwWMDadTkK8IYTpXx067_yQ9aW4
Message-ID: <CAOqmu80Q6_isHyZ89qu7fEj6GQjst_sBCRUTVyopdMthq7d=mw@mail.gmail.com>
Subject: Re: [PATCH V2 4/7] cpufreq: arm_big_little: don't initialize opp table
From: Inderpal Singh <inderpal.s@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linaro-kernel@lists.linaro.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arvind.chauhan@arm.com, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        sudeep.holla@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 4:40 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> OPP tables are already initialized for all CPUs by cpufreq core and so we don't
> need to reinitialize them from arm_big_little_dt driver.
>

I guess you wanted to say "cpu core code" instead of "cpufreq core".
Correction may be needed here and in the subsequent patches as well.


> Also, as the arm_big_little_dt driver doesn't have a .init_opp_table() callback
> anymore, make it optional in arm_big_little driver.
>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/arm_big_little.c    | 12 +++++++-----
>  drivers/cpufreq/arm_big_little_dt.c | 18 ------------------
>  2 files changed, 7 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
> index 1f4d4e3..561261e 100644
> --- a/drivers/cpufreq/arm_big_little.c
> +++ b/drivers/cpufreq/arm_big_little.c
> @@ -325,11 +325,13 @@ static int _get_cluster_clk_and_freq_table(struct device *cpu_dev)
>         if (freq_table[cluster])
>                 return 0;
>
> -       ret = arm_bL_ops->init_opp_table(cpu_dev);
> -       if (ret) {
> -               dev_err(cpu_dev, "%s: init_opp_table failed, cpu: %d, err: %d\n",
> +       if (arm_bL_ops->init_opp_table) {
> +               ret = arm_bL_ops->init_opp_table(cpu_dev);
> +               if (ret) {
> +                       dev_err(cpu_dev, "%s: init_opp_table failed, cpu: %d, err: %d\n",
>                                 __func__, cpu_dev->id, ret);
> -               goto out;
> +                       goto out;
> +               }
>         }
>
>         ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table[cluster]);
> @@ -542,7 +544,7 @@ int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops)
>                 return -EBUSY;
>         }
>
> -       if (!ops || !strlen(ops->name) || !ops->init_opp_table) {
> +       if (!ops || !strlen(ops->name)) {
>                 pr_err("%s: Invalid arm_bL_ops, exiting\n", __func__);
>                 return -ENODEV;
>         }
> diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
> index 8d9d591..502182d 100644
> --- a/drivers/cpufreq/arm_big_little_dt.c
> +++ b/drivers/cpufreq/arm_big_little_dt.c
> @@ -43,23 +43,6 @@ static struct device_node *get_cpu_node_with_valid_op(int cpu)
>         return np;
>  }
>
> -static int dt_init_opp_table(struct device *cpu_dev)
> -{
> -       struct device_node *np;
> -       int ret;
> -
> -       np = of_node_get(cpu_dev->of_node);
> -       if (!np) {
> -               pr_err("failed to find cpu%d node\n", cpu_dev->id);
> -               return -ENOENT;
> -       }
> -
> -       ret = of_init_opp_table(cpu_dev);
> -       of_node_put(np);
> -
> -       return ret;
> -}
> -
>  static int dt_get_transition_latency(struct device *cpu_dev)
>  {
>         struct device_node *np;
> @@ -81,7 +64,6 @@ static int dt_get_transition_latency(struct device *cpu_dev)
>  static struct cpufreq_arm_bL_ops dt_bL_ops = {
>         .name   = "dt-bl",
>         .get_transition_latency = dt_get_transition_latency,
> -       .init_opp_table = dt_init_opp_table,
>  };
>
>  static int generic_bL_probe(struct platform_device *pdev)
> --
> 2.0.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
