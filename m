Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3LKMFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:05:21 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41584
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab3LKMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:05:17 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
X-WSS-ID: 0MXN5FI-08-C9R-02
X-M-MSG: 
Message-ID: <52A854F7.7000701@amd.com>
Date: Wed, 11 Dec 2013 06:05:11 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <mingo@kernel.org>, <mingo@redhat.com>, <jacob.w.shin@gmail.com>,
        <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <tgl@domain.invalid>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131210152342.GE10633@localhost.localdomain>
In-Reply-To: <20131210152342.GE10633@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 9:23 AM, Frederic Weisbecker wrote:
> On Wed, Oct 02, 2013 at 11:11:06AM -0500,suravee.suthikulpanit@amd.com  wrote:
>> From: Jacob Shin<jacob.w.shin@gmail.com>
>>
>> Implement hardware breakpoint address mask for AMD Family 16h and
>> above processors. CPUID feature bit indicates hardware support for
>> DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
>> breakpoint addresses to allow matching of larger addresses ranges.
>>
>> Valuable advice and pseudo code from Oleg Nesterov<oleg@redhat.com>
>>
>> Signed-off-by: Jacob Shin<jacob.w.shin@gmail.com>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
> Thinking further about this, Oleg convinced me that we can keep the mask eventually.
> It actually makes sense internally just for the use of bpext.
>
> But I still have a few comments on this patchset:
>> ---
>>   arch/x86/include/asm/cpufeature.h     |  2 ++
>>   arch/x86/include/asm/debugreg.h       |  5 ++++
>>   arch/x86/include/asm/hw_breakpoint.h  |  1 +
>>   arch/x86/include/uapi/asm/msr-index.h |  4 +++
>>   arch/x86/kernel/cpu/amd.c             | 19 ++++++++++++++
>>   arch/x86/kernel/hw_breakpoint.c       | 47 ++++++++++++++---------------------
>>   6 files changed, 49 insertions(+), 29 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
>> index d3f5c63..26609bb 100644
>> --- a/arch/x86/include/asm/cpufeature.h
>> +++ b/arch/x86/include/asm/cpufeature.h
>> @@ -170,6 +170,7 @@
>>   #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
>>   #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
>>   #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
>> +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
> Please comment that it's AMD specific.

This #define locates in the AMD-specific section within the code,
which already has a comment at the beginning of the section saying
"/* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */".

>>   #define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
>>   
>>   /*
>> @@ -332,6 +333,7 @@ extern const char * const x86_power_flags[32];
>>   #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
>>   #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>>   #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>> +#define cpu_has_bpext		boot_cpu_has(X86_FEATURE_BPEXT)
>>   
>>   #ifdef CONFIG_X86_64
>>   
>> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
>> index 4b528a9..145b009 100644
>> --- a/arch/x86/include/asm/debugreg.h
>> +++ b/arch/x86/include/asm/debugreg.h
>> @@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
>>   static inline void debug_stack_usage_dec(void) { }
>>   #endif /* X86_64 */
>>   
>> +#ifdef CONFIG_CPU_SUP_AMD
>> +extern void set_dr_addr_mask(unsigned long mask, int dr);
>> +#else
>> +static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
>> +#endif
>>   
>>   #endif /* _ASM_X86_DEBUGREG_H */
>> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
>> index ef1c4d2..6c98be8 100644
>> --- a/arch/x86/include/asm/hw_breakpoint.h
>> +++ b/arch/x86/include/asm/hw_breakpoint.h
>> @@ -12,6 +12,7 @@
>>    */
>>   struct arch_hw_breakpoint {
>>   	unsigned long	address;
>> +	unsigned long	mask;
>>   	u8		len;
>>   	u8		type;
>>   };
>> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
>> index bb04650..1f04f6c 100644
>> --- a/arch/x86/include/uapi/asm/msr-index.h
>> +++ b/arch/x86/include/uapi/asm/msr-index.h
>> @@ -205,6 +205,10 @@
>>   /* Fam 16h MSRs */
>>   #define MSR_F16H_L2I_PERF_CTL		0xc0010230
>>   #define MSR_F16H_L2I_PERF_CTR		0xc0010231
>> +#define MSR_F16H_DR1_ADDR_MASK		0xc0011019
>> +#define MSR_F16H_DR2_ADDR_MASK		0xc001101a
>> +#define MSR_F16H_DR3_ADDR_MASK		0xc001101b
>> +#define MSR_F16H_DR0_ADDR_MASK		0xc0011027
>>   
>>   /* Fam 15h MSRs */
>>   #define MSR_F15H_PERF_CTL		0xc0010200
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 903a264..fffc9cb 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -909,3 +909,22 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>>   
>>   	return false;
>>   }
>> +
>> +void set_dr_addr_mask(unsigned long mask, int dr)
>> +{
>> +	if (!cpu_has_bpext)
>> +		return;
>> +
>> +	switch (dr) {
>> +	case 0:
>> +		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
>> +		break;
>> +	case 1:
>> +	case 2:
>> +	case 3:
>> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
>> +		break;
>> +	default:
> How about just:
>
> if (dr <= 4 && dr >= 0)
>     wrmsr(MSR_F16H_DR1_ADDR_MASK + dr - 1, mask, 0)

That won't work since the DR0 (MSR 0xc0011027)is at not contiguous
with DR1-3 (MSR 0xc0011019 - 0xc001101b).  If you prefer if/else, we
can do that as well, but I think it might be as cumbersome in the code.

>> +		break;
>> +	}
>> +}
>> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
>> index f66ff16..3cb1951 100644
>> --- a/arch/x86/kernel/hw_breakpoint.c
>> +++ b/arch/x86/kernel/hw_breakpoint.c
>> @@ -128,6 +128,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>>   	*dr7 |= encode_dr7(i, info->len, info->type);
>>   
>>   	set_debugreg(*dr7, 7);
>> +	if (info->mask)
>> +		set_dr_addr_mask(info->mask, i);
>>   
>>   	return 0;
>>   }
>> @@ -163,29 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
>>   	*dr7 &= ~__encode_dr7(i, info->len, info->type);
>>   
>>   	set_debugreg(*dr7, 7);
>> -}
>> -
>> -static int get_hbp_len(u8 hbp_len)
>> -{
>> -	unsigned int len_in_bytes = 0;
>> -
>> -	switch (hbp_len) {
>> -	case X86_BREAKPOINT_LEN_1:
>> -		len_in_bytes = 1;
>> -		break;
>> -	case X86_BREAKPOINT_LEN_2:
>> -		len_in_bytes = 2;
>> -		break;
>> -	case X86_BREAKPOINT_LEN_4:
>> -		len_in_bytes = 4;
>> -		break;
>> -#ifdef CONFIG_X86_64
>> -	case X86_BREAKPOINT_LEN_8:
>> -		len_in_bytes = 8;
>> -		break;
>> -#endif
>> -	}
>> -	return len_in_bytes;
>> +	if (info->mask)
>> +		set_dr_addr_mask(0, i);
>>   }
>>   
>>   /*
>> @@ -198,7 +179,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
>>   	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>>   
>>   	va = info->address;
>> -	len = get_hbp_len(info->len);
>> +	len = bp->attr.bp_len;
> So we can access the attr directly instead of get_hbp_len(). Good, that's a welcome
> simplification but it's a change that is meaningful and tricky enough to deserve a seperate patch.
>
> Could you send a seperate one for that?

Sure, I can split the patch.

>>   	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
>>   }
>> @@ -279,7 +260,16 @@ static int arch_build_bp_info(struct perf_event *bp)
>>   	}
>>   
>>   	/* Len */
>> +	info->mask = 0;
>> +
>>   	switch (bp->attr.bp_len) {
>> +	default:
>> +		if (!is_power_of_2(bp->attr.bp_len))
>> +			return -EINVAL;
>> +		if (!cpu_has_bpext)
>> +			return -EOPNOTSUPP;
>> +		info->mask = bp->attr.bp_len - 1;
>> +		/* fall through */
> So, that's perhaps just personal preference but having the default on
> top of the switch makes things very confusing. Can't we put the above
> in the end of the switch instead?

Ok. I'll clean this up a bit to your preference.

>
>>   	case HW_BREAKPOINT_LEN_1:
>>   		info->len = X86_BREAKPOINT_LEN_1;
>>   		break;
>> @@ -294,12 +284,11 @@ static int arch_build_bp_info(struct perf_event *bp)
>>   		info->len = X86_BREAKPOINT_LEN_8;
>>   		break;
>>   #endif
>> -	default:
>> -		return -EINVAL;
>>   	}
>>   
>>   	return 0;
>>   }
>> +
>>   /*
>>    * Validate the arch-specific HW Breakpoint register settings
>>    */
>> @@ -314,11 +303,11 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
>>   	if (ret)
>>   		return ret;
>>   
>> -	ret = -EINVAL;
>> -
>>   	switch (info->len) {
>>   	case X86_BREAKPOINT_LEN_1:
>>   		align = 0;
>> +		if (info->mask)
>> +			align = info->mask;
> Confused, I thought mask is set only when length is above 8?
>
>>   		break;
>>   	case X86_BREAKPOINT_LEN_2:
>>   		align = 1;
>> @@ -332,7 +321,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
>>   		break;
>>   #endif
>>   	default:
>> -		return ret;
>> +		BUG();
> Please use WARN_ON_ONCE() instead.
>
> Thanks.

OK.

I'll send out soon.

Suravee

   


