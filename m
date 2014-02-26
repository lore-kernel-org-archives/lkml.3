Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaBZWPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:15:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaBZWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:15:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] spi: sh-msiof: Add support for R-Car H2 and M2
Date: Wed, 26 Feb 2014 23:16:57 +0100
Message-ID: <38730952.JbtPf2mapG@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393323673-2751-4-git-send-email-geert@linux-m68k.org>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org> <1393323673-2751-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

Overall the series is great. I ran some time ago into issues with CCF due to 
the driver use of spi-bitbang, I'm happy to see this being fixed, thanks a 
lot. I have one small comment below though.

On Tuesday 25 February 2014 11:21:10 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Add support for the MSIOF variant in the R-Car H2 (r8a7790) and M2
> (r8a7791) SoCs.
> 
> Binding documentation:
>   - Add future-proof "renesas,msiof-<soctype>" compatible values,
>   - The default for "renesas,rx-fifo-size" is 256 on R-Car H2 and M2,
>   - "renesas,tx-fifo-size" and "renesas,rx-fifo-size" are deprecated for
>     soctype-specific bindings,
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
>   - The default RX FIFO size is 256 words on R-Car H2 and M2.
> 
> This is loosely based on a set of patches from Takashi Yoshii
> <takasi-y@ops.dti.ne.jp>.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> Cc: devicetree@vger.kernel.org
> ---
> v2:
>   - Rebased on top of new "spi: sh-msiof: Move default FIFO sizes to device
>     ID data",
>   - The default RX FIFO size is 256 words on R-Car H2 and M2,
>   - Deprecated overriding the FIFO size,
>   - Synced DT example with node from real DTS.
> 
>  Documentation/devicetree/bindings/spi/sh-msiof.txt |   23 +++++++++++++++--
>  drivers/spi/spi-sh-msiof.c                         |   23 ++++++++++++++---
>  2 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> b/Documentation/devicetree/bindings/spi/sh-msiof.txt index
> eae3c8c9300e..1f0cb33763a1 100644
> --- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> +++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
> @@ -1,8 +1,13 @@
>  Renesas MSIOF spi controller
> 
>  Required properties:
> -- compatible           : "renesas,sh-msiof" for SuperH, or
> +- compatible           : "renesas,msiof-<soctype>" for SoCs,
> +			 "renesas,sh-msiof" for SuperH, or
>  			 "renesas,sh-mobile-msiof" for SH Mobile series.
> +			 Examples with soctypes are:
> +			 "renesas,msiof-sh7724" (SH)

Given that the driver doesn't handle the "renesas,msiof-sh7724" compatible 
string this might not be a good example. Furthermore SuperH doesn't have DT 
support. I would thus drop the "renesas,sh-msiof" compatible string from patch 
1/6 and wouldn't mention sh7724 here. I very much doubt that someone would 
have developed DT support for SuperH on the side and shipped products that 
would be broken by this change :-)

> +			 "renesas,msiof-r8a7790" (R-Car H2)
> +			 "renesas,msiof-r8a7791" (R-Car M2)
>  - reg                  : Offset and length of the register set for the
> device - interrupt-parent     : The phandle for the interrupt controller
> that services interrupts for this device
> @@ -13,10 +18,24 @@ Required properties:
>  Optional properties:
>  - clocks               : Must contain a reference to the functional clock.
>  - num-cs               : Total number of chip-selects (default is 1)
> +
> +Optional properties, deprecated for soctype-specific bindings:
>  - renesas,tx-fifo-size : Overrides the default tx fifo size given in words
>  			 (default is 64)
>  - renesas,rx-fifo-size : Overrides the default rx fifo size given in words
> -			 (default is 64)
> +			 (default is 64, or 256 on R-Car H2 and M2)
> 
>  Pinctrl properties might be needed, too.  See
>  Documentation/devicetree/bindings/pinctrl/renesas,*.
> +
> +Example:
> +
> +	msiof0: spi@e6e20000 {
> +		compatible = "renesas,msiof-r8a7791";
> +		reg = <0 0xe6e20000 0 0x0064>;
> +		interrupts = <0 156 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp0_clks R8A7791_CLK_MSIOF0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		status = "disabled";
> +	};
> diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
> index bf389184924d..3baef2bacaed 100644
> --- a/drivers/spi/spi-sh-msiof.c
> +++ b/drivers/spi/spi-sh-msiof.c
> @@ -34,6 +34,7 @@
>  struct sh_msiof_chipdata {
>  	u16 tx_fifo_size;
>  	u16 rx_fifo_size;
> +	u16 master_flags;
>  };
> 
>  struct sh_msiof_spi_priv {
> @@ -214,7 +215,8 @@ static void sh_msiof_spi_set_clk_regs(struct
> sh_msiof_spi_priv *p, k = min_t(int, k, ARRAY_SIZE(sh_msiof_spi_clk_table)
> - 1);
> 
>  	sh_msiof_write(p, TSCR, sh_msiof_spi_clk_table[k].scr);
> -	sh_msiof_write(p, RSCR, sh_msiof_spi_clk_table[k].scr);
> +	if (!(p->chipdata->master_flags & SPI_MASTER_MUST_TX))
> +		sh_msiof_write(p, RSCR, sh_msiof_spi_clk_table[k].scr);
>  }
> 
>  static void sh_msiof_spi_set_pin_regs(struct sh_msiof_spi_priv *p,
> @@ -237,6 +239,10 @@ static void sh_msiof_spi_set_pin_regs(struct
> sh_msiof_spi_priv *p, tmp |= !cs_high << MDR1_SYNCAC_SHIFT;
>  	tmp |= lsb_first << MDR1_BITLSB_SHIFT;
>  	sh_msiof_write(p, TMDR1, tmp | MDR1_TRMD | TMDR1_PCON);
> +	if (p->chipdata->master_flags & SPI_MASTER_MUST_TX) {
> +		/* These bits are reserved if RX needs TX */
> +		tmp &= ~0x0000ffff;
> +	}
>  	sh_msiof_write(p, RMDR1, tmp);
> 
>  	tmp = 0;
> @@ -257,7 +263,7 @@ static void sh_msiof_spi_set_mode_regs(struct
> sh_msiof_spi_priv *p, {
>  	u32 dr2 = MDR2_BITLEN1(bits) | MDR2_WDLEN1(words);
> 
> -	if (tx_buf)
> +	if (tx_buf || (p->chipdata->master_flags & SPI_MASTER_MUST_TX))
>  		sh_msiof_write(p, TMDR2, dr2);
>  	else
>  		sh_msiof_write(p, TMDR2, dr2 | MDR2_GRPMASK1);
> @@ -666,11 +672,20 @@ static u32 sh_msiof_spi_txrx_word(struct spi_device
> *spi, unsigned nsecs, static const struct sh_msiof_chipdata sh_data = {
>  	.tx_fifo_size = 64,
>  	.rx_fifo_size = 64,
> +	.master_flags = 0,
> +};
> +
> +static const struct sh_msiof_chipdata r8a779x_data = {
> +	.tx_fifo_size = 64,
> +	.rx_fifo_size = 256,
> +	.master_flags = SPI_MASTER_MUST_TX,
>  };
> 
>  static const struct of_device_id sh_msiof_match[] = {
>  	{ .compatible = "renesas,sh-msiof",        .data = &sh_data },
>  	{ .compatible = "renesas,sh-mobile-msiof", .data = &sh_data },
> +	{ .compatible = "renesas,msiof-r8a7790",   .data = &r8a779x_data },
> +	{ .compatible = "renesas,msiof-r8a7791",   .data = &r8a779x_data },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, sh_msiof_match);
> @@ -789,7 +804,7 @@ static int sh_msiof_spi_probe(struct platform_device
> *pdev) /* init master and bitbang code */
>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
>  	master->mode_bits |= SPI_LSB_FIRST | SPI_3WIRE;
> -	master->flags = 0;
> +	master->flags = p->chipdata->master_flags;
>  	master->bus_num = pdev->id;
>  	master->dev.of_node = pdev->dev.of_node;
>  	master->num_chipselect = p->info->num_chipselect;
> @@ -832,6 +847,8 @@ static int sh_msiof_spi_remove(struct platform_device
> *pdev)
> 
>  static struct platform_device_id spi_driver_ids[] = {
>  	{ "spi_sh_msiof",	(kernel_ulong_t)&sh_data },
> +	{ "spi_r8a7790_msiof",	(kernel_ulong_t)&r8a779x_data },
> +	{ "spi_r8a7791_msiof",	(kernel_ulong_t)&r8a779x_data },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(platform, spi_driver_ids);

-- 
Regards,

Laurent Pinchart

