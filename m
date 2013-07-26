Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3GZHRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:17:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59583 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3GZHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <1374770011-22171-3-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-3-git-send-email-l.majewski@samsung.com>
Date: Fri, 26 Jul 2013 12:47:15 +0530
Message-ID: <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

>  /*********************************************************************
> + *               BOOST                                              *
> + *********************************************************************/
> +static int cpufreq_boost_set_sw(int state)
> +{
> +       struct cpufreq_frequency_table *freq_table;
> +       struct cpufreq_policy *policy;
> +       int ret = -EINVAL;
> +
> +       list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
> +               freq_table = cpufreq_frequency_get_table(policy->cpu);
> +               if (freq_table) {
> +                       ret = cpufreq_frequency_table_cpuinfo(policy,
> +                                                       freq_table);
> +                       if (!ret) {
> +                               policy->user_policy.max = policy->max;
> +                               __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +                       }
> +               }
> +       }
> +
> +       return ret;
> +}
> +
> +int cpufreq_boost_trigger_state(int state)
> +{
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       if (cpufreq_driver->boost_enabled == state)
> +               return 0;
> +
> +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> +       cpufreq_driver->boost_enabled = state;
> +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);

Not sure if we should leave the lock at this point of time, as we
haven't enabled boost until now.

If somebody tries to use this variable at this point of time, then
it would get the wrong information about it.

> +       ret = cpufreq_driver->set_boost(state);
> +       if (ret) {
> +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> +               cpufreq_driver->boost_enabled = 0;

should be:
                    cpufreq_driver->boost_enabled = !state;

> +               write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +               pr_err("%s: BOOST cannot %s\n", __func__,

s/BOOST cannot %s/Cannot %s BOOST

> +                      state ? "enabled" : "disabled");
> +       }
> +
> +       return ret;
> +}
> +
> +int cpufreq_boost_supported(void)
> +{
> +       if (cpufreq_driver)

This routine is always called from places where cpufreq_driver
can't be NULL..

--contd--

> +               return cpufreq_driver->boost_supported;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
> +
> +int cpufreq_boost_enabled(void)
> +{
> +       return cpufreq_driver->boost_enabled;

And if above check is necessary, then don't you need to check
it here as well?

> +}
> +EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
> +
> +/*********************************************************************
>   *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
>   *********************************************************************/
>
> @@ -2008,9 +2099,25 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>         cpufreq_driver = driver_data;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +       if (cpufreq_boost_supported()) {
> +               /*
> +                * Check if boost driver provides function to enable boost -

s/boost driver/driver

> +                * if not, use cpufreq_boost_set_sw as default
> +                */
> +               if (!cpufreq_driver->set_boost)
> +                       cpufreq_driver->set_boost = cpufreq_boost_set_sw;
> +
> +               ret = cpufreq_sysfs_create_file(&(boost.attr));

You don't need braces around boost.attr.

> +               if (ret) {
> +                       pr_err("%s: cannot register global BOOST sysfs file\n",
> +                               __func__);
> +                       goto err_null_driver;
> +               }
> +       }
> +
>         ret = subsys_interface_register(&cpufreq_interface);
>         if (ret)
> -               goto err_null_driver;
> +               goto err_boost_unreg;
>
>         if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
>                 int i;
> @@ -2037,6 +2144,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>         return 0;
>  err_if_unreg:
>         subsys_interface_unregister(&cpufreq_interface);
> +err_boost_unreg:
> +       if (cpufreq_boost_supported())
> +               cpufreq_sysfs_remove_file(&(boost.attr));

same here.

>  err_null_driver:
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
>         cpufreq_driver = NULL;
> @@ -2063,6 +2173,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>         pr_debug("unregistering driver %s\n", driver->name);
>
>         subsys_interface_unregister(&cpufreq_interface);
> +       if (cpufreq_boost_supported())
> +               cpufreq_sysfs_remove_file(&(boost.attr));

here too.

> +
>         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>
>         write_lock_irqsave(&cpufreq_driver_lock, flags);

> +static ssize_t scaling_available_frequencies_show(struct cpufreq_policy *policy,
> +                                                 char *buf)
> +{
> +       return show_available_freqs(policy, buf, 0);

s/0/false

> +}

> +static ssize_t scaling_boost_frequencies_show(struct cpufreq_policy *policy,
> +                                             char *buf)
> +{
> +       return show_available_freqs(policy, buf, 1);

s/1/true

> +}

Looks good mostly.. We Should be to get it in 3.12 :)
