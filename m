Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaEWGsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:48:03 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59697 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaEWGsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <1400797012-32106-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400797012-32106-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 23 May 2014 08:48:00 +0200
Message-ID: <CAPDyKFoF77fhYVaLX=nSS1A+mi9BUWHszkKA-stcutcOKovMXw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-dove: use mmc_of_parse() and remove
 card_tasklet CD handler
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Chris Ball <chris@printf.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 00:16, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> Commit f8ec589b86f6
>   "mmc: sdhci-dove: allow GPIOs to be used for card detection on Dove"
> added a gpio based card detect interrupt handler that was hooked up
> into card_tasket.
>
> Commit 3560db8e247a
>   "mmc: sdhci: push card_tasklet into threaded irq handler"
> now removed that very card_tasklet causing sdhci-dove to fail on build
> with:
> drivers/mmc/host/sdhci-dove.c: In function 'sdhci_dove_carddetect_irq':
> drivers/mmc/host/sdhci-dove.c:42:24: error: 'struct sdhci_host' has no member named 'card_tasklet'
>
> To fix both the build error and get a working gpio card detection without
> card_tasklet, replace sdhci_get_of_property() with more recent
> mmc_of_parse(). It takes care of gpio-based card detect passed through DT
> already and allows to remove the offending code sections dealing with
> removed card_tasklet.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks Sebastian!

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Chris, can you pick this up?

> ---
> This patch is based on todays mmc-next and fixes a build error there.
>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-dove.c | 74 +++----------------------------------------
>  1 file changed, 5 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
> index 0d315f4496c8..e6278ec007d7 100644
> --- a/drivers/mmc/host/sdhci-dove.c
> +++ b/drivers/mmc/host/sdhci-dove.c
> @@ -21,28 +21,17 @@
>
>  #include <linux/clk.h>
>  #include <linux/err.h>
> -#include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/mmc/host.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> -#include <linux/of_gpio.h>
>
>  #include "sdhci-pltfm.h"
>
>  struct sdhci_dove_priv {
>         struct clk *clk;
> -       int gpio_cd;
>  };
>
> -static irqreturn_t sdhci_dove_carddetect_irq(int irq, void *data)
> -{
> -       struct sdhci_host *host = data;
> -
> -       tasklet_schedule(&host->card_tasklet);
> -       return IRQ_HANDLED;
> -}
> -
>  static u16 sdhci_dove_readw(struct sdhci_host *host, int reg)
>  {
>         u16 ret;
> @@ -60,8 +49,6 @@ static u16 sdhci_dove_readw(struct sdhci_host *host, int reg)
>
>  static u32 sdhci_dove_readl(struct sdhci_host *host, int reg)
>  {
> -       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> -       struct sdhci_dove_priv *priv = pltfm_host->priv;
>         u32 ret;
>
>         ret = readl(host->ioaddr + reg);
> @@ -71,14 +58,6 @@ static u32 sdhci_dove_readl(struct sdhci_host *host, int reg)
>                 /* Mask the support for 3.0V */
>                 ret &= ~SDHCI_CAN_VDD_300;
>                 break;
> -       case SDHCI_PRESENT_STATE:
> -               if (gpio_is_valid(priv->gpio_cd)) {
> -                       if (gpio_get_value(priv->gpio_cd) == 0)
> -                               ret |= SDHCI_CARD_PRESENT;
> -                       else
> -                               ret &= ~SDHCI_CARD_PRESENT;
> -               }
> -               break;
>         }
>         return ret;
>  }
> @@ -117,28 +96,9 @@ static int sdhci_dove_probe(struct platform_device *pdev)
>
>         priv->clk = devm_clk_get(&pdev->dev, NULL);
>
> -       if (pdev->dev.of_node) {
> -               priv->gpio_cd = of_get_named_gpio(pdev->dev.of_node,
> -                                                 "cd-gpios", 0);
> -       } else {
> -               priv->gpio_cd = -EINVAL;
> -       }
> -
> -       if (gpio_is_valid(priv->gpio_cd)) {
> -               ret = gpio_request(priv->gpio_cd, "sdhci-cd");
> -               if (ret) {
> -                       dev_err(&pdev->dev, "card detect gpio request failed: %d\n",
> -                               ret);
> -                       return ret;
> -               }
> -               gpio_direction_input(priv->gpio_cd);
> -       }
> -
>         host = sdhci_pltfm_init(pdev, &sdhci_dove_pdata, 0);
> -       if (IS_ERR(host)) {
> -               ret = PTR_ERR(host);
> -               goto err_sdhci_pltfm_init;
> -       }
> +       if (IS_ERR(host))
> +               return PTR_ERR(host);
>
>         pltfm_host = sdhci_priv(host);
>         pltfm_host->priv = priv;
> @@ -146,39 +106,20 @@ static int sdhci_dove_probe(struct platform_device *pdev)
>         if (!IS_ERR(priv->clk))
>                 clk_prepare_enable(priv->clk);
>
> -       sdhci_get_of_property(pdev);
> +       ret = mmc_of_parse(host->mmc);
> +       if (ret)
> +               goto err_sdhci_add;
>
>         ret = sdhci_add_host(host);
>         if (ret)
>                 goto err_sdhci_add;
>
> -       /*
> -        * We must request the IRQ after sdhci_add_host(), as the tasklet only
> -        * gets setup in sdhci_add_host() and we oops.
> -        */
> -       if (gpio_is_valid(priv->gpio_cd)) {
> -               ret = request_irq(gpio_to_irq(priv->gpio_cd),
> -                                 sdhci_dove_carddetect_irq,
> -                                 IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> -                                 mmc_hostname(host->mmc), host);
> -               if (ret) {
> -                       dev_err(&pdev->dev, "card detect irq request failed: %d\n",
> -                               ret);
> -                       goto err_request_irq;
> -               }
> -       }
> -
>         return 0;
>
> -err_request_irq:
> -       sdhci_remove_host(host, 0);
>  err_sdhci_add:
>         if (!IS_ERR(priv->clk))
>                 clk_disable_unprepare(priv->clk);
>         sdhci_pltfm_free(pdev);
> -err_sdhci_pltfm_init:
> -       if (gpio_is_valid(priv->gpio_cd))
> -               gpio_free(priv->gpio_cd);
>         return ret;
>  }
>
> @@ -190,11 +131,6 @@ static int sdhci_dove_remove(struct platform_device *pdev)
>
>         sdhci_pltfm_unregister(pdev);
>
> -       if (gpio_is_valid(priv->gpio_cd)) {
> -               free_irq(gpio_to_irq(priv->gpio_cd), host);
> -               gpio_free(priv->gpio_cd);
> -       }
> -
>         if (!IS_ERR(priv->clk))
>                 clk_disable_unprepare(priv->clk);
>
> --
> 1.9.1
>
