Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaBSLx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:53:27 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42017 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaBSLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:53:25 -0500
Message-ID: <53049B2C.6070105@linaro.org>
Date: Wed, 19 Feb 2014 20:53:16 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] arm64: make a single hook to syscall_trace() for all
 syscall features
References: <52F199D3.2060409@linaro.org> <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org> <20140217173522.GD26590@mudshark.cambridge.arm.com>
In-Reply-To: <20140217173522.GD26590@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/18/2014 02:35 AM, Will Deacon wrote:
> On Fri, Feb 07, 2014 at 10:07:31AM +0000, AKASHI Takahiro wrote:
>> Currently syscall_trace() is called only for ptrace.
>> With additional TIF_xx flags introduced, it is now called in all the cases
>> of audit, ftrace and seccomp in addition to ptrace.
>> Those features will be implemented later, but it's safe to include them
>> now because they can not be turned on anyway.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/include/asm/thread_info.h |   13 +++++++++++++
>>   arch/arm64/kernel/entry.S            |    5 +++--
>>   arch/arm64/kernel/ptrace.c           |   11 +++++------
>>   3 files changed, 21 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
>> index 720e70b..c3df797 100644
>> --- a/arch/arm64/include/asm/thread_info.h
>> +++ b/arch/arm64/include/asm/thread_info.h
>
> [...]
>
>> +#define _TIF_WORK_SYSCALL	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
>> +				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
>
> This is called _TIF_SYSCALL_WORK on arch/arm/, any reason not to follow the
> naming convention here?

This is called _TIF_WORK_SYSCALL on arch/x86 :-)
That is the only reason, and so I don't have any objection to following arm
if you prefer it.

>>   #endif /* __KERNEL__ */
>>   #endif /* __ASM_THREAD_INFO_H */
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 39ac630..c94b2ab 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -631,8 +631,9 @@ el0_svc_naked:					// compat entry point
>>   	enable_irq
>>
>>   	get_thread_info tsk
>> -	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
>> -	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
>> +	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall hooks
>> +	tst	x16, #_TIF_WORK_SYSCALL
>> +	b.ne	__sys_trace
>>   	adr	lr, ret_fast_syscall		// return address
>>   	cmp     scno, sc_nr                     // check upper syscall limit
>>   	b.hs	ni_sys
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 6a8928b..64ce39f 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -1062,9 +1062,6 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>   {
>>   	unsigned long saved_reg;
>>
>> -	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>> -		return regs->syscallno;
>
> This doesn't look right for things like audit (where we don't want to report
> the syscall if only _TIF_SYSCALL_AUDIT is set, for example).

Yeah, it is my screwup.
I will add the guards against TIF_SYSCALL_TRACE (for ptrace),
TIF_SYSCALL_TRACEPOINT (for ftrace) and TIF_SYSCALL_AUDIT (for audit).

secure_computing() is protected in itself.

>>   	if (is_compat_task()) {
>>   		/* AArch32 uses ip (r12) for scratch */
>>   		saved_reg = regs->regs[12];
>> @@ -1078,10 +1075,12 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>   		regs->regs[7] = dir;
>>   	}
>>
>> -	if (dir)
>> +	if (dir) {
>>   		tracehook_report_syscall_exit(regs, 0);
>> -	else if (tracehook_report_syscall_entry(regs))
>> -		regs->syscallno = ~0UL;
>> +	} else {
>> +		if (tracehook_report_syscall_entry(regs))
>> +			regs->syscallno = ~0UL;
>> +	}
>
> This hunk doesn't do anything.

Well, this is just a change for future patches, but
I will remove it anyway due to the guards mentioned above.

-Takahiro AKASHI

> Will
>
