Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaIYPzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:55:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56823 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaIYPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:55:44 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 25 Sep 2014 17:53:10 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v4 2/3] mfd: viperboard: switch to devm_ allocation
Message-ID: <20140925155310.GK32124@localhost>
References: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
 <1411659697-27258-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411659697-27258-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:41:36PM +0300, Octavian Purdila wrote:
> Switch to using devm_ allocation to simplify the error path. Also
> remove a redundant OOM error message.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Reviewed-by: Johan Hovold <johan@kernel.org>

> ---
>  drivers/mfd/viperboard.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index 5f62f4e..0d46d05 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -58,17 +58,14 @@ static int vprbrd_probe(struct usb_interface *interface,
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
> -	if (vb->buf == NULL) {
> -		ret = -ENOMEM;
> -		goto error;
> -	}
> +	vb->buf = devm_kzalloc(&interface->dev,
> +			       sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
> +	if (vb->buf == NULL)
> +		return -ENOMEM;
>  
>  	mutex_init(&vb->lock);
>  
> @@ -109,11 +106,7 @@ static int vprbrd_probe(struct usb_interface *interface,
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
> @@ -125,8 +118,6 @@ static void vprbrd_disconnect(struct usb_interface *interface)
>  	mfd_remove_devices(&interface->dev);
>  	usb_set_intfdata(interface, NULL);
>  	usb_put_dev(vb->usb_dev);
> -	kfree(vb->buf);
> -	kfree(vb);
>  
>  	dev_dbg(&interface->dev, "disconnected\n");
>  }
