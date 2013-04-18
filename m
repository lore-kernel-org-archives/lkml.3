Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3DRIVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:21:18 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:40222 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3DRIVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130418080238.GB3137@gmail.com>
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org>
	<201304171550.56037.arnd@arndb.de>
	<20130417150437.GA3137@gmail.com>
	<201304171731.56292.arnd@arndb.de>
	<20130418080238.GB3137@gmail.com>
Date: Thu, 18 Apr 2013 10:21:14 +0200
Message-ID: <CAPDyKFqHBYRRNFqKMdw4H73_o-v_sQ5ybGg3jZHqgNDg4zyB5w@mail.gmail.com>
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with
 information acquired from DT
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2013 10:02, Lee Jones <lee.jones@linaro.org> wrote:
>> I think you can further simplify this, given that in the DT case we always
>> allocate a zeroed mmci_platform_data for host->plat, so !plat cannot happen
>> when we get here.
>
> Okay, third time lucky. :)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 372e921..3260ab4 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -298,14 +298,16 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
>   * no custom DMA interfaces are supported.
>   */
>  #ifdef CONFIG_DMA_ENGINE
> -static void mmci_dma_setup(struct mmci_host *host)
> +static void mmci_dma_setup(struct amba_device *dev,
> +                          struct mmci_host *host)

Hi Lee,

You don't need to pass the amba_device, this can be fetched from the
mmci_host. Check how other functions converts the mmci host it in this
driver.

Kind regards
Ulf Hansson

>  {
> +       struct device_node *np = dev->dev.of_node;
>         struct mmci_platform_data *plat = host->plat;
>         const char *rxname, *txname;
>         dma_cap_mask_t mask;
>
> -       if (!plat || !plat->dma_filter) {
> -               dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> +       if (!(plat->dma_filter || np)) {
> +               dev_info(mmc_dev(host->mmc), "no DMA platform data or DT\n");
>                 return;
>         }
>
> @@ -321,19 +323,21 @@ static void mmci_dma_setup(struct mmci_host *host)
>          * attempt to use it bidirectionally, however if it is
>          * is specified but cannot be located, DMA will be disabled.
>          */
> -       if (plat->dma_rx_param) {
> -               host->dma_rx_channel = dma_request_channel(mask,
> -                                                          plat->dma_filter,
> -                                                          plat->dma_rx_param);
> +       if (plat->dma_rx_param || np) {
> +               host->dma_rx_channel = dma_request_slave_channel_compat(mask,
> +                                                               plat->dma_filter,
> +                                                               plat->dma_rx_param,
> +                                                               &dev->dev, "rx");
>                 /* E.g if no DMA hardware is present */
>                 if (!host->dma_rx_channel)
>                         dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
>         }
>
> -       if (plat->dma_tx_param) {
> -               host->dma_tx_channel = dma_request_channel(mask,
> -                                                          plat->dma_filter,
> -                                                          plat->dma_tx_param);
> +       if (plat->dma_tx_param || np) {
> +               host->dma_tx_channel = dma_request_slave_channel_compat(mask,
> +                                                               plat->dma_filter,
> +                                                               plat->dma_tx_param,
> +                                                               &dev->dev, "tx");
>                 if (!host->dma_tx_channel)
>                         dev_warn(mmc_dev(host->mmc), "no TX DMA channel\n");
>         } else {
> @@ -1538,7 +1542,7 @@ static int mmci_probe(struct amba_device *dev,
>                  amba_rev(dev), (unsigned long long)dev->res.start,
>                  dev->irq[0], dev->irq[1]);
>
> -       mmci_dma_setup(host);
> +       mmci_dma_setup(dev, host);
>
>         pm_runtime_set_autosuspend_delay(&dev->dev, 50);
>         pm_runtime_use_autosuspend(&dev->dev);
>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
