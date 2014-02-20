Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaBTPsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:48:12 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45452 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaBTPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:48:08 -0500
MIME-Version: 1.0
In-Reply-To: <1392907779-22053-5-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
	<1392907779-22053-5-git-send-email-geert@linux-m68k.org>
Date: Fri, 21 Feb 2014 00:48:06 +0900
Message-ID: <CANqRtoQQ9cn55Ct7pva2Bo7461WbZG0=Y5f9zLwfKhyU2=QFZw@mail.gmail.com>
Subject: Re: [PATCH 04/11] ARM: shmobile: lager legacy: Add MSIOF support
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thu, Feb 20, 2014 at 11:49 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Add MSIOF resources, platform data, platform device, pinctrl, and SPI
> child device.
>
>   - Platform device numbering is 1-based for compatibility with the BSP,
>     as QSPI uses zero.
>   - Only MSIOF1 is in use, and thus registered. Its bus contains a single
>     device (a Renesas R2A11302FT PMIC).
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>  arch/arm/mach-shmobile/board-lager.c |   64 ++++++++++++++++++++++++++++++----
>  1 file changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
> index f0104bfe544e..6062bcbda366 100644
> --- a/arch/arm/mach-shmobile/board-lager.c
> +++ b/arch/arm/mach-shmobile/board-lager.c
> @@ -55,6 +55,7 @@
>  #include <linux/mtd/mtd.h>
>  #include <linux/spi/flash.h>
>  #include <linux/spi/rspi.h>
> +#include <linux/spi/sh_msiof.h>
>  #include <linux/spi/spi.h>
>  #include <sound/rcar_snd.h>
>  #include <sound/simple_card.h>
> @@ -287,6 +288,40 @@ static const struct platform_device_info ether_info __initconst = {
>         .dma_mask       = DMA_BIT_MASK(32),
>  };
>
> +/* MSIOF */
> +static const struct resource sh_msiof0_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6e20000, 0x0064),
> +       DEFINE_RES_IRQ(gic_spi(156)),
> +};
> +
> +static const struct resource sh_msiof1_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6e10000, 0x0064),
> +       DEFINE_RES_IRQ(gic_spi(157)),
> +};
> +
> +static const struct resource sh_msiof2_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6e00000, 0x0064),
> +       DEFINE_RES_IRQ(gic_spi(158)),
> +};
> +
> +static const struct resource sh_msiof3_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6c90000, 0x0064),
> +       DEFINE_RES_IRQ(gic_spi(159)),
> +};
> +
> +static const struct sh_msiof_spi_info sh_msiof_info __initconst = {
> +       .rx_fifo_override       = 256,
> +       .num_chipselect         = 1,
> +};
> +
> +#define r8a7790_register_msiof(idx)                                    \
> +       platform_device_register_resndata(&platform_bus,                \
> +                               "spi_r8a7790_msiof",                    \
> +                               (idx+1), sh_msiof##idx##_resources,     \
> +                               ARRAY_SIZE(sh_msiof##idx##_resources),  \
> +                               &sh_msiof_info,                         \
> +                               sizeof(struct sh_msiof_spi_info))

Hi Geert,

That for your efforts - it's good to see the MSIOF being integrated as
well! I have one comment on this legacy board integration code.

Since only MSIOF1 is used on Lager (correct me if i'm wrong), isn't it
best to omit the unused resources from above? In case of DT I think it
makes sense to define all channels in the SoC.dtsi and let the
SoC-board.dts just enable the channels that are used. But in this case
with legacy code  I think we should keep thing simple and small and
just enable the bits that are used on the particular board.

The same obviously applies to the Koelsch legacy code as well. =)

Thanks,

/ magnus
