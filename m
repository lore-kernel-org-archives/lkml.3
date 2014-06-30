Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaF3SeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:34:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42498 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbaF3SeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=dgSW551yzqjAV2_opw_4naqFEWpwUz9ktkGgR5vCBZA@mail.gmail.com>
References: <cover.1403684824.git.viresh.kumar@linaro.org> <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
 <53AB1CC1.4010907@codeaurora.org> <CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
 <53ACB568.4000903@codeaurora.org> <20140627015354.32686.83046@quantum>
 <CAKohponvN3rAvJrfi4TojFcq5gq7r2oNE4Q0_NtwBHmEZ8waBA@mail.gmail.com> <CAKohpo=dgSW551yzqjAV2_opw_4naqFEWpwUz9ktkGgR5vCBZA@mail.gmail.com>
From: Rob Herring <rob.herring@linaro.org>
Date: Mon, 30 Jun 2014 13:33:59 -0500
Message-ID: <CABGGiswMuofH5WRh4jgwh1=CV+fEXM_Ec3+WNwThbuMLVxsdcg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 2:57 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 27 June 2014 07:45, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 27 June 2014 07:23, Mike Turquette <mturquette@linaro.org> wrote:
>>>> but it isn't future-proof if/when the clock framework starts returning
>>>> dynamically allocated clock pointers for each clk_get() invocation.
>>>> Maybe we need a function in the common clock framework that tells us if
>>>> the clocks are the same either via DT or by taking two clock pointers?
>>>
>>> I looked through the patch briefly and did not see why we would need to
>>> do this. Any hint?
>>
>> We want to know which CPUs are sharing clock line, so that we can
>> fill affected-cpus field of cpufreq core.
>
> What about comparing "clocks" property in cpu DT nodes?

What if a different clock is selected for some reason. I think a clock
api function would be better.

That being said, I don't really have any issue with such a function.
Some comments on the implementation.

>
> @Rob/Grant: I tried looking for an existing routine to do that, but couldn't
> find it. And so wrote one.
>
> I am not good at DT stuff and so I do hope there would be few correction
> required here. Let me know if this can be added to drivers/of/base.c :
>
> +/**
> + * of_property_match - Match property in two nodes
> + * @np1, np2: Nodes to match
> + * @list_name: property to match
> + *
> + * Returns 1 on match, 0 on no match, and error for missing property.
> + */
> +static int of_property_match(const struct device_node *np1,
> +                             const struct device_node *np2,
> +                             const char *list_name)
> +{
> +       const __be32 *list1, *list2, *list1_end;

s/list/prop/

Everywhere.

> +       int size1, size2;
> +       phandle phandle1, phandle2;
> +
> +       /* Retrieve the list property */
> +       list1 = of_get_property(np1, list_name, &size1);
> +       if (!list1)
> +               return -ENOENT;
> +
> +       list2 = of_get_property(np2, list_name, &size2);
> +       if (!list2)
> +               return -ENOENT;
> +
> +       if (size1 != size2)
> +               return 0;
> +
> +       list1_end = list1 + size1 / sizeof(*list1);
> +
> +       /* Loop over the phandles */
> +       while (list1 < list1_end) {
> +               phandle1 = be32_to_cpup(list1++);
> +               phandle2 = be32_to_cpup(list2++);
> +
> +               if (phandle1 != phandle2)
> +                       return 0;
> +       }

You can just do a memcmp here.

This is wrong anyway because you don't know #clock-cells size.

Rob
