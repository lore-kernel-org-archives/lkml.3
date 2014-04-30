Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaD3DpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:45:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52411 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaD3DpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:45:22 -0400
MIME-Version: 1.0
In-Reply-To: <53554846.3070608@zytor.com>
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>
 <53554846.3070608@zytor.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 30 Apr 2014 11:44:41 +0800
Message-ID: <CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by GDB
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, eparis@redhat.com, ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/21/2014 09:19 AM, Hui Zhu wrote:
>> }
>> Now ax is in 32 bits now, need sign-extend to 64 bits.  But
>> current_thread_info()->status TS_COMPAT is cleared when GDB call "call func1()".
>> Linux kernel don't know this is a 32 bits task and will not extend it.
>> Then -ERESTARTSYS is not be handled and go back to user space.
>>
>> Then the syscall "read" get a errno in ERESTARTSYS.
>>
>> To fix this issue, I tried to add a local variable to "do_signal" but
>> it is not works.  The stack is cleared before GDB "continue".
>> so I make a patch that add "test_thread_flag (TIF_IA32)" to syscall_get_error.
>>
>> Signed-off-by: Hui Zhu <hui@codesourcery.com>
>> ---
>> --- a/arch/x86/include/asm/syscall.h
>> +++ b/arch/x86/include/asm/syscall.h
>> @@ -48,7 +48,8 @@ static inline long syscall_get_error(str
>>   * TS_COMPAT is set for 32-bit syscall entries and then
>>   * remains set until we return to user mode.
>>   */
>> - if (task_thread_info(task)->status & TS_COMPAT)
>> + if ((task_thread_info(task)->status & TS_COMPAT)
>> +    || test_thread_flag (TIF_IA32))
>>   /*
>>   * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
>>   * and will match correctly in comparisons.
>>
>
> No, this is definitely not the right fix.  Your description is
> incredibly hard to follow, but I feel pretty strongly that the above is
> at the very best a last resort fix.  TS_COMPAT is a local property
> whereas TIF_IA32 is global; it is important to keep their respective
> uses correct.  Mixing them is almost guaranteed to be just plain wrong.
>
>         -hpa
>

I am sorry that the root cause of issue has something wrong.
The right root cause is:
When inferior call 32 bits syscall "read", Linux kernel function
"ia32_cstar_target" will set TS_COMPAT to current_thread_info->status.

syscall read is interrupt by ctrl-c.   Then the $rax will be set to
errno -512 in 64 bits.
And the inferior will be stopped by Linux kernel function ptrace_stop,
the call trace is:
#0  freezable_schedule () at include/linux/freezer.h:172
#1  ptrace_stop (exit_code=exit_code@entry=5, why=why@entry=262148,
    clear_code=clear_code@entry=0, info=info@entry=0xffff88001d833e78)
    at kernel/signal.c:1920
#2  0xffffffff8107ec33 in ptrace_signal (info=0xffff88001d833e78, signr=5)
    at kernel/signal.c:2157
#3  get_signal_to_deliver (info=info@entry=0xffff88001d833e78,
    return_ka=return_ka@entry=0xffff88001d833e58, regs=<optimized out>,
    cookie=cookie@entry=0x0 <irq_stack_union>) at kernel/signal.c:2269
#4  0xffffffff81013438 in do_signal (regs=regs@entry=0xffff88001d833f58)
    at arch/x86/kernel/signal.c:696
#5  0xffffffff81013a40 in do_notify_resume (regs=0xffff88001d833f58,
    unused=<optimized out>, thread_info_flags=4) at arch/x86/kernel/signal.c:747
#6  <signal handler called>
#7  0x0000000000000000 in irq_stack_union ()

After that, GDB can control the stopped inferior.
To call function "func1()" of inferior, GDB need:
Step 1, save current values of registers ($rax 0xfffffffffffffe00(64 bits -512)
is cut to 0xfffffe00(32 bits -512) because inferior is a 32 bits program).
Step 2, change the values of registers.
Step 3, Push a dummy frame to stack.
Step 4, set a breakpint in the return address.

When GDB resume the inferior, it will keep execut from ptrace_stop
with new values of registers that set by GDB.
And TS_COMPAT inside current_thread_info->status will be cleared when
inferior switch back to user space.

When function "func1()" return, inferior will be stoped by breakpoint
inferior will be stopped by Linux kernel function "ptrace_stop" again.
current_thread_info->status will not set TS_COMPAT when inferior swith
from user space to kernel space because breakpoint handler "int3" doesn't
has code for that.

GDB begin to set saved values of registers back to inferior that use
function "amd64_collect_native_gregset".  Because this function just
zero-extend each 32 bits value to 64 bits value before put them to inferior.
$rax's value is set to 0xfffffe00(32 bits -512) but not
0xfffffffffffffe00(64 bits -512).

When GDB continue syscall "read" that is interrupted by "ctrl-c", it will
keep execute from ptrace_stop without "TS_COMPAT".
Then in Linux kernel function "syscall_get_error", current_thread_info->status
doesn't have TS_COMPAT and $rax is 0xfffffe00(32 bits -512).  Then in
function do_signal will not handle this -ERESTARTSYS.

-ERESTARTSYS will be return back to inferior, that is why inferior got a
errno -ERESTARTSYS.

I made a new patch that before call do_notify_resume(will call do_signal)
in the int3 handler, set TS_COMPAT to status if this task is TIF_IA32.
Then after GDB call a function of inferior, it will still has TS_COMPAT.

Signed-off-by: Hui Zhu <hui@codesourcery.com>
---
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1545,7 +1545,14 @@ paranoid_userspace:
  ENABLE_INTERRUPTS(CLBR_NONE)
  xorl %esi,%esi /* arg2: oldset */
  movq %rsp,%rdi /* arg1: &pt_regs */
+        testl $_TIF_IA32,%ebx
+        jnz call_do_notify_resume
+        GET_THREAD_INFO(%rcx)
+        orl $TS_COMPAT,TI_status(%rcx)
+call_do_notify_resume:
  call do_notify_resume
+        GET_THREAD_INFO(%rcx)
+        andl    $~TS_COMPAT,TI_status(%rcx)
  DISABLE_INTERRUPTS(CLBR_NONE)
  TRACE_IRQS_OFF
  jmp paranoid_userspace
