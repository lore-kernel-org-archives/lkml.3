Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaFRPcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:32:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11169 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFRPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:32:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e6-53a1b105a854
Message-id: <53A1AFD8.1080808@samsung.com>
Date: Wed, 18 Jun 2014 19:27:20 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack
 size
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
 <alpine.LFD.2.11.1406181039310.16842@knanqh.ubzr>
In-reply-to: <alpine.LFD.2.11.1406181039310.16842@knanqh.ubzr>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xK7qsGxcGG1xbqmDxflkPo8Wmx9dY
	LS7vmsNmcfsyr8WnZ//YLV5+PMHiwOaxZt4aRo+W5h42jzvX9rB5bF5S7/F5k1wAaxSXTUpq
	TmZZapG+XQJXxssbogWXhSrubzjH1MA4h7+LkZNDQsBEYvvBbawQtpjEhXvr2boYuTiEBJYy
	SrxcvJMZwmlmkvi/4AMzSBWvgJbEiX0fmboYOThYBFQldn6OBwmzCehJ/Ju1nQ0kLCoQIfH4
	ghBEtaDEj8n3WEBsEQEdiaMzX4ONZBbYzyjx5MY6sJHCAiEST26vYAHpFRKokDg/NQskzClg
	J/H71newEmag3v2t09ggbHmJzWveMk9gFJiFZMUsJGWzkJQtYGRexSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRES0l92MC4+ZnWIUYCDUYmH98PbBcFCrIllxZW5hxglOJiVRHhXL18YLMSb
	klhZlVqUH19UmpNafIiRiYNTqoHRZ32S5r3TXp/NgtNqz8q8Uoj3+uhUPF2kuVBuHxf3urbZ
	XpPPPM7b9LqjuKf68h1lproIwS9uke8MC/r+N5dME7zyZmG8a1buStZbM+67/9ipdWa57uSI
	M9Zhtw58v3FtccPKrQXWNZvDG92Ze5LZWdZkp852P2Up2SV+Su99g2PttaVBj14rsRRnJBpq
	MRcVJwIAnc4+mkcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/14 18:40, Nicolas Pitre wrote:
> On Wed, 18 Jun 2014, Andrey Ryabinin wrote:
> 
>> Changing kernel stack size on arm is not as simple as it should be:
>> 1) THRED_SIZE macro doen't respect PAGE_SIZE and THREAD_SIZE_ORDER
>> 2) stack size is hardcoded in get_thread_info macro
>>
>> This patch fixes it by caculating THREAD_SIZE and thread_info address
>> taking into account PAGE_SIZE and THREAD_SIZE_ORDER.
>>
>> Now changing stack size becomes simply changing THREAD_SIZE_ORDER.
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> 
> 

Thanks. Patch with fixes in commit message pushed to Russel's patch tracking system, #8078/1.
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8078/1


>> ---
>>  arch/arm/include/asm/assembler.h   | 8 +++++---
>>  arch/arm/include/asm/thread_info.h | 3 ++-
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
>> index 57f0584..906703a 100644
>> --- a/arch/arm/include/asm/assembler.h
>> +++ b/arch/arm/include/asm/assembler.h
>> @@ -24,6 +24,8 @@
>>  #include <asm/domain.h>
>>  #include <asm/opcodes-virt.h>
>>  #include <asm/asm-offsets.h>
>> +#include <asm/page.h>
>> +#include <asm/thread_info.h>
>>  
>>  #define IOMEM(x)	(x)
>>  
>> @@ -179,10 +181,10 @@
>>   * Get current thread_info.
>>   */
>>  	.macro	get_thread_info, rd
>> - ARM(	mov	\rd, sp, lsr #13	)
>> + ARM(	mov	\rd, sp, lsr #THREAD_SIZE_ORDER + PAGE_SHIFT	)
>>   THUMB(	mov	\rd, sp			)
>> - THUMB(	lsr	\rd, \rd, #13		)
>> -	mov	\rd, \rd, lsl #13
>> + THUMB(	lsr	\rd, \rd, #THREAD_SIZE_ORDER + PAGE_SHIFT	)
>> +	mov	\rd, \rd, lsl #THREAD_SIZE_ORDER + PAGE_SHIFT
>>  	.endm
>>  
>>  /*
>> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
>> index f989d7c..f85d2b0 100644
>> --- a/arch/arm/include/asm/thread_info.h
>> +++ b/arch/arm/include/asm/thread_info.h
>> @@ -14,9 +14,10 @@
>>  
>>  #include <linux/compiler.h>
>>  #include <asm/fpstate.h>
>> +#include <asm/page.h>
>>  
>>  #define THREAD_SIZE_ORDER	1
>> -#define THREAD_SIZE		8192
>> +#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
>>  #define THREAD_START_SP		(THREAD_SIZE - 8)
>>  
>>  #ifndef __ASSEMBLY__
>> -- 
>> 1.8.5.5
>>
> 

