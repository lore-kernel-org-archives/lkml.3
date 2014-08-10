Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaHJWma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 18:42:30 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64939 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaHJWm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 18:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <53E7890F.4070109@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
 <1407519880-6719-18-git-send-email-dvlasenk@redhat.com> <CALCETrXDjOPR9kEwx9fJFFz=A1jRKPBbfpoe8XztchktrUaz0Q@mail.gmail.com>
 <53E7890F.4070109@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 11 Aug 2014 07:42:07 +0900
Message-ID: <CALCETrVTw5amX-v_C+Bp5Y0B0KbzNKEEq_ZMke-AC7cZopGd9Q@mail.gmail.com>
Subject: Re: [PATCH 17/17] x86: simplify iret stack handling on SYSCALL64 fastpath
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:00 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> On 08/09/2014 12:59 AM, Andy Lutomirski wrote:
>>> + * When returning through fast path, userspace sees rcx = return address,
>>> + * r11 = rflags. When returning through iret (e.g. if audit is active),
>>> + * these registers may contain garbage.
>>> + * For ptrace we manage to avoid that: when we hit slow path on entry,
>>> + * we do save rcx and r11 in pt_regs, so ptrace on exit also sees them.
>>> + * If slow path is entered only on exit, there will be garbage.
>>
>> I don't like this.  At least the current code puts something
>> deterministic in there (-1) for the slow path, even though it's wrong
>> and makes the slow path behave visibly differently from the fast path.
>>
>> Leaking uninitialized data here is extra bad, though.  Keep in mind
>> that, when a syscall entry is interrupted before fully setting up
>> pt_regs, the interrupt frame overlaps task_pt_regs, so it's possible,
>> depending on the stack slot ordering, for a kernel secret
>> (kernel_stack?) to end up somewhere in task_pt_regs.
>
> It's easy to fix. We jump off fast path to slow path here:
>
>         movl TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS),%edx
>         andl %edi,%edx
>         jnz  sysret_careful
>
> This is the only use of "sysret_careful" label.
> Therefore, there we don't need to think about any other scenarios
> besides "we are returning from syscall here".

I may be missing something here (on vacation, not really testing
things, no big monitor, etc), but how is this compatible with things
like rt_sigreturn?  rt_sigreturn is call from the fastpath, via a
stub, and it returns through int_ret_from_syscall.  The C part needs
to modify all the regs, and those regs need to stick, so fixing up rcx
and r11 after rt_sigreturn can't work.

On the flip side, fork probably needs to *read* those regs, so the
fixup needs to happen before fork.

I'm sure it's possible to get this right, but it's complicated and
error-prone, and I'm not at all convinced it's worth it to save two
stores on the fast path.

(I'm pretty sure that current kernels have all kinds of bugs in this area.)

>
> My patch only fixes up segment regs:
>
>         /* Handle reschedules */
>         /* edx: work, edi: workmask */
>  sysret_careful:
> +       STORE_IRET_FRAME_CS_SS
>         bt $TIF_NEED_RESCHED,%edx
>
> pt_regs->rcx and ->r11 aren't initialized.
>
> We can fix that e.g. by adding here four more insns:
>
>         movq    RIP(%rsp),%rcx
>         movq    %rcx,RCX(%rsp)
>         movq    EFLAGS(%rsp),%rcx
>         movq    %rcx,R11(%rsp)
>
> similar to what my patch did on slow path on entry (see changes at
> "tracesys" label).
>
> Or we can just bite the bullet and save rcx and r11 on fast path
> (there it will require just two insns). +2 cycles on most CPUs.
>


--Andy
