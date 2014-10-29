Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaJ2FOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:14:18 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37513 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaJ2FOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:14:16 -0400
X-Original-SENDERIP: 10.178.30.169
X-Original-MAILFROM: hankyung.yu@lge.com
From: =?ks_c_5601-1987?B?wK/H0bDm?= <hankyung.yu@lge.com>
To: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chanho Min'" <chanho.min@lge.com>, "'Chris Ball'" <chris@printf.net>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Seungwon Jeon'" <tgih.jun@samsung.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'HyoJun Im'" <hyojun.im@lge.com>, <gunho.lee@lge.com>,
        "'CPGS'" <cpgs@samsung.com>
References: <1413946555-1266-1-git-send-email-chanho.min@lge.com> <544F1DB3.9050204@samsung.com> <00b601cff30a$3c57e710$b507b530$@lge.com> <54504B4E.2070208@samsung.com>
In-Reply-To: <54504B4E.2070208@samsung.com>
Subject: RE: [PATCH] mmc:core: fix hs400 timing selection
Date: Wed, 29 Oct 2014 14:14:14 +0900
Message-ID: <010501cff337$2e9e9790$8bdbc6b0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJgI7CSBWg4GKXd5yLJVzam1HpizQGEUuZiArskKpoBjS5zL5r3waPQ
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have read the specifications document to answer your question.
It is better, I think, the host controller is changed into DDR50 mode when
to change the eMMC bus mode into DDR50
There will no problem because the no data line will be used in DDR50 mode
during the transition to HS400.


So we drop this patch

Sorry for confusing. Thanks for the helpful response.

-----Original Message-----
From: Jaehoon Chung [mailto:jh80.chung@samsung.com] 
Sent: Wednesday, October 29, 2014 11:05 AM
To: 유한경; 'Jaehoon Chung'; 'Chanho Min'; 'Chris Ball'; 'Ulf Hansson';
'Seungwon Jeon'
Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; 'HyoJun Im';
gunho.lee@lge.com; 'CPGS'
Subject: Re: [PATCH] mmc:core: fix hs400 timing selection

Hi,

On 10/29/2014 08:52 AM, 유한경 wrote:
> Hi I'm Hankyung Yu
> 
> I will answer instead Chanho Min
> 
> After mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
> 
> Host controller set to SDR transfer
> 
> so is to change to a DDR transfer mode.

As commit message was mentioned, I have checked the JEDEC v5.01 spec(6.6.5).
There is no mention that mode needs to change to DDR mode.

And i know HS400 mode is only support the 8bit buswidth.
If HS200 mode was set to 4bit buswidth, is HS400 working fine?

Best Regards,
Jaehoon Chung

> 
> 
> -----Original Message-----
> From: Jaehoon Chung [mailto:jh80.chung@samsung.com]
> Sent: Tuesday, October 28, 2014 1:38 PM
> To: Chanho Min; Chris Ball; Ulf Hansson; Seungwon Jeon; Jaehoon Chung
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; HyoJun 
> Im; gunho.lee@lge.com; Hankyung Yu; CPGS
> Subject: Re: [PATCH] mmc:core: fix hs400 timing selection
> 
> Hi, Chanho.
> 
> On 10/22/2014 11:55 AM, Chanho Min wrote:
>> According to JEDEC v5.01 spec (6.6.5), In order to switch to HS400 
>> mode, host should perform the following steps.
>>
>>  1. HS200 mode selection completed
>>  2. Set HS_TIMING to 0x01(High Speed)  3. Host changes frequency to 
>> =< 52MHz  4. Set the bus width to DDR 8bit (CMD6)  5. Host may read 
>> Driver Strength (CMD8)  6. Set HS_TIMING to 0x03 (HS400)
>>
>> In current implementation, the order of 2 and 3 is reversed.
>> The HS_TIMING field should be set to 0x1 before the clock frequency 
>> is set to a value not greater than 52 MHz. Otherwise, Initialization 
>> of timing can be failed. Also, the host contoller's UHS timing mode 
>> should be set to DDR50 after the bus width is set to DDR 8bit.
>>
>> Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
>> Signed-off-by: Chanho Min <chanho.min@lge.com>
>> ---
>>  drivers/mmc/core/mmc.c |   13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index
>> a301a78..52f78e0 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -1061,9 +1061,6 @@ static int mmc_select_hs400(struct mmc_card *card)
>>  	 * Before switching to dual data rate operation for HS400,
>>  	 * it is required to convert from HS200 mode to HS mode.
>>  	 */
>> -	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> -	mmc_set_bus_speed(card);
>> -
>>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS,
>>  			   card->ext_csd.generic_cmd6_time, @@ -1074,6
> +1071,14 @@ static
>> int mmc_select_hs400(struct mmc_card *card)
>>  		return err;
>>  	}
>>  
>> +	/*
>> +	 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
>> +	 * be set to a value not greater than 52MHz after the HS_TIMING
>> +	 * field is set to 0x1.
>> +	 */
>> +	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> +	mmc_set_bus_speed(card);
>> +
>>  	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			 EXT_CSD_BUS_WIDTH,
>>  			 EXT_CSD_DDR_BUS_WIDTH_8,
>> @@ -1084,6 +1089,8 @@ static int mmc_select_hs400(struct mmc_card *card)
>>  		return err;
>>  	}
>>  
>> +	mmc_set_timing(card->host, MMC_TIMING_MMC_DDR52);
>> +
> 
> I didn't know why timing is set to ddr50.
> 
> Best Regards,
> Jaehoon Chung
> 
>>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS400,
>>  			   card->ext_csd.generic_cmd6_time,
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 

