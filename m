Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaLQD35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:29:57 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35127 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQD34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:29:56 -0500
Date: Tue, 16 Dec 2014 19:29:52 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Bean Huo =?utf-8?B?6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, Marek Vasut <marex@denx.de>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Message-ID: <20141217032952.GV9759@ld-irv-0074>
References: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 07:09:59AM +0000, Bean Huo 霍斌斌 (beanhuo) wrote:
> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
> 
> For Micron SPI NOR flash,enabling or disabling quad I/O protocol can be done
> By two methods, which are to use EVCR(Enhanced Volatile Configuration Register)
> and the ENTER QUAD I/O MODE command.There is no difference between these two
> methods.Unfortunately,for some Micron spi nor flashes,there no ENTER Quad I/O
> command(35h),such as n25q064.But for all current Micron spi nor,if it support
> quad I/O mode,using EVCR definitely be supported.It is a recommended method to
> enable Quad I/O mode by EVCR,Quad I/O protocol bit 7.When EVCR bit 7 is reset
> to 0,the SPI NOR flash will operate in quad I/O mode.
> 
> This patch has been tested on N25Q512A and MT25TL256BAA1ESF.Micron spi nor of 
> spi_nor_ids[] table all support this method.
> 
> Signed-off-by: bean huo <beanhuo@micron.com>
> Acked-by: Marek Vasut <marex@denx.de>
> ---
> v1-v2:
> 	Modified to that capture wait_till_ready()
> 	return value,if error,directly return its
> 	the value.
>  v2-v3:
> 	Directly use the reurning error value of
> 	read_reg and write_reg,instead of -EINVAL.
>  v3-v4:
> 	Modify commit logs that wraped into 80 columns.
>  v4-v5:
> 	Rebuild new patch based on latest linux-mtd.
>  v5-v6:
> 	Rebuild patch based on latest l2-mtd.
> 	add some comments.
> 	Add SPI_NOR_QUAD_READ flag in the spi_nor_ids[] for Micron spi nor.
> 
>  drivers/mtd/spi-nor/spi-nor.c |   61 +++++++++++++++++++++++++++++++++++------
>  include/linux/mtd/spi-nor.h   |    7 +++++
>  2 files changed, 60 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index 0f8ec3c..128941e 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -560,14 +560,14 @@ static const struct spi_device_id spi_nor_ids[] = {
>  	{ "mx66l1g55g",  INFO(0xc2261b, 0, 64 * 1024, 2048, SPI_NOR_QUAD_READ) },
>  
>  	/* Micron */
> -	{ "n25q032",	 INFO(0x20ba16, 0, 64 * 1024,   64, 0) },
> -	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, 0) },
> -	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, 0) },
> -	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
> -	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
> -	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
> -	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, USE_FSR) },
> -	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, USE_FSR) },
> +	{ "n25q032",	 INFO(0x20ba16, 0, 64 * 1024,   64, SPI_NOR_QUAD_READ) },
> +	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, SPI_NOR_QUAD_READ) },
> +	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
> +	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
> +	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ) },
> +	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
> +	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
> +	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },

Are you sure *all* of these support quad mode? I know some manufacturers
have been known to reuse IDs, and I wouldn't want a false positive to
slip in here, where an old part might not support it but the new one
does...

>  
>  	/* PMC */
>  	{ "pm25lv512",   INFO(0,        0, 32 * 1024,    2, SECT_4K_PMC) },
> @@ -891,6 +891,44 @@ static int spansion_quad_enable(struct spi_nor *nor)
>  	return 0;
>  }
>  
> +static int micron_quad_enable(struct spi_nor *nor)
> +{
> +	int ret, val;
> +
> +	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);

sparse (rightfully) complains about this line:

drivers/mtd/spi-nor/spi-nor.c: In function ‘micron_quad_enable’:
drivers/mtd/spi-nor/spi-nor.c:898:2: warning: passing argument 3 of ‘nor->read_reg’ from incompatible pointer type [enabled by default]
  ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
  ^
drivers/mtd/spi-nor/spi-nor.c:898:2: note: expected ‘u8 *’ but argument is of type ‘int *’
drivers/mtd/spi-nor/spi-nor.c:898:54: warning: incorrect type in argument 3 (different type sizes) [sparse]
drivers/mtd/spi-nor/spi-nor.c:898:54:    expected unsigned char [usertype] *buf [sparse]
drivers/mtd/spi-nor/spi-nor.c:898:54:    got int *<noident> [sparse]

So 'val' should be of type u8. Otherwise, you risk utilizing
uninitialized data for the other 32-8 bits.

> +	if (ret < 0) {
> +		dev_err(nor->dev, "error %d reading EVCR\n", ret);
> +		return ret;
> +	}
> +
> +	write_enable(nor);
> +
> +	/* set EVCR ,enable quad I/O */

You have the space on the wrong side of the comma.

> +	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
> +	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
> +	if (ret < 0) {
> +		dev_err(nor->dev, "error while writing EVCR register\n");
> +		return ret;
> +	}
> +
> +	ret = spi_nor_wait_till_ready(nor);
> +	if (ret)
> +		return ret;
> +
> +	/* read EVCR and check it */
> +	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);

Same here:

drivers/mtd/spi-nor/spi-nor.c:919:2: warning: passing argument 3 of ‘nor->read_reg’ from incompatible pointer type [enabled by default]
  ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
  ^
drivers/mtd/spi-nor/spi-nor.c:919:2: note: expected ‘u8 *’ but argument is of type ‘int *’
drivers/mtd/spi-nor/spi-nor.c:919:54: warning: incorrect type in argument 3 (different type sizes) [sparse]
drivers/mtd/spi-nor/spi-nor.c:919:54:    expected unsigned char [usertype] *buf [sparse]
drivers/mtd/spi-nor/spi-nor.c:919:54:    got int *<noident> [sparse]

> +	if (ret < 0) {
> +		dev_err(nor->dev, "error %d reading EVCR\n", ret);
> +		return ret;
> +	}
> +	if (val & EVCR_QUAD_EN_MICRON) {
> +		dev_err(nor->dev, "Micron EVCR Quad bit not clear\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int set_quad_mode(struct spi_nor *nor, struct flash_info *info)
>  {
>  	int status;
> @@ -903,6 +941,13 @@ static int set_quad_mode(struct spi_nor *nor, struct flash_info *info)
>  			return -EINVAL;
>  		}
>  		return status;
> +	case CFI_MFR_ST:
> +		status = micron_quad_enable(nor);
> +		if (status) {
> +			dev_err(nor->dev, "Micron quad-read not enabled\n");
> +			return -EINVAL;
> +		}
> +		return status;
>  	default:
>  		status = spansion_quad_enable(nor);
>  		if (status) {
> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
> index 63aeccf..4720b86 100644
> --- a/include/linux/mtd/spi-nor.h
> +++ b/include/linux/mtd/spi-nor.h
> @@ -56,6 +56,10 @@
>  /* Used for Spansion flashes only. */
>  #define SPINOR_OP_BRWR		0x17	/* Bank register write */
>  
> +/* Used for Micron flashes only. */
> +#define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
> +#define SPINOR_OP_WD_EVCR      0x61    /* Write EVCR register */
> +
>  /* Status Register bits. */
>  #define SR_WIP			1	/* Write in progress */
>  #define SR_WEL			2	/* Write enable latch */
> @@ -67,6 +71,9 @@
>  
>  #define SR_QUAD_EN_MX		0x40	/* Macronix Quad I/O */
>  
> +/* Enhanced Volatile Configuration Register bits */
> +#define EVCR_QUAD_EN_MICRON    0x80    /* Micron Quad I/O */
> +
>  /* Flag Status Register bits */
>  #define FSR_READY		0x80
>  

With int vs. u8 fixed up, this looks good. Hopefully I can take v7!

Thanks,
Brian
