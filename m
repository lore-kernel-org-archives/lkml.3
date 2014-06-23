Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaFWUpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:45:09 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54316 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaFWUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:45:07 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 23 Jun 2014 22:44:30 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Johan Hovold <johan@kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>, jkosina@suse.cz,
        cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140623204430.GC15945@localhost>
References: <20140623161723.GA20421@kroah.com>
 <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
 <20140623182324.GA30831@kroah.com>
 <20140623182432.GB30831@kroah.com>
 <20140623193134.GA15945@localhost>
 <20140623194059.GA19615@kroah.com>
 <20140623195212.GB15945@localhost>
 <20140623202448.GB29035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623202448.GB29035@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:24:48PM -0400, Greg KH wrote:
> On Mon, Jun 23, 2014 at 09:52:12PM +0200, Johan Hovold wrote:
> > On Mon, Jun 23, 2014 at 03:40:59PM -0400, Greg KH wrote:
> > > On Mon, Jun 23, 2014 at 09:31:34PM +0200, Johan Hovold wrote:
> > > > On Mon, Jun 23, 2014 at 02:24:32PM -0400, Greg KH wrote:
> > > > > On Mon, Jun 23, 2014 at 02:23:24PM -0400, Greg KH wrote:
> > > > > > On Mon, Jun 23, 2014 at 08:16:48PM +0300, Janne Kanniainen wrote:
> > > > > > > +	ret = sysfs_create_group(&led->hdev->dev.kobj, &gt683r_attribute_group);
> > > > > > > +	if (ret) {
> > > > > > > +		hid_err(hdev, "failed to create sysfs attributes\n");
> > > > > > > +		goto fail;
> > > > > > > +	}
> > > > > > 
> > > > > > No, you need to set the attribute group _before_ you call
> > > > > > led_classdev_register, as that is where the device will be created in
> > > > > > sysfs.  Surely the other led drivers already do this?  I'm almost afraid
> > > > > > to go look...
> > > > > 
> > > > > Yes, they do it already, set .dev_attr_group and you should be fine.
> > > > 
> > > > But this isn't an attribute of the LEDs but rather of the parent HID
> > > > device that is being probed (the led_mode is common to all three LEDs
> > > > and thus belongs in the parent device, right?).
> > > 
> > > Then that's even worse :(
> > > 
> > > The sysfs attribute should be on the class device here for the LED, you
> > > should not put an attribute on a device you are not the driver for.
> > 
> > But this is the driver for the HID device, which then in turn has three
> > individual LEDs. This particular device isn't really an input device
> > (the actual keyboard in this case appears to be connected over PS2), but
> > there are several HID drivers which are primarily input devices with
> > LEDs as sub-devices (e.g. drivers/hid/hid-lg4ff.c).
> 
> I don't know the specifics here, but as you just created a class device,
> why aren't the attributes on that class device?  Shouldn't that be the
> logical place for it, instead of having them on some "random" other type
> of device?

This is a non-standard attribute of this particular laptop. It has three
individual LEDs that can be enabled separately (using standard LED class
attributes), but they will all three be in the same "mode" (which here
apparently means that they can be fully on, vary with the volume(?!), or
pulse synchronously when enabled).

If we were to implement this mode attribute as a class attribute,
changing the mode of of one LED would also change the mode of the other
two devices (LEDs). Therefore I think it has to be an attribute of the
parent HID device (that the driver is for).

> Userspace will never be notified that the attribute is on
> that device due to the file being created "later", and tools using
> libudev and the like will be looking at the LED class device, not the
> "parent" device for any specific LED stuff.

Yeah, that seems to be the case. I doubt anyone will care much about
this particular custom attribute, but sure, setting the led_mode of the
HID device from an udev rule could be problematic.

> but if this really is the way that all LED devices work, and userspace
> programs are expecting this, that's seems odd.

Johan
