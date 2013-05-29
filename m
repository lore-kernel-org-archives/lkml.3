Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935352Ab3E2WZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:25:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:52371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935317Ab3E2WZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="321574654"
Date: Wed, 29 May 2013 15:25:00 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename ambiguous named XHCI_NEC_HOST to
 XHCI_NEC_SHOW_FW
Message-ID: <20130529222500.GC7151@xanatos>
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, May 29, 2013 at 11:14:32PM +0200, Alexander Holler wrote:
> Current Renesas Electronics XHCI hosts (which were formerly NEC)
> do support the same vendor command to show the firmware. Rename the
> ambigious named define XHCI_NEC_HOST to XHCI_NEC_SHOW_FW because it's
> only used to display the firmware version. Besides that, change the
> output "... NEC firmware version x.y" to "... firmware version x.y"
> to not confuse owners of Renesas USB hosts.
> 
> (so only cosmetic, no functional changes)

I'm actually inclined to say you should just rip out the firmware
version code entirely.  I haven't needed to use it for years, and if
Renesas changed their vendor command set, I would rather not submit
random commands to the host.

So, can you redo this patch to just rip out XHCI_NEC_HOST and everything
that uses it?

Sarah Sharp

> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  drivers/usb/host/xhci-pci.c  | 2 +-
>  drivers/usb/host/xhci-ring.c | 6 +++---
>  drivers/usb/host/xhci.c      | 4 ++--
>  drivers/usb/host/xhci.h      | 2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 1a30c38..f47d3d2 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -79,7 +79,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>  	}
>  
>  	if (pdev->vendor == PCI_VENDOR_ID_NEC)
> -		xhci->quirks |= XHCI_NEC_HOST;
> +		xhci->quirks |= XHCI_NEC_SHOW_FW;
>  
>  	if (pdev->vendor == PCI_VENDOR_ID_AMD && xhci->hci_version == 0x96)
>  		xhci->quirks |= XHCI_AMD_0x96_HOST;
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 1969c00..761d566 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1489,11 +1489,11 @@ bandwidth_change:
>  					"for disabled slot %u\n", slot_id);
>  		break;
>  	case TRB_TYPE(TRB_NEC_GET_FW):
> -		if (!(xhci->quirks & XHCI_NEC_HOST)) {
> +		if (!(xhci->quirks & XHCI_NEC_SHOW_FW)) {
>  			xhci->error_bitmask |= 1 << 6;
>  			break;
>  		}
> -		xhci_dbg(xhci, "NEC firmware version %2x.%02x\n",
> +		xhci_dbg(xhci, "firmware version %2x.%02x\n",
>  			 NEC_FW_MAJOR(le32_to_cpu(event->status)),
>  			 NEC_FW_MINOR(le32_to_cpu(event->status)));
>  		break;
> @@ -1512,7 +1512,7 @@ static void handle_vendor_event(struct xhci_hcd *xhci,
>  
>  	trb_type = TRB_FIELD_TO_TYPE(le32_to_cpu(event->generic.field[3]));
>  	xhci_dbg(xhci, "Vendor specific event TRB type = %u\n", trb_type);
> -	if (trb_type == TRB_NEC_CMD_COMP && (xhci->quirks & XHCI_NEC_HOST))
> +	if (trb_type == TRB_NEC_CMD_COMP && (xhci->quirks & XHCI_NEC_SHOW_FW))
>  		handle_cmd_completion(xhci, &event->event_cmd);
>  }
>  
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index b4aa79d..b961e9a 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -588,7 +588,7 @@ static int xhci_run_finished(struct xhci_hcd *xhci)
>  	xhci->shared_hcd->state = HC_STATE_RUNNING;
>  	xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
>  
> -	if (xhci->quirks & XHCI_NEC_HOST)
> +	if (xhci->quirks & XHCI_NEC_SHOW_FW)
>  		xhci_ring_cmd_db(xhci);
>  
>  	xhci_dbg(xhci, "Finished xhci_run for USB3 roothub\n");
> @@ -673,7 +673,7 @@ int xhci_run(struct usb_hcd *hcd)
>  			&xhci->ir_set->irq_pending);
>  	xhci_print_ir_set(xhci, 0);
>  
> -	if (xhci->quirks & XHCI_NEC_HOST)
> +	if (xhci->quirks & XHCI_NEC_SHOW_FW)
>  		xhci_queue_vendor_command(xhci, 0, 0, 0,
>  				TRB_TYPE(TRB_NEC_GET_FW));
>  
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 29c978e..e483f12 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1493,7 +1493,7 @@ struct xhci_hcd {
>  	unsigned int		quirks;
>  #define	XHCI_LINK_TRB_QUIRK	(1 << 0)
>  #define XHCI_RESET_EP_QUIRK	(1 << 1)
> -#define XHCI_NEC_HOST		(1 << 2)
> +#define XHCI_NEC_SHOW_FW	(1 << 2)
>  #define XHCI_AMD_PLL_FIX	(1 << 3)
>  #define XHCI_SPURIOUS_SUCCESS	(1 << 4)
>  /*
> -- 
> 1.8.1.5
> 
