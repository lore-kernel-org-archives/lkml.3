Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3FOK2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 06:28:23 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53198 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3FOK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 06:28:22 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        Oliver Schinagl <oliver@schinagl.nl>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        maxime.ripard@free-electrons.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Date: Sat, 15 Jun 2013 12:28:18 +0200
Message-ID: <2828921.i3T9JhMInt@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl>
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl> <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments inline.

On Saturday 15 of June 2013 01:16:20 Oliver Schinagl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
> 
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs
> node.
> 
> These fuses are most likly to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number etc and appear to be
> reasonable unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvinient to do so. Allwinner recommends that a certain input
> pin, labeled 'efuse_vddq', be connected to GND. To write these fuses,
> 2.5 V needs to be applied to this pin.
> 
> Even so, they can still be used to generate a board-unique mac from,
> board unique RSA key and seed the kernel RNG.
> 
> Currently supported are the following known chips:
> Allwinner sun4i (A10)
> Allwinner sun5i (A10s, A13)
> 
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/misc/eeprom/Kconfig     |  17 ++++
>  drivers/misc/eeprom/Makefile    |   1 +
>  drivers/misc/eeprom/sunxi_sid.c | 167
> ++++++++++++++++++++++++++++++++++++++++ 3 files changed, 185
> insertions(+)
>  create mode 100644 drivers/misc/eeprom/sunxi_sid.c
> 
> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> index 04f2e1f..c7bc6ed 100644
> --- a/drivers/misc/eeprom/Kconfig
> +++ b/drivers/misc/eeprom/Kconfig
> @@ -96,4 +96,21 @@ config EEPROM_DIGSY_MTC_CFG
> 
>  	  If unsure, say N.
> 
> +config EEPROM_SUNXI_SID
> +	tristate "Allwinner sunxi security ID support"
> +	depends on ARCH_SUNXI && SYSFS
> +	help
> +	  This is a driver for the 'security ID' available on various
> Allwinner +	  devices. Currently supported are:
> +		sun4i (A10)
> +		sun5i (A13)
> +
> +	  Due to the potential risks involved with changing e-fuses,
> +	  this driver is read-only
> +
> +	  For more information visit http://linux-sunxi.org/SID
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called sunxi_sid.
> +
>  endmenu
> diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
> index fc1e81d..9507aec 100644
> --- a/drivers/misc/eeprom/Makefile
> +++ b/drivers/misc/eeprom/Makefile
> @@ -4,4 +4,5 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
>  obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
>  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
>  obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
> +obj-$(CONFIG_EEPROM_SUNXI_SID)	+= sunxi_sid.o
>  obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
> diff --git a/drivers/misc/eeprom/sunxi_sid.c
> b/drivers/misc/eeprom/sunxi_sid.c new file mode 100644
> index 0000000..f014e1b
> --- /dev/null
> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -0,0 +1,167 @@
> +/*
> + * Copyright (c) 2013 Oliver Schinagl
> + * http://www.linux-sunxi.org
> + *
> + * Oliver Schinagl <oliver@schinagl.nl>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> by + * the Free Software Foundation; either version 2 of the License,
> or + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * This driver exposes the Allwinner security ID, a 128 bit eeprom, in
> byte + * sized chunks.
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/export.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/kobject.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/random.h>
> +#include <linux/stat.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>
> +
> +#define DRV_NAME "sunxi-sid"
> +#define DRV_VERSION "1.0"

What is this version thingy?

Is there a versioning scheme defined for this driver? Do you expect it to 
be changed every modification of this driver?

I don't see any point of having such thing in a project with a version 
control system, where you have all change history.

> +
> +/* There are 4 32-bit keys */
> +#define SID_KEYS 4
> +/* and 4 byte sized keys per 32-bit key */
> +#define SID_SIZE (SID_KEYS * 4)

>From this definition it looks like there are just 4 32-bit keys, I don't 
see those extra four byte-sized keys accounted by this size.

> +
> +

One _empty_ line is enough to separate definitions from code.

> +/* We read the entire key, but only return the requested byte. This is
> of + * course slower then it could be and uses 4 times more reads as
> needed but + * keeps code simpler.

I have no idea how often this is going to be read, but since the whole sid 
is really small (16 bytes), maybe it would be better to simply read the ID 
in probe to a buffer and then just memcpy from it in read().

> + */
> +static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
> +			      const unsigned int offset)
> +{
> +	u32 sid_key = 0;

	u32 sid_key; ...

> +
> +	if (offset >= SID_SIZE)
> +		goto exit;

		return 0; ...

> +
> +	sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
> +	sid_key >>= (offset % 4) * 8;
> +	sid_key &= 0xff;
> +	/* fall through */
> +
> +exit:

...and now magically here you can remove two unneeded lines.

> +	return (u8)sid_key;

Unnecessary casting.

> +}
> +
> +static ssize_t sid_read(struct file *fd, struct kobject *kobj,
> +			struct bin_attribute *attr, char *buf,
> +			loff_t pos, size_t size)
> +{
> +	int i;
> +	struct platform_device *pdev;
> +	void __iomem *sid_reg_base;
> +
> +	pdev = (struct platform_device
> *)to_platform_device(kobj_to_dev(kobj)); +	sid_reg_base = (void 
__iomem
> *)platform_get_drvdata(pdev);
> +
> +	for (i = 0; i < size; i++) {
> +		if ((pos + i) >= SID_SIZE || (pos < 0))
> +			break;
> +		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> +	}

This could be greatly simplified if you just read the whole sid to memory 
in probe and memcpy from it here.

> +	return i;
> +}
> +
> +static const struct of_device_id sunxi_sid_of_match[] = {
> +	{
> +		.compatible = "allwinner,sun4i-sid",
> +	},

Above 3 lines could be put in single line.

> +	{/* sentinel */}
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
> +
> +static const struct bin_attribute sid_bin_attr = {
> +	.attr = {
> +		.name = "eeprom",
> +		.mode = S_IRUGO,
> +	},
> +	.size = SID_SIZE,
> +	.read = sid_read,
> +};
> +
> +static int sunxi_sid_remove(struct platform_device *pdev)
> +{
> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
> +	dev_info(&pdev->dev, "sunxi SID driver unloaded\n");

Please either make this dev_dbg or remove it completely, as it is not 
something that users should be concerned about.

> +	return 0;
> +}
> +
> +static int __init sunxi_sid_probe(struct platform_device *pdev)
> +{
> +	int entropy[SID_SIZE], i;
> +	struct resource *res;
> +	void __iomem *sid_reg_base;
> +	int ret;
> +
> +	if (!pdev->dev.of_node) {
> +		dev_err(&pdev->dev, "No devicetree data available\n");
> +		ret = -ENXIO;
> +		goto exit;
> +	}

What is this check for? You don't seem to need anything from dev.of_node 
in this driver.

> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sid_reg_base)) {
> +		ret = PTR_ERR(sid_reg_base);
> +		goto exit;
> +	}

One of the points of having devm_ helpers was removing the need to use 
error paths at functions end. You can save 2 lines of code by changing 
this check to:

	if (IS_ERR(sid_reg_base))
		return PTR_ERR(sid_reg_base);

> +	platform_set_drvdata(pdev, sid_reg_base);
> +
> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to create sysfs bin entry\n");
> +		goto exit;
> +	}

Same here.

> +
> +	for (i = 0; i < SID_SIZE; i++)
> +		entropy[i] = sunxi_sid_read_byte(sid_reg_base, i);

You seem to read bytes into an array of ints. Your entropy data will 
always have most significant 24-bits cleared. Is this behavior correct?

> +	add_device_randomness(entropy, SID_SIZE);

Now I'm pretty sure that above is not the correct behavior. You are adding 
here first 16 bytes (=SID_SIZE) of entropy[], while it is an array of 16 
ints (=4*SID_SIZE)...

> +	dev_info(&pdev->dev, "sunxi SID ver %s loaded\n", DRV_VERSION);

Same comment as for the message in remove().

> +	ret = 0;
> +	/* fall through */
> +
> +exit:
> +	return ret;

Above 4 non-empty lines can be replaced by a single

	return 0;

> +}
> +
> +static struct platform_driver sunxi_sid_driver = {
> +	.probe = sunxi_sid_probe,
> +	.remove = sunxi_sid_remove,
> +	.driver = {
> +		.name = DRV_NAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = sunxi_sid_of_match,
> +	},
> +};
> +module_platform_driver(sunxi_sid_driver);
> +
> +

One empty line is enough.

Best regards,
Tomasz

> +MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
> +MODULE_DESCRIPTION("Allwinner sunxi security id driver");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL");
