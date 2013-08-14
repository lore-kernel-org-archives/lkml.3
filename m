Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab3HNXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408Ab3HNXBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:01:39 -0400
Message-ID: <1376521297.13642.62.camel@ul30vt.home>
Subject: Re: [PATCH] pci: Add probe functions for bus and slot reset
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Aug 2013 17:01:37 -0600
In-Reply-To: <CAErSpo625CTnxZvy-gmy8VzxT4favF4s=_giU6nGey_N=VwK5A@mail.gmail.com>
References: <20130814200549.21626.79779.stgit@bling.home>
	 <CAErSpo625CTnxZvy-gmy8VzxT4favF4s=_giU6nGey_N=VwK5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 14:24 -0600, Bjorn Helgaas wrote:
> On Wed, Aug 14, 2013 at 2:06 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Users of pci_reset_bus() and pci_reset_slot() need a way to probe
> > whether the bus or slot supports reset.  Add trivial helper functions
> > and export them as vfio-pci will make use of these.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >
> > This is logically patch 10/9 for v5 pci: bus and slot reset interfaces.
> > If there's a need to re-spin anything I'll roll this in.
> >
> >  drivers/pci/pci.c   |   24 ++++++++++++++++++++++++
> >  include/linux/pci.h |    2 ++
> >  2 files changed, 26 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index ba68451..888d847 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -3610,6 +3610,18 @@ static int pci_slot_reset(struct pci_slot *slot, int probe)
> >  }
> >
> >  /**
> > + * pci_probe_reset_slot - probe whether a PCI slot can be reset
> > + * @slot: PCI slot to probe
> > + *
> > + * Return 0 if slot can be reset, negative if a slot reset is not supported.
> 
> Remind me again why we need all the "probe" stuff.  That really
> uglifies the code and the locking.  I think I worked through it once,
> but regrettably, I didn't add any explanation and I've forgotten.

I'm not sure what insight I can provide.  We use
pci_probe_reset_function() to determine whether to create a reset entry
in pci-sysfs.  I obviously feel like I have a legitimate need for them
here to add them and make use of them in my code.

> I assume all the return values are immutable, i.e., they won't change
> because of hotplug events on the slot or the bus, right?

The only way I can think of that these would change is if you had a
hotplug driver enabling slot reset that is then unloaded or detached
from the controller requiring us to switch to a bus reset.  Otherwise
it's topology based.  Note that I don't actually expose which is used to
the user, I just give them a list of groups and devices and if it
changes between when they ask and when they try to do a reset, then they
have to ask again.

BTW, note that pci_reset_function is not immutable and we seem to deal
with it pretty well.  If we have a device with no function-based reset
capability we allow pci_reset_function to perform a secondary bus reset.
If another device was hot added to the bus, we'd no longer allow it.
AFAIK, nobody has ever encountered this and cared.

> Why do you need probe functions for slot and bus reset, but not for
> function reset?

There's already a pci_probe_reset_function() ;) Interestingly, that's
the one I don't need for vfio-pci because I want to reset a device when
a user opens it anyway, so I just call pci_reset_function() and check
the result.  With bus and slot reset there are likely more devices
affected (we can use pci_reset_function() if there's only a single
device on the bus).  I need to be able to tell the user the set of
devices affected, so I need to know whether to look at the bus or the
slot in case there's a difference.  Thanks,

Alex

> > + */
> > +int pci_probe_reset_slot(struct pci_slot *slot)
> > +{
> > +       return pci_slot_reset(slot, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(pci_probe_reset_slot);
> > +
> > +/**
> >   * pci_reset_slot - reset a PCI slot
> >   * @slot: PCI slot to reset
> >   *
> > @@ -3662,6 +3674,18 @@ static int pci_bus_reset(struct pci_bus *bus, int probe)
> >  }
> >
> >  /**
> > + * pci_probe_reset_bus - probe whether a PCI bus can be reset
> > + * @bus: PCI bus to probe
> > + *
> > + * Return 0 if bus can be reset, negative if a bus reset is not supported.
> > + */
> > +int pci_probe_reset_bus(struct pci_bus *bus)
> > +{
> > +       return pci_bus_reset(bus, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(pci_probe_reset_bus);
> > +
> > +/**
> >   * pci_reset_bus - reset a PCI bus
> >   * @bus: top level PCI bus to reset
> >   *
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 1a8fd34..daf40cd 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -924,7 +924,9 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
> >  int __pci_reset_function(struct pci_dev *dev);
> >  int __pci_reset_function_locked(struct pci_dev *dev);
> >  int pci_reset_function(struct pci_dev *dev);
> > +int pci_probe_reset_slot(struct pci_slot *slot);
> >  int pci_reset_slot(struct pci_slot *slot);
> > +int pci_probe_reset_bus(struct pci_bus *bus);
> >  int pci_reset_bus(struct pci_bus *bus);
> >  void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
> >  void pci_update_resource(struct pci_dev *dev, int resno);
> >



