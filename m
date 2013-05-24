Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3EXLZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:25:31 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54436 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3EXLZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:25:30 -0400
Date: Fri, 24 May 2013 12:25:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, linus.walleij@linaro.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] ARM: ux500: Allow Snowball to pass its own regulator
 settings
Message-ID: <20130524112524.GX22683@gmail.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369226853-16978-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Lee Jones wrote:

> This patch fixes a bug introduced in the v3.10 merge window.
> 
> Currently the external regulator settings are passed though to the AB8500
> regulator driver regards of whether they can or should be used on any
> ux500 based platform. They are not applicable for the u8505 and when
> enabled, they turn off AUX2 which adversely affects the eMMC on Snowball.
> 
> The driver already knows that the external regulator settings are not
> appropriate for the u8505, however it's more difficult for driver code to
> distinguish between two different u8500 based platforms.
> 
> Using the new semantics, we can just not pass the external regulator
> initialisation values from platform code and the external regulator
> driver will know not to register them.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500-regulators.c |    8 ++++++++
>  arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
>  arch/arm/mach-ux500/board-mop500.c            |    2 ++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
> index b34441b..7399e90 100644
> --- a/arch/arm/mach-ux500/board-mop500-regulators.c
> +++ b/arch/arm/mach-ux500/board-mop500-regulators.c
> @@ -996,6 +996,14 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
>  	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
>  };
>  
> +/* External regulators turn off VAUX2 when in use on Snowball. */
> +struct ab8500_regulator_platform_data snowball_regulator_plat_data = {
> +	.reg_init               = ab8500_reg_init,
> +	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
> +	.regulator              = ab8500_regulators,
> +	.num_regulator          = ARRAY_SIZE(ab8500_regulators),
> +};
> +
>  struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
>  	.reg_init               = ab8505_reg_init,
>  	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
> diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
> index 039f513..6300e79 100644
> --- a/arch/arm/mach-ux500/board-mop500-regulators.h
> +++ b/arch/arm/mach-ux500/board-mop500-regulators.h
> @@ -16,6 +16,7 @@
>  
>  extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
>  extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
> +extern struct ab8500_regulator_platform_data snowball_regulator_plat_data;
>  extern struct regulator_init_data tps61052_regulator;
>  extern struct regulator_init_data gpio_en_3v3_regulator;
>  extern struct regulator_init_data sdi0_reg_init_data;
> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index 0b018c4..2d609d4 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -615,6 +615,8 @@ static void __init snowball_init_machine(void)
>  	struct device *parent = NULL;
>  	int i;
>  
> +	ab8500_platdata.regulator = &snowball_regulator_plat_data;
> +
>  	platform_device_register(&db8500_prcmu_device);
>  
>  	sdi0_reg_info.enable_gpio = SNOWBALL_SDMMC_EN_GPIO;

Please drop this patch, I have sent a better solution.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
