Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab3LIRwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:52:53 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53375 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761245Ab3LIRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:52:41 -0500
Message-ID: <52A6035A.3070804@baylibre.com>
Date: Mon, 09 Dec 2013 09:52:26 -0800
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, Roger Quadros <rogerq@ti.com>
CC: tony@atomide.com, tomi.valkeinen@ti.com, balbi@ti.com, sr@denx.de,
        David.Laight@ACULAB.COM, michael@amarulasolutions.com,
        bigeasy@linutronix.de, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: OMAP4+: hwmod data: Don't prevent RESET of USB
 Host module
References: <1386080748-17005-1-git-send-email-rogerq@ti.com> <1386080748-17005-2-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Paul,

On 08/12/2013 17:26, Paul Walmsley wrote:
> Hi Benoît,
>
> On Tue, 3 Dec 2013, Roger Quadros wrote:
>
>> Without this, the USB devices are sometimes not detected on OMAP4 Panda
>> with u-boot v2013.10.
>>
>> Unlike what the comment states, errata i660 does not state that we
>> can't RESET the USB host module. Instead it states that RESET is the
>> only way to recover from a deadlock situation.
>>
>> RESET ensures that the module is in a known good state irrespective
>> of what bootloader does with the module, so it must be done at boot.
>>
>> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>
> Acked-by: Paul Walmsley <paul@pwsan.com>
>
> Will you pick this up for the -rc series, or do you want me or Tony to?
> Roger writes that this one's pretty important.

I guess, it is better for you to take it. I don't have anything queued 
for -rc.

Acked-by: Benoit Cousson <bcousson@baylibre.com>

Thanks,
Benoit

>
>
> - Paul
>
>
>> ---
>>   arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 12 ++----------
>>   arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 13 +++----------
>>   2 files changed, 5 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> index 1e5b12c..3318cae9 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> @@ -2937,7 +2937,7 @@ static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
>>   	.sysc_offs	= 0x0010,
>>   	.syss_offs	= 0x0014,
>>   	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
>> -			   SYSC_HAS_SOFTRESET),
>> +			   SYSC_HAS_SOFTRESET | SYSC_HAS_RESET_STATUS),
>>   	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>   			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>>   			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>> @@ -3001,15 +3001,7 @@ static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
>>   	 * hence HWMOD_SWSUP_MSTANDBY
>>   	 */
>>
>> -	/*
>> -	 * During system boot; If the hwmod framework resets the module
>> -	 * the module will have smart idle settings; which can lead to deadlock
>> -	 * (above Errata Id:i660); so, dont reset the module during boot;
>> -	 * Use HWMOD_INIT_NO_RESET.
>> -	 */
>> -
>> -	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
>> -			  HWMOD_INIT_NO_RESET,
>> +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>>   };
>>
>>   /*
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
>> index 9e08d69..e297d62 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
>> @@ -1544,7 +1544,8 @@ static struct omap_hwmod_class_sysconfig omap54xx_usb_host_hs_sysc = {
>>   	.rev_offs	= 0x0000,
>>   	.sysc_offs	= 0x0010,
>>   	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
>> -			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
>> +			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
>> +			   SYSC_HAS_RESET_STATUS),
>>   	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>>   			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>>   			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>> @@ -1598,15 +1599,7 @@ static struct omap_hwmod omap54xx_usb_host_hs_hwmod = {
>>   	 * hence HWMOD_SWSUP_MSTANDBY
>>   	 */
>>
>> -	/*
>> -	 * During system boot; If the hwmod framework resets the module
>> -	 * the module will have smart idle settings; which can lead to deadlock
>> -	 * (above Errata Id:i660); so, dont reset the module during boot;
>> -	 * Use HWMOD_INIT_NO_RESET.
>> -	 */
>> -
>> -	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
>> -			  HWMOD_INIT_NO_RESET,
>> +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>>   	.main_clk	= "l3init_60m_fclk",
>>   	.prcm = {
>>   		.omap4 = {
>> --
>> 1.8.3.2
>>
>
>
> - Paul
>


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
