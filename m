Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966698Ab3DQPcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:32:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900Ab3DQPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:32:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with information acquired from DT
Date: Wed, 17 Apr 2013 17:31:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org> <201304171550.56037.arnd@arndb.de> <20130417150437.GA3137@gmail.com>
In-Reply-To: <20130417150437.GA3137@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304171731.56292.arnd@arndb.de>
X-Provags-ID: V02:K0:0S+w7o5kWU3plUG2vMQkXTwLX4O4MvGXoZ2FW8bG2Rn
 WFvCT5Hru5Da8QtZdbN8/sNApTV7Fg2VD01HaxonwP2/MVm0pF
 NYetSwTAvmnEuFp0SX7SwRxm9F0GXM8pOdso90RmfHWAWUCI62
 czVON67X7PG1ocOI3zzF/ABYHWQ5uT9PsPoj80VPD/igq9GH6j
 YDJFNUNxvtJze6TyGvnRnHy/rifKRQF/3MHUBwauVCLKRwCxCv
 fatM4PS6i6tDLhjngm/HKByNg9ba7Xa7lj32LrlKQWg+ezcCC1
 xLY3l7wR4ADTjS+3xX3PipVDQZ4vsaXD1EGB7Amf5ki6dIJbb5
 W4u9wqusY40K/6xTHe2g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013, Lee Jones wrote:
> > This looks unnecessarily complex.
> 
> That thought did cross my mind.
> 
> > Why not just do dma_request_slave_channel_compat() unconditionally here?
> 
> So how about something like this instead, as it keeps the current
> semantics, and only differs in the case of DT.

Yes, looks better.

> @@ -298,14 +298,16 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
>   * no custom DMA interfaces are supported.
>   */
>  #ifdef CONFIG_DMA_ENGINE
> -static void mmci_dma_setup(struct mmci_host *host)
> +static void mmci_dma_setup(struct amba_device *dev,
> +			   struct mmci_host *host)
>  {
> +	struct device_node *np = dev->dev.of_node;
>  	struct mmci_platform_data *plat = host->plat;
>  	const char *rxname, *txname;
>  	dma_cap_mask_t mask;
>  
> -	if (!plat || !plat->dma_filter) {
> -		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> +	if (!(plat && plat->dma_filter) && !np) {
> +		dev_info(mmc_dev(host->mmc), "no DMA platform data or DT\n");
>  		return;
>  	}

I think you can further simplify this, given that in the DT case we always
allocate a zeroed mmci_platform_data for host->plat, so !plat cannot happen
when we get here.

> @@ -321,19 +323,21 @@ static void mmci_dma_setup(struct mmci_host *host)
>  	 * attempt to use it bidirectionally, however if it is
>  	 * is specified but cannot be located, DMA will be disabled.
>  	 */
> -	if (plat->dma_rx_param) {
> -		host->dma_rx_channel = dma_request_channel(mask,
> -							   plat->dma_filter,
> -							   plat->dma_rx_param);
> +	if ((plat && plat->dma_rx_param) || np) {
> +		host->dma_rx_channel = dma_request_slave_channel_compat(mask,
> +					(plat) ? plat->dma_filter : NULL,
> +					(plat) ? plat->dma_rx_param : NULL,
> +					&dev->dev, "rx");
>  		/* E.g if no DMA hardware is present */
>  		if (!host->dma_rx_channel)
>  			dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");

And based on that, you can unconditionally pass plat->dma_filter and
plat->dma_rx_param here. In case of DT, they will be NULL, and they
will not be used either.

	Arnd
