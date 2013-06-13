Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3FMKyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:54:31 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44173 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458Ab3FMKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:54:29 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts before unmasking
Date: Thu, 13 Jun 2013 12:54:26 +0200
Message-ID: <24084769.VqIFUPHnqh@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371058399-31933-3-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org> <1371058399-31933-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Wednesday 12 of June 2013 10:33:19 Doug Anderson wrote:
> A level-triggered interrupt should be acked after the interrupt line
> becomes inactive and before it is unmasked, or else another interrupt
> will be immediately triggered.  Acking before or after calling the
> handler is not enough.

Nice catch.

I guess that pinctrl-s3c64xx will need similar fix as well, won't it?

Also one comment inline.

> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/pinctrl/pinctrl-exynos.c | 42
> ++++++++++++++++++++++++++++++++++++++++ 1 file changed, 42
> insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-exynos.c
> b/drivers/pinctrl/pinctrl-exynos.c index c0729a3..67b7a27 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -81,11 +81,32 @@ static void exynos_gpio_irq_unmask(struct irq_data
> *irqd) struct samsung_pin_bank *bank =
> irq_data_get_irq_chip_data(irqd); struct samsung_pinctrl_drv_data *d =
> bank->drvdata;
>  	unsigned long reg_mask = d->ctrl->geint_mask + bank->eint_offset;
> +	unsigned long reg_con = d->ctrl->geint_con + bank->eint_offset;
> +	unsigned int pin = irqd->hwirq;
> +	unsigned int shift = EXYNOS_EINT_CON_LEN * pin;
> +	unsigned int con, trig_type;
>  	unsigned long mask;
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&bank->slock, flags);
> 
> +	/*
> +	 * Ack level interrupts right before unmask
> +	 *
> +	 * If we don't do this we'll get a double-interrupt.  Level 
triggered
> +	 * interrupts must not fire an interrupt if the level is not
> +	 * _currently_ active, even if it was active while the interrupt 
was
> +	 * masked.
> +	 */
> +	con = readl(d->virt_base + reg_con);
> +	trig_type = (con >> shift) & EXYNOS_EINT_CON_MASK;
> +	switch (trig_type) {
> +	case EXYNOS_EINT_LEVEL_HIGH:
> +	case EXYNOS_EINT_LEVEL_LOW:
> +		exynos_gpio_irq_ack(irqd);
> +		break;
> +	}

I think you can eliminate most of the code by doing this following way:

	if (irqd_get_trigger_type(irqd) & IRQ_TYPE_LEVEL_MASK)
		exynos_gpio_irq_ack(irqd);

Best regards,
Tomasz

> +
>  	mask = readl(d->virt_base + reg_mask);
>  	mask &= ~(1 << irqd->hwirq);
>  	writel(mask, d->virt_base + reg_mask);
> @@ -299,11 +320,32 @@ static void exynos_wkup_irq_unmask(struct irq_data
> *irqd) struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
> struct samsung_pinctrl_drv_data *d = b->drvdata;
>  	unsigned long reg_mask = d->ctrl->weint_mask + b->eint_offset;
> +	unsigned long reg_con = d->ctrl->weint_con + b->eint_offset;
> +	unsigned int pin = irqd->hwirq;
> +	unsigned long shift = EXYNOS_EINT_CON_LEN * pin;
> +	unsigned long con, trig_type;
>  	unsigned long mask;
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&b->slock, flags);
> 
> +	/*
> +	 * Ack level interrupts right before unmask
> +	 *
> +	 * If we don't do this we'll get a double-interrupt.  Level 
triggered
> +	 * interrupts must not fire an interrupt if the level is not
> +	 * _currently_ active, even if it was active while the interrupt 
was
> +	 * masked.
> +	 */
> +	con = readl(d->virt_base + reg_con);
> +	trig_type = (con >> shift) & EXYNOS_EINT_CON_MASK;
> +	switch (trig_type) {
> +	case EXYNOS_EINT_LEVEL_HIGH:
> +	case EXYNOS_EINT_LEVEL_LOW:
> +		exynos_wkup_irq_ack(irqd);
> +		break;
> +	}
> +
>  	mask = readl(d->virt_base + reg_mask);
>  	mask &= ~(1 << irqd->hwirq);
>  	writel(mask, d->virt_base + reg_mask);
