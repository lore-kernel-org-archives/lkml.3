Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3INHRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:17:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42957 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3INHQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:16:58 -0400
Date: Sat, 14 Sep 2013 09:16:53 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: dev->of_node overwrite can cause device loading with different
 driver
Message-ID: <20130914071653.GA26512@pengutronix.de>
References: <20130913155331.GC14456@pengutronix.de>
 <20130913171046.GA26207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130913171046.GA26207@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:43:56 up 20 days,  4:14, 49 users,  load average: 0.15, 0.29,
 0.22
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:10:46AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Sep 13, 2013 at 05:53:31PM +0200, Markus Pargmann wrote:
> > Hi,
> > 
> > I ran into a serious problem with overwriting device of_node property as
> > it is done in many drivers for ARM. If probing fails in such a
> > situation, the device could be loaded with a different driver.
> > 
> > This is an example situation, based on balbi's tag usb-for-v3.12:
> > 
> > ========================================================================
> > File drivers/usb/musb/musb_dsps.c:
> > 
> > static int dsps_musb_init(struct musb *musb)
> > {
> > ...
> > 	musb->xceiv = devm_usb_get_phy_by_phandle(dev, "phys", 0);
> > 	if (IS_ERR(musb->xceiv))
> > 		return PTR_ERR(musb->xceiv); <-- This can return -EPROBE_DEFER
> > ...
> > }
> > ...
> > static int dsps_create_musb_pdev(struct dsps_glue *glue,
> > 		struct platform_device *parent)
> > {
> > ...
> > 	/* allocate the child platform device */
> > 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
> > 	if (!musb) {
> > 		dev_err(dev, "failed to allocate musb device\n");
> > 		return -ENOMEM;
> > 	}
> > 
> > 	musb->dev.parent		= dev;
> > 	musb->dev.dma_mask		= &musb_dmamask;
> > 	musb->dev.coherent_dma_mask	= musb_dmamask;
> > 	musb->dev.of_node		= of_node_get(dn); <-- Overwrites the device of_node
> > ...
> > 	ret = platform_device_add(musb);
> > ...
> > }
> > static int dsps_probe(struct platform_device *pdev)
> > {
> > ...
> > 	ret = dsps_create_musb_pdev(glue, pdev);
> > ...
> > }
> > 
> > ========================================================================
> > File drivers/usb/musb/musb_core.c:
> > 
> > static int
> > musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
> > {
> > ...
> > 	status = musb_platform_init(musb); <-- This calls dsps_musb_init
> > 	if (status < 0)
> > 		goto fail1;
> > ...
> > 	return status;
> > 
> > }
> > static int musb_probe(struct platform_device *pdev)
> > {
> > ...
> > 	return musb_init_controller(dev, irq, base);
> > }
> > 
> > ========================================================================
> > 
> > musb_dsps is a glue driver that creates a core device in the probe
> > function and assigns it's own of_node to the new device.
> > Starting at the platform_device_add call, this is the function call
> > tree:
> > 
> > platform_device_add()
> > 
> > ...
> > 
> > device_attach() in drivers/base/dd.c, which iterates through a list of
> > drivers, calls __device_attach() on each of them. The list contains both
> > drivers, musb_dsps and musb_core. This is where this example splits into
> > two cases:
> > 
> > 1. We find the first matching driver, musb_dsps:
> > 
> >         __device_attach()
> >           platform_match() /* for the musb_core, detecting a match. */
> >           driver_probe_device()
> >             really_probe()
> >               musb_probe() is called, which returns -EPROBE_DEFER
> > 
> >             /* really_probe drops the return value and makes some cleanups */
> > 
> > 2. The error code does not reach the driver list iteration loop. It
> > is not supposed to do so because the drivercore tries to find another
> > matching driver. Now it tries the musb_dsps driver:
> > 
> >         __device_attach()
> >           platform_match()
> >             /* succeeds again, because the device has the
> > 	       of_node from its parent which claims that this
> > 	       is a musb_dsps device. */
> >           driver_probe_device()
> >             really_probe()
> >               dsps_probe() ... /* from here on it starts from the beginning. */
> > 
> > This recursion continued until the kernel had no memory left. This is a
> > special situation but there are many drivers that overwrite the of_node
> > property in their probe function. So they can actually match with a
> > different driver on the second or third probe attempt.
> 
> Ok, so what do you suggest we do for stuff like this?  Fix up the musb
> driver?  Or something else?

I think there are three options to solve this:

1. Break out of the driver list iteration loop as soon as a driver probe
   function fails. This way there is no possibility for another driver
   to be probed with a device struct that was changed by the first
   driver. But it would remove the support to fall back to
   another driver for a device. I am not aware of any device that is
   supported by multiple drivers.

2. We could restore the device struct completely or partially (only
   of_node) after a probe failure. This would avoid driver probes with
   unclean device structs, but introduces some overhead.

3. We could fix up all drivers that change the of_node. But there are
   ARM DT frameworks that require a device struct as parameter instead
   of a device_node parameter (e.g. soc-generic-dmaengine-pcm). So a
   driver core, initialized by a glue driver with DT bindings, has to
   set dev->of_node to use those frameworks. I think it is strange to
   have such DT framework interfaces if a driver is not supposed to
   overwrite dev->of_node permanently.

Regards,

Markus Pargmann

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
