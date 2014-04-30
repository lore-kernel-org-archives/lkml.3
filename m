Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbaD3RVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:21:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65493 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaD3RVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:21:49 -0400
Date: Wed, 30 Apr 2014 10:21:14 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH v4 10/21] mtd: support BB SRAM on ICP DAS LP-8x4x
Message-ID: <20140430172114.GA2497@norris-Latitude-E6410>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
 <1397668667-27328-1-git-send-email-ynvich@gmail.com>
 <1397668667-27328-4-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397668667-27328-4-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

A few more small comments.

On Wed, Apr 16, 2014 at 09:17:15PM +0400, Sergei Ianovich wrote:
> This provides an MTD device driver for 512kB of battery backed up SRAM
> on ICPDAS LP-8X4X programmable automation controllers.
> 
> SRAM chip is connected via FPGA and is not accessible without a driver,
> unlike flash memory which is wired to CPU MMU.
> 
> This SRAM becomes an excellent persisent storage of volatile process
> data like counter values and sensor statuses. Storing those data in
> flash or mmc card is not a viable solution.
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> Reviewed-by: Brian Norris <computersforpeace@gmail.com>
> ---
>    v3..v4 for Brian Norris 'Reviewed-by'
>    * add doc file for DT binding
>    * move DTS binding to a different patch (8/21)
>    * drop unused include directive
>    * drop safely unused callback
>    * drop non-default partion probe types
>    * drop duplicate error checks
>    * drop duplicate error reporting
>    * fixed error message on MTD registeration
>    * fixed module removal routine

Thanks for the updates. This patch looks pretty good to me.

>    v2..v3
>    * no changes (except number 08/16 -> 10/21)
> 
>    v0..v2
>    * use device tree
>    * use devm helpers where possible
> 
>  .../devicetree/bindings/mtd/sram-lp8x4x.txt        |  22 +++
>  arch/arm/configs/lp8x4x_defconfig                  |   1 +
>  drivers/mtd/devices/Kconfig                        |  14 ++
>  drivers/mtd/devices/Makefile                       |   1 +
>  drivers/mtd/devices/sram_lp8x4x.c                  | 204 +++++++++++++++++++++
>  5 files changed, 242 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/sram-lp8x4x.txt
>  create mode 100644 drivers/mtd/devices/sram_lp8x4x.c
> 
> diff --git a/Documentation/devicetree/bindings/mtd/sram-lp8x4x.txt b/Documentation/devicetree/bindings/mtd/sram-lp8x4x.txt
> new file mode 100644
> index 0000000..8b1e864
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/sram-lp8x4x.txt
> @@ -0,0 +1,22 @@
> +512kB battery backed up SRAM on LP-8x4x industrial computers
> +
> +Required properties:
> +- compatible : should be "icpdas,sram-lp8x4x"
> +
> +- reg: physical base addresses and region lengths of
> +       * IO memory range
> +       * SRAM page selector

Are these region types pretty static for this type of hardware? If not,
it helps to have a reg-names property in the DT, when there are 2 or
more register resources.

> +- eeprom-gpios : should point to active-low write enable GPIO

I'm curious: your driver doesn't actually utilize this binding. Is this
intentional? Is it actually optional? (I note that the example DT below
doesn't have this property...)

> +
> +SRAM chip is connected via FPGA and is not accessible without a driver,
> +unlike flash memory which is wired to CPU MMU. Driver is essentially
> +an address translation routine.
> +
> +Example:
> +
> +	sram@a000 {
> +		compatible = "icpdas,sram-lp8x4x";
> +		reg = <0xa000 0x1000
> +		       0x901e 0x1>;
> +	};
> diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
> index d60e37a..17a4e6f 100644
> --- a/arch/arm/configs/lp8x4x_defconfig
> +++ b/arch/arm/configs/lp8x4x_defconfig
> @@ -57,6 +57,7 @@ CONFIG_MTD_CFI_ADV_OPTIONS=y
>  CONFIG_MTD_CFI_GEOMETRY=y
>  CONFIG_MTD_CFI_INTELEXT=y
>  CONFIG_MTD_PHYSMAP_OF=y
> +CONFIG_MTD_SRAM_LP8X4X=y
>  CONFIG_PROC_DEVICETREE=y
>  CONFIG_BLK_DEV_LOOP=y
>  CONFIG_BLK_DEV_LOOP_MIN_COUNT=2

I can't take the defconfig update via MTD; it will need to go via the
appropriate ARM tree (arm-soc?). So this hunk needs to move to another
patch.

> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 1210bc2..fc8552b 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -225,4 +225,18 @@ config BCH_CONST_T
>  	default 4
>  endif
>  
> +config MTD_SRAM_LP8X4X
> +	tristate "SRAM on ICPDAS LP-8X4X"
> +	depends on OF && ARCH_PXA
> +       ---help---
> +	 This provides an MTD device driver for 512kiB of battery backed up SRAM
> +	 on ICPDAS LP-8X4X programmable automation controllers.
> +
> +	 SRAM chip is connected via FPGA and is not accessible without a driver,
> +	 unlike flash memory which is wired to CPU MMU.
> +
> +	 Say N, unless you plan to run this kernel on LP-8X4X.
> +
> +	 If you say M, the module will be called sram_lp8x4x.
> +
>  endmenu
> diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
> index c68868f..a7d86e2 100644
> --- a/drivers/mtd/devices/Makefile
> +++ b/drivers/mtd/devices/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
>  obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
>  obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
>  obj-$(CONFIG_MTD_ST_SPI_FSM)    += st_spi_fsm.o
> +obj-$(CONFIG_MTD_SRAM_LP8X4X)	+= sram_lp8x4x.o
>  
>  
>  CFLAGS_docg3.o			+= -I$(src)
> diff --git a/drivers/mtd/devices/sram_lp8x4x.c b/drivers/mtd/devices/sram_lp8x4x.c
> new file mode 100644
> index 0000000..4cfa70b
> --- /dev/null
> +++ b/drivers/mtd/devices/sram_lp8x4x.c
> @@ -0,0 +1,204 @@
> +/*
> + *  linux/drivers/mtd/devices/lp8x4x_sram.c
> + *
> + *  MTD Driver for SRAM on ICPDAS LP-8x4x
> + *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation or any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mtd/map.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_device.h>
> +#include <linux/slab.h>
> +#include <linux/string_helpers.h>
> +#include <linux/types.h>
> +
> +struct lp8x4x_sram_info {
> +	void __iomem	*bank;
> +	void __iomem	*virt;
> +	struct mutex	lock;
> +	unsigned	active_bank;
> +	struct mtd_info	mtd;
> +};
> +
> +static int
> +lp8x4x_sram_erase(struct mtd_info *mtd, struct erase_info *instr)
> +{
> +	struct lp8x4x_sram_info *info = mtd->priv;
> +	unsigned bank = instr->addr >> 11;
> +	unsigned offset = (instr->addr & 0x7ff) << 1;
> +	loff_t i;
> +
> +	mutex_lock(&info->lock);
> +	if (unlikely(bank != info->active_bank)) {
> +		info->active_bank = bank;
> +		iowrite8(bank, info->bank);
> +	}
> +	for (i = 0; i < instr->len; i++) {
> +		iowrite8(0xff, info->virt + offset);
> +		offset += 2;
> +		if (unlikely(offset == 0)) {
> +			info->active_bank++;
> +			iowrite8(info->active_bank, info->bank);
> +		}
> +	}
> +	mutex_unlock(&info->lock);
> +	instr->state = MTD_ERASE_DONE;
> +	mtd_erase_callback(instr);
> +
> +	return 0;
> +}
> +
> +static int
> +lp8x4x_sram_write(struct mtd_info *mtd, loff_t to, size_t len,
> +		size_t *retlen, const u_char *b)
> +{
> +	struct lp8x4x_sram_info *info = mtd->priv;
> +	unsigned bank = to >> 11;
> +	unsigned offset = (to & 0x7ff) << 1;
> +	loff_t i;
> +
> +	mutex_lock(&info->lock);
> +	if (unlikely(bank != info->active_bank)) {
> +		info->active_bank = bank;
> +		iowrite8(bank, info->bank);
> +	}
> +	for (i = 0; i < len; i++) {
> +		iowrite8(b[i], info->virt + offset);
> +		offset += 2;
> +		if (unlikely(offset == 0)) {
> +			info->active_bank++;
> +			iowrite8(info->active_bank, info->bank);
> +		}
> +	}
> +	mutex_unlock(&info->lock);
> +	*retlen = len;
> +	return 0;
> +}
> +
> +static int
> +lp8x4x_sram_read(struct mtd_info *mtd, loff_t from, size_t len,
> +		size_t *retlen, u_char *b)
> +{
> +	struct lp8x4x_sram_info *info = mtd->priv;
> +	unsigned bank = from >> 11;
> +	unsigned offset = (from & 0x7ff) << 1;
> +	loff_t i;
> +
> +	mutex_lock(&info->lock);
> +	if (unlikely(bank != info->active_bank)) {
> +		info->active_bank = bank;
> +		iowrite8(bank, info->bank);
> +	}
> +	for (i = 0; i < len; i++) {
> +		b[i] = ioread8(info->virt + offset);
> +		offset += 2;
> +		if (unlikely(offset == 0)) {
> +			info->active_bank++;
> +			iowrite8(info->active_bank, info->bank);
> +		}
> +	}
> +	mutex_unlock(&info->lock);
> +	*retlen = len;
> +	return 0;
> +}
> +
> +static struct of_device_id of_flash_match[] = {
> +	{
> +		.compatible	= "icpdas,sram-lp8x4x",
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_flash_match);
> +
> +static int
> +lp8x4x_sram_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct lp8x4x_sram_info *info;
> +	struct resource *res_virt, *res_bank;
> +	char sz_str[16];
> +	struct mtd_part_parser_data ppdata;
> +	int err = 0;
> +
> +	match = of_match_device(of_flash_match, &pdev->dev);
> +	if (!match)
> +		return -EINVAL;

Does this of_match_device() serve any particular purpose? Your driver
already matches against these IDs, and you're not actually retrieving
any of-data from the match, so this looks redundant.

> +
> +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	res_virt = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	info->virt =  devm_ioremap_resource(&pdev->dev, res_virt);
> +	if (IS_ERR(info->virt))
> +		return PTR_ERR(info->virt);
> +
> +	res_bank = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	info->bank = devm_ioremap_resource(&pdev->dev, res_bank);
> +	if (IS_ERR(info->bank))
> +		return PTR_ERR(info->bank);
> +
> +	info->mtd.priv = info;
> +	info->mtd.name = "SRAM";

Are you absolutely sure there is only ever a single SRAM device on a
given system? Because otherwise, you will get redundantly-named MTD's.
If the answer is no, you might consider a unique naming scheme.

> +	info->mtd.type = MTD_RAM;
> +	info->mtd.flags = MTD_CAP_RAM;
> +	info->mtd.size = resource_size(res_virt) << 7;
> +	info->mtd.erasesize = 512;
> +	info->mtd.writesize = 4;
> +	info->mtd._erase = lp8x4x_sram_erase;
> +	info->mtd._write = lp8x4x_sram_write;
> +	info->mtd._read = lp8x4x_sram_read;
> +	info->mtd.owner = THIS_MODULE;
> +
> +	mutex_init(&info->lock);
> +	iowrite8(info->active_bank, info->bank);
> +	platform_set_drvdata(pdev, info);
> +
> +	ppdata.of_node = pdev->dev.of_node;
> +	err = mtd_device_parse_register(&info->mtd, NULL, &ppdata,
> +			NULL, 0);
> +
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to register MTD\n");
> +		return err;
> +	}
> +
> +	string_get_size(info->mtd.size, STRING_UNITS_2, sz_str,
> +			sizeof(sz_str));
> +	dev_info(&pdev->dev, "using %s SRAM on LP-8X4X as %s\n", sz_str,
> +			dev_name(&info->mtd.dev));
> +	return 0;
> +}
> +
> +static int
> +lp8x4x_sram_remove(struct platform_device *dev)
> +{
> +	struct lp8x4x_sram_info *info = platform_get_drvdata(dev);
> +	return mtd_device_unregister(&info->mtd);
> +}
> +
> +static struct platform_driver lp8x4x_sram_driver = {
> +	.driver = {
> +		.name		= "sram-lp8x4x",
> +		.owner		= THIS_MODULE,
> +		.of_match_table = of_flash_match,
> +	},
> +	.probe		= lp8x4x_sram_probe,
> +	.remove		= lp8x4x_sram_remove,
> +};
> +
> +module_platform_driver(lp8x4x_sram_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
> +MODULE_DESCRIPTION("MTD driver for SRAM on ICPDAS LP-8x4x");

Thanks,
Brian
