Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947439Ab3BHXz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:55:28 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:36146 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947361Ab3BHXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:55:27 -0500
Date: Fri, 8 Feb 2013 15:55:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: sameo@linux.intel.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 02/11 V2] mei: bus: Implement driver registration
Message-ID: <20130208235524.GB24127@kroah.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <1360326504-17041-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360326504-17041-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 02:28:15PM +0200, Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/mei/bus.c  |   29 +++++++++++++++++++++++++++++
>  include/linux/mei_bus.h |    3 +++
>  2 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
> index bb96423c..0a5e624 100644
> --- a/drivers/misc/mei/bus.c
> +++ b/drivers/misc/mei/bus.c
> @@ -153,3 +153,32 @@ void mei_remove_device(struct mei_bus_client *client)
>  	device_unregister(&client->dev);
>  }
>  EXPORT_SYMBOL(mei_remove_device);
> +
> +int mei_driver_register(struct mei_bus_driver *driver)
> +{
> +	int err;
> +
> +	/* Can't register until after driver model init */
> +	if (unlikely(WARN_ON(!mei_bus_type.p)))
> +		return -EAGAIN;

No, you really don't know what 'p' is, so don't assume you do.  You have
fields you can test to see if your driver model is up and registered,
use them instead.  Don't you think that something called 'p' is not
there for you to use?

> +	driver->driver.owner = THIS_MODULE;

Nope, this should be the module that owns the driver, not this one.  It
needs to be passed in with the call, or as part of the driver structure.

> +	driver->driver.bus = &mei_bus_type;
> +
> +	err = driver_register(&driver->driver);
> +	if (err)
> +		return err;
> +
> +	pr_debug("mei: driver [%s] registered\n", driver->driver.name);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mei_driver_register);

_GPL() please?

> +
> +void mei_driver_unregister(struct mei_bus_driver *driver)
> +{
> +	driver_unregister(&driver->driver);
> +
> +	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
> +}
> +EXPORT_SYMBOL(mei_driver_unregister);

Same here.

thanks,

greg k-h
