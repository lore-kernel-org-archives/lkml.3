Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbbAOHHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:07:18 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45278 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbAOHHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:07:16 -0500
Message-ID: <54B7671A.7090600@hitachi.com>
Date: Thu, 15 Jan 2015 16:07:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org> <1420949002-3726-2-git-send-email-dave.long@linaro.org> <20150112125138.GA24728@linaro.org>
In-Reply-To: <20150112125138.GA24728@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/12 21:51), Steve Capper wrote:
> On Sat, Jan 10, 2015 at 11:03:16PM -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Add HAVE_REGS_AND_STACK_ACCESS_API feature for arm64.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>  arch/arm64/Kconfig                   |   1 +
>>  arch/arm64/include/asm/ptrace.h      |  29 +++++++++
>>  arch/arm64/include/uapi/asm/ptrace.h |  36 +++++++++++
>>  arch/arm64/kernel/ptrace.c           | 119 +++++++++++++++++++++++++++++++++++
>>  4 files changed, 185 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b1f9a20..12b3fd6 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -64,6 +64,7 @@ config ARM64
>>  	select HAVE_PERF_EVENTS
>>  	select HAVE_PERF_REGS
>>  	select HAVE_PERF_USER_STACK_DUMP
>> +	select HAVE_REGS_AND_STACK_ACCESS_API
>>  	select HAVE_RCU_TABLE_FREE
>>  	select HAVE_SYSCALL_TRACEPOINTS
>>  	select IRQ_DOMAIN
>> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
>> index 41ed9e1..3613e49 100644
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -111,6 +111,8 @@ struct pt_regs {
>>  	u64 syscallno;
>>  };
>>  
>> +#define MAX_REG_OFFSET (sizeof(struct user_pt_regs) - sizeof(u64))
>> +
>>  #define arch_has_single_step()	(1)
>>  
>>  #ifdef CONFIG_COMPAT
>> @@ -139,11 +141,38 @@ struct pt_regs {
>>  #define user_stack_pointer(regs) \
>>  	(!compat_user_mode(regs) ? (regs)->sp : (regs)->compat_sp)
>>  
>> +/**
>> + * regs_get_register() - get register value from its offset
>> + * @regs:	   pt_regs from which register value is gotten
>> + * @offset:    offset number of the register.
>> + *
>> + * regs_get_register returns the value of a register whose offset from @regs.
>> + * The @offset is the offset of the register in struct pt_regs.
>> + * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
>> + */
>> +static inline u64 regs_get_register(struct pt_regs *regs,
>> +					      unsigned int offset)
>> +{
>> +	if (unlikely(offset > MAX_REG_OFFSET))
>> +		return 0;
>> +	return *(u64 *)((u64)regs + offset);
>> +}
>> +
>> +/* Valid only for Kernel mode traps. */
>> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
>> +{
>> +	return regs->ARM_sp;
>> +}
>> +
>>  static inline unsigned long regs_return_value(struct pt_regs *regs)
>>  {
>>  	return regs->regs[0];
>>  }
>>  
>> +extern int regs_query_register_offset(const char *name);
>> +extern unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
>> +					       unsigned int n);
>> +
>>  /*
>>   * Are the current registers suitable for user mode? (used to maintain
>>   * security in signal handlers)
>> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
>> index 6913643..700d28b 100644
>> --- a/arch/arm64/include/uapi/asm/ptrace.h
>> +++ b/arch/arm64/include/uapi/asm/ptrace.h
>> @@ -61,6 +61,42 @@
>>  
>>  #ifndef __ASSEMBLY__
>>  
>> +#define ARM_cpsr	pstate
>> +#define ARM_pc		pc
>> +#define ARM_sp		sp
>> +#define ARM_lr		regs[30]
>> +#define ARM_fp		regs[29]
>> +#define ARM_x28		regs[28]
>> +#define ARM_x27		regs[27]
>> +#define ARM_x26		regs[26]
>> +#define ARM_x25		regs[25]
>> +#define ARM_x24		regs[24]
>> +#define ARM_x23		regs[23]
>> +#define ARM_x22		regs[22]
>> +#define ARM_x21		regs[21]
>> +#define ARM_x20		regs[20]
>> +#define ARM_x19		regs[19]
>> +#define ARM_x18		regs[18]
>> +#define ARM_ip1		regs[17]
>> +#define ARM_ip0		regs[16]
>> +#define ARM_x15		regs[15]
>> +#define ARM_x14		regs[14]
>> +#define ARM_x13		regs[13]
>> +#define ARM_x12		regs[12]
>> +#define ARM_x11		regs[11]
>> +#define ARM_x10		regs[10]
>> +#define ARM_x9		regs[9]
>> +#define ARM_x8		regs[8]
>> +#define ARM_x7		regs[7]
>> +#define ARM_x6		regs[6]
>> +#define ARM_x5		regs[5]
>> +#define ARM_x4		regs[4]
>> +#define ARM_x3		regs[3]
>> +#define ARM_x2		regs[2]
>> +#define ARM_x1		regs[1]
>> +#define ARM_x0		regs[0]
>> +#define ARM_ORIG_x0	orig_x0
>> +
>>  /*
>>   * User structures for general purpose, floating point and debug registers.
>>   */
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index d882b83..9115b25 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -48,6 +48,125 @@
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/syscalls.h>
>>  
>> +struct pt_regs_offset {
>> +	const char *name;
>> +	int offset;
>> +};
>> +
>> +#define REG_OFFSET_NAME(r) \
>> +	{.name = #r, .offset = offsetof(struct pt_regs, ARM_##r)}
>> +#define REG_OFFSET_END {.name = NULL, .offset = 0}
>> +
>> +static const struct pt_regs_offset regoffset_table[] = {
>> +	REG_OFFSET_NAME(x0),
>> +	REG_OFFSET_NAME(x1),
>> +	REG_OFFSET_NAME(x2),
>> +	REG_OFFSET_NAME(x3),
>> +	REG_OFFSET_NAME(x4),
>> +	REG_OFFSET_NAME(x5),
>> +	REG_OFFSET_NAME(x6),
>> +	REG_OFFSET_NAME(x7),
>> +	REG_OFFSET_NAME(x8),
>> +	REG_OFFSET_NAME(x9),
>> +	REG_OFFSET_NAME(x10),
>> +	REG_OFFSET_NAME(x11),
>> +	REG_OFFSET_NAME(x12),
>> +	REG_OFFSET_NAME(x13),
>> +	REG_OFFSET_NAME(x14),
>> +	REG_OFFSET_NAME(x15),
>> +	REG_OFFSET_NAME(ip0),
>> +	REG_OFFSET_NAME(ip1),
>> +	REG_OFFSET_NAME(x18),
>> +	REG_OFFSET_NAME(x19),
>> +	REG_OFFSET_NAME(x20),
>> +	REG_OFFSET_NAME(x21),
>> +	REG_OFFSET_NAME(x22),
>> +	REG_OFFSET_NAME(x23),
>> +	REG_OFFSET_NAME(x24),
>> +	REG_OFFSET_NAME(x25),
>> +	REG_OFFSET_NAME(x26),
>> +	REG_OFFSET_NAME(x27),
>> +	REG_OFFSET_NAME(x28),
>> +	REG_OFFSET_NAME(fp),
>> +	REG_OFFSET_NAME(lr),
>> +/*
>> +	REG_OFFSET_NAME(ip),
>> +*/
> 
> Should this comment block be removed?

Agreed, I think it should be removed.
Except that, this looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
>> +	REG_OFFSET_NAME(sp),
>> +	REG_OFFSET_NAME(pc),
>> +	REG_OFFSET_NAME(cpsr),
>> +	REG_OFFSET_NAME(ORIG_x0),
>> +	REG_OFFSET_END,
>> +};
>> +
>> +/**
>> + * regs_query_register_offset() - query register offset from its name
>> + * @name:	the name of a register
>> + *
>> + * regs_query_register_offset() returns the offset of a register in struct
>> + * pt_regs from its name. If the name is invalid, this returns -EINVAL;
>> + */
>> +int regs_query_register_offset(const char *name)
>> +{
>> +	const struct pt_regs_offset *roff;
>> +
>> +	for (roff = regoffset_table; roff->name != NULL; roff++)
>> +		if (!strcmp(roff->name, name))
>> +			return roff->offset;
>> +	return -EINVAL;
>> +}
>> +
>> +/**
>> + * regs_query_register_name() - query register name from its offset
>> + * @offset:	the offset of a register in struct pt_regs.
>> + *
>> + * regs_query_register_name() returns the name of a register from its
>> + * offset in struct pt_regs. If the @offset is invalid, this returns NULL;
>> + */
>> +const char *regs_query_register_name(unsigned int offset)
>> +{
>> +	const struct pt_regs_offset *roff;
>> +
>> +	for (roff = regoffset_table; roff->name != NULL; roff++)
>> +		if (roff->offset == offset)
>> +			return roff->name;
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * regs_within_kernel_stack() - check the address in the stack
>> + * @regs:      pt_regs which contains kernel stack pointer.
>> + * @addr:      address which is checked.
>> + *
>> + * regs_within_kernel_stack() checks @addr is within the kernel stack page(s).
>> + * If @addr is within the kernel stack, it returns true. If not, returns false.
>> + */
>> +bool regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
>> +{
>> +	return ((addr & ~(THREAD_SIZE - 1))  ==
>> +		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1)));
>> +}
>> +
>> +/**
>> + * regs_get_kernel_stack_nth() - get Nth entry of the stack
>> + * @regs:	pt_regs which contains kernel stack pointer.
>> + * @n:		stack entry number.
>> + *
>> + * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
>> + * is specified by @regs. If the @n th entry is NOT in the kernel stack,
>> + * this returns 0.
>> + */
>> +unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n)
>> +{
>> +	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
>> +
>> +	addr += n;
>> +	if (regs_within_kernel_stack(regs, (unsigned long)addr))
>> +		return *addr;
>> +	else
>> +		return 0;
>> +}
>> +
>>  /*
>>   * TODO: does not yet catch signals sent when the child dies.
>>   * in exit.c or in signal.c.
>> -- 
>> 1.8.1.2
>>
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


