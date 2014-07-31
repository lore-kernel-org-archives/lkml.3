Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaGaI0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:26:50 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38381 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaGaI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:26:45 -0400
Date: Thu, 31 Jul 2014 09:26:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: tthayer@opensource.altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@altera.com, delicious.quinoa@gmail.com,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, sameo@linux.intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com,
        Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCHv9 1/3] mfd: altera: Add Altera SDRAM Controller
Message-ID: <20140731082637.GH9030@lee--X1>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
 <1406744573-609-2-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406744573-609-2-git-send-email-tthayer@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, tthayer@opensource.altera.com wrote:

> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> Add a simple MFD for the Altera SDRAM Controller.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v1-8: The MFD implementation was not included in the original series.
> 
> v9: New MFD implementation.
> ---
>  MAINTAINERS                    |    5 ++
>  drivers/mfd/Kconfig            |    7 ++
>  drivers/mfd/Makefile           |    1 +
>  drivers/mfd/altera-sdr.c       |  162 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/altera-sdr.h |  102 +++++++++++++++++++++++++
>  5 files changed, 277 insertions(+)
>  create mode 100644 drivers/mfd/altera-sdr.c
>  create mode 100644 include/linux/mfd/altera-sdr.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 86efa7e..48a8923 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1340,6 +1340,11 @@ M:	Dinh Nguyen <dinguyen@altera.com>
>  S:	Maintained
>  F:	drivers/clk/socfpga/
>  
> +ARM/SOCFPGA SDRAM CONTROLLER SUPPORT
> +M:	Thor Thayer <tthayer@altera.com>
> +S:	Maintained
> +F:	drivers/mfd/altera-sdr.c
> +
>  ARM/STI ARCHITECTURE
>  M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
>  M:	Maxime Coquelin <maxime.coquelin@st.com>

This should be in a separate patch.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 6cc4b6a..8ce4961 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -719,6 +719,13 @@ config MFD_STMPE
>  		Keypad: stmpe-keypad
>  		Touchscreen: stmpe-ts
>  
> +config MFD_ALTERA_SDR
> +	bool "Altera SDRAM Controller MFD"
> +	depends on ARCH_SOCFPGA
> +	select MFD_CORE
> +	help
> +	  Support for Altera SDRAM Controller (SDR) MFD.
> +
>  menu "STMicroelectronics STMPE Interface Drivers"
>  depends on MFD_STMPE
>  
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8afedba..24cc2b7 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -169,3 +169,4 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
> +obj-$(CONFIG_MFD_ALTERA_SDR)	+= altera-sdr.o
> diff --git a/drivers/mfd/altera-sdr.c b/drivers/mfd/altera-sdr.c
> new file mode 100644
> index 0000000..b5c6646
> --- /dev/null
> +++ b/drivers/mfd/altera-sdr.c
> @@ -0,0 +1,162 @@
> +/*
> + * SDRAM Controller (SDR) MFD
> + *
> + * Copyright (C) 2014 Altera Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.

Can you use the shorter version of the licence?

> + */

'\n' here.

> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/altera-sdr.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +static const struct mfd_cell altera_sdr_devs[] = {
> +#if defined(CONFIG_EDAC_ALTERA_MC)

No need to do this, as it will only be matched if the driver is
enabled.  Please remove the #iffery.

> +	{
> +		.name = "altr_sdram_edac",
> +		.of_compatible = "altr,sdram-edac",

What other devices will there be?

> +	},
> +#endif
> +};
> +
> +u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset)
> +{
> +	return readl(sdr->reg_base + reg_offset);
> +}
> +EXPORT_SYMBOL_GPL(altera_sdr_readl);
> +
> +void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value)
> +{
> +	writel(value, sdr->reg_base + reg_offset);
> +}
> +EXPORT_SYMBOL_GPL(altera_sdr_writel);

Why are you abstracting these?

Might be better to use Regmap even.

> +/* Get total memory size in bytes */
> +u32 altera_sdr_mem_size(struct altera_sdr *sdr)
> +{
> +	u32 size;
> +	u32 read_reg, row, bank, col, cs, width;

Weird that size is on its own.  Either place on a single line or
separate them all.

> +	read_reg = altera_sdr_readl(sdr, SDR_DRAMADDRW_OFST);
> +	if (read_reg < 0)
> +		return 0;
> +
> +	width = altera_sdr_readl(sdr, SDR_DRAMIFWIDTH_OFST);
> +	if (width < 0)
> +		return 0;
> +
> +	col = (read_reg & SDR_DRAMADDRW_COLBITS_MASK) >>
> +		SDR_DRAMADDRW_COLBITS_LSB;
> +	row = (read_reg & SDR_DRAMADDRW_ROWBITS_MASK) >>
> +		SDR_DRAMADDRW_ROWBITS_LSB;
> +	bank = (read_reg & SDR_DRAMADDRW_BANKBITS_MASK) >>
> +		SDR_DRAMADDRW_BANKBITS_LSB;
> +	cs = (read_reg & SDR_DRAMADDRW_CSBITS_MASK) >>
> +		SDR_DRAMADDRW_CSBITS_LSB;

These would probably be better as macros.

> +	/* Correct for ECC as its not addressible */
> +	if (width == SDR_DRAMIFWIDTH_32B_ECC)
> +		width = 32;
> +	if (width == SDR_DRAMIFWIDTH_16B_ECC)
> +		width = 16;
> +
> +	/* calculate the SDRAM size base on this info */
> +	size = 1 << (row + bank + col);
> +	size = size * cs * (width / 8);
> +	return size;
> +}
> +EXPORT_SYMBOL_GPL(altera_sdr_mem_size);

Should this really be done in here?  Isn't this an SDRAM function?

> +static int altera_sdr_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct altera_sdr *sdr;
> +	struct resource *res;
> +	void __iomem *base;
> +	int ret;
> +
> +	sdr = devm_kzalloc(dev, sizeof(*sdr), GFP_KERNEL);
> +	if (!sdr)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	base = devm_ioremap(dev, res->start, resource_size(res));

Instead use devm_ioremap_resource(), then you can omit the error
checking of platform_get_resource().

> +	if (!base)
> +		return -ENOMEM;
> +
> +	sdr->dev = &pdev->dev;

Either use 'dev' here, or remove the top line in this function and use
&pdev->dev everywhere.  I personally prefer the latter.

> +	sdr->reg_base = base;
> +
> +	ret = mfd_add_devices(sdr->dev, 0, altera_sdr_devs,
> +			      ARRAY_SIZE(altera_sdr_devs), NULL, 0, NULL);
> +	if (ret)
> +		dev_err(sdr->dev, "error adding devices");
> +
> +	platform_set_drvdata(pdev, sdr);
> +
> +	dev_dbg(dev, "Altera SDR MFD registered\n");
> +
> +	return 0;
> +}
> +
> +static int altera_sdr_remove(struct platform_device *pdev)
> +{
> +	struct altera_sdr *sdr = platform_get_drvdata(pdev);

No need for this, just use &pdev->dev.

> +	mfd_remove_devices(sdr->dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id of_altera_sdr_match[] = {
> +	{ .compatible = "altr,sdr", },
> +	{ },
> +};
> +
> +static const struct platform_device_id altera_sdr_ids[] = {
> +	{ "altera_sdr", },
> +	{ }
> +};

What's this for?

> +static struct platform_driver altera_sdr_driver = {
> +	.driver = {
> +		.name = "altera_sdr",
> +		.owner = THIS_MODULE,

You can remove this line, it's taken care of for you.

> +		.of_match_table = of_altera_sdr_match,
> +	},
> +	.probe		= altera_sdr_probe,
> +	.remove		= altera_sdr_remove,
> +	.id_table	= altera_sdr_ids,
> +};
> +
> +static int __init altera_sdr_init(void)
> +{
> +	return platform_driver_register(&altera_sdr_driver);
> +}
> +postcore_initcall(altera_sdr_init);

Why was this chosen?

> +static void __exit altera_sdr_exit(void)
> +{
> +	platform_driver_unregister(&altera_sdr_driver);
> +}
> +module_exit(altera_sdr_exit);
> +
> +MODULE_AUTHOR("Alan Tull <atull@altera.com>");
> +MODULE_DESCRIPTION("Altera SDRAM Controller (SDR) MFD");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/altera-sdr.h b/include/linux/mfd/altera-sdr.h
> new file mode 100644
> index 0000000..a5f5c39
> --- /dev/null
> +++ b/include/linux/mfd/altera-sdr.h
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright (C) 2014 Altera Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.

Use the short version.

> + */

'\n' here.

> +#ifndef __LINUX_MFD_ALTERA_SDR_H
> +#define __LINUX_MFD_ALTERA_SDR_H
> +
> +/* SDRAM Controller register offsets */
> +#define SDR_CTLCFG_OFST                 0x00
> +#define SDR_DRAMADDRW_OFST		0x2C
> +#define SDR_DRAMIFWIDTH_OFST		0x30
> +#define SDR_DRAMSTS_OFST                0x38
> +#define SDR_DRAMINTR_OFST               0x3C
> +#define SDR_SBECOUNT_OFST               0x40
> +#define SDR_DBECOUNT_OFST               0x44
> +#define SDR_ERRADDR_OFST                0x48
> +#define SDR_DROPCOUNT_OFST              0x4C
> +#define SDR_DROPADDR_OFST               0x50
> +#define SDR_CTRLGRP_LOWPWREQ_OFST       0x54
> +#define SDR_CTRLGRP_LOWPWRACK_OFST      0x58
> +
> +/* SDRAM Controller CtrlCfg Register Bit Masks */
> +#define SDR_CTLCFG_ECC_EN               0x400
> +#define SDR_CTLCFG_ECC_CORR_EN          0x800
> +#define SDR_CTLCFG_GEN_SB_ERR           0x2000
> +#define SDR_CTLCFG_GEN_DB_ERR           0x4000
> +
> +#define SDR_CTLCFG_ECC_AUTO_EN          (SDR_CTLCFG_ECC_EN | \
> +					 SDR_CTLCFG_ECC_CORR_EN)
> +
> +/* SDRAM Controller Address Widths Field Register */
> +#define SDR_DRAMADDRW_COLBITS_MASK      0x001F
> +#define SDR_DRAMADDRW_COLBITS_LSB       0
> +#define SDR_DRAMADDRW_ROWBITS_MASK      0x03E0
> +#define SDR_DRAMADDRW_ROWBITS_LSB       5
> +#define SDR_DRAMADDRW_BANKBITS_MASK     0x1C00
> +#define SDR_DRAMADDRW_BANKBITS_LSB      10
> +#define SDR_DRAMADDRW_CSBITS_MASK       0xE000
> +#define SDR_DRAMADDRW_CSBITS_LSB        13

We normally call _LSB, _SHIFT.

> +/* SDRAM Controller Interface Data Width Defines */
> +#define SDR_DRAMIFWIDTH_16B_ECC         24
> +#define SDR_DRAMIFWIDTH_32B_ECC         40
> +
> +/* SDRAM Controller DRAM Status Register Bit Masks */
> +#define SDR_DRAMSTS_SBEERR              0x04
> +#define SDR_DRAMSTS_DBEERR              0x08
> +#define SDR_DRAMSTS_CORR_DROP           0x10
> +
> +/* SDRAM Controller DRAM IRQ Register Bit Masks */
> +#define SDR_DRAMINTR_INTREN             0x01
> +#define SDR_DRAMINTR_SBEMASK            0x02
> +#define SDR_DRAMINTR_DBEMASK            0x04
> +#define SDR_DRAMINTR_CORRDROPMASK       0x08
> +#define SDR_DRAMINTR_INTRCLR            0x10
> +
> +/* SDRAM Controller Single Bit Error Count Register Bit Masks */
> +#define SDR_SBECOUNT_COUNT_MASK         0x0F
> +
> +/* SDRAM Controller Double Bit Error Count Register Bit Masks */
> +#define SDR_DBECOUNT_COUNT_MASK         0x0F
> +
> +/* SDRAM Controller ECC Error Address Register Bit Masks */
> +#define SDR_ERRADDR_ADDR_MASK           0xFFFFFFFF
> +
> +/* SDRAM Controller ECC Autocorrect Drop Count Register Bit Masks */
> +#define SDR_DROPCOUNT_CORRMASK          0x0F
> +
> +/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
> +#define SDR_DROPADDR_ADDR_MASK          0xFFFFFFFF
> +
> +#define SELFRSHREQ_POS                  3
> +#define SELFRSHREQ_MASK                 0x8
> +
> +#define SELFRFSHMASK_POS                4
> +#define SELFRFSHMASK_MASK               0x30
> +
> +#define SELFRFSHACK_POS                 1
> +#define SELFRFSHACK_MASK                0x2
> +
> +struct altera_sdr {
> +	struct device *dev;
> +	void __iomem *reg_base;
> +};
> +
> +/* Register access API */
> +u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset);
> +void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value);

Regmap?

> +u32 altera_sdr_mem_size(struct altera_sdr *sdr);
> +
> +#endif /* __LINUX_MFD_ALTERA_SDR_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
