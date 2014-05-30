Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaE3Hni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:43:38 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:45045 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaE3Hnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:43:37 -0400
Date: Fri, 30 May 2014 08:43:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: iManager2: Add support for IT8516/18/28
Message-ID: <20140530074330.GN1954@lee--X1>
References: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of things on top of Guenter's comments.

> +config MFD_IMANAGER2
> +	tristate "Support for Advantech iManager2 EC ICs"
> +	select MFD_CORE

So you're not using any other frameworks? I see quite a lot of Mailbox
stuff.  Why aren't you using the Mailbox API, drivers/mailbox?  I'm
gussing you'll need I2C somewhere down the line too.  And Regmap?

> +/* imanager2_core.c - MFD core driver of Advantech EC IT8516/18/28

I can't find any documentation on this device.  Is there a datasheet
or similar?

> + * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */

Documentation/CodingStyle - Comments.

Run scripts/checkpatch.pl on your patches _before_ resending.

> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Don't like this.

> +#include <linux/module.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/advantech/imanager2.h>
> +
> +#define DRV_NAME	CHIP_NAME

Or this.

> +#define DRV_VERSION	"0.2.2"
> +
> +static struct platform_device *pdev;

Why don't you register from Device Tree or platform data? I.e. from
arch/<arch>/.  While we're on the subject, which architecture(s) is
this likely to run on, or is this device completely agnostic?

> +static struct mfd_cell it85xx_devs[] = {
> +	{ .name = DRV_NAME "_hwm", },
> +	{ .name = DRV_NAME "_i2c", },
> +};

Don't like this, just use "it85xx" instead of DRV_NAME.

> +static int ec_authentication(struct it85xx *ec)
> +{
> +	u8 tmp;
> +	int ret = 0;
> +
> +	spin_lock(&ec->lock);
> +
> +	if (inb(EC_IO_PORT_CMD) == 0xFF && inb(EC_IO_PORT_DATA) == 0xFF) {

One would guess that the Mailbox driver should be taking care of all
these.

[...]

> +static int ec_get_chip_type(struct it85xx *ec)
> +{
> +	spin_lock(&ec->lock);

Can you explain to me why you've chosen spin_lock over, say a mutex?

> +	outb(0x20, EC_SIO_CMD);

Don't use magic numbers - all addresses/masks should be #defined

[...]

> +static int ec_get_info(struct it85xx *ec)
> +{
> +	int ret;
> +	/* first kernel version that supports ITE mailbox */

What?

> +	const u16 supmbox_1st_kver = 0x1105;

No way, please remove.

> +	u8 *tmp = (u8 *)&ec->info.version.kernel_ver;
> +
> +	spin_lock(&ec->lock);
> +
> +	ret = ec_io_read(EC_CMD_ACPIRAM_READ,
> +			 EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION, &tmp[0], 2);
> +
> +	if (ec->info.version.kernel_ver >= supmbox_1st_kver) {

Yuk!

If you explain why you're doing this, maybe we can suggest another way
of achieving the same aim.


> +static int __init it85xx_probe(struct it85xx *ec)
> +{
> +	int ret;
> +
> +	ret = ec_authentication(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = ec_get_chip_type(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = ec_get_info(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = ec_build_device_table(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (request_region(EC_IO_PORT_DATA, 2, DRV_NAME) == NULL) {

devm_*

> +		release_region(EC_IO_PORT_DATA, 2);

Delete

> +		return -EIO;
> +	}
> +
> +	if (request_region(EC_ITE_PORT_OFS, 2, DRV_NAME) == NULL) {

Etc ...

> +		release_region(EC_ITE_PORT_OFS, 2);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init it85xx_device_add(const struct it85xx *ec)
> +{
> +	int ret;
> +
> +	pdev = platform_device_alloc(DRV_NAME, 0);
> +	if (pdev == NULL) {
> +		ret = -ENOMEM;
> +		pr_err("Device allocation failed\n");
> +		goto exit;

Remove the 'exit' lable and just 'return ret' here.
> +	}
> +
> +	ret = platform_device_add_data(pdev, ec,
> +				       sizeof(struct it85xx));

ec is not platform data, it's device data.  Platform data should be
passed in via the platform_data structure or Device Tree.

> +	if (ret != 0) {
> +		pr_err("Platform data allocation failed\n");
> +		goto exit_device_put;
> +	}
> +
> +	ret = platform_device_add(pdev);
> +	if (ret != 0) {
> +		pr_err("Device addition failed (%d)\n", ret);
> +		goto exit_device_put;
> +	}
> +
> +	ret = mfd_add_devices(&pdev->dev, pdev->id, it85xx_devs,
> +			      ARRAY_SIZE(it85xx_devs), NULL, -1, NULL);

Second argument here should probably be -1 for 'auto'.

> +	if (ret != 0) {
> +		pr_err("Cannot add sub device (error=%d)\n", ret);

Once you've converted this whole driver to a platform device, all the
pr_*'s need moving over to dev_*'s.


> +		goto exit_device_unregister;
> +	} else {

No need for the else.

> +		pr_info("MFD core driver v%s loaded\n", DRV_VERSION);

Remove this.

> +	}
> +
> +	return 0;
> +
> +exit_device_unregister:
> +	platform_device_unregister(pdev);
> +exit_device_put:
> +	platform_device_put(pdev);
> +exit:
> +	return ret;
> +}
> +
> +

Too many '\n'.

> +static int __init it85xx_init(void)
> +{
> +	struct it85xx ec;
> +
> +	memset(&ec, 0, sizeof(struct it85xx));
> +	spin_lock_init(&ec.lock);
> +	if (it85xx_probe(&ec) != 0)

Don't role your own Device Driver framework, instead [un]register with
platform_driver_[un]register().

> +		return -ENODEV;
> +
> +	return it85xx_device_add(&ec);
> +}
> +
> +static void __exit it85xx_exit(void)
> +{
> +	release_region(EC_ITE_PORT_OFS, 2);
> +	release_region(EC_IO_PORT_DATA, 2);
> +	mfd_remove_devices(&pdev->dev);

This should all be done in .remove, not exit.

> +	platform_device_unregister(pdev);
> +	pr_info("MFD core driver removed\n");

Useless print, please remove.

> +++ b/drivers/mfd/imanager2_ec.c
> @@ -0,0 +1,1093 @@

[...]

> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/advantech/imanager2.h>
> +
> +#define EC_UDELAY_TIME		100
> +#define EC_MAX_TIMEOUT_COUNT	10000

Are these arbitrary?

> +/*===========================================================
> + * Name   : wait_obf
> + * Purpose: wait output buffer full flag set
> + * Input  : none
> + * Output : 0: success; else: fail
> + *===========================================================*/

These headers are ugly, please use kerneldoc format.

> +static int wait_obf(void)
> +{
> +	int i;
> +	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
> +		if ((inb(EC_IO_PORT_CMD) & OBF_MASK) != 0)
> +			return 0;
> +
> +		udelay(EC_UDELAY_TIME);
> +	}
> +
> +	return -ETIMEDOUT;
> +}

[...]

> +int ec_mailbox_read_buffer(struct it85xx *ec, u8 cmd, u8 para,
> +			   u8 *data, int len)
> +{
> +	int ret, i;
> +	u8 status;
> +
> +	ret = ec_wait_cmd_clear(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, para);
> +	ec_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, cmd);
> +
> +	ret = ec_wait_cmd_clear(ec);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = ec_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
> +	if (ret != 0)
> +		return ret;
> +	if (status != EC_MAILBOX_STATUS_SUCCESS)
> +		return -EFAULT;
> +
> +	for (i = 0; i < len; i++)
> +		ec_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i), &data[i]);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ec_mailbox_read_buffer);

I suggest that you'll need to move a lot of this code to
drivers/mailbox.

[...]

I need to stop here - this patch is massive.

Please break it up into more manageable chunks for your next submission.

A 1500 line patch, is pretty unacceptable.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
