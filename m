Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaBHKgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 05:36:39 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59635 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaBHKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 05:36:37 -0500
Message-ID: <52F608B1.1080401@gmail.com>
Date: Sat, 08 Feb 2014 11:36:33 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [RFC PATCH] mtd: add per NAND partition ECC config
References: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
In-Reply-To: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 11:26, Boris BREZILLON wrote:
> This patch aims to add per partition ECC config for NAND devices.
> It defines a new field in the mtd struct to store the mtd ECC config and
> thus each mtd partition device can store its config instead of using the
> default NAND chip config.
>
> This feature is needed to support the sunxi boot0 paritition case:
> Allwinner boot code (BROM) requires a specific HW ECC for its boot code
> that may not fit the HW NAND requirements for the entire NAND chip.
>
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
> Hello,
>
> This patch is just a draft that implement per partition ECC config.
> It's currently not properly splitted (it should be separated in several
> patches) and not documented either.
>
> There's at least one point that bother me in the current implementation:
> I introduced DT notions in the nand core code by the mean of the get_ecc_ctrl
> callback, and so far this was kept out of mtd/nand core code (I guess it was
> on purpose).
>
> Please let me know if you see other drawbacks.
>
> If you think per partition ECC should not be implemented, could you help me
> find a way to handle sunxi specific case decribed above ?
>
> Best Regards,
>
> Boris
>
>
>
>
>   drivers/mtd/mtdpart.c          |   23 ++-
>   drivers/mtd/nand/nand_base.c   |  428 ++++++++++++++++++++++++----------------
>   drivers/mtd/ofpart.c           |   35 ++++
>   include/linux/mtd/mtd.h        |    3 +
>   include/linux/mtd/nand.h       |   12 ++
>   include/linux/mtd/partitions.h |    1 +
>   6 files changed, 332 insertions(+), 170 deletions(-)
>
> diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
> index 6e732c3..a5e262a 100644
> --- a/drivers/mtd/mtdpart.c
> +++ b/drivers/mtd/mtdpart.c
> @@ -28,6 +28,7 @@
>   #include <linux/list.h>
>   #include <linux/kmod.h>
>   #include <linux/mtd/mtd.h>
> +#include <linux/mtd/nand.h>
>   #include <linux/mtd/partitions.h>
>   #include <linux/err.h>
>   
> @@ -310,6 +311,8 @@ static int part_block_markbad(struct mtd_info *mtd, loff_t ofs)
>   static inline void free_partition(struct mtd_part *p)
>   {
>   	kfree(p->mtd.name);
> +	if (p->mtd.eccctrl && p->mtd.eccctrl->release)
> +		p->mtd.eccctrl->release(p->mtd.eccctrl);
>   	kfree(p);
>   }
>   
> @@ -364,7 +367,13 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>   	slave->mtd.writesize = master->writesize;
>   	slave->mtd.writebufsize = master->writebufsize;
>   	slave->mtd.oobsize = master->oobsize;
> -	slave->mtd.oobavail = master->oobavail;
> +	if (part->eccctrl) {
> +		slave->mtd.eccctrl = part->eccctrl;
> +		slave->mtd.oobavail = part->eccctrl->layout->oobavail;
> +	} else {
> +		slave->mtd.eccctrl = master->eccctrl;
> +		slave->mtd.oobavail = master->oobavail;
> +	}
>   	slave->mtd.subpage_sft = master->subpage_sft;
>   
>   	slave->mtd.name = name;
> @@ -515,9 +524,15 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>   			part->name);
>   	}
>   
> -	slave->mtd.ecclayout = master->ecclayout;
> -	slave->mtd.ecc_step_size = master->ecc_step_size;
> -	slave->mtd.ecc_strength = master->ecc_strength;
> +	if (part->eccctrl) {
> +		slave->mtd.ecclayout = part->eccctrl->layout;
> +		slave->mtd.ecc_step_size = part->eccctrl->size;
> +		slave->mtd.ecc_strength = part->eccctrl->strength;
> +	} else {
> +		slave->mtd.ecclayout = master->ecclayout;
> +		slave->mtd.ecc_step_size = master->ecc_step_size;
> +		slave->mtd.ecc_strength = master->ecc_strength;
> +	}
>   	slave->mtd.bitflip_threshold = master->bitflip_threshold;
>   
>   	if (master->_block_isbad) {
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index f59a465..24c1571 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -45,6 +45,7 @@
>   #include <linux/leds.h>
>   #include <linux/io.h>
>   #include <linux/mtd/partitions.h>
> +#include <linux/of_mtd.h>
>   
>   /* Define default oob placement schemes for large and small page devices */
>   static struct nand_ecclayout nand_oob_8 = {
> @@ -1031,26 +1032,26 @@ static int nand_read_page_raw_syndrome(struct mtd_info *mtd,
>   				       struct nand_chip *chip, uint8_t *buf,
>   				       int oob_required, int page)
>   {
> -	int eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> +	int eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
>   	uint8_t *oob = chip->oob_poi;
>   	int steps, size;
>   
> -	for (steps = chip->ecc.steps; steps > 0; steps--) {
> +	for (steps = mtd->eccctrl->steps; steps > 0; steps--) {
>   		chip->read_buf(mtd, buf, eccsize);
>   		buf += eccsize;
>   
> -		if (chip->ecc.prepad) {
> -			chip->read_buf(mtd, oob, chip->ecc.prepad);
> -			oob += chip->ecc.prepad;
> +		if (mtd->eccctrl->prepad) {
> +			chip->read_buf(mtd, oob, mtd->eccctrl->prepad);
> +			oob += mtd->eccctrl->prepad;
>   		}
>   
>   		chip->read_buf(mtd, oob, eccbytes);
>   		oob += eccbytes;
>   
> -		if (chip->ecc.postpad) {
> -			chip->read_buf(mtd, oob, chip->ecc.postpad);
> -			oob += chip->ecc.postpad;
> +		if (mtd->eccctrl->postpad) {
> +			chip->read_buf(mtd, oob, mtd->eccctrl->postpad);
> +			oob += mtd->eccctrl->postpad;
>   		}
>   	}
>   
> @@ -1072,30 +1073,31 @@ static int nand_read_page_raw_syndrome(struct mtd_info *mtd,
>   static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
>   				uint8_t *buf, int oob_required, int page)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *p = buf;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
>   	uint8_t *ecc_code = chip->buffers->ecccode;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   	unsigned int max_bitflips = 0;
>   
> -	chip->ecc.read_page_raw(mtd, chip, buf, 1, page);
> +	mtd->eccctrl->read_page_raw(mtd, chip, buf, 1, page);
>   
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
> -		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		mtd->eccctrl->calculate(mtd, p, &ecc_calc[i]);
>   
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		ecc_code[i] = chip->oob_poi[eccpos[i]];
>   
> -	eccsteps = chip->ecc.steps;
> +	eccsteps = mtd->eccctrl->steps;
>   	p = buf;
>   
>   	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
>   		int stat;
>   
> -		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
> +		stat = mtd->eccctrl->correct(mtd, p, &ecc_code[i],
> +					     &ecc_calc[i]);
>   		if (stat < 0) {
>   			mtd->ecc_stats.failed++;
>   		} else {
> @@ -1118,7 +1120,7 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   			uint32_t data_offs, uint32_t readlen, uint8_t *bufpoi)
>   {
>   	int start_step, end_step, num_steps;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   	uint8_t *p;
>   	int data_col_addr, i, gaps = 0;
>   	int datafrag_len, eccfrag_len, aligned_len, aligned_pos;
> @@ -1127,15 +1129,15 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   	unsigned int max_bitflips = 0;
>   
>   	/* Column address within the page aligned to ECC size (256bytes) */
> -	start_step = data_offs / chip->ecc.size;
> -	end_step = (data_offs + readlen - 1) / chip->ecc.size;
> +	start_step = data_offs / mtd->eccctrl->size;
> +	end_step = (data_offs + readlen - 1) / mtd->eccctrl->size;
>   	num_steps = end_step - start_step + 1;
>   
>   	/* Data size aligned to ECC ecc.size */
> -	datafrag_len = num_steps * chip->ecc.size;
> -	eccfrag_len = num_steps * chip->ecc.bytes;
> +	datafrag_len = num_steps * mtd->eccctrl->size;
> +	eccfrag_len = num_steps * mtd->eccctrl->bytes;
>   
> -	data_col_addr = start_step * chip->ecc.size;
> +	data_col_addr = start_step * mtd->eccctrl->size;
>   	/* If we read not a page aligned data */
>   	if (data_col_addr != 0)
>   		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, data_col_addr, -1);
> @@ -1144,16 +1146,17 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   	chip->read_buf(mtd, p, datafrag_len);
>   
>   	/* Calculate ECC */
> -	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size)
> -		chip->ecc.calculate(mtd, p, &chip->buffers->ecccalc[i]);
> +	for (i = 0; i < eccfrag_len;
> +	     i += mtd->eccctrl->bytes, p += mtd->eccctrl->size)
> +		mtd->eccctrl->calculate(mtd, p, &chip->buffers->ecccalc[i]);
>   
>   	/*
>   	 * The performance is faster if we position offsets according to
>   	 * ecc.pos. Let's make sure that there are no gaps in ECC positions.
>   	 */
>   	for (i = 0; i < eccfrag_len - 1; i++) {
> -		if (eccpos[i + start_step * chip->ecc.bytes] + 1 !=
> -			eccpos[i + start_step * chip->ecc.bytes + 1]) {
> +		if (eccpos[i + start_step * mtd->eccctrl->bytes] + 1 !=
> +			eccpos[i + start_step * mtd->eccctrl->bytes + 1]) {
>   			gaps = 1;
>   			break;
>   		}
> @@ -1166,13 +1169,14 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   		 * Send the command to read the particular ECC bytes take care
>   		 * about buswidth alignment in read_buf.
>   		 */
> -		index = start_step * chip->ecc.bytes;
> +		index = start_step * mtd->eccctrl->bytes;
>   
>   		aligned_pos = eccpos[index] & ~(busw - 1);
>   		aligned_len = eccfrag_len;
>   		if (eccpos[index] & (busw - 1))
>   			aligned_len++;
> -		if (eccpos[index + (num_steps * chip->ecc.bytes)] & (busw - 1))
> +		if (eccpos[index + (num_steps * mtd->eccctrl->bytes)] &
> +		    (busw - 1))
>   			aligned_len++;
>   
>   		chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
> @@ -1184,11 +1188,13 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   		chip->buffers->ecccode[i] = chip->oob_poi[eccpos[i + index]];
>   
>   	p = bufpoi + data_col_addr;
> -	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size) {
> +	for (i = 0; i < eccfrag_len;
> +	     i += mtd->eccctrl->bytes, p += mtd->eccctrl->size) {
>   		int stat;
>   
> -		stat = chip->ecc.correct(mtd, p,
> -			&chip->buffers->ecccode[i], &chip->buffers->ecccalc[i]);
> +		stat = mtd->eccctrl->correct(mtd, p,
> +					     &chip->buffers->ecccode[i],
> +					     &chip->buffers->ecccalc[i]);
>   		if (stat < 0) {
>   			mtd->ecc_stats.failed++;
>   		} else {
> @@ -1212,32 +1218,33 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
>   static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
>   				uint8_t *buf, int oob_required, int page)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *p = buf;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
>   	uint8_t *ecc_code = chip->buffers->ecccode;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   	unsigned int max_bitflips = 0;
>   
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> -		chip->ecc.hwctl(mtd, NAND_ECC_READ);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_READ);
>   		chip->read_buf(mtd, p, eccsize);
> -		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		mtd->eccctrl->calculate(mtd, p, &ecc_calc[i]);
>   	}
>   	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
>   
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		ecc_code[i] = chip->oob_poi[eccpos[i]];
>   
> -	eccsteps = chip->ecc.steps;
> +	eccsteps = mtd->eccctrl->steps;
>   	p = buf;
>   
>   	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
>   		int stat;
>   
> -		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
> +		stat = mtd->eccctrl->correct(mtd, p, &ecc_code[i],
> +					     &ecc_calc[i]);
>   		if (stat < 0) {
>   			mtd->ecc_stats.failed++;
>   		} else {
> @@ -1265,12 +1272,12 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
>   static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
>   	struct nand_chip *chip, uint8_t *buf, int oob_required, int page)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *p = buf;
>   	uint8_t *ecc_code = chip->buffers->ecccode;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
>   	unsigned int max_bitflips = 0;
>   
> @@ -1279,17 +1286,17 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
>   	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
>   	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
>   
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		ecc_code[i] = chip->oob_poi[eccpos[i]];
>   
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
>   		int stat;
>   
> -		chip->ecc.hwctl(mtd, NAND_ECC_READ);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_READ);
>   		chip->read_buf(mtd, p, eccsize);
> -		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		mtd->eccctrl->calculate(mtd, p, &ecc_calc[i]);
>   
> -		stat = chip->ecc.correct(mtd, p, &ecc_code[i], NULL);
> +		stat = mtd->eccctrl->correct(mtd, p, &ecc_code[i], NULL);
>   		if (stat < 0) {
>   			mtd->ecc_stats.failed++;
>   		} else {
> @@ -1314,9 +1321,9 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
>   static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
>   				   uint8_t *buf, int oob_required, int page)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *p = buf;
>   	uint8_t *oob = chip->oob_poi;
>   	unsigned int max_bitflips = 0;
> @@ -1324,17 +1331,17 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
>   		int stat;
>   
> -		chip->ecc.hwctl(mtd, NAND_ECC_READ);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_READ);
>   		chip->read_buf(mtd, p, eccsize);
>   
> -		if (chip->ecc.prepad) {
> -			chip->read_buf(mtd, oob, chip->ecc.prepad);
> -			oob += chip->ecc.prepad;
> +		if (mtd->eccctrl->prepad) {
> +			chip->read_buf(mtd, oob, mtd->eccctrl->prepad);
> +			oob += mtd->eccctrl->prepad;
>   		}
>   
> -		chip->ecc.hwctl(mtd, NAND_ECC_READSYN);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_READSYN);
>   		chip->read_buf(mtd, oob, eccbytes);
> -		stat = chip->ecc.correct(mtd, p, oob, NULL);
> +		stat = mtd->eccctrl->correct(mtd, p, oob, NULL);
>   
>   		if (stat < 0) {
>   			mtd->ecc_stats.failed++;
> @@ -1345,9 +1352,9 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
>   
>   		oob += eccbytes;
>   
> -		if (chip->ecc.postpad) {
> -			chip->read_buf(mtd, oob, chip->ecc.postpad);
> -			oob += chip->ecc.postpad;
> +		if (mtd->eccctrl->postpad) {
> +			chip->read_buf(mtd, oob, mtd->eccctrl->postpad);
> +			oob += mtd->eccctrl->postpad;
>   		}
>   	}
>   
> @@ -1361,14 +1368,16 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
>   
>   /**
>    * nand_transfer_oob - [INTERN] Transfer oob to client buffer
> - * @chip: nand chip structure
> + * @mtd: mtd structure
>    * @oob: oob destination address
>    * @ops: oob ops structure
>    * @len: size of oob to transfer
>    */
> -static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
> +static uint8_t *nand_transfer_oob(struct mtd_info *mtd, uint8_t *oob,
>   				  struct mtd_oob_ops *ops, size_t len)
>   {
> +	struct nand_chip *chip = mtd->priv;
> +
>   	switch (ops->mode) {
>   
>   	case MTD_OPS_PLACE_OOB:
> @@ -1377,7 +1386,7 @@ static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
>   		return oob + len;
>   
>   	case MTD_OPS_AUTO_OOB: {
> -		struct nand_oobfree *free = chip->ecc.layout->oobfree;
> +		struct nand_oobfree *free = mtd->eccctrl->layout->oobfree;
>   		uint32_t boffs = 0, roffs = ops->ooboffs;
>   		size_t bytes = 0;
>   
> @@ -1459,16 +1468,20 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
>   			 * the read methods return max bitflips per ecc step.
>   			 */
>   			if (unlikely(ops->mode == MTD_OPS_RAW))
> -				ret = chip->ecc.read_page_raw(mtd, chip, bufpoi,
> -							      oob_required,
> -							      page);
> +				ret = mtd->eccctrl->read_page_raw(mtd, chip,
> +								  bufpoi,
> +								  oob_required,
> +								  page);
>   			else if (!aligned && NAND_HAS_SUBPAGE_READ(chip) &&
>   				 !oob)
> -				ret = chip->ecc.read_subpage(mtd, chip,
> -							col, bytes, bufpoi);
> +				ret = mtd->eccctrl->read_subpage(mtd, chip,
> +								 col, bytes,
> +								 bufpoi);
>   			else
> -				ret = chip->ecc.read_page(mtd, chip, bufpoi,
> -							  oob_required, page);
> +				ret = mtd->eccctrl->read_page(mtd, chip,
> +							      bufpoi,
> +							      oob_required,
> +							      page);
>   			if (ret < 0) {
>   				if (!aligned)
>   					/* Invalidate page cache */
> @@ -1498,8 +1511,8 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
>   				int toread = min(oobreadlen, max_oobsize);
>   
>   				if (toread) {
> -					oob = nand_transfer_oob(chip,
> -						oob, ops, toread);
> +					oob = nand_transfer_oob(mtd, oob, ops,
> +								toread);
>   					oobreadlen -= toread;
>   				}
>   			}
> @@ -1604,13 +1617,14 @@ static int nand_read_oob_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
>   {
>   	uint8_t *buf = chip->oob_poi;
>   	int length = mtd->oobsize;
> -	int chunk = chip->ecc.bytes + chip->ecc.prepad + chip->ecc.postpad;
> -	int eccsize = chip->ecc.size;
> +	int chunk = mtd->eccctrl->bytes + mtd->eccctrl->prepad +
> +		    mtd->eccctrl->postpad;
> +	int eccsize = mtd->eccctrl->size;
>   	uint8_t *bufpoi = buf;
>   	int i, toread, sndrnd = 0, pos;
>   
> -	chip->cmdfunc(mtd, NAND_CMD_READ0, chip->ecc.size, page);
> -	for (i = 0; i < chip->ecc.steps; i++) {
> +	chip->cmdfunc(mtd, NAND_CMD_READ0, mtd->eccctrl->size, page);
> +	for (i = 0; i < mtd->eccctrl->steps; i++) {
>   		if (sndrnd) {
>   			pos = eccsize + i * (eccsize + chunk);
>   			if (mtd->writesize > 512)
> @@ -1663,9 +1677,10 @@ static int nand_write_oob_std(struct mtd_info *mtd, struct nand_chip *chip,
>   static int nand_write_oob_syndrome(struct mtd_info *mtd,
>   				   struct nand_chip *chip, int page)
>   {
> -	int chunk = chip->ecc.bytes + chip->ecc.prepad + chip->ecc.postpad;
> -	int eccsize = chip->ecc.size, length = mtd->oobsize;
> -	int i, len, pos, status = 0, sndcmd = 0, steps = chip->ecc.steps;
> +	int chunk = mtd->eccctrl->bytes + mtd->eccctrl->prepad +
> +		    mtd->eccctrl->postpad;
> +	int eccsize = mtd->eccctrl->size, length = mtd->oobsize;
> +	int i, len, pos, status = 0, sndcmd = 0, steps = mtd->eccctrl->steps;
>   	const uint8_t *bufpoi = chip->oob_poi;
>   
>   	/*
> @@ -1673,7 +1688,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
>   	 * or
>   	 * data-pad-ecc-pad-data-pad .... ecc-pad-oob
>   	 */
> -	if (!chip->ecc.prepad && !chip->ecc.postpad) {
> +	if (!mtd->eccctrl->prepad && !mtd->eccctrl->postpad) {
>   		pos = steps * (eccsize + chunk);
>   		steps = 0;
>   	} else
> @@ -1737,7 +1752,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
>   	stats = mtd->ecc_stats;
>   
>   	if (ops->mode == MTD_OPS_AUTO_OOB)
> -		len = chip->ecc.layout->oobavail;
> +		len = mtd->eccctrl->layout->oobavail;
>   	else
>   		len = mtd->oobsize;
>   
> @@ -1765,15 +1780,15 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
>   
>   	while (1) {
>   		if (ops->mode == MTD_OPS_RAW)
> -			ret = chip->ecc.read_oob_raw(mtd, chip, page);
> +			ret = mtd->eccctrl->read_oob_raw(mtd, chip, page);
>   		else
> -			ret = chip->ecc.read_oob(mtd, chip, page);
> +			ret = mtd->eccctrl->read_oob(mtd, chip, page);
>   
>   		if (ret < 0)
>   			break;
>   
>   		len = min(len, readlen);
> -		buf = nand_transfer_oob(chip, buf, ops, len);
> +		buf = nand_transfer_oob(mtd, buf, ops, len);
>   
>   		if (chip->options & NAND_NEED_READRDY) {
>   			/* Apply delay or wait for ready/busy pin */
> @@ -1888,26 +1903,26 @@ static int nand_write_page_raw_syndrome(struct mtd_info *mtd,
>   					struct nand_chip *chip,
>   					const uint8_t *buf, int oob_required)
>   {
> -	int eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> +	int eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
>   	uint8_t *oob = chip->oob_poi;
>   	int steps, size;
>   
> -	for (steps = chip->ecc.steps; steps > 0; steps--) {
> +	for (steps = mtd->eccctrl->steps; steps > 0; steps--) {
>   		chip->write_buf(mtd, buf, eccsize);
>   		buf += eccsize;
>   
> -		if (chip->ecc.prepad) {
> -			chip->write_buf(mtd, oob, chip->ecc.prepad);
> -			oob += chip->ecc.prepad;
> +		if (mtd->eccctrl->prepad) {
> +			chip->write_buf(mtd, oob, mtd->eccctrl->prepad);
> +			oob += mtd->eccctrl->prepad;
>   		}
>   
>   		chip->write_buf(mtd, oob, eccbytes);
>   		oob += eccbytes;
>   
> -		if (chip->ecc.postpad) {
> -			chip->write_buf(mtd, oob, chip->ecc.postpad);
> -			oob += chip->ecc.postpad;
> +		if (mtd->eccctrl->postpad) {
> +			chip->write_buf(mtd, oob, mtd->eccctrl->postpad);
> +			oob += mtd->eccctrl->postpad;
>   		}
>   	}
>   
> @@ -1927,21 +1942,21 @@ static int nand_write_page_raw_syndrome(struct mtd_info *mtd,
>   static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
>   				  const uint8_t *buf, int oob_required)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
>   	const uint8_t *p = buf;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   
>   	/* Software ECC calculation */
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
> -		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		mtd->eccctrl->calculate(mtd, p, &ecc_calc[i]);
>   
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		chip->oob_poi[eccpos[i]] = ecc_calc[i];
>   
> -	return chip->ecc.write_page_raw(mtd, chip, buf, 1);
> +	return mtd->eccctrl->write_page_raw(mtd, chip, buf, 1);
>   }
>   
>   /**
> @@ -1954,20 +1969,20 @@ static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
>   static int nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
>   				  const uint8_t *buf, int oob_required)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
>   	const uint8_t *p = buf;
> -	uint32_t *eccpos = chip->ecc.layout->eccpos;
> +	uint32_t *eccpos = mtd->eccctrl->layout->eccpos;
>   
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> -		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_WRITE);
>   		chip->write_buf(mtd, p, eccsize);
> -		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> +		mtd->eccctrl->calculate(mtd, p, &ecc_calc[i]);
>   	}
>   
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		chip->oob_poi[eccpos[i]] = ecc_calc[i];
>   
>   	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
> @@ -1992,10 +2007,10 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
>   {
>   	uint8_t *oob_buf  = chip->oob_poi;
>   	uint8_t *ecc_calc = chip->buffers->ecccalc;
> -	int ecc_size      = chip->ecc.size;
> -	int ecc_bytes     = chip->ecc.bytes;
> -	int ecc_steps     = chip->ecc.steps;
> -	uint32_t *eccpos  = chip->ecc.layout->eccpos;
> +	int ecc_size      = mtd->eccctrl->size;
> +	int ecc_bytes     = mtd->eccctrl->bytes;
> +	int ecc_steps     = mtd->eccctrl->steps;
> +	uint32_t *eccpos  = mtd->eccctrl->layout->eccpos;
>   	uint32_t start_step = offset / ecc_size;
>   	uint32_t end_step   = (offset + data_len - 1) / ecc_size;
>   	int oob_bytes       = mtd->oobsize / ecc_steps;
> @@ -2003,7 +2018,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
>   
>   	for (step = 0; step < ecc_steps; step++) {
>   		/* configure controller for WRITE access */
> -		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_WRITE);
>   
>   		/* write data (untouched subpages already masked by 0xFF) */
>   		chip->write_buf(mtd, buf, ecc_size);
> @@ -2012,7 +2027,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
>   		if ((step < start_step) || (step > end_step))
>   			memset(ecc_calc, 0xff, ecc_bytes);
>   		else
> -			chip->ecc.calculate(mtd, buf, ecc_calc);
> +			mtd->eccctrl->calculate(mtd, buf, ecc_calc);
>   
>   		/* mask OOB of un-touched subpages by padding 0xFF */
>   		/* if oob_required, preserve OOB metadata of written subpage */
> @@ -2027,7 +2042,7 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
>   	/* copy calculated ECC for whole page to chip->buffer->oob */
>   	/* this include masked-value(0xFF) for unwritten subpages */
>   	ecc_calc = chip->buffers->ecccalc;
> -	for (i = 0; i < chip->ecc.total; i++)
> +	for (i = 0; i < mtd->eccctrl->total; i++)
>   		chip->oob_poi[eccpos[i]] = ecc_calc[i];
>   
>   	/* write OOB buffer to NAND device */
> @@ -2051,29 +2066,29 @@ static int nand_write_page_syndrome(struct mtd_info *mtd,
>   				    struct nand_chip *chip,
>   				    const uint8_t *buf, int oob_required)
>   {
> -	int i, eccsize = chip->ecc.size;
> -	int eccbytes = chip->ecc.bytes;
> -	int eccsteps = chip->ecc.steps;
> +	int i, eccsize = mtd->eccctrl->size;
> +	int eccbytes = mtd->eccctrl->bytes;
> +	int eccsteps = mtd->eccctrl->steps;
>   	const uint8_t *p = buf;
>   	uint8_t *oob = chip->oob_poi;
>   
>   	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
>   
> -		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
> +		mtd->eccctrl->hwctl(mtd, NAND_ECC_WRITE);
>   		chip->write_buf(mtd, p, eccsize);
>   
> -		if (chip->ecc.prepad) {
> -			chip->write_buf(mtd, oob, chip->ecc.prepad);
> -			oob += chip->ecc.prepad;
> +		if (mtd->eccctrl->prepad) {
> +			chip->write_buf(mtd, oob, mtd->eccctrl->prepad);
> +			oob += mtd->eccctrl->prepad;
>   		}
>   
> -		chip->ecc.calculate(mtd, p, oob);
> +		mtd->eccctrl->calculate(mtd, p, oob);
>   		chip->write_buf(mtd, oob, eccbytes);
>   		oob += eccbytes;
>   
> -		if (chip->ecc.postpad) {
> -			chip->write_buf(mtd, oob, chip->ecc.postpad);
> -			oob += chip->ecc.postpad;
> +		if (mtd->eccctrl->postpad) {
> +			chip->write_buf(mtd, oob, mtd->eccctrl->postpad);
> +			oob += mtd->eccctrl->postpad;
>   		}
>   	}
>   
> @@ -2104,7 +2119,7 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
>   	int status, subpage;
>   
>   	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) &&
> -		chip->ecc.write_subpage)
> +		mtd->eccctrl->write_subpage)
>   		subpage = offset || (data_len < mtd->writesize);
>   	else
>   		subpage = 0;
> @@ -2112,13 +2127,15 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
>   	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, page);
>   
>   	if (unlikely(raw))
> -		status = chip->ecc.write_page_raw(mtd, chip, buf,
> -							oob_required);
> +		status = mtd->eccctrl->write_page_raw(mtd, chip, buf,
> +						      oob_required);
>   	else if (subpage)
> -		status = chip->ecc.write_subpage(mtd, chip, offset, data_len,
> -							 buf, oob_required);
> +		status = mtd->eccctrl->write_subpage(mtd, chip, offset,
> +						     data_len, buf,
> +						     oob_required);
>   	else
> -		status = chip->ecc.write_page(mtd, chip, buf, oob_required);
> +		status = mtd->eccctrl->write_page(mtd, chip, buf,
> +						  oob_required);
>   
>   	if (status < 0)
>   		return status;
> @@ -2177,7 +2194,7 @@ static uint8_t *nand_fill_oob(struct mtd_info *mtd, uint8_t *oob, size_t len,
>   		return oob + len;
>   
>   	case MTD_OPS_AUTO_OOB: {
> -		struct nand_oobfree *free = chip->ecc.layout->oobfree;
> +		struct nand_oobfree *free = mtd->eccctrl->layout->oobfree;
>   		uint32_t boffs = 0, woffs = ops->ooboffs;
>   		size_t bytes = 0;
>   
> @@ -2405,7 +2422,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
>   			 __func__, (unsigned int)to, (int)ops->ooblen);
>   
>   	if (ops->mode == MTD_OPS_AUTO_OOB)
> -		len = chip->ecc.layout->oobavail;
> +		len = mtd->eccctrl->layout->oobavail;
>   	else
>   		len = mtd->oobsize;
>   
> @@ -2459,9 +2476,11 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
>   	nand_fill_oob(mtd, ops->oobbuf, ops->ooblen, ops);
>   
>   	if (ops->mode == MTD_OPS_RAW)
> -		status = chip->ecc.write_oob_raw(mtd, chip, page & chip->pagemask);
> +		status = mtd->eccctrl->write_oob_raw(mtd, chip,
> +						     page & chip->pagemask);
>   	else
> -		status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
> +		status = mtd->eccctrl->write_oob(mtd, chip,
> +						 page & chip->pagemask);
>   
>   	chip->select_chip(mtd, -1);
>   
> @@ -3582,32 +3601,9 @@ int nand_scan_ident(struct mtd_info *mtd, int maxchips,
>   }
>   EXPORT_SYMBOL(nand_scan_ident);
>   
> -
> -/**
> - * nand_scan_tail - [NAND Interface] Scan for the NAND device
> - * @mtd: MTD device structure
> - *
> - * This is the second phase of the normal nand_scan() function. It fills out
> - * all the uninitialized function pointers with the defaults and scans for a
> - * bad block table if appropriate.
> - */
> -int nand_scan_tail(struct mtd_info *mtd)
> +int nand_ecc_ctrl_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc)
>   {
>   	int i;
> -	struct nand_chip *chip = mtd->priv;
> -	struct nand_ecc_ctrl *ecc = &chip->ecc;
> -
> -	/* New bad blocks should be marked in OOB, flash-based BBT, or both */
> -	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
> -			!(chip->bbt_options & NAND_BBT_USE_FLASH));
> -
> -	if (!(chip->options & NAND_OWN_BUFFERS))
> -		chip->buffers = kmalloc(sizeof(*chip->buffers), GFP_KERNEL);
> -	if (!chip->buffers)
> -		return -ENOMEM;
> -
> -	/* Set the internal oob buffer location, just after the page data */
> -	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
>   
>   	/*
>   	 * If no default placement scheme is given, select an appropriate one.
> @@ -3633,14 +3629,10 @@ int nand_scan_tail(struct mtd_info *mtd)
>   		}
>   	}
>   
> -	if (!chip->write_page)
> -		chip->write_page = nand_write_page;
> -
>   	/*
>   	 * Check ECC mode, default to software if 3byte/512byte hardware ECC is
>   	 * selected and we have 256 byte pagesize fallback to software ECC
>   	 */
> -
>   	switch (ecc->mode) {
>   	case NAND_ECC_HW_OOB_FIRST:
>   		/* Similar to NAND_ECC_HW, but a separate read_page handle */
> @@ -3789,7 +3781,6 @@ int nand_scan_tail(struct mtd_info *mtd)
>   	for (i = 0; ecc->layout->oobfree[i].length
>   			&& i < ARRAY_SIZE(ecc->layout->oobfree); i++)
>   		ecc->layout->oobavail += ecc->layout->oobfree[i].length;
> -	mtd->oobavail = ecc->layout->oobavail;
>   
>   	/*
>   	 * Set the number of read / write steps for one page depending on ECC
> @@ -3802,6 +3793,111 @@ int nand_scan_tail(struct mtd_info *mtd)
>   	}
>   	ecc->total = ecc->steps * ecc->bytes;
>   
> +	return 0;
> +}
> +EXPORT_SYMBOL(nand_ecc_ctrl_init);
> +
> +
> +static void nand_release_ecc_ctrl(const struct nand_ecc_ctrl *ecc)
> +{
> +	if (ecc->mode == NAND_ECC_SOFT_BCH)
> +		nand_bch_free((struct nand_bch_control *)ecc->priv);
> +
> +	kfree(ecc);
> +}
> +
> +const struct nand_ecc_ctrl *nand_get_ecc_ctrl(struct mtd_info *mtd,
> +					      nand_ecc_modes_t mode,
> +					      struct device_node *np)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct nand_ecc_ctrl *ecc;
> +	u32 ecc_step, ecc_strength;
> +	int ret;
> +
> +	if (mode != NAND_ECC_NONE && mode != NAND_ECC_SOFT &&
> +	    mode != NAND_ECC_SOFT_BCH)
> +		return ERR_PTR(-EINVAL);
> +
> +	ecc = kzalloc(sizeof(*ecc), GFP_KERNEL);
> +	if (!ecc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ecc->size = chip->ecc_step_ds;
> +	ecc->strength = chip->ecc_strength_ds;
> +	if (!of_get_nand_ecc_level(np, &ecc_strength, &ecc_step)) {
Oops: I make use of the of_get_nand_ecc_level function that I introduced 
in another
patch series: ( https://lkml.org/lkml/2014/2/5/212)

This function will be replaced by Ezequiel's work, but if you want to 
test this patch,
you just need to apply this patch first : 
https://lkml.org/lkml/2014/1/29/210
> +		ecc->size = ecc_step;
> +		ecc->strength = ecc_strength;
> +	}
> +
> +	switch (mode) {
> +	case NAND_ECC_NONE:
> +		break;
> +	case NAND_ECC_SOFT:
> +		break;
> +	case NAND_ECC_SOFT_BCH:
> +		ecc->bytes = ((ecc->strength * fls(8 * ecc->size)) + 7) / 8;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	ecc->mode = mode;
> +	ret = nand_ecc_ctrl_init(mtd, ecc);
> +	if (ret)
> +		goto err;
> +
> +	ecc->release = nand_release_ecc_ctrl;
> +
> +	return ecc;
> +
> +err:
> +	kfree(ecc);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(nand_get_ecc_ctrl);
> +
> +/**
> + * nand_scan_tail - [NAND Interface] Scan for the NAND device
> + * @mtd: MTD device structure
> + *
> + * This is the second phase of the normal nand_scan() function. It fills out
> + * all the uninitialized function pointers with the defaults and scans for a
> + * bad block table if appropriate.
> + */
> +int nand_scan_tail(struct mtd_info *mtd)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct nand_ecc_ctrl *ecc = &chip->ecc;
> +	int ret;
> +	/*struct nand_rnd_ctrl *rnd = &chip->rnd;*/
> +
> +	/* New bad blocks should be marked in OOB, flash-based BBT, or both */
> +	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
> +			!(chip->bbt_options & NAND_BBT_USE_FLASH));
> +
> +	if (!(chip->options & NAND_OWN_BUFFERS))
> +		chip->buffers = kmalloc(sizeof(*chip->buffers), GFP_KERNEL);
> +	if (!chip->buffers)
> +		return -ENOMEM;
> +
> +	/* Set the internal oob buffer location, just after the page data */
> +	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
> +
> +	if (!chip->write_page)
> +		chip->write_page = nand_write_page;
> +
> +	if (!chip->get_ecc_ctrl)
> +		chip->get_ecc_ctrl = nand_get_ecc_ctrl;
> +
> +	ret = nand_ecc_ctrl_init(mtd, ecc);
> +	if (ret)
> +		return ret;
> +
> +	mtd->eccctrl = &chip->ecc;
> +	mtd->oobavail = ecc->layout->oobavail;
> +
>   	/* Allow subpage writes up to ecc.steps. Not possible for MLC flash */
>   	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) && nand_is_slc(chip)) {
>   		switch (ecc->steps) {
> diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
> index d64f8c3..0365c1e 100644
> --- a/drivers/mtd/ofpart.c
> +++ b/drivers/mtd/ofpart.c
> @@ -16,6 +16,7 @@
>   #include <linux/module.h>
>   #include <linux/init.h>
>   #include <linux/of.h>
> +#include <linux/of_mtd.h>
>   #include <linux/mtd/mtd.h>
>   #include <linux/slab.h>
>   #include <linux/mtd/partitions.h>
> @@ -25,6 +26,25 @@ static bool node_has_compatible(struct device_node *pp)
>   	return of_get_property(pp, "compatible", NULL);
>   }
>   
> +static int parse_ofnandpart(struct mtd_info *master,
> +			    struct mtd_partition *part,
> +			    struct device_node *pp)
> +{
> +	struct nand_chip *chip = master->priv;
> +	int mode = of_get_nand_ecc_mode(pp);
> +	const struct nand_ecc_ctrl *ret;
> +
> +	if (mode < 0)
> +		return 0;
> +
> +	ret = chip->get_ecc_ctrl(master, mode, pp);
> +	if (IS_ERR(ret))
> +		return PTR_ERR(ret);
> +
> +	part->eccctrl = ret;
> +	return 0;
> +}
> +
>   static int parse_ofpart_partitions(struct mtd_info *master,
>   				   struct mtd_partition **pparts,
>   				   struct mtd_part_parser_data *data)
> @@ -63,6 +83,7 @@ static int parse_ofpart_partitions(struct mtd_info *master,
>   		const __be32 *reg;
>   		int len;
>   		int a_cells, s_cells;
> +		int ret;
>   
>   		if (node_has_compatible(pp))
>   			continue;
> @@ -89,6 +110,20 @@ static int parse_ofpart_partitions(struct mtd_info *master,
>   		if (of_get_property(pp, "lock", &len))
>   			(*pparts)[i].mask_flags |= MTD_POWERUP_LOCK;
>   
> +		switch (master->type) {
> +		case MTD_NANDFLASH:
> +		case MTD_MLCNANDFLASH:
> +			ret = parse_ofnandpart(master, &(*pparts)[i], pp);
> +			if (ret) {
> +				nr_parts--;
> +				continue;
> +			}
> +
> +			break;
> +		default:
> +			break;
> +		}
> +
>   		i++;
>   	}
>   
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 8cc0e2f..7b08d50 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -109,6 +109,8 @@ struct nand_ecclayout {
>   	struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES_LARGE];
>   };
>   
> +struct nand_ecc_ctrl;
> +
>   struct module;	/* only needed for owner field in mtd_info */
>   
>   struct mtd_info {
> @@ -169,6 +171,7 @@ struct mtd_info {
>   
>   	/* ECC layout structure pointer - read only! */
>   	struct nand_ecclayout *ecclayout;
> +	const struct nand_ecc_ctrl *eccctrl;
>   
>   	/* the ecc step size. */
>   	unsigned int ecc_step_size;
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index c70e0a3..d3f0cfd 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -407,8 +407,11 @@ struct nand_ecc_ctrl {
>   	int (*read_oob)(struct mtd_info *mtd, struct nand_chip *chip, int page);
>   	int (*write_oob)(struct mtd_info *mtd, struct nand_chip *chip,
>   			int page);
> +	void (*release)(const struct nand_ecc_ctrl *ctrl);
>   };
>   
> +
> +
>   /**
>    * struct nand_buffers - buffer structure for read/write
>    * @ecccalc:	buffer for calculated ECC
> @@ -544,6 +547,9 @@ struct nand_chip {
>   			int feature_addr, uint8_t *subfeature_para);
>   	int (*onfi_get_features)(struct mtd_info *mtd, struct nand_chip *chip,
>   			int feature_addr, uint8_t *subfeature_para);
> +	const struct nand_ecc_ctrl *(*get_ecc_ctrl)(struct mtd_info *mtd,
> +						    nand_ecc_modes_t mode,
> +						    struct device_node *np);
>   
>   	int chip_delay;
>   	unsigned int options;
> @@ -699,6 +705,12 @@ extern int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
>   extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
>   			size_t *retlen, uint8_t *buf);
>   
> +int nand_ecc_ctrl_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc);
> +
> +const struct nand_ecc_ctrl *nand_get_ecc_ctrl(struct mtd_info *mtd,
> +					      nand_ecc_modes_t mode,
> +					      struct device_node *np);
> +
>   /**
>    * struct platform_nand_chip - chip level device structure
>    * @nr_chips:		max. number of chips to scan for
> diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
> index 1f8d24b..9e39fb1 100644
> --- a/include/linux/mtd/partitions.h
> +++ b/include/linux/mtd/partitions.h
> @@ -42,6 +42,7 @@ struct mtd_partition {
>   	uint64_t offset;		/* offset within the master MTD space */
>   	uint32_t mask_flags;		/* master MTD flags to mask out for this partition */
>   	struct nand_ecclayout *ecclayout;	/* out of band layout for this partition (NAND only) */
> +	const struct nand_ecc_ctrl *eccctrl;	/* NAND ECC config for this partition (NAND only) */
>   };
>   
>   #define MTDPART_OFS_RETAIN	(-3)

