Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3JPOmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:42:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48680 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3JPOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <1381933924-32437-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1381933924-32437-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Wed, 16 Oct 2013 16:42:07 +0200
Message-ID: <CAPDyKFoegdoRQU0tOp0V=D4Gd=kbrE4i8EJdE668hU7+a=p4sg@mail.gmail.com>
Subject: Re: [PATCH] mmc: atmel-mci: add vmmc-supply support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2013 16:32, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Other MMC hosts handle a regulator named vmmc-supply that allows to power the
> MMC card or SDIO device before communicating on the bus.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/mmc/host/atmel-mci.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 69e438e..deffa1f 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -23,6 +23,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/scatterlist.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
> @@ -2355,6 +2356,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>         struct mci_platform_data        *pdata;
>         struct atmel_mci                *host;
>         struct resource                 *regs;
> +       struct regulator                *reg_vmmc;
>         unsigned int                    nr_slots;
>         int                             irq;
>         int                             ret;
> @@ -2371,6 +2373,16 @@ static int __init atmci_probe(struct platform_device *pdev)
>                 }
>         }
>
> +       reg_vmmc = devm_regulator_get(&pdev->dev, "vmmc");

Use "mmc_regulator_get_supply" instead. This will also try to setup
the "ocr_avail" mask, which is likely what you need as well.

Kind regards
Ulf Hansson

> +       if (!IS_ERR(reg_vmmc)) {
> +               ret = regulator_enable(reg_vmmc);
> +               if (ret) {
> +                       dev_err(&pdev->dev,
> +                               "Failed to enable vmmc regulator: %d\n", ret);
> +                       return ret;
> +               }
> +       }
> +
>         irq = platform_get_irq(pdev, 0);
>         if (irq < 0)
>                 return irq;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
