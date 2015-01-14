Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbbANQwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:52:19 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:39076 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbANQwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:52:14 -0500
Date: Wed, 14 Jan 2015 09:52:04 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 02/10] PCI, x86: clip firmware assigned resource under
 parent bridge's
Message-ID: <20150114165204.GA19925@google.com>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
 <1421090600-9750-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421090600-9750-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:23:12AM -0800, Yinghai Lu wrote:
> Some bios put range that is not fully coverred by root bus resources.
> Try to clip them and update them in pci bridge bars.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
> Reported-by: Marek Kordik <kordikmarek@gmail.com>
> Tested-by: Marek Kordik <kordikmarek@gmail.com>
> Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/i386.c | 74 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 9b18ef3..d43e1af 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -205,10 +205,11 @@ EXPORT_SYMBOL(pcibios_align_resource);
>   *	    as well.
>   */
>  
> -static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
> +static bool pcibios_allocate_bridge_resources(struct pci_dev *dev)
>  {
>  	int idx;
>  	struct resource *r;
> +	bool changed = false;
>  
>  	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
>  		r = &dev->resource[idx];
> @@ -216,17 +217,33 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
>  			continue;
>  		if (r->parent)	/* Already allocated */
>  			continue;
> -		if (!r->start || pci_claim_resource(dev, idx) < 0) {
> -			/*
> -			 * Something is wrong with the region.
> -			 * Invalidate the resource to prevent
> -			 * child resource allocations in this
> -			 * range.
> -			 */
> -			r->start = r->end = 0;
> -			r->flags = 0;
> +
> +		if (!r->start)
> +			goto clear;
> +
> +		if (pci_claim_resource(dev, idx) >= 0)
> +			continue;
> +
> +		/* try again after clip for pci bridge*/
> +		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
> +		    pci_bus_clip_resource(dev, r)) {
> +			changed = true;
> +			if (pci_claim_resource(dev, idx) >= 0)
> +				continue;
>  		}
> +
> +clear:
> +		/*
> +		 * Something is wrong with the region.
> +		 * Invalidate the resource to prevent
> +		 * child resource allocations in this
> +		 * range.
> +		 */
> +		r->start = r->end = 0;
> +		r->flags = 0;
>  	}
> +
> +	return changed;

There's a lot of duplicated code in these patches.  Is it possible to
factor this out a bit, e.g., something like this?

  int pci_claim_bridge_resource(struct pci_dev *dev, int i)
  {
    if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
      return 0;

    if (pci_claim_resource(dev, i) == 0)
      return 0;		/* claimed the window */

    if (!pci_bus_clip_resource(dev, i))
      return -EINVAL;	/* clipping didn't change anything */

    if (dev->subordinate)
      pci_setup_bridge(dev->subordinate);
    if (pci_claim_resource(dev, i) == 0)
      return 0;		/* claimed a smaller window */

    return -EINVAL;
  }

>  }
>  
>  static void pcibios_allocate_bus_resources(struct pci_bus *bus)
> @@ -234,8 +251,12 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
>  	struct pci_bus *child;
>  
>  	/* Depth-First Search on bus tree */
> -	if (bus->self)
> -		pcibios_allocate_bridge_resources(bus->self);
> +	if (bus->self) {
> +		bool changed = pcibios_allocate_bridge_resources(bus->self);
> +
> +		if (changed)
> +			pci_setup_bridge(bus);
> +	}
>  	list_for_each_entry(child, &bus->children, node)
>  		pcibios_allocate_bus_resources(child);
>  }
> @@ -274,18 +295,27 @@ static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
>  				dev_dbg(&dev->dev,
>  					"BAR %d: reserving %pr (d=%d, p=%d)\n",
>  					idx, r, disabled, pass);
> -				if (pci_claim_resource(dev, idx) < 0) {
> -					if (r->flags & IORESOURCE_PCI_FIXED) {
> -						dev_info(&dev->dev, "BAR %d %pR is immovable\n",
> +
> +				if (pci_claim_resource(dev, idx) >= 0)
> +					continue;
> +
> +				if (r->flags & IORESOURCE_PCI_FIXED) {
> +					dev_info(&dev->dev, "BAR %d %pR is immovable\n",
>  							 idx, r);
> -					} else {
> -						/* We'll assign a new address later */
> -						pcibios_save_fw_addr(dev,
> -								idx, r->start);
> -						r->end -= r->start;
> -						r->start = 0;
> -					}
> +					continue;
> +				}
> +
> +				/* try again with clip */
> +				if (pci_bus_clip_resource(dev, r)) {
> +					pci_update_resource(dev, idx);
> +					if (pci_claim_resource(dev, idx) >= 0)
> +						continue;

This hunk doesn't make sense to me.  This only deals with standard BARs and
IOV BARS.  It doesn't deal with bridge windows at all.  The sizes of these
BARs and IOV BARs are fixed and there's no point in trying to clip them
because we can't tell the hardware that the BAR is now smaller.

It's different for bridge windows because we can adjust their size.

Bjorn

>  				}
> +
> +				/* We'll assign a new address later */
> +				pcibios_save_fw_addr(dev, idx, r->start);
> +				r->end -= r->start;
> +				r->start = 0;
>  			}
>  		}
>  	if (!pass) {
> -- 
> 1.8.4.5
> 
