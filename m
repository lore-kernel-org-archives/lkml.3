Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3JBP3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3JBP3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:29:33 -0400
Message-ID: <1380727766.14271.74.camel@ul30vt.home>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Alex Williamson <alex.williamson@redhat.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Kim Phillips <kim.phillips@linaro.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, a.motakis@virtualopensystems.com,
        agraf@suse.de, stuart.yoder@freescale.com, B07421@freescale.com,
        B16395@freescale.com, R65777@freescale.com, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Date: Wed, 02 Oct 2013 09:29:26 -0600
In-Reply-To: <20131002151413.GG63102@lvm>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <20131001200054.GA27330@kroah.com>
	 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
	 <20131002015355.GD63102@lvm> <1380681356.14271.57.camel@ul30vt.home>
	 <20131002151413.GG63102@lvm>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 16:14 +0100, Christoffer Dall wrote:
> On Tue, Oct 01, 2013 at 08:35:56PM -0600, Alex Williamson wrote:
> > On Wed, 2013-10-02 at 02:53 +0100, Christoffer Dall wrote:
> > > On Tue, Oct 01, 2013 at 05:02:44PM -0500, Kim Phillips wrote:
> > > > On Tue, 1 Oct 2013 13:00:54 -0700
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > > On Tue, Oct 01, 2013 at 01:38:31PM -0500, Kim Phillips wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Santosh and I are having a problem figuring out how to enable binding
> > > > > > (and re-binding) platform devices to a platform VFIO driver (see
> > > > > > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > > > > > 
> > > > > > Binding platform drivers currently depends on a string match in the
> > > > > > device node's compatible entry.  On an arndale, one can currently
> > > > > > rebind the same device to the same driver like so:
> > > > > > 
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > > > > > 
> > > > > > And one can bind it to the vfio-dt driver, as Antonis instructs, by
> > > > > > appending a 'vfio-dt' string to the device tree compatible entry for
> > > > > > the device.  Then this would work:
> > > > > > 
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > > > > > 
> > > > > > Consequently, the hack patch below [2] allows any platform device to be
> > > > > > bound to the vfio-dt driver, without making changes to the device
> > > > > > tree.  It's a hack because I don't see having any driver name specific
> > > > > > code in drivers/base/bus.c being upstream acceptable.
> > > > > 
> > > > > You are correct.
> > > > > 
> > > > > What is wrong with just doing the above unbind/bind things through
> > > > > sysfs, that is what it is there for, right?
> > > > 
> > > > The bind fails because the compatible string in the device tree doesn't
> > > > match that of the VFIO platform driver, so driver_match_device always
> > > > returns false.
> > > > 
> > > It sounds like this is not going to be pretty almost no matter what
> > > we'll end up doing: Inherently VFIO is going to bind to a device without
> > > the device tree entry for that device ever saying anything about VFIO.
> > > 
> > > How is this solved for PCI?  Can we use some analogy from that work to
> > > construct the missing piece?
> > 
> > PCI supports a dynamic ID table for driver/device matching, see
> > pci_add_dynid().  The problem is that this gets a little sloppy for the
> > period where you have multiple drivers that can claim the same device,
> > especially in the presence of hotplug.  Thus the desire to improve the
> > situation with some kind of direct binding interface.  Thanks,
> > 
> So that's called on the vfio pci driver?

This happens at the PCI bus driver level, all PCI drivers support
dynamic IDs with a sysfs entry for adding and removing them.  vfio-pci
starts with an empty ID table and all it sees are .probe() callbacks
when the dynamic table is updated and a match is made.

> Wouldn't a sysfs file to add compatibility strings to the vfio-platform
> driver make driver_match_device return true and make everyone happy?

Seems like it.  Since you don't have a bus driver providing that
infrastructure for you the driver would need to do it by itself.

> There would be an issue of binding priority to solve, I guess similar to
> the PCI problem, but then at least the two device types would share a
> common orthogonal challenge.

Perhaps some sort of "force_bind" sysfs entry created by the driver that
can unbind the existing driver and skip the match code.  Thanks,

Alex

