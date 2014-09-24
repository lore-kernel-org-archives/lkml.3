Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaIXKMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:12:15 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:42440 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:12:13 -0400
Date: Wed, 24 Sep 2014 11:12:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140924101206.GD19999@lee--X1>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Octavian Purdila wrote:

> Currently the I/O buffer is allocated part of the device status
> structure, potentially sharing the same cache line with other members
> in this structure.
> 
> Allocate the buffer separately, to avoid the I/O operations corrupting
> the device status structure due to cache line sharing.
> 
> Compiled tested only as I don't have access to hardware.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/mfd/viperboard.c       | 8 ++++++++
>  include/linux/mfd/viperboard.h | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index e00f534..5f62f4e 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -64,6 +64,12 @@ static int vprbrd_probe(struct usb_interface *interface,
>  		return -ENOMEM;
>  	}
>  
> +	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);

Can you obtain the 'struct device' first then use managed resources
(devm_*)?

> +	if (vb->buf == NULL) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
>  	mutex_init(&vb->lock);
>  
>  	vb->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> @@ -105,6 +111,7 @@ static int vprbrd_probe(struct usb_interface *interface,
>  error:
>  	if (vb) {
>  		usb_put_dev(vb->usb_dev);
> +		kfree(vb->buf);

Then you don't need this.

>  		kfree(vb);
>  	}
>  
> @@ -118,6 +125,7 @@ static void vprbrd_disconnect(struct usb_interface *interface)
>  	mfd_remove_devices(&interface->dev);
>  	usb_set_intfdata(interface, NULL);
>  	usb_put_dev(vb->usb_dev);
> +	kfree(vb->buf);

Or this.

>  	kfree(vb);
>  
>  	dev_dbg(&interface->dev, "disconnected\n");
> diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
> index 1934528..af928d0 100644
> --- a/include/linux/mfd/viperboard.h
> +++ b/include/linux/mfd/viperboard.h
> @@ -103,7 +103,7 @@ struct vprbrd_i2c_addr_msg {
>  struct vprbrd {
>  	struct usb_device *usb_dev; /* the usb device for this device */
>  	struct mutex lock;
> -	u8 buf[sizeof(struct vprbrd_i2c_write_msg)];
> +	u8 *buf;
>  	struct platform_device pdev;
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
