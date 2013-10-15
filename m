Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab3JOWwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 18:52:46 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36476 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab3JOWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 18:52:45 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] clk: s3c64xx: Correct spi bus clock hookups
Date: Wed, 16 Oct 2013 00:52:42 +0200
Message-ID: <1785136.Xbc2LARBDy@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On Tuesday 15 of October 2013 13:26:22 Charles Keepax wrote:
> Correct the SPI bus clock hookups to match their state before the switch
> to this driver. With out this patch my system (based on an s3c6410)
> can't locate any spibus clock.

That's right, a patch like this is needed indeed, however...

> Note, I only have a passing familiarity with this driver and subsystem
> so this patch could probably use a careful eye.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/clk/samsung/clk-s3c64xx.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-s3c64xx.c
> b/drivers/clk/samsung/clk-s3c64xx.c index 7d2c842..f6ac974 100644
> --- a/drivers/clk/samsung/clk-s3c64xx.c
> +++ b/drivers/clk/samsung/clk-s3c64xx.c
> @@ -356,8 +356,12 @@ static struct samsung_clock_alias
> s3c64xx_clock_aliases[] = { ALIAS(SCLK_MMC2, "s3c-sdhci.2",
> "mmc_busclk.2"),
>  	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
>  	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
> -	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi-bus"),
> -	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi-bus"),
> +	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi_busclk0"),
> +	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi_busclk1"),
> +	ALIAS(SCLK_SPI1_48, "s3c6410-spi.1", "spi_busclk2"),

...according to the documentation, the order is different. The SPI_CLKSEL 
field of CLK_CFG register of the SPI block can have following values:
0 - PCLK (aka PCLK_SPIx)
1 - USBCLK (aka SCLK_SPIx_48)
2 - Epll clock (aka SCLK_SPIx)

The index after spi_busclk corresponds to the value written to SPI_CLKSEL 
field, so your patch should be adjusted accordingly.

By the way, the USBCLK case is a bit strange, because it requires USB 
signal mask to be unmasked, which in turn needs USB PHY to be enabled, as 
otherwise some "unwanted leakage" can occur. Having to enable USB just to 
use SPI seems rather inconvenient (especially in terms of power 
consumption), so the usability of this clock is rather limited and it 
might be better not to let the driver know about it.

Best regards,
Tomasz

P.S. Please keep linux-samsung-soc mailing list on Cc when sending patches 
for Samsung hardware.

