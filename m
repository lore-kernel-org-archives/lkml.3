Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaGaHGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:06:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40670 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaGaHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:06:48 -0400
Date: Thu, 31 Jul 2014 00:06:43 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michal.simek@xilinx.com, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, arnd@arndb.de, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, pekon@ti.com, jussi.kivilinna@iki.fi,
        acourbot@nvidia.com, ivan.khoronzhuk@ti.com, joern@logfs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        anirudh@xilinx.com, svemula@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH RFC v4 3/4] nand: pl353: Add ONDIE ECC support
Message-ID: <20140731070643.GG11952@brian-ubuntu>
References: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
 <27fce982-6598-44a0-ad80-c13d02a952ee@BN1AFFO11FD042.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27fce982-6598-44a0-ad80-c13d02a952ee@BN1AFFO11FD042.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Punnaiah,

I haven't looked too closely at everything here, but a few comments:

On Mon, Jul 28, 2014 at 09:01:39PM +0530, Punnaiah Choudary Kalluri wrote:
> Added ONDIE ECC support. Currently this ecc mode is supported for
> specific micron parts with oob size 64 bytes.
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
> Changes in v4:
> - Updated the driver to sync with pl353_smc driver APIs
> ---
>  drivers/mtd/nand/pl353_nand.c |  162 ++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 144 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/mtd/nand/pl353_nand.c b/drivers/mtd/nand/pl353_nand.c
> index 93dc4ca..5c9b60d 100644
> --- a/drivers/mtd/nand/pl353_nand.c
> +++ b/drivers/mtd/nand/pl353_nand.c
> @@ -140,6 +140,48 @@ static struct nand_ecclayout nand_oob_64 = {
>  		 .length = 50} }
>  };
>  
> +static struct nand_ecclayout ondie_nand_oob_64 = {
> +	.eccbytes = 32,
> +
> +	.eccpos = {
> +		8, 9, 10, 11, 12, 13, 14, 15,
> +		24, 25, 26, 27, 28, 29, 30, 31,
> +		40, 41, 42, 43, 44, 45, 46, 47,
> +		56, 57, 58, 59, 60, 61, 62, 63
> +	},
> +
> +	.oobfree = {
> +		{ .offset = 4, .length = 4 },
> +		{ .offset = 20, .length = 4 },
> +		{ .offset = 36, .length = 4 },
> +		{ .offset = 52, .length = 4 }
> +	}
> +};
> +
> +/* Generic flash bbt decriptors */
> +static uint8_t bbt_pattern[] = { 'B', 'b', 't', '0' };
> +static uint8_t mirror_pattern[] = { '1', 't', 'b', 'B' };
> +
> +static struct nand_bbt_descr bbt_main_descr = {
> +	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
> +		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
> +	.offs = 4,
> +	.len = 4,
> +	.veroffs = 20,
> +	.maxblocks = 4,
> +	.pattern = bbt_pattern
> +};
> +
> +static struct nand_bbt_descr bbt_mirror_descr = {
> +	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
> +		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
> +	.offs = 4,
> +	.len = 4,
> +	.veroffs = 20,
> +	.maxblocks = 4,
> +	.pattern = mirror_pattern
> +};

Why do you need a custom BBT descriptor? It's much better to use the
standard ones. Perhaps you just want the NAND_BBT_NO_OOB_BBM option, so
you get the bbt_{main,mirror}_no_oob_descr structs from nand_bbt.c.

> +
>  /**
>   * pl353_nand_calculate_hwecc - Calculate Hardware ECC
>   * @mtd:	Pointer to the mtd_info structure
> @@ -816,15 +858,74 @@ static int pl353_nand_device_ready(struct mtd_info *mtd)
>  }
>  
>  /**
> + * pl353_nand_detect_ondie_ecc - Get the flash ondie ecc state
> + * @mtd:	Pointer to the mtd_info structure
> + *
> + * This function enables the ondie ecc for the Micron ondie ecc capable devices
> + *
> + * Return:	1 on detect, 0 if fail to detect
> + */
> +static int pl353_nand_detect_ondie_ecc(struct mtd_info *mtd)

No. On-die ECC support should not be added to a specific NAND driver; it
needs to be written generically as part of nand_base. There have been
recent attempts to do this for Toshiba (try searching the linux-mtd
archives, in the last 4 months or so), but they fell a little short. I'd
rather start with a nand_base approach though.

> +{
> +	struct nand_chip *nand_chip = mtd->priv;
> +	u8 maf_id, dev_id, i, get_feature;
> +	u8 set_feature[4] = { 0x08, 0x00, 0x00, 0x00 };
> +
> +	/* Check if On-Die ECC flash */
> +	nand_chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
> +	nand_chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
> +
> +	/* Read manufacturer and device IDs */
> +	maf_id = readb(nand_chip->IO_ADDR_R);
> +	dev_id = readb(nand_chip->IO_ADDR_R);
> +
> +	if ((maf_id == NAND_MFR_MICRON) &&
> +	    ((dev_id == 0xf1) || (dev_id == 0xa1) ||
> +	     (dev_id == 0xb1) || (dev_id == 0xaa) ||
> +	     (dev_id == 0xba) || (dev_id == 0xda) ||
> +	     (dev_id == 0xca) || (dev_id == 0xac) ||
> +	     (dev_id == 0xbc) || (dev_id == 0xdc) ||
> +	     (dev_id == 0xcc) || (dev_id == 0xa3) ||
> +	     (dev_id == 0xb3) ||
> +	     (dev_id == 0xd3) || (dev_id == 0xc3))) {

So you're writing this with a list of device IDs? Would it make more
sense to use the ONFI parameters?

> +
> +		nand_chip->cmdfunc(mtd, NAND_CMD_GET_FEATURES,
> +				   ONDIE_ECC_FEATURE_ADDR, -1);
> +		get_feature = readb(nand_chip->IO_ADDR_R);
> +
> +		if (get_feature & 0x08) {
> +			return 1;
> +		} else {
> +			nand_chip->cmdfunc(mtd, NAND_CMD_SET_FEATURES,
> +					   ONDIE_ECC_FEATURE_ADDR, -1);
> +			for (i = 0; i < 4; i++)
> +				writeb(set_feature[i], nand_chip->IO_ADDR_W);
> +
> +			ndelay(1000);
> +
> +			nand_chip->cmdfunc(mtd, NAND_CMD_GET_FEATURES,
> +					   ONDIE_ECC_FEATURE_ADDR, -1);
> +			get_feature = readb(nand_chip->IO_ADDR_R);
> +
> +			if (get_feature & 0x08)
> +				return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * pl353_nand_ecc_init - Initialize the ecc information as per the ecc mode
>   * @mtd:	Pointer to the mtd_info structure
> + * @ondie_ecc_state:	ondie ecc status
>   *
>   * This function initializes the ecc block and functional pointers as per the
>   * ecc mode
>   *
>   * Return:	Zero on success and error on failure.
>   */
> -static int pl353_nand_ecc_init(struct mtd_info *mtd)
> +static int pl353_nand_ecc_init(struct mtd_info *mtd, int ondie_ecc_state)
>  {
>  	struct nand_chip *nand_chip = mtd->priv;
>  	struct pl353_nand_info *xnand =
> @@ -838,27 +939,50 @@ static int pl353_nand_ecc_init(struct mtd_info *mtd)
>  
>  	switch (xnand->ecc_mode) {
>  	case NAND_ECC_HW:
> -		if (mtd->writesize > 2048) {
> +		if ((mtd->writesize > 2048) || ((ondie_ecc_state) &&
> +						(mtd->oobsize != 64))) {
>  			pr_warn("hardware ECC not possible\n");
>  			return -ENOTSUPP;
>  		}
>  
>  		nand_chip->ecc.mode = NAND_ECC_HW;
> -		nand_chip->ecc.calculate = pl353_nand_calculate_hwecc;
> -		nand_chip->ecc.correct = pl353_nand_correct_data;
> -		nand_chip->ecc.hwctl = NULL;
> -		nand_chip->ecc.read_page = pl353_nand_read_page_hwecc;
> -		nand_chip->ecc.size = PL353_NAND_ECC_SIZE;
> -		nand_chip->ecc.write_page = pl353_nand_write_page_hwecc;
> -		pl353_smc_set_ecc_pg_size(mtd->dev.parent, mtd->writesize);
> -		pl353_smc_set_ecc_mode(mtd->dev.parent, PL353_SMC_ECCMODE_APB);
> -		/* Hardware ECC generates 3 bytes ECC code for each 512 bytes */
> -		nand_chip->ecc.bytes = 3;
> -
> -		if (mtd->oobsize == 16)
> -			nand_chip->ecc.layout = &nand_oob_16;
> -		else
> -			nand_chip->ecc.layout = &nand_oob_64;
> +		if (ondie_ecc_state) {
> +			/* Bypass the controller ECC block */
> +			pl353_smc_set_ecc_mode(mtd->dev.parent,
> +						PL353_SMC_ECCMODE_BYPASS);
> +			nand_chip->ecc.bytes = 0;
> +			nand_chip->ecc.layout = &ondie_nand_oob_64;
> +			nand_chip->ecc.read_page = pl353_nand_read_page_raw;
> +			nand_chip->ecc.write_page = pl353_nand_write_page_raw;
> +			nand_chip->ecc.size = mtd->writesize;
> +			/*
> +			 * On-Die ECC spare bytes offset 8 is used for ECC codes
> +			 * Use the BBT pattern descriptors
> +			 */
> +			nand_chip->bbt_td = &bbt_main_descr;
> +			nand_chip->bbt_md = &bbt_mirror_descr;
> +		} else {
> +			nand_chip->ecc.calculate = pl353_nand_calculate_hwecc;
> +			nand_chip->ecc.correct = pl353_nand_correct_data;
> +			nand_chip->ecc.hwctl = NULL;
> +			nand_chip->ecc.read_page = pl353_nand_read_page_hwecc;
> +			nand_chip->ecc.size = PL353_NAND_ECC_SIZE;
> +			nand_chip->ecc.write_page = pl353_nand_write_page_hwecc;
> +			pl353_smc_set_ecc_pg_size(mtd->dev.parent,
> +							mtd->writesize);
> +			pl353_smc_set_ecc_mode(mtd->dev.parent,
> +							PL353_SMC_ECCMODE_APB);
> +			/*
> +			 * Hardware ECC generates 3 bytes ECC code for each
> +			 * 512 bytes
> +			 */
> +			nand_chip->ecc.bytes = 3;
> +
> +			if (mtd->oobsize == 16)
> +				nand_chip->ecc.layout = &nand_oob_16;
> +			else
> +				nand_chip->ecc.layout = &nand_oob_64;
> +		}
>  
>  		break;
>  	case NAND_ECC_SOFT:
> @@ -901,6 +1025,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
>  	struct nand_chip *nand_chip;
>  	struct resource *res;
>  	struct mtd_part_parser_data ppdata;
> +	int ondie_ecc_state;
>  
>  	xnand = devm_kzalloc(&pdev->dev, sizeof(*xnand), GFP_KERNEL);
>  	if (!xnand)
> @@ -944,6 +1069,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, xnand);
>  
> +	ondie_ecc_state = pl353_nand_detect_ondie_ecc(mtd);
>  	/* first scan to find the device and get the page size */
>  	if (nand_scan_ident(mtd, 1, NULL)) {
>  		dev_err(&pdev->dev, "nand_scan_ident for NAND failed\n");
> @@ -954,7 +1080,7 @@ static int pl353_nand_probe(struct platform_device *pdev)
>  	if (xnand->ecc_mode < 0)
>  		xnand->ecc_mode = NAND_ECC_HW;
>  
> -	if (pl353_nand_ecc_init(mtd))
> +	if (pl353_nand_ecc_init(mtd, ondie_ecc_state))
>  		return -ENOTSUPP;
>  
>  	if (nand_chip->options & NAND_BUSWIDTH_16)

Brian
