Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaEDOHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaEDOHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:07:09 -0400
Message-ID: <1399212446.4302.13.camel@localhost.localdomain>
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
From: Marcel Apfelbaum <marcel.a@redhat.com>
To: Ronen Hod <rhod@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, mst@redhat.com
Date: Sun, 04 May 2014 17:07:26 +0300
In-Reply-To: <5366451E.1050800@redhat.com>
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
	 <5366451E.1050800@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-04 at 16:48 +0300, Ronen Hod wrote:
> On 05/01/2014 05:35 PM, Marcel Apfelbaum wrote:
> > When a board is added, the shpchp driver checks if there
> > is a mismatch between the bridge's adapter and the bus speed.
> > If there is, it sets the subordinate speed (if there is no device on it).
> 
> Since the speed is irrelevant when running in a VM, I suggest that
> you either ignore it altogether, or "normalize" the speed of all the
> devices/bridges/buses in QEMU in order to avoid any conflicts
> in the first place.
Before this patch, this would not help since the primary bus speed
is not even set by the kernel.

After this patch, normalizing the QEMU device/bus/... speed may help
avoiding future conflicts, but we should discuss it in qemu mailing list :).

Ignoring emulated/para-virt device's speed when running in a VM it is\
a good question, but I don't know if such a distinction would be feasible.

Any thoughts would be appreciated,
Thanks,
Marcel

> 
> Thanks, Ronen.
> 
> >
> > However, it takes the reference of the board speed from the primary bus
> > and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
> > its speed is not updated and remains 0xff. As a result hotplug fails
> > with error: "Speed of bus ff and adapter 0 mismatch".
> >
> > Fixed that by checking the speed against the subordinate bus.
> >
> > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> > index 5849927..6efc2ec 100644
> > --- a/drivers/pci/hotplug/shpchp_ctrl.c
> > +++ b/drivers/pci/hotplug/shpchp_ctrl.c
> > @@ -282,8 +282,8 @@ static int board_added(struct slot *p_slot)
> >   		return WRONG_BUS_FREQUENCY;
> >   	}
> >   
> > -	bsp = ctrl->pci_dev->bus->cur_bus_speed;
> > -	msp = ctrl->pci_dev->bus->max_bus_speed;
> > +	bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
> > +	msp = ctrl->pci_dev->subordinate->max_bus_speed;
> >   
> >   	/* Check if there are other slots or devices on the same bus */
> >   	if (!list_empty(&ctrl->pci_dev->subordinate->devices))
> 



