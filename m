Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaEUEVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:21:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41706 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaEUEVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:21:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Wt2n=uZF2oZ9pnjTTjU2E-fbjk40mNXDxE067Z6uutZA@mail.gmail.com>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
	<0fcd08cda4001198c02fb41f3e6437bf758417d1.1400302114.git.viresh.kumar@linaro.org>
	<CAD=FV=Wt2n=uZF2oZ9pnjTTjU2E-fbjk40mNXDxE067Z6uutZA@mail.gmail.com>
Date: Wed, 21 May 2014 09:51:30 +0530
Message-ID: <CAKohpokKgHvowYoUxac-4T8+2RsMMzF1MLm=Dv=29Vbu2HGh1Q@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 22:19, Doug Anderson <dianders@chromium.org> wrote:
> Note that in the old code you used to set the "emc" clock before the
> transition to the intermediate clock.  Now you don't.  Are you sure
> it's OK to change this order?

Yeah, I have seen that and as Stephen didn't had any objection to the
change I thought it is probably fine.

>> @@ -98,10 +88,21 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
>>         else
>>                 clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
>>
>> -       ret = tegra_cpu_clk_set_rate(rate * 1000);
>> +       if (rate == clk_get_rate(pll_p_clk))
>
> Shouldn't this be "rate * 1000 =="?

Yes.

>> +               goto out;
>> +
>> +       ret = clk_set_rate(pll_x_clk, rate * 1000);
>> +       if (ret) {
>> +               pr_err("Failed to change pll_x to %lu\n", rate);
>> +               goto out;
>> +       }
>
> I feel like this should be in tegra_target_intermediate(), since it
> could fail (right?).  Essentially we want to be as sure as possible
> that tegra_target() doesn't return an error code.
>
>
>> +
>> +       ret = clk_set_parent(cpu_clk, pll_x_clk);
>
> Presumably this won't actually ever fail, since that violates the
> rules that target() shouldn't fail if you used an intermediate
> frequency.

Don't know, it looks this rule isn't going to last long.. Let me see
if I can improve it a bit.
