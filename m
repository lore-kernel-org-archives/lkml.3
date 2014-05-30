Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaE3B45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:56:57 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41663 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaE3B44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <53877103.8070604@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
	<53877103.8070604@wwwdotorg.org>
Date: Fri, 30 May 2014 07:26:55 +0530
Message-ID: <CAKohponsZOpV74+SLMDLy0oCV-j896wA9--bwbwk4GUL59m1ug@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 23:10, Stephen Warren <swarren@wwwdotorg.org> wrote:
> This patch breaks Tegra. The reason is below.

Lets see what blunder I made :)

>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>
>> -static int tegra_cpu_clk_set_rate(unsigned long rate)
>> +static unsigned int
>> +tegra_get_intermediate(struct cpufreq_policy *policy, unsigned int index)
>
> (BTW, can we please not put the return type on a separate line; it's
> inconsistent with the rest of the code in this file)

Sure.

>> +{
>> +     unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
>> +
>> +     /*
>> +      * Don't switch to intermediate freq if:
>> +      * - we are already at it, i.e. policy->cur == ifreq
>> +      * - index corresponds to ifreq
>> +      */
>> +     if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
>> +             return 0;
>
> If policy->cur == ifreq here, then tegra_target_intermediate() isn't
> called by the cpufreq core, so ...
>
>> +static int
>> +tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int index)
>>  {
>>       int ret;
>>
>>       /*
>>        * Take an extra reference to the main pll so it doesn't turn
>>        * off when we move the cpu off of it
>>        */
>>       clk_prepare_enable(pll_x_clk);
>
> ... that reference isn't added...
>
>> @@ -98,10 +96,23 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
>>       else
>>               clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
>>
>> -     ret = tegra_cpu_clk_set_rate(rate * 1000);
>> +     /* target freq == pll_p */
>> +     if (rate * 1000 == clk_get_rate(pll_p_clk)) {
>> +             ret = tegra_target_intermediate(policy, index);
>> +             goto disable_pll_x;
>> +     }
>
> ... and this code doesn't call it either, since we could be switching
> from the pll_p rate to something faster ...
>
>> +
>> +     ret = clk_set_rate(pll_x_clk, rate * 1000);
>> +     /* Restore to earlier frequency on error, i.e. pll_x */
>>       if (ret)
>> -             pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
>> -                     rate);
>> +             pr_err("Failed to change pll_x to %lu\n", rate);
>> +
>> +     ret = clk_set_parent(cpu_clk, pll_x_clk);
>> +     /* This shouldn't fail while changing or restoring */
>> +     WARN_ON(ret);
>> +
>> +disable_pll_x:
>> +     clk_disable_unprepare(pll_x_clk);
>
> ... so this turns off pll_x even though we're running from it.

Can you describe the role of the enable/disable of this pll_x_clk please?
Which all clocks depend on it, etc? So that I understand why its important
to enable it and for which clocks. And also if we need to disable it after
changing to any freq..

> It would be simpler if Tegra *always* used an intermediate frequency,
> and hence the core *always* called tegra_target_intermediate().
> Admittedly, this would result in tegra_target() sometimes (when
> switching CPU clock rate to the pll_p rate) doing nothing other than
> removing the extra reference on pll_x, but I think that the code would
> be simpler to follow and more robust.

Ok, will check what suits best.
