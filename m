Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaKTL1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:27:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32842 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKTL1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:27:18 -0500
Message-ID: <546DD00E.4000704@collabora.co.uk>
Date: Thu, 20 Nov 2014 12:27:10 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk> <20141118141827.GB24004@x1>
In-Reply-To: <20141118141827.GB24004@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

Thanks a lot for your feedback.

On 11/18/2014 03:18 PM, Lee Jones wrote:
>>  
>> +config MFD_CROS_EC_DEV
> 
> _DEV as a post-fix doesn't really describe the driver.
>

the _DEV is meant to denote (user-space device interface) but is true that
a better name can be used, I'll see what I can came with.
 
>> +	tristate "ChromeOS Embedded Controller userspace device interface"
>> +	depends on MFD_CROS_EC
>> +
> 
> Superfluous '\n'.
> 

Ok

>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -12,6 +12,7 @@ obj-$(CONFIG_MFD_BCM590XX)	+= bcm590xx.o
>>  obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
>>  obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
>>  obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
>> +obj-$(CONFIG_MFD_CROS_EC_DEV)	+= cros_ec_dev.o
> 
> Alphabetical?
>

Ok

>> +
>> +#define pr_fmt(fmt) "cros_ec_dev: " fmt
> 
> This doesn't appear to even be used?
>

It is used by pr_* family of functions, e.g: from include/linux/printk.h

#define pr_err(fmt, ...) \
         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 
>> +#include <linux/compat.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/fs.h>
>> +#include <linux/mfd/cros_ec.h>
>> +#include <linux/mfd/cros_ec_commands.h>
>> +#include <linux/mfd/cros_ec_dev.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/printk.h>
> 
> What do you need this for?
>

the printk.h header? to use the pr_* functions but I'll make sure that only
the needed headers are included.
 
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +
>> +/* Device variables */
>> +#define CROS_CLASS_NAME "chromeos"
> 
> Any reason why you can't use the name directly?
> 

I prefer macros if possible since they cost nothing and give you an indirection
level if you want to change it later. Any reason to not use a define directive?

>> +static struct cros_ec_device *ec;
> 
> Can't you put this in a struct somewhere?
>

Yes, I'll remove the global variable and put it in struct file .private_data
 
>> +static struct class *cros_class;
> 
> Why this this global instead of using the one in 'struct
> cros_ec_device'?
> 
>> +static int ec_major;
> 
> Same here.  Only use globals if you're forced to.
>

Ok, I'll look how to refactor to remove these globals too.
 
>> +
>> +
> 
> Superfluous '\n'.
> 

Ok

>> +
>> +	ret = cros_ec_cmd_xfer(ec, &msg);
>> +	if (ret < 0)
>> +		return ret;
>> +	if (msg.result != EC_RES_SUCCESS) {
>> +		snprintf(str, maxlen,
>> +			 "%s\nUnknown EC version: EC returned %d\n",
>> +			 CROS_EC_DEV_VERSION, msg.result);
>> +		return 0;
>> +	}
>> +	if (resp.current_image >= ARRAY_SIZE(current_image_name))
>> +		resp.current_image = 3; /* invalid */
> 
> Add a '\n' here.
>

Ok

>> +	if (*offset != 0)
>> +		return 0;
>> +
>> +	ret = ec_get_version(ec, msg, sizeof(msg));
>> +	if (ret)
>> +		return ret;
> 
> New line here.  Not sure why you are bunching up these segments.
> 

Ok

>> +	count = min(length, strlen(msg));
>> +
>> +	if (copy_to_user(buffer, msg, count))
>> +		return -EFAULT;
>> +
>> +	*offset += count;
> 
> You know offset is 0 here, so you can just *offset = count.
> 

True

>> +	return count;
>> +}
>> +
>> +
> 
> Please remove these double line spaces throughout.
>

Ok
 
>> +/* Ioctls */
>> +static long ec_device_ioctl_xcmd(void __user *argp)
>> +{
>> +	long ret;
>> +	struct cros_ec_command s_cmd;
>> +	uint8_t *user_indata;
>> +	uint8_t buf[EC_PROTO2_MAX_PARAM_SIZE];
>> +
>> +	if (copy_from_user(&s_cmd, argp, sizeof(s_cmd)))
>> +		return -EFAULT;
>> +	if (s_cmd.outsize &&
>> +	    copy_from_user(&buf, (void __user *)s_cmd.outdata, sizeof(buf)))
>> +		return -EFAULT;
>> +
>> +	user_indata = s_cmd.indata;
>> +	s_cmd.indata = buf;
>> +	s_cmd.outdata = buf;
>> +	ret = cros_ec_cmd_xfer(ec, &s_cmd);
>> +	s_cmd.indata = user_indata;
> 
> For conforming if you swap these round, place a '\n' after this line
> and move the check for 'ret' to just after the call to
> cros_ec_cmd_xfer().
>

Ok
 
>> +static long ec_device_compat_ioctl(struct file *filp, unsigned int cmd,
>> +				   unsigned long arg)
>> +{
>> +	void __user
>> +	*argp = (void __user *)arg;
> 
> Why is this expressed over multiple lines?
>

No reason at all, I'll change it.
 
>> +	switch (cmd) {
>> +	case CROS_EC_DEV_COMPAT_IOCXCMD:
>> +		return ec_device_compat_ioctl_xcmd(argp);
>> +	case CROS_EC_DEV_COMPAT_IOCRDMEM:
>> +		return ec_device_compat_ioctl_readmem(argp);
>> +	}
> 
> '\n'
>

Ok
 
>> +	return -ENOTTY;
>> +}
>> +#endif /* CONFIG_COMPAT */
>> +
>> +
> 
> Please remove.
> 

Ok

>> +static int ec_device_probe(struct platform_device *pdev)
>> +{
>> +	int retval = -ENOTTY;
>> +
>> +	ec = dev_get_drvdata(pdev->dev.parent);
> 
> Stick this as the first line in the function.
>

Ok
 
>> +	cros_class = class_create(THIS_MODULE, CROS_CLASS_NAME);
>> +	if (IS_ERR(cros_class)) {
>> +		pr_err("failed to register device class\n");
> 
> Why are you using pr_err() over dev_err()?
>

You are right, I'll use dev_err() instead.

>> +		retval = PTR_ERR(cros_class);
>> +		goto failed_class;
> 
> Remove this goto and the corresponding label and just return from here.
>

Ok

>> +
>> +static struct platform_driver cros_ec_dev_driver = {
>> +	.driver = {
>> +		.name = "cros-ec-dev",
>> +		.owner = THIS_MODULE,
> 
> Remove this line.
>

Right, I've seen some cleanups efforts to remove the owner from drivers
but forgot when reviewing this driver for posting.
 
>> +	},
>> +	.probe = ec_device_probe,
>> +	.remove = ec_device_remove,
>> +};
> 
> Where is this device registered from?
> 
>> +module_platform_driver(cros_ec_dev_driver);

This preprocessor macro is expanded to (from include/linux/device.h):

module_platform_driver() -> module_driver()

#define module_driver(__driver, __register, __unregister, ...) \
static int __init __driver##_init(void) \
{ \
	return __register(&(__driver) , ##__VA_ARGS__); \
} \

Again, thanks a lot for your detailed review.

Best regards,
Javier

