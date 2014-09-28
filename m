Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaI1Wns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:43:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48536 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1Wnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:43:47 -0400
X-Auth-Info: BVwmSKZZ7m5SMYMJgOl1d+yWHxZ4HHzr/gUF6a8u90Y=
From: Marek Vasut <marex@denx.de>
To: bpqw <bpqw@micron.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor: Add Micron quad I/O support
Date: Mon, 29 Sep 2014 00:43:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com> <201409261046.07132.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315DCED6@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315DCED6@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409290043.43750.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 28, 2014 at 03:59:42 AM, bpqw wrote:
> For Micron spi norflash,you can enable
> Quad spi transfer by clear EVCR(Enhanced
> Volatile Configuration Register) Quad I/O
> protocol bit.

OK, this information is nice and all, but what does this patch do? I can't learn 
this information from the commit message as it is, can I ? And , the purpose of 
the commit message is exactly to summarize the change the patch implements.

> Signed-off-by: bean huo <beanhuo@micron.com>
> ---
>  v1-v2:modified to that capture wait_till_ready()
> 	return value,if error,directly return its
> 	the value.
> 
>  drivers/mtd/spi-nor/spi-nor.c |   46
> +++++++++++++++++++++++++++++++++++++++++ include/linux/mtd/spi-nor.h   | 
>   6 ++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index b5ad6be..0c3b4fd 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -878,6 +878,45 @@ static int spansion_quad_enable(struct spi_nor *nor)
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

Why not just "return ret;" ?
[...]
