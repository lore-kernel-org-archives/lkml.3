Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaGCCoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:44:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:38775 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGCCoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <53B4B0B3.9080000@codeaurora.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
	<53B4B0B3.9080000@codeaurora.org>
Date: Thu, 3 Jul 2014 08:14:04 +0530
Message-ID: <CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 July 2014 06:54, Stephen Boyd <sboyd@codeaurora.org> wrote:
> I gave it a spin. It works so you can have my
>
> Tested-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, all suggested improvements are made and pushed again with
your Tested-by..

> I'm still concerned about the patch where we figure out if the clocks
> are shared. I worry about a configuration where there are different
> clocks for on/off (i.e. gates) that are per-cpu but they all source from
> the same divider or something that is per-cluster. In DT this may be
> described as different clock provider outputs for the gates and in the
> cpu node we would have different clock specifiers but in reality all the
> CPUs in that cluster are affected by the same frequency scaling.

Yeah, this is probably what matches with Rob's doubt. These can
actually be different. Good point.

> In this case we'll need to get help from the clock framework to
> determine that those gates clocks don't have any .set_rate() callback so
> they can't actually change rate independently, and then walk up the tree
> to their parents to see if they have a common ancestor that does change
> rates. That's where it becomes useful to have a clock framework API for
> this, like clk_shares_rate(struct clk *clk, struct clk *peer) or
> something that can hide all this from cpufreq. Here's what I think it
> would look like (totally untested/uncompiled):
>
> static struct clk *find_rate_changer(struct clk *clk)
> {
>
>         if (!clk)
>                 return NULL;
>
>         do {
>                 /* Rate could change by changing parents */
>                 if (clk->num_parents > 1)
>                         return clk;
>
>                 /* Rate could change by calling clk_set_rate() */
>                 if (clk->ops->set_rate)
>                         return clk;
>
>                 /*
>                  * This is odd, clk_set_rate() doesn't propagate
>                  * and this clock can't change rate or parents
>                  * so we must be at the root and the clock we
>                  * started at can't change rates. Just return the
>                  * root so that we can see if the other clock shares
>                  * the same root although CPUfreq should never care.
>                  */
>                 if (!(clk->flags & CLK_SET_RATE_PARENT))
>                         return clk;
>         } while ((clk = clk->parent))
>
>         return NULL;
> }
>
> bool clk_shares_rate(struct clk *clk, struct clk *peer)
> {
>         struct clk *p1, *p2;
>
>         p1 = find_rate_changer(clk);
>         p2 = find_rate_changer(peer)
>
>         return p1 == p2;
> }

I find it much better then doing what I did initially, simply matching clk_get()
outputs. Lets see what Mike has to say..

@Mike: Is this less ugly ? :)
