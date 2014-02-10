Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBJM2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:28:25 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:41239 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJM2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:28:20 -0500
Message-ID: <52F8C5E0.8040804@gmail.com>
Date: Mon, 10 Feb 2014 13:28:16 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mtd: add per NAND partition ECC config
References: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com> <20980858CB6D3A4BAE95CA194937D5E73EA6F1F0@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EA6F1F0@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 12:55, Gupta, Pekon wrote:
> Hi Boris,
>
>> From: Boris BREZILLON
>>
>> This patch aims to add per partition ECC config for NAND devices.
>> It defines a new field in the mtd struct to store the mtd ECC config and
>> thus each mtd partition device can store its config instead of using the
>> default NAND chip config.
>>
>> This feature is needed to support the sunxi boot0 paritition case:
>> Allwinner boot code (BROM) requires a specific HW ECC for its boot code
>> that may not fit the HW NAND requirements for the entire NAND chip.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>> Hello,
>>
>> This patch is just a draft that implement per partition ECC config.
>> It's currently not properly splitted (it should be separated in several
>> patches) and not documented either.
>>
>> There's at least one point that bother me in the current implementation:
>> I introduced DT notions in the nand core code by the mean of the get_ecc_ctrl
>> callback, and so far this was kept out of mtd/nand core code (I guess it was
>> on purpose).
>>
>> Please let me know if you see other drawbacks.
>>
>> If you think per partition ECC should not be implemented, could you help me
>> find a way to handle sunxi specific case decribed above ?
>>
> There was a discussion on having per partition based ECC earlier [1].
> Though I was not in favor of supporting it earlier, but your proposal looks good.
> However, I still feel there are more caveats here, to explore..
>
> [...]
>
>> @@ -364,7 +367,13 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>> 	slave->mtd.writesize = master->writesize;
>> 	slave->mtd.writebufsize = master->writebufsize;
>> 	slave->mtd.oobsize = master->oobsize;
>> -	slave->mtd.oobavail = master->oobavail;
>> +	if (part->eccctrl) {
>> +		slave->mtd.eccctrl = part->eccctrl;
>> +		slave->mtd.oobavail = part->eccctrl->layout->oobavail;
>> +	} else {
>> +		slave->mtd.eccctrl = master->eccctrl;
>> +		slave->mtd.oobavail = master->oobavail;
>> +	}
>> 	slave->mtd.subpage_sft = master->subpage_sft;
>>
>> 	slave->mtd.name = name;
>> @@ -515,9 +524,15 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>> 			part->name);
>> 	}
>>
>> -	slave->mtd.ecclayout = master->ecclayout;
>> -	slave->mtd.ecc_step_size = master->ecc_step_size;
>> -	slave->mtd.ecc_strength = master->ecc_strength;
>> +	if (part->eccctrl) {
>> +		slave->mtd.ecclayout = part->eccctrl->layout;
>> +		slave->mtd.ecc_step_size = part->eccctrl->size;
>> +		slave->mtd.ecc_strength = part->eccctrl->strength;
> You have to replicate 'struct nand_ecc_ctrl' from 'nand_chip' to 'mtd_info'
> because each ECC algorithm may have its own callback for hwctl(), calculate(), and correct().
> How do you plan to populate those ?  In driver probe ?

That's already handled (see parse_ofnandpart function):

For each new partition if a valid ecc-mode is detected the function will 
call the get_ecc_ctrl
callback which is then supposed to allocate and initialize a new 
nand_ecc_ctrl struct.

On nand probe (more precisely in the nand_scan_tail function), I simply 
assign the mtd eccctrl
field to the nand chip ecc field, so that even when there's no partition 
the mtd device have a
reference to a valid nand_ecc_ctrl struct.

Is that what you were talking about ?

>
>> +	} else {
>> +		slave->mtd.ecclayout = master->ecclayout;
>> +		slave->mtd.ecc_step_size = master->ecc_step_size;
>> +		slave->mtd.ecc_strength = master->ecc_strength;
>> +	}
>> 	slave->mtd.bitflip_threshold = master->bitflip_threshold;
>>
>> 	if (master->_block_isbad) {
> [...]
>
>> +const struct nand_ecc_ctrl *nand_get_ecc_ctrl(struct mtd_info *mtd,
>> +					      nand_ecc_modes_t mode,
>> +					      struct device_node *np)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nand_ecc_ctrl *ecc;
>> +	u32 ecc_step, ecc_strength;
>> +	int ret;
>> +
>> +	if (mode != NAND_ECC_NONE && mode != NAND_ECC_SOFT &&
>> +	    mode != NAND_ECC_SOFT_BCH)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	ecc = kzalloc(sizeof(*ecc), GFP_KERNEL);
>> +	if (!ecc)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ecc->size = chip->ecc_step_ds;
>> +	ecc->strength = chip->ecc_strength_ds;
>> +	if (!of_get_nand_ecc_level(np, &ecc_strength, &ecc_step)) {
>> +		ecc->size = ecc_step;
>> +		ecc->strength = ecc_strength;
>> +	}
>> +
> Here we may need to ecc_strength for each partition.
> Example: for OMAP3 ROM supports only HAM1 (1-bit hamming),
>        but kernel may support up-to BCH8 (8-bit BCH) ECC schemes.
> But, anyways that's specific to OMAP platforms..

If you need HW specific handling, you just have to implement a new 
get_ecc_ctrl
function and assign it to the get_ecc_ctrl field before calling 
nand_scan_tail.
That's what I'm doing in the sunxi driver.

This nand_get_ecc_ctrl function is only used when no specific 
get_ecc_ctrl is provided.


>> +	switch (mode) {
>> +	case NAND_ECC_NONE:
>> +		break;
>> +	case NAND_ECC_SOFT:
>> +		break;
>> +	case NAND_ECC_SOFT_BCH:
>> +		ecc->bytes = ((ecc->strength * fls(8 * ecc->size)) + 7) / 8;
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	ecc->mode = mode;
>> +	ret = nand_ecc_ctrl_init(mtd, ecc);
>> +	if (ret)
>> +		goto err;
>> +
>> +	ecc->release = nand_release_ecc_ctrl;
>> +
>> +	return ecc;
>> +
>> +err:
>> +	kfree(ecc);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL(nand_get_ecc_ctrl);
>> +
> I'll be happy to extend and test this, if you plan a complete version.

This version is fully functionnal (I tested it with the sunxi driver), 
but it depends on a this
patch: https://lkml.org/lkml/2014/1/29/210.

I'll be happy to get it tested on other platforms.

Best Regards,

Boris

>
> [1] http://comments.gmane.org/gmane.linux.ports.arm.omap/108083
> (you can skip initial discussion about OMAP3, and jump to Thomas Petazzoni | 2 Dec 17:19 2013)
>
>
> with regards, pekon

