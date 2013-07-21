Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3GUP70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3GUP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:59:25 -0400
Date: Sun, 21 Jul 2013 08:59:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Graham White <dgwhite11@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: core: Removed superfluous calls to
 put_device in device_destroy and to kobject deletion functions in
 device_del.
Message-ID: <20130721155937.GB19774@kroah.com>
References: <1374420899-2525-1-git-send-email-dgwhite11@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374420899-2525-1-git-send-email-dgwhite11@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 11:34:59AM -0400, David Graham White wrote:
> When device_destroy is called and the device's embedded kobject may be removed,
> this would occur with the call to put_device in device_unregister. Further,
> put_device should take care of cleaning up the kobject without the need to
> call kobject_del indepenedently in device_del.
> 
> Signed-off-by: David Graham White <dgwhite11@gmail.com>
> ---
>  drivers/base/core.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8856d74..d6494ee 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1292,9 +1292,7 @@ void device_del(struct device *dev)
>  	 */
>  	if (platform_notify_remove)
>  		platform_notify_remove(dev);
> -	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
>  	cleanup_device_parent(dev);
> -	kobject_del(&dev->kobj);
>  	put_device(parent);
>  }
>  
> @@ -1849,10 +1847,8 @@ void device_destroy(struct class *class, dev_t devt)
>  	struct device *dev;
>  
>  	dev = class_find_device(class, NULL, &devt, __match_devt);
> -	if (dev) {
> -		put_device(dev);
> +	if (dev)
>  		device_unregister(dev);
> -	}
>  }
>  EXPORT_SYMBOL_GPL(device_destroy);

Are you sure about this.  It seems that every few years someone tries to
make this type of "fix" to the driver code, only to find out that this
really was needed.

Have you tested this to ensure that things get cleaned up properly?

thanks,

greg k-h
