Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaD3Q2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:28:49 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36687 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742AbaD3Q2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>
 <53554846.3070608@zytor.com> <CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>
 <53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com>
 <536085B7.5070002@zytor.com> <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 1 May 2014 00:28:07 +0800
Message-ID: <CANFwon1OnRmXChO_uYa=ftJc8NqmvV7CRdM6hrWeyqXYUt417Q@mail.gmail.com>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by GDB
To: Mark Kettenis <mark.kettenis@xs4all.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, pinskia@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, eparis@redhat.com, ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 9:35 PM, Mark Kettenis <mark.kettenis@xs4all.nl> wrote:
>> Date: Tue, 29 Apr 2014 22:10:15 -0700
>> From: "H. Peter Anvin" <hpa@zytor.com>
>>
>> On 04/29/2014 10:08 PM, Andrew Pinski wrote:
>> >
>> > restoring the values is hard since even the ptrace interface does not
>> > allow for that.
>> >
>>
>> So that begs the ultimate question, which is: given the fact that there
>> is *state missing* from the state vector (this is the core of the
>> problem), is there a way we can add that state so that gdb will be able
>> to save and restore it?
>
> Carrying around additional state in GDB is complicated; I'd rather
> avoid it.
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

Make a new patch that add following code to putreg():
case offsetof(struct user_regs_struct, orig_ax):
/*
* A 64-bit debugger setting orig_ax of a 32-bit inferior
* means to restore the state of the task restarting a
* 32-bit syscall.
* Make sure we interpret the -ERESTART* codes correctly
* in case the task is not actually still sitting at the
* exit from a 32-bit syscall with TS_COMPAT still set.
*/
if (test_ti_thread_flag(task_thread_info(child), TIF_IA32)) {
struct pt_regs *regs = task_pt_regs(child);
regs->orig_ax = value;
if (syscall_get_nr(child, regs) >= 0)
task_thread_info(child)->status |= TS_COMPAT;
return 0;
}

>
> If (and only if) the goal of that TS_COMPAT flag solely is to trigger
> the error code sign-extension in arch/x86/asm/syscall.h:syscall_get_error(),
> we could work around to problem in GDB by checking "orig_ax" to see if
> we're continuing an interrupted system call and sign extend the error
> code in the real "eax" register if we are.

I will update patch in
https://sourceware.org/ml/gdb-patches/2014-04/msg00429.html
according to this comments.

Thanks,
Hui

Signed-off-by: Hui Zhu <hui@codesourcery.com>
---
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -452,6 +452,23 @@ static int putreg(struct task_struct *ch
  if (child->thread.gs != value)
  return do_arch_prctl(child, ARCH_SET_GS, value);
  return 0;
+ case offsetof(struct user_regs_struct, orig_ax):
+ /*
+ * A 64-bit debugger setting orig_ax of a 32-bit inferior
+ * means to restore the state of the task restarting a
+ * 32-bit syscall.
+ * Make sure we interpret the -ERESTART* codes correctly
+ * in case the task is not actually still sitting at the
+ * exit from a 32-bit syscall with TS_COMPAT still set.
+ */
+ if (test_ti_thread_flag(task_thread_info(child), TIF_IA32)) {
+ struct pt_regs *regs = task_pt_regs(child);
+ regs->orig_ax = value;
+ if (syscall_get_nr(child, regs) >= 0)
+ task_thread_info(child)->status |= TS_COMPAT;
+ return 0;
+ }
+ break;
 #endif
  }
