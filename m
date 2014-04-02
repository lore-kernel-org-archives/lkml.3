Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbaDBAjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:39:39 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56260 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaDBAje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:39:34 -0400
Date: Tue, 1 Apr 2014 17:39:29 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stuart.yoder@freescale.com,
        kvm@vger.kernel.org, jan.kiszka@siemens.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux-pci@vger.kernel.org,
        linux@roeck-us.net, konrad.wilk@oracle.com, d.kasatkin@samsung.com,
        tj@kernel.org, scottwood@freescale.com,
        a.motakis@virtualopensystems.com, tech@virtualopensystems.com,
        Bharat.Bhushan@freescale.com, toshi.kani@hp.com,
        kim.phillips@linaro.org, a.rigo@virtualopensystems.com,
        iommu@lists.linux-foundation.org, joe@perches.com
Subject: Re: [RFC PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
Message-ID: <20140402003929.GL4756@lvm>
References: <20140401161851.18815.31108.stgit@bling.home>
 <20140401164725.GA4649@kroah.com>
 <1396372540.476.160.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396372540.476.160.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:15:40AM -0600, Alex Williamson wrote:
> On Tue, 2014-04-01 at 09:47 -0700, Greg KH wrote:
> > On Tue, Apr 01, 2014 at 10:28:54AM -0600, Alex Williamson wrote:
> > > The driver_override field allows us to specify the driver for a device
> > > rather than relying on the driver to provide a positive match of the
> > > device.  This shortcuts the existing process of looking up the vendor
> > > and device ID, adding them to the driver new_id, binding the device,
> > > then removing the ID, but it also provides a couple advantages.
> > > 
> > > First, the above process allows the driver to bind to any device
> > > matching the new_id for the window where it's enabled.  This is often
> > > not desired, such as the case of trying to bind a single device to a
> > > meta driver like pci-stub or vfio-pci.  Using driver_override we can
> > > do this deterministically using:
> > > 
> > > echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > > 
> > > Previously we could not invoke drivers_probe after adding a device
> > > to new_id for a driver as we get non-deterministic behavior whether
> > > the driver we intend or the standard driver will claim the device.
> > > Now it becomes a deterministic process, only the driver matching
> > > driver_override will probe the device.
> > > 
> > > To return the device to the standard driver, we simply clear the
> > > driver_override and reprobe the device, ex:
> > > 
> > > echo > /sys/bus/pci/devices/0000:03:00.0/preferred_driver
> > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > > 
> > > Another advantage to this approach is that we can specify a driver
> > > override to force a specific binding or prevent any binding.  For
> > > instance when an IOMMU group is exposed to userspace through VFIO
> > > we require that all devices within that group are owned by VFIO.
> > > However, devices can be hot-added into an IOMMU group, in which case
> > > we want to prevent the device from binding to any driver (preferred
> > > driver = "none") or perhaps have it automatically bind to vfio-pci.
> > > With driver_override it's a simple matter for this field to be set
> > > internally when the device is first discovered to prevent driver
> > > matches.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > > 
> > > Apologies for the exceptionally long cc list, this is a follow-up to
> > > Stuart's "Subject: mechanism to allow a driver to bind to any device"
> > > thread.  This is effectively a v2 of the proof-of-concept patch I
> > > posted in that thread.  This version changes to use a dummy id struct
> > > to return on an "override" match, which removes the collateral damage
> > > and greatly simplifies the patch.  This feels fairly well baked for
> > > PCI and I would expect that platform drivers could do a similar
> > > implementation.  From there perhaps we can discuss whether there's
> > > any advantage to placing driver_override on struct device.  The logic
> > > for incorporating it into the match still needs to happen per bus
> > > driver, so it might only contribute to consistency of the show/store
> > > sysfs attributes to move it up to struct device.  Please comment.
> > > Thanks,
> > > 
> > > Alex
> > > 
> > >  drivers/pci/pci-driver.c |   25 ++++++++++++++++++++++---
> > >  drivers/pci/pci-sysfs.c  |   40 ++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/pci.h      |    1 +
> > >  3 files changed, 63 insertions(+), 3 deletions(-)
> > 
> > No Documentation/ABI/ update to reflect the ABI you are creating?
> 
> Oops, thanks for the reminder.  I'd propose this:
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index a3c5a66..55ca6e5 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -250,3 +250,21 @@ Description:
>  		valid.  For example, writing a 2 to this file when sriov_numvfs
>  		is not 0 and not 2 already will return an error. Writing a 10
>  		when the value of sriov_totalvfs is 8 will return an error.
> +
> +What:		/sys/bus/pci/devices/.../driver_override
> +Date:		April 2014
> +Contact:	Alex Williamson <alex.williamson@redhat.com>
> +Description:
> +		This file allows the driver for a device to be specified
> +		which will override standard static and dynamic ID matching.
> +		When specified, only a driver with a name matching the value
> +		written to driver_override will have an opportunity to bind
> +		to the device.  The override may be cleared by writing an
> +		empty string (ex. echo > driver_override), returning the
> +		device to standard matching rules binding.  Writing to
> +		driver_override does not automatically unbind the device from
> +		its current driver or make any attempt to automatically load
> +		the specified driver name.  If no driver with a matching name

Would it make sense to suggest how this is done (e.g. this must be done
by writing into ....)?

> +		is currently loaded in the kernel, no match will be found.

"no match will be found" when trying to bind any driver to the device,
or?  Can this be clarified?

> +		This also allows devices to opt-out of driver binding using
> +		a driver_override name such as "none".
> 
Otherwise it's very well written.

-Christoffer
