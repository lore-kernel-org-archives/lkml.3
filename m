Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaHYJR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:17:28 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51164 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaHYJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:17:05 -0400
Message-ID: <53FAFF03.1000301@linaro.org>
Date: Mon, 25 Aug 2014 17:16:51 +0800
From: Guodong Xu <guodong.xu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lgirdwood@gmail.com,
        broonie@kernel.org, grant.likely@linaro.org, khilman@linaro.org,
        haojian.zhuang@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        axel.lin@ingics.com, zhangnian@huawei.com
Subject: Re: [PATCH v6 4/6] mfd: Add hi6421 PMIC core driver
References: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org> <1408367356-2628-5-git-send-email-guodong.xu@linaro.org> <20140820080912.GG4266@lee--X1>
In-Reply-To: <20140820080912.GG4266@lee--X1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Lee

Thanks. I added for most of your comments. Some items, I have a
different understanding. I added in below.

On 08/20/2014 04:09 PM, Lee Jones wrote:
> On Mon, 18 Aug 2014, Guodong Xu wrote:
>> This adds driver to support HiSilicon Hi6421 PMIC. Hi6421 includes multi-
>> functions, such as regulators, codec, ADCs, Coulomb counter, etc.
>> This driver includes core APIs _only_.
>>
>> Drivers for individul components, like voltage regulators, are
>> implemented in corresponding driver directories and files.
>>
>> Registers in Hi6421 are memory mapped, so using regmap-mmio API.
>>
>> Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/mfd/hi6421.txt |  37 +++++++
> 
> DT documentation should be in a patch of its own.
> 
> See: Documentation/devicetree/bindings/submitting-patches.txt
> 

Thanks. Will do.

>>  drivers/mfd/Kconfig                              |  13 +++
>>  drivers/mfd/Makefile                             |   1 +
>>  drivers/mfd/hi6421-pmic-core.c                   | 117 +++++++++++++++++++++++
>>  include/linux/mfd/hi6421-pmic.h                  |  39 ++++++++
>>  5 files changed, 207 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/hi6421.txt
>>  create mode 100644 drivers/mfd/hi6421-pmic-core.c
>>  create mode 100644 include/linux/mfd/hi6421-pmic.h
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/hi6421.txt b/Documentation/devicetree/bindings/mfd/hi6421.txt
>> new file mode 100644
>> index 0000000..1512123
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/hi6421.txt
>> @@ -0,0 +1,37 @@
>> +* HI6421 Multi-Functional Device (MFD), by HiSilicon Ltd.
>> +
>> +Required parent device properties:
>> +- reg		: register range space of hi6421;
> 
> You need to describe the compatible string here.
> 

Yes.

>> +Supported Hi6421 sub-devices include:
>> +
>> +Device                     IRQ Names              Supply Names   Description
>> +------                     ---------              ------------   -----------
>> +regulators               :                      :              : Regulators
> 
> If a cell has been intentionally left blank, put 'None' to be clear.
> 
> When will the other devices be added?
> 

RTC and irq will follow up next Month.

>> +Required child device properties:
>> +None.
>> +
>> +Example:
>> +	pmic: pmic@c00000 {
> 
> 24bit addressing?
> 

No. that's due to a range property in parent node. I will change it to
32-bit address.

> Is this node referenced by another node via phandle?  If not, you can
> drop the "pmic" label.  If it is referenced by another node, but there
> is more than one PMIC, label "pmic" won't do.
> 

ok. Will change node name to
 +               hi6421 {
...

>> +		compatible = "hisilicon,hi6421-pmic";
>> +		reg = <0xc00000 0x0180>; /* 0x60 << 2 */
>> +
>> +		regulators {
>> +			// supply for MLC NAND/ eMMC
>> +			hi6421_vout0_reg: hi6421_vout0 {
>> +				regulator-name = "VOUT0";
> 
> I may be mistaken, but "vout0" doesn't come across as a very good
> regulator name to me.
>

Right, but 'VOUT0' is the name used in hi4511 boards' schematic. So I
used this name to facilitate dts and board design matching.


>> +				regulator-min-microvolt = <2850000>;
>> +				regulator-max-microvolt = <2850000>;
>> +			};
>> +
>> +			// supply for 26M Oscillator
>> +			hi6421_vout1_reg: hi6421_vout1 {
>> +				regulator-name = "VOUT1";
>> +				regulator-min-microvolt = <1700000>;
>> +				regulator-max-microvolt = <2000000>;
>> +				regulator-boot-on;
>> +				regulator-always-on;
> 
> Again an assumption here, but doesn't 'egulator-always-on' insinuate
> 'regulator-boot-on', or does it simply mean "once it's on, it must
> stay on"?
>

>From Documentation/devicetree/bindings/regulator/regulator.txt,
- regulator-boot-on: bootloader/firmware enabled regulator
- regulator-always-on: boolean, regulator should never be disabled

'regulator-boot-on' is describing a board status, so I added it into dts
file. Although in kernel code there is no much operation depending on it.

>> +			};
>> +		};
>> +       	};
> 
> Your tabbing is out here.
> 

Sorry. will fix.

>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index de5abf2..347cbf6 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -210,6 +210,19 @@ config MFD_MC13XXX_I2C
>>  	help
>>  	  Select this if your MC13xxx is connected via an I2C bus.
>>  
>> +config MFD_HI6421_PMIC
>> +	tristate "HiSilicon Hi6421 PMU/Codec IC"
>> +	depends on OF
>> +	select MFD_CORE
>> +	select REGMAP_MMIO
>> +	help
>> +	  This driver supports HiSilicon Hi6421 PMIC. Hi6421 includes multi-
> 
> It doesn't support it, it adds support for it - subtle difference.
> 

Thanks, will fix.

>> +	  functions, such as regulators, codec, ADCs, Coulomb counter, etc.
>> +	  This driver includes core APIs _only_. You have to select
>> +	  individul components like voltage regulators under corresponding
>> +	  menus in order to enable them.
>> +	  Memory-mapped I/O is the way to communicate with Hi6421.
> 
> "We communicate with the Hi6421 via memory-mapped I/O." 
> 
>>  config HTC_EGPIO
>>  	bool "HTC EGPIO support"
>>  	depends on GPIOLIB && ARM
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index f001487..dc59efd 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>>  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>>  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>>  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>> +obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
>>  
>>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
>> diff --git a/drivers/mfd/hi6421-pmic-core.c b/drivers/mfd/hi6421-pmic-core.c
>> new file mode 100644
>> index 0000000..2be4d3f
>> --- /dev/null
>> +++ b/drivers/mfd/hi6421-pmic-core.c
>> @@ -0,0 +1,117 @@
>> +/*
>> + * Device driver for Hi6421 IC
>> + *
>> + * Copyright (c) <2011-2014> HiSilicon Technologies Co., Ltd.
>> + *              http://www.hisilicon.com
>> + * Copyright (c) <2013-2014> Linaro Ltd.
>> + *              http://www.linaro.org
> 
> I'm not sure Linaro own the copyright to this driver.  It should still
> belong to HiSilicon.
> 

That was discussed with HiSilicon and agreement was we need both. The
driver code is a complete re-write by me. HiSilicon original driver is
reference for functionality understanding purpose.

>> + * Author: Guodong Xu <guodong.xu@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
> 
> This should also contain a link to the full licence.
> 
> See: COPYING
> 

Thanks. I checked COPYING, but there is no 'link' to full license. I
copied a link from other c source: http://www.gnu.org/licenses/
is that OK?

>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>> +#include <linux/mfd/hi6421-pmic.h>
>> +
>> +static struct of_device_id of_hi6421_pmic_match_tbl[] = {
>> +	{
>> +		.compatible = "hisilicon,hi6421-pmic",
>> +	},
> 
> This can be just one line.
> 
>> +	{ /* end */ }
> 
> No real need for this comment.
> 

Fixed.

>> +};
>> +
>> +static const struct mfd_cell hi6421_devs[] = {
>> +	{
>> +		.name = "hi6421-regulator",
>> +	},
> 
> Again, one line.
> 
>> +};
>> +
>> +static struct regmap_config hi6421_regmap_config = {
>> +	.reg_bits = 32,
>> +	.reg_stride = 4,
>> +	.val_bits = 8,
>> +	.max_register = HI6421_REG_TO_BUS_ADDR(0xFF),
> 
> 0xFF should really be defined.
> 
>> +};
>> +
>> +static int hi6421_pmic_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
> 
> You only use this a couple of times.  You use '&pdev->dev' more
> regularly. May as well remove it and just use '&pdev->dev' all
> the time.
> 

Right. Will fix.

>> +	struct hi6421_pmic *pmic = NULL;
> 
> No need to initialise this.
> 
>> +	struct resource *res;
>> +	void __iomem *base;
>> +	int ret;
>> +
>> +	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
>> +	if (!pmic) {
>> +		dev_err(dev, "cannot allocate hi6421_pmic device info\n");
> 
> No need to print out messages on OOM, the OS will do that for you.
> 
>> +		return -ENOMEM;
>> +	}
>> +
>> +	/* get resources */
> 
> This comment doesn't add to the code.  The name of the function call
> is clear enough.
> 
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (unlikely(!res)) {
> 
> Only 21 out of 1718 uses of platform_get_resource() use unlikely() to
> check the return value.  I think it's okay to drop it.
> 
>> +		dev_err(&pdev->dev, "Invalid mem resource.\n");
> 
> "No memory resource specified"?
> 
>> +		return -ENODEV;
>> +	}
> 
> Actually, scrap all that.  You can remove error checking altogether
> for platform_get_resource(), as devm_ioremap_resource() does it for
> you.  Code should read:
> 

Thanks. Will do.

>   res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   base = devm_ioremap_resource(dev, res);
>   if (IS_ERR(base))
> 	  return PTR_ERR(base);
> 
>> +	base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(base))
>> +		return PTR_ERR(base);
>> +
>> +	pmic->regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
>> +						 &hi6421_regmap_config);
>> +	if (IS_ERR(pmic->regmap)) {
>> +		dev_err(&pdev->dev, "regmap init failed: %ld\n",
>> +						PTR_ERR(pmic->regmap));
> 
> Can you break the line at the first ',/' and line up against '('?
> 
>> +		return PTR_ERR(pmic->regmap);
>> +	}
>> +
>> +	pmic->dev = dev;
>> +	platform_set_drvdata(pdev, pmic);
> 
> It's not _that_ important, but I like to see this at the end after you
> know everything else has succeeded.
>

When I move this after mfd_add_devices(), it fails to boot. In mfd
devices's probe, pmic->regmap is used.


>> +	/* set over-current protection debounce 8ms*/
> 
> Should be a ' ' between '8ms' and '*/'.
> 
>> +	regmap_update_bits(pmic->regmap, HI6421_OCP_DEB_CTRL_REG,
>> +		(HI6421_OCP_DEB_SEL_MASK | HI6421_OCP_EN_DEBOUNCE_MASK |
>> +		 HI6421_OCP_AUTO_STOP_MASK),
>> +		(HI6421_OCP_DEB_SEL_8MS | HI6421_OCP_EN_DEBOUNCE_ENABLE));
>> +
>> +	ret = mfd_add_devices(dev, 0, hi6421_devs,
>> +			ARRAY_SIZE(hi6421_devs), NULL, 0, NULL);
> 
> I'd like to see an error message if mfd_add_devices() fails.
> 

Will do.

>> +	return ret;
>> +}
>> +
>> +static int hi6421_pmic_remove(struct platform_device *pdev)
>> +{
>> +	mfd_remove_devices(&pdev->dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver hi6421_pmic_driver = {
>> +	.driver = {
>> +		.name	= "hi6421_pmic",
>> +		.owner  = THIS_MODULE,
> 
> This is taken care of for you, you can remove it.
> 

Will do.

>> +		.of_match_table = of_hi6421_pmic_match_tbl,
>> +	},
>> +	.probe	= hi6421_pmic_probe,
>> +	.remove	= hi6421_pmic_remove,
>> +};
>> +module_platform_driver(hi6421_pmic_driver);
>> +
>> +MODULE_AUTHOR("Guodong Xu <guodong.xu@linaro.org>");
>> +MODULE_DESCRIPTION("Hi6421 PMIC driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/include/linux/mfd/hi6421-pmic.h b/include/linux/mfd/hi6421-pmic.h
>> new file mode 100644
>> index 0000000..36bcb34
>> --- /dev/null
>> +++ b/include/linux/mfd/hi6421-pmic.h
>> @@ -0,0 +1,39 @@
>> +/*
>> + * Header file for device driver Hi6421 PMIC
>> + *
>> + * Copyright (c) <2011-2014> HiSilicon Technologies Co., Ltd.
>> + *              http://www.hisilicon.com
>> + * Copyright (c) <2013-2014> Linaro Ltd.
>> + *              http://www.linaro.org
>> + *
>> + * Author: Guodong Xu <guodong.xu@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef	__HI6421_PMIC_H
>> +#define	__HI6421_PMIC_H
>> +
>> +/* Hi6421 registers are mapped to memory bus in 4 bytes stride */
>> +#define HI6421_REG_TO_BUS_ADDR(x)	(x << 2)
>> +
>> +/* Hi6421 OCP (over current protection) and DEB (debounce) control register */
>> +#define	HI6421_OCP_DEB_CTRL_REG		HI6421_REG_TO_BUS_ADDR(0x51)
>> +#define	HI6421_OCP_DEB_SEL_MASK		(0x0C)
>> +#define HI6421_OCP_DEB_SEL_8MS		(0x00)
>> +#define HI6421_OCP_DEB_SEL_16MS		(0x04)
>> +#define HI6421_OCP_DEB_SEL_32MS		(0x08)
>> +#define HI6421_OCP_DEB_SEL_64MS		(0x0C)
>> +#define HI6421_OCP_EN_DEBOUNCE_MASK	(0x02)
>> +#define HI6421_OCP_EN_DEBOUNCE_ENABLE	(0x02)
>> +#define HI6421_OCP_AUTO_STOP_MASK	(0x01)
>> +#define HI6421_OCP_AUTO_STOP_ENABLE	(0x01)
> 
> Remove the ()'s.
> 

Will do.

Thanks.
Guodong

>> +struct hi6421_pmic {
>> +	struct device		*dev;
>> +	struct regmap		*regmap;
>> +};
>> +
>> +#endif		/* __HI6421_PMIC_H */
> 
