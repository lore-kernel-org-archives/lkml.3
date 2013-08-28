Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3H1Td6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:33:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49854 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3H1Td4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:33:56 -0400
Date: Wed, 28 Aug 2013 12:33:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Missing removal of sysfs attributes in gpiolib
Message-ID: <20130828193353.GA8518@roeck-us.net>
References: <20130828175717.GA7493@roeck-us.net>
 <20130828183139.GA14627@kroah.com>
 <20130828184433.GA8240@roeck-us.net>
 <20130828185306.GA3346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828185306.GA3346@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:53:06AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Aug 28, 2013 at 11:44:33AM -0700, Guenter Roeck wrote:
> > On Wed, Aug 28, 2013 at 11:31:39AM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 28, 2013 at 10:57:17AM -0700, Guenter Roeck wrote:
> > > > Hi,
> > > > 
> > > > I noticed that gpiolib does not explicitly remove the sysfs attributes it
> > > > created when exporting a gpio pin when the pin is unexported, ie when the
> > > > associated device is removed.
> > > > 
> > > > Are those attributes auto-removed when device_unregister() is called ?
> > > 
> > > Yes they are.
> > > 
> > Does that mean that the explicit attribute removal that is implemented
> > in many drivers can be dropped ? That might save a lot of code.
> 
> Yes, they could be dropped, but I think it's nicer to be explicit about
> this.  Originally, it could be a long time before the kernel would
> remove the sysfs device from the tree, so removing the files could cause
> problems as the callbacks would happen for a device that the driver was
> not expecting to be present.
> 
> Also, if a driver is "unbound" from a device, and the device sticks
> around, the sysfs files are not removed automatically, it's up to the
> driver to remove them, so it's good practice to remove them.
> 
> > > > Sorry if this is a dumb question - I have not noticed this anywhere else,
> > > > and I don't seem to be able to find the code actually performing auto-removal
> > > > of manually created attributes, so I wonder if this is a bug or intentional.
> > > 
> > > Hm, I thought this was listed in the kobject.txt documentation file, but
> > > I don't seem to find it there.
> > > 
> > Would be great if this could be documented somewhere (unless it is and
> > I didn't find it ;). I would volunteer to do it myself, but I have no idea
> > what the conditions for auto-removal are nor how to phrase it, nor where
> > to put it.
> 
> When the kobject is removed from the system, the sysfs files attached to
> it are also removed.  That could go into kobject.txt somewhere, but the
> attributes are what need to be highlighted, and used, so that's a better
> thing to focus on at the moment.
> 
> > > But, ideally you aren't creating individual attributes directly, you are
> > > using attribute groups for the device, right?
> > > 
> > gpiolib does currently create individual attributes as well as attribute
> > groups after registering the device. I was in the process of converting
> > it to use device_create_with_groups() when I noticed that there is no
> > removal, so I wondered.
> 
> The driver core will remove the attributes at the point the device goes
> away, no need to remove them on your own here at all.
> 
> > I take it that attribute groups created with sysfs_create_group()
> > are auto-removed as well, correct ?  
> 
> Yes they are, but no driver, or subsystem, should be making that call,
> they should be using the driver core pointers for attributes instead to
> properly handle the lifespan of the attributes for the device.
> 
A good reason to use device_create_with_groups() instead of creating
attributes manually.

Guenter
