Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3IRIcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:32:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42725 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3IRIcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:32:01 -0400
Date: Wed, 18 Sep 2013 10:31:55 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: dev->of_node overwrite can cause device loading with different
 driver
Message-ID: <20130918083155.GB10126@pengutronix.de>
References: <20130913155331.GC14456@pengutronix.de>
 <20130913171046.GA26207@kroah.com>
 <20130914071653.GA26512@pengutronix.de>
 <20130914121729.GA7823@kroah.com>
 <20130914122809.GI12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130914122809.GI12758@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:49:53 up 23 days, 18:20, 49 users,  load average: 0.01, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 01:28:09PM +0100, Russell King - ARM Linux wrote:
> On Sat, Sep 14, 2013 at 05:17:29AM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Sep 14, 2013 at 09:16:53AM +0200, Markus Pargmann wrote:
> > > 3. We could fix up all drivers that change the of_node. But there are
> > >    ARM DT frameworks that require a device struct as parameter instead
> > >    of a device_node parameter (e.g. soc-generic-dmaengine-pcm). So a
> > >    driver core, initialized by a glue driver with DT bindings, has to
> > >    set dev->of_node to use those frameworks. I think it is strange to
> > >    have such DT framework interfaces if a driver is not supposed to
> > >    overwrite dev->of_node permanently.
> > 
> > How about any driver that does muck with this structure, restore it
> > properly if their probe() function fails?  Yes, you show that this is
> > going to be tricky in some places (i.e. musb), but it makes sense that
> > the burden of fixing this issue would rest on them, as they are the ones
> > causing this problem, right?
> 
> It's not about overwriting at all.

musb does not overwrite of_node, but other drivers do, e.g. USB chipidea
core driver which uses its parent of_node. When probe fails in this
case, we could end up with similar issues.

Regards,

Markus

> 
> It's quite simple:
> 
> 1. OF creates a platform device and attaches an of_node to it.
> 2. This platform device is matched using the data in the of_node structure
>    against one of the MUSB stub drivers.
> 3. The MUSB stub driver creates a new platform device, and copies the
>    of_node to it, and registers it.
> 4. This new platform device _can_ itself be matched against the stub
>    driver using the of_node structure.  When this happens, go to step
>    2 and repeat 2-4.
> 
> That's where the problem is - it's not about overwriting an existing
> platform device's of_node pointer with something that the driver has
> dreamt up at all.
> 
> If we're lucky, step 3.5 would be "match against the 'musb-hdrc' driver
> and successfully probe it" which is the only thing that would break
> the above loop.
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
