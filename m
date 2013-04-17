Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966413Ab3DQNvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:51:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:51:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with information acquired from DT
Date: Wed, 17 Apr 2013 15:50:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366205534-25079-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304171550.56037.arnd@arndb.de>
X-Provags-ID: V02:K0:yVvCkUP9m4ZRJB4rD/tgucuunRKv7CCKJcZ/faDILbg
 A04d9Ti9YIMIZUjpQqMMDpiGCa/LL0eSaiD2GqSDtCp2fwswIN
 +jW6R4pHnjaEqZbOVOAFAB226x3klXkxQ3AGXK84UKATI9jMfD
 LQYTdGzMaFS8Q01xUaet9Mlm7F4k7W2Ng9S2vs4CD+p0of+wwZ
 TgCm8aZ0K1wFrX4uO6vIiverfKSVOC5/2L3Wp7N/aJOUXU4Eke
 UjXynTkUy2f9BzluBClWn0LLmodxeCDNNHZC/uzhBOfhKolUMM
 YSdAkjctcGy6uDNkT2CC93MpadSv2+KYZQfdFJ9rUTQcb5PpbF
 UVmEXEgP5R/16HNwZiyY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013, Lee Jones wrote:

>  #ifdef CONFIG_DMA_ENGINE
> -static void mmci_dma_setup(struct mmci_host *host)
> +static void mmci_dma_setup(struct amba_device *dev,
> +			   struct mmci_host *host)
>  {
> +	struct device_node *np = dev->dev.of_node;
>  	struct mmci_platform_data *plat = host->plat;
>  	const char *rxname, *txname;
>  	dma_cap_mask_t mask;
> +	const char *chan_name;
> +	int count, i;
> +	bool do_tx = false, do_rx = false;
>  
>  	if (!plat || !plat->dma_filter) {
> -		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> -		return;
> +		if (np) {
> +			count = of_property_count_strings(np, "dma-names");
> +			for (i = 0; i < count; i++) {
> +				of_property_read_string_index(np, "dma-names",
> +							      i, &chan_name);
> +				if (strcmp(chan_name, "tx"))
> +					do_tx = true;
> +				else if (strcmp(chan_name, "rx"))
> +					do_rx = true;
> +			}
> +		} else {
> +			dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> +			return;
> +		}
>  	}

This looks unnecessarily complex.

>  	/* initialize pre request cookie */
> @@ -321,19 +338,21 @@ static void mmci_dma_setup(struct mmci_host *host)
>  	 * attempt to use it bidirectionally, however if it is
>  	 * is specified but cannot be located, DMA will be disabled.
>  	 */
> -	if (plat->dma_rx_param) {
> -		host->dma_rx_channel = dma_request_channel(mask,
> -							   plat->dma_filter,
> -							   plat->dma_rx_param);
> +	if (plat->dma_rx_param || do_rx) {
> +		host->dma_rx_channel = dma_request_slave_channel_compat(mask,
> +					(plat) ? plat->dma_filter : NULL,
> +					(plat) ? plat->dma_rx_param : NULL,
> +					&dev->dev, "rx");
>  		/* E.g if no DMA hardware is present */
>  		if (!host->dma_rx_channel)
>  			dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
>  	}

Why not just do dma_request_slave_channel_compat() unconditionally here?
It's not an error for MMCI if that fails. If you want to keep the warning
in the case dma_rx_channel is provided by not working, you can do it like

	host->dma_rx_channel = dma_request_slave_channel(dev, "rx");
	if (!host->dma_rx_channel && plat->dma_rx_param) {
		host->dma_rx_channel = dma_request_channel(mask,
							   plat->dma_filter,
							   plat->dma_rx_param);
		...
	}

	Arnd
