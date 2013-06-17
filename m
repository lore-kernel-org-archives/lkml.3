Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3FQL6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:58:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51785 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab3FQL6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:58:07 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-aa-51bef9cd7593
From: Tomasz Figa <t.figa@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH Resend] pinctrl: exynos: Fix build breakage
Date: Mon, 17 Jun 2013 13:57:58 +0200
Message-id: <1992157.1uNu7hFias@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
References: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xy7pnf+4LNDi0Usri7LKDbBZT/ixn
	sri8aw6bxYzz+5gsphz+wmJx8k8vowObx+yGiywed67tYfP4vEkugDmKyyYlNSezLLVI3y6B
	K6Nt+1vGgkNCFZdf3GdtYDzL38XIySEhYCKx/2oTO4QtJnHh3nq2LkYuDiGBpYwSLRO2MUI4
	XUwSxybeZQWpYhNQk/jc8IgNxBYRcJF4/WsRM0gRs0ADo8TKzZPARgkL2EvMuXUdqJuDg0VA
	VeLlLDWQMK+ApsTLebsZQWx+AXWJd9ueMoHYogKuEu9XH2YBsTkF3CX+dewGGyMk4Caxat0P
	doheQYkfk++B1TALaEs8eXeBFWQ8M9CcKVNyJzAKzkJSNQtJ1SyEqgWMzKsYRVNLkwuKk9Jz
	DfWKE3OLS/PS9ZLzczcxQoL7yw7GxcesDjEKcDAq8fBuqN4XKMSaWFZcmXuIUYKDWUmEN3Yi
	UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjidSK5KjN/YLe6+79Mzsg3O0aPJPzxpHJ1xJvOszZ
	+HyGln5qZOniBj/TF0LfVvdLbGGs3dFtddg0+v3X6TYle56u1b0QtenkR1f3rw1Ty+dJ/ti4
	OPbRkonTp31m2VcV3rBcbjvj4zmL+q8lrNSexvHNgSVZOKXnW/DUcIW+rxk3Qza1OR8oUmIp
	zkg01GIuKk4EALK3f/xMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Monday 17 of June 2013 15:08:12 Sachin Kamat wrote:
> 'exynos_wkup_irq_ack' should be defined ahead of its call.
> 
> Fixes the following error:
> drivers/pinctrl/pinctrl-exynos.c: In function ‘exynos_wkup_irq_mask’:
> drivers/pinctrl/pinctrl-exynos.c:299:3: error: implicit declaration of
> function ‘exynos_wkup_irq_ack’ [-Werror=implicit-function-declaration]
>    exynos_wkup_irq_ack(irqd);
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Doug Anderson <dianders@chromium.org>
> ---
> Fixed the commit message.
> ---

This patch is incorrect.

Compilation error is caused by merge error of Doug's patch:

pinctrl: exynos: ack level-triggered interrupts before unmasking

hunk of which went to wrong function - mask instead of unmask.

Linus, could you fix it?

Best regards,
Tomasz

>  drivers/pinctrl/pinctrl-exynos.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-exynos.c
> b/drivers/pinctrl/pinctrl-exynos.c index 8cd5bf5..f9277bc 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -279,6 +279,15 @@ err_domains:
>  	return ret;
>  }
> 
> +static void exynos_wkup_irq_ack(struct irq_data *irqd)
> +{
> +	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
> +	struct samsung_pinctrl_drv_data *d = b->drvdata;
> +	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
> +
> +	writel(1 << irqd->hwirq, d->virt_base + pend);
> +}
> +
>  static void exynos_wkup_irq_mask(struct irq_data *irqd)
>  {
>  	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
> @@ -307,15 +316,6 @@ static void exynos_wkup_irq_mask(struct irq_data *irqd)
> spin_unlock_irqrestore(&b->slock, flags);
>  }
> 
> -static void exynos_wkup_irq_ack(struct irq_data *irqd)
> -{
> -	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
> -	struct samsung_pinctrl_drv_data *d = b->drvdata;
> -	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
> -
> -	writel(1 << irqd->hwirq, d->virt_base + pend);
> -}
> -
>  static void exynos_wkup_irq_unmask(struct irq_data *irqd)
>  {
>  	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
