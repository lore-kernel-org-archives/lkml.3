Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaEHR2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:28:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753348AbaEHR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:28:06 -0400
Message-ID: <536BBEA4.6080908@free-electrons.com>
Date: Thu, 08 May 2014 19:28:04 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johan Hovold <johan@hovold.com>
CC: Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com> <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com> <20140508154912.GA6776@localhost>
In-Reply-To: <20140508154912.GA6776@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/05/2014 17:49, Johan Hovold wrote:
> On Wed, May 07, 2014 at 06:20:49PM +0200, Boris BREZILLON wrote:
>> The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
>> mask all interrupts no matter what IMR claims about already masked irqs.
> Crap, I totally forgot about this. Doug reported the problem off-list
> back in December, but it got lost somehow. Sorry.

No problem.

BTW, I started to work on a more generic solution to handle these muxed
irqs issues (see https://lkml.org/lkml/2014/3/28/353).
Could you take a look at it (I'm still not happy with the proposed DT
bindings, but this can be discussed)?

>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
>> ---
>> Hello Bryan,
>>
>> Yet another patch for you ;-).
>>
>> As usual, could you tell me if it fixes your bug.
>>
>> BTW, thanks for your tests.
>>
>> Best Regards,
>>
>> Boris
>>
>>  arch/arm/mach-at91/sysirq_mask.c | 7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
>> index 2ba694f..eb3d2a5 100644
>> --- a/arch/arm/mach-at91/sysirq_mask.c
>> +++ b/arch/arm/mach-at91/sysirq_mask.c
>> @@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
>>  	if (!base)
>>  		return;
>>  
>> -	mask = readl_relaxed(base + AT91_RTC_IMR);
>> -	if (mask) {
>> -		pr_info("AT91: Disabling rtc irq\n");
>> -		writel_relaxed(mask, base + AT91_RTC_IDR);
>> -		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
>> -	}
>> +	writel_relaxed(0x1f, base + AT91_RTC_IDR);
> I believe this is the right way to handle this hardware bug (IMR is
> always read as 0 on one particular SoC), but please document this in a
> comment.

Sure, I'll quote atmel's datasheet describing the errata.

>
> You should also keep the flush (read of IMR) regardless (to make sure
> the write has reached the peripheral), and remember to remove the now
> unused mask variable.

Does it has something to do with memory barriers ?
If so, why not using writel instead of writel_relaxed ?
If not, could you point out where it is described in the datasheet ?

Best Regards,

Boris

>
>>  	iounmap(base);
>>  }
> Thanks,
> Johan

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

