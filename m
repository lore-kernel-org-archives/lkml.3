Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaBEByj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:54:39 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35081 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaBEByh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:54:37 -0500
Message-ID: <52F199D3.2060409@linaro.org>
Date: Wed, 05 Feb 2014 10:54:27 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
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
Subject: Re: [PATCH v3 3/3] arm64: audit: Add audit hook in ptrace/syscall_trace
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org> <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org> <1391410590-4884-4-git-send-email-takahiro.akashi@linaro.org> <20140204173133.GG664@mudshark.cambridge.arm.com>
In-Reply-To: <20140204173133.GG664@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 02:31 AM, Will Deacon wrote:
> On Mon, Feb 03, 2014 at 06:56:30AM +0000, AKASHI Takahiro wrote:
>> This patch adds auditing functions on entry to or exit from
>> every system call invocation.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/include/asm/thread_info.h |    1 +
>>   arch/arm64/kernel/entry.S            |    3 +++
>>   arch/arm64/kernel/ptrace.c           |   10 ++++++++++
>>   3 files changed, 14 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
>> index 720e70b..7468388 100644
>> --- a/arch/arm64/include/asm/thread_info.h
>> +++ b/arch/arm64/include/asm/thread_info.h
>> @@ -101,6 +101,7 @@ static inline struct thread_info *current_thread_info(void)
>>   #define TIF_NEED_RESCHED	1
>>   #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>>   #define TIF_SYSCALL_TRACE	8
>> +#define TIF_SYSCALL_AUDIT	9
>>   #define TIF_POLLING_NRFLAG	16
>>   #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
>>   #define TIF_FREEZE		19
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 827cbad..83c4b29 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -630,6 +630,9 @@ el0_svc_naked:					// compat entry point
>>   	get_thread_info tsk
>>   	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
>>   	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
>> +#ifdef CONFIG_AUDITSYSCALL
>> +	tbnz	x16, #TIF_SYSCALL_AUDIT, __sys_trace // auditing syscalls?
>> +#endif
>
> Could we avoid the back-to-back tbnz instructions with a single mask? It's
> not obvious that it will end up any better, but it would be good to know.

When first implementing ftrace support, TIF_SYSCALL_TRACEPOINT is defined as 10
and 'tst' instruction doesn't allow the following code:
     tst x16, #(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_TRACEPOINT)

That is why I've used "back-to-back" tbnz since then, but now that I'm going to
submit ftrace, audit and later seccomp, I will replace it with:
     #define TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE|TRACEPOINT|AUDIT|SECCOMP)

     tst x16, #TIF_SYSCALL_WORK
     b.ne __syscall_trace


>>   	adr	lr, ret_fast_syscall		// return address
>>   	cmp     scno, sc_nr                     // check upper syscall limit
>>   	b.hs	ni_sys
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 6777a21..75a3f23 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -19,6 +19,7 @@
>>    * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>    */
>>
>> +#include <linux/audit.h>
>>   #include <linux/kernel.h>
>>   #include <linux/sched.h>
>>   #include <linux/mm.h>
>> @@ -38,6 +39,7 @@
>>   #include <asm/compat.h>
>>   #include <asm/debug-monitors.h>
>>   #include <asm/pgtable.h>
>> +#include <asm/syscall.h>
>>   #include <asm/traps.h>
>>   #include <asm/system_misc.h>
>>
>> @@ -1064,6 +1066,14 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>   {
>>   	unsigned long saved_reg;
>>
>> +	if (dir)
>> +		audit_syscall_exit(regs);
>> +	else
>> +		audit_syscall_entry(syscall_get_arch(current, regs),
>> +			(int)regs->syscallno,
>> +			regs->orig_x0, regs->regs[1],
>> +			regs->regs[2], regs->regs[3]);
>> +
>
> Do we really want to perform the audit checks before the tracehook calls?
> Remember that the latter can rewrite all of the registers.

OK. I will change the code to make calls in the following order:
On entry,
    *secure_computing
    *tracehook_report_syscall(ENTER)
    *trace_sys_enter
    *audit_syscall_entry
On exit,
    *audit_syscall_exit
    *trace_sys_exit
    *tracehook_report_syscall(EXIT)

The order here is the exact same as on x86, but such change might
decrease the readability in syscall_trace().

Thanks,
-Takahiro AKASHI

> Will
>
