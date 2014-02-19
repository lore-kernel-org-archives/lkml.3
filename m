Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaBSKtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:49:09 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62926 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaBSKtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:49:07 -0500
Message-ID: <53048C19.6040509@linaro.org>
Date: Wed, 19 Feb 2014 19:48:57 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3 5/6] arm64: ftrace: Add system call tracepoint
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org> <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org> <1391768336-5642-6-git-send-email-takahiro.akashi@linaro.org> <20140217192936.GH26590@mudshark.cambridge.arm.com>
In-Reply-To: <20140217192936.GH26590@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:29 AM, Will Deacon wrote:
> On Fri, Feb 07, 2014 at 10:18:55AM +0000, AKASHI Takahiro wrote:
>> This patch allows system call entry or exit to be traced as ftrace events,
>> ie. sys_enter_*/sys_exit_*, if CONFIG_FTRACE_SYSCALLS is enabled.
>> Those events appear and can be controlled under
>>      ${sysfs}/tracing/events/syscalls/
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/Kconfig               |    1 +
>>   arch/arm64/include/asm/syscall.h |    1 +
>>   arch/arm64/include/asm/unistd.h  |    2 ++
>>   arch/arm64/kernel/ptrace.c       |    5 +++++
>>   4 files changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 43fce76..9bdaf5c 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -42,6 +42,7 @@ config ARM64
>>   	select HAVE_HW_BREAKPOINT if PERF_EVENTS
>>   	select HAVE_MEMBLOCK
>>   	select HAVE_PERF_EVENTS
>> +	select HAVE_SYSCALL_TRACEPOINTS
>>   	select IRQ_DOMAIN
>>   	select MODULES_USE_ELF_RELA
>>   	select NO_BOOTMEM
>> diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
>> index 70ba9d4..383771e 100644
>> --- a/arch/arm64/include/asm/syscall.h
>> +++ b/arch/arm64/include/asm/syscall.h
>> @@ -18,6 +18,7 @@
>>
>>   #include <linux/err.h>
>>
>> +extern const void *sys_call_table[];
>>
>>   static inline int syscall_get_nr(struct task_struct *task,
>>   				 struct pt_regs *regs)
>> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
>> index 82ce217..c335479 100644
>> --- a/arch/arm64/include/asm/unistd.h
>> +++ b/arch/arm64/include/asm/unistd.h
>> @@ -28,3 +28,5 @@
>>   #endif
>>   #define __ARCH_WANT_SYS_CLONE
>>   #include <uapi/asm/unistd.h>
>> +
>> +#define NR_syscalls (__NR_syscalls)
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 64ce39f..f4c3c4e 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -41,6 +41,9 @@
>>   #include <asm/traps.h>
>>   #include <asm/system_misc.h>
>>
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/syscalls.h>
>> +
>>   /*
>>    * TODO: does not yet catch signals sent when the child dies.
>>    * in exit.c or in signal.c.
>> @@ -1076,10 +1079,12 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>   	}
>>
>>   	if (dir) {
>> +		trace_sys_exit(regs, regs->syscallno);
>>   		tracehook_report_syscall_exit(regs, 0);
>>   	} else {
>>   		if (tracehook_report_syscall_entry(regs))
>>   			regs->syscallno = ~0UL;
>> +		trace_sys_enter(regs, regs->syscallno);
>
> Shouldn't these calls be guarded by a TIF_SYSCALL_TRACEPOINT check?

Yes. I will add the guard.

-Takahiro AKASHI

> Will
>
