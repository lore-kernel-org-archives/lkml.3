Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3JQSQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:16:51 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60340 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3JQSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:16:48 -0400
Date: Thu, 17 Oct 2013 14:16:44 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Dave Martin <Dave.Martin@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
In-Reply-To: <52600A7D.2000809@linaro.org>
Message-ID: <alpine.LFD.2.03.1310171345300.1873@syhkavp.arg>
References: <20131017143204.GE2442@localhost.localdomain> <52600A7D.2000809@linaro.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Daniel Lezcano wrote:

> On 10/17/2013 04:32 PM, Dave Martin wrote:
> > On Thu, Oct 17, 2013 at 12:45:29PM +0200, Daniel Lezcano wrote:
> > > On 10/14/2013 05:08 PM, Vyacheslav Tyrtov wrote:
> > > > From: Tarek Dakhran <t.dakhran@samsung.com>
> > > > 
> > > > Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> > > > This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
> > 
> > [...]
> > 
> > > > +	__mcpm_cpu_down(cpu, cluster);
> > > > +
> > > > +	if (!skip_wfi) {
> > > > +		exynos_core_power_down(cpu, cluster);
> > > > +		wfi();
> > > > +	}
> > > > +}
> > > 
> > > I did not looked line by line but these functions looks very similar
> > > than the tc2_pm.c's function. no ?
> > 
> > This is true.
> > 
> > > May be some code consolidation could be considered here.
> > > 
> > > Added Nico and Lorenzo in Cc.
> > > 
> > > Thanks
> > >    -- Daniel
> > 
> > Nico can commnent further, but I think the main concern here was that
> > this code shouldn't be factored prematurely.
> 
> I do not share this opinion.
> 
> > There are many low-level platform specifics involved here, so it's
> > hard to be certain that all platforms could fit into a more abstracted
> > framework until we have some evidence to look at.
> > 
> > This could be revisited when we have a few diverse MCPM ports to
> > compare.
> 
> I am worried about seeing more and more duplicated code around the ARM arch
> (eg. arm[64]/kernel/smp.c arm64/kernel/smp.c).

I didn't look too closely at those files so can't comment much on them.

> The cpuidle drivers have been duplicated and it took a while before
> refactoring them, and it is not finished. The hotplug code have been
> duplicated and now it is very difficult to factor it out.
> 
> A lot of work have been done to consolidate the code across the different SoC
> since the last 2 years.
> 
> If we let duplicate code populate the different files, they will belong to
> different maintainers, thus different trees. Each SoC contributors will tend
> to add their small changes making the code to diverge more and more and making
> difficult to re-factor it later.
> 
> I am in favor of preventing duplicate code entering in the kernel and force
> the contributors to improve the kernel in general, not just the small part
> they are supposed to work on. Otherwise, we are letting the kernel to fork
> itself, internally...

Now I'm going to comment.

What you say above is perfectly right.  As a general principle, we want 
good consolidation.  That's the theory.

However you need to know what needs to be consolidated in the first 
place.  In practice you cannot consolidate duplicated code if that code 
doesn't exist. In the cpuidle and hotplug cases it is very easy now to 
see what kind of consolidation should have been done after the facts.  
I'm sure that 10 years ago that wasn't as obvious.

In the MCPM case we didn't know up front what exactly would end up being 
duplicated in each machine specific backend.  And to some extent we 
still don't know as there is very few backends merged into mainline at 
this point (I know more of them exist out of tree but I didn't see the 
code yet). Right now we have only 2 such backends and some duplication 
was already identified, hence the patch to abstract the v7 cache 
flushing I posted recently.

Another possibility for consolidation in the MCPM backends is the last 
man determination.  However we've seen that the PSCI compatibility 
backend doesn't need that and abstracting that just yet might be 
premature, possibly making interaction with PSCI very awkward.

So it is very important to get the right balance between code 
duplication and over-engineering.  Premature abstractions do fall into 
the over-engineering category and it is just as bad.  Above all it is 
most important to be vigilant and take care of duplicated code before it 
gets too big.

In the past we've seen bad code duplication in some subsystems because 
no one was looking at the big picture.  In the MCPM case I'm watching. 
And in this case we're far from being in a critical situation.


Nicolas
