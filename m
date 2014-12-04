Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaLDQz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbaLDQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:55:27 -0500
Message-ID: <1417712114.15750.123.camel@bling.home>
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset
 slot or bus with 'do_flr' SysFS attribute
From: Alex Williamson <alex.williamson@redhat.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: David Vrabel <david.vrabel@citrix.com>, bhelgaas@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Date: Thu, 04 Dec 2014 09:55:14 -0700
In-Reply-To: <779770151.20141204172558@eikelenboom.it>
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com>
	 <5480528F.8010106@citrix.com> <1107877503.20141204141054@eikelenboom.it>
	 <548064EA.8090905@citrix.com> <308719815.20141204150909@eikelenboom.it>
	 <5480702F.2060004@citrix.com> <1578910783.20141204155025@eikelenboom.it>
	 <1417707546.15750.100.camel@bling.home>
	 <779770151.20141204172558@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 17:25 +0100, Sander Eikelenboom wrote:
> Thursday, December 4, 2014, 4:39:06 PM, you wrote:
> 
> > On Thu, 2014-12-04 at 15:50 +0100, Sander Eikelenboom wrote:
> >> Thursday, December 4, 2014, 3:31:11 PM, you wrote:
> >> 
> >> > On 04/12/14 14:09, Sander Eikelenboom wrote:
> >> >> 
> >> >> Thursday, December 4, 2014, 2:43:06 PM, you wrote:
> >> >> 
> >> >>> On 04/12/14 13:10, Sander Eikelenboom wrote:
> >> >>>>
> >> >>>> Thursday, December 4, 2014, 1:24:47 PM, you wrote:
> >> >>>>
> >> >>>>> On 04/12/14 12:06, Konrad Rzeszutek Wilk wrote:
> >> >>>>>>
> >> >>>>>> On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> >> >>>>>>>
> >> >>>>>>> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
> >> >>>>>>>>
> >> >>>>>>>> Instead of doing all this complex dance, we depend on the toolstack 
> >> >>>>>>>> doing the right thing. As such implement the 'do_flr' SysFS attribute 
> >> >>>>>>>> which 'xl' uses when a device is detached or attached from/to a guest. 
> >> >>>>>>>> It bypasses the need to worry about the PCI lock. 
> >> >>>>>>>
> >> >>>>>>> No.  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
> >> >>>>>>> proposed). 
> >> >>>>>>>
> >> >>>>>>
> >> >>>>>> Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).
> >> >>>>
> >> >>>>> It is only needed if the core won't provide one.
> >> >>>>
> >> >>>>> +static int pcistub_try_create_reset_file(struct pci_dev *pci)
> >> >>>>> +{
> >> >>>>> +       struct xen_pcibk_dev_data *dev_data = pci_get_drvdata(pci);
> >> >>>>> +       struct device *dev = &pci->dev;
> >> >>>>> +       int ret;
> >> >>>>> +
> >> >>>>> +       /* Already have a per-function reset? */
> >> >>>>> +       if (pci_probe_reset_function(pci) == 0)
> >> >>>>> +               return 0;
> >> >>>>> +
> >> >>>>> +       ret = device_create_file(dev, &dev_attr_reset);
> >> >>>>> +       if (ret < 0)
> >> >>>>> +               return ret;
> >> >>>> +       dev_data->>created_reset_file = true;
> >> >>>>> +       return 0;
> >> >>>>> +}
> >> >>>>
> >> >>>> Wouldn't the "core-reset-sysfs-file" be still wired to the end up calling 
> >> >>>> "pci.c:__pci_dev_reset" ?
> >> >>>>
> >> >>>> The problem with that function is that from my testing it seems that the 
> >> >>>> first option "pci_dev_specific_reset" always seems to return succes, so all the
> >> >>>> other options are skipped (flr, pm, slot, bus). However the device it self is 
> >> >>>> not properly reset enough (perhaps the pci_dev_specific_reset is good enough for 
> >> >>>> none virtualization purposes and it's probably the least intrusive. For 
> >> >>>> virtualization however it would be nice to be sure it resets properly, or have a 
> >> >>>> way to force a specific reset routine.)
> >> >> 
> >> >>> Then you need work with the maintainer for those specific devices or
> >> >>> drivers to fix their specific reset function.
> >> >> 
> >> >>> I'm not adding stuff to pciback to workaround broken quirks.
> >> >> 
> >> >> OK that's a pretty clear message there, so if one wants to use pci and vga
> >> >> passthrough one should better use KVM and vfio-pci.
> >> 
> >> > Have you (or anyone else) ever raised the problem with the broken reset
> >> > quirk for certain devices with the relevant maintainer?
> >> 
> >> >> vfio-pci has:
> >> >> - logic to do the try-slot-bus-reset logic
> >> 
> >> > Just because vfio-pci fixed it incorrectly doesn't mean pciback has to
> >> > as well.
> >> 
> >> Depends on what you call an "incorrect fix" .. it fixes a quirk .. 
> >> you can say that's incorrect, but then you would have to remove 50% of
> >> the kernel and Xen code as well.
> >> 
> >> (i do in general agree it's better to strive for a generic solution though,
> >> that's exactly why i brought up that that function doesn't seem to work perfect
> >> for virtualization purposes) 
> >> 
> >> > It makes no sense for both pciback and vfio-pci to workaround problems
> >> > with pci_function_reset() in different ways -- it should be fixed in the
> >> > core PCI code so both can benefit and make use of the same code.
> >> 
> >> Well perhaps Bjorn knows why the order of resets and skipping the rest as
> >> implemented in "pci.c:__pci_dev_reset" was implemented in that way ?
> >> 
> >> Especially what is the expectation about pci_dev_specific_reset doing a proper 
> >> reset for say a vga-card:
> >> - i know it doesn't work on a radeon card (doesn't blank screen, on next guest 
> >>   boot reports it's already posted, powermanagement doesn't work).
> >> - while with a slot/bus reset, that all just works fine, screen blanks 
> >>   immediately and everything else also works.
> >> 
> >> Added Alex as well since he added this workaround for KVM/vfio-pci, perhaps he knows why
> >> he introduced the workaround in vfio-pci instead of trying to fix it in core pci 
> >> code ?
> 
> > I don't know what workaround you're talking about.  As devices are
> > released from the user, vfio-pci attempts to reset them.  If
> > pci_reset_function() returns success we mark the device clean, otherwise
> > it gets marked dirty.  Each time a device is released, if there are
> > dirty devices we test whether we can try a bus/slot reset to clean them.
> > In the case of assigning a GPU this typically means that the GPU or
> > audio function come through first, there's no reset mechanism so it gets
> > marked dirty, the next device comes through and we manage to try a bus
> > reset.  vfio-pci does not have any device specific resets, all
> > functionality is added to the PCI-core, thank-you-very-much.  I even
> > posted a generic PCI quirk patch recently that marks AMD VGA PM reset as
> > bad so that pci_reset_function() won't claim that worked.  All VGA
> > access quirks are done in QEMU, the kernel doesn't have any business in
> > remapping config space over MMIO regions or trapping other config space
> > backdoors.
> 
> Thanks for your insightful reply!
> 
> With "workaround" I was trying to refer to "vfio_pci_try_bus_reset()" which
> implements how to reset the devices, it indeed uses function you introduced in
> pci core code (with a solution for locking issues Konrad also seems to have 
> ran into: 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=61cf16d8bd38c3dc52033ea75d5b1f8368514a17
> 
> David seems to be arguing the whole "vfio_pci_try_bus_reset()" should be not 
> needed and just doing calling "pci_reset_function()" (directly or by
> echo "1" > /sys/bus/pci/devices/BDF/reset shoud always magically do the
> right thing. 
> (Which in my opinion seems the contradict with the mere existence
> of "vfio_pci_try_bus_reset()" (i don't think you would have implemented it 
> when you would have deemed it unnecessary)) 

That truly would be magic because a bus/slot reset and function reset
are completely different beasts.  QEMU, through vfio-pci, makes use of
both.  Take for instance hot-plugging the second port of a dual-port NIC
to a guest, where the first port may be (a) assigned to the same guest,
(b) assigned to a different guest, (c) in-use by the host, or (d)
not-in-use.  For a hotplug I can only make use of a bus/slot reset in
one of those cases (d).  For a cold-plug or VM reset, only two (a,d).  I
don't see how pci_reset_function() can have that sort of visibility to
the ownership and usage of a given device.  vfio-pci doesn't even have
this visibility, which is why the distinction is made in QEMU.  vfio-pci
is just a conduit and gatekeeper to the PCI-core interfaces, for
instance preventing QEMU from doing a reset in the (b) and (c) cases.
What prevents that in the Xen case?  Userspace?

> > I have never heard of problems with the dev specific reset claiming to
> > work and not doing anything, there are only a few of these, it should be
> > easy to debug.
> 
> > I didn't read the original patch, but the title alone of this patch is
> > quite confusing.  FLR is specifically a function-level-reset, so one
> > would expect 'do_flr' to be function specific.  The pci-sysfs 'reset'
> > attribute is already function specific.  If pci_reset_function() isn't
> > doing the job and we need to use bus/slot reset, it's clearly not an
> > FLR.  Thanks,
> > Alex
> 
> The name "do_flr" is coming from the Xen xl toolstack which historically has 
> code that tries to reset devices using a echo "BDF" > /sys/bus/pci/drivers/pciback/do_flr

Redundant to /sys/bus/pci/devices/DDDD:BB:DD.F/reset

> But the name "do_flr" and the debug messages indeed are incorrect (it's not 
> doing a flr nor a D3/PM reset), confusing and should not be used.
> 
> And as you seem to have solved the locking issue for vfio-pci, it is probably 
> possible for xen-pciback to do the same. Instead of letting xen-pciback
> work around the locking problem by deferring to the xl toolstack the resetting
> logic could be kept into xen-pciback it self. 
> That would also mean that the sysfs attribute would be unnecessary and make 
> the naming issue moot.

I would consider the try_*_reset() interfaces to be a workaround for
existing locking issues which are much harder to solve.  It makes the
vfio-pci reset-on-release a best effort approach, which is generally
fine.  For vfio I can't rely on a toolstack, nor maybe should you.
There's always a chance that the VM/user is sent a kill -9 and it's the
kernel's job to protect itself and return things to a quiescent state.
This is why I don't simply have QEMU send a bus reset on shutdown or put
reset policy that can affect other users or the host in userspace.
Thanks,

Alex

