Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3FQW6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:58:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3FQW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:58:48 -0400
Date: Mon, 17 Jun 2013 15:58:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: arnd@arndb.de, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130617225847.GA9494@kroah.com>
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl>
 <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
> 
> Allwinner has electric fuses (efuse) on their line of chips. This driver
> reads those fuses, seeds the kernel entropy and exports them as a sysfs node.
> 
> These fuses are most likly to be programmed at the factory, encoding
> things like Chip ID, some sort of serial number etc and appear to be
> reasonable unique.
> While in theory, these should be writeable by the user, it will probably
> be inconvinient to do so. Allwinner recommends that a certain input pin,
> labeled 'efuse_vddq', be connected to GND. To write these fuses, 2.5 V
> needs to be applied to this pin.
> 
> Even so, they can still be used to generate a board-unique mac from, board
> unique RSA key and seed the kernel RNG.
> 
> Currently supported are the following known chips:
> Allwinner sun4i (A10)
> Allwinner sun5i (A10s, A13)
> 
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/misc/eeprom/Kconfig     |  17 +++++
>  drivers/misc/eeprom/Makefile    |   1 +
>  drivers/misc/eeprom/sunxi_sid.c | 147 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 165 insertions(+)
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
> +	  This is a driver for the 'security ID' available on various Allwinner
> +	  devices. Currently supported are:
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
> diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
> new file mode 100644
> index 0000000..6a16c19
> --- /dev/null
> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (c) 2013 Oliver Schinagl
> + * http://www.linux-sunxi.org
> + *
> + * Oliver Schinagl <oliver@schinagl.nl>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * This driver exposes the Allwinner security ID, a 128 bit eeprom, in byte
> + * sized chunks.
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/kobject.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/random.h>
> +#include <linux/stat.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>
> +
> +#define DRV_NAME "sunxi-sid"
> +
> +/* There are 4 32-bit keys */
> +#define SID_KEYS 4
> +/* Each key is 4 bytes long */
> +#define SID_SIZE (SID_KEYS * 4)
> +
> +/* We read the entire key, due to a 32 bit read alignment requirement. Since we
> + * want to return the requested byte, this resuls in somewhat slower code and
> + * uses 4 times more reads as needed but keeps code simpler. Since the SID is
> + * only very rarly probed, this is not really an issue.
> + */
> +static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
> +			      const unsigned int offset)
> +{
> +	u32 sid_key;
> +
> +	if (offset >= SID_SIZE)
> +		return 0;
> +
> +	sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
> +	sid_key >>= (offset % 4) * 8;
> +
> +	return sid_key; /* Only return the last byte */
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
> +	pdev = to_platform_device(kobj_to_dev(kobj));
> +	sid_reg_base = (void __iomem *)platform_get_drvdata(pdev);
> +
> +	if (pos < 0 || pos >= SID_SIZE)
> +		return 0;
> +	if (size > (SID_SIZE - pos))
> +		size = SID_SIZE - pos;
> +
> +	for (i = 0; i < size; i++)
> +		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> +
> +	return i;
> +}
> +
> +static const struct of_device_id sunxi_sid_of_match[] = {
> +	{ .compatible = "allwinner,sun4i-sid", },
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
> +	dev_dbg(&pdev->dev, "%s driver unloaded\n", DRV_NAME);
> +
> +	return 0;
> +}
> +
> +static int __init sunxi_sid_probe(struct platform_device *pdev)
> +{
> +	u8 entropy[SID_SIZE];
> +	unsigned int i;
> +	struct resource *res;
> +	void __iomem *sid_reg_base;
> +	int ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sid_reg_base))
> +		return PTR_ERR(sid_reg_base);
> +	platform_set_drvdata(pdev, sid_reg_base);
> +
> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
> +	if (ret)
> +		return ret;

You just raced with userspace, having the file show up after the device
was announced to users that it was there.  Please use the proper device
file api to add default attributes to prevent this from happening.

Bonus is it ends up making your driver smaller and simpler :)

> +	for (i = 0; i < SID_SIZE; i++)
> +		entropy[i] = sunxi_sid_read_byte(sid_reg_base, i);
> +	add_device_randomness(entropy, SID_SIZE);

Really?  I don't mind it but is this something that is ok to add to the
pool?  Will it be different on different machines with this device?  Or
will it always be the same on all systems with this device?

thanks,

greg k-h
