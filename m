Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaBMXYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:24:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBMXYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:24:48 -0500
Date: Thu, 13 Feb 2014 15:26:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140213232606.GA27372@kroah.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
 <20140120100415.GX15937@n2100.arm.linux.org.uk>
 <20140213181216.GB24155@kroah.com>
 <20140213181559.GB30257@n2100.arm.linux.org.uk>
 <20140213182701.GA32578@kroah.com>
 <20140213184249.GC30257@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213184249.GC30257@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 06:42:49PM +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 13, 2014 at 10:27:01AM -0800, Greg KH wrote:
> > On Thu, Feb 13, 2014 at 06:15:59PM +0000, Russell King - ARM Linux wrote:
> > > On Thu, Feb 13, 2014 at 10:12:16AM -0800, Greg KH wrote:
> > > > On Mon, Jan 20, 2014 at 10:04:15AM +0000, Russell King - ARM Linux wrote:
> > > > > On Mon, Jan 20, 2014 at 02:32:35PM +0530, Tushar Behera wrote:
> > > > > > uart_register_driver call binds the driver to a specific device
> > > > > > node through tty_register_driver call. This should typically happen
> > > > > > during device probe call.
> > > > > > 
> > > > > > In a multiplatform scenario, it is possible that multiple serial
> > > > > > drivers are part of the kernel. Currently the driver registration fails
> > > > > > if multiple serial drivers with same default major/minor numbers are
> > > > > > included in the kernel.
> > > > > > 
> > > > > > A typical case is observed with amba-pl011 and samsung-uart drivers.
> > > > > 
> > > > > NAK.  There should not be any other driver using amba-pl011's device numbers.
> > > > 
> > > > I agree, but there is.  And because of that, moving the registration to
> > > > the probe call fixes the issue with building a kernel with all of the
> > > > drivers built into them, so I'm going to take both of these patches, as
> > > > it does solve that problem, while still allowing the device number
> > > > collision to happen.
> > > 
> > > So what happens when two _devices_ are probed by this driver at the same
> > > time?
> > 
> > The bus that the driver is on will not allow that to happen, I thought
> > we went through this before...
> > 
> > And yes, devices on different busses could cause problems, but is that
> > the case here for these devices?  At first glance, I don't think that
> > can happen for these drivers.
> 
> We went through this before, and I stated the paths, and no one disagreed
> with that.
> 
> It /is/ racy.

Ok, I just went and looked at the uart driver register path, and I don't
see the race (note, if there is one, it's there today, regardless of
this patch).

uart_register_driver() fils in a bunch of fields, and passes control off
to tty_register_driver().  If the minor/major number allocation here
fails, due to collisions, then an error occurs, and things back out
safely.

If the allocation succeeds, then we lock the list of drivers, add them
to the list, then register the tty device with the subsystem for how
ever many tty devices were asked for.  Yes, the locking might be wrong
here, in the tty layer, but again, that's nothing new created by this
patch.

So I fail to see the problem with applying this patch, as it solves a
problem people are having, and should be fine given that no hardware
with both of these devices will ever be present at the same time.

thanks,

greg k-h
