Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaE3OA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:00:28 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44303 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaE3OA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:00:27 -0400
Message-ID: <53888EF5.5090800@collabora.co.uk>
Date: Fri, 30 May 2014 16:00:21 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: olof@lixom.net, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: exynos5420: Keep aclk66_peric enabled during boot
References: <1401398496-4624-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1401398496-4624-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 05/29/2014 11:21 PM, Doug Anderson wrote:
> Right now if you've got earlyprintk enabled on exynos5420-peach-pit
> then you'll get a hang on boot.  Here's why:
> 
> 1. The i2c-s3c2410 driver will probe at subsys_initcall.  It will
>    enable its clock and disable it.  This is the clock "i2c2".
> 2. The act of disabling "i2c2" will disable its parents.  In this case
>    the parent is "aclk66_peric".  There are no other children of
>    "aclk66_peric" officially enabled, so "aclk66_peric" will be turned
>    off (despite being CLK_IGNORE_UNUSED, but that's by design).
> 3. The next time you try to earlyprintk you'll do so without the UART
>    clock enabled.  That's because the UART clocks are also children of
>    "aclk66_peric".  You'll hang.
> 
> There's no good place to put a clock enable for earlyprintk, which is
> handled by a bunch of assembly code.  The best we can do is to handle
> this in the clock driver.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/clk/samsung/clk-exynos5420.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 

I tested your patch and it solves the issue for me, so feel free to add

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Just one trivial comment below:

> diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
> index 9d7d7ee..1e586be 100644
> --- a/drivers/clk/samsung/clk-exynos5420.c
> +++ b/drivers/clk/samsung/clk-exynos5420.c
> @@ -1172,11 +1172,17 @@ static struct of_device_id ext_clk_match[] __initdata = {
>  	{ },
>  };
>  
> +/* Keep these clocks on until late_initcall */
> +static const char *boot_clocks[] __initconst = {
> +	"aclk66_peric",
> +};
> +
>  /* register exynos5420 clocks */
>  static void __init exynos5x_clk_init(struct device_node *np,
>  		enum exynos5x_soc soc)
>  {
>  	struct samsung_clk_provider *ctx;
> +	int i;
>  
>  	if (np) {
>  		reg_base = of_iomap(np, 0);
> @@ -1226,6 +1232,12 @@ static void __init exynos5x_clk_init(struct device_node *np,
>  	}
>  
>  	exynos5420_clk_sleep_init();
> +
> +	for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
> +		struct clk *to_enable = __clk_lookup(boot_clocks[i]);
> +
> +		clk_prepare_enable(to_enable);
> +	}
>  }
>  
>  static void __init exynos5420_clk_init(struct device_node *np)
> @@ -1239,3 +1251,15 @@ static void __init exynos5800_clk_init(struct device_node *np)
>  	exynos5x_clk_init(np, EXYNOS5800);
>  }
>  CLK_OF_DECLARE(exynos5800_clk, "samsung,exynos5800-clock", exynos5800_clk_init);
> +
> +static int __init exynos5420_clk_late_init(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
> +		struct clk *to_disable = __clk_lookup(boot_clocks[i]);
> +
> +		clk_disable_unprepare(to_disable);
> +	}
> +}
> +late_initcall(exynos5420_clk_late_init);
> 

You should return 0 here.

Best regards,
Javier
