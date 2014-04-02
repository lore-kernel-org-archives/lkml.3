Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaDBXCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:02:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbaDBXCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:02:42 -0400
Message-ID: <1396479728.476.410.camel@ul30vt.home>
Subject: Re: [RFC PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
From: Alex Williamson <alex.williamson@redhat.com>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: gregkh@linuxfoundation.org, stuart.yoder@freescale.com,
        kvm@vger.kernel.org, jan.kiszka@siemens.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux-pci@vger.kernel.org,
        linux@roeck-us.net, konrad.wilk@oracle.com, d.kasatkin@samsung.com,
        tj@kernel.org, scottwood@freescale.com,
        a.motakis@virtualopensystems.com, tech@virtualopensystems.com,
        Bharat.Bhushan@freescale.com, toshi.kani@hp.com,
        a.rigo@virtualopensystems.com, iommu@lists.linux-foundation.org,
        joe@perches.com, christoffer.dall@linaro.org,
        kim.phillips@freescale.com
Date: Wed, 02 Apr 2014 17:02:08 -0600
In-Reply-To: <20140402170638.51745f5c231a7632422e4cc5@linaro.org>
References: <20140401161851.18815.31108.stgit@bling.home>
	 <20140401185212.7229f2c114c7e95089f00e90@linaro.org>
	 <20140402002324.GA2662@kroah.com>
	 <20140402170638.51745f5c231a7632422e4cc5@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 17:06 -0500, Kim Phillips wrote:
> On Tue, 1 Apr 2014 17:23:24 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Apr 01, 2014 at 06:52:12PM -0500, Kim Phillips wrote:
> > > On Tue, 01 Apr 2014 10:28:54 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > 
> > > > The driver_override field allows us to specify the driver for a device
> > > > rather than relying on the driver to provide a positive match of the
> > > > device.  This shortcuts the existing process of looking up the vendor
> > > > and device ID, adding them to the driver new_id, binding the device,
> > > > then removing the ID, but it also provides a couple advantages.
> > > > 
> > > > First, the above process allows the driver to bind to any device
> > > > matching the new_id for the window where it's enabled.  This is often
> > > > not desired, such as the case of trying to bind a single device to a
> > > > meta driver like pci-stub or vfio-pci.  Using driver_override we can
> > > > do this deterministically using:
> > > > 
> > > > echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> > > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > > > 
> > > > Previously we could not invoke drivers_probe after adding a device
> > > > to new_id for a driver as we get non-deterministic behavior whether
> > > > the driver we intend or the standard driver will claim the device.
> > > > Now it becomes a deterministic process, only the driver matching
> > > > driver_override will probe the device.
> > > > 
> > > > To return the device to the standard driver, we simply clear the
> > > > driver_override and reprobe the device, ex:
> > > > 
> > > > echo > /sys/bus/pci/devices/0000:03:00.0/preferred_driver
> > > > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > > > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > > > 
> > > > Another advantage to this approach is that we can specify a driver
> > > > override to force a specific binding or prevent any binding.  For
> > > > instance when an IOMMU group is exposed to userspace through VFIO
> > > > we require that all devices within that group are owned by VFIO.
> > > > However, devices can be hot-added into an IOMMU group, in which case
> > > > we want to prevent the device from binding to any driver (preferred
> > > > driver = "none") or perhaps have it automatically bind to vfio-pci.
> > > > With driver_override it's a simple matter for this field to be set
> > > > internally when the device is first discovered to prevent driver
> > > > matches.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > > 
> > > > Apologies for the exceptionally long cc list, this is a follow-up to
> > > > Stuart's "Subject: mechanism to allow a driver to bind to any device"
> > > > thread.  This is effectively a v2 of the proof-of-concept patch I
> > > > posted in that thread.  This version changes to use a dummy id struct
> > > > to return on an "override" match, which removes the collateral damage
> > > > and greatly simplifies the patch.  This feels fairly well baked for
> > > > PCI and I would expect that platform drivers could do a similar
> > > > implementation.  From there perhaps we can discuss whether there's
> > > > any advantage to placing driver_override on struct device.  The logic
> > > > for incorporating it into the match still needs to happen per bus
> > > > driver, so it might only contribute to consistency of the show/store
> > > > sysfs attributes to move it up to struct device.  Please comment.
> > > 
> > > Sounds like Greg likes this approach more than {drv,dev}_sysfs_only.
> > 
> > I have made no such judgement, I only pointed out that if you
> 
> ok.  If no-one chimes in in favour of one or the other, driver_override
> works for platform devices.
> 
> > modify/add/remove a sysfs file, it needs to have documentation for it.
> 
> ok, so the platform device implementation should add a new
> Documentation/ABI/testing/sysfs-bus-platform...
> 
> > > The diff below is the result of duplicating and converting this patch
> > > for platform devices, and, indeed, binding a device to the
> > > vfio-platform driver succeeds with:
> > > 
> > > echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
> > > echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
> > > echo fff51000.ethernet > /sys/bus/platform/drivers_probe
> > > 
> > > However, it's almost pure duplication modulo the bus match code.  The
> > > only other place I can see where to put the common bus check is
> > > drivers/base/base.h:driver_match_device(), which I'm guessing is
> > > off-limits?  So should we leave this as per-bus code, and somehow
> > > refactor driver_override_{show,store}?
> > 
> > If you can provide a way for this to be done in a bus-independant way,
> > like we did for new_id and the like, I'd be open to reviewing it.
> 
> I may be blind, but I don't see any new_id-related code shared
> between drivers/pci/pci-driver.c and, e.g., drivers/usb/serial/bus.c,
> nor do I see anything new_id related in drivers/base/.
> 
> So if we are to follow the current model, the PCI and platform device
> implementations should be maintained separately.

I'm not finding any common new_id code either.  Only PCI and USB
implement both new_id and remove_id and they don't share code or ABI
documentation.  I also don't see much advantage to trying to push this
into struct device, we could save a few lines of show/store code, but
the functionality needs to be implemented by the bus driver.  The base
code can't override bus drivers like PCI that do another match lookup to
retrieve the ID table entry to pass to the driver.  At best we could
have common show/store keyed from a bool on struct bus_type.  Thanks,

Alex

