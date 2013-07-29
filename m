Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3G2OFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:05:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38692 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab3G2OFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:05:16 -0400
Date: Mon, 29 Jul 2013 15:04:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "albert.u.boot@aribaud.net" <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/10] ARM: sun6i: Add restart code for the A31
Message-ID: <20130729140430.GA25264@e106331-lin.cambridge.arm.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:25:06PM +0100, Maxime Ripard wrote:
> The Allwinner A31 has a sligthly different watchdog that requires a
> different restart code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-sunxi/sunxi.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index 11326d9..c18ef3a 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -32,6 +32,15 @@
>  #define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
>  #define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
>  
> +#define SUN6I_WATCHDOG1_IRQ_REG		0x00
> +#define SUN6I_WATCHDOG1_CTRL_REG	0x10
> +#define SUN6I_WATCHDOG1_CTRL_RESTART		(1 << 0)
> +#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
> +#define SUN6I_WATCHDOG1_CONFIG_RESTART		(1 << 0)
> +#define SUN6I_WATCHDOG1_CONFIG_IRQ		(1 << 1)
> +#define SUN6I_WATCHDOG1_MODE_REG	0x18
> +#define SUN6I_WATCHDOG1_MODE_ENABLE		(1 << 0)
> +
>  static void __iomem *wdt_base;
>  
>  static void sun4i_restart(enum reboot_mode mode, const char *cmd)
> @@ -56,8 +65,36 @@ static void sun4i_restart(enum reboot_mode mode, const char *cmd)
>  	}
>  }
>  
> +static void sun6i_restart(char mode, const char *cmd)
> +{
> +	if (!wdt_base)
> +		return;
> +
> +	/* Disable interrupts */
> +	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
> +
> +	/* We want to disable the IRQ and just reset the whole system */
> +	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
> +		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
> +
> +	/* Enable timer. The default and lowest interval value is 0.5s */
> +	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> +		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> +
> +	/* Restart the watchdog. */
> +	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
> +		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
> +
> +	while (1) {
> +		mdelay(5);
> +		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> +			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> +	}
> +}
> +
>  static struct of_device_id sunxi_restart_ids[] = {
>  	{ .compatible = "allwinner,sun4i-wdt", .data = sun4i_restart },
> +	{ .compatible = "allwinner,sun6i-wdt", .data = sun6i_restart },

Is there a corresponding binding document addition? 

sun4i-wdt.txt could be turned into a more general sunxi-wdt.txt.

Thanks,
Mark.
