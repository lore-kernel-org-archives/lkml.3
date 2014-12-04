Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaLDTFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:05:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39242 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaLDTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:05:30 -0500
Date: Thu, 4 Dec 2014 14:05:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, alex.williamson@redhat.com
Cc: Sander Eikelenboom <linux@eikelenboom.it>, bhelgaas@google.com,
        linux-pci@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
Message-ID: <20141204190514.GB4545@laptop.dumpdata.com>
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com>
 <5480528F.8010106@citrix.com>
 <1107877503.20141204141054@eikelenboom.it>
 <548064EA.8090905@citrix.com>
 <308719815.20141204150909@eikelenboom.it>
 <5480702F.2060004@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480702F.2060004@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:31:11PM +0000, David Vrabel wrote:
> On 04/12/14 14:09, Sander Eikelenboom wrote:
> > 
> > Thursday, December 4, 2014, 2:43:06 PM, you wrote:
> > 
> >> On 04/12/14 13:10, Sander Eikelenboom wrote:
> >>>
> >>> Thursday, December 4, 2014, 1:24:47 PM, you wrote:
> >>>
> >>>> On 04/12/14 12:06, Konrad Rzeszutek Wilk wrote:
> >>>>>
> >>>>> On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> >>>>>>
> >>>>>> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
> >>>>>>>
> >>>>>>> Instead of doing all this complex dance, we depend on the toolstack 
> >>>>>>> doing the right thing. As such implement the 'do_flr' SysFS attribute 
> >>>>>>> which 'xl' uses when a device is detached or attached from/to a guest. 
> >>>>>>> It bypasses the need to worry about the PCI lock. 
> >>>>>>
> >>>>>> No.  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
> >>>>>> proposed). 
> >>>>>>
> >>>>>
> >>>>> Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).
> >>>
> >>>> It is only needed if the core won't provide one.
> >>>
> >>>> +static int pcistub_try_create_reset_file(struct pci_dev *pci)
> >>>> +{
> >>>> +       struct xen_pcibk_dev_data *dev_data = pci_get_drvdata(pci);
> >>>> +       struct device *dev = &pci->dev;
> >>>> +       int ret;
> >>>> +
> >>>> +       /* Already have a per-function reset? */
> >>>> +       if (pci_probe_reset_function(pci) == 0)
> >>>> +               return 0;
> >>>> +
> >>>> +       ret = device_create_file(dev, &dev_attr_reset);
> >>>> +       if (ret < 0)
> >>>> +               return ret;
> >>> +       dev_data->>created_reset_file = true;
> >>>> +       return 0;
> >>>> +}
> >>>
> >>> Wouldn't the "core-reset-sysfs-file" be still wired to the end up calling 
> >>> "pci.c:__pci_dev_reset" ?
> >>>
> >>> The problem with that function is that from my testing it seems that the 
> >>> first option "pci_dev_specific_reset" always seems to return succes, so all the
> >>> other options are skipped (flr, pm, slot, bus). However the device it self is 
> >>> not properly reset enough (perhaps the pci_dev_specific_reset is good enough for 
> >>> none virtualization purposes and it's probably the least intrusive. For 
> >>> virtualization however it would be nice to be sure it resets properly, or have a 
> >>> way to force a specific reset routine.)
> > 
> >> Then you need work with the maintainer for those specific devices or
> >> drivers to fix their specific reset function.
> > 
> >> I'm not adding stuff to pciback to workaround broken quirks.
> > 
> > OK that's a pretty clear message there, so if one wants to use pci and vga
> > passthrough one should better use KVM and vfio-pci.
> 
> Have you (or anyone else) ever raised the problem with the broken reset
> quirk for certain devices with the relevant maintainer?
> 
> > vfio-pci has:
> > - logic to do the try-slot-bus-reset logic
> 
> Just because vfio-pci fixed it incorrectly doesn't mean pciback has to
> as well.
> 
> It makes no sense for both pciback and vfio-pci to workaround problems
> with pci_function_reset() in different ways -- it should be fixed in the
> core PCI code so both can benefit and make use of the same code.

We seem to be going in circles.

This thread: http://patchwork.ozlabs.org/patch/368668/

has an interesting discussion that pretty much touches all of this
and I believe it ends with David agreeing with Alex that an
bus-reset is a perfect use-case.

I believe the contention was on how to expose this interface
to the user-space. David's was thinking to use 'reset' while
I used 'do_flr' (which is a misleading name but hte toolstack
already does it). Perhaps we should just have (as David suggested)
an 'bus_reset' on the devices.

I am going to go on a limb and presume that David was thinking
that this 'bus_reset' would be exposed in the generic PCI land?

> 
> David
> 
