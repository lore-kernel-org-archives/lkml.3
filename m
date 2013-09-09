Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3IIJIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:08:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IIJIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:08:01 -0400
Message-ID: <1378717612.4151.6.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH RFC 0/6] ARM: OMAP2+: AM43x/AM335x prcm reset driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Pavel Machek <pavel@ucw.cz>
Date: Mon, 09 Sep 2013 11:06:52 +0200
In-Reply-To: <5228A99D.4020702@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
	 <1378375634.3948.10.camel@pizza.hi.pengutronix.de>
	 <5228A99D.4020702@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 05.09.2013, 21:26 +0530 schrieb Afzal Mohammed:
> Hi Philipp,
> 
> On Thursday 05 September 2013 03:37 PM, Philipp Zabel wrote:
> > Am Montag, den 02.09.2013, 19:41 +0530 schrieb Afzal Mohammed:
> 
> >> Two new reset API's are provided to check whether reset is ready and
> >> to clear reset. This would be required in case IP needs to mix reset
> >> handling procedure with power/clock managment procedure to achieve
> >> proper reset and these procedures are sometimes IP specific that would
> >> make it difficult to handle reset fully in pm_runtime platform support.
> 
> >> client IP handling s/w (DT based) should do as follows:
> 
> >> 2. In driver, that require reset to be deasserted,
> >>  (this is the sequence required for gfx on AM43x/AM335x, this would
> >>   depend on requirements of the IP)
> >>
> >> 	mydriver_probe(struct platform device *pdev)
> >> 	{
> >> 		:
> >> 		:
> >> 		reset_control_get(&pdev->dev, NULL);
> >> 		reset_control_clear_reset();
> >> 		reset_control_deassert();
> >> 		pm_runtime_get_sync();
> >> 		if (reset_control_is_reset() != true)
> >> 			goto err;
> >> 		reset_control_put();
> >> 		:
> >> 		:
> >> 	}
> 
> > if possible, I'd like to move this logic into the reset controller
> > driver. Can this be reordered to enable power before deasserting the
> > reset line (assuming it is initially asserted)? In this case, I'd
> > suggest to just call device_reset:
> > 
> > 	pm_runtime_get_sync(&pdev->dev);
> > 	ret = device_reset(&pdev->dev);
> > 	if (ret)
> > 		goto err;
> > 
> > The ops.reset callback in the prcm driver then can handle clearing
> > the reset status bit, deasserting the reset control bit, and waiting for
> > the reset status bit to be set (or timing out with an error).
> 
> I too would have loved to have it in such a clean way and was initially
> proceeding in that direction, but there is an issue specific to OMAP
> family SoC's, which was required to be taken care of (even though
> present use case for AM335x/AM43x would work [as it does not have
> hardware supervised clockdomain mode] with a small change in platform
> level power management support code - a generic one shared with other
> OMAP family SoC's)
> 
> For a module to be reset, clock domain to which the module clock belongs
> should be set to software supervised mode. During "pm_runtime_get_sync",
> in OMAP platform level handling code, it first put clockdomain into
> software supervised mode, enables clock to module, and once module is
> ready, module will be put to hardware supervised mode. In hardware
> supervised mode, reset may not happen.
> 
> So if device_reset() is done after pm_runtime_get_sync(), reset may not
> happen as by the time device_reset() is called, clockdomain would be in
> hardware supervised mode. But in other case, as reset is already
> deasserted when pm_runtime_get_sync() is called, module would be reset
> as it first puts to software supervised mode.
> 
> And device reset would happen only upon enabling clock to module (if
> reset was deasserted) by pm_runtime_get_sync(), so reset status has to
> be checked after pm call, preventing us having device_reset() before
> pm_runtime_get_sync(), or else in that case we have to sacrifice on
> reset status checking (which may not be reliable)
> 
> Another alternative would have been to integrate this reset handling in
> low level power management code thus hiding all reset handling from
> driver, but as far as I know the reset sequence to be done is sometimes
> IP specific, preventing it.

So if I understand correctly, the only problem is that on OMAP the clock
needs to be enabled to deassert the reset, but as long as the clock
domain is in hardware supervised mode, it won't be enabled?
Would it be possible to create an internal API to switch the clock
domain to software supervised mode, which can be used both by the code
behind pm_runtime_get_sync and reset_control_deassert?

regards
Philipp

