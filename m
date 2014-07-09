Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaGIQJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:09:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14145 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGIQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:09:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Jul 2014 08:58:38 -0700
Date: Wed, 9 Jul 2014 19:09:25 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140709160925.GM23218@tbergstrom-lnx.Nvidia.com>
References: <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
 <20140709063130.GA3170@ulmo>
 <20140709083311.GE23218@tbergstrom-lnx.Nvidia.com>
 <20140709102551.GA19357@ulmo>
 <20140709110816.GF23218@tbergstrom-lnx.Nvidia.com>
 <20140709120400.GA3819@ulmo>
 <20140709124344.GK23218@tbergstrom-lnx.Nvidia.com>
 <20140709125613.GA3262@ulmo>
 <20140709132010.GL23218@tbergstrom-lnx.Nvidia.com>
 <20140709144216.GA32375@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140709144216.GA32375@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:42:18PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Jul 09, 2014 at 04:20:10PM +0300, Peter De Schrijver wrote:
> > On Wed, Jul 09, 2014 at 02:56:14PM +0200, Thierry Reding wrote:
> > > > Old Signed by an unknown key
> > > 
> > > On Wed, Jul 09, 2014 at 03:43:44PM +0300, Peter De Schrijver wrote:
> > > > On Wed, Jul 09, 2014 at 02:04:02PM +0200, Thierry Reding wrote:
> > > > > > For those 2 domains we can find the necessary clocks and resets by parsing
> > > > > > the relevant existing DT nodes for PCIe and gr3d. For clocks, this isn't
> > > > > > even needed as we can always register some extra clkdev's to get them. There
> > > > > > is no equivalent for resets so we have to parse the gr3d and pcie DT nodes,
> > > > > > but that's not too bad I think.
> > > > > 
> > > > > Even if we could really do this, at this point I don't see an advantage.
> > > > > All that it would be doing is move to some subsystem that doesn't quite
> > > > > match what we need just for the sake of moving to that subsystem. Having
> > > > > a Tegra-specific API doesn't sound so bad anymore.
> > > > > 
> > > > 
> > > > The advantage would be that we can use LP0/SC7 as a cpuidle state.
> > > 
> > > How is that going to work? And why does it need powergates to be
> > 
> > pm_runtime_get() and pm_runtime_put() hook into genpd. So genpd knows
> > when all devices in a domain are idle. It can then decide to turn off
> > the domain (based on the decision of a per domain governor). If all
> > domains are off (except for the non-powergateable domain), a special cpuidle
> > state can be enabled by genpd which will initiate a transition to LP0 without
> > actually doing a full system suspend.
> 
> Okay, I see.
> 
> > > implemented as power domains? If we switch off power gates, then we need
> > > to restore context in the drivers anyway, therefore I assume .suspend()
> > > and .resume() would need to be called, in which case powergate handling
> > > can surely be done at that stage, can't it?
> > > 
> > 
> > .suspend() and .resume() are not used for this. genpd uses other per device
> > callbacks to save and restore the state which are invoked when the domain
> > is turned off and on (.save_state and .restore_state). The major difference
> > with .suspend() and .resume() is that .suspend() has to perform 3 tasks:
> > prevent any new requests to the driver, finalize or cancel all outstanding
> > requests and save the hw context. .save_state will only be called when the
> > device is idle (based on the refcount controlled by pm_runtime_get() and
> > pm_runtime_put()) which means it only has to handle saving the hw context.
> 
> With the above, would it be possible to make turning off the domain
> conditional on whether or not all devices in the domain implement
> .save_state() and .restore_state()? That would allow us to convert to
> power domains and then stage in context save/restore in drivers (or even
> leave it out if there's not enough to be gained from turning the
> partition off).
> 

Maybe. I would have to check that.

> > > > Also system
> > > > resume from LP0 can be faster as we potentially don't have to resume all
> > > > domains at once.
> > > 
> > > I don't understand what that's got to do with anything. If we call into
> > > the PMC driver explicitly via tegra_powergate_*() functions from driver
> > > code, then we have full control over suspend/resume in the drivers, and
> > > therefore don't need to resume all at once either.
> > 
> > But then we would be duplicating all the bookkeeping required for this? What's
> > the point of that?
> 
> We're doing fine without any bookkeeping currently. I understand that
> this may change eventually, but I'm hesitant to start any conversion
> like this before we don't have a better understanding of how it should
> work (and actual use-cases which we can test). Also we've seen in the
> past that coding things up before we have enough use-cases we're bound
> to fail at coming up with a proper binding and then we have to keep
> carrying loads of code for compatibility.
> 
> So if you're willing to give this a shot, I'm not at all opposed to it
> generally. But we need to make sure that both the binding is reasonably
> future-proof and that we can actually test things like reference-counted
> power domains.
> 
> Now in the meantime there are a bunch of other drivers that will need to
> use the powergate API. DC is one of them. We haven't needed this before
> because we assumed the partitions would be on by default. That's not
> always the case apparently (ChromeOS does some funky things here). Both
> the SATA and XUSB drivers that have been posted use them as well and the
> nouveau driver that Alex has been working on uses at least parts of it.
> I don't think it's fair to keep them from being merged while we're
> trying to make the transition to power domains, but we should keep an
> eye on what's happening there so it doesn't conflict with any of the
> work we're planning for power domains.

The problem with this is that moving to the genpd APIs will become much more
difficult I'm afraid. I think we should maybe just make the pmc driver turn
on all the domains which were turned off by the bootloader. That way the
drivers don't need to handle the powerdomains at all for the time being.

Cheers,

Peter.
