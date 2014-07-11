Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaGKLwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:52:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53611 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaGKLwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:52:05 -0400
Message-ID: <53BFCFC3.1090402@ti.com>
Date: Fri, 11 Jul 2014 14:51:31 +0300
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
References: <1404909450-11970-1-git-send-email-rogerq@ti.com> <1404909450-11970-3-git-send-email-rogerq@ti.com> <20980858CB6D3A4BAE95CA194937D5E73EB01DF7@DBDE04.ent.ti.com> <53BFBDFA.8040901@ti.com> <20980858CB6D3A4BAE95CA194937D5E73EB01F7E@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EB01F7E@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 02:27 PM, Gupta, Pekon wrote:
>> From: Quadros, Roger
>>> On 07/11/2014 10:43 AM, Gupta, Pekon wrote:
>>>> From: Quadros, Roger
> [...]
> 
>>>> @@ -1176,6 +1172,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info
>> *mtd,
>>>> {
>>>> 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
>>>> 						   mtd);
>>>> +	struct nand_chip *chip = mtd->priv;
>>>> 	int eccbytes	= info->nand.ecc.bytes;
>>>> 	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
>>>> 	u8 *ecc_code;
>>>> @@ -1183,7 +1180,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info
>> *mtd,
>>>> 	u32 val;
>>>> 	int i, j;
>>>>
>>>> -	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
>>>> +	nsectors = chip->ecc.steps;
>>>
>>> Sorry NAK.. I'm sure you are breaking something here :-)
>>>
>>> NAND driver supports multiple ECC schemes like;
>>> OMAP_ECC_CODE_HAM1_HW (support for legacy reasons)
>>> OMAP_ECC_CODE_BCH4_HW_DETECTION_SW (needed for OMAP3 and AM35xx)
>>> OMAP_ECC_CODE_BCH4_HW
>>> OMAP_ECC_CODE_BCH8_HW
>>> OMAP_ECC_CODE_BCH8_HW_DETECTION_SW  (needed for OMAP3 and AM35xx)
>>> OMAP_ECC_CODE_BCH16_HW
>>>
>>> IIRC ..
>>> - software based ecc-schemes OMAP_ECC_CODE_BCHx_HW_DETECTION_SW
>>>   Reads/Write in per-sector granularity. (here nsector != chip->ecc.steps)
>>
>> OK. I still don't have a full understanding about the ECC schemes so to ensure we
>> don't break anything I can just leave nsectors as it is and probably just store a
>> copy of it in omap_nand_info to avoid reading it back from gpmc_ecc_config.
>>
>> I still have a few questions to clarify my understanding.
>>
>> The only difference between OMAP_ECC_CODE_BCHx_HW_DETECTION_SW and
>> OMAP_ECC_CODE_BCHx_HW is that in the former the _correction_ is done by software
>> and in the latter the _correction_ is done by hardware (i.e. ELM module).
>> In both cases the _detection_ is done by the same hardware IP via ecc.calculate(),
>> i.e. omap_calculate_ecc_bch().
>>
>> so why should nsector be different for both in the _detection_ stage?
>>
> Again IIRC, That is because of ELM driver.
> ELM hardware engine has 8 channels with each of them having 512Bytes capacity.
> Now, there can be two approaches:
> (1) SECTOR_MODE:  Process only one sector of 512 bytes at a time, and iterate
>       chip->ecc.steps times.
> (2) PAGE_MODE: Process complete page at a time, enabling multiple channels
>     simultaneously. This improves some throughput, especially for large-page
>    NAND devices and MLC NAND where bit-flips are common.
> 
> As ELM uses (2)nd approach, so the GPMC also has to calculate and store
> ECC for complete page at a time. That is why trace NAND driver you will find
> -  OMAP_ECC_CODE_BCHx_HW_DETECTION_SW use generic implementation
>          chip->ecc.read_page= nand_read_page_hwecc() defined in nand_base.c
> whereas,
> -  OMAP_ECC_CODE_BCHx_HW use custom implementation
>          chip->ecc.read_page= omap_read_page_bch() defined in omap.c
> 
> 
>> An I right that ecc_steps is nothing but number of sub-blocks ECC calculation and correction
>> needs to be done for larger pages. This is a function of ECC hw capability (chip->ecc.size)
>> and NAND flash capability (mtd->writesize). i.e. ecc_steps = mtd->writesize / chip->ecc.size
>>
>> We hardcode chip->ecc.size to 512 for all the ECC schemes in omap_nand_probe() so
>> calculate and correct will always be called for 512 byte sized blocks. So when does
>> the usecase for nsector > 1 come in?
>>
> Ok.. I'll try to explain above details again in probably simplified version
> - OMAP_ECC_CODE_BCHx_HW_DETECTION_SW
>   uses lib/bch.c (via nand_bch.c) to correct ECC. And is generic implementation
>   so here each sector  (data chunk of ecc_size) is corrected independently.
>   So nsector = 1;
>   
> - OMAP_ECC_CODE_BCHx_HW
>   Uses ELM to correct ECC. But the way ELM driver is written today. It corrects
>   the whole page in single go. Not individual sectors (ecc_size chunks).

Then shouldn't chip->ecc.size be equal page size and chip->ecc.steps be equal to 1 for upto 4KB pages?
For larger pages it can be a multiple of 4KB page size. i.e. 2 for 8KB, 4 for 16KB and so on.

So nsectors is not necessarily equal to ecc.steps but equal to how many 512 byte blocks are there in
one step. i.e. [min(4096, page_size) / 512]. And it must be local to omap NAND driver.


>   So, its doable to make it same like OMAP_ECC_CODE_BCHx_HW_DETECTION_SW
>   But then you _may_ have performance penalty for new technology NAND and MLC
>   NAND on which bit-flips are very common.
>   So to keep ELM driver as it is (performance tweaked), we use different
>   configurations in GPMC to read complete page in single go. This is where
>    nsector = chip->ecc.steps;
> 
> Hope that clarifies the implementation..
> 
> Good to document this detail somewhere for OMAP drivers both (u-boot and kernel).
> Any thoughts ?

Sure. we have the processors wiki. That should be a good place.

cheers,
-roger
