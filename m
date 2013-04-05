Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161978Ab3DEP7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:59:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60394 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161724Ab3DEP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:58:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/pBtAtBx9lwcRCSUGfYZB9
Date: Fri, 5 Apr 2013 08:58:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, linux@arm.linux.org.uk, rnayak@ti.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        "Menon, Nishanth" <nm@ti.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130405155851.GA10155@atomide.com>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
 <1363703220-4777-2-git-send-email-rogerq@ti.com>
 <20130403234242.GE10155@atomide.com>
 <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515EA9E3.1010409@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130405 03:44]:
> On 04/04/2013 07:41 PM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [130404 00:39]:
> >> On 04/04/2013 02:42 AM, Tony Lindgren wrote:
> > For v3.10, let's just make sure that USB works with DT as then
> > after v3.10 we can make omap4 DT only and get rid of estimated
> > 7K lines of code and data. I guess this is the last piece missing
> > for that, or are we also missing something else?
> 
> For panda we just need a way to map the auxclk to the USB PHY device
> and the relevant dts data to get USB host working with DT.
> Beagle USB host should work already with DT without any changes.
> 
> > 
> > Can't you set up a clock alias for your device so it can find the
> > auxclk when requesting it with the dev entry?
> > 
> 
> which clock is mapped to which PHY device depends on board design
> and that cannot be per-determined at one place. This information
> needs to come from the board.dts file.

OK that makes sense.
 
> There was an earlier attempt to provide a way of building clock aliases
> at runtime from device tree [1], but the current approach is way better
> 
> [1]
> https://lkml.org/lkml/2013/3/12/241
> 
> > For the DT clock driver if needed for v3.10, how about just do a
> > minimal drivers/clock/omap/ that uses the standard binding?
> > Then that driver can just do clk_get() from cclock44xx_data.c
> 
> I don't understand how to do it and why it is better than the current
> approach.

Well your approach is fine as a first step moving all the clock
code, but it needs to be a real driver under drivers/clock/omap.
And the DT binding needs to stay the same for the driver(s) in the
long term as we start moving clocks to DT + /lib/firmware.

If this all is too late for v3.10, I suggest you just set up the
right clock alias for panda with machine_is_compatible flag in
board-generic.c so we get EHCI working with DT for v3.10. Then
it's easy to to deal with it properly for v3.11.

> How can that driver do clk_get() from cclock44xx_data.c?
> from where does it get the clk_id to pass into clk_get()?

Can't you just use the clock name there to get it?
 
> > for now? And then later on we'll just move all the clocks to a
> > combination of DT + /lib/firmware.
> 
> What is the benefit of moving clock data to /lib/firmware? We could
> as well just move it to DT only, no?

DT only clocks option is naturally available with this too. It
just gets easily inefficient with such a huge number of clocks.
 
> >> e.g. auxclk are required to be specified in DT nodes for USB PHY.
> >> Without this we can't get USB host working on Panda.
> > 
> > OK. So if the USB PHY has a dev entry, can't you just set up a
> > clock alias in struct omap_clk omap44xx_clks[] for it?
> 
> I've explained why this can't be done above.

Yes I understand now, the clock is board specific. 
  
> >> As Rajendra points out, it seems moving entire clock data to DT is not
> >> going to happen soon. So this is the simplistic way things can work.
> > 
> > Right but seems like we can get started there without moving
> > them all at once.
> > 
> What if we provide a complete clock list instead of only auxclks in
> dt_clks[]?
> 
> This approach is similar to arch/arm/mach-imx/clk-imx35.c
> 
> Device drivers can then use them as they migrate to DT. Then later
> we could migrate clock data to DT, without impacting device drivers.

As long as the binding stays the same in the long run too, this
clock remapping approach is just fine as a starting point. And
the driver needs to go to drivers/clock/omap. But in the long run
we just want to get the huge amounts static data out of the kernel
for clocks and hwmod data to fix things for good.

Regards,

Tony
