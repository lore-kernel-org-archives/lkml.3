Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3H0Lax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:30:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33839 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3H0Lav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:30:51 -0400
Message-ID: <521C8DF4.3030209@arm.com>
Date: Tue, 27 Aug 2013 12:31:00 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v4 3/5] ARM64: arch_timer: add support to configure and
 enable event stream
References: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1377274749-6196-4-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130827111905.GF19897@arm.com>
In-Reply-To: <20130827111905.GF19897@arm.com>
X-OriginalArrivalTime: 27 Aug 2013 11:30:47.0144 (UTC) FILETIME=[DFE8C680:01CEA318]
X-MC-Unique: 113082712304902401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 27/08/13 12:19, Catalin Marinas wrote:
> On Fri, Aug 23, 2013 at 05:19:07PM +0100, Sudeep KarkadaNagesha wrote:
>> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
>> index 00b09d0..0f57158 100644
>> --- a/arch/arm64/include/asm/arch_timer.h
>> +++ b/arch/arm64/include/asm/arch_timer.h
>> @@ -97,21 +97,53 @@ static inline u32 arch_timer_get_cntfrq(void)
>>  	return val;
>>  }
>>  
>> -static inline void arch_counter_set_user_access(void)
>> +static inline u32 arch_timer_get_cntkctl(void)
>>  {
>>  	u32 cntkctl;
>> -
>>  	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
>> +	return cntkctl;
>> +}
>> +
>> +static inline void arch_timer_set_cntkctl(u32 cntkctl)
>> +{
>> +	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>> +}
>> +
>> +static inline void arch_counter_set_user_access(void)
>> +{
>> +	u32 cntkctl = arch_timer_get_cntkctl();
>>  
>>  	/* Disable user access to the timers and the physical counter. */
>>  	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>>  			| ARCH_TIMER_USR_VT_ACCESS_EN
>>  			| ARCH_TIMER_USR_PCT_ACCESS_EN);
>>  
>> -	/* Enable user access to the virtual counter. */
>> +	/* Enable user access to the virtual counter */
> 
> This change isn't needed here. Just move it to the first patch which
> adds the comment.
> 
It's a mistake, accidentally removed leading '.'
I will remove this.

>>  	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
>>  
>> -	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>> +	arch_timer_set_cntkctl(cntkctl);
>> +}
>> +
>> +static inline void arch_timer_evtstrm_config(bool enable, int divider)
>> +{
>> +	u32 cntkctl = arch_timer_get_cntkctl();
>> +	if (enable) {
>> +		cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
>> +		/* Set the divider and enable virtual event stream */
>> +		cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
>> +				| ARCH_TIMER_VIRT_EVT_EN;
>> +	} else {
>> +		cntkctl &= ~ARCH_TIMER_VIRT_EVT_EN; /* disable event stream */
>> +	}
>> +	arch_timer_set_cntkctl(cntkctl);
>> +}
>> +
>> +static inline void arch_timer_set_hwcap_evtstrm(void)
>> +{
>> +	elf_hwcap |= HWCAP_EVTSTRM;
>> +#ifdef CONFIG_COMPAT
>> +	compat_dyn_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
>> +#endif
>>  }
>>  
>>  static inline u64 arch_counter_get_cntvct(void)
>> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
>> index 6d4482f..022d771 100644
>> --- a/arch/arm64/include/asm/hwcap.h
>> +++ b/arch/arm64/include/asm/hwcap.h
>> @@ -30,6 +30,7 @@
>>  #define COMPAT_HWCAP_IDIVA	(1 << 17)
>>  #define COMPAT_HWCAP_IDIVT	(1 << 18)
>>  #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
>> +#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
>>  
>>  #ifndef __ASSEMBLY__
>>  /*
>> @@ -37,11 +38,15 @@
>>   * instruction set this cpu supports.
>>   */
>>  #define ELF_HWCAP		(elf_hwcap)
>> +#ifdef CONFIG_COMPAT
>>  #define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
>>  				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
>>  				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
>>  				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
>> -				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
>> +				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
>> +				 compat_dyn_elf_hwcap)
>> +extern unsigned int compat_dyn_elf_hwcap;
>> +#endif
> 
> Can we just have a compat_elf_hwcap which is initialised to all the
> above and avoid compat_dyn_elf_hwcap?
> 
It was Will's suggestion(https://lkml.org/lkml/2013/8/20/425)
Moreover with config option now it makes more sense to retain it.
It avoids having conditional definition. Let me know your opinion.

Regards,
Sudeep


