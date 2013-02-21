Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3BUSse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:48:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43406 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3BUSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:48:33 -0500
Date: Thu, 21 Feb 2013 21:47:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: usbduxsigma.c: fix DMA buffers
 on stack
Message-ID: <20130221184755.GG9138@mwanda>
References: <1361468826-12053-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361468826-12053-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple small style issues.

On Thu, Feb 21, 2013 at 09:47:06AM -0800, Kumar Amit Mehta wrote:
> This patch fixes an instance of DMA buffer on stack(being passed to
> usb_control_msg)for the USB-DUXsigma Board driver. Found using smatch.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/comedi/drivers/usbduxsigma.c |   37 +++++++++++++++++---------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
> index dc6b017..46137e8 100644
> --- a/drivers/staging/comedi/drivers/usbduxsigma.c
> +++ b/drivers/staging/comedi/drivers/usbduxsigma.c
> @@ -681,10 +681,14 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
>  static int usbduxsub_start(struct usbduxsub *usbduxsub)
>  {
>  	int errcode = 0;
> -	uint8_t local_transfer_buffer[16];
> -
> +	uint8_t *local_transfer_buffer;

Put a blank line here between the declaration and the code.

> +	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
> +	if (!local_transfer_buffer) {
> +		errcode = -ENOMEM;
> +		goto exit;

Just return directly.

> +	}
>  	/* 7f92 to zero */
> -	local_transfer_buffer[0] = 0;
> +	*local_transfer_buffer = 0;

The original is sort of nicer.  local_transfer is an array and we're
setting the first element.  It seems more clear to me.  Also I
already had to argue with everyone to get comedi to use arrays
instead of pointer math.  :P

I wonder why we have a 16 byte array when we only use the first
byte and we pass 1 as the length to usb_control_msg().  Odd.
Perhaps it shouldn't be an array after all.

regards,
dan carpenter
>  static int usbduxsub_stop(struct usbduxsub *usbduxsub)
>  {
>  	int errcode = 0;
>  

Delete this blank line...

> -	uint8_t local_transfer_buffer[16];
> +	uint8_t *local_transfer_buffer;
> +	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
> +	if (!local_transfer_buffer) {
> +		errcode = -ENOMEM;
> +		goto exit;
> +	}
>  

regards,
dan carpenter

