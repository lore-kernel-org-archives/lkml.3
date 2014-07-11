Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaGKKgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:36:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37681 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaGKKgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:36:14 -0400
Message-ID: <53BFBDFA.8040901@ti.com>
Date: Fri, 11 Jul 2014 13:35:38 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "javier@dowhile0.org" <javier@dowhile0.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/10] mtd: nand: omap: Always use chip->ecc.steps
 for BCH sector count
References: <1404909450-11970-1-git-send-email-rogerq@ti.com> <1404909450-11970-3-git-send-email-rogerq@ti.com> <20980858CB6D3A4BAE95CA194937D5E73EB01DF7@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EB01DF7@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 10:43 AM, Gupta, Pekon wrote:
>> From: Quadros, Roger
>>
>> Instead of hardcoding use the pre-calculated chip->ecc.steps for
>> configuring number of sectors to process with the BCH algorithm.
>>
>> This also avoids unnecessary access to the ECC_CONFIG register in
>> omap_calculate_ecc_bch().
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>> drivers/mtd/nand/omap2.c | 9 +++------
>> 1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>> index 5b8739c..6f3d7cd 100644
>> --- a/drivers/mtd/nand/omap2.c
>> +++ b/drivers/mtd/nand/omap2.c
>> @@ -1066,10 +1066,10 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>> *mtd, int mode)
>> 	unsigned int ecc_size1, ecc_size0;
>>
>> 	/* GPMC configurations for calculating ECC */
>> +	nsectors = chip->ecc.steps;
>> 	switch (ecc_opt) {
>> 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
>> 		bch_type = 0;
>> -		nsectors = 1;
>> 		if (mode == NAND_ECC_READ) {
>> 			wr_mode	  = BCH_WRAPMODE_6;
>> 			ecc_size0 = BCH_ECC_SIZE0;
>> @@ -1082,7 +1082,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>> *mtd, int mode)
>> 		break;
>> 	case OMAP_ECC_BCH4_CODE_HW:
>> 		bch_type = 0;
>> -		nsectors = chip->ecc.steps;
>> 		if (mode == NAND_ECC_READ) {
>> 			wr_mode	  = BCH_WRAPMODE_1;
>> 			ecc_size0 = BCH4R_ECC_SIZE0;
>> @@ -1095,7 +1094,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>> *mtd, int mode)
>> 		break;
>> 	case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
>> 		bch_type = 1;
>> -		nsectors = 1;
>> 		if (mode == NAND_ECC_READ) {
>> 			wr_mode	  = BCH_WRAPMODE_6;
>> 			ecc_size0 = BCH_ECC_SIZE0;
>> @@ -1108,7 +1106,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>> *mtd, int mode)
>> 		break;
>> 	case OMAP_ECC_BCH8_CODE_HW:
>> 		bch_type = 1;
>> -		nsectors = chip->ecc.steps;
>> 		if (mode == NAND_ECC_READ) {
>> 			wr_mode	  = BCH_WRAPMODE_1;
>> 			ecc_size0 = BCH8R_ECC_SIZE0;
>> @@ -1121,7 +1118,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>> *mtd, int mode)
>> 		break;
>> 	case OMAP_ECC_BCH16_CODE_HW:
>> 		bch_type = 0x2;
>> -		nsectors = chip->ecc.steps;
>> 		if (mode == NAND_ECC_READ) {
>> 			wr_mode	  = 0x01;
>> 			ecc_size0 = 52; /* ECC bits in nibbles per sector */
>> @@ -1176,6 +1172,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
>> {
>> 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
>> 						   mtd);
>> +	struct nand_chip *chip = mtd->priv;
>> 	int eccbytes	= info->nand.ecc.bytes;
>> 	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
>> 	u8 *ecc_code;
>> @@ -1183,7 +1180,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
>> 	u32 val;
>> 	int i, j;
>>
>> -	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
>> +	nsectors = chip->ecc.steps;
> 
> Sorry NAK.. I'm sure you are breaking something here :-)
> 
> NAND driver supports multiple ECC schemes like;
> OMAP_ECC_CODE_HAM1_HW (support for legacy reasons)
> OMAP_ECC_CODE_BCH4_HW_DETECTION_SW (needed for OMAP3 and AM35xx)
> OMAP_ECC_CODE_BCH4_HW
> OMAP_ECC_CODE_BCH8_HW
> OMAP_ECC_CODE_BCH8_HW_DETECTION_SW  (needed for OMAP3 and AM35xx)
> OMAP_ECC_CODE_BCH16_HW
> 
> IIRC ..
> - software based ecc-schemes OMAP_ECC_CODE_BCHx_HW_DETECTION_SW
>   Reads/Write in per-sector granularity. (here nsector != chip->ecc.steps)

OK. I still don't have a full understanding about the ECC schemes so to ensure we
don't break anything I can just leave nsectors as it is and probably just store a
copy of it in omap_nand_info to avoid reading it back from gpmc_ecc_config.

I still have a few questions to clarify my understanding.

The only difference between OMAP_ECC_CODE_BCHx_HW_DETECTION_SW and
OMAP_ECC_CODE_BCHx_HW is that in the former the _correction_ is done by software
and in the latter the _correction_ is done by hardware (i.e. ELM module).
In both cases the _detection_ is done by the same hardware IP via ecc.calculate(),
i.e. omap_calculate_ecc_bch().

so why should nsector be different for both in the _detection_ stage?

An I right that ecc_steps is nothing but number of sub-blocks ECC calculation and correction
needs to be done for larger pages. This is a function of ECC hw capability (chip->ecc.size)
and NAND flash capability (mtd->writesize). i.e. ecc_steps = mtd->writesize / chip->ecc.size

We hardcode chip->ecc.size to 512 for all the ECC schemes in omap_nand_probe() so
calculate and correct will always be called for 512 byte sized blocks. So when does
the usecase for nsector > 1 come in?

cheers,
-roger
