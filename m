Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3K0Iij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:38:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33818 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3K0Iig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:38:36 -0500
Message-ID: <5295AECB.7040503@ti.com>
Date: Wed, 27 Nov 2013 14:05:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ARM: davinci: aemif: get rid of davinci-nand driver dependency
 on aemif
References: <5291CB01.1010506@ti.com> <1385409654-19006-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385409654-19006-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ MTD maintainers

On Tuesday 26 November 2013 01:30 AM, Ivan Khoronzhuk wrote:
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
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  arch/arm/mach-davinci/aemif.c                   |   73 ++++++++++++++++++++++-
>  arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>  arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>  arch/arm/mach-davinci/board-dm355-evm.c         |    5 ++
>  arch/arm/mach-davinci/board-dm355-leopard.c     |    5 ++
>  arch/arm/mach-davinci/board-dm365-evm.c         |    4 ++
>  arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>  arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
>  arch/arm/mach-davinci/board-mityomapl138.c      |    3 +
>  arch/arm/mach-davinci/board-neuros-osd2.c       |    9 ++-
>  arch/arm/mach-davinci/devices-tnetv107x.c       |    3 +
>  drivers/mtd/nand/davinci_nand.c                 |   23 -------
>  include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
>  13 files changed, 116 insertions(+), 28 deletions(-)

[...]

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
> +	int ret = 0;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot get IORESOURCE_MEM\n");
> +		return -ENOMEM;
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

The AEMIF clock has to be enabled before this. The NAND driver might
load much later.

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
> +err:
> +	iounmap(base);
> +	return ret;
> +}
> +EXPORT_SYMBOL(davinci_aemif_setup);

No need to export this symbol as nothing apart from platform code uses it.

>  static const short mityomap_mii_pins[] = {
> diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
> index bb680af..a7d6668 100644
> --- a/arch/arm/mach-davinci/board-neuros-osd2.c
> +++ b/arch/arm/mach-davinci/board-neuros-osd2.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_data/mmc-davinci.h>
>  #include <linux/platform_data/mtd-davinci.h>
>  #include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -192,9 +193,15 @@ static __init void davinci_ntosd2_init(void)
>  		davinci_cfg_reg(DM644X_ATAEN_DISABLE);
>  
>  		/* only one device will be jumpered and detected */
> -		if (HAS_NAND)
> +		if (HAS_NAND) {
>  			platform_device_register(
>  					&davinci_ntosd2_nandflash_device);
> +
> +			if (davinci_aemif_setup(
> +				&davinci_ntosd2_nandflash_device))
> +				pr_warn("%s: Cannot configure AEMIF.\n",
> +					__func__);

This is looking really ugly. Can you shorten
davinci_ntosd2_nandflash_device to just "ntosd2_nandflash" or similar?

I am yet to test this. Will test once the next version is posted.

Overall, I cannot say I am fan of this approach (mostly because we are
ending up having two drivers for the same hardware in kernel). But given
that the other option of adding platform device support to AEMIF driver
is not acceptable to you, I guess I will live with this.

Thanks,
Sekhar
