Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaGCBYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:24:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48154 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGCBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:24:05 -0400
Message-ID: <53B4B0B3.9080000@codeaurora.org>
Date: Wed, 02 Jul 2014 18:24:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
References: <cover.1404231535.git.viresh.kumar@linaro.org> <CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
In-Reply-To: <CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 21:12, Viresh Kumar wrote:
> On 1 July 2014 22:02, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> V1: https://lkml.org/lkml/2014/6/25/152
>>
>> Stephen Boyd sent few patches some time back around a new cpufreq driver for
>> Qualcomm's Krait SoC: https://lkml.org/lkml/2014/6/24/918.
>>
>> Krait couldn't use existing cpufreq-cpu0 driver as it doesn't have support for
>> SoC's with multiple clusters or SoC's which don't share clock line across all
>> CPUs.
>>
>> This patchset is all about extending support beyond CPU0. It can be used for
>> platforms like Krait or ARM big LITTLE architecture now.
>>
>> First two patches add helper routine for of and clk layer, which would be used
>> by later patches.
>>
>> Third one adds space for driver specific data in 'struct cpufreq_policy' and
>> later ones migrate cpufreq-cpu0 to cpufreq-generic, i.e. can be used for SoCs
>> which don't share clock lines across all CPUs.
>>
>> @Stephen: I haven't added your Tested-by as there were few modifications since
>> the time you tested it last.
>>
>> Pushed here:
>> Rebased over v3.16-rc3:
>> git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v2
> Hi Stephen,
>
> As suggested by you I have updated patch
>
> 7/14: cpufreq: cpu0: OPPs can be populated at runtime
> 12/14: cpufreq: cpu0: Extend support beyond CPU0
>
> and dropped
> 2/14: clk: Create of_clk_shared_by_cpus()
>
> Please see if they look fine and work for you.
>
> git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v3

I gave it a spin. It works so you can have my

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

I'm still concerned about the patch where we figure out if the clocks
are shared. I worry about a configuration where there are different
clocks for on/off (i.e. gates) that are per-cpu but they all source from
the same divider or something that is per-cluster. In DT this may be
described as different clock provider outputs for the gates and in the
cpu node we would have different clock specifiers but in reality all the
CPUs in that cluster are affected by the same frequency scaling.

In this case we'll need to get help from the clock framework to
determine that those gates clocks don't have any .set_rate() callback so
they can't actually change rate independently, and then walk up the tree
to their parents to see if they have a common ancestor that does change
rates. That's where it becomes useful to have a clock framework API for
this, like clk_shares_rate(struct clk *clk, struct clk *peer) or
something that can hide all this from cpufreq. Here's what I think it
would look like (totally untested/uncompiled):

static struct clk *find_rate_changer(struct clk *clk)
{	

	if (!clk)
		return NULL; 

	do {
		/* Rate could change by changing parents */
		if (clk->num_parents > 1)
			return clk;

		/* Rate could change by calling clk_set_rate() */
		if (clk->ops->set_rate)
			return clk;

		/* 
		 * This is odd, clk_set_rate() doesn't propagate 
		 * and this clock can't change rate or parents
		 * so we must be at the root and the clock we
		 * started at can't change rates. Just return the
		 * root so that we can see if the other clock shares
		 * the same root although CPUfreq should never care.
		 */
		if (!(clk->flags & CLK_SET_RATE_PARENT))
			return clk;
	} while ((clk = clk->parent))

	return NULL;
}

bool clk_shares_rate(struct clk *clk, struct clk *peer)
{
	struct clk *p1, *p2;

	p1 = find_rate_changer(clk);
	p2 = find_rate_changer(peer)

	return p1 == p2;
}


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

