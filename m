Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaE2XAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:00:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34275 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE2XAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:00:23 -0400
Date: Thu, 29 May 2014 17:00:17 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: ddutile@redhat.com, linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pci: Add pci_walk_vbus for walking virtual busses
 associated with SR-IOV
Message-ID: <20140529230017.GB11907@google.com>
References: <20140528222901.18898.48031.stgit@ahduyck-cp2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528222901.18898.48031.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:29:09PM -0700, Alexander Duyck wrote:
> This function provides a simple means for applying a given function to all
> devices on bus and all of it's children, including virtual busses.  To do
> this the function begins by processing all devices on the bus, then it will
> proceed through bus->children and process each of the child busses.

Yeah, I think this makes sense.  I forgot that the pci_bus has a list of
all child buses, and the virtual buses *are* on that list.  It's just that
there's no bridge pci_dev where dev->subordinate is the virtual bus, so if
we iterate over the bus->devices list as pci_walk_bus() does, we won't find
a bridge leading to the virtual bus.

But it seems like we could use pci_walk_vbus() as you implemented it here
for both purposes, i.e., we could just change pci_walk_bus() to work this
way.  Would that break anything?  It'd be nicer to just have one "walk bus"
interface, especially since these differ in a pretty subtle way.

I don't really want to elevate the "virtual bus" idea, i.e., the idea that
we have a bus that is not the secondary bus of a bridge, to a first-class
PCI citizen.  It seems like a wart that I'd like to get rid of if we had a
way to do it.

I'm curious about what Windows does for this situation.  I have a dim
memory that it creates some kind of virtual bridge device leading to a bus
like this.  But I have no reference, and maybe I just made that up.

Bjorn

> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>  drivers/pci/bus.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    2 ++
>  2 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index fb8aed3..769bbcb 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -336,6 +336,50 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>  }
>  EXPORT_SYMBOL_GPL(pci_walk_bus);
>  
> +/** pci_walk_vbus - walk devices on/under bus, calling callback.
> + *  @top      bus whose devices should be walked
> + *  @cb       callback to be called for each device found
> + *  @userdata arbitrary pointer to be passed to callback.
> + *
> + *  Walk the given bus, including any child buses under this bus.
> + *  Call the provided callback on each device found.
> + *
> + *  We check the return of @cb each time. If it returns anything
> + *  other than 0, we break out.
> + *
> + */
> +void pci_walk_vbus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
> +		   void *userdata)
> +{
> +	struct list_head *bus_next;
> +	struct pci_bus *bus;
> +	struct pci_dev *dev;
> +
> +	down_read(&pci_bus_sem);
> +	bus_next = &top->node;
> +	for (;;) {
> +		/* prep bus for next iteration */
> +		bus = list_entry(bus_next, struct pci_bus, node);
> +
> +		/* process each device on this bus */
> +		list_for_each_entry(dev, &bus->devices, bus_list) {
> +			if (cb(dev, userdata))
> +				goto release_semaphore;
> +		}
> +
> +		/* end of this bus, go to child, next bus, or finish */
> +		for (bus_next = bus->children.next;
> +		     bus_next == &bus->children;
> +		     bus_next = bus->node.next, bus = bus->parent) {
> +			if (bus == top)
> +				goto release_semaphore;
> +		}
> +	}
> +release_semaphore:
> +	up_read(&pci_bus_sem);
> +}
> +EXPORT_SYMBOL_GPL(pci_walk_vbus);
> +
>  struct pci_bus *pci_bus_get(struct pci_bus *bus)
>  {
>  	if (bus)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index aab57b4..1fb18a8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1118,6 +1118,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
>  
>  void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>  		  void *userdata);
> +void pci_walk_vbus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
> +		   void *userdata);
>  int pci_cfg_space_size(struct pci_dev *dev);
>  unsigned char pci_bus_max_busnr(struct pci_bus *bus);
>  void pci_setup_bridge(struct pci_bus *bus);
> 
