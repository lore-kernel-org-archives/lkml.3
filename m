Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaDUQU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:20:27 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:62291 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDUQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:20:23 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 22 Apr 2014 00:19:42 +0800
Message-ID: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>
Subject: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by GDB
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#cat gdb.base/interrupt.c
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#ifdef SIGNALS
#include <signal.h>

static void
sigint_handler (int signo)
{
}
#endif

int
main ()
{
  char x;
  int nbytes;
#ifdef SIGNALS
  signal (SIGINT, sigint_handler);
#endif
  printf ("talk to me baby\n");
  while (1)
    {
      nbytes = read (0, &x, 1);
      if (nbytes < 0)
{
#ifdef EINTR
 if (errno != EINTR)
#endif
   {
     perror ("");
     return 1;
   }
}
      else if (nbytes == 0)
{
 printf ("end of file\n");
 exit (0);
}
      else
write (1, &x, 1);
    }
  return 0;
}

int
func1 ()
{
  return 4;
}
#gcc -g -m32 gdb.base/interrupt.c
#gdb ./a.out
(gdb) r
Starting program: /home/teawater/gdb/binutils-gdb/gdb/testsuite/a.out
talk to me baby
data
data
^C
Program received signal SIGINT, Interrupt.
0xf7ffd430 in __kernel_vsyscall ()
(gdb) c
Continuing.
^C
Program received signal SIGINT, Interrupt.
0xf7ffd430 in __kernel_vsyscall ()
(gdb) p func1()
$1 = 4
(gdb) c
Continuing.
Unknown error 512
[Inferior 1 (process 7953) exited with code 01]

      nbytes = read (0, &x, 1);
      if (nbytes < 0)
{
#ifdef EINTR
 if (errno != EINTR)
#endif
After GDB call a function "func1()" by hands, "read" will get
errno 512(ERESTARTSYS) that should handled by Linux kernel.

The root cause of this issue is:
When user use ctrl-c stop the inferior, the signal will be handled in
Linux kernel function "do_signal" in arch/x86/kernel/signal.c.
The inferior will be stoped by function "ptrace_stop".  The call trace is:
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

When GDB "call func1()", to control inferior execute the function func1()
and go back to old ip.  GDB need set all the registers by GDB function
"amd64_collect_native_gregset" that will zero-extend most of 32 bits registers
to 64 bits and set to inferior.
And execute from ptrace_stop and got back to do_signal.
current_thread_info()->status TS_COMPAT will be clean by function
"int_with_check" when it return to user space.

When GDB "continue", inferior will execute from ptrace_stop and got back
to do_signal again.
Because this signal interrupt a syscall, go back to function do_signal
will use function "syscall_get_error" check if this is a syscall and got
error:
static inline long syscall_get_error(struct task_struct *task,
    struct pt_regs *regs)
{
unsigned long error = regs->ax;
#ifdef CONFIG_IA32_EMULATION
/*
* TS_COMPAT is set for 32-bit syscall entries and then
* remains set until we return to user mode.
*/
if (task_thread_info(task)->status & TS_COMPAT)
/*
* Sign-extend the value so (int)-EFOO becomes (long)-EFOO
* and will match correctly in comparisons.
*/
error = (long) (int) error;
#endif
return IS_ERR_VALUE(error) ? error : 0;
}
Now ax is in 32 bits now, need sign-extend to 64 bits.  But
current_thread_info()->status TS_COMPAT is cleared when GDB call "call func1()".
Linux kernel don't know this is a 32 bits task and will not extend it.
Then -ERESTARTSYS is not be handled and go back to user space.

Then the syscall "read" get a errno in ERESTARTSYS.

To fix this issue, I tried to add a local variable to "do_signal" but
it is not works.  The stack is cleared before GDB "continue".
so I make a patch that add "test_thread_flag (TIF_IA32)" to syscall_get_error.

Signed-off-by: Hui Zhu <hui@codesourcery.com>
---
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -48,7 +48,8 @@ static inline long syscall_get_error(str
  * TS_COMPAT is set for 32-bit syscall entries and then
  * remains set until we return to user mode.
  */
- if (task_thread_info(task)->status & TS_COMPAT)
+ if ((task_thread_info(task)->status & TS_COMPAT)
+    || test_thread_flag (TIF_IA32))
  /*
  * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
  * and will match correctly in comparisons.
