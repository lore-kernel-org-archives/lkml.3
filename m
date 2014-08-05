Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaHEKgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:36:21 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51698 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaHEKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:36:16 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrV6rap+rZirLsMmdzML9rSKnWEmq-ACNLLGYgKtT-K6uA@mail.gmail.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com>
 <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com> <CALCETrV6rap+rZirLsMmdzML9rSKnWEmq-ACNLLGYgKtT-K6uA@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 5 Aug 2014 12:35:55 +0200
Message-ID: <CAK1hOcM_KLqi9MVa_b-WoimCD084F-t_qE-maEX7ibgtzg8BnQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 11:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Next up: remove FIXUP/RESTORE_TOP_OF_STACK? :)  Maybe I'll give that a shot.
>>
>> I'm yet at the stage "what that stuff does anyway?" and at
>> "why do we need percpu old_rsp thingy?" in particular.
>
> On x86_64, the syscall instruction has no effect on rsp.  That means
> that the entry point starts out with no stack.  There are no free
> registers whatsoever at the entry point.
>
> That means that the entry code needs to do swapgs, stash rsp somewhere
> relative to gs, and then load the kernel's rsp.  old_rsp is the spot
> used for this.
>
> Now the kernel does an optimization that is, I think, very much not
> worth it.  The kernel doesn't bother sticking the old rsp value into
> pt_regs (saving two instructions on fast path entries) and doesn't
> initialize the SS, CS, RCX, and EFLAGS fields in pt_regs, saving four
> more instructions.
>
> To make this optimization work, the whole FIXUP/RESTORE_TOP_OF_STACK
> dance is needed, and there's the usersp crap in the context switch
> code, and current_user_stack_pointer(), and probably even more crap
> that I haven't noticed.  And I sure hope that nothing in the *compat*
> syscall path touches current_user_stack_pointer(), because the compat
> code doesn't seem to use old_rsp.
>
> I think this should all be ripped out.  The only real difficulty will
> be that the sysret code needs to restore rsp itself, so the sysret
> path will end up needing two more instructions.  Removing all of the
> TOP_OF_STACK stuff will add ten instructions to fast path syscalls,
> and I wouldn't be surprised if this adds considerably fewer than ten
> cycles on any modern chip.

Something like this on the fast path? -

        SWAPGS_UNSAFE_STACK
        movq    %rsp,PER_CPU_VAR(old_rsp)
        movq    PER_CPU_VAR(kernel_stack),%rsp
        ENABLE_INTERRUPTS(CLBR_NONE)
        ALLOC_PTREGS_ON_STACK 8         /* +8: space for orig_ax */
        SAVE_C_REGS
        movq  %rax,ORIG_RAX(%rsp)
        movq  %rcx,RIP(%rsp)
+       movq  %r11,EFLAGS(%rsp)
+       movq PER_CPU_VAR(old_rsp),%rcx
+       movq %rcx,RSP(%rsp)
        ...
-       RESTORE_C_REGS_EXCEPT_RCX
+       RESTORE_C_REGS_EXCEPT_RCX_R11
        movq RIP(%rsp),%rcx
+       movq    EFLAGS(%rsp), %r11
-       movq    PER_CPU_VAR(old_rsp), %rsp
+       movq    RSP(%rsp), %rsp
      USERGS_SYSRET64

Looks like only 3 additional insns (unfortunately, one is memory read).
Do we need to save rsc and r11 in "struct pt_regs" in their
"standard" slots, though? If we don't, we can drop two insns
(SAVE_C_REGS -> SAVE_C_REGS_EXCEPT_RCX_R11).

Then old_rsp can be nuked everywhere else,
RESTORE_TOP_OF_STACK can be nuked, and
FIXUP_TOP_OF_STACK can be reduced to merely:

        movq $__USER_DS,SS(%rsp)
        movq $__USER_CS,CS(%rsp)

(BTW, why currently it does "movq $-1,RCX+\offset(%rsp)?)

-- 
vda
