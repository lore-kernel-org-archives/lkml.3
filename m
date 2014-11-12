Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaKLU7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:59:31 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:46465 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaKLU7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:59:30 -0500
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E7AC2@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
	<201409251211.57183.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
	<201409261046.07132.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315E7AC2@NTXXIAMBX02.xacn.micron.com>
Date: Thu, 13 Nov 2014 02:29:29 +0530
Message-ID: <CAD6G_RQGsLP35E-ecNUvSZyGht4bta4dmnMwLdg+QbEp0bTGmg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
From: Jagan Teki <jagannadh.teki@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2014 05:39, bpqw <bpqw@micron.com> wrote:
> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
>
> For Micron SPI NOR flash, enabling or disabling quad I/O protocol is controlled
> by EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7.
> When EVCR bit 7 is reset to 0, the SPI NOR flash will operate in quad I/O mode.
>
> Signed-off-by: bean huo <beanhuo@micron.com>
> Acked-by: Marek Vasut <marex@denx.de>
> ---
>  v1-v2:modified to that capture wait_till_ready()
>          return value,if error,directly return its
>          the value.
>  v2-v3:directly use the reurning error value of
>          read_reg and write_reg,instead of -EINVAL.
>
>  drivers/mtd/spi-nor/spi-nor.c |   46 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mtd/spi-nor.h   |    6 ++++++
>  2 files changed, 52 insertions(+)
>
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c index b5ad6be..486b167 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -878,6 +878,45 @@ static int spansion_quad_enable(struct spi_nor *nor)
>         return 0;
>  }
>
> +static int micron_quad_enable(struct spi_nor *nor) {
> +       int ret, val;
> +
> +       ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
> +       if (ret < 0) {
> +               dev_err(nor->dev, "error %d reading EVCR\n", ret);
> +               return ret;
> +       }

Best to define read_evsr()

> +
> +       write_enable(nor);
> +
> +       /* set EVCR ,enable quad I/O */
> +       nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
> +       ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
> +       if (ret < 0) {
> +               dev_err(nor->dev,
> +                       "error while writing EVCR register\n");
> +               return ret;
> +       }
> +
> +       ret = wait_till_ready(nor);
> +       if (ret)
> +               return ret;

I don't think this will ready w/o wait time or something - may be use
if (wait_till_ready(nor))
       return 1;

> +
> +       /* read EVCR and check it */
> +       ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
> +       if (ret < 0) {
> +               dev_err(nor->dev, "error %d reading EVCR\n", ret);
> +               return ret;
> +       }
> +       if (val & EVCR_QUAD_EN_MICRON) {
> +               dev_err(nor->dev, "Micron EVCR Quad bit not clear\n");
> +               return -EINVAL;
> +       }

IMHO, use read_evcr() as defined above and write the finite statement code like
        ret = read_evcr(nor);
        if (!(ret > 0 && (ret & EVCR_QUAD_EN_MICRON))) {
                dev_err(nor->dev, "Micron EVCR Quad bit not clear\n");
                return -EINVAL;
        }

> +
> +       return 0;
> +}
> +
>  static int set_quad_mode(struct spi_nor *nor, u32 jedec_id)  {
>         int status;
> @@ -890,6 +929,13 @@ static int set_quad_mode(struct spi_nor *nor, u32 jedec_id)
>                         return -EINVAL;
>                 }
>                 return status;
> +       case CFI_MFR_ST:
> +               status = micron_quad_enable(nor);
> +               if (status) {
> +                       dev_err(nor->dev, "Micron quad-read not enabled\n");
> +                       return -EINVAL;
> +               }
> +               return status;
>         default:
>                 status = spansion_quad_enable(nor);
>                 if (status) {
> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h index 9e6294f..d71b659 100644
> --- a/include/linux/mtd/spi-nor.h
> +++ b/include/linux/mtd/spi-nor.h
> @@ -56,6 +56,10 @@
>  /* Used for Spansion flashes only. */
>  #define SPINOR_OP_BRWR         0x17    /* Bank register write */
>
> +/* Used for Micron flashes only. */
> +#define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
> +#define SPINOR_OP_WD_EVCR      0x61    /* Write EVCR register */
> +
>  /* Status Register bits. */
>  #define SR_WIP                 1       /* Write in progress */
>  #define SR_WEL                 2       /* Write enable latch */
> @@ -67,6 +71,8 @@
>
>  #define SR_QUAD_EN_MX          0x40    /* Macronix Quad I/O */
>
> +#define EVCR_QUAD_EN_MICRON    0x80    /* Micron Quad I/O */
> +
>  /* Flag Status Register bits */
>  #define FSR_READY              0x80
>

thanks!
-- 
Jagan.
