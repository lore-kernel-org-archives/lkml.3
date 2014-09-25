Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaIYPAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:00:39 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49974 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaIYPAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:00:38 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 25 Sep 2014 16:58:03 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v3 2/3] mfd: viperboard: switch to devm_ allocation
Message-ID: <20140925145803.GG32124@localhost>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
 <1411656197-26517-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411656197-26517-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:43:16PM +0300, Octavian Purdila wrote:
> Switch to using devm_ allocation to simplify the error path. Also
> remove a redundant OOM error message.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/mfd/viperboard.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index 5f62f4e..57fac1d 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -53,18 +53,16 @@ static int vprbrd_probe(struct usb_interface *interface,
>  			      const struct usb_device_id *id)
>  {
>  	struct vprbrd *vb;
> -

Don't include random whitespace changes in your patches.

>  	u16 version = 0;
>  	int pipe, ret;
>  
>  	/* allocate memory for our device state and initialize it */
> -	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
> -	if (vb == NULL) {
> -		dev_err(&interface->dev, "Out of memory\n");
> +	vb = devm_kzalloc(&interface->dev, sizeof(*vb), GFP_KERNEL);
> +	if (vb == NULL)
>  		return -ENOMEM;
> -	}
>  
> -	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
> +	vb->buf = devm_kzalloc(&interface->dev,
> +			       sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
>  	if (vb->buf == NULL) {
>  		ret = -ENOMEM;
>  		goto error;

You should just return -ENOMEM here.

> @@ -109,11 +107,7 @@ static int vprbrd_probe(struct usb_interface *interface,
>  	return 0;
>  
>  error:
> -	if (vb) {
> -		usb_put_dev(vb->usb_dev);
> -		kfree(vb->buf);
> -		kfree(vb);
> -	}
> +	usb_put_dev(vb->usb_dev);
>  
>  	return ret;
>  }
> @@ -125,8 +119,6 @@ static void vprbrd_disconnect(struct usb_interface *interface)
>  	mfd_remove_devices(&interface->dev);
>  	usb_set_intfdata(interface, NULL);
>  	usb_put_dev(vb->usb_dev);
> -	kfree(vb->buf);
> -	kfree(vb);
>  
>  	dev_dbg(&interface->dev, "disconnected\n");
>  }

Johan
