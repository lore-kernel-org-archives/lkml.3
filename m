Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3LBUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:21:33 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63564 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3LBUVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:21:23 -0500
Date: Mon, 2 Dec 2013 12:21:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset
 the system
Message-ID: <20131202202120.GA23611@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386008082-28740-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 10:14:41AM -0800, Doug Anderson wrote:
> A good watchdog driver is supposed to report when it was responsible
> for resetting the system.  Implement this for the s3c2410, at least on
> exynos5250 and exynos5420 where we already have a pointer to the PMU
> registers to read the information.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> This patch is based atop Leela Krishna's recent series that ends with
> (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
> AKA <https://patchwork.kernel.org/patch/3251861/>.
> 
>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> index 47f4dcf..2c87d37 100644
> --- a/drivers/watchdog/s3c2410_wdt.c
> +++ b/drivers/watchdog/s3c2410_wdt.c
> @@ -62,9 +62,13 @@
>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
>  
> +#define RST_STAT_REG_OFFSET		0x0404
>  #define WDT_DISABLE_REG_OFFSET		0x0408
>  #define WDT_MASK_RESET_REG_OFFSET	0x040c
>  #define QUIRK_NEEDS_PMU_CONFIG		(1 << 0)
> +#define QUIRK_HAS_RST_STAT		(1 << 1)
> +#define QUIRKS_NEED_PMUREG		(QUIRK_NEEDS_PMU_CONFIG | \
> +					 QUIRK_HAS_RST_STAT)
>  
I am not really happy about the NEED (both of them, really) here.
How about HAS instead ?

>  static bool nowayout	= WATCHDOG_NOWAYOUT;
>  static int tmr_margin;
> @@ -98,6 +102,9 @@ MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
>   * timer reset functionality.
>   * @mask_bit: Bit number for the watchdog timer in the disable register and the
>   * mask reset register.
> + * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
> + * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
> + * reset.
>   * @quirks: A bitfield of quirks.
>   */
>  
> @@ -105,6 +112,8 @@ struct s3c2410_wdt_variant {
>  	int disable_reg;
>  	int mask_reset_reg;
>  	int mask_bit;
> +	int rst_stat_reg;
> +	int rst_stat_bit;
>  	u32 quirks;
>  };
>  
> @@ -131,14 +140,20 @@ static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
>  	.disable_reg = WDT_DISABLE_REG_OFFSET,
>  	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
>  	.mask_bit = 20,
> -	.quirks = QUIRK_NEEDS_PMU_CONFIG
> +	.rst_stat_reg = RST_STAT_REG_OFFSET,
> +	.rst_stat_bit = 20,
> +	.quirks = QUIRK_NEEDS_PMU_CONFIG |
> +		QUIRK_HAS_RST_STAT,

Why not use QUIRKS_NEED_PMUREG ?

Also, is there ever a chance that the two bits don't come together ?
If not a single bit might be sufficient.

Thanks,
Guenter

>  };
>  
>  static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
>  	.disable_reg = WDT_DISABLE_REG_OFFSET,
>  	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
>  	.mask_bit = 0,
> -	.quirks = QUIRK_NEEDS_PMU_CONFIG
> +	.rst_stat_reg = RST_STAT_REG_OFFSET,
> +	.rst_stat_bit = 9,
> +	.quirks = QUIRK_NEEDS_PMU_CONFIG |
> +		QUIRK_HAS_RST_STAT,
>  };
>  
>  static const struct of_device_id s3c2410_wdt_match[] = {
> @@ -423,6 +438,25 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
>  }
>  #endif
>  
> +static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
> +{
> +	unsigned int bootstatus = 0;
> +	int ret;
> +
> +	if (wdt->drv_data->quirks & QUIRK_HAS_RST_STAT) {
> +		unsigned int rst_stat;
> +
> +		ret = regmap_read(wdt->pmureg, wdt->drv_data->rst_stat_reg,
> +				  &rst_stat);
> +		if (ret)
> +			dev_warn(wdt->dev, "Couldn't get RST_STAT register\n");
> +		else if (rst_stat & BIT(wdt->drv_data->rst_stat_bit))
> +			bootstatus |= WDIOF_CARDRESET;
> +	}
> +
> +	return bootstatus;
> +}
> +
>  /* s3c2410_get_wdt_driver_data */
>  static inline struct s3c2410_wdt_variant *
>  get_wdt_drv_data(struct platform_device *pdev)
> @@ -460,7 +494,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
>  	wdt->wdt_device = s3c2410_wdd;
>  
>  	wdt->drv_data = get_wdt_drv_data(pdev);
> -	if (wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG) {
> +	if (wdt->drv_data->quirks & QUIRKS_NEED_PMUREG) {
>  		wdt->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
>  							"samsung,syscon-phandle");
>  		if (IS_ERR(wdt->pmureg)) {
> @@ -531,6 +565,8 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
>  
>  	watchdog_set_nowayout(&wdt->wdt_device, nowayout);
>  
> +	wdt->wdt_device.bootstatus = s3c2410wdt_get_bootstatus(wdt);
> +
>  	ret = watchdog_register_device(&wdt->wdt_device);
>  	if (ret) {
>  		dev_err(dev, "cannot register watchdog (%d)\n", ret);
> -- 
> 1.8.4.1
> 
> 
