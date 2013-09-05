Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639Ab3IEKIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:08:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41635 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934879Ab3IEKIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:08:21 -0400
Message-ID: <1378375634.3948.10.camel@pizza.hi.pengutronix.de>
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
Date: Thu, 05 Sep 2013 12:07:14 +0200
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
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

Hi Afzal,

Am Montag, den 02.09.2013, 19:41 +0530 schrieb Afzal Mohammed:
> Hi,
> 
> This is an attempt to achieve reset on AM43x/AM335x based SoC's with
> reset driver making use of the reset framework.
> 
> prcm node is added in device tree, which would hold reset bindings.
> Initially node was made as a one that represents reset functionality
> of SoC. but ended up with node for prcm (which is felt to be natural
> choice) instead. I am a bit doubtful whether placement of prcm node in
> root node as in this series is the right thing.
> 
> Reset driver gets probed for specific prcm node, the same defines
> register details to be used for a particular SoC (using ".data" field
> associated with ".compatible" in driver match table).
> 
> Another option to handle different SoC's would be to add register
> details to DT and let the driver extract it from DT. I vaguely
> remember seeing a thread mentioning that putting register details in
> DT is not preferred. But open to putting register level details
> instead in DT if that is being generally preferred. This would have
> advantage that adding reset support for a new SoC would be easier, but
> would have to put more thought before doing so as DT bindings should
> not change.
> 
> With the approach taken here, for supporting a new SoC with new prcm
> register details, driver would have to be updated much like the way a
> pci based ethernet driver would have to be updated to handle a new IP
> version that is not register level compatible with the existing ones.
> 
> In this series out of the three IP's (gfx, m3, pruss) that would need
> reset support, here as a proof of concept only gfx is taken care.
> Other's can be easily supported by adding new register data array
> entries.
> 
> Two new reset API's are provided to check whether reset is ready and
> to clear reset. This would be required in case IP needs to mix reset
> handling procedure with power/clock managment procedure to achieve
> proper reset and these procedures are sometimes IP specific that would
> make it difficult to handle reset fully in pm_runtime platform support.
> 
> *------*
> client IP handling s/w (DT based) should do as follows:
> 
> 1. Specify reset handle in the relevant DT node, for eg.
> 
> 	myip@deadbeef {
> 		:
> 		:
> 		/* here prcm is the handle to reset binding node */
> 		resets = <&prcm 0>;
> 	};
> 
> 2. In driver, that require reset to be deasserted,
>  (this is the sequence required for gfx on AM43x/AM335x, this would
>   depend on requirements of the IP)
> 
> 	mydriver_probe(struct platform device *pdev)
> 	{
> 		:
> 		:
> 		reset_control_get(&pdev->dev, NULL);
> 		reset_control_clear_reset();
> 		reset_control_deassert();
> 		pm_runtime_get_sync();
> 		if (reset_control_is_reset() != true)
> 			goto err;
> 		reset_control_put();
> 		:
> 		:
> 	}
> 
> *------*

if possible, I'd like to move this logic into the reset controller
driver. Can this be reordered to enable power before deasserting the
reset line (assuming it is initially asserted)? In this case, I'd
suggest to just call device_reset:

	pm_runtime_get_sync(&pdev->dev);
	ret = device_reset(&pdev->dev);
	if (ret)
		goto err;

The ops.reset callback in the prcm driver then can handle clearing
the reset status bit, deasserting the reset control bit, and waiting for
the reset status bit to be set (or timing out with an error).

> May be removing reset handling in hwmod can be considered by making
> use of reset driver.
> 
> Or as another extreme, perhaps, other logic's in the prcm can be
> handled by a new prcm driver and then this reset driver can be a child
> of it.
> 
> Regards
> Afzal
> 
> 
> Afzal Mohammed (6):
>   reset: is_reset and clear_reset api's
>   doc: dt: binding: omap: am43x/am335x prcm reset
>   reset: am43x/am335x support
>   ARM: OMAP2+: AM43x/AM335x: have reset controller
>   ARM: dts: AM335x: prcm node (for reset)
>   ARM: dts: AM4372: prcm node (for reset)
> 
>  .../devicetree/bindings/arm/omap/prcm.txt          |  13 ++
>  arch/arm/boot/dts/am33xx.dtsi                      |   6 +
>  arch/arm/boot/dts/am4372.dtsi                      |   6 +
>  arch/arm/mach-omap2/Kconfig                        |   2 +
>  drivers/reset/Kconfig                              |  14 ++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/amx3_reset.c                         | 157 +++++++++++++++++++++
>  drivers/reset/core.c                               |  32 +++++
>  include/linux/reset-controller.h                   |   2 +
>  include/linux/reset.h                              |   2 +
>  10 files changed, 235 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/prcm.txt
>  create mode 100644 drivers/reset/amx3_reset.c

regards
Philipp

