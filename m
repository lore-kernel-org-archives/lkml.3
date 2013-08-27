Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3H0XQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:16:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34399 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3H0XQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:16:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130827231612.8231.15073@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC v2 08/16] ARM: mxs: remove custom .init_time hook
Date: Tue, 27 Aug 2013 16:16:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-08-27 14:28:02)
> This patch converts clk-imx2[38] clocksource_of_init compatible init
> associated with fsl,imx2[38]-clkctrl. With arch/arm calling
> of_clk_init(NULL) from time_init(), we can now also remove custom
> .init_time hooks.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

Need Shawn's Ack for this as well.

> ---
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-mxs/mach-mxs.c |   13 -------------
>  drivers/clk/mxs/clk-imx23.c  |   16 +++++++---------
>  drivers/clk/mxs/clk-imx28.c  |   16 +++++++---------
>  include/linux/clk/mxs.h      |    2 --
>  4 files changed, 14 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
> index 98f6e2a..cc511a4 100644
> --- a/arch/arm/mach-mxs/mach-mxs.c
> +++ b/arch/arm/mach-mxs/mach-mxs.c
> @@ -13,8 +13,6 @@
>  #include <linux/clk.h>
>  #include <linux/clk/mxs.h>
>  #include <linux/clkdev.h>
> -#include <linux/clocksource.h>
> -#include <linux/clk-provider.h>
>  #include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/gpio.h>
> @@ -490,16 +488,6 @@ static void mxs_restart(enum reboot_mode mode, const char *cmd)
>         soft_restart(0);
>  }
>  
> -static void __init mxs_timer_init(void)
> -{
> -       if (of_machine_is_compatible("fsl,imx23"))
> -               mx23_clocks_init();
> -       else
> -               mx28_clocks_init();
> -       of_clk_init(NULL);
> -       clocksource_of_init();
> -}
> -
>  static const char *mxs_dt_compat[] __initdata = {
>         "fsl,imx28",
>         "fsl,imx23",
> @@ -508,7 +496,6 @@ static const char *mxs_dt_compat[] __initdata = {
>  
>  DT_MACHINE_START(MXS, "Freescale MXS (Device Tree)")
>         .handle_irq     = icoll_handle_irq,
> -       .init_time      = mxs_timer_init,
>         .init_machine   = mxs_machine_init,
>         .init_late      = mxs_pm_init,
>         .dt_compat      = mxs_dt_compat,
> diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
> index c396fe3..7eb1d1a 100644
> --- a/drivers/clk/mxs/clk-imx23.c
> +++ b/drivers/clk/mxs/clk-imx23.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk.h>
>  #include <linux/clk/mxs.h>
>  #include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> @@ -100,19 +101,17 @@ static enum imx23_clk clks_init_on[] __initdata = {
>         cpu, hbus, xbus, emi, uart,
>  };
>  
> -int __init mx23_clocks_init(void)
> +static void __init mx23_clocks_init(struct device_node *np)
>  {
> -       struct device_node *np;
>         u32 i;
>  
> +       clkctrl = of_iomap(np, 0);
> +       WARN_ON(!clkctrl);
> +
>         np = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
>         digctrl = of_iomap(np, 0);
>         WARN_ON(!digctrl);
>  
> -       np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
> -       clkctrl = of_iomap(np, 0);
> -       WARN_ON(!clkctrl);
> -
>         clk_misc_init();
>  
>         clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
> @@ -162,7 +161,7 @@ int __init mx23_clocks_init(void)
>                 if (IS_ERR(clks[i])) {
>                         pr_err("i.MX23 clk %d: register failed with %ld\n",
>                                 i, PTR_ERR(clks[i]));
> -                       return PTR_ERR(clks[i]);
> +                       return;
>                 }
>  
>         clk_data.clks = clks;
> @@ -171,6 +170,5 @@ int __init mx23_clocks_init(void)
>  
>         for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
>                 clk_prepare_enable(clks[clks_init_on[i]]);
> -
> -       return 0;
>  }
> +CLK_OF_DECLARE(imx23_clkctrl, "fsl,imx23-clkctrl", mx23_clocks_init);
> diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
> index 4faf0af..12d3f3d 100644
> --- a/drivers/clk/mxs/clk-imx28.c
> +++ b/drivers/clk/mxs/clk-imx28.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk.h>
>  #include <linux/clk/mxs.h>
>  #include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> @@ -154,19 +155,17 @@ static enum imx28_clk clks_init_on[] __initdata = {
>         cpu, hbus, xbus, emi, uart,
>  };
>  
> -int __init mx28_clocks_init(void)
> +static void __init mx28_clocks_init(struct device_node *np)
>  {
> -       struct device_node *np;
>         u32 i;
>  
> +       clkctrl = of_iomap(np, 0);
> +       WARN_ON(!clkctrl);
> +
>         np = of_find_compatible_node(NULL, NULL, "fsl,imx28-digctl");
>         digctrl = of_iomap(np, 0);
>         WARN_ON(!digctrl);
>  
> -       np = of_find_compatible_node(NULL, NULL, "fsl,imx28-clkctrl");
> -       clkctrl = of_iomap(np, 0);
> -       WARN_ON(!clkctrl);
> -
>         clk_misc_init();
>  
>         clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
> @@ -239,7 +238,7 @@ int __init mx28_clocks_init(void)
>                 if (IS_ERR(clks[i])) {
>                         pr_err("i.MX28 clk %d: register failed with %ld\n",
>                                 i, PTR_ERR(clks[i]));
> -                       return PTR_ERR(clks[i]);
> +                       return;
>                 }
>  
>         clk_data.clks = clks;
> @@ -250,6 +249,5 @@ int __init mx28_clocks_init(void)
>  
>         for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
>                 clk_prepare_enable(clks[clks_init_on[i]]);
> -
> -       return 0;
>  }
> +CLK_OF_DECLARE(imx28_clkctrl, "fsl,imx28-clkctrl", mx28_clocks_init);
> diff --git a/include/linux/clk/mxs.h b/include/linux/clk/mxs.h
> index 90c30dc..5138a90 100644
> --- a/include/linux/clk/mxs.h
> +++ b/include/linux/clk/mxs.h
> @@ -9,8 +9,6 @@
>  #ifndef __LINUX_CLK_MXS_H
>  #define __LINUX_CLK_MXS_H
>  
> -int mx23_clocks_init(void);
> -int mx28_clocks_init(void);
>  int mxs_saif_clkmux_select(unsigned int clkmux);
>  
>  #endif
> -- 
> 1.7.2.5
