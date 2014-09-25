Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaIYPzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:55:12 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:60132 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaIYPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:55:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 25 Sep 2014 17:52:35 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v4 1/3] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140925155235.GJ32124@localhost>
References: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
 <1411659697-27258-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411659697-27258-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:41:35PM +0300, Octavian Purdila wrote:
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

Reviewed-by: Johan Hovold <johan@kernel.org>

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
>  		kfree(vb);
>  	}
>  
> @@ -118,6 +125,7 @@ static void vprbrd_disconnect(struct usb_interface *interface)
>  	mfd_remove_devices(&interface->dev);
>  	usb_set_intfdata(interface, NULL);
>  	usb_put_dev(vb->usb_dev);
> +	kfree(vb->buf);
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
