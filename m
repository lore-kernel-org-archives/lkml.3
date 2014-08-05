Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaHEPSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHEPSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:18:24 -0400
Message-ID: <53E0F59E.7090101@redhat.com>
Date: Tue, 05 Aug 2014 17:17:50 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <vda.linux@googlemail.com>
CC: X86 ML <x86@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com> <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com> <CALCETrV6rap+rZirLsMmdzML9rSKnWEmq-ACNLLGYgKtT-K6uA@mail.gmail.com> <CAK1hOcM_KLqi9MVa_b-WoimCD084F-t_qE-maEX7ibgtzg8BnQ@mail.gmail.com> <CALCETrUToxhfNy42A38R1cUU1HFrQV=jycf2LFqtPv_6b6nRRw@mail.gmail.com>
In-Reply-To: <CALCETrUToxhfNy42A38R1cUU1HFrQV=jycf2LFqtPv_6b6nRRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 04:53 PM, Andy Lutomirski wrote:
> On Aug 5, 2014 7:36 PM, "Denys Vlasenko" <vda.linux@googlemail.com> wrote:
>>
>> On Mon, Aug 4, 2014 at 11:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> Next up: remove FIXUP/RESTORE_TOP_OF_STACK? :)  Maybe I'll give that a shot.
>>>>
>>>> I'm yet at the stage "what that stuff does anyway?" and at
>>>> "why do we need percpu old_rsp thingy?" in particular.
>>>
>>> On x86_64, the syscall instruction has no effect on rsp.  That means
>>> that the entry point starts out with no stack.  There are no free
>>> registers whatsoever at the entry point.
>>>
>>> That means that the entry code needs to do swapgs, stash rsp somewhere
>>> relative to gs, and then load the kernel's rsp.  old_rsp is the spot
>>> used for this.
>>>
>>> Now the kernel does an optimization that is, I think, very much not
>>> worth it.  The kernel doesn't bother sticking the old rsp value into
>>> pt_regs (saving two instructions on fast path entries) and doesn't
>>> initialize the SS, CS, RCX, and EFLAGS fields in pt_regs, saving four
>>> more instructions.
>>>
>>> To make this optimization work, the whole FIXUP/RESTORE_TOP_OF_STACK
>>> dance is needed, and there's the usersp crap in the context switch
>>> code, and current_user_stack_pointer(), and probably even more crap
>>> that I haven't noticed.  And I sure hope that nothing in the *compat*
>>> syscall path touches current_user_stack_pointer(), because the compat
>>> code doesn't seem to use old_rsp.
>>>
>>> I think this should all be ripped out.  The only real difficulty will
>>> be that the sysret code needs to restore rsp itself, so the sysret
>>> path will end up needing two more instructions.  Removing all of the
>>> TOP_OF_STACK stuff will add ten instructions to fast path syscalls,
>>> and I wouldn't be surprised if this adds considerably fewer than ten
>>> cycles on any modern chip.
>>
>> Something like this on the fast path? -
>>
>>         SWAPGS_UNSAFE_STACK
>>         movq    %rsp,PER_CPU_VAR(old_rsp)
>>         movq    PER_CPU_VAR(kernel_stack),%rsp
>>         ENABLE_INTERRUPTS(CLBR_NONE)
>>         ALLOC_PTREGS_ON_STACK 8         /* +8: space for orig_ax */
>>         SAVE_C_REGS
>>         movq  %rax,ORIG_RAX(%rsp)
>>         movq  %rcx,RIP(%rsp)
>> +       movq  %r11,EFLAGS(%rsp)
>> +       movq PER_CPU_VAR(old_rsp),%rcx
>> +       movq %rcx,RSP(%rsp)
>>         ...
>> -       RESTORE_C_REGS_EXCEPT_RCX
>> +       RESTORE_C_REGS_EXCEPT_RCX_R11
>>         movq RIP(%rsp),%rcx
>> +       movq    EFLAGS(%rsp), %r11
>> -       movq    PER_CPU_VAR(old_rsp), %rsp
>> +       movq    RSP(%rsp), %rsp
>>       USERGS_SYSRET64
> 
> The sysret code still needs the inverse, right?

The part after "..." in my skecth is the sysret code.

> ptrace can change RSP.

By writing to pt_regs->rsp, yes. And the above code
will pick it up - we read RSP(%rsp).

>> Do we need to save rcx and r11 in "struct pt_regs" in their
>> "standard" slots, though?
> 
> ptrace probably wants it.

Let's see.
They don't contain any useful information:
With current code,
pt_regs->r11 is the same as pt_regs->rflags,
pt_regs->rcx is the same as pt_regs->rip (modulo weird store of -1).
So reading them by ptrace is... weird - just read
pt_regs->rflags or pt_regs->rip instead!

If ptrace is active, we'll return via iretq.
If ptrace wrote to these pt_regs members, on return
to userspace current code restores modified values.
My proposed change does not change this.

So, only ptrace reads of rcx and r11 will be affected.
Hmm. Maybe we can fill them only on "tracesys:" codepath?

>> Then old_rsp can be nuked everywhere else,
>> RESTORE_TOP_OF_STACK can be nuked, and
>> FIXUP_TOP_OF_STACK can be reduced to merely:
>>
>>         movq $__USER_DS,SS(%rsp)
>>         movq $__USER_CS,CS(%rsp)
> 
> Mmm, right.  That's probably better than doing this on the fast path.
> 
>>
>> (BTW, why currently it does "movq $-1,RCX+\offset(%rsp)?)
> 
> I would argue this is a bug.

Agree.

> (In fact, I have a patch floating around
> to fix it.  The current code is glitchy in a visible-to-user-space
> way.)  We should put rcx into both RIP and RCX, since the sysret path
> will implicitly do that, and we should restore the same register
> values in the iret and sysret paths.

