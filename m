Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaFBBio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:38:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaFBBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:38:43 -0400
Date: Sun, 1 Jun 2014 18:38:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Philipp Hachtmann <hachti@hachti.de>
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
Message-ID: <20140602013839.GA831@kroah.com>
References: <1401579066-8298-1-git-send-email-hachti@hachti.de>
 <1401579066-8298-3-git-send-email-hachti@hachti.de>
 <20140601000059.27360.qmail@stuge.se>
 <538A7063.8010205@hachti.de>
 <20140601023106.GA4961@kroah.com>
 <538BCC03.3090606@hachti.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538BCC03.3090606@hachti.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:57:39AM +0200, Philipp Hachtmann wrote:
> On 01.06.2014 04:31, Greg KH wrote:
> >As they are GPIO pins on this device, it should be the subsystem that
> >controls it.  That way, userspace programs that are used to talk to a
> >GPIO device will "just work", and not have to be customized just for
> >this specific device and sysfs file.
> 
> >So please use the GPIO subsystem instead of creating your own interface.
> 
> Yes but... I should have avoided the term "GPIO".

No, you used the right term :)

> The FT232H (and other chips of the family) are communication controller ICs
> that support several operation modes. The usb-serial driver partially
> supports the chips' functionalities by supplying a tty device to the system.
> At least the FT232H has something called CBUS: Four (!) bits of GPIO that
> *might* be available depending on the device's configuration stored in an
> EEPROM attached to the chip. For example if the chip is in sync FIFO mode,
> only two of those bits reach the chip's surface.
> 
> I'll try to discuss two use cases:
> 
> 1. Someone builds hardware with an FT chip and some general functionality
> attached to the four usable CBUS lines, totally unrelated to the chip's
> FIFO/UART etc. functionality.
> In that case I would strongly recommend to register the CBUS stuff with the
> GPIO subsystem. The user then could - as you noted - run any program used to
> deal with official GPIO pins on top of the four lines.
> But I think that this use case is one of the less likely ones.

But you don't know...

> 2. Someone builds hardware which uses some CBUS pins to control external
> circuitry that also uses the UART/FIFO interface. Both with tight functional
> integration. The CBUS pins become something in the rank of modem status
> lines.
> An application that uses the port also wants to easily access the CBUS pins.
> And it really knows what it does because it knows what it is doing. From my
> point of view this is the more common use case.
> 
> Consequently the best way to cover the CBUS pins would be via the device's
> ioctls. But as the device is driven by common tty and usb-serial code which
> handles the ioctls I currently see how to achieve that without breaking a
> lot.

No, I am not going to add custom ioctls to a single driver for this.

Please just use the gpio subsystem, that is what it is there for, and if
you need to interleave led flashing or modem control line signals with
the data you are sending, then just do that in your program.  It's no
different than sending custom ioctls, you have to know what you are
doing.

This comes up every 6 months or so, you aren't the first to ask for
custom ioctls / sysfs files for this chip.  But no one seems to want to
to do the work to make it a proper gpio device, which is sad :(

> For me personally it's most important to get access to CBUS in any way where
> the relation of the tty and the CBUS is *not* lost.

It would not be lost at all, you can see that relationship in sysfs
between the gpio device and the tty device, they are both attached to
the same "parent" usb interface.

thanks,

greg k-h
