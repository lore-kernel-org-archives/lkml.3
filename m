Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbAPQPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:15:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54573 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbAPQPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:15:48 -0500
Message-ID: <54B93930.1090409@arm.com>
Date: Fri, 16 Jan 2015 16:15:44 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm64: Track system support for mixed endian EL0
References: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com> <1421325366-13263-2-git-send-email-suzuki.poulose@arm.com> <20150116155322.GX7091@arm.com>
In-Reply-To: <20150116155322.GX7091@arm.com>
X-OriginalArrivalTime: 16 Jan 2015 16:15:45.0193 (UTC) FILETIME=[AE934190:01D031A7]
X-MC-Unique: 115011616154502301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/15 15:53, Will Deacon wrote:
> On Thu, Jan 15, 2015 at 12:36:04PM +0000, Suzuki K. Poulose wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>
>> This patch keeps track of the mixed endian EL0 support across
>> the system and provides helper functions to export it. The status
>> is a boolean indicating whether all the CPUs on the system supports
>> mixed endian at EL0.
>>
>> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/cpufeature.h |   10 ++++++++++
>>   arch/arm64/kernel/cpuinfo.c         |   22 ++++++++++++++++++++++
>>   2 files changed, 32 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 07547cc..c7f68d1 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -26,6 +26,9 @@
>>
>>   #define ARM64_NCAPS				2
>>
>> +#define ID_AA64MMFR0_EL1_BigEndEL0	(0x1UL << 16)
>> +#define ID_AA64MMFR0_EL1_BigEnd		(0x1UL << 8)
>
> I don't like the CaMeLcAsE. Also, perhaps these definitions should be
> somewhere like cputype.h?
Yeah, I tried to keep it aligned withe ARMv8 architecture definition of 
those bits. Will change it.
Things are a bit messy w.r.t the definitions. We have cpu.h, 
cpufeature.h and cputype.h. I could move it to cputype.h, where we 
already have MIDR_ defintions.

>
>> +
>>   #ifndef __ASSEMBLY__
>>
>>   extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
>> @@ -51,7 +54,14 @@ static inline void cpus_set_cap(unsigned int num)
>>   		__set_bit(num, cpu_hwcaps);
>>   }
>>
>> +static inline bool id_aa64mmfr0_mixed_endian_el0(unsigned long mmfr0)
>> +{
>> +	return !!(mmfr0 & (ID_AA64MMFR0_EL1_BigEndEL0 | ID_AA64MMFR0_EL1_BigEnd));
>> +}
>
> These are 4-bit fields and I think you think you should be treating them
> as such.
OK

>
>> +
>>   void check_local_cpu_errata(void);
>> +bool system_supports_mixed_endian_el0(void);
>> +bool cpu_supports_mixed_endian_el0(void);
>>
>>   #endif /* __ASSEMBLY__ */
>>
>> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
>> index 07d435c..b6d1135 100644
>> --- a/arch/arm64/kernel/cpuinfo.c
>> +++ b/arch/arm64/kernel/cpuinfo.c
>> @@ -35,6 +35,7 @@
>>    */
>>   DEFINE_PER_CPU(struct cpuinfo_arm64, cpu_data);
>>   static struct cpuinfo_arm64 boot_cpu_data;
>> +static bool mixed_endian_el0 = true;
>>
>>   static char *icache_policy_str[] = {
>>   	[ICACHE_POLICY_RESERVED] = "RESERVED/UNKNOWN",
>> @@ -68,6 +69,26 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
>>   	pr_info("Detected %s I-cache on CPU%d\n", icache_policy_str[l1ip], cpu);
>>   }
>>
>> +bool cpu_supports_mixed_endian_el0(void)
>> +{
>> +	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
>> +}
>
> Can we not just define a mask/value pair and have code do the MMFR0 access
> inline? It also feels a bit over-engineered like this.
Sure, will change this.

Thanks
Suzuki
>
> Will
>


