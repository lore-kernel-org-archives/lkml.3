Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaIZSCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:02:52 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64768 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaIZSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140924154737.50db90eb@canb.auug.org.au>
References: <20140924154737.50db90eb@canb.auug.org.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 26 Sep 2014 11:02:27 -0700
Message-ID: <CALCETrUFHZuhG5qHaJ3yi8P06hLYSo+76y5ZcqXwHahQSUZt-A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the audit tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/x86/kernel/ptrace.c between commit 91397401bb50 ("ARCH: AUDIT:
> audit_syscall_entry() should not require the arch") from the audit tree
> and commit e0ffbaabc46d ("x86: Split syscall_trace_enter into two
> phases") from the tip tree.
>
> I fixed it up (see below - there is more cleanup possible since
> do_audit_syscall_entry() no longer needs its "arch" argument) and can
> carry the fix as necessary (no action is required).

I don't think that more cleanup is possible after all.
do_audit_syscall_entry may not need to pass the arch parameter to the
audit code, but it still needs it to choose the set of registers to
use.

--Andy

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/x86/kernel/ptrace.c
> index eb1c87f0b03b,29576c244699..000000000000
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@@ -1441,24 -1441,126 +1441,126 @@@ void send_sigtrap(struct task_struct *t
>         force_sig_info(SIGTRAP, &info, tsk);
>   }
>
> -
> - #ifdef CONFIG_X86_32
> - # define IS_IA32      1
> - #elif defined CONFIG_IA32_EMULATION
> - # define IS_IA32      is_compat_task()
> - #else
> - # define IS_IA32      0
> + static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
> + {
> + #ifdef CONFIG_X86_64
> +       if (arch == AUDIT_ARCH_X86_64) {
>  -              audit_syscall_entry(arch, regs->orig_ax, regs->di,
> ++              audit_syscall_entry(regs->orig_ax, regs->di,
> +                                   regs->si, regs->dx, regs->r10);
> +       } else
>   #endif
> +       {
>  -              audit_syscall_entry(arch, regs->orig_ax, regs->bx,
> ++              audit_syscall_entry(regs->orig_ax, regs->bx,
> +                                   regs->cx, regs->dx, regs->si);
> +       }
> + }
>
>   /*
> -  * We must return the syscall number to actually look up in the table.
> -  * This can be -1L to skip running any syscall at all.
> +  * We can return 0 to resume the syscall or anything else to go to phase
> +  * 2.  If we resume the syscall, we need to put something appropriate in
> +  * regs->orig_ax.
> +  *
> +  * NB: We don't have full pt_regs here, but regs->orig_ax and regs->ax
> +  * are fully functional.
> +  *
> +  * For phase 2's benefit, our return value is:
> +  * 0:                 resume the syscall
> +  * 1:                 go to phase 2; no seccomp phase 2 needed
> +  * anything else:     go to phase 2; pass return value to seccomp
>    */
> - long syscall_trace_enter(struct pt_regs *regs)
> + unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
> + {
> +       unsigned long ret = 0;
> +       u32 work;
> +
> +       BUG_ON(regs != task_pt_regs(current));
> +
> +       work = ACCESS_ONCE(current_thread_info()->flags) &
> +               _TIF_WORK_SYSCALL_ENTRY;
> +
> +       /*
> +        * If TIF_NOHZ is set, we are required to call user_exit() before
> +        * doing anything that could touch RCU.
> +        */
> +       if (work & _TIF_NOHZ) {
> +               user_exit();
> +               work &= ~TIF_NOHZ;
> +       }
> +
> + #ifdef CONFIG_SECCOMP
> +       /*
> +        * Do seccomp first -- it should minimize exposure of other
> +        * code, and keeping seccomp fast is probably more valuable
> +        * than the rest of this.
> +        */
> +       if (work & _TIF_SECCOMP) {
> +               struct seccomp_data sd;
> +
> +               sd.arch = arch;
> +               sd.nr = regs->orig_ax;
> +               sd.instruction_pointer = regs->ip;
> + #ifdef CONFIG_X86_64
> +               if (arch == AUDIT_ARCH_X86_64) {
> +                       sd.args[0] = regs->di;
> +                       sd.args[1] = regs->si;
> +                       sd.args[2] = regs->dx;
> +                       sd.args[3] = regs->r10;
> +                       sd.args[4] = regs->r8;
> +                       sd.args[5] = regs->r9;
> +               } else
> + #endif
> +               {
> +                       sd.args[0] = regs->bx;
> +                       sd.args[1] = regs->cx;
> +                       sd.args[2] = regs->dx;
> +                       sd.args[3] = regs->si;
> +                       sd.args[4] = regs->di;
> +                       sd.args[5] = regs->bp;
> +               }
> +
> +               BUILD_BUG_ON(SECCOMP_PHASE1_OK != 0);
> +               BUILD_BUG_ON(SECCOMP_PHASE1_SKIP != 1);
> +
> +               ret = seccomp_phase1(&sd);
> +               if (ret == SECCOMP_PHASE1_SKIP) {
> +                       regs->orig_ax = -1;
> +                       ret = 0;
> +               } else if (ret != SECCOMP_PHASE1_OK) {
> +                       return ret;  /* Go directly to phase 2 */
> +               }
> +
> +               work &= ~_TIF_SECCOMP;
> +       }
> + #endif
> +
> +       /* Do our best to finish without phase 2. */
> +       if (work == 0)
> +               return ret;  /* seccomp and/or nohz only (ret == 0 here) */
> +
> + #ifdef CONFIG_AUDITSYSCALL
> +       if (work == _TIF_SYSCALL_AUDIT) {
> +               /*
> +                * If there is no more work to be done except auditing,
> +                * then audit in phase 1.  Phase 2 always audits, so, if
> +                * we audit here, then we can't go on to phase 2.
> +                */
> +               do_audit_syscall_entry(regs, arch);
> +               return 0;
> +       }
> + #endif
> +
> +       return 1;  /* Something is enabled that we can't handle in phase 1 */
> + }
> +
> + /* Returns the syscall nr to run (which should match regs->orig_ax). */
> + long syscall_trace_enter_phase2(struct pt_regs *regs, u32 arch,
> +                               unsigned long phase1_result)
>   {
>         long ret = 0;
> +       u32 work = ACCESS_ONCE(current_thread_info()->flags) &
> +               _TIF_WORK_SYSCALL_ENTRY;
>
> -       user_exit();
> +       BUG_ON(regs != task_pt_regs(current));
>
>         /*
>          * If we stepped into a sysenter/syscall insn, it trapped in



-- 
Andy Lutomirski
AMA Capital Management, LLC
