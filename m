Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3GXQAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:00:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:00:09 -0400
Date: Wed, 24 Jul 2013 09:00:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Natalia Ovsyanikov <natalia.ovsyanikov@intel.com>
Subject: Re: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Message-ID: <20130724160008.GA17083@kroah.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:41:56PM +0300, Tomas Winkler wrote:
> Export fw status register through sysfs interface.
> The interface is for applications that monitors
> fw health.
> 
> Signed-off-by: Natalia Ovsyanikov <natalia.ovsyanikov@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index 173ff09..64e36a8 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -659,6 +659,44 @@ out:
>  	return mask;
>  }
>  
> +/**
> + * mei_show_fw_status - mei device attribute show method
> + *
> + * @dev:  device pointer
> + * @attr: attribute pointer
> + * @buf:  char out buffer
> + *
> + * returns number of the bytes, printed into the buffer
> + */
> +
> +static ssize_t mei_show_fw_status(struct device *device,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct mei_device *dev = dev_get_drvdata(device);
> +	u32 fw_status;
> +	int err;
> +
> +	mutex_lock(&dev->device_lock);
> +	err = mei_fw_status(dev, &fw_status);
> +	mutex_unlock(&dev->device_lock);
> +	if (err) {
> +		dev_err(device, "attribute show: read fw_status error = %d\n",
> +			err);
> +		return err;
> +	}
> +
> +	dev_dbg(device, "attribute show: fw_status 0x%x\n", fw_status);
> +	return sprintf(buf, "%08X\n", fw_status);
> +}
> +static DEVICE_ATTR(fw_status, S_IRUGO, mei_show_fw_status, NULL);
> +static struct attribute *mei_attributes[] = {
> +	&dev_attr_fw_status.attr,
> +	NULL
> +};
> +static const struct attribute_group mei_attr_group = {
> +	.attrs  = mei_attributes,
> +};
> +
>  /*
>   * file operations structure will be used for mei char device.
>   */
> @@ -685,17 +723,22 @@ static struct miscdevice  mei_misc_device = {
>  		.minor = MISC_DYNAMIC_MINOR,
>  };
>  
> -
>  int mei_register(struct mei_device *dev)
>  {
> +	struct device *device = &dev->pdev->dev;
>  	int ret;
> -	mei_misc_device.parent = &dev->pdev->dev;
> +
> +	mei_misc_device.parent = device;
>  	ret = misc_register(&mei_misc_device);
>  	if (ret)
>  		return ret;
>  
> +	ret = sysfs_create_group(&device->kobj, &mei_attr_group);
> +	if (ret)
> +		return ret;

And you just lost the race with userspace (you told it you had a device,
it went and scanned your attributes and saved them, then you registered
more...)

Please use the dev_groups field for your class to properly have the
driver core register these before userspace is told about the device,
that's the correct way to do this.

thanks,

greg k-h
