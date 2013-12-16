Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3LPOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:39:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34187 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:39:40 -0500
Date: Mon, 16 Dec 2013 09:39:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Subject: Re: [Xen-devel] [RFC PATCH 5/5] xen/pciback: PCI reset slot or bus
Message-ID: <20131216143916.GC12913@phenom.dumpdata.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-6-git-send-email-konrad.wilk@oracle.com>
 <52AEE548.8010800@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AEE548.8010800@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:34:32AM +0000, David Vrabel wrote:
> On 13/12/13 16:09, Konrad Rzeszutek Wilk wrote:
> > The life-cycle of a PCI device in Xen pciback is a bit complex.
> > 
> > It starts with the device being binded to us - for which
> > we do a device function reset.
> > 
> > If the device is unbinded from us - we also do a function
> > reset.
> 
> Spelling: bound and unbound.
> 
> > The reset is done when all of the functions of a device
> > are binded to Xen pciback. Or when a device is un-assigned
> > from a guest. We do this by having a 'completion' workqueue
> > on which the users of the PCI device wait. This workqueue
> > is started once the device has been 'binded' or de-assigned
> > from a guest.
> 
> The use of a work item and a completion baffles me.  What problem does
> this solve?

Avoiding of deadlock. Whenever you do any SysFS operations on on PCI
devices it ends up locking pci_dev and then we try to use it .. and
end up dead-locking. I should have clarified that more.

I could add code to pci (Generic) to have an non-locking variant - but
there is soo much of it I think doing it in a work item and completion
would be much simpler.

> 
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> [...]
> > +	/* We expect X amount of slots (this would also find out
> > +	 * if we do not have all of the slots assigned to us).
> > +	 */
> > +	list_for_each_entry(pci_dev, &dev->bus->devices, bus_list)
> > +		slots++;
> > +
> > +	spin_lock_irqsave(&pcistub_devices_lock, flags);
> > +	/* Iterate over the existing devices to ascertain whether
> > +	 * all of them are under the bridge and not in use. */
> > +	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
> > +		if (!psdev->dev)
> > +			continue;
> > +
> > +		if (pci_domain_nr(psdev->dev->bus) == pci_domain_nr(dev->bus) &&
> > +		    psdev->dev->bus->number == dev->bus->number &&
> > +		    PCI_SLOT(psdev->dev->devfn) == PCI_SLOT(dev->devfn)) {
> > +			slots--;
> > +			/* Ignore ourselves in case hadn't cleaned up yet */
> > +			if (psdev->pdev && psdev->dev != dev)
> > +				inuse++;
> > +		}
> > +	}
> 
> This check looks broken.  A device added to pciback but still bound to
> another driver will be considered as safe to reset.
> 
> I think you want something like:
> 
> list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> {
>     if (pdev != dev && pdev->driver
>         && pdev->driver != xen_pcibk_pci_driver))
>         return -ENOTTY;
> }

Good catch!
> 
> It is safe to reset unbound devices (even if they're not (or intended)
> to be available to pciback).

OK, we can check for that.
> 
> It is also possible in the above loop if slot reset is supported to
> ignore sibling devices that are on different slots.

Not sure what you mean?
> 
> > +	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
> > +	/* Slots should be zero (all slots under the bridge are
> > +	 * accounted for), and inuse should be zero (not assigned
> > +	 * to anybody). */
> > +	if (!slots && !inuse) {
> > +		int rc = 0, bus = 0;
> > +		list_for_each_entry(pci_dev, &dev->bus->devices, bus_list) {
> > +			dev_dbg(&pci_dev->dev, "resetting the slot device\n");
> > +			if (!pci_probe_reset_slot(pci_dev->slot))
> > +				rc = pci_reset_slot(pci_dev->slot);
> > +			else
> > +				bus = 1;
> > +			if (rc)
> > +				dev_info(&pci_dev->dev, "resetting slot failed with %d\n", rc);
> > +		}
> 
> Why are you resetting every slot on the bus?  You only need to reset the
> slot that the device is on.

Bug.
> 
> Take a look at the vfio-pci driver.  It does this bus/slot reset choice
> in a much more straightforward way.
> 
> David
