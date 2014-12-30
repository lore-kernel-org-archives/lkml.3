Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaL3LIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:08:42 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36074 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaL3LIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141224212051.30499.28078.stgit@notabene.brown>
References: <20141224211653.30499.46669.stgit@notabene.brown>
	<20141224212051.30499.28078.stgit@notabene.brown>
Date: Tue, 30 Dec 2014 12:08:39 +0100
Message-ID: <CAPDyKFq1DEeZJbRvdCHtZjQfDBEq6Sd5q+7HpEeb5Kv9doYkZQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mmc: core: Allow host driver to provide isr for
 card-detect interrupts.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>, GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 22:20, NeilBrown <neilb@suse.de> wrote:
> One of the reasons omap_hsmmc doesn't use the slot-gpio library
> is that it has some non-standard functionality in the card-detect
> interrupt service routine.
>
> To make it possible for omap_hsmmc (and maybe others) to be converted
> to use slot-gpio, add 'mmc_gpio_set_cd_isr' which provides an
> alternate isr to be registered by the slot-gpio code.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/mmc/core/slot-gpio.c  |   20 +++++++++++++++++++-
>  include/linux/mmc/slot-gpio.h |    2 ++
>  2 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> index 1a3edbd47719..1826b25a2a40 100644
> --- a/drivers/mmc/core/slot-gpio.c
> +++ b/drivers/mmc/core/slot-gpio.c
> @@ -25,6 +25,7 @@ struct mmc_gpio {
>         struct gpio_desc *cd_gpio;
>         bool override_ro_active_level;
>         bool override_cd_active_level;
> +       irqreturn_t (*cd_gpio_isr)(int irq, void *dev_id);
>         char *ro_label;
>         char cd_label[0];
>  };
> @@ -136,8 +137,10 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
>                 irq = -EINVAL;
>
>         if (irq >= 0) {
> +               if (!ctx->cd_gpio_isr)
> +                       ctx->cd_gpio_isr = mmc_gpio_cd_irqt;
>                 ret = devm_request_threaded_irq(host->parent, irq,
> -                       NULL, mmc_gpio_cd_irqt,
> +                       NULL, ctx->cd_gpio_isr,
>                         IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>                         ctx->cd_label, host);
>                 if (ret < 0)
> @@ -151,6 +154,21 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
>  }
>  EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
>
> +/* Register an alternate interrupt service routine for
> + * the card-detect GPIO.
> + */
> +int mmc_gpio_set_cd_isr(struct mmc_host *host,
> +                       irqreturn_t (*isr)(int irq, void *dev_id))
> +{
> +       struct mmc_gpio *ctx;
> +
> +       ctx = host->slot.handler_priv;
> +       if (ctx->cd_gpio_isr)
> +               return -EBUSY;
> +       ctx->cd_gpio_isr = isr;
> +       return 0;

I feel this is a bit more complex than what's needed.
How about just assigning ->cd_gpio_isr() callback, without checking
it's value first and then make mmc_gpio_set_cd_isr() a void function?

> +}
> +
>  /**
>   * mmc_gpio_request_cd - request a gpio for card-detection
>   * @host: mmc host
> diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpio.h
> index 4a36d6954631..4faf41c9a77a 100644
> --- a/include/linux/mmc/slot-gpio.h
> +++ b/include/linux/mmc/slot-gpio.h
> @@ -26,6 +26,8 @@ int mmc_gpiod_request_cd(struct mmc_host *host, const char *con_id,
>  int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
>                          unsigned int idx, bool override_active_level,
>                          unsigned int debounce, bool *gpio_invert);
> +int mmc_gpio_set_cd_isr(struct mmc_host *host,
> +                           irqreturn_t (*isr)(int irq, void *dev_id));
>  void mmc_gpiod_request_cd_irq(struct mmc_host *host);
>
>  #endif
>
>
