Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3GGOlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:41:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3GGOlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:41:02 -0400
Date: Sun, 7 Jul 2013 17:42:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH] uio: uio_pci_generic: Add support for MSI interrupts
Message-ID: <20130707144208.GA3960@redhat.com>
References: <1372285823-6293-1-git-send-email-linux@roeck-us.net>
 <20130627074501.GC5489@redhat.com>
 <20130627170052.GA9646@roeck-us.net>
 <20130704072023.GA2095@redhat.com>
 <20130704142523.GA22081@roeck-us.net>
 <20130704143412.GA23126@redhat.com>
 <20130704163500.GA24375@roeck-us.net>
 <20130707081511.GA28067@redhat.com>
 <20130707143901.GA25797@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130707143901.GA25797@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 07:39:01AM -0700, Guenter Roeck wrote:
> On Sun, Jul 07, 2013 at 11:15:11AM +0300, Michael S. Tsirkin wrote:
> > On Thu, Jul 04, 2013 at 09:35:00AM -0700, Guenter Roeck wrote:
> > > On Thu, Jul 04, 2013 at 05:34:12PM +0300, Michael S. Tsirkin wrote:
> > > > On Thu, Jul 04, 2013 at 07:25:23AM -0700, Guenter Roeck wrote:
> > > > > On Thu, Jul 04, 2013 at 10:20:23AM +0300, Michael S. Tsirkin wrote:
> > > > > > On Thu, Jun 27, 2013 at 10:00:52AM -0700, Guenter Roeck wrote:
> > > > > > > On Thu, Jun 27, 2013 at 10:45:01AM +0300, Michael S. Tsirkin wrote:
> > > > > > > > On Wed, Jun 26, 2013 at 03:30:23PM -0700, Guenter Roeck wrote:
> > > > > > > > > Enable support for MSI interrupts if the device supports it.
> > > > > > > > > Since MSI interrupts are edge triggered, it is no longer necessary to
> > > > > > > > > disable interrupts in the kernel and re-enable them from user-space.
> > > > > > > > > Instead, clearing the interrupt condition in the user space application
> > > > > > > > > automatically re-enables the interrupt.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > > > > > > ---
> > > > > > > > > An open question is if we can just do this unconditionally
> > > > > > > > > or if there should be some flag to enable it. A module parameter, maybe ?
> > > > > > > > 
> > > > > > > > NACK
> > > > > > > > 
> > > > > > > > UIO is for devices that don't do memory writes.
> > > > > > > > Anything that can do writes must be protected by an IOMMU
> > > > > > > > and/or have a secure kernel driver, not a UIO stub.
> > > > > > > > 
> > > > > > > > MSI is done by memory writes so if userspace
> > > > > > > > controls the device it can trick it to write
> > > > > > > > anywhere in memory.
> > > > > > > > 
> > > > > > > Just out of curiosity: Since MSI support is mandatory for all PCIE devices,
> > > > > > > isn't that possible anyway, even if MSI is not enabled by the kernel ?
> > > > > > > All one would need to do is to enable MSI from user space; after all,
> > > > > > > the chip configuration space is writable.
> > > > > > > 
> > > > > > > Thanks,
> > > > > > > Guenter
> > > > > > 
> > > > > > If a device has capability to do writes, sure. So don't do this then :)
> > > > > > 
> > > > > Not an option. I need to use MSI.
> > > > > 
> > > > > Not that it matters anymore - turns out it was better writing a specific driver
> > > > > for my devices anyway; I needed to be able to disable chip interrupts before
> > > > > unloading the driver. But why is it then a reason to NACK this patch ?
> > > > 
> > > > There seem to be two cases - either you can't access the device -
> > > > and the uio driver is not useful - or you can, and it's not safe.
> > > > In both cases the patch does not seem to bring about anything
> > > > except user confusion ...
> > > > 
> > > Sounds like claiming that supporting MSI would cause some kind of confusion.
> > > Not sure if I can follow that logic.
> > > 
> > > Actually, it simplifies the user space code a lot. Since MSI interrupts are edge
> > > triggered and queued, it is not necessary to disable the interrupts, and all
> > > user space has to do is to remove the interrupt reason. Works quite nicely for
> > > our devices.
> > > 
> > > As I said, I don't really care too much anymore if this patch is rejected, but
> > > the reasons for the rejection are kind of weak.
> > > 
> > > > > Besides, doesn't one have to be root anyway to perform such activities,
> > > > > which could then be more easily accomplished by writing into /dev/mem ?
> > > > > 
> > > > > Thanks,
> > > > > Guenter
> > > > 
> > > > root might not be able to write into /dev/mem.
> > > > 
> > > I don't really want to try, but at least it is marked rw for root.
> > > 
> > > Guenter
> > 
> > Yes but mechanisms such as selinux can still block it.
> > 
> I hope it can also prevent the use of the the MSI trick on PCIe devices.
> After all, the user space mechanisms to write into configuration space
> are available for all devices, not just for those with uio drivers.
> 
> Guenter

Yes, selinux can also prevent access to sysfs and procfs for any process.

-- 
MST
