Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3HSUUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab3HSUUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:20:38 -0400
Message-ID: <1376943632.2657.25.camel@ul30vt.home>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 19 Aug 2013 14:20:32 -0600
In-Reply-To: <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
	 <1376937682.2657.15.camel@ul30vt.home>
	 <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 14:02 -0600, Bjorn Helgaas wrote:
> On Mon, Aug 19, 2013 at 12:41 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Wed, 2013-08-14 at 17:06 -0600, Alex Williamson wrote:
> >> On Wed, 2013-08-14 at 16:42 -0600, Bjorn Helgaas wrote:
> >> > On Wed, Aug 14, 2013 at 2:10 PM, Alex Williamson
> >> > <alex.williamson@redhat.com> wrote:
> 
> >> > > +static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
> >> > > +                                        int (*fn)(struct pci_dev *,
> >> > > +                                                  void *data), void *data,
> >> > > +                                        bool slot)
> >> > > +{
> >> > > +       struct pci_dev *tmp;
> >> > > +       int ret = 0;
> >> > > +
> >> > > +       list_for_each_entry(tmp, &pdev->bus->devices, bus_list) {
> >> > > +               if (slot && tmp->slot != pdev->slot)
> >> > > +                       continue;
> >> > > +
> >> > > +               ret = fn(tmp, data);
> >> > > +               if (ret)
> >> > > +                       break;
> >> > > +
> >> > > +               if (tmp->subordinate) {
> >> > > +                       ret = vfio_pci_for_each_slot_or_bus(tmp, fn,
> >> > > +                                                           data, false);
> >> > > +                       if (ret)
> >> > > +                               break;
> >> > > +               }
> >> > > +       }
> >> > > +
> >> > > +       return ret;
> >> > > +}
> >> >
> >> > vfio_pci_for_each_slot_or_bus() isn't really vfio-specific, is it?
> >>
> >> It's not, I originally has callbacks split out as PCI patches but I was
> >> able to simplify some things in the code by customizing it to my usage,
> >> so I left it here.
> >>
> >> > I mean, traversing the PCI hierarchy doesn't require vfio knowledge.  I
> >> > think this loop (walking the bus->devices list) skips devices on
> >> > "virtual buses" that may be added for SR-IOV.  I'm not sure that
> >> > pci_walk_bus() handles that correctly either, but at least if you used
> >> > that, we could fix the problem in one place.
> >>
> >> I didn't know about pci_walk_bus(), I'll look into switching to it.
> >
> > It looks like pci_walk_bus() is a poor replacement for when dealing with
> > slots.  There might be multiple slots on a bus or a mix of slots and
> > non-slots, so for each device pci_walk_bus() finds on a subordinate bus
> > I'd need to walk up the tree to find the parent bridge on the original
> > bus to figure out if it's in the same slot.
> 
> Do you really care about that scenario?  PCIe only supports a single
> slot per bus, as far as I know.

I believe that's true for pciehp, but I can easily imagine that it's not
the case for other hotplug controllers.  I don't run into this scenario
on any of my hardware, but I also don't want to embed any pciehp
assumptions either.  So I care for the sake of completeness, but I'm not
targeting specific hardware that needs this.

> > Should we have a pci_walk_slot() function?
> 
> I guess.  And supply the pci_slot rather than the pci_dev?  I'm a
> little bit worried because the idea of a "slot" is not well-defined in
> the spec, and we have sort of an ad hoc method of discovering and
> managing them, e.g., acpiphp and pciehp might discover the same slot.
> But I guess that's no reason to bury generic code in vfio.

I try to handle the slot as opaque, only caring that the slot pointer
matches, so I think our implementation is ok... so long as we only get
one driver claiming to manage a slot, but that's not a vfio problem ;)
Thanks,

Alex

