Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaAUAZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:25:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbaAUAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:25:36 -0500
Date: Mon, 20 Jan 2014 16:26:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140121002623.GA6173@kroah.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <20140120211601.GB634@kroah.com>
 <20140120213206.GJ15937@n2100.arm.linux.org.uk>
 <20140120231141.GA2355@kroah.com>
 <20140120231603.GL15937@n2100.arm.linux.org.uk>
 <20140120235128.GA5012@kroah.com>
 <20140121000706.GN15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121000706.GN15937@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:07:06AM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 20, 2014 at 03:51:28PM -0800, Greg KH wrote:
> > On Mon, Jan 20, 2014 at 11:16:03PM +0000, Russell King - ARM Linux wrote:
> > > I don't believe the driver model has any locking to prevent a drivers
> > > ->probe function running concurrently with it's ->remove function for
> > > two (or more) devices.
> > 
> > The bus prevents this from happening.
> > 
> > > The locking against this is done on a per-device basis, not a per-driver
> > > basis.
> > 
> > No, on a per-bus basis.
> 
> I don't see it.
> 
> Let's start from driver_register().

Which happens from module probing, which is single-threaded, right?

Or from module_init callbacks, which is single-threaded.

Normally, busses never add devices (which is what drivers bind to),
except in a single-at-a-time fashion, unless they really know what they
are doing (i.e. PCI had multi-threaded device probing for a while, don't
remember if it still does...)


> This takes no locks and calls bus_add_driver().
> This also takes no locks and calls driver_attach().
> This walks the list of devices calling __driver_attach() for each.
> __driver_attach() tries to match the device against the driver,
> locks the parent device if one exists, and the device which is about
> to be probed.  It then calls driver_probe_device().
> driver_probe_device() inserts a runtime barrier and calls really_probe().
> really_probe() ultimately calls either the bus ->probe method or the
> driver ->probe method.
> 
> At no point in that sequence do I see anything which does any locking
> on a per-driver basis.  Let's look at device_add().
> 
> device_add() calls bus_probe_device(), which then calls device_attach().
> device_attach() takes the device's lock, and walks the list of drivers
> calling __device_attach() on each driver.  This then calls down into
> driver_probe_device(), and the path is the same as the above.
> 
> I don't see any per-driver locking here either.
> 
> I've checked the klist stuff, don't see anything there.  Ditto for
> bus_for_each_drv().
> 
> If you think there's a per-driver lock that's held over probes or removes,
> please point it out.  I'm fairly certain that there isn't, because we have
> to be able to deal with recursive probes (yes, we've had to deal with
> those in the past.)

Hm, you are right, I think that's why we had to remove the locks.  The
klist stuff handles us getting the needed locks for managing our
internal lists of devices and drivers, and those should be fine.

So, let's go back to your original worry, what are you concerned about?
A device being removed while probe() is called?

thanks,

greg k-h
