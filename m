Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3AUKCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:02:00 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:54050 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUKB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <1358760723-32752-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
	<1358760723-32752-3-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 21 Jan 2013 12:01:57 +0200
Message-ID: <CAHp75VcKv-mtnd4tw0bOD+H8_DvuuWEkdq51cNmeNDHveLVfgA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] spi/pxa2xx: fix warnings when compiling a 64-bit kernel
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:31 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Fix following warnings seen when compiling 64-bit:
>
> drivers/spi/spi-pxa2xx.c: In function ‘map_dma_buffers’: drivers/spi/spi-pxa2xx.c:384:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:384:40: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/spi/spi-pxa2xx.c:1572:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/spi/spi-pxa2xx.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
> index 54097ad..3b831c6 100644
> --- a/drivers/spi/spi-pxa2xx.c
> +++ b/drivers/spi/spi-pxa2xx.c
> @@ -47,7 +47,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
>
>  #define DMA_INT_MASK           (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
>  #define RESET_DMA_CHANNEL      (DCSR_NODESC | DMA_INT_MASK)
> -#define IS_DMA_ALIGNED(x)      ((((u32)(x)) & 0x07) == 0)
> +#define IS_DMA_ALIGNED(x)      IS_ALIGNED((unsigned long)x, DMA_ALIGNMENT)

x -> (x) due to it's used in macro.

>  #define MAX_DMA_LEN            8191
>  #define DMA_ALIGNMENT          8
>
> @@ -1576,8 +1576,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
>         master->transfer = transfer;
>
>         drv_data->ssp_type = ssp->type;
> -       drv_data->null_dma_buf = (u32 *)ALIGN((u32)(drv_data +
> -                                               sizeof(struct driver_data)), 8);
> +       drv_data->null_dma_buf = (u32 *)PTR_ALIGN(&drv_data[1], DMA_ALIGNMENT);
>
>         drv_data->ioaddr = ssp->mmio_base;
>         drv_data->ssdr_physical = ssp->phys_base + SSDR;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
