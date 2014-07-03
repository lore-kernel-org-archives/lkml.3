Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbaGCWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:16:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38911 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbaGCWQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:16:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Lists linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Arvind Chauhan" <arvind.chauhan@arm.com>,
        linux-arm-msm@vger.kernel.org, "Sachin Kamat" <spk.linux@gmail.com>,
        "Thomas P Abraham" <thomas.ab@samsung.com>,
        "Shawn Guo" <shawn.guo@linaro.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Nishanth Menon" <nm@ti.com>, "Tomasz Figa" <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Michal Simek" <michal.simek@xilinx.com>,
        "Rob Herring" <rob.herring@linaro.org>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        "Simon Horman" <horms@verge.net.au>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
 <CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
 <53B4B0B3.9080000@codeaurora.org>
 <CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com>
Message-ID: <20140703221609.11380.6884@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Date: Thu, 03 Jul 2014 15:16:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Viresh Kumar (2014-07-02 19:44:04)
> On 3 July 2014 06:54, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > I gave it a spin. It works so you can have my
> >
> > Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Thanks, all suggested improvements are made and pushed again with
> your Tested-by..
> 
> > I'm still concerned about the patch where we figure out if the clocks
> > are shared. I worry about a configuration where there are different
> > clocks for on/off (i.e. gates) that are per-cpu but they all source from
> > the same divider or something that is per-cluster. In DT this may be
> > described as different clock provider outputs for the gates and in the
> > cpu node we would have different clock specifiers but in reality all the
> > CPUs in that cluster are affected by the same frequency scaling.
> 
> Yeah, this is probably what matches with Rob's doubt. These can
> actually be different. Good point.
> 
> > In this case we'll need to get help from the clock framework to
> > determine that those gates clocks don't have any .set_rate() callback so
> > they can't actually change rate independently, and then walk up the tree
> > to their parents to see if they have a common ancestor that does change
> > rates. That's where it becomes useful to have a clock framework API for
> > this, like clk_shares_rate(struct clk *clk, struct clk *peer) or
> > something that can hide all this from cpufreq. Here's what I think it
> > would look like (totally untested/uncompiled):
> >
> > static struct clk *find_rate_changer(struct clk *clk)
> > {
> >
> >         if (!clk)
> >                 return NULL;
> >
> >         do {
> >                 /* Rate could change by changing parents */
> >                 if (clk->num_parents > 1)
> >                         return clk;
> >
> >                 /* Rate could change by calling clk_set_rate() */
> >                 if (clk->ops->set_rate)
> >                         return clk;
> >
> >                 /*
> >                  * This is odd, clk_set_rate() doesn't propagate
> >                  * and this clock can't change rate or parents
> >                  * so we must be at the root and the clock we
> >                  * started at can't change rates. Just return the
> >                  * root so that we can see if the other clock shares
> >                  * the same root although CPUfreq should never care.
> >                  */
> >                 if (!(clk->flags & CLK_SET_RATE_PARENT))
> >                         return clk;
> >         } while ((clk = clk->parent))
> >
> >         return NULL;
> > }
> >
> > bool clk_shares_rate(struct clk *clk, struct clk *peer)
> > {
> >         struct clk *p1, *p2;
> >
> >         p1 = find_rate_changer(clk);
> >         p2 = find_rate_changer(peer)
> >
> >         return p1 == p2;
> > }
> 
> I find it much better then doing what I did initially, simply matching clk_get()
> outputs. Lets see what Mike has to say..

Sorry for being dense, but I still do not get why trying to dynamically
discover a shared rate-changeable clock is a better approach than simply
describing the hardware in DT?

Is adding a property to the CPU binding that describes how the CPUs in a
cluster expect to use a clock somehow a non-starter? It is certainly a
win for readability when staring at DT and trying to understand how DVFS
on that CPU is meant to work (as opposed to hiding that knowledge behind
a tree walk).

Regards,
Mike

> 
> @Mike: Is this less ugly ? :)
