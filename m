Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaLNQOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:14:49 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60139 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaLNQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:14:48 -0500
X-Auth-Info: DEadbEHMUpK5kdok7K2D2pjiRTWqgpEm0Y/kyJiL06o=
From: Marek Vasut <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Sun, 14 Dec 2014 17:12:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: mturquette@linaro.org, festevam@gmail.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201412141712.12589.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 at 04:28:53 PM, Stefan Wahren wrote:
> According to i.MX23 and i.MX28 reference manual the fractional
> clock control registers must be addressed by byte instructions.
> 
> This patch fixes the erroneous 32-bit access to these registers.
> 
> The changes has been tested only with a i.MX28 board, because i don't
> have access to an i.MX23 board.

The clock block is the same, so this _should_ be fine.

> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  drivers/clk/mxs/clk-imx23.c |    8 +++++---
>  drivers/clk/mxs/clk-imx28.c |   14 ++++++++------
>  drivers/clk/mxs/clk-ref.c   |   19 ++++++++++---------
>  3 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
> index 9fc9359..371ba03 100644
> --- a/drivers/clk/mxs/clk-imx23.c
> +++ b/drivers/clk/mxs/clk-imx23.c
> @@ -46,7 +46,8 @@ static void __iomem *digctrl;
>  #define BP_CLKSEQ_BYPASS_SAIF	0
>  #define BP_CLKSEQ_BYPASS_SSP	5
>  #define BP_SAIF_DIV_FRAC_EN	16
> -#define BP_FRAC_IOFRAC		24
> +
> +#define FRAC_IO	3
> 
>  static void __init clk_misc_init(void)
>  {
> @@ -72,9 +73,10 @@ static void __init clk_misc_init(void)
>  	/*
>  	 * 480 MHz seems too high to be ssp clock source directly,
>  	 * so set frac to get a 288 MHz ref_io.
> +	 * According to reference manual we must access frac bytewise.
>  	 */
> -	writel_relaxed(0x3f << BP_FRAC_IOFRAC, FRAC + CLR);
> -	writel_relaxed(30 << BP_FRAC_IOFRAC, FRAC + SET);
> +	writeb_relaxed(0x3f, FRAC + FRAC_IO + CLR);
> +	writeb_relaxed(30, FRAC + FRAC_IO + SET);
>  }
> 
>  static const char *sel_pll[]  __initconst = { "pll", "ref_xtal", };
> diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
> index a6c3501..3eae119 100644
> --- a/drivers/clk/mxs/clk-imx28.c
> +++ b/drivers/clk/mxs/clk-imx28.c
> @@ -53,8 +53,9 @@ static void __iomem *clkctrl;
>  #define BP_ENET_SLEEP		31
>  #define BP_CLKSEQ_BYPASS_SAIF0	0
>  #define BP_CLKSEQ_BYPASS_SSP0	3
> -#define BP_FRAC0_IO1FRAC	16
> -#define BP_FRAC0_IO0FRAC	24
> +
> +#define FRAC0_IO1	2
> +#define FRAC0_IO0	3
> 
>  static void __iomem *digctrl;
>  #define DIGCTRL digctrl
> @@ -118,11 +119,12 @@ static void __init clk_misc_init(void)
>  	/*
>  	 * 480 MHz seems too high to be ssp clock source directly,
>  	 * so set frac0 to get a 288 MHz ref_io0 and ref_io1.
> +	 * According to reference manual we must access frac0 bytewise.
>  	 */
> -	val = readl_relaxed(FRAC0);
> -	val &= ~((0x3f << BP_FRAC0_IO0FRAC) | (0x3f << BP_FRAC0_IO1FRAC));
> -	val |= (30 << BP_FRAC0_IO0FRAC) | (30 << BP_FRAC0_IO1FRAC);
> -	writel_relaxed(val, FRAC0);
> +	writeb_relaxed(0x3f, FRAC0 + FRAC0_IO0 + CLR);
> +	writeb_relaxed(30, FRAC0 + FRAC0_IO0 + SET);
> +	writeb_relaxed(0x3f, FRAC0 + FRAC0_IO1 + CLR);
> +	writeb_relaxed(30, FRAC0 + FRAC0_IO1 + SET);

This used to be a R-M-W sequence, but now it's changed to multiple writes. This
changes the behavior and seeing you use the CLR register, I am worried this 
might be prone to clock glitches. What do you think please ?

[...]

Also, it might be a good idea to zap the 0x3f mask and use HEX and DEC numbers 
consistently, but this is an idea for another patch.

Best regards,
