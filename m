Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaD3Uo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:44:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54101 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbaD3Uoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:44:55 -0400
Message-ID: <536160B1.9060601@zytor.com>
Date: Wed, 30 Apr 2014 13:44:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Kettenis <mark.kettenis@xs4all.nl>
CC: pinskia@gmail.com, teawater@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, gdb@sourceware.org
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>	<53554846.3070608@zytor.com>	<CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>	<53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com> <536085B7.5070002@zytor.com> <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
In-Reply-To: <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 06:35 AM, Mark Kettenis wrote:
> 
> arch/x86/kernel/ptrace.c:putreg32() has this bit of code:
> 
>         case offsetof(struct user32, regs.orig_eax):
>                 /*
>                  * A 32-bit debugger setting orig_eax means to restore
>                  * the state of the task restarting a 32-bit syscall.
>                  * Make sure we interpret the -ERESTART* codes correctly
>                  * in case the task is not actually still sitting at the
>                  * exit from a 32-bit syscall with TS_COMPAT still set.
>                  */
>                 regs->orig_ax = value;
>                 if (syscall_get_nr(child, regs) >= 0)
>                         task_thread_info(child)->status |= TS_COMPAT;
>                 break;
> 
> which gets used for 32-bit compat ptrace(2).  Perhaps the same logic
> should be added to putreg() if the child is a 32-bit process?
> 

This seems a lot saner although I haven't thought about some of the
consequences.

> If (and only if) the goal of that TS_COMPAT flag solely is to trigger
> the error code sign-extension in arch/x86/asm/syscall.h:syscall_get_error(),
> we could work around to problem in GDB by checking "orig_ax" to see if
> we're continuing an interrupted system call and sign extend the error
> code in the real "eax" register if we are.

So to clarify the meaning of all these flags, here is the first cut of
my writeup on the topic:

The x86-64 Linux kernel supports three types of processes: legacy i386
32-bit processes, x32 32-bit processes, or x86-64 64-bit processes.
It is a common question how to know what kind of process is currently
executing.  However, it turns out this question is not as
straightforward as it first seems, and it is important to keep the
various aspects of this in mind, or it is often easy to make wrong
design choices.

Mixing and matching these three different meanings is harmful.


1. The initial execution mode

The initial execution mode is determined by the type of initial
executable (usually, but not always, ELF).  Inside the kernel, this is
represented by the flags TIF_IA32, TIF_X32 and TIF_ADDR32.
Specifically, for an i386 process TIF_IA32 and TIF_ADDR32 will be set,
for an x32 process TIF_X32 and TIF_ADDR32 will be set, and for an
x86-64 process none will be set.

These flags control the format of signal stack frames, core dumps, and
(TIF_ADDR32) whether or not the kernel will allocate address space
above 4 GiB on behalf of the process.

Currently, these cannot be changed, in the future it may be possible
for the process to request a change at runtime.

The use of this bit for signal stack frames is a bit unfortunate.
There may be a better solution in the future like remembering the type
of system call that configured the stack frame.  In general as little
as possible should depend on this mode.


2. The current execution mode

The actual execution mode (16, 32, or 64 bits) of the processor is
changeable in user space simply by executing a far transfer
instruction (to get into 16-bit mode, the modify_ldt system call needs
to enable suitable segments).  At first instruction, an i386 process
will run in 32-bit mode and an x32 or x86-64 process will run in
64-bit mode, but there is no restriction preventing the process from
changing its execution mode.

Therefore, the execution mode may very well be different from process
entry and also different from the last time the process went through
the kernel.

Currently the kernel does not allow an LDT segment to be a 64-bit
segment.  This means that the user space process will have %cs ==
USER_CS (currently 0x33) whenever it is running in 64-bit mode.


3. The system call type

i386 processes will execute system calls via int $0x80, syscall32 or
sysenter32, depending on the processor.  x32 and x86-64 processes both
execute system calls via the syscall64 instruction.

Because i386 system call numbers are unrelated to and overlap x86-64
system call numbers, they are distinguished via the type of entry,
which is recorded in the form of the TS_COMPAT flag.  That is, to
uniquely know what system call has been executed, you need both the
status of the TS_COMPAT flag and the system call number recorded in
the orig_ax field of pt_regs.

x32 and x86-64 processes both run in 64-bit mode and both use the
syscall64 instruction, so x32 processes are distinguished by setting
bit 30 in the system call number.  Sometimes the base system call
number is also different for x32.  It is not currently illegal, but
not generally useful, for bit 30 to not match the system call number
for a system call number that is not shared between x32 and x86-64.
This may be made illegal in the future, if the need arises.

The type of system call (i386, x32 or x86-64) determines not just the
meaning of the system call number, but also changes the semantics of
some system calls, for example, a read() of certain files in the input
system will return different values, and some system calls use
different data structures in different modes.

It is worth noting that there is absolutely nothing that prevents a
64-bit process to execute int $0x80 and execute an i386 compatibility
system call.  Such a system call will run with TS_COMPAT set and will
use i386 data structures and semantics.

The TS_COMPAT bit has no meaning (and should always be clear) when no
system call is executing.



