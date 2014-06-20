Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231AbaFTRgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:36:38 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46071 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935197AbaFTRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140620172330.GA30656@arm.com>
References: <20140618202748.GA9022@www.outflux.net>
	<20140620102258.GA26626@arm.com>
	<CAGXu5jKJ07bXw_K+7uSAf=H_SDoeoaWPxS4rwuonbR71Svwwmw@mail.gmail.com>
	<20140620172330.GA30656@arm.com>
Date: Fri, 20 Jun 2014 10:36:35 -0700
X-Google-Sender-Auth: Hjmf4IulE2-Q4nuoulJ6dy2ZjQU
Message-ID: <CAGXu5jKg0didhwZTUq8AbMnwD=RV=EaWiZWBWuar625JXGnL6w@mail.gmail.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under PTRACE_O_TRACESECCOMP
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        =?UTF-8?Q?Andr=C3=A9_Hentschel?= <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:23 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Jun 20, 2014 at 05:44:52PM +0100, Kees Cook wrote:
>> On Fri, Jun 20, 2014 at 3:22 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > I'm struggling to see the bug in the current code, so apologies if my
>> > questions aren't helpful.
>> >
>> > On Wed, Jun 18, 2014 at 09:27:48PM +0100, Kees Cook wrote:
>> >> An x86 tracer wanting to change the syscall uses PTRACE_SETREGS
>> >> (stored to regs->orig_ax), and an ARM tracer uses PTRACE_SET_SYSCALL
>> >> (stored to current_thread_info()->syscall). When this happens, the
>> >> syscall can change across the call to secure_computing(), since it may
>> >> block on tracer notification, and the tracer can then make changes
>> >> to the process, before we return from secure_computing(). This
>> >> means the code must respect the changed syscall after the
>> >> secure_computing() call in syscall_trace_enter(). The same is true
>> >> for tracehook_report_syscall_entry() which may also block and change
>> >> the syscall.
>> >
>> > I don't think I understand what you mean by `the code must respect the
>> > changed syscall'. The current code does indeed issue the new syscall, so are
>> > you more concerned with secure_computing changing ->syscall, then the
>> > debugger can't see the new syscall when it sees the trap from tracehook?
>> > Are these even supposed to inter-operate?
>>
>> The problem is the use of "scno" in the call -- it results in ignoring
>> the value that may be set up in ->syscall by a tracer:
>>
>> syscall_trace_enter(regs, scno):
>>     current_thread_info()->syscall = scno;
>>     secure_computing(scno):
>>         [block on ptrace]
>>         [ptracer changes current_thread_info()->syscall vis PTRACE_SET_SYSCALL]
>>     ...
>>     return scno;
>>
>> This means the tracer's changed syscall value will be ignored
>> (syscall_trace_enter returns original "scno" instead of actual
>> current_thread_info()->syscall). In the original code, failure cases
>> were propagated correctly, but not tracer-induced changes.
>>
>> Is that more clear? It's not an obvious state (due to the external
>> modification of process state during the ptrace blocking). I've also
>> got tests for this, if that's useful to further illustrate:
>>
>> https://github.com/kees/seccomp/commit/bd24e174593f79784b97178b583f17e0ea9d2aa7
>
> Right, gotcha. Thanks for the explanation. I was confused, because
> tracehook_report_syscall does the right thing (returns
> current_thread_info()->syscall), but if we don't have TIF_SYSCALL_TRACE set,
> then updates during the secure_computing callback will be ignored.
>
> However, my fix to this is significantly smaller than your patch, so I fear
> I'm still missing something.

Oh, yes, that's much smaller. Nice! I will test this and report back.

>
> Will
>
> --->8
>
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 0dd3b79b15c3..0c27ed6f3f23 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -908,7 +908,7 @@ enum ptrace_syscall_dir {
>         PTRACE_SYSCALL_EXIT,
>  };
>
> -static int tracehook_report_syscall(struct pt_regs *regs,
> +static void tracehook_report_syscall(struct pt_regs *regs,
>                                     enum ptrace_syscall_dir dir)
>  {
>         unsigned long ip;
> @@ -926,7 +926,6 @@ static int tracehook_report_syscall(struct pt_regs *regs,
>                 current_thread_info()->syscall = -1;
>
>         regs->ARM_ip = ip;
> -       return current_thread_info()->syscall;
>  }
>
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
> @@ -938,7 +937,9 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>                 return -1;
>
>         if (test_thread_flag(TIF_SYSCALL_TRACE))
> -               scno = tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
> +               tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
> +
> +       scno = current_thread_info()->syscall;

Perhaps it'd be worth adding a comment above this line just for people
looking at this in the future. Something like:

/* secure_computing and tracehook_report_syscall may have changed syscall */

-Kees

>
>         if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>                 trace_sys_enter(regs, scno);



-- 
Kees Cook
Chrome OS Security
