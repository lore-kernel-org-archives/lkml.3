Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbaD3Ntt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:49:49 -0400
Received: from sibelius.xs4all.nl ([83.163.83.176]:25009 "EHLO
	glazunov.sibelius.xs4all.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758792AbaD3Nts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:49:48 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 09:49:47 EDT
Date: Wed, 30 Apr 2014 15:35:33 +0200 (CEST)
Message-Id: <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
From: Mark Kettenis <mark.kettenis@xs4all.nl>
To: hpa@zytor.com
CC: pinskia@gmail.com, teawater@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, gdb@sourceware.org
In-reply-to: <536085B7.5070002@zytor.com> (hpa@zytor.com)
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>	<53554846.3070608@zytor.com>	<CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>	<53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com> <536085B7.5070002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Tue, 29 Apr 2014 22:10:15 -0700
> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> On 04/29/2014 10:08 PM, Andrew Pinski wrote:
> > 
> > restoring the values is hard since even the ptrace interface does not
> > allow for that.
> > 
> 
> So that begs the ultimate question, which is: given the fact that there
> is *state missing* from the state vector (this is the core of the
> problem), is there a way we can add that state so that gdb will be able
> to save and restore it?

Carrying around additional state in GDB is complicated; I'd rather
avoid it.

arch/x86/kernel/ptrace.c:putreg32() has this bit of code:

        case offsetof(struct user32, regs.orig_eax):
                /*
                 * A 32-bit debugger setting orig_eax means to restore
                 * the state of the task restarting a 32-bit syscall.
                 * Make sure we interpret the -ERESTART* codes correctly
                 * in case the task is not actually still sitting at the
                 * exit from a 32-bit syscall with TS_COMPAT still set.
                 */
                regs->orig_ax = value;
                if (syscall_get_nr(child, regs) >= 0)
                        task_thread_info(child)->status |= TS_COMPAT;
                break;

which gets used for 32-bit compat ptrace(2).  Perhaps the same logic
should be added to putreg() if the child is a 32-bit process?

If (and only if) the goal of that TS_COMPAT flag solely is to trigger
the error code sign-extension in arch/x86/asm/syscall.h:syscall_get_error(),
we could work around to problem in GDB by checking "orig_ax" to see if
we're continuing an interrupted system call and sign extend the error
code in the real "eax" register if we are.
