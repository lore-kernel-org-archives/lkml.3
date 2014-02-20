Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaBTPlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:41:24 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:65267 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBTPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <1392907389-21798-8-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
	<1392907389-21798-8-git-send-email-geert@linux-m68k.org>
Date: Fri, 21 Feb 2014 00:41:18 +0900
Message-ID: <CANqRtoQVJzEgo_AdVxrPSRUY6ocyPaQ=RKQJyxoExDrfYxiJ3w@mail.gmail.com>
Subject: Re: [PATCH 07/10] spi: sh-msiof: Add support for R-Car H2 and M2
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:43 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Add support for the MSIOF variant in the R-Car H2 (r8a7790) and M2
> (r8a7791) SoCs.
>
> Binding documentation:
>   - Add future-proof "renesas,msiof-<soctype>" compatible values,
>   - Add example bindings.
>
> Implementation:
>   - MSIOF on R-Car H2 and M2 requires the transmission of dummy data if
>     data is being received only (cfr. "Set SICTR.TSCKE to 1" and "Write
>     dummy transmission data to SITFDR" in paragraph "Transmit and Receive
>     Procedures" of the Hardware User's Manual).
>   - As RX depends on TX, MSIOF on R-Car H2 and M2 also lacks the RSCR
>     register (Receive Clock Select Register), and some bits in the RMDR1
>     (Receive Mode Register 1) and TMDR2 (Transmit Mode Register 2)
>     registers.
>   - Use the recently introduced SPI_MASTER_MUST_TX flag to enable support
>     for dummy transmission in the SPI core, and to differentiate from other
>     MSIOF implementations in code paths that need this.
>   - New DT compatible values ("renesas,msiof-r8a7790" and
>     "renesas,msiof-r8a7791") are added, as well as new platform device
>     names ("spi_r8a7790_msiof" and "spi_r8a7791_msiof").
>   - Hardware features are indicated using a new struct sh_msiof_chipdata,
>     which is used for both DT and legacy binding. For now this contains the
>     SPI master flags only.
>
> This is loosely based on a set of patches from Takashi Yoshii
> <takasi-y@ops.dti.ne.jp>.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/spi/sh-msiof.txt |   21 +++++++-
>  drivers/spi/spi-sh-msiof.c                         |   57 ++++++++++++++++----
>  2 files changed, 66 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
> index 92515c1ececa..31624fb4997d 100644
> --- a/drivers/spi/spi-sh-msiof.c
> +++ b/drivers/spi/spi-sh-msiof.c
> @@ -659,6 +671,23 @@ static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
>  }
>
>  #ifdef CONFIG_OF
> +static const struct sh_msiof_chipdata sh_data = {
> +       .master_flags = 0,
> +};
> +
> +static const struct sh_msiof_chipdata r8a779x_data = {
> +       .master_flags = SPI_MASTER_MUST_TX,
> +};
> +
> +static const struct of_device_id sh_msiof_match[] = {
> +       { .compatible = "renesas,sh-msiof",        .data = &sh_data },
> +       { .compatible = "renesas,sh-mobile-msiof", .data = &sh_data },
> +       { .compatible = "renesas,msiof-r8a7790",   .data = &r8a779x_data },
> +       { .compatible = "renesas,msiof-r8a7791",   .data = &r8a779x_data },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, sh_msiof_match);

Hi Geert,

Thanks for your patches. They all look good in general I think.

On thing stuck out a bit with the bindings. I can see that you specify
both fifo size and use the SoC suffix for the r8a7790 and r8a7791
bindings. Isn't that a bit of redundant information there, if we know
that the SoC is r8a7790 or r8a7791 then can't we simply put that
information in r8a779x_data above and perhaps keep the binding
simpler? Perhaps same thing applies to other properties as well?

Cheers,

/ magnus
