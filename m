Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBJOpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:45:34 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:58941 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbaBJOpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:45:33 -0500
Message-ID: <52F8E5E2.30805@st.com>
Date: Mon, 10 Feb 2014 15:44:50 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
Cc: <linux@arm.linux.org.uk>, <u.kleine-koenig@pengutronix.de>,
        <jonathan.austin@arm.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <nico@linaro.org>, <sboyd@codeaurora.org>,
        <marc.zyngier@arm.com>, <ben.dooks@codethink.co.uk>,
        <vgupta@synopsys.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140210141634.GA2794@e103592.cambridge.arm.com>
In-Reply-To: <20140210141634.GA2794@e103592.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 03:16 PM, Dave Martin wrote:
> On Fri, Feb 07, 2014 at 05:19:15PM +0100, Fabrice GASNIER wrote:
>> This patch adds imprecise abort enable/disable macros.
>> It also enables imprecise aborts when starting kernel.
> Relying on imprecise aborts for hardware probing would be considered bad
> hardware and/or software design for ARM-specific stuff.
>
> PCI is more generic though, so we may have to put up with this to some
> extent.  Can you point me to the affected probing code?  I'm not very
> familiar with that stuff...
Hi,

I'm currently re-basing to prepare upstream of such a driver so, no code 
for now on my side,
but, I saw others that have similar behavior :
http://www.spinics.net/lists/linux-pci/msg26124.html
Basically, I think all PCI drivers using hook_fault_code(16+6, ...) use 
similar mechanism.
>
>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>> ---
>>   arch/arm/include/asm/irqflags.h |   33 +++++++++++++++++++++++++++++++++
>>   arch/arm/kernel/smp.c           |    1 +
>>   arch/arm/kernel/traps.c         |    4 ++++
>>   3 files changed, 38 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
>> index 3b763d6..82e3834 100644
>> --- a/arch/arm/include/asm/irqflags.h
>> +++ b/arch/arm/include/asm/irqflags.h
>> @@ -51,6 +51,9 @@ static inline void arch_local_irq_disable(void)
>>   
>>   #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
>>   #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
>> +
>> +#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
>> +#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
>>   #else
>>   
>>   /*
>> @@ -130,6 +133,36 @@ static inline void arch_local_irq_disable(void)
>>   	: "memory", "cc");					\
>>   	})
>>   
>> +/*
>> + * Enable Aborts
>> + */
>> +#define local_abt_enable()					\
>> +	({							\
>> +		unsigned long temp;				\
>> +	__asm__ __volatile__(					\
>> +	"mrs	%0, cpsr		@ sta\n"		\
>> +"	bic	%0, %0, %1\n"					\
>> +"	msr	cpsr_c, %0"					\
> I suggest you use "cpsie/cpsid a" instead.  This requires ARMv6, but the
> CPSR.A bit only exists on ARMv6 and later anyway.  Poking that bit
> on earlier CPUs may cause unpredictable behaviour, so these macros
> should be no-ops for v5 and earlier.
Thanks,
I'll prepare a new patch that way.
>
>> +	: "=r" (temp)						\
>> +	: "r" (PSR_A_BIT)					\
>> +	: "memory", "cc");					\
>> +	})
>> +
>> +/*
>> + * Disable Aborts
>> + */
>> +#define local_abt_disable()					\
>> +	({							\
>> +		unsigned long temp;				\
>> +	__asm__ __volatile__(					\
>> +	"mrs	%0, cpsr		@ cla\n"		\
>> +"	orr	%0, %0, %1\n"					\
>> +"	msr	cpsr_c, %0"					\
>> +	: "=r" (temp)						\
>> +	: "r" (PSR_A_BIT)					\
>> +	: "memory", "cc");					\
>> +	})
>> +
>>   #endif
>>   
>>   /*
>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>> index dc894ab..c2093cb 100644
>> --- a/arch/arm/kernel/smp.c
>> +++ b/arch/arm/kernel/smp.c
>> @@ -377,6 +377,7 @@ asmlinkage void secondary_start_kernel(void)
>>   
>>   	local_irq_enable();
>>   	local_fiq_enable();
>> +	local_abt_enable();
>>   
>>   	/*
>>   	 * OK, it's off to the idle thread for us
>> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
>> index 4636d56..ef15709 100644
>> --- a/arch/arm/kernel/traps.c
>> +++ b/arch/arm/kernel/traps.c
>> @@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
>>   
>>   	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
>>   	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
>> +
>> +	/* Enable imprecise aborts */
>> +	local_abt_enable();
> It would be good to clean up why aborts are not being consistently
> enabled on boot.
I did a bit of analysis and summarized it in this thread. I've not been 
further:
http://archive.arm.linux.org.uk/lurker/message/20140203.164322.edba427a.en.html

BR,
Fabrice
>
> Really, they should be enabled, except for a brief window during
> boot when the vectors are not mapped and the abort can't be dispatched.
>
> Cheers
> ---Dave

