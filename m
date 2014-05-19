Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaESP61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:58:27 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39633 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaESP6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140519153915.GI15130@arm.com>
References: <1400252476-20128-1-git-send-email-jean.pihet@linaro.org>
	<20140519153915.GI15130@arm.com>
Date: Mon, 19 May 2014 17:58:23 +0200
Message-ID: <CAFrcx1n-cPXm=w+84gQiUjZoFKi7gYnvJ0BQ+8yXKS=k3nEt3g@mail.gmail.com>
Subject: Re: [PATCH] [RFC] ARM: perf: allow tracing with kernel tracepoints events
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 19 May 2014 17:39, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> On Fri, May 16, 2014 at 04:01:16PM +0100, Jean Pihet wrote:
>> When tracing with tracepoints events the IP and CPSR are set to 0,
>> preventing the perf code to resolve the symbols:
>>
>> ./perf record -e kmem:kmalloc cal
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.007 MB perf.data (~321 samples) ]
>>
>> ./perf report
>> Overhead Command Shared Object Symbol
>> ........ ....... ............. ...........
>> 40.78%   cal     [unknown]     [.]00000000
>> 31.6%    cal     [unknown]     [.]00000000
>>
>> The examination of the gathered samples (perf report -D) shows the IP
>> is set to 0 and that the samples are considered as user space samples,
>> while the IP should be set from the registers and the samples should be
>> considered as kernel samples.
>>
>> The fix is to implement perf_arch_fetch_caller_regs for ARM, which
>> fills the necessary registers: ip, lr, sp and cpsr (used to check
>> the user mode property of the samples).
>>
>> Heavily inspired from arch/arm/include/asm/kexec.h.
>>
>> Reported by Sneha Priya on linaro-dev, cf.
>> http://lists.linaro.org/pipermail/linaro-dev/2014-May/017151.html
>>
>> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Reported-by: Sneha Priya <sneha.cse@hotmail.com>
>> ---
>>  arch/arm/include/asm/perf_event.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
>> index 7558775..d466e39 100644
>> --- a/arch/arm/include/asm/perf_event.h
>> +++ b/arch/arm/include/asm/perf_event.h
>> @@ -26,6 +26,19 @@ struct pt_regs;
>>  extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>>  extern unsigned long perf_misc_flags(struct pt_regs *regs);
>>  #define perf_misc_flags(regs)        perf_misc_flags(regs)
>> +
>> +#define perf_arch_fetch_caller_regs(regs, __ip) {    \
>> +     instruction_pointer(regs)= (__ip);              \
>> +     __asm__ __volatile__ (                          \
>> +             "mov    %[_ARM_sp], sp\n\t"             \
>> +             "str    lr, %[_ARM_lr]\n\t"             \
>> +             "mrs    %[_ARM_cpsr], cpsr\n\t"         \
>> +             : [_ARM_cpsr] "=r" (regs->ARM_cpsr),    \
>> +               [_ARM_sp] "=r" (regs->ARM_sp),        \
>> +               [_ARM_lr] "=o" (regs->ARM_lr)         \
>> +             : : "memory"                            \
>> +     );                                              \
>> +}
>
> Why do we need to save lr? If it's for unwinding, what about fp? Also, why
> do you have a "memory" clobber and why is this block marked volatile?
These are all valid questions, hence the RFC state of the patch.

Here is the comment about the marco from include/linux/perf_event.h:
/*
 * Take a snapshot of the regs. Skip ip and frame pointer to
 * the nth caller. We only need a few of the regs:
 * - ip for PERF_SAMPLE_IP
 * - cs for user_mode() tests
 * - bp for callchains
 * - eflags, for future purposes, just in case
 */
static inline void perf_fetch_caller_regs(struct pt_regs *regs)
...

So, is it OK to provide a version that saves ip, cpsr (for
user_mode()), lr and fp (for callchain)?

The clobber and volatile are from my copy/paste from the kexec code.
The memory clobber is there because we are touching the regs struct in
memory. Just tell me if those are overkill, I will remove them.

Thanks for reviewing,
Jean

>
> Will
