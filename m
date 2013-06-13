Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3FMLDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:03:16 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60780 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab3FMLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:03:14 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pinctrl: exynos: Add spinlocks to irq_mask and irq_unmask
Date: Thu, 13 Jun 2013 13:03:12 +0200
Message-ID: <1563709.AX9HNR4mCI@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371058399-31933-1-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Wednesday 12 of June 2013 10:33:17 Doug Anderson wrote:
> The patch:
>   1984695 pinctrl: samsung: Protect bank registers with a spinlock
> 
> ...added spinlocks to protect many accesses.  However, the irq_mask
> and irq_unmask functions still do an unprotected read/modify/write.
> Add the spinlock there.

Right, that's correct.

I always thought that the IRQ core already does some irqchip level 
locking, but it seems like I got confused by irq_desc spinlock. Thanks for 
spotting this.

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/pinctrl/pinctrl-exynos.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-exynos.c
> b/drivers/pinctrl/pinctrl-exynos.c index 2d76f66..c29a28e 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -56,10 +56,15 @@ static void exynos_gpio_irq_unmask(struct irq_data
> *irqd) struct samsung_pinctrl_drv_data *d = bank->drvdata;
>  	unsigned long reg_mask = d->ctrl->geint_mask + bank->eint_offset;
>  	unsigned long mask;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bank->slock, flags);
> 
>  	mask = readl(d->virt_base + reg_mask);
>  	mask &= ~(1 << irqd->hwirq);
>  	writel(mask, d->virt_base + reg_mask);
> +
> +	spin_unlock_irqrestore(&bank->slock, flags);
>  }
> 
>  static void exynos_gpio_irq_mask(struct irq_data *irqd)
> @@ -68,10 +73,15 @@ static void exynos_gpio_irq_mask(struct irq_data
> *irqd) struct samsung_pinctrl_drv_data *d = bank->drvdata;
>  	unsigned long reg_mask = d->ctrl->geint_mask + bank->eint_offset;
>  	unsigned long mask;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bank->slock, flags);
> 
>  	mask = readl(d->virt_base + reg_mask);
>  	mask |= 1 << irqd->hwirq;
>  	writel(mask, d->virt_base + reg_mask);
> +
> +	spin_unlock_irqrestore(&bank->slock, flags);
>  }
> 
>  static void exynos_gpio_irq_ack(struct irq_data *irqd)
> @@ -264,10 +274,15 @@ static void exynos_wkup_irq_unmask(struct irq_data
> *irqd) struct samsung_pinctrl_drv_data *d = b->drvdata;
>  	unsigned long reg_mask = d->ctrl->weint_mask + b->eint_offset;
>  	unsigned long mask;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&b->slock, flags);
> 
>  	mask = readl(d->virt_base + reg_mask);
>  	mask &= ~(1 << irqd->hwirq);
>  	writel(mask, d->virt_base + reg_mask);
> +
> +	spin_unlock_irqrestore(&b->slock, flags);
>  }
> 
>  static void exynos_wkup_irq_mask(struct irq_data *irqd)
> @@ -276,10 +291,15 @@ static void exynos_wkup_irq_mask(struct irq_data
> *irqd) struct samsung_pinctrl_drv_data *d = b->drvdata;
>  	unsigned long reg_mask = d->ctrl->weint_mask + b->eint_offset;
>  	unsigned long mask;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&b->slock, flags);
> 
>  	mask = readl(d->virt_base + reg_mask);
>  	mask |= 1 << irqd->hwirq;
>  	writel(mask, d->virt_base + reg_mask);
> +
> +	spin_unlock_irqrestore(&b->slock, flags);
>  }
> 
>  static void exynos_wkup_irq_ack(struct irq_data *irqd)
