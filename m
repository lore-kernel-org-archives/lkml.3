Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaK0DHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:07:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaK0DG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:06:59 -0500
Date: Wed, 26 Nov 2014 19:05:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/3] mei: export fw status registers through
 sysfs
Message-ID: <20141127030538.GB8656@kroah.com>
References: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
 <1416409300-14431-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416409300-14431-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:01:39PM +0200, Tomas Winkler wrote:
> The interface is for applications that monitor
> the fw health.
> 
> We use device_create_with_groups interface
> to register attribute with the mei class device
> 
> Signed-off-by :Tomas Winkler <tomas.winkler@intel.com>
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c | 43 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index 5d6a15c3619a..3c019c0e60eb 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -627,6 +627,44 @@ out:
>  	return mask;
>  }
>  
> +/**
> + * fw_status_show - mei device attribute show method
> + *
> + * @device: device pointer
> + * @attr: attribute pointer
> + * @buf:  char out buffer
> + *
> + * Return: number of the bytes printed into buf or error
> + */
> +static ssize_t fw_status_show(struct device *device,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct mei_device *dev = dev_get_drvdata(device);
> +	struct mei_fw_status fw_status;
> +	int err, i;
> +	ssize_t cnt = 0;
> +
> +	mutex_lock(&dev->device_lock);
> +	err = mei_fw_status(dev, &fw_status);
> +	mutex_unlock(&dev->device_lock);
> +	if (err) {
> +		dev_err(device, "read fw_status error = %d\n", err);
> +		return err;
> +	}
> +
> +	for (i = 0; i < fw_status.count; i++)
> +		cnt += scnprintf(buf + cnt, PAGE_SIZE - cnt, "%08X\n",
> +				fw_status.status[i]);

That really looks like more than a "one value per file" thing.

Hint, if you are ever worrying about the size of the buffer for your
sysfs file, you are doing something wrong.

thanks,

greg k-h
