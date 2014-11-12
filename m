Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaKLXSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:18:10 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:48997 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaKLXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141112220058.GA5295@redhat.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Nov 2014 15:17:45 -0800
Message-ID: <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: Oleg Nesterov <oleg@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 2:00 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Andy,
>
> As I said many times I do not understand asm ;) so most probably I missed
> something but let me ask anyway.

You must be the most competent non-asm-speaking asm reviewer in the world :)

>
> On 11/11, Andy Lutomirski wrote:
>>
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1064,6 +1064,9 @@ ENTRY(\sym)
>>       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>>
>>       .if \paranoid
>> +     CFI_REMEMBER_STATE
>> +     testl $3, CS(%rsp)              /* If coming from userspace, switch */
>> +     jnz 1f                          /* stacks. */
>>       call save_paranoid
>>       .else
>>       call error_entry
>> @@ -1104,6 +1107,36 @@ ENTRY(\sym)
>>       jmp error_exit                  /* %ebx: no swapgs flag */
>>       .endif
>>
>> +     .if \paranoid
>> +     CFI_RESTORE_STATE
>> +     /*
>> +      * Paranoid entry from userspace.  Switch stacks and treat it
>> +      * as a normal entry.  This means that paranoid handlers
>> +      * run in real process context if user_mode(regs).
>> +      */
>> +1:
>> +     call error_entry
>> +
>> +     DEFAULT_FRAME 0
>> +
>> +     movq %rsp,%rdi                  /* pt_regs pointer */
>> +     call sync_regs
>
> Can't we simplify sync_regs() then?

Yes.  Will do.

>
>> @@ -1324,8 +1357,6 @@ ENTRY(paranoid_exit)
>>       TRACE_IRQS_OFF_DEBUG
>>       testl %ebx,%ebx                         /* swapgs needed? */
>>       jnz paranoid_restore
>> -     testl $3,CS(%rsp)
>> -     jnz   paranoid_userspace
>>  paranoid_swapgs:
>
> Looks like this label can die.
>

Yes.

>> -paranoid_userspace:
>> -     GET_THREAD_INFO(%rcx)
>> -     movl TI_flags(%rcx),%ebx
>> -     andl $_TIF_WORK_MASK,%ebx
>> -     jz paranoid_swapgs
>> -     movq %rsp,%rdi                  /* &pt_regs */
>> -     call sync_regs
>> -     movq %rax,%rsp                  /* switch stack for scheduling */
>> -     testl $_TIF_NEED_RESCHED,%ebx
>> -     jnz paranoid_schedule
>> -     movl %ebx,%edx                  /* arg3: thread flags */
>> -     TRACE_IRQS_ON
>> -     ENABLE_INTERRUPTS(CLBR_NONE)
>> -     xorl %esi,%esi                  /* arg2: oldset */
>> -     movq %rsp,%rdi                  /* arg1: &pt_regs */
>> -     call do_notify_resume
>
> So, before this patch we use _TIF_WORK_MASK to decide if we need to call
> do_notify_resume().
>
> After this patch we jump to error_exit and it checks the same _TIF_WORK_MASK.
> But note that retint_careful->retint_careful checks another mask,
> _TIF_DO_NOTIFY_MASK.
>
> So it seems to me we can miss (say) TIF_UPROBE after int3 handler, no?

Only if we didn't call uprobe_deny_signal.  Presumably the
TIF_NOTIFY_RESUME got added there because it didn't work on x86 due to
exactly this issue.

>
> Yes, even _if_ I am right we should blame these masks, _TIF_DO_NOTIFY_MASK
> should probably include _TIF_UPROBE (and afaics in this case we can remove
> set_thread_flag(TIF_NOTIFY_RESUME) in uprobe_deny_signal()).

Ugh, yes.  I'll fix that with a separate patch.  Fortunately, the
other uprobe architectures seem to be okay.

>
> And in any case, can't we cleanup _TIF_WORK_MASK and _TIF_ALLWORK_MASK?
> IMHO, they should clearly define which bits we want to check.

Almost certainly.  I'll leave that for another day, though.

v2 coming soon with these changes and some additional comment cleanups.

--Andy
