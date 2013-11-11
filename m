Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3KKUVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:21:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41172 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751222Ab3KKUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:20:57 -0500
Date: Mon, 11 Nov 2013 15:20:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: David Cohen <david.a.cohen@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
In-Reply-To: <xa1t8uwvyyia.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1311111517160.17105-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Michal Nazarewicz wrote:

> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

I think this is still wrong.

> @@ -787,7 +788,14 @@ static ssize_t ffs_epfile_io(struct file *file,
>  
>  	/* Allocate & copy */
>  	if (!halt) {
> -		data = kmalloc(len, GFP_KERNEL);
> +		/*
> +		 * Controller requires buffer size to be aligned to
> +		 * maxpacketsize of an out endpoint.
> +		 */
> +		data_len = read && gadget->quirk_ep_out_aligned_size ?
> +			usb_ep_align_maxpacketsize(ep->ep, len) : len;
> +
> +		data = kmalloc(data_len, GFP_KERNEL);
>  		if (unlikely(!data))
>  			return -ENOMEM;
>  
> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
>  		req->context  = &done;
>  		req->complete = ffs_epfile_io_complete;
>  		req->buf      = data;
> -		req->length   = len;
> +		req->length   = data_len;

IIUC, req->length should still be set to len, not to data_len.

>  
>  		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
>  
> @@ -836,9 +844,16 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			ret = -EINTR;
>  			usb_ep_dequeue(ep->ep, req);
>  		} else {
> +			/*
> +			 * XXX We may end up silently droping data here.
> +			 * Since data_len (i.e. req->length) may be bigger
> +			 * than len (after being rounded up to maxpacketsize),
> +			 * we may end up with more data then user space has
> +			 * space for.
> +			 */

Then this will never come up.  If the host sends a packet that's too 
long, you'll get a -EOVERFLOW error.

>  			ret = ep->status;
>  			if (read && ret > 0 &&
> -			    unlikely(copy_to_user(buf, data, ret)))
> +			    unlikely(copy_to_user(buf, data, min(ret, len))))
>  				ret = -EFAULT;
>  		}
>  	}

The reason for the quirk is that the controller may write all the 
incoming data to the buffer, even if this is more data than the driver 
requested.

Alan Stern

