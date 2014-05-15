Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaEOKwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:52:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12912 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaEOKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:52:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 May 2014 03:46:48 -0700
Date: Thu, 15 May 2014 13:52:00 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Message-ID: <20140515105200.GI15168@tbergstrom-lnx.Nvidia.com>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140514142739.GA8612@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:27:40PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, May 13, 2014 at 12:09:49PM -0600, Stephen Warren wrote:
> > On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
> > > Add shared and cbus clocks to the Tegra124 clock implementation.
> > 
> > > diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
> > 
> > > +#define TEGRA124_CLK_C2BUS 401
> > > +#define TEGRA124_CLK_C3BUS 402
> > > +#define TEGRA124_CLK_GR3D_CBUS 403
> > > +#define TEGRA124_CLK_GR2D_CBUS 404
> > ...
> > 
> > I worry about this a bit. IIUC, these clocks don't actually exist in HW,
> > but are more a way of SW applying policy to the clock that do exist in
> > HW. As such, I'm not convinced it's a good idea to expose these clock
> > IDS to DT, since DT is supposed to represent the HW, and not be
> > influenced by internal SW implementation details.
> > 
> > Do any DTs actually need to used these new clock IDs? I don't think we
> > could actually use these value in e.g. tegra124.dtsi's clocks
> > properties, since these clocks don't exist in HW. Was it your intent to
> > do that? If not, can't we just define these SW-internal clock IDs in the
> > header inside the Tegra clock driver, so the values are invisible to DT?
> 
> I'm beginning to wonder if abusing clocks in this way is really the best
> solution. From what I understand there are two problems here that are
> mostly orthogonal though they're implemented using similar techniques.
> 
> The reason for introducing cbus clocks are still unclear to me. From the
> cover letter of this patch series it seems like these should be
> completely hidden from drivers and as such they don't belong in device
> tree. Also if they are an implementation detail, why are they even
> implemented as clocks? Perhaps an example use-case would help illustrate
> the need for this.

We don't have a PLL per engine, hence we have to use a PLL as parent for
several module clocks. However you can't change a PLLs rate with
active clients. So for scaling the PLL clocking eg. VIC or MSENC, you need to
change their parent to a different PLL, change the original PLL rate and change
the parent back to the original PLL, all while ensuring you never exceed the
maximum allowed clock at the current voltage. You also want to take into
account if a module is clocked so you don't bother handling clocks which are
disabled. (eg. if only the VIC clock is enabled, there is no point in changing
the MSENC parent). All this is handled by the 'cbus' clock.

> 
> As for shared clocks I'm only aware of one use-case, namely EMC scaling.
> Using clocks for that doesn't seem like the best option to me. While it
> can probably fix the immediate issue of choosing an appropriate
> frequency for the EMC clock it isn't a complete solution for the problem
> that we're trying to solve. From what I understand EMC scaling is one
> part of ensuring quality of service. The current implementations of that
> seems to abuse clocks (essentially one X.emc clock per X clock) to
> signal the amount of memory bandwidth required by any given device. But
> there are other parts to the puzzle. Latency allowance is one. The value
> programmed to the latency allowance registers for example depends on the
> EMC frequency.
> 

There are more usecases:

1) sclk scaling, which is similar to emc in that it has many modules who want
to influence this clock. The problem here is that sclk clocks the AVP
and is used as a parent for the AHB and APB clocks. So there are many drivers
who want to vote on this.

2) thermal capping. We want to limit eg the GPU clockrate due to thermals.

3) 'cbus' scaling. We want to scale the PLLs clocking several modules and
therefore several drivers need to be able to 'vote' on the rate. Also here
we don't want to take disabled clocks into account for the final rate
calculation.

Case 1 and 2 could presumably be handled by PM QoS, although for case 2 we
need to enforce an upper bound rather than a minimum rate. The PM QoS
maintainer has up to now rejected any patches which add PM QoS constraints
to limit a clock or another variable. For case 1 we could add a 
'bus throughput' QoS parameter to control sclk. The units would then be
MiB/s or something simlar. However sclk also clocks the AVP and would be
rather strange to require a driver to set a certain bus throughput requirement
to ensure the AVP runs fast enough.

For case 3, I don't see any existing mechanism to handle this. I don't think
PM QoS is helping here because PM QoS is supposed to deal with higher level
units (eg MiB/s), but in this case the only relationship between the modules
is that we run from the same PLL. So there is no higher level unit which makes
sense here.


Cheers,

Peter.
