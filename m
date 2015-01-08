Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbbAHMlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:41:46 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4208 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbAHMln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:41:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 08 Jan 2015 04:40:14 -0800
Date: Thu, 8 Jan 2015 14:41:22 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Vince Hsu <vinceh@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150108124122.GY10073@tbergstrom-lnx.Nvidia.com>
References: <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
 <20150107141938.GA7392@nvidia.com>
 <20150107151206.GG1621@ulmo>
 <20150108093205.GV10073@tbergstrom-lnx.Nvidia.com>
 <20150108114153.GL1987@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150108114153.GL1987@ulmo.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.21.24.170]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:41:54PM +0100, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Jan 08, 2015 at 11:32:06AM +0200, Peter De Schrijver wrote:
> > > > And specify the dependencies between domains in DT?
> > > 
> > > I think the dependencies could be in the driver. Of course the power
> > > domains are per-SoC data, so really shouldn't be in the DTS either (the
> > > data is all implied by the compatible value) but there's no good way to
> > > get at the clocks and resets without DT, so I think that's a reasonable
> > > trade-off.
> > > 
> > > It seems to me like there are only two dependencies:
> > > 
> > > 	DIS and DISB depend on SOR
> > > 	VE depends on DIS
> > > 
> > > That's according to 5.6.6 "Programming Guide for Power Gating and
> > > Ungating" of the Tegra K1 TRM. It also seems like a bunch of modules are
> > > part of seemingly unrelated domains. Especially SOR seems to cover a
> > > large range of modules (MIPI-CAL, DPAUX, SOR, HDMI, DSI, DSIB and
> > > HDA2HDMI).
> > > 
> > > Given that we may want to more fine-grainedly control clocks to save
> > > power, don't we need to control clocks and resets within the drivers? I
> > > think the runtime PM framework makes sure to call this in the right
> > > order, so for suspend, the sequence would be:
> > > 
> > > 	1) device->suspend
> > > 	2) domain->suspend
> > > 
> > > and for resume:
> > > 
> > > 	1) domain->resume
> > > 	2) device->resume
> > > 
> > > But then we're back to square one, namely that the MC flush doesn't work
> > > properly, since it needs to be implemented in domain->suspend. Does that
> > > mean we can't clock-gate modules? In order to ensure a proper powergate
> > > sequence, the domain code would need to clk_enable() the module clock to
> > > make sure it stays on during the reset sequence. But if the domain code
> > > has a reference to the clock, then the driver can't clock-gate the
> > > module anymore by calling clk_disable().
> > > 
> > > Am I missing something?
> > > 
> > 
> > There's a difference between having a reference and actually enabling the
> > clock.
> 
> My point was that as long as anyone was keeping a reference the clock
> couldn't in fact be turned off.
> 
> > the domain powergate method will only be called when the clocks of
> > all modules in the domain are off.
> 
> No, the power domain will be disabled when all devices in the domain are
> idle.
> 
> > So the powergate method can then turn them on again, do the module
> > resets and client flushes and then disable them again. Same for
> > ungate. So I don't see a problem here?
> 
> I think that could work, but we'd need to make sure that drivers that
> use runtime PM and are connected to a power domain enable clocks only
> after taking a runtime PM reference and disable the clocks before they
> release that reference.
> 
> So to simplify things, maybe all clock handling for drivers should be
> moved into runtime PM operations, and whenever the driver needs the
> clock enabled it takes a runtime PM reference. That would ensure that
> clocks aren't accidentally left on.

Yes. That's exactly what needs to happen (apart from some special cases where
the driver also controls some clocks for the external signals like display.
those clocks most likely still need to be handled by the drivers).

Cheers,

Peter.
