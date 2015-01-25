Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbbAYQP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbbAYQPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:47 -0500
Date: Sun, 25 Jan 2015 20:33:16 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] uio: Simplify the lifetime logic of struct
 uio_device.
Message-ID: <20150125123316.GA9141@kroah.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
 <1421434179-3650-2-git-send-email-mandeep.sandhu@cyaninc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421434179-3650-2-git-send-email-mandeep.sandhu@cyaninc.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:49:36AM -0800, Mandeep Sandhu wrote:
> Embed struct device into struct uio_device, and use
> the refcounting and the release method of struct device
> to control struct uio_device.
> 
> This allows device_create and device_destroy to be replaced
> with the more standard device_register and device_unregister,
> and allows the struct device reference count to act as a
> reference count on struct idev as well.
> 
> Tested-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
> Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
> ---
>  drivers/uio/uio.c          | 41 ++++++++++++++++++++++++++---------------
>  include/linux/uio_driver.h |  3 ++-
>  2 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 6276f13..350b81b 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -16,7 +16,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/poll.h>
> -#include <linux/device.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/idr.h>
> @@ -270,7 +269,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  		if (!map_found) {
>  			map_found = 1;
>  			idev->map_dir = kobject_create_and_add("maps",
> -							&idev->dev->kobj);
> +							&idev->device.kobj);
>  			if (!idev->map_dir)
>  				goto err_map;
>  		}
> @@ -295,7 +294,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  		if (!portio_found) {
>  			portio_found = 1;
>  			idev->portio_dir = kobject_create_and_add("portio",
> -							&idev->dev->kobj);
> +							&idev->device.kobj);
>  			if (!idev->portio_dir)
>  				goto err_portio;
>  		}
> @@ -334,7 +333,7 @@ err_map_kobj:
>  		kobject_put(&map->kobj);
>  	}
>  	kobject_put(idev->map_dir);
> -	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
> +	dev_err(&idev->device, "error creating sysfs files (%d)\n", ret);
>  	return ret;
>  }
>  
> @@ -371,7 +370,7 @@ static int uio_get_minor(struct uio_device *idev)
>  		idev->minor = retval;
>  		retval = 0;
>  	} else if (retval == -ENOSPC) {
> -		dev_err(idev->dev, "too many uio devices\n");
> +		dev_err(&idev->device, "too many uio devices\n");
>  		retval = -EINVAL;
>  	}
>  	mutex_unlock(&minor_lock);
> @@ -785,6 +784,13 @@ static void release_uio_class(void)
>  	uio_major_cleanup();
>  }
>  
> +static void uio_device_release(struct device *dev)
> +{
> +	struct uio_device *idev = dev_get_drvdata(dev);


No, calculate the offset of, then you don't need to mess with drvdata,
as that shouldn't be used by the "core" of a subsystem.

> +
> +	devm_kfree(dev->parent, idev);
> +}
> +
>  /**
>   * uio_register_device - register a new userspace IO device
>   * @owner:	module that creates the new device
> @@ -819,14 +825,19 @@ int __uio_register_device(struct module *owner,
>  	if (ret)
>  		return ret;
>  
> -	idev->dev = device_create(&uio_class, parent,
> -				  MKDEV(uio_major, idev->minor), idev,
> -				  "uio%d", idev->minor);
> -	if (IS_ERR(idev->dev)) {
> -		printk(KERN_ERR "UIO: device register failed\n");
> -		ret = PTR_ERR(idev->dev);
> +	idev->device.devt = MKDEV(uio_major, idev->minor);
> +	idev->device.class = &uio_class;
> +	idev->device.parent = parent;
> +	idev->device.release = uio_device_release;
> +	dev_set_drvdata(&idev->device, idev);

This will not be needed if you fix up the release function.

> +
> +	ret = kobject_set_name(&idev->device.kobj, "uio%d", idev->minor);

dev_set_name()?




> +	if (ret)
> +		goto err_device_create;
> +
> +	ret = device_register(&idev->device);
> +	if (ret)
>  		goto err_device_create;
> -	}
>  
>  	ret = uio_dev_add_attributes(idev);
>  	if (ret)
> @@ -835,7 +846,7 @@ int __uio_register_device(struct module *owner,
>  	info->uio_dev = idev;
>  
>  	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
> -		ret = devm_request_irq(idev->dev, info->irq, uio_interrupt,
> +		ret = devm_request_irq(&idev->device, info->irq, uio_interrupt,
>  				  info->irq_flags, info->name, idev);
>  		if (ret)
>  			goto err_request_irq;
> @@ -846,7 +857,7 @@ int __uio_register_device(struct module *owner,
>  err_request_irq:
>  	uio_dev_del_attributes(idev);
>  err_uio_dev_add_attributes:
> -	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
> +	device_unregister(&idev->device);
>  err_device_create:
>  	uio_free_minor(idev);
>  	return ret;
> @@ -871,7 +882,7 @@ void uio_unregister_device(struct uio_info *info)
>  
>  	uio_dev_del_attributes(idev);
>  
> -	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
> +	device_unregister(&idev->device);
>  
>  	return;
>  }
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 32c0e83..e8f7f82 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -14,6 +14,7 @@
>  #ifndef _UIO_DRIVER_H_
>  #define _UIO_DRIVER_H_
>  
> +#include <linux/device.h>
>  #include <linux/fs.h>
>  #include <linux/interrupt.h>
>  
> @@ -65,7 +66,7 @@ struct uio_port {
>  
>  struct uio_device {
>          struct module           *owner;
> -        struct device           *dev;
> +	struct device           device;

No need to rename the variable, just change it from being a pointer.

thanks,

greg k-h
