Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaAFKkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:40:39 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58404 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAFKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:40:37 -0500
Date: Mon, 6 Jan 2014 10:40:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 18/18] mfd: vexpress: Split sysreg functions into MFD cells
Message-ID: <20140106104030.GI23772@lee--X1>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-19-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387815830-8794-19-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch splits individual sysreg functions into
> separate MFD cells, which then become individual
> platform devices with their own drivers.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  .../devicetree/bindings/arm/vexpress-sysreg.txt    |  37 ++-
>  arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++++++-
>  arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++++++-
>  arch/arm/mach-vexpress/v2m.c                       |  23 +-
>  drivers/mfd/Kconfig                                |  11 +
>  drivers/mfd/Makefile                               |   2 +-
>  drivers/mfd/vexpress-sysreg.c                      | 247 +++++++++++++++------
>  include/linux/vexpress.h                           |  16 +-
>  8 files changed, 377 insertions(+), 111 deletions(-)

<snip>

> +static struct mfd_cell vexpress_sysreg_cells[] = {
> +	{
> +		.name = "syscon",
> +		.of_compatible = "arm,vexpress-sysreg,sys_id",
> +		.num_resources = 1,
> +		.resources = (struct resource []) {
> +			DEFINE_RES_MEM(SYS_ID, 0x4),
> +		},
> +		.platform_data = &vexpress_sysreg_sys_id_pdata,
> +		.pdata_size = sizeof(vexpress_sysreg_sys_id_pdata),

Not sure how comfortable I am with using Device Tree and populating
platform_data with information which by the looks of it you're
planning to make persistent. What's stopping you from using a DT
property to name the block, or better yet, just use the compatible
string? Also, won't naming these blocks in DT also aid other OSes?

<snip>

> +static int vexpress_sysreg_probe(struct platform_device *pdev)
>  {
> -	vexpress_sysreg_base = base;
> -	vexpress_sysreg_setup(NULL);
> +	struct resource *mem;
> +	void __iomem *base;
> +	struct bgpio_chip *mmc_gpio_chip;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem)
> +		return -EINVAL;
> +
> +	base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
> +	if (!base)
> +		return -ENOMEM;
> +
> +	vexpress_config_set_master(vexpress_sysreg_get_master(base));
> +
> +	/*
> +	 * Duplicated SYS_MCI pseudo-GPIO controller for compatibility with
> +	 * older trees using sysreg node for MMC control lines.
> +	 */
> +	mmc_gpio_chip = devm_kzalloc(&pdev->dev, sizeof(*mmc_gpio_chip),
> +			GFP_KERNEL);
> +	if (!mmc_gpio_chip)
> +		return -ENOMEM;
> +	bgpio_init(mmc_gpio_chip, &pdev->dev, 0x4, base + SYS_MCI, NULL,
> +			NULL, NULL, NULL, 0);
> +	mmc_gpio_chip->gc.ngpio = 2;
> +	gpiochip_add(&mmc_gpio_chip->gc);
> +
> +	return mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
> +			vexpress_sysreg_cells,
> +			ARRAY_SIZE(vexpress_sysreg_cells), mem, 0, 0);

Don't use 0 as NULL, you will cause a sparse error.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
