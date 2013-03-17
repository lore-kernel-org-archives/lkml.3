Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3CQMjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 08:39:33 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:44889 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3CQMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 08:39:31 -0400
Date: Sun, 17 Mar 2013 13:39:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130317133920.465e8a8c@endymion.delvare>
In-Reply-To: <20130316212540.GA18933@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
	<20130316162140.GB2630@kroah.com>
	<20130316181253.GA23608@roeck-us.net>
	<20130316195002.GB3112@kroah.com>
	<20130316212540.GA18933@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 14:25:40 -0700, Guenter Roeck wrote:
> On Sat, Mar 16, 2013 at 12:50:02PM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Mar 16, 2013 at 11:12:53AM -0700, Guenter Roeck wrote:
> > > My use case is primarily for hwmon drivers.
> > > 
> > > hwmon has a separate API call to register a driver with the hwmon subsystem,
> > > which creates a separate hwmon device and provides the user space notification.
> > > As the created attribute files are often conditional on device variant and device
> > > configuration, I don't see how this could be done through a default attribute
> > > list (even though it might be worthwhile exploring if it can be used for some
> > > of the simpler drivers).
> > 
> > The default attribute list functionality offers you the ability to have
> > callbacks to your driver to validate if you really want this sysfs file
> > to be created or not.  Just use that like other subsystems do, then you
> > will never have to be making these create and remove calls at all.
> 
> I thought about it, but right now I have no idea how to make it work.
> Initialization sequence in hwmon drivers is
>     probe():
>         allocate and initialize local driver data structures
>     	detect configuration and initialize hardware if necessary
> 	create attribute files
> 	register with hwmon subsystem
> 	sometimes do additional work, such as enable interrupts
> 
> If I use attribute_group of the device_driver structure to create the attribute
> files, my understanding is that those would be created prior to calling
> the probe function.
> 
> This would be too early, since local data structures do not yet exist, and
> the chip configuration is unknown and uninitialized.
> 
> On the other side, attribute files must exist before hwmon_device_register()
> is called, since otherwise userspace would get confused.

I'd like to add something at this point.

We have historically created the hwmon attributes in the hardware (i2c,
platform...) device, and then created an empty hwmon class device on
top of it so that libsensors etc. can locate all hardware monitoring
chips on the system. This is probably wrong and this may explain the
difference of views between Greg and Guenter.

I suspect that ideally all hwmon-related attributes should belong to the
hwmon-class device and not the physical device. Would doing so solve
the problem of is_visible() needing chip-specific information that can
only be gathered during probe()? Sure this is an interface change, but
a few hwmon drivers already do it that way (the ones without an actual
hardware device, e.g. ACPI thermal zones) and libsensors supports this
since version 3.0.3, which was released in September 2008 - 4.5 years
ago.

This would require creating the attributes after calling
hwmon_device_register() rather than before, but from the ongoing
discussion I seem to understand that the driver core supports creating
the attributes for us, possibly at the same time as the class device
will be created. Would this solve the userspace timing issue?

Also note that libsensors is really old fashioned when it comes to
device discovery. It doesn't support hot-plug nor hot-remove. So some
work would be needed in this area anyway if we want libsensors-based
applications to properly cope with device addition and removal.

Just my 2 cents.

-- 
Jean Delvare
