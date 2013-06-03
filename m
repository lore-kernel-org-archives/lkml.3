Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3FCE5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:57:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49181 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FCE5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:57:12 -0400
Message-ID: <51AC2222.8000604@linaro.org>
Date: Mon, 03 Jun 2013 10:27:06 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/3] ARM: EXYNOS: uncompress - print debug messages if
 DEBUG_LL is defined
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org> <1370000944-19786-2-git-send-email-tushar.behera@linaro.org> <20130601035929.GA3868@quad.lixom.net>
In-Reply-To: <20130601035929.GA3868@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 09:29 AM, Olof Johansson wrote:
> On Fri, May 31, 2013 at 05:19:02PM +0530, Tushar Behera wrote:
>> Printing low-level debug messages make an assumption that the specified
>> UART port has been preconfigured by the bootloader. Incorrectly
>> specified UART port results in system getting stalled while printing the
>> message "Uncompressing Linux... done, booting the kernel"
>>
>> This UART port number is specified through S3C_LOWLEVEL_UART_PORT. Since
>> the UART port might different for different board, it is not possible to
>> specify it correctly for every board that use a common defconfig file.
>>
>> Calling this print subroutine only when DEBUG_LL fixes the problem. By
>> disabling DEBUG_LL in default config file, we would be able to boot
>> multiple boards with different default UART ports.
>>
>> With this current approach, we miss the print "Uncompressing Linux...
>> done, booting the kernel." when DEBUG_LL is not defined.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  arch/arm/mach-exynos/include/mach/uncompress.h  |   11 ++++++++---
>>  arch/arm/plat-samsung/include/plat/uncompress.h |   10 +++++++++-
>>  2 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/include/mach/uncompress.h b/arch/arm/mach-exynos/include/mach/uncompress.h
>> index 2979995..730f69f 100644
>> --- a/arch/arm/mach-exynos/include/mach/uncompress.h
>> +++ b/arch/arm/mach-exynos/include/mach/uncompress.h
>> @@ -37,11 +37,16 @@ static void arch_detect_cpu(void)
>>  	chip_id >>= 20;
>>  	chip_id &= 0xf;
>>  
>> +#ifdef CONFIG_DEBUG_LL
>>  	if (chip_id == 0x5)
>> -		uart_base = (volatile u8 *)EXYNOS5_PA_UART + (S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
>> +		uart_base = (volatile u8 *)EXYNOS5_PA_UART +
>> +			(S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
>>  	else
>> -		uart_base = (volatile u8 *)EXYNOS4_PA_UART + (S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
>> -
>> +		uart_base = (volatile u8 *)EXYNOS4_PA_UART +
>> +			(S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
>> +#else
>> +	uart_base = NULL;
>> +#endif
> 
> You can do:
> 
> 	if (!config_enabled(CONFIG_DEBUG_LL))
> 		return;
> 

Thanks for the hint.

Or rather, we calculate uart_base unconditionally in mach/uncompress.h
and replace check for uart_base with config_enabled(CONFIG_DEBUG_LL) in
plat/uncompress.h. That would get rid of all the ifdef's in the
mach/uncompress.h files.

Let me spin out another version with this change.

> Since uart_base will be set to 0 by being in BSS anyway.
> 
> 
> -Olof
> 


-- 
Tushar Behera
