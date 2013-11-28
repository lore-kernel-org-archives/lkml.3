Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3K1KsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:48:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39346 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3K1KsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:48:15 -0500
Message-ID: <52971EF2.5030500@ti.com>
Date: Thu, 28 Nov 2013 12:46:10 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: <nsekhar@ti.com>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v2] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ CC Santosh Shilimkar

On 11/27/2013 04:31 PM, Ivan Khoronzhuk wrote:
> The problem that the set timings code contains the call of Davinci
> platform function davinci_aemif_setup_timing() which is not
> accessible if kernel is built for another platform like Keystone.
>
> The Keysone platform is going to use TI AEMIF driver.
> If TI AEMIF is used we don't need to set timings and bus width.
> It is done by AEMIF driver.
>
> To get rid of davinci-nand driver dependency on aemif platform code
> we moved aemif code to davinci platform.
>
> The platform AEMIF code (aemif.c) has to be removed once Davinci
> will be converted to DT and use ti-aemif.c driver.
>
> The long device name "davinci_ntosd2_nandflash_device" was renamed
> to "ntosd2_nandflash" as requested by Sekhar Nori, because after
> adding changes the line is so broken that its almost unreadable.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> v2..v1:
> - enabled AEMIF clock
> - removed EXPORT_SYMBOL(davinci_aemif_setup)
> - renamed ugly name davinci_ntosd2_nandflash_device
>
> CC:
> Sekhar Nori <nsekhar@ti.com>
>
>   arch/arm/mach-davinci/aemif.c                   |   89 ++++++++++++++++++++++-
>   arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>   arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>   arch/arm/mach-davinci/board-dm355-evm.c         |    5 ++
>   arch/arm/mach-davinci/board-dm355-leopard.c     |    5 ++
>   arch/arm/mach-davinci/board-dm365-evm.c         |    4 +
>   arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>   arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
>   arch/arm/mach-davinci/board-mityomapl138.c      |    3 +
>   arch/arm/mach-davinci/board-neuros-osd2.c       |   13 +++-
>   arch/arm/mach-davinci/devices-tnetv107x.c       |    3 +
>   drivers/mtd/nand/davinci_nand.c                 |   23 ------
>   include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
>   13 files changed, 133 insertions(+), 31 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
> index f091a90..64dccfc 100644
> --- a/arch/arm/mach-davinci/aemif.c
> +++ b/arch/arm/mach-davinci/aemif.c
> @@ -16,6 +16,7 @@
>   #include <linux/time.h>
>
>   #include <linux/platform_data/mtd-davinci-aemif.h>
> +#include <linux/platform_data/mtd-davinci.h>
>
>   /* Timing value configuration */
>
> @@ -43,6 +44,17 @@
>   				WSTROBE(WSTROBE_MAX) | \
>   				WSETUP(WSETUP_MAX))
>
> +static inline unsigned int davinci_aemif_readl(void __iomem *base, int offset)
> +{
> +	return readl_relaxed(base + offset);
> +}
> +
> +static inline void davinci_aemif_writel(void __iomem *base,
> +					int offset, unsigned long value)
> +{
> +	writel_relaxed(value, base + offset);
> +}
> +
>   /*
>    * aemif_calc_rate - calculate timing data.
>    * @wanted: The cycle time needed in nanoseconds.
> @@ -86,7 +98,7 @@ static int aemif_calc_rate(int wanted, unsigned long clk, int max)
>    *
>    * Returns 0 on success, else negative errno.
>    */
> -int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
> +static int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
>   					void __iomem *base, unsigned cs)
>   {
>   	unsigned set, val;
> @@ -130,4 +142,77 @@ int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
>
>   	return 0;
>   }
> -EXPORT_SYMBOL(davinci_aemif_setup_timing);
> +
> +/**
> + * davinci_aemif_setup - setup AEMIF interface by davinci_nand_pdata
> + * @pdev - link to platform device to setup settings for
> + *
> + * This function does not use any locking while programming the AEMIF
> + * because it is expected that there is only one user of a given
> + * chip-select.
> + *
> + * Returns 0 on success, else negative errno.
> + */
> +int davinci_aemif_setup(struct platform_device *pdev)
> +{
> +	struct davinci_nand_pdata *pdata = dev_get_platdata(&pdev->dev);
> +	uint32_t val;
> +	struct resource	*res;
> +	void __iomem *base;
> +	struct clk* clk;
> +	int ret = 0;
> +
> +	clk = clk_get(&pdev->dev, "aemif");
> +	if (IS_ERR(clk)) {
> +		ret = PTR_ERR(clk);
> +		dev_dbg(&pdev->dev, "unable to get AEMIF clock, err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(clk);
> +	if (ret < 0) {
> +		dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot get IORESOURCE_MEM\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	base = ioremap(res->start, resource_size(res));
> +	if (!base) {
> +		dev_err(&pdev->dev, "ioremap failed for resource %pR\n", res);
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	/*
> +	 * Setup Async configuration register in case we did not boot
> +	 * from NAND and so bootloader did not bother to set it up.
> +	 */
> +	val = davinci_aemif_readl(base, A1CR_OFFSET + pdev->id * 4);
> +	/*
> +	 * Extended Wait is not valid and Select Strobe mode is not
> +	 * used
> +	 */
> +	val &= ~(ACR_ASIZE_MASK | ACR_EW_MASK | ACR_SS_MASK);
> +	if (pdata->options & NAND_BUSWIDTH_16)
> +		val |= 0x1;
> +
> +	davinci_aemif_writel(base, A1CR_OFFSET + pdev->id * 4, val);
> +
> +	if (pdata->timing)
> +		ret = davinci_aemif_setup_timing(pdata->timing, base, pdev->id);
> +
> +	if (ret < 0)
> +		dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
> +
> +	iounmap(base);
> +err:
> +	clk_disable_unprepare(clk);
> +	return ret;
> +}
> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
> index d1f45af..5623131 100644
> --- a/arch/arm/mach-davinci/board-da830-evm.c
> +++ b/arch/arm/mach-davinci/board-da830-evm.c
> @@ -419,6 +419,9 @@ static inline void da830_evm_init_nand(int mux_mode)
>   	if (ret)
>   		pr_warning("da830_evm_init: NAND device not registered.\n");
>
> +	if (davinci_aemif_setup(&da830_evm_nand_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
> +
>   	gpio_direction_output(mux_mode, 1);
>   }
>   #else
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index e0af0ec..234c5bb 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -358,6 +358,9 @@ static inline void da850_evm_setup_nor_nand(void)
>
>   		platform_add_devices(da850_evm_devices,
>   					ARRAY_SIZE(da850_evm_devices));
> +
> +		if (davinci_aemif_setup(&da850_evm_nandflash_device))
> +			pr_warn("%s: Cannot configure AEMIF.\n", __func__);
>   	}
>   }
>
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index ecdc7d4..f35095f 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -27,6 +27,7 @@
>   #include <linux/platform_data/mtd-davinci.h>
>   #include <linux/platform_data/mmc-davinci.h>
>   #include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>
>   #include <asm/mach-types.h>
>   #include <asm/mach/arch.h>
> @@ -395,6 +396,10 @@ static __init void dm355_evm_init(void)
>
>   	platform_add_devices(davinci_evm_devices,
>   			     ARRAY_SIZE(davinci_evm_devices));
> +
> +	if (davinci_aemif_setup(&davinci_nand_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
> +
>   	evm_init_i2c();
>   	davinci_serial_init(dm355_serial_device);
>
> diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
> index 43bacbf..7f45c5a 100644
> --- a/arch/arm/mach-davinci/board-dm355-leopard.c
> +++ b/arch/arm/mach-davinci/board-dm355-leopard.c
> @@ -23,6 +23,7 @@
>   #include <linux/platform_data/mmc-davinci.h>
>   #include <linux/platform_data/mtd-davinci.h>
>   #include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>
>   #include <asm/mach-types.h>
>   #include <asm/mach/arch.h>
> @@ -253,6 +254,10 @@ static __init void dm355_leopard_init(void)
>
>   	platform_add_devices(davinci_leopard_devices,
>   			     ARRAY_SIZE(davinci_leopard_devices));
> +
> +	if (davinci_aemif_setup(&davinci_nand_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
> +
>   	leopard_init_i2c();
>   	davinci_serial_init(dm355_serial_device);
>
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index e08a868..88c01c3 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -39,6 +39,7 @@
>   #include <linux/platform_data/mmc-davinci.h>
>   #include <linux/platform_data/mtd-davinci.h>
>   #include <linux/platform_data/keyscan-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>
>   #include <media/ths7303.h>
>   #include <media/tvp514x.h>
> @@ -665,6 +666,9 @@ fail:
>
>   		platform_add_devices(dm365_evm_nand_devices,
>   				ARRAY_SIZE(dm365_evm_nand_devices));
> +
> +		if (davinci_aemif_setup(&davinci_nand_device))
> +			pr_warn("%s: Cannot configure AEMIF.\n", __func__);
>   	} else {
>   		/* no OneNAND support yet */
>   	}
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index 987605b7..5602957 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -778,6 +778,11 @@ static __init void davinci_evm_init(void)
>   		/* only one device will be jumpered and detected */
>   		if (HAS_NAND) {
>   			platform_device_register(&davinci_evm_nandflash_device);
> +
> +			if (davinci_aemif_setup(&davinci_evm_nandflash_device))
> +				pr_warn("%s: Cannot configure AEMIF.\n",
> +					__func__);
> +
>   			evm_leds[7].default_trigger = "nand-disk";
>   			if (HAS_NOR)
>   				pr_warning("WARNING: both NAND and NOR flash "
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 13d0801..ae129bc 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -805,6 +805,9 @@ static __init void evm_init(void)
>
>   	platform_device_register(&davinci_nand_device);
>
> +	if (davinci_aemif_setup(&davinci_nand_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
> +
>   	dm646x_init_edma(dm646x_edma_rsv);
>
>   	if (HAS_ATA)
> diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
> index 7aa105b..98a66ff 100644
> --- a/arch/arm/mach-davinci/board-mityomapl138.c
> +++ b/arch/arm/mach-davinci/board-mityomapl138.c
> @@ -432,6 +432,9 @@ static void __init mityomapl138_setup_nand(void)
>   {
>   	platform_add_devices(mityomapl138_devices,
>   				 ARRAY_SIZE(mityomapl138_devices));
> +
> +	if (davinci_aemif_setup(&mityomapl138_nandflash_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
>   }
>
>   static const short mityomap_mii_pins[] = {
> diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
> index bb680af..829ee07 100644
> --- a/arch/arm/mach-davinci/board-neuros-osd2.c
> +++ b/arch/arm/mach-davinci/board-neuros-osd2.c
> @@ -31,6 +31,7 @@
>   #include <linux/platform_data/mmc-davinci.h>
>   #include <linux/platform_data/mtd-davinci.h>
>   #include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>
>   #include <asm/mach-types.h>
>   #include <asm/mach/arch.h>
> @@ -105,7 +106,7 @@ static struct resource davinci_ntosd2_nandflash_resource[] = {
>   	},
>   };
>
> -static struct platform_device davinci_ntosd2_nandflash_device = {
> +static struct platform_device ntosd2_nandflash = {
>   	.name		= "davinci_nand",
>   	.id		= 0,
>   	.dev		= {
> @@ -192,9 +193,13 @@ static __init void davinci_ntosd2_init(void)
>   		davinci_cfg_reg(DM644X_ATAEN_DISABLE);
>
>   		/* only one device will be jumpered and detected */
> -		if (HAS_NAND)
> -			platform_device_register(
> -					&davinci_ntosd2_nandflash_device);
> +		if (HAS_NAND) {
> +			platform_device_register(&ntosd2_nandflash);
> +
> +			if (davinci_aemif_setup(&ntosd2_nandflash))
> +				pr_warn("%s: Cannot configure AEMIF.\n",
> +					__func__);
> +		}
>   	}
>
>   	platform_add_devices(davinci_ntosd2_devices,
> diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
> index 01d8686..de4862e 100644
> --- a/arch/arm/mach-davinci/devices-tnetv107x.c
> +++ b/arch/arm/mach-davinci/devices-tnetv107x.c
> @@ -324,6 +324,9 @@ static int __init nand_init(int chipsel, struct davinci_nand_pdata *data)
>   		return ret;
>   	}
>
> +	if (davinci_aemif_setup(pdev))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
> +
>   	return platform_device_register(pdev);
>   }
>
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index b77a01e..6cc506c 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -734,28 +734,6 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>   		goto err_clk_enable;
>   	}
>
> -	/*
> -	 * Setup Async configuration register in case we did not boot from
> -	 * NAND and so bootloader did not bother to set it up.
> -	 */
> -	val = davinci_nand_readl(info, A1CR_OFFSET + info->core_chipsel * 4);
> -
> -	/* Extended Wait is not valid and Select Strobe mode is not used */
> -	val &= ~(ACR_ASIZE_MASK | ACR_EW_MASK | ACR_SS_MASK);
> -	if (info->chip.options & NAND_BUSWIDTH_16)
> -		val |= 0x1;
> -
> -	davinci_nand_writel(info, A1CR_OFFSET + info->core_chipsel * 4, val);
> -
> -	ret = 0;
> -	if (info->timing)
> -		ret = davinci_aemif_setup_timing(info->timing, info->base,
> -							info->core_chipsel);
> -	if (ret < 0) {
> -		dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
> -		goto err_timing;
> -	}
> -
>   	spin_lock_irq(&davinci_nand_lock);
>
>   	/* put CSxNAND into NAND mode */
> @@ -844,7 +822,6 @@ syndrome_done:
>   	return 0;
>
>   err_scan:
> -err_timing:
>   	clk_disable_unprepare(info->clk);
>
>   err_clk_enable:
> diff --git a/include/linux/platform_data/mtd-davinci-aemif.h b/include/linux/platform_data/mtd-davinci-aemif.h
> index 05b2934..97948ac 100644
> --- a/include/linux/platform_data/mtd-davinci-aemif.h
> +++ b/include/linux/platform_data/mtd-davinci-aemif.h
> @@ -10,6 +10,8 @@
>   #ifndef _MACH_DAVINCI_AEMIF_H
>   #define _MACH_DAVINCI_AEMIF_H
>
> +#include <linux/platform_device.h>
> +
>   #define NRCSR_OFFSET		0x00
>   #define AWCCR_OFFSET		0x04
>   #define A1CR_OFFSET		0x10
> @@ -31,6 +33,5 @@ struct davinci_aemif_timing {
>   	u8	ta;
>   };
>
> -int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
> -					void __iomem *base, unsigned cs);
> +int davinci_aemif_setup(struct platform_device *pdev);
>   #endif
>


-- 
Regards,
Ivan Khoronzhuk
