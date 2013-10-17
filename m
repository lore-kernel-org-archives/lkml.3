Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3JQIe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:34:26 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:48282 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3JQIeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:34:23 -0400
MIME-Version: 1.0
In-Reply-To: <1381961999-8187-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1381961999-8187-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Thu, 17 Oct 2013 10:34:22 +0200
Message-ID: <CAPDyKFpWq+cT5nrqifrt+bNR3acT1rpdyxgfjY-63MCfEC18DA@mail.gmail.com>
Subject: Re: [PATCHv2] mmc: atmel-mci: add vmmc-supply support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2013 00:19, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Other MMC hosts handle a regulator named vmmc-supply that allows to power the
> MMC card or SDIO device before communicating on the bus.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>
> Changes in v2:
>  - use mmc_regulator_get_supply instead of devm_regulator_get
>
>  drivers/mmc/host/atmel-mci.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 69e438e..4ea5333 100644
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
> @@ -2198,6 +2199,14 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>         host->slot[id] = slot;
>         mmc_add_host(mmc);
>
> +       mmc_regulator_get_supply(mmc);
> +       if (!IS_ERR(mmc->supply.vmmc)) {
> +               int ret = regulator_enable(mmc->supply.vmmc);

You should not enable the regulator here, instead handle that from the
.set_ios function. This complete code chunk must also be moved prior
to mmc_add_host above.

When enabling/disabling the regulator from the .set_ios, I suppose you
want to use mmc_regulator_set_ocr API instead.

Kind regards
Ulf Hansson

> +               if (ret)
> +                       dev_err(&mmc->class_dev,
> +                               "failed to enable regulator: %d\n", ret);
> +       }
> +
>         if (gpio_is_valid(slot->detect_pin)) {
>                 int ret;
>
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
