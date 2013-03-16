Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3CPVZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:25:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64742 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3CPVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:25:36 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 16 Mar 2013 14:25:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130316212540.GA18933@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
 <20130316162140.GB2630@kroah.com>
 <20130316181253.GA23608@roeck-us.net>
 <20130316195002.GB3112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316195002.GB3112@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 12:50:02PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Mar 16, 2013 at 11:12:53AM -0700, Guenter Roeck wrote:
> > Adding lm-sensors.
> > 
> > On Sat, Mar 16, 2013 at 09:21:40AM -0700, Greg Kroah-Hartman wrote:
> > > On Thu, Mar 14, 2013 at 08:24:45PM -0700, Guenter Roeck wrote:
> > > > Provide devres functions for device_create_file, sysfs_create_file,
> > > > and sysfs_create_group plus the respective remove functions.
> > > > 
> > > > Idea is to be able to drop calls to the remove functions from the various
> > > > drivers using those calls.
> > > 
> > > Hm, despite the fact that almost every driver that makes these calls is
> > > broken?  :)
> > > 
> > > > Potential savings are substantial. There are more than 700 calls to
> > > > device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
> > > > and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
> > > > as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
> > > > opportunities, and adding sysfs_create_link would create another 100 or so.
> > > 
> > > The idea is nice, but why are these drivers adding sysfs files on their
> > > own?  Are they doing this in a way that is race-free with userspace
> > > (i.e. creating them before userspace is told about the device), or are
> > > they broken and need to have these calls added to the "default
> > > device/driver/bus" attribute list for them instead?
> > > 
> > My use case is primarily for hwmon drivers.
> > 
> > hwmon has a separate API call to register a driver with the hwmon subsystem,
> > which creates a separate hwmon device and provides the user space notification.
> > As the created attribute files are often conditional on device variant and device
> > configuration, I don't see how this could be done through a default attribute
> > list (even though it might be worthwhile exploring if it can be used for some
> > of the simpler drivers).
> 
> The default attribute list functionality offers you the ability to have
> callbacks to your driver to validate if you really want this sysfs file
> to be created or not.  Just use that like other subsystems do, then you
> will never have to be making these create and remove calls at all.
> 

I thought about it, but right now I have no idea how to make it work.
Initialization sequence in hwmon drivers is
    probe():
        allocate and initialize local driver data structures
    	detect configuration and initialize hardware if necessary
	create attribute files
	register with hwmon subsystem
	sometimes do additional work, such as enable interrupts

If I use attribute_group of the device_driver structure to create the attribute
files, my understanding is that those would be created prior to calling
the probe function.

This would be too early, since local data structures do not yet exist, and
the chip configuration is unknown and uninitialized.

On the other side, attribute files must exist before hwmon_device_register()
is called, since otherwise userspace would get confused.

If interrupts are supported, those are typically used to signal attribute
file related events (via udev and/or poll events), meaning the interrupts
must only be enabled after sysfs files were created (becaue the interrupt
acts on it), and should only be enabled after the hwmon device was registered
(because otherwise userspace won't know about the device if the first interrupt
happens after sysfs file creation but before hwmon registration).

I looked into the use of is_visible. The drivers I looked at (ad7877, tsc2005,
lm3533_led, lm3533-core, lm3533_bl) all need data obtained in the probe function
in their is_visible function, meaning the attribute files can not be created
before that data is available. That (and the solution to create the attributes
in the probe function after basic device initialization) is quite similar
to the problem we have in the hwmon subsystem and its current solution.

Overall I have no idea how to make this all fit into the generic attribute
file handling. If you do, please let me know.

> > The idea was to also provide devm_hwmon_register and devm_hwmon_unregister.
> > Together that would help us reducing the remove function for most hwmon
> > drivers to pretty much nothing.
> 
> That's a great goal to have, I like it.
> 
> > Some other subsystems:
> > 
> > usb: Used widely. From looking into a couple of sources, usage seems to be
> > questionable, as I don't see how userspace would be notified. I don't know
> > enough about usb to be sure, though.
> 
> Which USB drivers do this?  The core should be fine, we delay telling
> userspace until after the core has create the files it needs.  USB
> drivers should all be using attribute lists, if not, then they are
> probably broken, although it really depends on the subsystem they are
> registering themselves with (USB is just the transport layer for lots of
> different things, as you know.)
> 
Just look for device_create_file in the drivers/usb directory. Maybe I got it
all wrong, and everything is fine. Either some 50 calls to device_create_file
and 10 calls to sysfs_create_groups creeped in, or those (or at least many
of those) are fine. If the calls are fine, introducing devm_ functions to
replace at least many of those calls would make sense again.


> > mtd: One use case (volume creation) seems to be safe, as it notifies userspace
> > about its completion. For UBI I am not that sure, as it registers the device
> > first and then adds the attributes.
> 
> That's not good (the UBI one.)  It should be fixed.
> 
> > regulators: No idea if it does the right thing.
> 
> Ick.
>
Not necessarily - just shows that I don't understand the code.

> > input: Usage in files I looked at seems questionable.
> 
> Really?  I thought we fixed those a while ago, but more could have crept
> in over time.  Which is why I really want to not export those
> functions...
> 
Maybe it is not a problem because the input device is registered as input device
from its probe function, ie there is a sysfs event after its attribute files
were created. But if the use is ok, so would be supporting the use of devm_
functions in those drivers.

> > There are others, but it really gets murky and I don't understand
> > the subsystems well enough to make a call.
> > 
> > > I think the "we need to fix the drivers" option is the correct one :(
> > > 
> > > Ideally, I could get rid of those files from being exported at all, but
> > > some busses do do things correctly, so I can't.  But they seem to be in
> > > the minority...
> > > 
> > > So how about we fix up the drivers first, then, if there are valid users
> > > for this type of interface (which I do think there is), we can add it
> > > then?
> > > 
> > I think hwmon is a valid use case.
> 
> See above for why I don't think it is.
> 
> Bonus is, if you use the attribute callbacks, your code is smaller :)
> 
> > For other subsystems, I simply don't know enough about those to do that kind
> > of work; I think it would make more sense to ask it to be done by people who
> > are familiar with the respective subsystems or drivers to do it.
> 
> I agree.
> 
> > Besides, looking through well above 1,000 calls would probably take about
> > forever if a single person was to do it, even if that person would be available
> > full-time to do the work.
> > 
> > How about an alternative: Provide the API, then if/when people start using it
> > wrongly ask them to fix up the drivers instead. That seems to make more sense
> > to me.
> 
> People are using the existing apis "wrongly" and no one noticed,
> including me :(
> 
> Anyway, see above for how you can change the hwmon subsystem to not need
> this at all, so you don't have to add anything new to the core of the
> kernel, just fix up the drivers and you will be fine.
> 
Unfortunately I have no ida how to make that all work. Can you point me
to some examples showing me how other subsystems solved a similar problem ?

I browsed through various drivers using is_visible, but none of the ones I found
really apply; almost all actually call sysfs_create_group in the probe function
and thus could use the devm_ API as well.

Thanks,
Guenter
