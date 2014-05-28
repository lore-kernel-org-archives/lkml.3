Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaE1DaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:30:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaE1DaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:30:21 -0400
Date: Tue, 27 May 2014 20:30:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, konrad.wilk@oracle.com, kim.phillips@linaro.org,
        stuart.yoder@freescale.com, agraf@suse.de, libvir-list@redhat.com,
        iommu@lists.linux-foundation.org, christoffer.dall@linaro.org,
        tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: Introduce new device binding path using
 pci_dev.driver_override
Message-ID: <20140528033019.GA11547@kroah.com>
References: <20140520145136.28232.90707.stgit@bling.home>
 <20140528030742.GO11907@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528030742.GO11907@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:07:42PM -0600, Bjorn Helgaas wrote:
> On Tue, May 20, 2014 at 08:53:21AM -0600, Alex Williamson wrote:
> > The driver_override field allows us to specify the driver for a device
> > rather than relying on the driver to provide a positive match of the
> > device.  This shortcuts the existing process of looking up the vendor
> > and device ID, adding them to the driver new_id, binding the device,
> > then removing the ID, but it also provides a couple advantages.
> > 
> > First, the above existing process allows the driver to bind to any
> > device matching the new_id for the window where it's enabled.  This is
> > often not desired, such as the case of trying to bind a single device
> > to a meta driver like pci-stub or vfio-pci.  Using driver_override we
> > can do this deterministically using:
> > 
> > echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > 
> > Previously we could not invoke drivers_probe after adding a device
> > to new_id for a driver as we get non-deterministic behavior whether
> > the driver we intend or the standard driver will claim the device.
> > Now it becomes a deterministic process, only the driver matching
> > driver_override will probe the device.
> > 
> > To return the device to the standard driver, we simply clear the
> > driver_override and reprobe the device:
> > 
> > echo > /sys/bus/pci/devices/0000:03:00.0/driver_override
> > echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> > echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> > 
> > Another advantage to this approach is that we can specify a driver
> > override to force a specific binding or prevent any binding.  For
> > instance when an IOMMU group is exposed to userspace through VFIO
> > we require that all devices within that group are owned by VFIO.
> > However, devices can be hot-added into an IOMMU group, in which case
> > we want to prevent the device from binding to any driver (override
> > driver = "none") or perhaps have it automatically bind to vfio-pci.
> > With driver_override it's a simple matter for this field to be set
> > internally when the device is first discovered to prevent driver
> > matches.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Greg, are you going to weigh in on this?  It does seem to solve some real
> problems.  ISTR you had an opinion once, but I don't know your current
> thoughts.

Give me a few more days, still digging through my patch backlog...

thanks,

greg k-h
