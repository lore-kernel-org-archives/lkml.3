Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3CPSMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:12:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54814 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3CPSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:12:45 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 16 Mar 2013 11:12:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130316181253.GA23608@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
 <20130316162140.GB2630@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316162140.GB2630@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding lm-sensors.

On Sat, Mar 16, 2013 at 09:21:40AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Mar 14, 2013 at 08:24:45PM -0700, Guenter Roeck wrote:
> > Provide devres functions for device_create_file, sysfs_create_file,
> > and sysfs_create_group plus the respective remove functions.
> > 
> > Idea is to be able to drop calls to the remove functions from the various
> > drivers using those calls.
> 
> Hm, despite the fact that almost every driver that makes these calls is
> broken?  :)
> 
> > Potential savings are substantial. There are more than 700 calls to
> > device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
> > and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
> > as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
> > opportunities, and adding sysfs_create_link would create another 100 or so.
> 
> The idea is nice, but why are these drivers adding sysfs files on their
> own?  Are they doing this in a way that is race-free with userspace
> (i.e. creating them before userspace is told about the device), or are
> they broken and need to have these calls added to the "default
> device/driver/bus" attribute list for them instead?
> 
My use case is primarily for hwmon drivers.

hwmon has a separate API call to register a driver with the hwmon subsystem,
which creates a separate hwmon device and provides the user space notification.
As the created attribute files are often conditional on device variant and device
configuration, I don't see how this could be done through a default attribute
list (even though it might be worthwhile exploring if it can be used for some
of the simpler drivers).

The idea was to also provide devm_hwmon_register and devm_hwmon_unregister.
Together that would help us reducing the remove function for most hwmon
drivers to pretty much nothing.

Some other subsystems:

usb: Used widely. From looking into a couple of sources, usage seems to be
questionable, as I don't see how userspace would be notified. I don't know
enough about usb to be sure, though.

mtd: One use case (volume creation) seems to be safe, as it notifies userspace
about its completion. For UBI I am not that sure, as it registers the device
first and then adds the attributes.

regulators: No idea if it does the right thing.

input: Usage in files I looked at seems questionable.

There are others, but it really gets murky and I don't understand
the subsystems well enough to make a call.

> I think the "we need to fix the drivers" option is the correct one :(
> 
> Ideally, I could get rid of those files from being exported at all, but
> some busses do do things correctly, so I can't.  But they seem to be in
> the minority...
> 
> So how about we fix up the drivers first, then, if there are valid users
> for this type of interface (which I do think there is), we can add it
> then?
> 
I think hwmon is a valid use case.

For other subsystems, I simply don't know enough about those to do that kind
of work; I think it would make more sense to ask it to be done by people who
are familiar with the respective subsystems or drivers to do it.

Besides, looking through well above 1,000 calls would probably take about
forever if a single person was to do it, even if that person would be available
full-time to do the work.

How about an alternative: Provide the API, then if/when people start using it
wrongly ask them to fix up the drivers instead. That seems to make more sense
to me.

Thanks,
Guenter
