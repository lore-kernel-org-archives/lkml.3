Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3KKE3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 23:29:32 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:33468 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3KKE3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 23:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131108170448.GF15074@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-5-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108170448.GF15074@mudshark.cambridge.arm.com>
Date: Mon, 11 Nov 2013 09:59:22 +0530
Message-ID: <CA+b37P2aeXs4Cy_HxF24HQAYAnYzZ19PgV6rqrQLY9SMpZHDJg@mail.gmail.com>
Subject: Re: [PATCH RFC 4/6] arm64: Add kernel return probes support(kretprobes)
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 22:34, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Oct 17, 2013 at 12:17:49PM +0100, Sandeepa Prabhu wrote:
>> AArch64 ISA does not instructions to pop PC register value
>> from stack(like ARM v7 has ldmia {...,pc}) without using
>> one of the general purpose registers. This means return probes
>> cannot return to the actual return address directly without
>> modifying register context, and without trapping into debug exception.
>>
>> So like many other architectures, we prepare a global routine
>> with NOPs, which serve as trampoline to hack away the
>> function return address, by placing an extra kprobe on the
>> trampoline entry.
>>
>> The pre-handler of this special trampoline' kprobe execute return
>> probe handler functions and restore original return address in ELR_EL1,
>> this way, saved pt_regs still hold the original register context to be
>> carried back to the probed kernel function.
>>
>> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>> ---
>>  arch/arm64/Kconfig               |   1 +
>>  arch/arm64/include/asm/kprobes.h |   1 +
>>  arch/arm64/include/asm/ptrace.h  |   5 ++
>>  arch/arm64/kernel/kprobes.c      | 125 ++++++++++++++++++++++++++++++++++++++-
>>  4 files changed, 129 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 2e89059..73eff55 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -28,6 +28,7 @@ config ARM64
>>       select HAVE_MEMBLOCK
>>       select HAVE_PERF_EVENTS
>>       select HAVE_KPROBES if !XIP_KERNEL
>> +     select HAVE_KRETPROBES if (HAVE_KPROBES)
>
> Don't need the brackets.
OK.
>
>>       select IRQ_DOMAIN
>>       select MODULES_USE_ELF_RELA
>>       select NO_BOOTMEM
>> diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
>> index 9b491d0..eaca849 100644
>> --- a/arch/arm64/include/asm/kprobes.h
>> +++ b/arch/arm64/include/asm/kprobes.h
>> @@ -55,5 +55,6 @@ void arch_remove_kprobe(struct kprobe *);
>>  int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
>>  int kprobe_exceptions_notify(struct notifier_block *self,
>>                            unsigned long val, void *data);
>> +void kretprobe_trampoline(void);
>>
>>  #endif /* _ARM_KPROBES_H */
>> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
>> index 89f1727..58b2589 100644
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -166,6 +166,11 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
>>  #define instruction_pointer(regs)    (regs)->pc
>>  #define stack_pointer(regs)          ((regs)->sp)
>>
>> +static inline long regs_return_value(struct pt_regs *regs)
>> +{
>> +     return regs->regs[0];
>> +}
>
> This is also being implemented by another patch series (I think the audit
> stuff?).
Not sure, I did not see this being implemented in audit(audit adds for
'syscallno',  not for return value in x0)
I can rebase my code if this change is implemented and queued in other patchset.

>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
