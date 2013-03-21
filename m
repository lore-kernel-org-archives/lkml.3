Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3CUW3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:29:06 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45592 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3CUW3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:29:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAPDyKFq4cPqVAfjbG7wZFS2B4PEt5ev_AkwBNi3LjL4OgxJ=tA@mail.gmail.com>
Cc: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1363151317.3311.9.camel@bilhuang-vm1> <51420EBB.7080503@wwwdotorg.org>
 <1363310454.3311.44.camel@bilhuang-vm1> <5142B027.4040403@wwwdotorg.org>
 <20130315093951.GV18519@tbergstrom-lnx.Nvidia.com>
 <CAPDyKFoBJpraMz8i1FmFqG7=Zsv0DTQ0PKVOQJ-+iEsKpb3Hdg@mail.gmail.com>
 <1363349206.5827.10.camel@bilhuang-vm1>
 <CAPDyKFpHz6KCNbVe2AsDuzZw-oN7NyRzCA=RatWA+9iMaQ7C+Q@mail.gmail.com>
 <514378CB.1060605@wwwdotorg.org>
 <CAPDyKFq4cPqVAfjbG7wZFS2B4PEt5ev_AkwBNi3LjL4OgxJ=tA@mail.gmail.com>
Message-ID: <20130321222852.834.43745@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [RFC 1/1] clk: Add notifier support in
 clk_prepare_enable/clk_disable_unprepare
Date: Thu, 21 Mar 2013 15:28:52 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ulf Hansson (2013-03-18 03:36:29)
> On 15 March 2013 20:38, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 03/15/2013 06:33 AM, Ulf Hansson wrote:
> >> On 15 March 2013 13:06, Bill Huang <bilhuang@nvidia.com> wrote:
> >>> On Fri, 2013-03-15 at 18:08 +0800, Ulf Hansson wrote:
> > ...
> >>>> Some prerequisites; I think am in favor of using the clk API to
> >>>> trigger DVFS changes and then I agree on that clk_prepare|unprepare
> >>>> needs to be possible to track from a DVFS perspective. clk_set_rate is
> >>>> not enough.
> >>>>
> >>>> So if we decide to do the above (using the clk API to trigger DVFS
> >>>> changes), I believe we should discuss two possible solutions;
> >>>> - clk notifiers or..
> >>>> - dvfs clock type.
> >>>>
> >>>> I am trying to make up my mind of what I think is the best solution.
> >>>> Have you considered "dvfs clock type"?
> >>>> I put some comments about this for "[PATCH 2/5] clk: notifier handler
> >>>> for dynamic voltage scaling" recently as well.
> >>>>
> >>>> What could the advantages/disadvantages be between the two options?
> >>>
> >>> I personally prefer clk notifiers since that's easy and all the existing
> >>> device drivers don't need to be modified, a new clock or API might be
> >>> more thoroughly considered (and hence maybe more graceful) but that
> >>> means we need more time to cook and many drivers need to plug into that
> >>> API when it comes out, a lot of test/verification or maybe chaos
> >>> follows, I'm not sure will that be a little overkill.
> >>
> >> I guess you did not fully got what I meant with "dvfs clock type". It
> >> will not affect the clock API. But instead the dvfs is handled by
> >> implementing a specific clk hw type. So the same thing is accomplished
> >> as with clk notifiers, no changes should be needed to device drivers.
> >>
> >> The difference is only that no notifiers will be needed, and all the
> >> dvfs stuff will be handled in the clk hw instead. It will mean that we
> >> will bundle dvfs stuff into the clock drivers, instead of separating
> >> the code outside the clock drivers. But, on the other hand no
> >> notifiers will be needed.
> >
> > The advantage here is that I assume that a notifier would continually
> > have to check whether the clock being modified was one that the DVFS
> > notifier cared about. By integrating the CVFS logic into the clk_hw
> > itself, it'll only ever get executed for clocks that really care about
> > DVFS. Presumably, the code that implements the clk_hw could also use
> > some common DVFS library as part of the implementation, and still share
> > code. Or perhaps, what about putting DVFS "ops" into a clk_hw alongside
> > any other existing ops, and having the clock core call them whenever
> > appropriate?
> 
> Thanks for your comment Stephen.
> 
> I agree to your reflections as well. It will probably be a more
> optimized solution going this direction and we don't have to add more
> "clk notifier code" to the clk API, which I guess is good.
> It would be interesting to get some input from some of the maintainers
> to this discussion as well, let's see.
> 

I do not like the dvfs clock type at all.  For the set of DVFS problems
that we are trying to solve, voltage scaling is more of a function of a
device's requirements than of a clock.  Put another way, we don't scale
voltage because a clock runs at a rate, we scale voltage because a
device runs at a rate.  That is why the clock rate change notifiers were
interesting for dvfs: the device scales the voltage in response to a
clock frequency change.

However it seems the rate-change notifiers are a bit messy for dvfs.

As such I'm currently hacking on a new rfc to introduce a separate dvfs
api.  Based on recent discussions and some face-to-face feedback I think
that kicking off DVFS transitions from the clock framework (which looks
very enticing at first glance) is coming at the problem from the wrong
direction.  A new api that builds on top of clocks, regulators and opps
is straight-forward, requires no weird cross-layer calls and is
generally cleaner.  The downside is that driver authors will have to
choose between using clk_set_rate or magic_dvfs_set_rate apis.  That
dilemma is entirely analogous to the runtime pm versus
clk_enable/clk_disable dilemma and hopefully won't be a big hurdle to
acceptance.

I'll post in the v2 thread as well, specifically addressing the
devfreq/clk_set_rate idea.

Regards,
Mike

> Kind regards
> Ulf Hansson
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
