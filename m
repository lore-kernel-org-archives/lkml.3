Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3IWSv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:51:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34656 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3IWSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:51:56 -0400
Message-ID: <52408DC8.3020407@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:51:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND] spi/tegra114: Correct support for cs_change
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com>
In-Reply-To: <1379528245-6283-1-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 12:17 PM, Rhyland Klein wrote:
> The tegra114 driver wasn't currently handling the cs_change functionality.
> It is meant to invert normal behavior, and we were only using it to possibly
> delay at the end of a transfer.

I don't really follow this patch description well. It may help if you
fully spelled out the definition of normal behaviour, what the driver
was doing, and what it should be doing (which is presumable what it does
do after this patch).

> This patch modifies the logic so that the cs state will be toggled after
> every individual transfer or NOT toggled at the end of the last transfer
> if cs_change is set in that transfer struct.
> 
> Also, this builds in logic so that if a different device tries to start
> a transfer while CS is active from a different device, it will abort the
> previous transfer and start a new one for the new device.

What user-visible impact does this patch have. Does it solve a bug, or
improve performance, or ...? In other words, how would I test this
patch, other that testing for regressions in SPI functionality that I
know already works.

BTW, I don't think you're using get_maintainer.pl, since Mark Brown is
the SPI maintainer now, not Grant Likely.

> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
> index 145dd43..a9973de 100644
> --- a/drivers/spi/spi-tegra114.c
> +++ b/drivers/spi/spi-tegra114.c
> @@ -182,6 +182,7 @@ struct tegra_spi_data {
>  	u32					cur_speed;
>  
>  	struct spi_device			*cur_spi;
> +	struct spi_device			*cs_control;
>  	unsigned				cur_pos;
>  	unsigned				cur_len;
>  	unsigned				words_per_32bit;
> @@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>  		else if (req_mode == SPI_MODE_3)
>  			command1 |= SPI_CONTROL_MODE_3;
>  
> -		tegra_spi_writel(tspi, command1, SPI_COMMAND1);
> +		if (tspi->cs_control) {
> +			if (tspi->cs_control != spi)
> +				tegra_spi_writel(tspi, command1, SPI_COMMAND1);

Do you really need a separate write call there? The value of command1
isn't fully set up there (the CS bits are all set up immediately after),
so won't that glitch the CS lines in some cases?

> +			tspi->cs_control = NULL;
> +		} else
> +			tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>  
>  		command1 |= SPI_CS_SW_HW;
>  		if (spi->mode & SPI_CS_HIGH)
> @@ -732,6 +738,9 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>  		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
>  	}
>  
> +	if (t->len == 0 && !t->tx_buf && !t->rx_buf)
> +		return 0;

What if !t->len, but t->tx_buf || t->rx_buf ?

This code is also duplicated in tegra_spi_transfer_one_message() after
this patch. Instead, perhaps the first N lines of
tegra_spi_start_transfer_one() should be split out into e.g.
tegra_spi_setup_transfer_one(), such that
tegra_spi_transfer_one_message() can always call it, plus have
tegra_spi_transfer_one_message() only call
tegra_spi_start_transfer_one() if (t->len != 0).

