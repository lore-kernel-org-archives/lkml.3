Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbaD3XEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:04:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:45339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759651AbaD3XEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,961,1389772800"; 
   d="scan'208";a="504015564"
Date: Wed, 30 Apr 2014 16:04:24 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
Message-ID: <20140430230424.GA5880@xanatos>
References: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
 <Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
 <CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
 <535FDE71.7000601@linux.intel.com>
 <CAODwPW_wpG3Xupfgfzi4LeYukL6qOFNkK=Zg9Ks7sjRA5y450A@mail.gmail.com>
 <1398793097-2805-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398793097-2805-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

I tested both this patch and your global command queue patches on top of
your for-usb-linus branch.  After reverting commit 400362f1d8dc "ALSA:
usb-audio: Resume mixer values properly", I was able to get my USB
webcam working. [1]

I wrote a small shell script (attached) to start and kill guvcview over
and over, so that I could test the xHCI driver issuing Configure
Endpoint commands, and proceeded to plug and unplug a VIA USB 3.0 hub in
over and over again.  I got occasional descriptor fetch errors and once
saw a Set Address timeout, and everything seemed to work as expected.

In short, I think it's fine to merge Julius' patch to usb-linus and your
command queue patches to usb-next.

Sarah Sharp

[1] https://lkml.org/lkml/2014/4/19/117

On Tue, Apr 29, 2014 at 10:38:17AM -0700, Julius Werner wrote:
> The current XHCI driver recalculates the Context Entries field in the
> Slot Context on every add_endpoint() and drop_endpoint() call. In the
> case of drop_endpoint(), it seems to assume that the add_flags will
> always contain every endpoint for the new configuration, which is not
> necessarily correct if you don't make assumptions about how the USB core
> uses the add_endpoint/drop_endpoint interface (add_flags only contains
> endpoints that are new additions in the new configuration).
> 
> Furthermore, EP0_FLAG is not consistently set in add_flags throughout
> the lifetime of a device. This means that when all endpoints are
> dropped, the Context Entries field can be set to 0 (which is invalid and
> may cause a Parameter Error) or -1 (which is interpreted as 31 and
> causes the driver to keep using the old, incorrect value).
> 
> The only surefire way to set this field right is to also take all
> existing endpoints into account, and to force the value to 1 (meaning
> only EP0 is active) if no other endpoint is found. This patch implements
> that as a single step in the final check_bandwidth() call and removes
> the intermediary calculations from add_endpoint() and drop_endpoint().
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci.c | 51 +++++++++++++++++--------------------------------
>  1 file changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 924a6cc..fec6423 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1562,12 +1562,10 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
>  	struct xhci_hcd *xhci;
>  	struct xhci_container_ctx *in_ctx, *out_ctx;
>  	struct xhci_input_control_ctx *ctrl_ctx;
> -	struct xhci_slot_ctx *slot_ctx;
> -	unsigned int last_ctx;
>  	unsigned int ep_index;
>  	struct xhci_ep_ctx *ep_ctx;
>  	u32 drop_flag;
> -	u32 new_add_flags, new_drop_flags, new_slot_info;
> +	u32 new_add_flags, new_drop_flags;
>  	int ret;
>  
>  	ret = xhci_check_args(hcd, udev, ep, 1, true, __func__);
> @@ -1614,24 +1612,13 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
>  	ctrl_ctx->add_flags &= cpu_to_le32(~drop_flag);
>  	new_add_flags = le32_to_cpu(ctrl_ctx->add_flags);
>  
> -	last_ctx = xhci_last_valid_endpoint(le32_to_cpu(ctrl_ctx->add_flags));
> -	slot_ctx = xhci_get_slot_ctx(xhci, in_ctx);
> -	/* Update the last valid endpoint context, if we deleted the last one */
> -	if ((le32_to_cpu(slot_ctx->dev_info) & LAST_CTX_MASK) >
> -	    LAST_CTX(last_ctx)) {
> -		slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
> -		slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(last_ctx));
> -	}
> -	new_slot_info = le32_to_cpu(slot_ctx->dev_info);
> -
>  	xhci_endpoint_zero(xhci, xhci->devs[udev->slot_id], ep);
>  
> -	xhci_dbg(xhci, "drop ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
> +	xhci_dbg(xhci, "drop ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
>  			(unsigned int) ep->desc.bEndpointAddress,
>  			udev->slot_id,
>  			(unsigned int) new_drop_flags,
> -			(unsigned int) new_add_flags,
> -			(unsigned int) new_slot_info);
> +			(unsigned int) new_add_flags);
>  	return 0;
>  }
>  
> @@ -1654,11 +1641,9 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
>  	struct xhci_hcd *xhci;
>  	struct xhci_container_ctx *in_ctx, *out_ctx;
>  	unsigned int ep_index;
> -	struct xhci_slot_ctx *slot_ctx;
>  	struct xhci_input_control_ctx *ctrl_ctx;
>  	u32 added_ctxs;
> -	unsigned int last_ctx;
> -	u32 new_add_flags, new_drop_flags, new_slot_info;
> +	u32 new_add_flags, new_drop_flags;
>  	struct xhci_virt_device *virt_dev;
>  	int ret = 0;
>  
> @@ -1673,7 +1658,6 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
>  		return -ENODEV;
>  
>  	added_ctxs = xhci_get_endpoint_flag(&ep->desc);
> -	last_ctx = xhci_last_valid_endpoint(added_ctxs);
>  	if (added_ctxs == SLOT_FLAG || added_ctxs == EP0_FLAG) {
>  		/* FIXME when we have to issue an evaluate endpoint command to
>  		 * deal with ep0 max packet size changing once we get the
> @@ -1739,24 +1723,14 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
>  	 */
>  	new_drop_flags = le32_to_cpu(ctrl_ctx->drop_flags);
>  
> -	slot_ctx = xhci_get_slot_ctx(xhci, in_ctx);
> -	/* Update the last valid endpoint context, if we just added one past */
> -	if ((le32_to_cpu(slot_ctx->dev_info) & LAST_CTX_MASK) <
> -	    LAST_CTX(last_ctx)) {
> -		slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
> -		slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(last_ctx));
> -	}
> -	new_slot_info = le32_to_cpu(slot_ctx->dev_info);
> -
>  	/* Store the usb_device pointer for later use */
>  	ep->hcpriv = udev;
>  
> -	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
> +	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
>  			(unsigned int) ep->desc.bEndpointAddress,
>  			udev->slot_id,
>  			(unsigned int) new_drop_flags,
> -			(unsigned int) new_add_flags,
> -			(unsigned int) new_slot_info);
> +			(unsigned int) new_add_flags);
>  	return 0;
>  }
>  
> @@ -2723,8 +2697,19 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  			ctrl_ctx->drop_flags == 0)
>  		return 0;
>  
> -	xhci_dbg(xhci, "New Input Control Context:\n");
> +	/* Fix up Context Entries field. Minimum value is EP0 == BIT(1). */
>  	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
> +	for (i = 31; i >= 1; i--) {
> +		__le32 le32 = cpu_to_le32(BIT(i));
> +		if ((virt_dev->eps[i-1].ring && !(ctrl_ctx->drop_flags & le32))
> +				|| (ctrl_ctx->add_flags & le32) || i == 1) {
> +			slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
> +			slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(i));
> +			break;
> +		}
> +	}
> +
> +	xhci_dbg(xhci, "New Input Control Context:\n");
>  	xhci_dbg_ctx(xhci, virt_dev->in_ctx,
>  		     LAST_CTX_TO_EP_NUM(le32_to_cpu(slot_ctx->dev_info)));
>  
> -- 
> 1.8.3.2
> 
