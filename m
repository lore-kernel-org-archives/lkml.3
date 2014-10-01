Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaJATCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:02:05 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36669 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaJATCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <1412160357-11324-1-git-send-email-takahiro.akashi@linaro.org>
References: <1412160357-11324-1-git-send-email-takahiro.akashi@linaro.org>
Date: Wed, 1 Oct 2014 12:02:00 -0700
X-Google-Sender-Auth: whX6R2alFMopm-sl3dVaaw28_pw
Message-ID: <CAGXu5j+s7YLDfLC_9LjWbXQVwi2XnQ=sZAcHa+j6SefNC85xZw@mail.gmail.com>
Subject: Re: [PATCH v2] arm: prevent BUG_ON in audit_syscall_entry()
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, broonie@linaro.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 3:45 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> BUG_ON() in audit_syscall_entry() is hit under the following conditions:
>   1) syscall auditing is enabled (that is, by running auditd).
>   2) user process issues syscall(-1)
> In fact, syscall(-1) just fails (not raising SIGILL, that is an expected
> behavior if not audited), and the succeeding syscall will hit this BUG_ON.

Thanks for digging in to this!

>
> ------------[ cut here ]------------
> kernel BUG at (...)/kernel/auditsc.c:1534!
> Internal error: Oops - BUG: 0 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 61 Comm: syscall_arm Not tainted 3.17.0-rc4 #60
> task: ea0c4380 ti: ea48e000 task.ti: ea48e000
> PC is at __audit_syscall_entry+0xe4/0x110
> LR is at 0xea0c4380
> pc : [<c02b2ae8>]    lr : [<ea0c4380>]    psr: 20000013
> sp : ea48ff68  ip : 00000001  fp : 0000869c
> r10: 00000200  r9 : ea48e000  r8 : c020f4e4
> r7 : 000000c5  r6 : ea48e000  r5 : ea48ffb0  r4 : ea490800
> r3 : bef1e718  r2 : 00000001  r1 : 000000c5  r0 : 40000028
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c5387d  Table: 8a4ac059  DAC: 00000015
> Process syscall_arm (pid: 61, stack limit = 0xea48e250)
> Stack: (0xea48ff68 to 0xea490000)
> ff60:                   540e7a69 3ab5e840 00000200 000000c5 ea48ffb0 ea48e000
> ff80: 000000c5 c02114bc bef1e718 00000001 b6efdb58 ffffffff 08400000 000000c5
> ffa0: c020f4e4 c020f49c b6efdb58 ffffffff 00000001 bef1e718 bef1e718 00000001
> ffc0: b6efdb58 ffffffff 08400000 000000c5 00000000 b6f22850 00000008 0000869c
> ffe0: 000000c5 bef1e704 b6ea315f b6e318e6 20000030 00000001 00000000 00000000
> [<c02b2ae8>] (__audit_syscall_entry) from [<c02114bc>] (syscall_trace_enter+0xf0/0x120)
> [<c02114bc>] (syscall_trace_enter) from [<c020f49c>] (__sys_trace+0xc/0x38)
> Code: e584500c e5842004 e28dd00c e8bd80f0 (e7f001f2)
> ---[ end trace 0c4441660aba5692 ]---
>
> Under the current implementation, audit_syscall_entry() is called even
> against syscall(-1), but audit_syscall_exit() is not. Because 'in_syscall'
> flag in a current thread's audit context is kept on, next called
> audit_syscall_entry() will see BUG_ON(in_syscall).
>
> This patch fixes this bug by
>   1) preventing syscall enter/exit tracing, ftrace tracepoint and audit,
>      from being executed if an invalid (including -1) or pseudo syscall
>      number (starting from __NR_ARM_BASE + 1).
>      Please note that tracehook_report_syscall(PTRACE_SYSCALL_EXIT) is
>      still executed as it should be paired with
>      tracehook_report_syscall(PTRACE_SYSCALL_ENTER).
>
>   2) handling user-issued syscall(-1) with arm_syscall() for compatibility
>      if tracing is on.
>      Since UL(-1) > __NR_ARM_BASE - __NR_SYSCALL_BASE, arm_syscall() is
>      called at local_restart in entry-common.S if tracing is off.
>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm/include/asm/traps.h   |    1 +
>  arch/arm/kernel/entry-common.S |    3 ++-
>  arch/arm/kernel/ptrace.c       |   49 +++++++++++++++++++++++++---------------
>  3 files changed, 34 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm/include/asm/traps.h b/arch/arm/include/asm/traps.h
> index f555bb3..de01145 100644
> --- a/arch/arm/include/asm/traps.h
> +++ b/arch/arm/include/asm/traps.h
> @@ -49,6 +49,7 @@ static inline int in_exception_text(unsigned long ptr)
>  extern void __init early_trap_init(void *);
>  extern void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame);
>  extern void ptrace_break(struct task_struct *tsk, struct pt_regs *regs);
> +extern int arm_syscall(int no, struct pt_regs *regs);
>
>  extern void *vectors_page;
>
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index e52fe5a..4c62324 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -476,10 +476,11 @@ __sys_trace:
>         cmp     scno, #-1                       @ skip the syscall?
>         bne     2b
>         add     sp, sp, #S_OFF                  @ restore stack
> -       b       ret_slow_syscall
> +       b       __sys_trace_return_skipped
>
>  __sys_trace_return:
>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
> +__sys_trace_return_skipped:
>         mov     r0, sp
>         bl      syscall_trace_exit
>         b       ret_slow_syscall
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 0c27ed6..d458367 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -930,7 +930,9 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  {
> -       current_thread_info()->syscall = scno;
> +       int orig_scno;
> +
> +       current_thread_info()->syscall = orig_scno = scno;
>
>         /* Do the secure computing check first; failures should be fast. */
>         if (secure_computing(scno) == -1)
> @@ -941,31 +943,42 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>
>         scno = current_thread_info()->syscall;
>
> -       if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> -               trace_sys_enter(regs, scno);
> +       if (scno >= 0 && scno < NR_syscalls) {
> +               if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> +                       trace_sys_enter(regs, scno);
>
> -       audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
> -                           regs->ARM_r2, regs->ARM_r3);
> +               audit_syscall_entry(AUDIT_ARCH_ARM, scno,
> +                                   regs->ARM_r0, regs->ARM_r1,
> +                                   regs->ARM_r2, regs->ARM_r3);
> +       } else if (scno == -1 && orig_scno == -1) {
> +               /*
> +                * For compatibility, we handles user-issued syscall(-1)
> +                * here with arm_syscall().
> +                */
> +               arm_syscall(scno, regs);

Won't this always land in bad_syscall(-1, regs) during arm_syscall?
Should syscall_trace-enter just call bad_syscall directly instead, or
are you using arm_syscall since it's the common entry point for this
kind of logic on "non-standard" syscalls?

Either way, this look good! Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> +       }
>
>         return scno;
>  }
>
>  asmlinkage void syscall_trace_exit(struct pt_regs *regs)
>  {
> -       /*
> -        * Audit the syscall before anything else, as a debugger may
> -        * come in and change the current registers.
> -        */
> -       audit_syscall_exit(regs);
> +       if (current_thread_info()->syscall < NR_syscalls) {
> +               /*
> +                * Audit the syscall before anything else, as a debugger may
> +                * come in and change the current registers.
> +                */
> +               audit_syscall_exit(regs);
>
> -       /*
> -        * Note that we haven't updated the ->syscall field for the
> -        * current thread. This isn't a problem because it will have
> -        * been set on syscall entry and there hasn't been an opportunity
> -        * for a PTRACE_SET_SYSCALL since then.
> -        */
> -       if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> -               trace_sys_exit(regs, regs_return_value(regs));
> +               /*
> +                * Note that we haven't updated the ->syscall field for the
> +                * current thread. This isn't a problem because it will have
> +                * been set on syscall entry and there hasn't been
> +                * an opportunity for a PTRACE_SET_SYSCALL since then.
> +                */
> +               if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> +                       trace_sys_exit(regs, regs_return_value(regs));
> +       }
>
>         if (test_thread_flag(TIF_SYSCALL_TRACE))
>                 tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
