Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaA2Orf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:47:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:34367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaA2Ord (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466623833"
Date: Wed, 29 Jan 2014 16:47:00 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, george.cherian@ti.com,
        rogerq@ti.com, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140129144659.GA22152@xps8300>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
 <20140121144725.GF30451@saruman.home>
 <20140127150855.GA17928@xps8300>
 <20140127160458.GF13268@saruman.home>
 <20140128153230.GA20991@xps8300>
 <20140128163036.GD28546@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128163036.GD28546@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 28, 2014 at 10:30:36AM -0600, Felipe Balbi wrote:
> On Tue, Jan 28, 2014 at 05:32:30PM +0200, Heikki Krogerus wrote:
> > On Mon, Jan 27, 2014 at 10:05:20AM -0600, Felipe Balbi wrote:
> > For the controller drivers the PHYs are just a resource like any
> > other. The controller drivers can't have any responsibility of
> > them. They should not care if PHY drivers are available for them or
> > not, or even if the PHY framework is available or not.
> 
> huh? If memory isn't available you don't continue probing, right ? If
> your IORESOURCE_MEM is missing, you also don't continue probing, if your
> IRQ line is missing, you bail too. Those are also nothing but resources
> to the driver, what you're asking here is to treat PHY as a _different_
> resource; which might be fine, but we need to make sure we don't
> continue probing when a PHY is missing in a platform that certainly
> needs a PHY.

Yes, true. In my head I was comparing the PHY only to resources like
gpios, clocks, dma channels, etc. that are often optional to the
drivers.

> > > > > But I really want to see the argument against using no-op. As far as I
> > > > > could see, everybody needs a PHY driver one way or another, some
> > > > > platforms just haven't sent any PHY driver upstream and have their own
> > > > > hacked up solution to avoid using the PHY layer.
> > > > 
> > > > Not true in our case. Platforms using Intel's SoCs and chip sets may
> > > > or may not have controllable USB PHY. Quite often they don't. The
> > > > Baytrails have usually ULPI PHY for USB2, but that does not mean they
> > > > provide any vendor specific functions or any need for a driver in any
> > > > case.
> > > 
> > > that's different from what I heard.
> > 
> > I don't know where you got that impression, but it's not true. The
> > Baytrail SoCs for example don't have internal USB PHYs, which means
> > the manufacturers using it can select what they want. So we have
> > boards where PHY driver(s) is needed and boards where it isn't.
> 
> alright, that explains it ;-) So you have external USB2 and USB3 PHYs ?
> You have an external PIPE3 interface ? That's quite an achievement,
> kudos to your HW designers. Getting timing closure on PIPE3 is a
> difficult task.

No, only the USB2 PHY is external. I'm giving you wrong information,
I'm sorry about that. Need to concentrate on what I'm writing.

<snip>

> > This is really good to get. We have some projects where we are dealing
> > with more embedded environments, like IVI, where the kernel should be
> > stripped of everything useless. Since the PHYs are autonomous, we
> > should be able to disable the PHY libraries/frameworks.
> 
> hmmm, in that case it's a lot easier to treat. We can use
> ERR_PTR(-ENXIO) as an indication that the framework is disabled, or
> something like that.
> 
> The difficult is really reliably supporting e.g. OMAP5 (which won't work
> without a PHY) and your BayTrail with autonomous PHYs. What can we use
> as an indication ?

OMAP has it's own glue driver, so shouldn't it depend on the PHY
layer?

> I mean, I need to know that a particular platform depends on a PHY
> driver before I decide to return -EPROBE_DEFER or just assume the PHY
> isn't needed ;-)

I don't think dwc3 (core) should care about that. The PHY layer needs
to tell us that. If the PHY driver that the platform depends is not
available yet, the PHY layer returns -EPROBE_DEFER and dwc3 ends up
returning -EPROBE_DEFER.

<snip>

> > I think our goals are the same. I just want to also minimize the need
> > for any platform specific extra work from the upper layers regarding
> > the PHYs.
> 
> I'll agree to that, but let's not apply patches until we're 100% sure
> there will be no regressions. Looking at $subject, I don't think it
> satisfies that condition ;-)

Agreed. Let's think this through carefully.


Cheers,

-- 
heikki
