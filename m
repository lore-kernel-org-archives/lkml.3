Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3IRInp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:43:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35645 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3IRInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:43:42 -0400
Date: Wed, 18 Sep 2013 10:43:36 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: dev->of_node overwrite can cause device loading with different
 driver
Message-ID: <20130918084336.GC10126@pengutronix.de>
References: <20130913155331.GC14456@pengutronix.de>
 <20130913171046.GA26207@kroah.com>
 <20130914071653.GA26512@pengutronix.de>
 <20130914112056.GH12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130914112056.GH12758@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:23:54 up 23 days, 17:54, 49 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 12:20:56PM +0100, Russell King - ARM Linux wrote:
> On Sat, Sep 14, 2013 at 09:16:53AM +0200, Markus Pargmann wrote:
> > I think there are three options to solve this:
> > 
> > 1. Break out of the driver list iteration loop as soon as a driver probe
> >    function fails. This way there is no possibility for another driver
> >    to be probed with a device struct that was changed by the first
> >    driver. But it would remove the support to fall back to
> >    another driver for a device. I am not aware of any device that is
> >    supported by multiple drivers.
> 
> What if the incorrect driver (the one which created this platform device)
> is the one which was matched first?

Yes that would lead to the same recursion. But I think it is better to
assign the of_node within driver probe which wouldn't be a problem for
(1), e.g. by using dev->parent or by passing the of_node via
platform data.

> 
> > 2. We could restore the device struct completely or partially (only
> >    of_node) after a probe failure. This would avoid driver probes with
> >    unclean device structs, but introduces some overhead.
> 
> I don't think it's about changing an existing device structure.  The
> problem is more to do with this:
> 
> - We have a platform device with an associated of_node.
> - The of_node is used to match it to its device driver.
> - This device driver spawns a new platform device, and copies the
>   of_node to the new platform device (so that the _intended_ driver
>   can get access to the DT properties)
> - The DD layer tries to match this new platform device with a driver,
>   and _can_ match this new platform device against the device driver
>   which created it due to the of_node matching.
> 
> There's two solutions here:
> 
> 1. get rid of this yucky "lets spawn a new device" stuff - if you
>    actually work out what's going on with MUSB and its use of this
>    platform device, it's _really_ horrid, and that's putting it
>    mildly.  Let's call the device being probed, devA, and briefly:
> 
> 	new_dev = platform_device_alloc();
> 
> 	devA->platform_data = glue
> 	glue->dev = devA
> 	glue->musb = new_dev
> 	new_dev->parent = devA
> 
> 	set_drvdata(devA, glue)
> 
> 	platform_device_add(new_dev);
> 
>    musb->controller is the new device, callbacks into this layer do:
> 
> 	glue = get_drvdata(musb->controller->parent)
> 
>    that's not too bad, because this is accessing devA's driver data
>    from within its owning driver... until you find this:
> 
> 	musb = glue_to_musb(glue)
> 
>    which is defined as:
> 
> 	#define glue_to_musb(g)         platform_get_drvdata(g->musb)
> 
>    glue->musb is the _child_ platform device, and we're accessing the
>    child's driver data here.
> 
>    This seems to me to be a layering violation, and also rather racy when
>    you consider that glue_to_musb() gets used from workqueue contexts
>    (and I don't see a flush_workqueue() call in these stub drivers.)
>    What if the new platform device gets unbound just before the workqueue
>    fires?
> 
>    Another thing to note here is that platform_device_add_data() takes a
>    copy of the data - in the case of omap2430, this is kzalloc'd but
>    is pointlessly kept around until this driver is removed (via the devm_
>    mechanisms.)
> 
>    The last thing I don't like in these drivers is this:
> 
>         memset(musb_resources, 0x00, sizeof(*musb_resources) *
>                         ARRAY_SIZE(musb_resources));
> 
>         musb_resources[0].name = pdev->resource[0].name;
>         musb_resources[0].start = pdev->resource[0].start;
>         musb_resources[0].end = pdev->resource[0].end;
>         musb_resources[0].flags = pdev->resource[0].flags;
> 
>         musb_resources[1].name = pdev->resource[1].name;
>         musb_resources[1].start = pdev->resource[1].start;
>         musb_resources[1].end = pdev->resource[1].end;
>         musb_resources[1].flags = pdev->resource[1].flags;
> 
>         musb_resources[2].name = pdev->resource[2].name;
>         musb_resources[2].start = pdev->resource[2].start;
>         musb_resources[2].end = pdev->resource[2].end;
>         musb_resources[2].flags = pdev->resource[2].flags;
> 
>         ret = platform_device_add_resources(musb, musb_resources,
>                         ARRAY_SIZE(musb_resources));
> 
>    A little knowledge of the driver model will reveal that the above
>    is utterly pointless - and can be simplified to:
> 
> 	ret = platform_device_add_resources(musb, pdev->resource,
> 					    pdev->num_resources);
> 
>    as platform_device_add_resources() copies the passed resource
>    structures via kmemdup() already.  There's no reason for this
>    device driver to make its own copy of the resources just to have
>    them re-copied.  It's also a lot safer in case fewer than three
>    resources are supplied.  It's also a lot less hastle if additional
>    resources are added (like what's happened recently to these drivers.)
> 
> 2. don't pass the of_node via the platform_device, but as part of
>    the platform device's data.
> 
> Is there any reason why musb isn't implemented as a library which these
> stub drivers can hook into?
> 
> I'd much prefer (1), because it gets rid of the horrid dma_mask stuff in
> these drivers, turning it more into a "conventional" driver.
> 

I also prefer your first solution. But as a quick fix for all drivers
with similar of_node usage, I prefer the mentioned of_node cleanup at
the end of the probe function.

Regards,

Markus Pargmann

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
