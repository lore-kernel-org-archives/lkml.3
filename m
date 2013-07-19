Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3GSXtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:49:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3GSXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:49:43 -0400
Date: Fri, 19 Jul 2013 16:49:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-sunxi@googlegroups.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.shevchenko@gmail.com,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130719234944.GA11498@kroah.com>
References: <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
 <51E466A3.4010503@schinagl.nl>
 <20130716064107.GA10868@kroah.com>
 <20130717114650.GN3125@lukather>
 <20130717161758.GA9822@kroah.com>
 <20130719094211.GD5106@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719094211.GD5106@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:42:11AM +0200, Maxime Ripard wrote:
> On Wed, Jul 17, 2013 at 09:17:58AM -0700, Greg KH wrote:
> > On Wed, Jul 17, 2013 at 01:46:50PM +0200, Maxime Ripard wrote:
> > > On Mon, Jul 15, 2013 at 11:41:07PM -0700, Greg KH wrote:
> > > > On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
> > > > > So using these new patches for binary attributes, how can I pass data 
> > > > > between my driver and the sysfs files using a platform_driver? Or are 
> > > > > other 'hacks' needed and using the .groups attribute from 
> > > > > platform_driver->device_driver->groups is really the wrong approach.
> > > > > 
> > > > > I did ask around and still haven't figured it out so far, so I do 
> > > > > apologize if you feel I'm wasting your precious time.
> > > > 
> > > > How is the platform device not the same thing that was passed to your
> > > > probe function?
> > > 
> > > One thing I don't get here is why it should be set in the
> > > platform_driver structure. From my understanding of the device model,
> > > and since what Oliver is trying to do is exposing a few bytes of memory
> > > to sysfs, shouldn't the sysfs file be attached to the device instead?
> > 
> > It will be created by the driver core for any device attached to the
> > driver automatically.
> > 
> > > I mean, here, the sysfs file will be created under something like
> > > .../drivers/sunxi-sid/eeprom. What happens when you have several
> > > instances of that driver loaded? I'd expect it to have several sysfs
> > > files created, one for each instance. So to me, it should be in the
> > > device structure, not the driver one.
> > 
> > You can't have multiple drivers with the same name loaded (or the same
> > module loaded multiple times.)  You can have multiple devices for a
> > single driver, which is what we do all the time.
> 
> Yes, I know that, and it's actually my point.
> With the current oliver's code he pasted earlier in this thread:
> 
> # find /sys/ -name eeprom
> /sys/bus/platform/drivers/sunxi-sid/eeprom
> 
> While I'd expect the eeprom file to be located in
> /sys/bus/platform/devices/X.eeprom/eeprom like it used to be in the v4,
> since it's an instance-specific content.

Oh crap.  You are totally right.  That's why we added the new device
create call, to allow this to work properly.

Right now you are getting the kobject of the driver, not the device, in
the callback, which is not what you want (sure, if you only have once
instance, you can work around it, but don't it's the driver core's fault
for not giving you the correct api...)

Let me go look at how I can make this work "easier", give me a few days.

greg k-h
