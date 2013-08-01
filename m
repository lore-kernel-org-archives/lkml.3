Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3HAIkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:40:17 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49765 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:40:14 -0400
Date: Thu, 1 Aug 2013 16:40:05 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Hein Tibosch" <hein_tibosch@yahoo.es>
Cc: balajitk <balajitk@ti.com>, cjb <cjb@laptop.org>,
        mayuzheng <mayuzheng@kedacom.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Felipe Balbi" <balbi@ti.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH] mmc: omap_hsmmc: Fix sleep too long in ISR context.
References: <201308011017566117580@gmail.com>, 
	<51FA1AB7.8030105@yahoo.es>
X-Priority: 3
X-GUID: B2E86939-18C5-4116-9D6C-481464B70FFC
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201308011640027321434@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r718ePsL019440

>Hi Jianpeng Ma,
>
>On 8/1/2013 10:18 AM, majianpeng wrote:
>> We found a problem when we removed a working sd card that the irqaction
>> of omap_hsmmc can sleep to 3.6s. This cause our watchdog to work.
>> In func omap_hsmmc_reset_controller_fsm, it should watch a 0->1
>> transition.It used loops_per_jiffy as the timer.
>> The code is:
>>> while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>>>                && (i++ < limit))
>>>                        cpu_relax();
>> But the loops_per_jiffy is:
>>>  while(i++ < limit)
>>> 	cpu_relax();
>> It add some codes so the time became long.
>> Becasue those codes in ISR context, it can't use timer_before/after.
>> I divived the time into 1ms and used udelay(1) to instead.
>> It will cause do additional udelay(1).But from my test,it looks good.
>>
>> Reported-by: Yuzheng Ma <mayuzheng@kedacom.com>
>> Tested-by: Yuzheng Ma <mayuzheng@kedacom.com>
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  drivers/mmc/host/omap_hsmmc.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 1865321..96daca1 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -977,6 +977,8 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>>  	unsigned long limit = (loops_per_jiffy *
>>  				msecs_to_jiffies(MMC_TIMEOUT_MS));
>>  
>> +	/*Divided time into us for unit 1,we can use udelay(1)*/
>> +	i = limit / (MMC_TIMEOUT_MS * 1000);
>
>'limit' is a number of loops, which you now divide by 20,000?
>
>To get uS, you could just change:
>
>-	unsigned long limit = (loops_per_jiffy *
>-				msecs_to_jiffies(MMC_TIMEOUT_MS));
>+	unsigned long limit = 1000 * MMC_TIMEOUT_MS;
>
Yes, you are right.
>and make this amount of loops using udelay().
>
>>  	OMAP_HSMMC_WRITE(host->base, SYSCTL,
>>  			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
>>  
>> @@ -985,15 +987,19 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>>  	 * Monitor a 0->1 transition first
>>  	 */
>>  	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
>> -		while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> -					&& (i++ < limit))
>> -			cpu_relax();
>
>I still don't see why any of these loops could last 3.6 seconds?
>Yes the __raw_readl() will add some time, but so much?
>I'd like to see which value you get for 'limit' on your machine
>Would PM play a role? Or cpu-freq, and 'loops_per_jiffy' isn't updated
>on time?
>From my test, i found it don't monitor a 0->1 transtion.That is the last result is 'i = limit'.
The later while opertion stop also because 'i = limit'.
The basic reason is the hardware. 
It write bit and monitor 1-->0---1>---0.But we start monitor we only got 0 and the value don't change.
Maybe the transition is 1-->0.So the monitor can't work but still waste cpu.

>
>> +		while (i--) {
>> +			if ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> +				break;
>> +			udelay(1);
>
>In earlier threads, the use of udelay was disliked because it's a waste
>of cpu cycles. The desired bit in SYSCTL will change, while udelay()
>is still making many useless loops.
Yes, but it at most wast 1us.

Jianpeng Ma
>
>> +		}
>>  	}
>> -	i = 0;
>>  
>> -	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
>> -		(i++ < limit))
>> -		cpu_relax();
>> +	i = limit / (MMC_TIMEOUT_MS * 1000);
>> +	while (i--) {
>> +		if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> +			break;
>> +		udealy(1);
>> +	}
>>  
>>  	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
>>  		dev_err(mmc_dev(host->mmc),
>Hein
Thanks!
Jianpeng Ma
>Hi Jianpeng Ma,
>
>On 8/1/2013 10:18 AM, majianpeng wrote:
>> We found a problem when we removed a working sd card that the irqaction
>> of omap_hsmmc can sleep to 3.6s. This cause our watchdog to work.
>> In func omap_hsmmc_reset_controller_fsm, it should watch a 0->1
>> transition.It used loops_per_jiffy as the timer.
>> The code is:
>>> while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>>>                && (i++ < limit))
>>>                        cpu_relax();
>> But the loops_per_jiffy is:
>>>  while(i++ < limit)
>>> 	cpu_relax();
>> It add some codes so the time became long.
>> Becasue those codes in ISR context, it can't use timer_before/after.
>> I divived the time into 1ms and used udelay(1) to instead.
>> It will cause do additional udelay(1).But from my test,it looks good.
>>
>> Reported-by: Yuzheng Ma <mayuzheng@kedacom.com>
>> Tested-by: Yuzheng Ma <mayuzheng@kedacom.com>
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  drivers/mmc/host/omap_hsmmc.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 1865321..96daca1 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -977,6 +977,8 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>>  	unsigned long limit = (loops_per_jiffy *
>>  				msecs_to_jiffies(MMC_TIMEOUT_MS));
>>  
>> +	/*Divided time into us for unit 1,we can use udelay(1)*/
>> +	i = limit / (MMC_TIMEOUT_MS * 1000);
>
>'limit' is a number of loops, which you now divide by 20,000?
>
>To get uS, you could just change:
>
>-	unsigned long limit = (loops_per_jiffy *
>-				msecs_to_jiffies(MMC_TIMEOUT_MS));
>+	unsigned long limit = 1000 * MMC_TIMEOUT_MS;
>
>and make this amount of loops using udelay().
>
>>  	OMAP_HSMMC_WRITE(host->base, SYSCTL,
>>  			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
>>  
>> @@ -985,15 +987,19 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>>  	 * Monitor a 0->1 transition first
>>  	 */
>>  	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
>> -		while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> -					&& (i++ < limit))
>> -			cpu_relax();
>
>I still don't see why any of these loops could last 3.6 seconds?
>Yes the __raw_readl() will add some time, but so much?
>I'd like to see which value you get for 'limit' on your machine
>Would PM play a role? Or cpu-freq, and 'loops_per_jiffy' isn't updated
>on time?
>
>> +		while (i--) {
>> +			if ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> +				break;
>> +			udelay(1);
>
>In earlier threads, the use of udelay was disliked because it's a waste
>of cpu cycles. The desired bit in SYSCTL will change, while udelay()
>is still making many useless loops.
>
>> +		}
>>  	}
>> -	i = 0;
>>  
>> -	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
>> -		(i++ < limit))
>> -		cpu_relax();
>> +	i = limit / (MMC_TIMEOUT_MS * 1000);
>> +	while (i--) {
>> +		if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>> +			break;
>> +		udealy(1);
>> +	}
>>  
>>  	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
>>  		dev_err(mmc_dev(host->mmc),
>Heinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
