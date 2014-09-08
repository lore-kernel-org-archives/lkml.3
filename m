Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaIHQfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:35:03 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51834 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753267AbaIHQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:35:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193E/F9qoRqfqqOJWWRo65p
Date: Mon, 8 Sep 2014 09:34:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: phy: twl4030-usb: Move code from
 twl4030_phy_power to the runtime PM calls
Message-ID: <20140908163455.GE3238@atomide.com>
References: <1409182091-31191-1-git-send-email-tony@atomide.com>
 <1409182091-31191-4-git-send-email-tony@atomide.com>
 <54086E3D.4000200@ti.com>
 <20140904170723.GA14282@atomide.com>
 <540DBC68.7040905@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DBC68.7040905@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [140908 07:26]:
> Hi Tony,
> 
> On Thursday 04 September 2014 10:37 PM, Tony Lindgren wrote:
> > * Kishon Vijay Abraham I <kishon@ti.com> [140904 06:51]:
> >> Hi Tony,
> >>
> >> On Thursday 28 August 2014 04:58 AM, Tony Lindgren wrote:
> >>> We don't need twl4030_phy_power() any longer now that we have
> >>> the runtime PM calls. Let's get rid of it as it's confusing.
> >>> No functional changes, just move the code and use res instead
> >>> of ret as we are not returning that value.
> >>
> >> Now that you are doing pm_runtime_get_sync in twl4030_phy_init, won't it power
> >> on the phy even before initializing it (since runtime_resume will be invoked
> >> even before doing phy_init)?
> > 
> > Yes. The logic being that it should not matter as we are not
> > configuring the phy until in twl4030_phy_power_on(). Maybe we
> > should add code to make sure the phy is deconfigured initially
> > though :)
> > 
> > In twl4030_phy_init() we just want to check the ID pin state to get
> > things right initially. In the twl4030-usb case the I2C chip is
> > always on, but let's try to get the runtime PM set up like any
> > standard Linux driver would do it to avoid confusion.
> > 
> >> Even if pm_runtime_get_sync in not done in twl4030_phy_init, phy-core itself
> >> does pm_runtime_get_sync in phy_init().
> > 
> > Hmm OK. Looking at that, looks like we don't neeed any of these
> > custom exports though:
> > 
> > $ git grep phy_pm_runtime | grep EXPORT_SYMBOL
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get);
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get_sync);
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put);
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put_sync);
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_allow);
> > drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_forbid);
> > 
> > The reasons why I think we don't need the above at all is:
> > 
> > 1. We already have a framework for that in Linux runtime PM and we
> >    can follow the standard Linux runtime PM calls and not proxy
> >    them in phy-core.c
> 
> The reason for adding these are for providing fine grained control of the PHY
> by the controller drivers. In most cases the controller driver determines when
> the PHY should be active or idle.

Yeah but having the USB controller driver attempt to manage the
PHY did not work well. That all had to be ripped out of musb driver
in commits 30a70b026b4c and 8b2bc2c9351b.

I took a brief look at trying to fix musb + twl4030-usb runtime PM
so the USB controller driver would manage it. And that's probably
so far the only USB driver and PHY controller combo where we've had
runtime PM working in various forms in the mainline kernel.

Attempting to make the USB controller driver manage the runtime PM
for the PHY would make things unnecesarily complicated. The PHY can
sleep since it's on the I2C bus. So we'd have to implement some kind
of completion checking all over the place to attempt to keep things
in sync.

Meanwhile, having independent PHY drivers doing their own runtime
PM avoids all these issues. At minimum, it just means the PHY
driver needs to implement PHY init, power_on and power_off functions
like they already do. Then as needed, the PHY driver can implement
it's runtime PM calls.

I think what does make sense to do in the PHY framework is to keep
track of the PHY state in a generic way, and have a generic way of
telling the USB controller driver of the PHY state. That might allow
us eventually remove things like omap_musb_mailbox() calls.

And the custom exported functions above are unused AFAIK, so let's
just remove them.

> > 2. We can allow idling the phy properly on the bus it's connected
> >    to, in this case I2C, even if USB driver is not loaded. We
> >    eventually should idle the phy even if usb_add_phy_dev()
> >    failed
> 
> yes.. that's why we have ops like phy_power_on to tell when the PHY should be
> active. So these PHYs can be idled in probe.

Yeah phy_power_on et al are good, and needed. But the runtime PM
should be implemented in the actual PHY drivers because of the
reasons above.
 
> > 3. There's no actual need for phy-core.c to proxy the runtime
> >    PM calls
> > 
> > So we can and should just let the phy drivers do their own runtime PM
> > as needed based on just the phy init, power_on and power_off calls.
> > 
> > Probably the same goes for the regulator_enable in phy-core.c. That
> > should be handled in the phy driver as phy-core is already unable
> > to handle it properly. For example, for phy-twl4030-usb.c we have
> > three regulators to deal with and the phy framework won't have any
> > idea how to deal with those.
> 
> hmm.. It was modelled for basic PHY drivers that have a single regulator (e.g.,
> TI PIPE3 PHY). The idea is not to duplicate getting and enabling regulator in
> each of the PHY drivers when it can be abstracted in phy-core.

There's no need to for that AFAIK. That too can be implemented in the
PHY driver as part of runtime PM as needed.

Regards,

Tony
