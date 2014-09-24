Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaIXIsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:48:54 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45795 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaIXIsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <1411476708-13551-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1411476708-13551-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 24 Sep 2014 10:48:50 +0200
Message-ID: <CAPDyKFr-yytpn9CFSoY+dd4+Cf+=qAVqPvch-2nB+vOHAudUSQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: atmel-mci: Switch to using managed resource
 in probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 September 2014 14:51, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> This change uses managed resource APIs to allocate resources such as,
> clk, gpio, io in order to simplify the driver unload or failure cases.
> Hence does away with release statements of the same resources in error
> labels and remove function.
>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Thanks! Applied for next.

You don't need this extensive list of "Cc" in the commit message for
future patches. It's also recommended to add acks etc in chronological
order, thus Ludovic's ack should have been put below your sob.

Kind regards
Uffe

>
> ---
> Changes since v1:
> - Dropped using devm_request_irq as suggested by Ludovic Desroches
>   as it seems there are race conditions seen with them.
> - Added another patch to fix failure path in probe to call atmci_cleanup_slot
>   after dma_alloc_coherent() fails to release mmc_host resources.
> - Fixed typos in commit message
> ---
>  drivers/mmc/host/atmel-mci.c |   41 ++++++++++++++---------------------------
>  1 file changed, 14 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index bb585d9..36212fb 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -17,6 +17,7 @@
>  #include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/ioport.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -2195,7 +2196,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>         /* Assume card is present initially */
>         set_bit(ATMCI_CARD_PRESENT, &slot->flags);
>         if (gpio_is_valid(slot->detect_pin)) {
> -               if (gpio_request(slot->detect_pin, "mmc_detect")) {
> +               if (devm_gpio_request(&host->pdev->dev, slot->detect_pin,
> +                                     "mmc_detect")) {
>                         dev_dbg(&mmc->class_dev, "no detect pin available\n");
>                         slot->detect_pin = -EBUSY;
>                 } else if (gpio_get_value(slot->detect_pin) ^
> @@ -2208,7 +2210,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>                 mmc->caps |= MMC_CAP_NEEDS_POLL;
>
>         if (gpio_is_valid(slot->wp_pin)) {
> -               if (gpio_request(slot->wp_pin, "mmc_wp")) {
> +               if (devm_gpio_request(&host->pdev->dev, slot->wp_pin,
> +                                     "mmc_wp")) {
>                         dev_dbg(&mmc->class_dev, "no WP pin available\n");
>                         slot->wp_pin = -EBUSY;
>                 }
> @@ -2232,7 +2235,6 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>                         dev_dbg(&mmc->class_dev,
>                                 "could not request IRQ %d for detect pin\n",
>                                 gpio_to_irq(slot->detect_pin));
> -                       gpio_free(slot->detect_pin);
>                         slot->detect_pin = -EBUSY;
>                 }
>         }
> @@ -2257,10 +2259,7 @@ static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
>
>                 free_irq(gpio_to_irq(pin), slot);
>                 del_timer_sync(&slot->detect_timer);
> -               gpio_free(pin);
>         }
> -       if (gpio_is_valid(slot->wp_pin))
> -               gpio_free(slot->wp_pin);
>
>         slot->host->slot[id] = NULL;
>         mmc_free_host(slot->mmc);
> @@ -2395,7 +2394,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>         if (irq < 0)
>                 return irq;
>
> -       host = kzalloc(sizeof(struct atmel_mci), GFP_KERNEL);
> +       host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
>         if (!host)
>                 return -ENOMEM;
>
> @@ -2403,20 +2402,18 @@ static int __init atmci_probe(struct platform_device *pdev)
>         spin_lock_init(&host->lock);
>         INIT_LIST_HEAD(&host->queue);
>
> -       host->mck = clk_get(&pdev->dev, "mci_clk");
> -       if (IS_ERR(host->mck)) {
> -               ret = PTR_ERR(host->mck);
> -               goto err_clk_get;
> -       }
> +       host->mck = devm_clk_get(&pdev->dev, "mci_clk");
> +       if (IS_ERR(host->mck))
> +               return PTR_ERR(host->mck);
>
> -       ret = -ENOMEM;
> -       host->regs = ioremap(regs->start, resource_size(regs));
> +       host->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
>         if (!host->regs)
> -               goto err_ioremap;
> +               return -ENOMEM;
>
>         ret = clk_prepare_enable(host->mck);
>         if (ret)
> -               goto err_request_irq;
> +               return ret;
> +
>         atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>         host->bus_hz = clk_get_rate(host->mck);
>         clk_disable_unprepare(host->mck);
> @@ -2427,7 +2424,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>
>         ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
>         if (ret)
> -               goto err_request_irq;
> +               return ret;
>
>         /* Get MCI capabilities and set operations according to it */
>         atmci_get_cap(host);
> @@ -2499,12 +2496,6 @@ err_init_slot:
>         if (host->dma.chan)
>                 dma_release_channel(host->dma.chan);
>         free_irq(irq, host);
> -err_request_irq:
> -       iounmap(host->regs);
> -err_ioremap:
> -       clk_put(host->mck);
> -err_clk_get:
> -       kfree(host);
>         return ret;
>  }
>
> @@ -2532,10 +2523,6 @@ static int __exit atmci_remove(struct platform_device *pdev)
>                 dma_release_channel(host->dma.chan);
>
>         free_irq(platform_get_irq(pdev, 0), host);
> -       iounmap(host->regs);
> -
> -       clk_put(host->mck);
> -       kfree(host);
>
>         return 0;
>  }
> --
> 1.7.9.5
>
