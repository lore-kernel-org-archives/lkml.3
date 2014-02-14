Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBNANU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:13:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:13:18 -0500
Date: Thu, 13 Feb 2014 16:14:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140214001436.GA16287@kroah.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
 <20140120100415.GX15937@n2100.arm.linux.org.uk>
 <20140213181216.GB24155@kroah.com>
 <20140213181559.GB30257@n2100.arm.linux.org.uk>
 <20140213182701.GA32578@kroah.com>
 <20140213184249.GC30257@n2100.arm.linux.org.uk>
 <20140213232606.GA27372@kroah.com>
 <20140214000717.GG30257@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214000717.GG30257@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:07:17AM +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 13, 2014 at 03:26:06PM -0800, Greg KH wrote:
> > On Thu, Feb 13, 2014 at 06:42:49PM +0000, Russell King - ARM Linux wrote:
> > > We went through this before, and I stated the paths, and no one disagreed
> > > with that.
> > > 
> > > It /is/ racy.
> > 
> > Ok, I just went and looked at the uart driver register path, and I don't
> > see the race (note, if there is one, it's there today, regardless of
> > this patch).
> 
> The race isn't the uart code, it's the driver model.
> 
> Consider what happens when this happens:
> 
> * Two pl011 devices get registered at the same time by two different
>   threads.

How?  What two different busses will see this same device?  The amba bus
code should prevent that from happening, right?  If not, there's bigger
problems in that bus code :)

That's where this problem should be fixed, if there is one, otherwise
this same issue would be there for any type of driver that calles into
the uart core, right?

> * Both devices have a lock taken on the _device_ itself before matching
>   against the driver.
> 
> * Both devices get matched to the same driver.
> 
> * Both devices are passed into the driver's probe function.
> 
> * Both check uart_reg.state, both call uart_register_driver() on that
>   at the same time, which results in two allocations inside
>   uart_register_driver(), one gets overwritten...
> 
> So, the /only/ thing which stops this happening is that the devices
> are generally available before the driver is registered, and driver
> registration results in devices being probed serially.  Moreover, both
> attempt to call tty_register_driver()... one succeeds, the other fails.
> 
> However, what about the userspace bind/unbind methods.  Yes, userspace
> can ask the driver core to unbind devices from a driver or bind - and
> again, there's no per-driver locking here.  So, if you can trigger two
> concurrent binds from userspace, you hit the same race as above.
> 
> So, if you want to accept these patches, go ahead, introduce races, but
> personally I'd recommend plugging these races.

The only way to solve this would be to do it in the bus, I don't see
anything here that makes it any "racier" than it currently is.

thanks,

greg k-h
