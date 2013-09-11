Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3IKCoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:44:13 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59219 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3IKCoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <1378833022-31046-1-git-send-email-ben.l.gardiner@gmail.com>
References: <1378833022-31046-1-git-send-email-ben.l.gardiner@gmail.com>
Date: Tue, 10 Sep 2013 19:44:11 -0700
Message-ID: <CA+7tXih464v2xwf41rLzG5_mSFG2x7-2Wgde=g-y7d56g_2HeA@mail.gmail.com>
Subject: Re: [PATCH] spi: spi-davinci: deassert CS on setup()
From: Trent Piepho <tpiepho@gmail.com>
To: Ben Gardiner <ben.l.gardiner@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is supposed to be possible to call setup() on one slave while
transfers on another slave attached to the same master are in
progress.

A cursory look at the code makes it seem that all the CS control bits
share SPIDAT1?  Will writing to SPIDAT1 in davinci_spi_chipselect()
cause a race if another chipselect is being used?

On Tue, Sep 10, 2013 at 10:10 AM, Ben Gardiner <ben.l.gardiner@gmail.com> wrote:
> The mmc_spi driver's mmc_cs_off() function states that "chipselect will always
> be inactive after setup()"; however, the spi-davinci driver's setup() leaves CS
> state unchanged.
>
> Add a call to davinci_spi_chipselect(spi, BITBANG_CS_INACTIVE) to the spi-
> davinci drivers' setup() function.
>
> Signed-off-by: Ben Gardiner <ben.l.gardiner@gmail.com>
> ---
>  drivers/spi/spi-davinci.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index 707966b..f0f4dbd 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -404,6 +404,7 @@ static int davinci_spi_setup(struct spi_device *spi)
>                     (pdata->chip_sel[spi->chip_select] == SPI_INTERN_CS))
>                         set_io_bits(dspi->base + SPIPC0, 1 << spi->chip_select);
>
> +               davinci_spi_chipselect(spi, BITBANG_CS_INACTIVE);
>         }
>
>         if (spi->mode & SPI_READY)
> --
> 1.8.1.2
>
>
> ------------------------------------------------------------------------------
> How ServiceNow helps IT people transform IT departments:
> 1. Consolidate legacy IT systems to a single system of record for IT
> 2. Standardize and globalize service processes across IT
> 3. Implement zero-touch automation to replace manual, redundant tasks
> http://pubads.g.doubleclick.net/gampad/clk?id=51271111&iu=/4140/ostg.clktrk
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
