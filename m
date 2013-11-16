Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3KPHhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 02:37:24 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64839 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KPHhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 02:37:18 -0500
Date: Fri, 15 Nov 2013 23:34:54 -0800
From: Olof Johansson <olof@lixom.net>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>, Stephen Hurd <shurd@broadcom.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: disable UHS on broadcom sdhci
Message-ID: <20131116073454.GA20132@quad.lixom.net>
References: <1384559782-7614-1-git-send-email-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384559782-7614-1-git-send-email-grundler@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 15, 2013 at 03:56:22PM -0800, Grant Grundler wrote:
> From: Stephen Hurd <shurd@broadcom.com>
> 
> Add two new quirks needed by BCM57785 card reader:
> SDHCI_QUIRK2_BROKEN_UHS:
>     Disables all UHS modes.

This seems appropriate. You _could_ use SDHCI_QUIRK_MISSING_CAPS and
hardcode them instead, but it doesn't seem to be an improvement really.

> SDHCI_QUIRK2_BCM57785_CR:
>     Bit twiddles some Broadcom-specific registers and supresses an error
>     about the 64k bar0.

I think this can be done without spending a global SDHCI quirk bit. This
is just a one-time setup that needs to be done, isn't it? It's hard
to tell since there's no official errata described, but if it is, then
overriding the probe function is the way to go instead, flipping these
bits there and then call the regular probe.


[...]

> index 7a7fb4f..cf26c0f 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1144,6 +1144,27 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
>  			return;
>  	}
>  
> +	if (host->quirks2 & SDHCI_QUIRK2_BCM57785_CR) {
> +		u32 tmp;
> +
> +		/*
> +		 * Register descriptions from:
> +		 *     http://www.broadcom.com/collateral/pg/57785-PG103-R.pdf
> +		 */

That's a 661 page document, that unfortunately doesn't really help decode any
of the bits below because they are all touching reserved or marked-internal
bits of registers. :-)

Still, good to see a doc link.

> +		tmp = sdhci_readl(host, BCM57785_CR_MUX_CTL);
> +		tmp &= ~0x3000;		/* bits 12:15 are reserved */
> +		sdhci_writel(host, tmp, BCM57785_CR_MUX_CTL);
> +		tmp = sdhci_readl(host, BCM57785_CR_CLK_CTL);
> +		tmp &= ~(0x01a03f30);	/* Internal debug for SD3.0 */
> +		tmp |= (0x00500000);
> +
> +		if ((sdhci_readw(host, SDHCI_HOST_CONTROL2) &
> +			    SDHCI_CTRL_VDD_180) && (clock >= 200000000))
> +			tmp |= (1<<24);
> +		sdhci_writel(host, tmp, BCM57785_CR_CLK_CTL);
> +	}
> +
>  	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
>  
>  	if (clock == 0)
[...]
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 3e781b8..664003a 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -98,6 +98,12 @@ struct sdhci_host {
>  #define SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON		(1<<4)
>  /* Controller has a non-standard host control register */
>  #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
> +/* UHS modes do not work */
> +#define SDHCI_QUIRK2_BROKEN_UHS				(1<<6)
> +/* hacks for Broadcom-specific card reader bugs */
> +#define SDHCI_QUIRK2_BCM57785_CR			(1<<7)
> +#define	  BCM57785_CR_MUX_CTL 0x198  /* Card Reader MUX control */
> +#define	  BCM57785_CR_CLK_CTL 0x19c  /* Card Reader Clock Status/Ctl */

These two defines should not be in a global include file; they should likely go
in the c file instead.


-Olof
