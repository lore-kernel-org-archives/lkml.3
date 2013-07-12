Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3GLW7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:59:20 -0400
Received: from mailout.micron.com ([137.201.242.129]:51419 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab3GLW7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:59:18 -0400
Message-ID: <51E08A3C.5030001@micron.com>
Date: Fri, 12 Jul 2013 15:59:08 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: David Milburn <dmilburn@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtip32xx: dynamically allocate buffer in debugfs functions
References: <1369344225-4110-1-git-send-email-dmilburn@redhat.com>
In-Reply-To: <1369344225-4110-1-git-send-email-dmilburn@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20012.001
X-TM-AS-Result: No--16.938300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2013 2:23 PM, David Milburn wrote:

> Dynamically allocate buf to prevent warnings:
> 
> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_device_status’:
> drivers/block/mtip32xx/mtip32xx.c:2823: warning: the frame size of 1056 bytes is larger than 1024 bytes
> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_registers’:
> drivers/block/mtip32xx/mtip32xx.c:2894: warning: the frame size of 1056 bytes is larger than 1024 bytes
> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_flags’:
> drivers/block/mtip32xx/mtip32xx.c:2917: warning: the frame size of 1056 bytes is larger than 1024 bytes
> 
> Signed-off-by: David Milburn <dmilburn@redhat.com>


Acked-by: Asai Thambi S P <asamymuthupa@micron.com>

> ---
>  drivers/block/mtip32xx/mtip32xx.c |   47 +++++++++++++++++++++++++++++--------
>  1 files changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index 847107e..baa0996 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -2806,34 +2806,51 @@ static ssize_t show_device_status(struct device_driver *drv, char *buf)
>  static ssize_t mtip_hw_read_device_status(struct file *f, char __user *ubuf,
>  						size_t len, loff_t *offset)
>  {
> +	struct driver_data *dd =  (struct driver_data *)f->private_data;
>  	int size = *offset;
> -	char buf[MTIP_DFS_MAX_BUF_SIZE];
> +	char *buf;
> +	int rv = 0;
>  
>  	if (!len || *offset)
>  		return 0;
>  
> +	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(&dd->pdev->dev,
> +			"Memory allocation: status buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	size += show_device_status(NULL, buf);
>  
>  	*offset = size <= len ? size : len;
>  	size = copy_to_user(ubuf, buf, *offset);
>  	if (size)
> -		return -EFAULT;
> +		rv = -EFAULT;
>  
> -	return *offset;
> +	kfree(buf);
> +	return rv ? rv : *offset;
>  }
>  
>  static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
>  				  size_t len, loff_t *offset)
>  {
>  	struct driver_data *dd =  (struct driver_data *)f->private_data;
> -	char buf[MTIP_DFS_MAX_BUF_SIZE];
> +	char *buf;
>  	u32 group_allocated;
>  	int size = *offset;
> -	int n;
> +	int n, rv = 0;
>  
>  	if (!len || size)
>  		return 0;
>  
> +	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(&dd->pdev->dev,
> +			"Memory allocation: register buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
>  
>  	for (n = dd->slot_groups-1; n >= 0; n--)
> @@ -2888,21 +2905,30 @@ static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
>  	*offset = size <= len ? size : len;
>  	size = copy_to_user(ubuf, buf, *offset);
>  	if (size)
> -		return -EFAULT;
> +		rv = -EFAULT;
>  
> -	return *offset;
> +	kfree(buf);
> +	return rv ? rv : *offset;
>  }
>  
>  static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
>  				  size_t len, loff_t *offset)
>  {
>  	struct driver_data *dd =  (struct driver_data *)f->private_data;
> -	char buf[MTIP_DFS_MAX_BUF_SIZE];
> +	char *buf;
>  	int size = *offset;
> +	int rv = 0;
>  
>  	if (!len || size)
>  		return 0;
>  
> +	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(&dd->pdev->dev,
> +			"Memory allocation: flag buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
>  							dd->port->flags);
>  	size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
> @@ -2911,9 +2937,10 @@ static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
>  	*offset = size <= len ? size : len;
>  	size = copy_to_user(ubuf, buf, *offset);
>  	if (size)
> -		return -EFAULT;
> +		rv = -EFAULT;
>  
> -	return *offset;
> +	kfree(buf);
> +	return rv ? rv : *offset;
>  }
>  
>  static const struct file_operations mtip_device_status_fops = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


