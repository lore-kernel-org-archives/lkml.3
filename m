Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaKSSdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:33:04 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59882 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbaKSSdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:33:03 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: rockchip: Handle wakeup pins
Date: Wed, 19 Nov 2014 19:36:34 +0100
Message-ID: <14309764.DganbDSVIF@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416354596-15013-2-git-send-email-dianders@chromium.org>
References: <1416354596-15013-1-git-send-email-dianders@chromium.org> <1416354596-15013-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. November 2014, 15:49:55 schrieb Doug Anderson:
> The rockchip pinctrl driver was using irq_gc_set_wake() as its
> implementation of irq_set_wake() but was totally ignoring everything
> that irq_gc_set_wake() did (which is to upkeep gc->wake_active).
> 
> Let's fix that by setting gc->wake_active as GPIO_INTEN at suspend
> time and restoring GPIO_INTEN at resume time.
> 
> NOTE a few quirks when thinking about this patch:
> - Rockchip pinctrl hardware supports both "disable/enable" and
>   "mask/unmask".  Right now we only use "disable/enable" and present
>   those to Linux as "mask/unmask".  This should be OK because
>   enable/disable is optional and Linux will implement it in terms of
>   mask/unmask.  At the moment we always tell hardware all interrupts
>   are unmasked (the boot default).
> - At suspend time Linux tries to call "disable" on all interrupts and
>   also enables wakeup on all wakeup interrupts.  One would think that
>   since "disable" is implemented as "mask" when "disable" isn't
>   provided and that since we were ignoring gc->wake_active that
>   nothing would have woken us up.  That's not the case since Linux
>   "optimizes" things and just leaves interrutps unmasked, assuming it
>   could mask them later when they go off.  That meant that at suspend
>   time all interrupts were actually being left enabled.
> 
> With this patch random non-wakeup interrupts no longer wake the system
> up.  Wakeup interrupts still wake the system up.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  drivers/pinctrl/pinctrl-rockchip.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index ba74f0a..e91e845 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -89,6 +89,7 @@ struct rockchip_iomux {
>   * @reg_pull: optional separate register for additional pull settings
>   * @clk: clock of the gpio bank
>   * @irq: interrupt of the gpio bank
> + * @saved_enables: Saved content of GPIO_INTEN at suspend time.
>   * @pin_base: first pin number
>   * @nr_pins: number of pins in this bank
>   * @name: name of the bank
> @@ -107,6 +108,7 @@ struct rockchip_pin_bank {
>  	struct regmap			*regmap_pull;
>  	struct clk			*clk;
>  	int				irq;
> +	u32				saved_enables;
>  	u32				pin_base;
>  	u8				nr_pins;
>  	char				*name;
> @@ -1543,6 +1545,23 @@ static int rockchip_irq_set_type(struct irq_data *d,
> unsigned int type) return 0;
>  }
> 
> +static void rockchip_irq_suspend(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct rockchip_pin_bank *bank = gc->private;
> +
> +	bank->saved_enables = irq_reg_readl(gc, GPIO_INTEN);
> +	irq_reg_writel(gc, gc->wake_active, GPIO_INTEN);
> +}
> +
> +static void rockchip_irq_resume(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct rockchip_pin_bank *bank = gc->private;
> +
> +	irq_reg_writel(gc, bank->saved_enables, GPIO_INTEN);
> +}
> +
>  static int rockchip_interrupts_register(struct platform_device *pdev,
>  						struct rockchip_pinctrl *info)
>  {
> @@ -1587,6 +1606,8 @@ static int rockchip_interrupts_register(struct
> platform_device *pdev, gc->chip_types[0].chip.irq_mask =
> irq_gc_mask_clr_bit;
>  		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
>  		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
> +		gc->chip_types[0].chip.irq_suspend = rockchip_irq_suspend;
> +		gc->chip_types[0].chip.irq_resume = rockchip_irq_resume;
>  		gc->chip_types[0].chip.irq_set_type = rockchip_irq_set_type;
>  		gc->wake_enabled = IRQ_MSK(bank->nr_pins);

