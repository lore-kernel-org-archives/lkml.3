Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbaGEOp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:45:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54243 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGEOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:45:26 -0400
Date: Sat, 5 Jul 2014 16:45:21 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, kernel@pengutronix.de
Subject: Re: [PATH v2] mxc_nand: use our own read_page function
Message-ID: <20140705144521.GA16653@pengutronix.de>
References: <1403815368-29469-2-git-send-email-m.grzeschik@pengutronix.de>
 <1403865524-25061-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403865524-25061-1-git-send-email-m.grzeschik@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:45:04 up 1 day,  1:21, 29 users,  load average: 0,06, 0,04, 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Fri, Jun 27, 2014 at 12:38:44PM +0200, Michael Grzeschik wrote:
> The current approach of the read_page function is to iterate over all
> subpages and call the correct_data function. The correct_data function
> currently does the same. It iterates over all subpages and checks for
> correctable and uncorrectable data. This redundant call for each
> subpage leads to miscalculations.
> 
> This patch changes the driver to use its own read_page function in which
> we call the correct_data function only once per page. With that we do
> the failure and correct statistics counting inside this function.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
> fixed printk to pr_debug
> 
>  drivers/mtd/nand/mxc_nand.c | 73 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index a72d508..5f9e36d 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -141,6 +141,8 @@ struct mxc_nand_host;
>  
>  struct mxc_nand_devtype_data {
>  	void (*preset)(struct mtd_info *);
> +	int (*read_page)(struct mtd_info *mtd, struct nand_chip *chip,
> +			uint8_t *buf, int oob_required, int page);
>  	void (*send_cmd)(struct mxc_nand_host *, uint16_t, int);
>  	void (*send_addr)(struct mxc_nand_host *, uint16_t, int);
>  	void (*send_page)(struct mtd_info *, unsigned int);
> @@ -649,6 +651,59 @@ static int mxc_nand_correct_data_v1(struct mtd_info *mtd, u_char *dat,
>  	return 0;
>  }
>  
> +/**
> + * mxc_nand_read_page_hwecc_v2_v3 - [REPLACEABLE] hardware ECC based page read function
> + * @mtd: mtd info structure
> + * @chip: nand chip info structure
> + * @buf: buffer to store read data
> + * @oob_required: caller requires OOB data read to chip->oob_poi
> + * @page: page number to read
> + *
> + * Not for syndrome calculating ECC controllers which need a special oob layout.
> + */
> +static int
> +mxc_nand_read_page_hwecc_v2_v3(struct mtd_info *mtd,
> +			       struct nand_chip *chip,
> +			       uint8_t *buf, int oob_required, int page)
> +{
> +	int i, eccsize = chip->ecc.size;
> +	struct nand_chip *nand_chip = mtd->priv;
> +	struct mxc_nand_host *host = nand_chip->priv;
> +	int eccbytes = chip->ecc.bytes;
> +	int eccsteps = chip->ecc.steps;
> +	uint8_t *p = buf;
> +	uint8_t *ecc_calc = chip->buffers->ecccalc;
> +	uint8_t *ecc_code = chip->buffers->ecccode;
> +	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	unsigned int max_bitflips = 0;
> +	u32 ecc_stat, err;
> +	int stat;
> +
> +	ecc_stat = host->devtype_data->get_ecc_status(host);
> +	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> +		err = ecc_stat & 0xf;
> +		chip->ecc.hwctl(mtd, NAND_ECC_READ);
> +		chip->read_buf(mtd, p, eccsize);
> +		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		ecc_stat >>= 4;
> +
> +	}
> +	ecc_stat = host->devtype_data->get_ecc_status(host);
> +	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
> +
> +	for (i = 0; i < chip->ecc.total; i++)
> +		ecc_code[i] = chip->oob_poi[eccpos[i]];
> +
> +	eccsteps = chip->ecc.steps;
> +	p = buf;
> +
> +	stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
> +	max_bitflips = max_t(unsigned int, max_bitflips, stat);
> +
> +	return max_bitflips;
> +}
> +
> +
>  static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
>  				 u_char *read_ecc, u_char *calc_ecc)
>  {
> @@ -656,7 +711,7 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
>  	struct mxc_nand_host *host = nand_chip->priv;
>  	u32 ecc_stat, err;
>  	int no_subpages = 1;
> -	int ret = 0;
> +	int ret = 0, broken = 0;
>  	u8 ecc_bit_mask, err_limit = 0x1;
>  
>  	ecc_bit_mask = 0xf;
> @@ -673,15 +728,21 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
>  	do {
>  		err = ecc_stat & ecc_bit_mask;
>  		if (err > err_limit) {
> -			printk(KERN_WARNING "UnCorrectable RS-ECC Error\n");
> -			return -1;
> +			broken++;
>  		} else {
>  			ret += err;
>  		}
>  		ecc_stat >>= 4;
>  	} while (--no_subpages);
>  
> -	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
> +	mtd->ecc_stats.corrected += ret;
> +	if (ret)
> +		pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
> +
> +	mtd->ecc_stats.failed += broken;
> +	if (broken)
> +		printk(KERN_WARNING "%d Symbol UnCorrectable RS-ECC Error\n",
> +			 broken);
>  
>  	return ret;
>  }
> @@ -1216,6 +1277,7 @@ static const struct mxc_nand_devtype_data imx27_nand_devtype_data = {
>  /* v21: i.MX25, i.MX35 */
>  static const struct mxc_nand_devtype_data imx25_nand_devtype_data = {
>  	.preset = preset_v2,
> +	.read_page = mxc_nand_read_page_hwecc_v2_v3,
>  	.send_cmd = send_cmd_v1_v2,
>  	.send_addr = send_addr_v1_v2,
>  	.send_page = send_page_v2,
> @@ -1242,6 +1304,7 @@ static const struct mxc_nand_devtype_data imx25_nand_devtype_data = {
>  /* v3.2a: i.MX51 */
>  static const struct mxc_nand_devtype_data imx51_nand_devtype_data = {
>  	.preset = preset_v3,
> +	.read_page = mxc_nand_read_page_hwecc_v2_v3,
>  	.send_cmd = send_cmd_v3,
>  	.send_addr = send_addr_v3,
>  	.send_page = send_page_v3,
> @@ -1269,6 +1332,7 @@ static const struct mxc_nand_devtype_data imx51_nand_devtype_data = {
>  /* v3.2b: i.MX53 */
>  static const struct mxc_nand_devtype_data imx53_nand_devtype_data = {
>  	.preset = preset_v3,
> +	.read_page = mxc_nand_read_page_hwecc_v2_v3,
>  	.send_cmd = send_cmd_v3,
>  	.send_addr = send_addr_v3,
>  	.send_page = send_page_v3,
> @@ -1483,6 +1547,7 @@ static int mxcnd_probe(struct platform_device *pdev)
>  	this->ecc.layout = host->devtype_data->ecclayout_512;
>  
>  	if (host->pdata.hw_ecc) {
> +		this->ecc.read_page = host->devtype_data->read_page;
>  		this->ecc.calculate = mxc_nand_calculate_ecc;
>  		this->ecc.hwctl = mxc_nand_enable_hwecc;
>  		this->ecc.correct = host->devtype_data->correct_data;
> -- 
> 2.0.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
