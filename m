Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3G2JVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:21:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16521 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3G2JVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:21:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YA/l71OLUCG2FDfA0QyDu
Date: Mon, 29 Jul 2013 02:21:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130729092116.GA7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70B5D.6030802@wwwdotorg.org>
 <20130718073638.GP7656@atomide.com>
 <51E84180.6080902@wwwdotorg.org>
 <20130719073957.GZ7656@atomide.com>
 <51E98C71.5010709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E98C71.5010709@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130719 12:05]:
> On 07/19/2013 01:39 AM, Tony Lindgren wrote:
> > 
> > I think the only sane way to deal with this is to make the I2C controller
> > to show up as two separate I2C controller instances. Then use runtime
> > PM to save and restore the state for each instance, and locking between
> > the two driver instances.
> > 
> > For the pin muxing part, I'd do this:
> > 
> > 			i2c1 instance	i2c2 instance	notes
> > default_state		0 pins		0 pins		(or dedicated pins only)
> > active_state		all pins	alls pins
> > idle_state		safe mode	safe mode
> > 
> > Then when i2c1 instance is done, it's runtime PM suspend muxes the pins
> > to safe mode, or some nop state. Then when i2c2 instance is woken, it's
> > runtime PM resume muxes pins to i2c2.
> 
> I see two issues with that approach:
> 
> 1) Runtime PM doesn't always put a device into an idle state as soon as
> its work is done. Sometimes (always?) there is a delay between when the
> device is last used and when the HW is actually made idle so that if the
> device is re-activated quickly, the kernel hasn't wasted time making it
> idle then active again. You'd have to force that delay to complete when
> switching between the two virtual controller devices.

There is the autosuspend timeout for delayed transitions, but I think
runtime PM already has calls for making the state change immediate also.
 
> 2) This requires two separate device objects for the two I2C instances.
> I guess you could have the driver for the one I2C mux node end up
> instantiating two child devices for this purpose, and hence make that
> happen without needing to change the DT ABI. However, that sure feels
> complex...

Yes but you will also automatically get quite a bit of sanity to your
I2C driver code rather than trying to handle the two separate instances
within the driver alone. Consider things like scanning the I2C buses for
devices and just dev_dbg().
 
> I wonder if it wouldn't be better to have active/idle/sleep as
> "modifiers" to the state name rather than alternatives, so you end up
> with states named:
> 
> default
> nobus:active
> nobus:idle
> nobus:sleep
> bus0:active
> bus0:idle
> bus0:sleep
> bus1:active
> bus1:idle
> bus1:sleep
> 
> Of course, if you continue on with that approach (i.e. you add more
> sub-fields each separated by a colon), you end up with a huge
> combinatorial mess of state names.

Right :) Sooner or later we'll have some totally messed up piece of
hardware pop up that multiplexes one controller across a large number
number buses..

Regards,

Tony
