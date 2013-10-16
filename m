Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3JPIKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:10:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab3JPIKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:10:37 -0400
Date: Wed, 16 Oct 2013 09:10:35 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] clk: s3c64xx: Correct spi bus clock hookups
Message-ID: <20131016081035.GD20219@opensource.wolfsonmicro.com>
References: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1785136.Xbc2LARBDy@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1785136.Xbc2LARBDy@flatron>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ samsung soc mailing list

On Wed, Oct 16, 2013 at 12:52:42AM +0200, Tomasz Figa wrote:
> Hi Charles,
> 
> On Tuesday 15 of October 2013 13:26:22 Charles Keepax wrote:
> >  	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
> >  	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
> > -	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi-bus"),
> > -	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi-bus"),
> > +	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi_busclk0"),
> > +	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi_busclk1"),
> > +	ALIAS(SCLK_SPI1_48, "s3c6410-spi.1", "spi_busclk2"),
> 
> ...according to the documentation, the order is different. The SPI_CLKSEL 
> field of CLK_CFG register of the SPI block can have following values:
> 0 - PCLK (aka PCLK_SPIx)
> 1 - USBCLK (aka SCLK_SPIx_48)
> 2 - Epll clock (aka SCLK_SPIx)
> 
> The index after spi_busclk corresponds to the value written to SPI_CLKSEL 
> field, so your patch should be adjusted accordingly.

Hmm... will probably need to test this to see what happens the
old clock setup was this:

	CLKDEV_INIT(NULL, "spi_busclk0", &clk_p),
	CLKDEV_INIT("s3c6410-spi.0", "spi_busclk1", &clk_sclk_spi0.clk),
	CLKDEV_INIT("s3c6410-spi.0", "spi_busclk2", &clk_48m_spi0),
	CLKDEV_INIT("s3c6410-spi.1", "spi_busclk1", &clk_sclk_spi1.clk),
	CLKDEV_INIT("s3c6410-spi.1", "spi_busclk2", &clk_48m_spi1),

Which appears to differ from the documentation, that said though
I would wager that only the first of those has really had much
testing.

> 
> By the way, the USBCLK case is a bit strange, because it requires USB 
> signal mask to be unmasked, which in turn needs USB PHY to be enabled, as 
> otherwise some "unwanted leakage" can occur. Having to enable USB just to 
> use SPI seems rather inconvenient (especially in terms of power 
> consumption), so the usability of this clock is rather limited and it 
> might be better not to let the driver know about it.

Seems reasonable to drop this for now and it could be added back
in if someone specifically needed to use it.

Thanks,
Charles

