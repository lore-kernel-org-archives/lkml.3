Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIYKuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:50:44 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60393 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaIYKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:50:42 -0400
X-Auth-Info: dCpK3dt1mtuFnP13lcBV0I1qEq/4zX4Qx0o+MrlOa9U=
From: Marek Vasut <marex@denx.de>
To: bpqw <bpqw@micron.com>
Subject: Re: [PATCH 1/1] driver:mtd:spi-nor: Add Micron quad I/O support
Date: Thu, 25 Sep 2014 12:11:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409251211.57183.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 at 08:20:35 AM, bpqw wrote:
> For Micron spi norflash,you can enable Quad spi transfer
> by clear EVCR(Enhanced Volatile Configuration Register)
> Quad I/O protocol bit.
> 
> Signed-off-by: bean huo <beanhuo@micron.com>
> ---
>  drivers/mtd/spi-nor/spi-nor.c |   45
> +++++++++++++++++++++++++++++++++++++++++ include/linux/mtd/spi-nor.h   | 
>   6 ++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index b5ad6be..e72894f 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -878,6 +878,44 @@ static int spansion_quad_enable(struct spi_nor *nor)
>  	return 0;
>  }
> 
> +static int micron_quad_enable(struct spi_nor *nor)
> +{
> +	int ret, val;
> +
> +	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
> +	if (ret < 0) {
> +		dev_err(nor->dev, "error %d reading EVCR\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	write_enable(nor);
> +
> +	/* set EVCR ,enable quad I/O */
> +	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
> +	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
> +	if (ret < 0) {
> +		dev_err(nor->dev,
> +			"error while writing EVCR register\n");
> +		return -EINVAL;
> +	}
> +
> +	if (wait_till_ready(nor))
> +		return 1;

Why does this not return proper error code or even better, return value from 
wait_till_ready() ?

Other than that, there's nothing wrong with the patch I think.

Best regards,
Marek Vasut
