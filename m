Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKKEWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:22:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKKEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:22:18 -0500
Date: Tue, 11 Nov 2014 13:21:00 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [V2 PATCH 05/10] added media specific (MS) TCP drivers
Message-ID: <20141111042100.GB22068@kroah.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-5-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415671781-11351-5-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:09:36PM -0800, Stephanie Wallick wrote:
> +static int ma_open;

Why do you need this variable?

> +/**
> + * This function is used to open the device file in order to read/write
> + * from/to it.
> + *
> + * @inode:	Struct with various information that is passed in when this
> + *		function is called. We don't need to use it for our purposes.
> + * @file:	The file to be opened.
> + */
> +static int mausb_open(struct inode *inode, struct file *file)
> +{
> +	if (ma_open)
> +		return -EBUSY;
> +	ma_open++;

Racy :(

> +	try_module_get(THIS_MODULE);

Even more racy, _NEVER_ make this type of call, it's _ALWAYS_ wrong.

And totally not even needed at all, if you set up your file structure
properly.

> +
> +	return 0;
> +}
> +
> +/**
> + * This function is used to close the device file.
> + *
> + * @inode:	Struct with various information that is passed in when this
> + *		function is called. We don't need to use it for our purposes.
> + * @file:	The file to be closed.
> + */
> +static int mausb_release(struct inode *inode, struct file *file)
> +{
> +	ma_open--;

Again, racy, and pointless, why are you doing this?

> +	module_put(THIS_MODULE);

And again, broken and racy :(

> +	return 0;
> +}
> +
> +
> +/**
> + * This function is used to execute ioctl commands, determined by ioctl_func.
> + *
> + * @file:	  The device file. We don't use it directly, but it's passed in.
> + * @ioctl_func:	  This value determines which ioctl function will be used.
> + * @ioctl_buffer: This buffer is used to transfer data to/from the device.
> + */
> +long mausb_ioctl(struct file *file, unsigned int ioctl_func,
> +		unsigned long ioctl_buffer)
> +{
> +	char message[BUFFER];
> +	int ret, value;
> +	unsigned long int long_value;
> +	char __user *msg = (char *)ioctl_buffer;
> +	char *response;
> +
> +	switch (ioctl_func) {
> +	case IOCTL_GET_VRSN:
> +		ret = copy_to_user(msg, DRIVER_VERSION, strlen(DRIVER_VERSION));
> +		break;

This should be a sysfs file.  Why even care about the version?


> +	case IOCTL_GET_NAME:
> +		ret = copy_to_user(msg, MAUSB_NAME, strlen(MAUSB_NAME));
> +		break;

Why?

> +	case IOCTL_GADGET_C:
> +		ret = gadget_connection(1);
> +		if (ret >= 0)
> +			response = MAUSB_GADGET_C_SUCCESS;
> +		else
> +			response = MAUSB_GADGET_C_FAIL;
> +
> +		ret = copy_to_user(msg, response, strlen(response));
> +		break;

Can't this be a sysfs file?

> +	case IOCTL_GADGET_D:
> +		ret = gadget_connection(0);
> +		if (ret >= 0)
> +			response = MAUSB_GADGET_D_SUCCESS;
> +		else
> +			response = MAUSB_GADGET_D_FAIL;
> +
> +		ret = copy_to_user(msg, response, strlen(response));
> +		break;

Same here.


> +	case IOCTL_SET_PORT:
> +		ret = strncpy_from_user(message, msg, BUFFER);
> +		if (ret < 0)
> +			break;
> +		ret = kstrtoint(msg, 0, &value);
> +		if (ret != 0)
> +			break;
> +
> +		ret = set_port_no(value);
> +		sprintf(message, "PORT NUMBER:%d, Returned %i\n", value,
> +			ret);

That looks like a debug message.

> +		ret = copy_to_user(msg, message, strlen(message));
> +		break;

That really looks like a sysfs file.


> +	case IOCTL_SET_IP:
> +		ret = strncpy_from_user(message, msg, BUFFER);
> +		if (ret < 0)
> +			break;
> +		ret = kstrtoul(message, 0, &long_value);
> +		if (ret != 0)
> +			break;
> +
> +		ret = set_ip_addr(long_value);
> +		sprintf(message, "IP ADDRESS:%lx, returned %i\n",
> +			long_value, ret);

That looks like a debug message :(

> +		ret = copy_to_user(msg, message, strlen(message));
> +		break;

again sysfs file?


> +	case IOCTL_SET_MAC:
> +		{
> +			u8 mac[6];
> +			int i;
> +			ret = copy_from_user(mac, msg, 6);
> +			if (ret) {
> +				pr_err("copy_from_user failed\n");
> +				break;
> +			}
> +			for (i = 0; i < ETH_ALEN; i++)
> +				pr_info("mac[%d]=0x%x\n", i, mac[i]);
> +			ret = set_mac_addr(mac);
> +			if (ret)
> +				pr_err("unable to set MAC addr\n");
> +
> +			break;
> +		}

And again, sysfs file.

What about any other ioctl?  You forgot to return an invalid number.

> +	}
> +
> +	/* failure */
> +	if (ret < 0)
> +		return ret;

You could have just returned a stack value here :(


> +
> +	/* success */
> +	return 0;

No need for the comments, this is a pretty common kernel idiom,
especially when all 6 lines get reduced to a single 'return ret;' line :)


> +}
> +
> +/**
> + * This struct creates links with our implementations of various entry point
> + * functions.
> + */
> +const struct file_operations fops = {
> +	.open = mausb_open,
> +	.release = mausb_release,
> +	.unlocked_ioctl = mausb_ioctl
> +};

Any reason you didn't set the file_operations module owner here?  (hint,
do that and you will never need the crazy try_module_get() crazy
above...)

> +
> +/**
> + * Registers a character device using our device file. This function is called
> + * in the mausb_hcd_init function.
> + */
> +int reg_chrdev()

()???


> +{
> +	int ret;
> +
> +#ifdef MAUSB_PRINT_IOCTL_MAGIC

please no.


> +
> +	printk(KERN_DEBUG "Printing IOCTL magic numbers:\n");
> +	printk(KERN_DEBUG "IOCTL_SET_MSG        = %u\n", IOCTL_SET_MSG);
> +	printk(KERN_DEBUG "IOCTL_GET_MSG        = %u\n", IOCTL_GET_MSG);
> +	printk(KERN_DEBUG "IOCTL_GET_VRSN       = %u\n", IOCTL_GET_VRSN);
> +	printk(KERN_DEBUG "IOCTL_GET_NAME       = %u\n", IOCTL_GET_NAME);
> +	printk(KERN_DEBUG "IOCTL_GADGET_C       = %u\n", IOCTL_GADGET_C);
> +	printk(KERN_DEBUG "IOCTL_GADGET_D       = %u\n", IOCTL_GADGET_D);
> +	printk(KERN_DEBUG "IOCTL_MED_DELAY      = %u\n", IOCTL_MED_DELAY);
> +	printk(KERN_DEBUG "IOCTL_SET_IP         = %u\n", IOCTL_SET_IP);
> +	printk(KERN_DEBUG "IOCTL_SET_PORT       = %u\n", IOCTL_SET_PORT);
> +	printk(KERN_DEBUG "IOCTL_SET_IP_DECIMAL = %u\n", IOCTL_SET_IP_DECIMAL);
> +	printk(KERN_DEBUG "IOCTL_SET_MAC        = %u\n", IOCTL_SET_MAC);
> +
> +#endif
> +
> +	ret = register_chrdev(MAJOR_NUM, MAUSB_NAME, &fops);
> +
> +	if (ret < 0)
> +		printk(KERN_ALERT "Registering mausb failed with %d\n", ret);
> +	else
> +		printk(KERN_INFO "%s registeration complete. Major device"
> +			" number %d.\n", MAUSB_NAME, MAJOR_NUM);
> +
> +	return ret;
> +}
> +
> +/**
> + * Unregisters the character device when the hcd is unregistered. As hinted,
> + * this function is called in the mausb_hcd_exit function.
> + */
> +void unreg_chrdev()

That's a _very_ bold global function name you just chose for this, and
the previous function :(


> +{
> +	unregister_chrdev(MAJOR_NUM, MAUSB_NAME);
> +}
> diff --git a/drivers/staging/mausb/drivers/mausb_ioctl.h b/drivers/staging/mausb/drivers/mausb_ioctl.h
> new file mode 100644
> index 0000000..4126ade
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_ioctl.h
> @@ -0,0 +1,101 @@
> +/* Name:         mausb_ioctl.h
> + * Description:  header file for MA USB ioctl functions
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2014 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * Contact Information:
> + * Sean Stalley, sean.stalley@intel.com
> + * Stephanie Wallick, stephanie.s.wallick@intel.com
> + * 2111 NE 25th Avenue
> + * Hillsboro, Oregon 97124
> + *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2014 Intel Corporation.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> +    * Redistributions of source code must retain the above copyright
> +      notice, this list of conditions and the following disclaimer.
> +    * Redistributions in binary form must reproduce the above copyright
> +      notice, this list of conditions and the following disclaimer in
> +      the documentation and/or other materials provided with the
> +      distribution.
> +    * Neither the name of Intel Corporation nor the names of its
> +      contributors may be used to endorse or promote products derived
> +      from this software without specific prior written permission.
> +
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#ifndef MAUSB_IOCTL_H
> +#define MAUSB_IOCTL_H
> +
> +#define BUFFER 80

Why 80?  Why not 8000?  Why any number at all?

> +#define DRIVER_VERSION "Alpha 0.0.25"

Why is this even needed?

> +#define MAJOR_NUM 100

You can't just steal another driver's major number, that's not allowed
at all, and again, something I can never even accept into the staging
tree.

Why need a reserved major at all?

> +/* These define the ioctl functions that can be used. */
> +#define IOCTL_GET_VRSN _IOR(MAJOR_NUM, 0, char *)
> +#define IOCTL_GET_NAME _IOR(MAJOR_NUM, 1, char *)
> +#define IOCTL_GADGET_C _IOR(MAJOR_NUM, 2, char *)
> +#define IOCTL_GADGET_D _IOR(MAJOR_NUM, 3, char *)
> +#define IOCTL_SET_IP   _IOR(MAJOR_NUM, 4, char *)
> +#define IOCTL_SET_PORT _IOR(MAJOR_NUM, 5, char *)
> +#define IOCTL_SET_MAC  _IOR(MAJOR_NUM, 6, char *)

These are not all _IOR() ioctls, look at the code implementing them!

> +/* This is the location where the device file will be created. It is used to
> + * read/write to in order to communicate to and from the device. */
> +#define DEVICE_FILE_NAME "/dev/mausb"

Never used, don't put that in a kernel file.


> +
> +/* MAC address length */
> +#define ETH_ALEN 6
> +
> +/* Responses to IOCTL calls */
> +#define MAUSB_GADGET_C_SUCCESS	"gadget connect process complete"
> +#define MAUSB_GADGET_C_FAIL	"gadget connect process failed"
> +#define MAUSB_GADGET_D_SUCCESS	"gadget disconnect process complete"
> +#define MAUSB_GADGET_D_FAIL	"gadget disconnect process failed"

ioctls returning text strings?  Next thing you will want i18n versions
of them...

> +int mausb_transfer_packet(struct ms_pkt *pkt,
> +	struct mausb_pkt_transfer *transfer)
> +{
> +	return transfer->transfer_packet(pkt, transfer->context);
> +}
> +EXPORT_SYMBOL(mausb_transfer_packet);

EXPORT_SYMBOL_GPL() for USB stuff please.

I'm not reviewing further, sorry.

thanks,

greg k-h
