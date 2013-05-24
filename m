Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3EXNvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:51:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753210Ab3EXNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:51:20 -0400
Date: Fri, 24 May 2013 09:51:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Federico Manzan <f.manzan@gmail.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbfs: Increase arbitrary limit for USB 3 isopkt length
In-Reply-To: <1369385249-15624-1-git-send-email-f.manzan@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305240946410.1238-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013, Federico Manzan wrote:

> Increase the current arbitrary limit for isocronous packet size to a
> value large enough to account for USB 3.0 super bandwidth streams,
> bMaxBurst (0~15 allowed, 1~16 packets)
> bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
> so the size max for one USB 3 isocronous transfer is
> 1024 byte * 16 * 3 = 49152 byte
> 
> Signed-off-by: Federico Manzan <f.manzan@gmail.com>

So you decided to take matters into your own hands.  Good for you!

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index caefc80..7ac137e 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1287,9 +1287,11 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  			goto error;
>  		}
>  		for (totlen = u = 0; u < uurb->number_of_packets; u++) {
> -			/* arbitrary limit,
> -			 * sufficient for USB 2.0 high-bandwidth iso */
> -			if (isopkt[u].length > 8192) {
> +			/* arbitrary limit need for USB 3.0
> +			 * bMaxBurst (0~15 allowed, 1~16 packets)
> +			 * bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
> +			 * sizemax: 1024 * 16 * 3 = 49152*/
> +			if (isopkt[u].length > 65536) {
>  				ret = -EINVAL;
>  				goto error;
>  			}

A couple of suggestions for improvements:

First, new or updated multi-line comments should follow the accepted
formatting standard:

	/*
	 * Start comment here...
	 * and end here.
	 */

Second, it's confusing for the comment to mention that the limit is
49152 and the code to set the limit to 65536.  They should agree on a
single value (probably 49152).

If you make those two changes, you can add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

