Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaIVInY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:43:24 -0400
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:20662
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbaIVInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:43:23 -0400
Message-ID: <541FDD05.1020704@freescale.com>
Date: Mon, 22 Sep 2014 11:25:41 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>, Michael Neuling <mikey@neuling.org>
CC: <greg@kroah.com>, <arnd@arndb.de>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <cbe-oss-dev@lists.ozlabs.org>,
        <imunsie@au.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <jk@ozlabs.org>, <anton@samba.org>,
        "Laurentiu Tudor" <Laurentiu.Tudor@freescale.com>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>	 <1411028820-29933-4-git-send-email-mikey@neuling.org> <1411157769.13320.74.camel@snotra.buserror.net>
In-Reply-To: <1411157769.13320.74.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: AM3PR01CA046.eurprd01.prod.exchangelabs.com (10.141.191.36)
 To DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB320;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(479174003)(377454003)(377424004)(24454002)(54356999)(107046002)(90102001)(19580395003)(19580405001)(36756003)(76482002)(83072002)(65816999)(87266999)(83322001)(80316001)(42186005)(85852003)(15202345003)(79102003)(80022003)(46102003)(81342003)(95666004)(74662003)(77982003)(4396001)(106356001)(97736003)(105586002)(20776003)(47776003)(85306004)(64706001)(33656002)(99396002)(31966008)(83506001)(74502003)(50986999)(87976001)(81542003)(77096002)(76176999)(21056001)(50466002)(92566001)(102836001)(59896002)(101416001)(65956001)(23676002)(66066001)(65806001)(15975445006)(120916001)(92726001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB320;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 11:16 PM, Scott Wood wrote:
> On Thu, 2014-09-18 at 18:26 +1000, Michael Neuling wrote:
>> From: Ian Munsie <imunsie@au1.ibm.com>
>>
>> Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
>> to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
>> lot of IRQs which can be a scarce resource.
>>
>> For cxl we can require multiple IRQs for every contexts that is attached to the
>> accelerator.  For AFU directed accelerators, there may be 1000s of contexts
>> attached, hence we can easily run out of IRQs, especially if we are needlessly
>> wasting them.
>>
>> This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
>> of IRQs, hence avoiding this wastage.
>>
>> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
>> Signed-off-by: Michael Neuling <mikey@neuling.org>
>> ---
>>  arch/powerpc/sysdev/msi_bitmap.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> This conflicts with (and partially duplicates)
> http://patchwork.ozlabs.org/patch/381892/
> which I have in my tree.  How should we handle it?
> 
> Laurentiu, from looking at the overlap between patches I see a problem
> with your existing patch, regarding the out-of-irqs path and
> msi_bitmap_free_hwirqs(), so one way or another that needs to get fixed
> soon.
> 

Agree. My patch lacks error checking so Michael's patch is better.

---
Best Regards, Laurentiu

> 
>> diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
>> index 2ff6302..e001559 100644
>> --- a/arch/powerpc/sysdev/msi_bitmap.c
>> +++ b/arch/powerpc/sysdev/msi_bitmap.c
>> @@ -24,28 +24,36 @@ int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
>>  	 * This is fast, but stricter than we need. We might want to add
>>  	 * a fallback routine which does a linear search with no alignment.
>>  	 */
>> -	offset = bitmap_find_free_region(bmp->bitmap, bmp->irq_count, order);
>> +	offset = bitmap_find_next_zero_area(bmp->bitmap, bmp->irq_count, 0,
>> +					    num, (1 << order) - 1);
>> +	if (offset > bmp->irq_count)
>> +		goto err;
>> +	bitmap_set(bmp->bitmap, offset, num);
>>  	spin_unlock_irqrestore(&bmp->lock, flags);
>>  
>>  	pr_debug("msi_bitmap: allocated 0x%x (2^%d) at offset 0x%x\n",
>>  		 num, order, offset);
>>  
>>  	return offset;
>> +err:
>> +	spin_unlock_irqrestore(&bmp->lock, flags);
>> +	return -ENOMEM;
>>  }
>> +EXPORT_SYMBOL(msi_bitmap_alloc_hwirqs);
>>  
>>  void msi_bitmap_free_hwirqs(struct msi_bitmap *bmp, unsigned int offset,
>>  			    unsigned int num)
>>  {
>>  	unsigned long flags;
>> -	int order = get_count_order(num);
>>  
>> -	pr_debug("msi_bitmap: freeing 0x%x (2^%d) at offset 0x%x\n",
>> -		 num, order, offset);
>> +	pr_debug("msi_bitmap: freeing 0x%x at offset 0x%x\n",
>> +		 num, offset);
>>  
>>  	spin_lock_irqsave(&bmp->lock, flags);
>> -	bitmap_release_region(bmp->bitmap, offset, order);
>> +	bitmap_clear(bmp->bitmap, offset, num);
>>  	spin_unlock_irqrestore(&bmp->lock, flags);
>>  }
>> +EXPORT_SYMBOL(msi_bitmap_free_hwirqs);
>>  
>>  void msi_bitmap_reserve_hwirq(struct msi_bitmap *bmp, unsigned int hwirq)
>>  {
> 
> 

