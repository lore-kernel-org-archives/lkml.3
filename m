Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaCaXw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:52:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaCaXwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:52:55 -0400
Message-ID: <1396309926.476.136.camel@ul30vt.home>
Subject: Re: mechanism to allow a driver to bind to any device
From: Alex Williamson <alex.williamson@redhat.com>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: konrad.wilk@oracle.com, kvm@vger.kernel.org, jan.kiszka@siemens.com,
        will.deacon@arm.com, stuart.yoder@freescale.com,
        a.rigo@virtualopensystems.com, mhocko@suse.cz, scottwood@freescale.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux@roeck-us.net,
        d.kasatkin@samsung.com, tj@kernel.org, bhelgaas@google.com,
        a.motakis@virtualopensystems.com, tech@virtualopensystems.com,
        toshi.kani@hp.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        joe@perches.com, christoffer.dall@linaro.org,
        kim.phillips@freescale.com
Date: Mon, 31 Mar 2014 17:52:06 -0600
In-Reply-To: <20140331173627.e4abfb3397287c3b9aff6606@linaro.org>
References: <20140215024725.GA2542@kroah.com>
	 <7043e1edd9974de590dcb392cd8aff14@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140215173348.GA8056@kroah.com>
	 <b6374a0f30194969ba4622ff2f58ae65@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140220224337.GA20097@kroah.com>
	 <54cd150235ba4954becdd12f725c5ebd@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140326144025.GA18387@phenom.dumpdata.com>
	 <D45FC8F2-7807-4BBB-A253-8EFCD091D6BD@suse.de>
	 <1395850862.632.247.camel@ul30vt.home>
	 <1395871761.632.316.camel@ul30vt.home>
	 <20140328165809.GA12659@phenom.dumpdata.com>
	 <1396026623.4502.34.camel@ul30vt.home>
	 <20140331173627.e4abfb3397287c3b9aff6606@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 17:36 -0500, Kim Phillips wrote:
> On Fri, 28 Mar 2014 11:10:23 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Fri, 2014-03-28 at 12:58 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Wed, Mar 26, 2014 at 04:09:21PM -0600, Alex Williamson wrote:
> > > > On Wed, 2014-03-26 at 10:21 -0600, Alex Williamson wrote:
> > > > > On Wed, 2014-03-26 at 23:06 +0800, Alexander Graf wrote:
> > > > > > 
> > > > > > > Am 26.03.2014 um 22:40 schrieb Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> > > > > > > 
> > > > > > >> On Wed, Mar 26, 2014 at 01:40:32AM +0000, Stuart Yoder wrote:
> > > > > > >> Hi Greg,
> > > > > > >> 
> > > > > > >> We (Linaro, Freescale, Virtual Open Systems) are trying get an issue
> > > > > > >> closed that has been perculating for a while around creating a mechanism
> > > > > > >> that will allow kernel drivers like vfio can bind to devices of any type.
> > > > > > >> 
> > > > > > >> This thread with you:
> > > > > > >> http://www.spinics.net/lists/kvm-arm/msg08370.html
> > > > > > >> ...seems to have died out, so am trying to get your response
> > > > > > >> and will summarize again.  Vfio drivers in the kernel (regardless of
> > > > > > >> bus type) need to bind to devices of any type.  The driver's function
> > > > > > >> is to simply export hardware resources of any type to user space.
> > > > > > >> 
> > > > > > >> There are several approaches that have been proposed:
> > > > > > > 
> > > > > > > You seem to have missed the one I proposed.
> > > > > > >> 
> > > > > > >>   1.  new_id -- (current approach) the user explicitly registers
> > > > > > >>       each new device type with the vfio driver using the new_id
> > > > > > >>       mechanism.
> > > > > > >> 
> > > > > > >>       Problem: multiple drivers will be resident that handle the
> > > > > > >>       same device type...and there is nothing user space hotplug
> > > > > > >>       infrastructure can do to help.
> > > > > > >> 
> > > > > > >>   2.  "any id" -- the vfio driver could specify a wildcard match
> > > > > > >>       of some kind in its ID match table which would allow it to
> > > > > > >>       match and bind to any possible device id.  However,
> > > > > > >>       we don't want the vfio driver grabbing _all_ devices...just the ones we
> > > > > > >>       explicitly want to pass to user space.
> > > > > > >> 
> > > > > > >>       The proposed patch to support this was to create a new flag
> > > > > > >>       "sysfs_bind_only" in struct device_driver.  When this flag
> > > > > > >>       is set, the driver can only bind to devices via the sysfs
> > > > > > >>       bind file.  This would allow the wildcard match to work.
> > > > > > >> 
> > > > > > >>       Patch is here:
> > > > > > >>       https://lkml.org/lkml/2013/12/3/253
> > > > > > >> 
> > > > > > >>   3.  "Driver initiated explicit bind" -- with this approach the
> > > > > > >>       vfio driver would create a private 'bind' sysfs object
> > > > > > >>       and the user would echo the requested device into it:
> > > > > > >> 
> > > > > > >>       echo 0001:03:00.0 > /sys/bus/pci/drivers/vfio-pci/vfio_bind
> > > > > > >> 
> > > > > > >>       In order to make that work, the driver would need to call
> > > > > > >>       driver_probe_device() and thus we need this patch:
> > > > > > >>       https://lkml.org/lkml/2014/2/8/175
> > > > > > > 
> > > > > > > 4). Use the 'unbind' (from the original device) and 'bind' to vfio driver.
> > > > > > 
> > > > > > This is approach 2, no?
> > > > > > 
> > > > > > > 
> > > > > > > Which I think is what is currently being done. Why is that not sufficient?
> > > > > > 
> > > > > > How would 'bind to vfio driver' look like?
> > > > > > 
> > > > > > > The only thing I see in the URL is " That works, but it is ugly."
> > > > > > > There is some mention of race but I don't see how - if you do the 'unbind'
> > > > > > > on the original driver and then bind the BDF to the VFIO how would you get
> > > > > > > a race?
> > > > > > 
> > > > > > Typically on PCI, you do a
> > > > > > 
> > > > > >   - add wildcard (pci id) match to vfio driver
> > > > > >   - unbind driver
> > > > > >   -> reprobe
> > > > > >   -> device attaches to vfio driver because it is the least recent match
> > > > > >   - remove wildcard match from vfio driver
> > > > > > 
> > > > > > If in between you hotplug add a card of the same type, it gets attached to vfio - even though the logical "default driver" would be the device specific driver.
> > > > > 
> > > > > I've mentioned drivers_autoprobe in the past, but I'm not sure we're
> > > > > really factoring it into the discussion.  drivers_autoprobe allows us to
> > > > > toggle two points:
> > > > > 
> > > > > a) When a new device is added whether we automatically give drivers a
> > > > > try at binding to it
> > > > > 
> > > > > b) When a new driver is added whether it gets to try to bind to anything
> > > > > in the system
> > > > > 
> > > > > So we do have a mechanism to avoid the race, but the problem is that it
> > > > > becomes the responsibility of userspace to:
> > > > > 
> > > > > 1) turn off drivers_autoprobe
> > > > > 2) unbind/new_id/bind/remove_id
> > > > > 3) turn on drivers_autoprobe
> > > > > 4) call drivers_probe for anything added between 1) & 3)
> > > > > 
> > > > > Is the question about the ugliness of the current solution whether it's
> > > > > unreasonable to ask userspace to do this?
> > > > > What we seem to be asking for above is more like an autoprobe flag per
> > > > > driver where there's some way for this special driver to opt out of auto
> > > > > probing.  Option 2. in Stuart's list does this by short-cutting ID
> > > > > matching so that a "match" is only found when using the sysfs bind path,
> > > > > option 3. enables a way for a driver to expose their own sysfs entry
> > > > > point for binding.  The latter feels particularly chaotic since drivers
> > > > > get to make-up their own bind mechanism.
> 
> agreed - so far, option 2 looks the most sane.
> 
> > > > > Another twist I'll throw in is that devices can be hot added to IOMMU
> > > > > groups that are in-use by userspace.  When that happens we'd like to be
> > > > > able to disable driver autoprobe of the device to avoid a host driver
> > > > > automatically binding to the device.  I wonder if instead of looking at
> > > > > the problem from the driver perspective, if we were to instead look at
> > > > > it from the device perspective if we might find a solution that would
> > > > > address both.  For instance, if devices had a driver_probe_id property
> > > > > that was by default set to their bus specific ID match ("$VENDOR
> > > > > $DEVICE" on PCI) could we use that to write new match IDs so that a
> > > > > device could only bind to a given driver?  Effectively we could then
> > > > > bind either using the current method of adding to the list of IDs a
> > > > > driver will match of changing the ID that a device would match.  Does
> > > > > that get us anywhere?  Thanks,
> 
> How does this compare to Scott's device->sysfs_bind_only, in addition
> to option 2 above's driver->sysfs_bind_only?:
> 
> "What it looks like we do still want from the driver core is the ability
> for a driver to say that it should not be bound to a device except via
> explicit sysfs bind, and the ability for a user to say that a device
> should not be bound to a driver except via explicit sysfs bind.  This is
> a separate issue from making driver_match_device() happy (in some
> earlier e-mails in the thread these two issues were not properly
> separated)." [1]

Sorry, I can't find reference to how device->sysfs_bind_only works in
conjunction with driver->sysfs_bind_only.  Can you provide some example
use cases?

As it stands, the driver->sysfs_bind_only patch of option 2 forces a
driver to operate in either the existing mode or a mode where there is
no automatic binding.  That breaks existing vfio-pci users today who are
able to build the driver static into their kernel and use vfio-pci.ids=
$VENDOR:$DEVICE on the kernel commandline so that vfio-pci grabs their
devices before any loadable module drivers.  It also doesn't address the
issue above where a device is hot-added to an IOMMU group and we may
want to have the device auto-bind to the vfio driver, or at the very
least not auto-bind to a host driver.  Maybe the device portion of
sysfs_bind_only addresses that.

All of the original proposals above are working on the premise that we
add an id or enable an "any id" for a driver, but then we need to
prevent the driver from binding to others of that id, which just makes a
mess.  So why not reverse it and allow a device to specify an id that
matches a driver?  That automatically solves the many-to-one problem of
device-to-driver since we're only setting a property on a single device.
We also no longer care if the device gets bound automatically or via
sysfs because it can only go to the correct driver.  So we don't need a
restriction like sysfs-only.  There's no modal operation of the driver,
it's just a new match rule.  It can also be implemented at the bus
driver, completely independent of the driver core.

> > > > Here's one way this might work for PCI; note that we can do this
> > > > entirely in the bus driver for PCI.  Bind/unbind would go like this:
> > > > 
> > > > # bind device to vfio-pci
> > > > echo vfio-pci > /sys/bus/pci/devices/0000\:03\:00.0/preferred_driver
> > > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
> > > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > > > 
> > > > # bind device back to host driver
> > > > echo > /sys/bus/pci/devices/0000\:03\:00.0/preferred_driver
> > > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
> > > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> With the null-write to preferred_driver, it's not crystal clear (to
> me at least) what would happen in the above command sequence, given
> multiple drivers may match.  It seems like there'd be more control
> binding in a multiple driver-match environment using
> {device,driver}->sysfs_bind_only.

The null-write says there is no preferred driver and existing matching
rules apply.  The device starts out with no preferred_driver.  Notice
that we never added any new ids to drivers, we made the device match the
driver, then we cleared it.  Thanks,

Alex

