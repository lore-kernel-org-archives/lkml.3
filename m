Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaEIPAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:00:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46689 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756697AbaEIPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:00:03 -0400
Message-ID: <536CED70.3060908@free-electrons.com>
Date: Fri, 09 May 2014 17:00:00 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Roszko <mark.roszko@gmail.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v4] ARM: at91: fix at91_sysirq_mask_rtc for sam9x5
 SoCs
References: <1399646610-18816-1-git-send-email-boris.brezillon@free-electrons.com> <20140509145125.GD6776@localhost>
In-Reply-To: <20140509145125.GD6776@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2014 16:51, Johan Hovold wrote:
> On Fri, May 09, 2014 at 04:43:30PM +0200, Boris BREZILLON wrote:
>> sam9x5 SoCs have the following errata:
>> "RTC: Interrupt Mask Register cannot be used
>>  Interrupt Mask Register read always returns 0."
>>
>> Hence we should not rely on what IMR claims about already masked IRQs
>> and just disable all IRQs.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: <stable@vger.kernel.org> # v3.10+
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Reviewed-by: Johan Hovold <jhovold@gmail.com>
>
> Looks good, but for the future: Why do you break the comment lines you
> added at column 60?

Oops, I guess I was influenced by the preceding lines (atmel's datasheet
quote).

>
> Thanks,
> Johan
>
>> ---
>> Hello,
>>
>> Again, sorry for the noise, but I forgot to add Nicolas' ack and to keep
>> Andrew and the stable ML in cc.
>>
>> Best Regards,
>>
>> Boris
>>
>> Changes since v3:
>> - fix commit message and comment
>> Changes since v2:
>> - removed unused variable 'mask'
>> Changes since v1:
>> - use a macro to define IRQs bitmask
>> - read IMR register to ensure the write to IDR has been flushed
>> - quote atmel's datasheet errata in commit message
>> - comment the code to describe why we're not using IMR to disable
>>   the interrupts
>>
>>  arch/arm/mach-at91/sysirq_mask.c | 22 +++++++++++++---------
>>  1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
>> index 2ba694f..f8bc351 100644
>> --- a/arch/arm/mach-at91/sysirq_mask.c
>> +++ b/arch/arm/mach-at91/sysirq_mask.c
>> @@ -25,24 +25,28 @@
>>  
>>  #include "generic.h"
>>  
>> -#define AT91_RTC_IDR	0x24	/* Interrupt Disable Register */
>> -#define AT91_RTC_IMR	0x28	/* Interrupt Mask Register */
>> +#define AT91_RTC_IDR		0x24	/* Interrupt Disable Register */
>> +#define AT91_RTC_IMR		0x28	/* Interrupt Mask Register */
>> +#define AT91_RTC_IRQ_MASK	0x1f	/* Available IRQs mask */
>>  
>>  void __init at91_sysirq_mask_rtc(u32 rtc_base)
>>  {
>>  	void __iomem *base;
>> -	u32 mask;
>>  
>>  	base = ioremap(rtc_base, 64);
>>  	if (!base)
>>  		return;
>>  
>> -	mask = readl_relaxed(base + AT91_RTC_IMR);
>> -	if (mask) {
>> -		pr_info("AT91: Disabling rtc irq\n");
>> -		writel_relaxed(mask, base + AT91_RTC_IDR);
>> -		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
>> -	}
>> +	/*
>> +	 * sam9x5 SoCs have the following errata:
>> +	 * "RTC: Interrupt Mask Register cannot be used
>> +	 *  Interrupt Mask Register read always returns 0."
>> +	 *
>> +	 * Hence we're not relying on IMR values to disable
>> +	 * interrupts.
>> +	 */
>> +	writel_relaxed(AT91_RTC_IRQ_MASK, base + AT91_RTC_IDR);
>> +	(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
>>  
>>  	iounmap(base);
>>  }

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

