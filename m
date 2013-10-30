Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3J3Rf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:35:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753441Ab3J3Rf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:35:57 -0400
Date: Wed, 30 Oct 2013 13:35:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 2/3] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
In-Reply-To: <1383152778-30739-3-git-send-email-david.a.cohen@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1310301331580.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, David Cohen wrote:

> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint. ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/gadget/f_fs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 75e4b78..b49dd55 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -755,10 +755,12 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			     char __user *buf, size_t len, int read)
>  {
>  	struct ffs_epfile *epfile = file->private_data;
> +	struct usb_gadget *gadget = epfile->ffs->gadget;
>  	struct ffs_ep *ep;
>  	char *data = NULL;
>  	ssize_t ret;
>  	int halt;
> +	size_t orig_len = len;
>  
>  	goto first_try;
>  	do {
> @@ -794,6 +796,21 @@ first_try:
>  			goto error;
>  		}
>  
> +		/*
> +		 * Controller requires buffer size to be aligned to
> +		 * maxpacketsize of an out endpoint.
> +		 */
> +		if (gadget->quirk_ep_out_aligned_size && read &&
> +		    !IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize)) {

IS_ALIGNED works only when the second argument is a power of 2.  

Interrupt endpoints are not required to have maxpacket sizes that are 
powers of 2.  Does this code ever get used for an interrupt endpoint?

> +			size_t old_len = len;

Why add old_len here when you added orig_len above?

> +			len = roundup(orig_len,
> +				      (size_t)ep->ep->desc->wMaxPacketSize);
> +			if (unlikely(data) && len > old_len) {

If the original value wasn't aligned, how can len fail to be > old_len?

> +				kfree(data);
> +				data = NULL;
> +			}
> +		}
> +
>  		/* Allocate & copy */
>  		if (!halt && !data) {
>  			data = kzalloc(len, GFP_KERNEL);

Alan Stern

