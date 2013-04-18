Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3DRIQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:16:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33490 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3DRIQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:16:09 -0400
Date: Thu, 18 Apr 2013 09:15:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with
	information acquired from DT
Message-ID: <20130418081549.GE14496@n2100.arm.linux.org.uk>
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org> <201304171550.56037.arnd@arndb.de> <20130417150437.GA3137@gmail.com> <201304171731.56292.arnd@arndb.de> <20130418080238.GB3137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418080238.GB3137@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:02:38AM +0100, Lee Jones wrote:
> @@ -321,19 +323,21 @@ static void mmci_dma_setup(struct mmci_host *host)
>  	 * attempt to use it bidirectionally, however if it is
>  	 * is specified but cannot be located, DMA will be disabled.
>  	 */
> -	if (plat->dma_rx_param) {
> -		host->dma_rx_channel = dma_request_channel(mask,
> -							   plat->dma_filter,
> -							   plat->dma_rx_param);
> +	if (plat->dma_rx_param || np) {
> +		host->dma_rx_channel = dma_request_slave_channel_compat(mask,
> +								plat->dma_filter,
> +								plat->dma_rx_param,
> +								&dev->dev, "rx");
>  		/* E.g if no DMA hardware is present */
>  		if (!host->dma_rx_channel)
>  			dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");

I don't think this is right - I think Arnd has been leading you up the
garden path saying that this can be simplified.  Why?

If you look at what this code does, the DMA channels are optional.  If
they're not provided, then you don't get an error or a warning printk from
the code.  However, after your conversion, if you use DT and avoid giving
the DMA information (which you have to avoid on the majority of ARM
platforms) then "np" will be non-NULL, and
dma_request_slave_channel_compat() will return NULL, causing the error
and/or warning to be printed.

So, we really need to know whether the DMA channel information has been
provided in DT in the upper level "if" statement, and _not_ use
dma_request_slave_channel_compat().
