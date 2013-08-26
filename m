Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3HZF2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:28:55 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53050 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3HZF2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-2-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 10:58:53 +0530
Message-ID: <CAKohpo=m=smN-qk45dSdq8SOwAyqtE1xLV-Y85GaCbVhBDsmjQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
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
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor nitpicking, nothing much :)

On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
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

In case ret wasn't 0 (i.e. we failed), we should print an error
message and break
our loop ?

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
> +
> +       ret = cpufreq_driver->set_boost(state);
> +       if (ret) {
> +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> +               cpufreq_driver->boost_enabled = !state;
> +               write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +               pr_err("%s: Cannot %s BOOST\n", __func__,
> +                      state ? "enabled" : "disabled");

s/enabled/enable and s/disabled/disable

> +       }
> +
> +       return ret;
> +}
> +
