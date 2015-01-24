Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbbAXOJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:09:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55911 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbbAXOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:07 -0500
Message-ID: <54C3A5D2.4010402@free-electrons.com>
Date: Sat, 24 Jan 2015 11:01:54 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org,
        Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-kernel@vger.kernel.org,
        Sudhakar Gundubogula <sudhakar@marvell.com>,
        Seif Mazareeb <seif@marvell.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mtd: nand: pxa3xx: Fix PIO FIFO draining
References: <1422027703-3763-1-git-send-email-maxime.ripard@free-electrons.com> <1422027703-3763-2-git-send-email-maxime.ripard@free-electrons.com> <54C26FCA.5050600@free-electrons.com>
In-Reply-To: <54C26FCA.5050600@free-electrons.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:59 PM, Gregory CLEMENT wrote:
> On 23/01/2015 16:41, Maxime Ripard wrote:
>> The NDDB register holds the data that are needed by the read and write
>> commands.
>>
>> However, during a read PIO access, the datasheet specifies that after each 32
>> bits read in that register, when BCH is enabled, we have to make sure that the
>> RDDREQ bit is set in the NDSR register.
>>
>> This fixes an issue that was seen on the Armada 385, and presumably other mvebu
>> SoCs, when a read on a newly erased page would end up in the driver reporting a
>> timeout from the NAND.
>>
>> Cc: <stable@vger.kernel.org>
> 
> It would help the stable maintainer if you could indicate since which commit or
> kernel release this fix should be applied.
> 

This is a fix for the BCH support, namely commit 43bcfd2bb24a
"mtd: nand: pxa3xx: Add driver-specific ECC BCH support". The commit was merged
in v3.14.

However, this patch won't apply directly there. It will apply on commit
fa543bef72d6 "mtd: nand: pxa3xx: Add a read/write buffers markers"; which
was also merged in v3.14.

Therefore, I guess it's OK to say

Cc: <stable@vger.kernel.org> # v3.14.x

>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  drivers/mtd/nand/pxa3xx_nand.c | 36 ++++++++++++++++++++++++++++++------
>>  1 file changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
>> index 96b0b1d27df1..320c2ab14d4e 100644
>> --- a/drivers/mtd/nand/pxa3xx_nand.c
>> +++ b/drivers/mtd/nand/pxa3xx_nand.c
>> @@ -480,6 +480,30 @@ static void disable_int(struct pxa3xx_nand_info *info, uint32_t int_mask)
>>  	nand_writel(info, NDCR, ndcr | int_mask);
>>  }
>>  
>> +static void drain_fifo(struct pxa3xx_nand_info *info,
>> +		       void *data,
>> +		       int len)

^^
You don't need to split that line, it seems to fit 80 characters as is.

>> +{
>> +	u32 *dst = (u32 *)data;
>> +
>> +	if (info->ecc_bch) {
>> +		while (len--) {
>> +			*dst++ = nand_readl(info, NDDB);
>> +
>> +			/*
>> +			 * According to the datasheet, when reading
>> +			 * from NDDB with BCH enabled, after each 32
>> +			 * bits reads, we have to make sure that the
>> +			 * NDSR.RDDREQ bit is set
>> +			 */
>> +			while (!(nand_readl(info, NDSR) & NDSR_RDDREQ))
>> +				cpu_relax();
> 
> Are we sure that we won't be blocked here?
> If not, what about adding a timeout?
> 

Definitely. I think we shouldn't have an infinite loop, no matter what the hw specs say.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
