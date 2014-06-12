Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaFLIlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:41:31 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56739 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaFLIl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <64aec591-a271-4ea9-8ce3-96160d6a1bf5@SVR-ORW-FEM-04.mgc.mentorg.com>
References: <64aec591-a271-4ea9-8ce3-96160d6a1bf5@SVR-ORW-FEM-04.mgc.mentorg.com>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 12 Jun 2014 16:40:47 +0800
Message-ID: <CANFwon0o1MZOgfh_WMN-YG952p=_nnn+X++AbFVeHHSGv=0+1g@mail.gmail.com>
Subject: Re: [PATCH v2] Fix get ERESTARTSYS with m32 in x86_64 when debug by GDB
To: Hui Zhu <hui@codesourcery.com>
Cc: "H.Peter Anvin" <hpa@zytor.com>, Mark Kettenis <mark.kettenis@xs4all.nl>,
        Andrew Pinski <pinskia@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, eparis@redhat.com, ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Thanks,
Hui

On Mon, May 5, 2014 at 8:00 PM, Hui Zhu <hui@codesourcery.com> wrote:
> cat gdb.base/interrupt.c
> #include <errno.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
>
> #ifdef SIGNALS
> #include <signal.h>
>
> static void
> sigint_handler (int signo)
> {
> }
> #endif
>
> int
> main ()
> {
>   char x;
>   int nbytes;
> #ifdef SIGNALS
>   signal (SIGINT, sigint_handler);
> #endif
>   printf ("talk to me baby\n");
>   while (1)
>     {
>       nbytes = read (0, &x, 1);
>       if (nbytes < 0)
> {
> #ifdef EINTR
>  if (errno != EINTR)
> #endif
>    {
>      perror ("");
>      return 1;
>    }
> }
>       else if (nbytes == 0)
> {
>  printf ("end of file\n");
>  exit (0);
> }
>       else
> write (1, &x, 1);
>     }
>   return 0;
> }
>
> int
> func1 ()
> {
>   return 4;
> }
> gcc -g -m32 gdb.base/interrupt.c
> gdb ./a.out
> (gdb) r
> Starting program: /home/teawater/gdb/binutils-gdb/gdb/testsuite/a.out
> talk to me baby
> data
> data
> ^C
> Program received signal SIGINT, Interrupt.
> 0xf7ffd430 in __kernel_vsyscall ()
> (gdb) c
> Continuing.
> ^C
> Program received signal SIGINT, Interrupt.
> 0xf7ffd430 in __kernel_vsyscall ()
> (gdb) p func1()
> $1 = 4
> (gdb) c
> Continuing.
> Unknown error 512
> [Inferior 1 (process 7953) exited with code 01]
>
> The root cause is:
> When inferior call 32 bits syscall "read", Linux kernel function
> "ia32_cstar_target" will set TS_COMPAT to current_thread_info->status.
>
> syscall read is interrupt by ctrl-c.   Then the $rax will be set to
> errno -512 in 64 bits.
> And the inferior will be stopped by Linux kernel function ptrace_stop,
> the call trace is:
> #0  freezable_schedule () at include/linux/freezer.h:172
> #1  ptrace_stop (exit_code=exit_code@entry=5, why=why@entry=262148,
>     clear_code=clear_code@entry=0, info=info@entry=0xffff88001d833e78)
>     at kernel/signal.c:1920
> #2  0xffffffff8107ec33 in ptrace_signal (info=0xffff88001d833e78, signr=5)
>     at kernel/signal.c:2157
> #3  get_signal_to_deliver (info=info@entry=0xffff88001d833e78,
>     return_ka=return_ka@entry=0xffff88001d833e58, regs=<optimized out>,
>     cookie=cookie@entry=0x0 <irq_stack_union>) at kernel/signal.c:2269
> #4  0xffffffff81013438 in do_signal (regs=regs@entry=0xffff88001d833f58)
>     at arch/x86/kernel/signal.c:696
> #5  0xffffffff81013a40 in do_notify_resume (regs=0xffff88001d833f58,
>     unused=<optimized out>, thread_info_flags=4) at arch/x86/kernel/signal.c:747
> #6  <signal handler called>
> #7  0x0000000000000000 in irq_stack_union ()
>
> After that, GDB can control the stopped inferior.
> To call function "func1()" of inferior, GDB need:
> Step 1, save current values of registers ($rax 0xfffffffffffffe00(64 bits -512)
> is cut to 0xfffffe00(32 bits -512) because inferior is a 32 bits program).
> Step 2, change the values of registers.
> Step 3, Push a dummy frame to stack.
> Step 4, set a breakpint in the return address.
>
> When GDB resume the inferior, it will keep execut from ptrace_stop
> with new values of registers that set by GDB.
> And TS_COMPAT inside current_thread_info->status will be cleared when
> inferior switch back to user space.
>
> When function "func1()" return, inferior will be stoped by breakpoint
> inferior will be stopped by Linux kernel function "ptrace_stop" again.
> current_thread_info->status will not set TS_COMPAT when inferior swith
> from user space to kernel space because breakpoint handler "int3" doesn't
> has code for that.
>
> GDB begin to set saved values of registers back to inferior that use
> function "amd64_collect_native_gregset".  Because this function just
> zero-extend each 32 bits value to 64 bits value before put them to inferior.
> $rax's value is set to 0xfffffe00(32 bits -512) but not
> 0xfffffffffffffe00(64 bits -512).
>
> When GDB continue syscall "read" that is interrupted by "ctrl-c", it will
> keep execute from ptrace_stop without "TS_COMPAT".
> Then in Linux kernel function "syscall_get_error", current_thread_info->status
> doesn't have TS_COMPAT and $rax is 0xfffffe00(32 bits -512).  Then in
> function do_signal will not handle this -ERESTARTSYS.
>
> -ERESTARTSYS will be return back to inferior, that is why inferior got a
> errno -ERESTARTSYS.
>
> According to comments from Mark.  I make a new version that add following
> code to putreg():
>         case offsetof(struct user_regs_struct, orig_ax):
>                 /*
>                  * A 64-bit debugger setting orig_ax of a 32-bit inferior
>                  * means to restore the state of the task restarting a
>                  * 32-bit syscall.
>                  * Make sure we interpret the -ERESTART* codes correctly
>                  * in case the task is not actually still sitting at the
>                  * exit from a 32-bit syscall with TS_COMPAT still set.
>                  */
>                 if (test_ti_thread_flag(task_thread_info(child), TIF_IA32)) {
>                         struct pt_regs *regs = task_pt_regs(child);
>                         regs->orig_ax = value;
>                         if (syscall_get_nr(child, regs) >= 0)
>                                 task_thread_info(child)->status |= TS_COMPAT;
>                         return 0;
>                 }
>                 break;
>
> Signed-off-by: Hui Zhu <hui@codesourcery.com>
> ---
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -452,6 +452,23 @@ static int putreg(struct task_struct *ch
>                 if (child->thread.gs != value)
>                         return do_arch_prctl(child, ARCH_SET_GS, value);
>                 return 0;
> +       case offsetof(struct user_regs_struct, orig_ax):
> +               /*
> +                * A 64-bit debugger setting orig_ax of a 32-bit inferior
> +                * means to restore the state of the task restarting a
> +                * 32-bit syscall.
> +                * Make sure we interpret the -ERESTART* codes correctly
> +                * in case the task is not actually still sitting at the
> +                * exit from a 32-bit syscall with TS_COMPAT still set.
> +                */
> +               if (test_ti_thread_flag(task_thread_info(child), TIF_IA32)) {
> +                       struct pt_regs *regs = task_pt_regs(child);
> +                       regs->orig_ax = value;
> +                       if (syscall_get_nr(child, regs) >= 0)
> +                               task_thread_info(child)->status |= TS_COMPAT;
> +                       return 0;
> +               }
> +               break;
>  #endif
>         }
>
