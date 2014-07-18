Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbaGROS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:18:27 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:62461 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761268AbaGROS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <53C8F56C.5070706@imgtec.com>
References: <CAGXu5jJJ7dqC-or=ZhKKj8=eA5itKX4aLRsnxmFZvwnyRcrUrw@mail.gmail.com>
	<53C8F56C.5070706@imgtec.com>
Date: Fri, 18 Jul 2014 07:18:25 -0700
X-Google-Sender-Auth: qVR6Cm9gA0zlK5VUgX9BGE36bE8
Message-ID: <CAGXu5j+TE_t1akY0v2LSMvAEHcmTf_1nXCJLuWRCdJQFeKmZJA@mail.gmail.com>
Subject: Re: MIPS seccomp and changing syscalls
From: Kees Cook <keescook@chromium.org>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 3:22 AM, Markos Chandras
<Markos.Chandras@imgtec.com> wrote:
> Hi Kees,
>
> On 07/17/2014 11:29 PM, Kees Cook wrote:
>> Hi,
>>
>> I recently fixed a bug in seccomp on ARM that I think may be present
>> in the MIPS implementation too. In arch/mips/kernel/ptrace.c
>> syscall_trace_enter, the syscall variable is used (and returned), but
>> the syscall may be changed by either secure_computing or
>> tracehook_report_syscall_entry (via ptracers which can block and
>> change the registers). (I would note that "ret" is also set but never
>> used, so tracehook_report_syscall_entry failures actually won't get
>> noticed.)
>>
>> The discussion about this bug on ARM is here:
>> https://lkml.org/lkml/2014/6/20/439
>
> Thanks for letting us know.
> Right, I believe MIPS will have the same problem and a similar patch to
> Will Deacon's one will fix it properly. Would you like to submit one for
> MIPS too? Otherwise I can do it myself.
>
>>
>> I don't yet have a working MIPS environment to test this on, but it
>> feels like the same bug. (Though, for testing, what's the right way to
>> change syscall during PTRACE_SYSCALL? On x86 it's the orig_ax
>> register, on ARM it's a arch-specific ptrace function
>> (PTRACE_SET_SYSCALL).
>
> For MIPS, the syscall numbers is in the v0 register ($2). But the o32
> ABI also has the syscall() system call. So in case of indirect system
> calls, the real system call is the first argument of syscall(), which is
> register a0 ($4). See syscall_get_nr in arch/mips/include/asm/syscall.h

I just spent some time reading the scall*.S code, and it looks like
there actually isn't a way to change syscall via a tracer on MIPS. The
syscall function pointer is calculated before the tracer call, and
then only the first four registers are restored.

It seems like providing this feature on MIPS would require reordering
the logic in the entry points, potentially doing a full register set
reload. (It looks like MIPS only has a "fastpath" and no "slowpath"
logic.)

So, strictly speaking, there's no bug in syscall_trace_enter, but
there is a missing trace feature. :)

Slightly related, it'd be great to add MIPS to the syscall(2)
man-page; most other architectures are in there now:
http://manpages.ubuntu.com/manpages/trusty/en/man2/syscall.2.html

-Kees

-- 
Kees Cook
Chrome OS Security
