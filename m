Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab3BVS6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:58:39 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:42906 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132Ab3BVS6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:58:37 -0500
Message-ID: <5127BFDB.4010608@bfs.de>
Date: Fri, 22 Feb 2013 19:58:35 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Kumar Amit Mehta <gmate.amit@gmail.com>
CC: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: drivers: usbduxfast.c: fix for DMA
 buffers on stack
References: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com>
In-Reply-To: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 22.02.2013 19:07, schrieb Kumar Amit Mehta:
> fix for instances of DMA buffer on stack(being passed to usb_control_msg) for
> the USB-DUXfast Board driver.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/comedi/drivers/usbduxfast.c |   30 ++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
> index 4bf5dd0..1ba0e3d 100644
> --- a/drivers/staging/comedi/drivers/usbduxfast.c
> +++ b/drivers/staging/comedi/drivers/usbduxfast.c
> @@ -436,10 +436,14 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
>  static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
>  {
>  	int ret;
> -	unsigned char local_transfer_buffer[16];
> +	unsigned char *local_transfer_buffer;
> +
> +	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
> +	if (!local_transfer_buffer)
> +		return -ENOMEM;
>  
>  	/* 7f92 to zero */
> -	local_transfer_buffer[0] = 0;
> +	*local_transfer_buffer = 0;
>  	/* bRequest, "Firmware" */
>  	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
>  			      USBDUXFASTSUB_FIRMWARE,
> @@ -450,22 +454,25 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
>  			      local_transfer_buffer,
>  			      1,      /* Length */
>  			      EZTIMEOUT);    /* Timeout */
> -	if (ret < 0) {
> +	if (ret < 0)
>  		dev_err(&udfs->interface->dev,
>  			"control msg failed (start)\n");
> -		return ret;
> -	}
>  
> -	return 0;
> +	kfree(local_transfer_buffer);
> +	return ret;
>  }
>  
>  static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
>  {
>  	int ret;
> -	unsigned char local_transfer_buffer[16];
> +	unsigned char *local_transfer_buffer;
> +
> +	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
> +	if (!local_transfer_buffer)
> +		return -ENOMEM;
>  
>  	/* 7f92 to one */
> -	local_transfer_buffer[0] = 1;
> +	*local_transfer_buffer = 1;
>  	/* bRequest, "Firmware" */
>  	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
>  			      USBDUXFASTSUB_FIRMWARE,
> @@ -474,13 +481,12 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
>  			      0x0000,	/* Index */
>  			      local_transfer_buffer, 1,	/* Length */
>  			      EZTIMEOUT);	/* Timeout */
> -	if (ret < 0) {
> +	if (ret < 0)
>  		dev_err(&udfs->interface->dev,
>  			"control msg failed (stop)\n");
> -		return ret;
> -	}
>  
> -	return 0;
> +	kfree(local_transfer_buffer);
> +	return ret;
>  }
>  
>  static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,

mmh, it seems a bit overheat to alloc 1 byte.
Could one of the driver maintainers please comment
is that realy need ? or is it possible to pass one byte
in a register ? (aka char/int) without allocating ?

re,
 wh
