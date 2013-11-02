Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3KBP4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:56:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KBP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:56:17 -0400
Date: Sat, 2 Nov 2013 08:58:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when device-tree
 is used.
Message-ID: <20131102155824.GG23938@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
 <1383279744.28909.26.camel@pasglop>
 <1383280054.28909.30.camel@pasglop>
 <20131101160329.37f3707b@notabene.brown>
 <1383282516.28909.36.camel@pasglop>
 <20131101204749.GA19662@kroah.com>
 <1383347399.28909.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383347399.28909.46.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 10:09:59AM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2013-11-01 at 13:47 -0700, Greg Kroah-Hartman wrote:
> 
> > > > On my device I seem to have some platform devices registered through
> > > > device-tree, and some registered through platform_device_add (e.g.
> > > > 'alarmtimer').  Guaranteeing they remain disjoint sets if the kernel is
> > > > allowed to evolve independently of the devicetree might be tricky....
> > > > Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform" ??
> > > 
> > > No, I think device-tree created platform devices should go
> > > to /sys/devices/platform like the "classic" ones.
> > > 
> > > The problem is really how to deal with potential name duplication. We
> > > could try to register, if we get -EEXIST (assuming sysfs returns the
> > > right stuff), try again with ".1" etc...
> > 
> > How can there be device name collisions?  All platform devices _should_
> > be named uniquely, if not, you have bigger problems...
> 
> The problem is how to create a unique name from a platform device
> created from a device-tree node.

I have no idea, and frankly, I don't care, I leave that to the
device-tree maintainers, as they are the ones that are using platform
devices for this type of kernel interaction.

So go blame them for this, not me, remember, I'm the one who _hates_
platform devices and wish they had never been created...

> Device tree nodes aren't necessarily uniquely named. They are unique
> under a given parent but that hierarchy isn't preserved when creating
> corresponding platform devices (and it would be very tricky to do so).
> 
> Currently, we simply append a number to the name when creating them,
> which is obtained from a global counter.

That's the best solution, you can't rely on device ids being the same
for any type of bus, that's just life.

> Neil is unhappy about that because on his specific hardware, the device
> has a unique name and thus we introduce a naming difference between
> device-tree usage and old-style "hard coded" board file usage.
> 
> It would be nice if we could do something that only appends the "global
> number" at the end of the name if the name isn't already unique. Thus my
> proposal of trying first with the base name, and trying again if that
> returns -EEXIST in some kind of loop.

Just loop through all the platform devices before registering it to
determine if you need to do this, the platform code can do this just
fine.  If you try to register a duplicate name with the driver core,
odds are it will complain loudly, so don't do that.

good luck,

greg k-h
