Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab3HNJDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:03:54 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:45759 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759510Ab3HNJDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:03:51 -0400
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 1/6] ARM/ARM64: =?UTF-8?Q?arch=5Ftimer=3A=20add=20m?=  =?UTF-8?Q?acros=20for=20bits=20in=20control=20register?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Aug 2013 10:03:48 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <520B44CF.6040403@linaro.org>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <520B44CF.6040403@linaro.org>
Message-ID: <6071c584a32b1a5f80923818a477a719@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: daniel.lezcano@linaro.org, sudeep.karkadanagesha@arm.com, lorenzo.pieralisi@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 2013-08-14 09:50, Daniel Lezcano wrote:
> On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Add macros to describe the bitfields in the ARM architected timer
>> control register to make code easy to understand.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  arch/arm/include/asm/arch_timer.h    |  9 +++++++--
>>  arch/arm64/include/asm/arch_timer.h  | 12 ++++++++----
>>  include/clocksource/arm_arch_timer.h |  8 ++++++++
>>  3 files changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/arch_timer.h 
>> b/arch/arm/include/asm/arch_timer.h
>> index e406d57..9ef74da 100644
>> --- a/arch/arm/include/asm/arch_timer.h
>> +++ b/arch/arm/include/asm/arch_timer.h
>> @@ -95,8 +95,13 @@ static inline void 
>> arch_counter_set_user_access(void)
>>
>>  	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
>>
>> -	/* disable user access to everything */
>> -	cntkctl &= ~((3 << 8) | (7 << 0));
>> +	/* Disable user access to both physical/virtual counters/timers. 
>> */
>> +	/* Also disable virtual event stream */
>> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>> +			| ARCH_TIMER_USR_VT_ACCESS_EN
>> +			| ARCH_TIMER_VIRT_EVT_EN
>> +			| ARCH_TIMER_USR_VCT_ACCESS_EN
>> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
>>
>>  	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
>>  }
>> diff --git a/arch/arm64/include/asm/arch_timer.h 
>> b/arch/arm64/include/asm/arch_timer.h
>> index 98abd47..00b09d0 100644
>> --- a/arch/arm64/include/asm/arch_timer.h
>> +++ b/arch/arm64/include/asm/arch_timer.h
>> @@ -101,12 +101,16 @@ static inline void 
>> arch_counter_set_user_access(void)
>>  {
>>  	u32 cntkctl;
>>
>> -	/* Disable user access to the timers and the physical counter. */
>>  	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
>> -	cntkctl &= ~((3 << 8) | (1 << 0));
>>
>> -	/* Enable user access to the virtual counter and frequency. */
>> -	cntkctl |= (1 << 1);
>> +	/* Disable user access to the timers and the physical counter. */
>> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>> +			| ARCH_TIMER_USR_VT_ACCESS_EN
>> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
>> +
>> +	/* Enable user access to the virtual counter. */
>> +	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
>> +
>>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>>  }
>
> Before doing those changes, I suggest you kill 
> include/asm/arch_timer.h
> header file and move the functions directly in the arm_arch_timer.c 
> as
> they are only used by it.

How do you suggest to proceed? Having #ifdefs in arm_arch_timer.c to 
cope with the inline assembly functions present in both arm and arm64 
include files? Doesn't seem much of a progress to me...

>> diff --git a/include/clocksource/arm_arch_timer.h 
>> b/include/clocksource/arm_arch_timer.h
>> index c463ce9..551f7e9 100644
>> --- a/include/clocksource/arm_arch_timer.h
>> +++ b/include/clocksource/arm_arch_timer.h
>> @@ -29,6 +29,14 @@
>>  #define ARCH_TIMER_PHYS_ACCESS		0
>>  #define ARCH_TIMER_VIRT_ACCESS		1
>>
>> +#define ARCH_TIMER_USR_PCT_ACCESS_EN	(1 << 0) /* physical counter 
>> */
>> +#define ARCH_TIMER_USR_VCT_ACCESS_EN	(1 << 1) /* virtual counter */
>> +#define ARCH_TIMER_VIRT_EVT_EN		(1 << 2)
>> +#define ARCH_TIMER_EVT_TRIGGER_SHIFT	(4)
>> +#define ARCH_TIMER_EVT_TRIGGER_MASK	(0xF << 
>> ARCH_TIMER_EVT_TRIGGER_SHIFT)
>> +#define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer 
>> registers */
>> +#define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer 
>> registers */
>> +
>>  #ifdef CONFIG_ARM_ARCH_TIMER
>>
>>  extern u32 arch_timer_get_rate(void);
>>

         M.
-- 
Fast, cheap, reliable. Pick two.
