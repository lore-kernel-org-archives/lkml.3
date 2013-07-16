Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3GPJl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:41:57 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36163 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3GPJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <1372927830-2949-3-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-3-git-send-email-l.majewski@samsung.com>
Date: Tue, 16 Jul 2013 15:11:54 +0530
Message-ID: <CAKohpomfWKiRjznXeYsg32xAAWPTBQ4Gd0D_pftbA5=zMDiH4Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> +int cpufreq_boost_trigger_state(int state)
> +{
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       if (boost_enabled != state) {
> +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> +               boost_enabled = state;
> +
> +               ret = cpufreq_driver->enable_boost(state);
> +               if (ret)
> +                       boost_enabled = 0;
> +
> +               write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +               if (ret)
> +                       pr_err("%s: BOOST cannot enable (%d)\n",

Who said we are enabling it?

> +                              __func__, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +int cpufreq_boost_supported(void)
> +{
> +       if (cpufreq_driver)
> +               return cpufreq_driver->boost_supported;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
> +
> +int cpufreq_boost_enabled(void)
> +{
> +       return boost_enabled;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
> +
> +void cpufreq_set_boost_enabled(int state)

Maybe cpufreq_block_boost? As suggested by Rafael.

> +{
> +       boost_enabled = state;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_set_boost_enabled);
> +
> +/*********************************************************************
>   *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
>   *********************************************************************/
>
> @@ -2001,6 +2094,22 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>         cpufreq_driver = driver_data;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +       if (cpufreq_driver->boost_supported) {
> +               /*
> +                * Check if boost driver provides function to enable boost -
> +                * if not, use cpufreq_boost_enable_sw as default
> +                */
> +               if (!cpufreq_driver->enable_boost)
> +                       cpufreq_driver->enable_boost = &cpufreq_boost_enable_sw;

& is redundant.
