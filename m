Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaIDRHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:07:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20593 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754972AbaIDRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:07:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/fFVNhfJQtxPXc1tT7uicg
Date: Thu, 4 Sep 2014 10:07:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: phy: twl4030-usb: Move code from
 twl4030_phy_power to the runtime PM calls
Message-ID: <20140904170723.GA14282@atomide.com>
References: <1409182091-31191-1-git-send-email-tony@atomide.com>
 <1409182091-31191-4-git-send-email-tony@atomide.com>
 <54086E3D.4000200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54086E3D.4000200@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [140904 06:51]:
> Hi Tony,
> 
> On Thursday 28 August 2014 04:58 AM, Tony Lindgren wrote:
> > We don't need twl4030_phy_power() any longer now that we have
> > the runtime PM calls. Let's get rid of it as it's confusing.
> > No functional changes, just move the code and use res instead
> > of ret as we are not returning that value.
> 
> Now that you are doing pm_runtime_get_sync in twl4030_phy_init, won't it power
> on the phy even before initializing it (since runtime_resume will be invoked
> even before doing phy_init)?

Yes. The logic being that it should not matter as we are not
configuring the phy until in twl4030_phy_power_on(). Maybe we
should add code to make sure the phy is deconfigured initially
though :)

In twl4030_phy_init() we just want to check the ID pin state to get
things right initially. In the twl4030-usb case the I2C chip is
always on, but let's try to get the runtime PM set up like any
standard Linux driver would do it to avoid confusion.

> Even if pm_runtime_get_sync in not done in twl4030_phy_init, phy-core itself
> does pm_runtime_get_sync in phy_init().

Hmm OK. Looking at that, looks like we don't neeed any of these
custom exports though:

$ git grep phy_pm_runtime | grep EXPORT_SYMBOL
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get);
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_get_sync);
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put);
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_put_sync);
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_allow);
drivers/phy/phy-core.c:EXPORT_SYMBOL_GPL(phy_pm_runtime_forbid);

The reasons why I think we don't need the above at all is:

1. We already have a framework for that in Linux runtime PM and we
   can follow the standard Linux runtime PM calls and not proxy
   them in phy-core.c

2. We can allow idling the phy properly on the bus it's connected
   to, in this case I2C, even if USB driver is not loaded. We
   eventually should idle the phy even if usb_add_phy_dev()
   failed

3. There's no actual need for phy-core.c to proxy the runtime
   PM calls

So we can and should just let the phy drivers do their own runtime PM
as needed based on just the phy init, power_on and power_off calls.

Probably the same goes for the regulator_enable in phy-core.c. That
should be handled in the phy driver as phy-core is already unable
to handle it properly. For example, for phy-twl4030-usb.c we have
three regulators to deal with and the phy framework won't have any
idea how to deal with those.

And the phy-core won't be able to deal with the phy driver interrupts
anyways, so any attempt of doing finer grained runtime PM in phy-core
or handling of separate wake-up interrupts will be doomed to fail.

I think the changes above would simplify the phy handling quite
a bit, what do you think?

Regards,

Tony
