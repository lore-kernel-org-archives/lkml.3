Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaENXdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:33:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaENXdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:33:43 -0400
Message-ID: <5373FD38.3060805@ti.com>
Date: Thu, 15 May 2014 02:33:12 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: <grygorii.strashko@ti.com>, Murali Karicheri <m-karicheri2@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nand: davinci: add support for 4K page size nand devices
References: <1399588265-7130-1-git-send-email-ivan.khoronzhuk@ti.com> <5370E6F3.3050705@ti.com>
In-Reply-To: <5370E6F3.3050705@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/12/2014 06:21 PM, Santosh Shilimkar wrote:
> On Thursday 08 May 2014 06:31 PM, Ivan Khoronzhuk wrote:
>> From: Sandeep Paulraj <s-paulraj@ti.com>
>>
>> It is needed for k2l keystone2 EVM which uses NAND flash with 4K page
>> size, hence add support for 4K page size nand devices.
>>
>> Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>
>> Based on l2-mtd/master
>>
>>   drivers/mtd/nand/davinci_nand.c | 41 ++++++++++++++++++++++++++++++-----------
>>   1 file changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> index b922c8e..24a5769 100644
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -520,6 +520,31 @@ static struct nand_ecclayout hwecc4_2048 = {
>>   	},
>>   };
>>   
>> +/* An ECC layout for using 4-bit ECC with large-page (4096bytes) flash,
>> + * storing ten ECC bytes plus the manufacturer's bad block marker byte,
>> + * and not overlapping the default BBT markers.
>> + */
> Comment style ....
> /*
>   *
>   */

yes

>> +static struct nand_ecclayout hwecc4_4096 __initconst = {
>> +          .eccbytes = 80,
>> +          .eccpos = {
>> +                  /* at the end of spare sector */
>> +                  48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
>> +                  58, 59, 60, 61, 62, 63, 64, 65, 66, 67,
>> +                  68, 69, 70, 71, 72, 73, 74, 75, 76, 77,
>> +                  78, 79, 80, 81, 82, 83, 84, 85, 86, 87,
>> +                  88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
>> +                  98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
>> +                  108, 109, 110, 111, 112, 113, 114, 115, 116, 117,
>> +                  118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
>> +                  },
>> +          .oobfree = {
>> +                  /* 2 bytes at offset 0 hold manufacturer badblock markers */
>> +                  {.offset = 2, .length = 46, },
>> +                  /* 5 bytes at offset 8 hold BBT markers */
>> +                  /* 8 bytes at offset 16 hold JFFS2 clean markers */
>> +         },
>> +};
>> +
>>   #if defined(CONFIG_OF)
>>   static const struct of_device_id davinci_nand_of_match[] = {
>>   	{.compatible = "ti,davinci-nand", },
>> @@ -796,18 +821,12 @@ static int nand_davinci_probe(struct platform_device *pdev)
>>   			info->chip.ecc.mode = NAND_ECC_HW_OOB_FIRST;
>>   			goto syndrome_done;
>>   		}
>> +		if (chunks == 8) {
> May be use some meaning macros instead of magic value '8'

It just continues style used in the code:

if (chunks == 1) {
...
if (chunks == 4) {
...
if (chunks == 8) {
...

>
>> +			info->ecclayout = hwecc4_4096;
>> +			info->chip.ecc.mode = NAND_ECC_HW_OOB_FIRST;
>> +			goto syndrome_done;
>> +		}
>>   
>> -		/* 4KiB page chips are not yet supported. The eccpos from
>> -		 * nand_ecclayout cannot hold 80 bytes and change to eccpos[]
>> -		 * breaks userspace ioctl interface with mtd-utils. Once we
>> -		 * resolve this issue, NAND_ECC_HW_OOB_FIRST mode can be used
>> -		 * for the 4KiB page chips.
>> -		 *
>> -		 * TODO: Note that nand_ecclayout has now been expanded and can
>> -		 *  hold plenty of OOB entries.
>> -		 */
>> -		dev_warn(&pdev->dev, "no 4-bit ECC support yet "
>> -				"for 4KiB-page NAND\n");
>>   		ret = -EIO;
>>   		goto err;
>>   
>>

-- 
Regards,
Ivan Khoronzhuk

