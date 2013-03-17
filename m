Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3CQGaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 02:30:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62281 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3CQGa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 02:30:28 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 16 Mar 2013 23:30:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130317063033.GB32694@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
 <20130316162140.GB2630@kroah.com>
 <20130316181253.GA23608@roeck-us.net>
 <20130316195002.GB3112@kroah.com>
 <20130316212540.GA18933@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316212540.GA18933@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 02:25:40PM -0700, Guenter Roeck wrote:
> On Sat, Mar 16, 2013 at 12:50:02PM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Mar 16, 2013 at 11:12:53AM -0700, Guenter Roeck wrote:
> > > Adding lm-sensors.
> > > 
> > > On Sat, Mar 16, 2013 at 09:21:40AM -0700, Greg Kroah-Hartman wrote:
> > > > On Thu, Mar 14, 2013 at 08:24:45PM -0700, Guenter Roeck wrote:
> > > > > Provide devres functions for device_create_file, sysfs_create_file,
> > > > > and sysfs_create_group plus the respective remove functions.
> > > > > 
> > > > > Idea is to be able to drop calls to the remove functions from the various
> > > > > drivers using those calls.
> > > > 
> > > > Hm, despite the fact that almost every driver that makes these calls is
> > > > broken?  :)
> > > > 
> > > > > Potential savings are substantial. There are more than 700 calls to
> > > > > device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
> > > > > and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
> > > > > as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
> > > > > opportunities, and adding sysfs_create_link would create another 100 or so.
> > > > 
> > > > The idea is nice, but why are these drivers adding sysfs files on their
> > > > own?  Are they doing this in a way that is race-free with userspace
> > > > (i.e. creating them before userspace is told about the device), or are
> > > > they broken and need to have these calls added to the "default
> > > > device/driver/bus" attribute list for them instead?
> > > > 
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
> > 
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
> 
> If interrupts are supported, those are typically used to signal attribute
> file related events (via udev and/or poll events), meaning the interrupts
> must only be enabled after sysfs files were created (becaue the interrupt
> acts on it), and should only be enabled after the hwmon device was registered
> (because otherwise userspace won't know about the device if the first interrupt
> happens after sysfs file creation but before hwmon registration).
> 
> I looked into the use of is_visible. The drivers I looked at (ad7877, tsc2005,
> lm3533_led, lm3533-core, lm3533_bl) all need data obtained in the probe function
> in their is_visible function, meaning the attribute files can not be created
> before that data is available. That (and the solution to create the attributes
> in the probe function after basic device initialization) is quite similar
> to the problem we have in the hwmon subsystem and its current solution.
> 
> Overall I have no idea how to make this all fit into the generic attribute
> file handling. If you do, please let me know.
> 
I spent some time implementing two variants of devm_hwmon_device_register().
One is based on the patchset provided here, and uses the following API.

struct device *devm_hwmon_device_register(struct device *dev);

The other is

struct device *devm_hwmon_device_register(struct device *dev, struct
					  attribute_group **groups);

The second API includes a pointer to the sysfs attribute groups, and creates the
sysfs attributes within the API call. With this approach, conditional attributes
are managed with is_visible.

I then converted a couple of drivers to the new APIs.

For the first approach, conversion was quite simple:
	device_create_file -> devm_device_create_file
	sysfs_create_group -> devm_sysfs_create_group
	hwmon_device_register -> devm_hwmon_device_register
and drop all remove calls.

Result for the lm90 driver as a medium complexity example:

 drivers/hwmon/lm90.c |   46 +++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

The object size is reduced by approximately 500 bytes (of 20k).

Result for max16065 driver:

 drivers/hwmon/max16065.c |   52 +++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 40 deletions(-)

Code size is reduced by approximately 450 bytes (of 12k).

For the second approach, I had to convert sysfs groups to use is_visible,
create new groups where those did not exist, implement is_visible functions,
drop calls to device_create_file, sysfs_create_group, and drop the remove
functions.

Result for the lm90 driver:
 drivers/hwmon/lm90.c |  137 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 83 insertions(+), 54 deletions(-)

The object size increases by about 200 bytes.

Results for max16065 driver:

 drivers/hwmon/max16065.c |  142 ++++++++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 62 deletions(-)

Code size increases by about 160 bytes.

This is after I pulled all tricks I could find to reduce the code size increase.
In both cases, the code ended up being less readable and more confusing
than before, as the validation if an attribute has to be created or not
is now spread across multiple is_visible functions and no longer
in a single block of code, and it is more difficult to understand if an
attribute will be created or not.

For simple drivers which don't need is_visible, the resulting code is
similar with both approaches. Unfortunately, most hwmon drivers are not
that simple. As soon as conditional attributes are needed, the code ends up
being more complex.

In conclusion, I see the second approach (ie using is_visible) as a no-go.
The idea is to reduce complexity, not to increase it. So, ultimately, we can
discuss how the API functions are named and its parameters, but for the hwmon
subsystem conversion to devres to make sense we would need the device/sysfs
API functions along the line I proposed. Otherwise we are better off with
just keeping the current hwmon API and not bother converting it to devres.

Thanks,
Guenter
