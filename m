Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3DXVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864Ab3DXVdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:33:49 -0400
Message-ID: <1366839204.2918.726.camel@bling.home>
Subject: Re: [PATCH] pci: Disable slot presence detection around bus reset
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sheng Yang <sheng@linux.intel.com>
Date: Wed, 24 Apr 2013 15:33:24 -0600
In-Reply-To: <1360900439.3248.310.camel@bling.home>
References: <20130214183640.16220.33060.stgit@bling.home>
	 <CAErSpo4uopqKwXY-6HrSZ9mk08tgY9L-iUG2ykmKcMK077tDrQ@mail.gmail.com>
	 <1360900439.3248.310.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 20:53 -0700, Alex Williamson wrote:
> On Thu, 2013-02-14 at 16:47 -0700, Bjorn Helgaas wrote:
> > On Thu, Feb 14, 2013 at 11:37 AM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > > A bus reset can trigger a presence detection change and result in a
> > > suprise hotplug.  This is generally not what we want to happen when
> > > trying to reset a device.  Disable the presence detection control on
> > > on bridges around bus reset.
> > 
> > This is a really interesting situation, and I'm not quite ready to
> > sign up to the idea that this is really a problem and that if it is,
> > this is the way we want to fix it.
> > 
> > What would happen if we *did* handle this as a hotplug event, with a
> > removal followed by an add?
> > 
> > The scheme where pci_reset_function() does "pci_save_state(dev);
> > pci_dev_reset(dev); pci_restore_state(dev);" makes me nervous.
> > 
> > We're saving and restoring some of PCI config space around the reset,
> > but there's no guarantee that we're preserving *all* the important
> > state in config space because I think devices can have non-architected
> > device-specific things in config space that we don't know how to
> > save/restore.
> > 
> > Devices also have internal state not exposed via config space.  That
> > state is lost during the reset but can't be restored by
> > pci_restore_state().  So it seems like pci_reset_function() is
> > pretending to do something it can't really do reliably.
> > 
> > If we make it so a reset is always handled as a remove+add, then we'll
> > use a more generic path, and we'll get all the stuff you expect when
> > initializing a new device -- resource assignment, IRQ setup, quirks,
> > etc.  Quirks in particular seem like something we want, but don't
> > currently get with pci_reset_function().
> > 
> > Oh, and the "disable presence detect" approach below only works for
> > things below a PCIe bridge with native hotplug, right?  I wonder what
> > happens if we reset devices below a bridge using SHPC or acpiphp.
> 
> Triggering a remove+add is not useful for the way we use it today.  The
> users I'm aware of are KVM device assignment and VFIO, where we trigger
> it in an attempt to get the device to a known state so that we have some
> hope of repeatability.  In those scenarios the reset is initiated by the
> driver.  The interface isn't meant to guarantee the device is returned
> to an identical state as it was before reset.  If it did, why would we
> call it?  We want to get to a state as near to power on, but still with
> config programming, as we can.
> 
> Being driver directed, having the reset initiate a remove is pretty near
> the last thing we want.  That limits the scope of calling it to only
> when the driver can readily release the device.  If we have the device
> attached to a guest or userspace driver, that's potentially a lot of
> setup and teardown and effectively extending a surprise removal all the
> way up the stack.
> 
> Obviously a bus reset is a big hammer and we do exhaust all the little
> hammers of flr and pm reset before we try it, but in this case, we know
> the device that's going away and with all likelihood, it's coming right
> back at the same location.  If we take the path of forcing a remove+add,
> let's just remove it from the reset_function call path and we'll do
> without reset for those devices.  Thanks,

Time to revisit this bug.  Clearly when a driver or userspace calls
pci_reset_function the intention is not to have the device be
hot-unplugged and re-plugged.  So I think we either need to prevent that
from happening or politely decline the reset.

I don't really know how to do this on acpiphp or shpc or whatever other
hotplug controllers we support.  So, what if we add a reset_slot
callback to hotplug_slot_ops?  We could then make pci_parent_bus_reset
do something like:

if (dev->slot && dev->slot->hotplug_slot) {
    if (!dev->slot->hotplug_slot->reset_slot)
        return -ENOTTY;

    return dev->slot->hotplug_slot->reset_slot(dev->slot->hotplug_slot);
} else {
    ... standard secondary bus reset...
}

I'd actually also like to add a pci_reset_bus interface because we do
have cases where the pci_reset_function is not sufficient (device
doesn't do any useful reset of it's own and pci_parent_bus_reset won't
because there are other devices on the bus).  Graphics cards in
particular are biting us here.  When all of the devices on the bus are
owned by a driver, this would provide a less device dependent reset.  It
would use same logic and code as enabled with reset_slot.  Thoughts?
Thanks,

Alex

