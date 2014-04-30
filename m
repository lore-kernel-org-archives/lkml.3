Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaD3EvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:51:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45450 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaD3EvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:51:19 -0400
Message-ID: <53608125.2020103@zytor.com>
Date: Tue, 29 Apr 2014 21:50:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, eparis@redhat.com, ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com> <53554846.3070608@zytor.com> <CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>
In-Reply-To: <CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 08:44 PM, Hui Zhu wrote:
> 
> I am sorry that the root cause of issue has something wrong.
> The right root cause is:
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

So gdb just corrupted the system state.

> Step 2, change the values of registers.
> Step 3, Push a dummy frame to stack.
> Step 4, set a breakpint in the return address.
> 
> When GDB resume the inferior, it will keep execut from ptrace_stop
> with new values of registers that set by GDB.

> And TS_COMPAT inside current_thread_info->status will be cleared when
> inferior switch back to user space.

As it should, because TS_COMPAT *only is meaningful while a system call
is executing*.

> When function "func1()" return, inferior will be stoped by breakpoint
> inferior will be stopped by Linux kernel function "ptrace_stop" again.
> current_thread_info->status will not set TS_COMPAT when inferior swith
> from user space to kernel space because breakpoint handler "int3" doesn't
> has code for that.

As it shouldn't, because there is no system call entry involved.

> GDB begin to set saved values of registers back to inferior that use
> function "amd64_collect_native_gregset".  Because this function just
> zero-extend each 32 bits value to 64 bits value before put them to inferior.
> $rax's value is set to 0xfffffe00(32 bits -512) but not
> 0xfffffffffffffe00(64 bits -512).
>
> When GDB continue syscall "read" that is interrupted by "ctrl-c", it will
> keep execute from ptrace_stop without "TS_COMPAT".

gdb has corrupted the state, and it fails to execute.

I'm wondering if we need to add additional state here, to carry the
TS_COMPAT bit.  We have talked about this kind of issues in the past.

> Then in Linux kernel function "syscall_get_error", current_thread_info->status
> doesn't have TS_COMPAT and $rax is 0xfffffe00(32 bits -512).  Then in
> function do_signal will not handle this -ERESTARTSYS.
> 
> -ERESTARTSYS will be return back to inferior, that is why inferior got a
> errno -ERESTARTSYS.
> 
> I made a new patch that before call do_notify_resume(will call do_signal)
> in the int3 handler, set TS_COMPAT to status if this task is TIF_IA32.
> Then after GDB call a function of inferior, it will still has TS_COMPAT.

I'm not sure if I want to label this a gdb bug or not (my main feeling
is that gdb should save and restore the register set presented to it,
and that truncating values to 32 bits is the root of the problem), but
the above is definitely a hack which doesn't really address the real
problem.

	-hpa

