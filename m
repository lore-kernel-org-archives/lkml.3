Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbbAMXnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:43:12 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41428 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbbAMXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <CACZ9PQU6rAgSX3yRnSbUyk4GqJLtvpEKGQaqu_MDoWo_FB5A3g@mail.gmail.com>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
	<1420986751-30364-3-git-send-email-r.peniaev@gmail.com>
	<CAGXu5jLi=6QTzF_z9pFAeXQqLZPfSCcwZc+q-a7b-tKwwBo4vg@mail.gmail.com>
	<CACZ9PQU6rAgSX3yRnSbUyk4GqJLtvpEKGQaqu_MDoWo_FB5A3g@mail.gmail.com>
Date: Tue, 13 Jan 2015 15:43:09 -0800
X-Google-Sender-Auth: DEfQwtAKAnWlDsPJM6rscewJXcQ
Message-ID: <CAGXu5jL6_CQmi1RRP5JbiaDgUK77_sQ+pwghANLaRMkdGeMAzw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: entry-common,ptrace: do not pass scno to syscall_trace_enter
From: Kees Cook <keescook@chromium.org>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sekhar Nori <nsekhar@ti.com>, Andy Lutomirski <luto@amacapital.net>,
        Eric Paris <eparis@redhat.com>, Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 3:21 PM, Roman Peniaev <r.peniaev@gmail.com> wrote:
> On Wed, Jan 14, 2015 at 5:08 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Sun, Jan 11, 2015 at 6:32 AM, Roman Pen <r.peniaev@gmail.com> wrote:
>>> In previous patch current_thread_info()->syscall is set with
>>> corresponding syscall number prior to further calls, thus there
>>> is no any need to pass 'scno'.
>>>
>>> Also, add explicit comment why do we have to reread 'scno' local
>>> variable.
>>>
>>> Signed-off-by: Roman Pen <r.peniaev@gmail.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>> Cc: Sekhar Nori <nsekhar@ti.com>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>> Cc: Eric Paris <eparis@redhat.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  arch/arm/kernel/entry-common.S | 1 -
>>>  arch/arm/kernel/ptrace.c       | 6 ++++--
>>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>>> index 89452ff..3d12eb5 100644
>>> --- a/arch/arm/kernel/entry-common.S
>>> +++ b/arch/arm/kernel/entry-common.S
>>> @@ -228,7 +228,6 @@ ENDPROC(vector_swi)
>>>          * context switches, and waiting for our parent to respond.
>>>          */
>>>  __sys_trace:
>>> -       mov     r1, scno
>>>         add     r0, sp, #S_OFF
>>>         bl      syscall_trace_enter
>>>
>>> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
>>> index ef9119f..1238787 100644
>>> --- a/arch/arm/kernel/ptrace.c
>>> +++ b/arch/arm/kernel/ptrace.c
>>> @@ -928,9 +928,9 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>>         regs->ARM_ip = ip;
>>>  }
>>>
>>> -asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>>> +asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>>  {
>>> -       current_thread_info()->syscall = scno;
>>> +       int scno = current_thread_info()->syscall;
>>
>> Was this assignment of current_thread_info()->syscall redundant? If
>> so, this looks fine. If not, what will now be setting the thread_info?
>
> [sorry, i have to resend this email because previously I sent it using my phone
>  and arm maillist rejected it because of html inside]
>
> Yes, it is redundant.
> Because of the previous patch thread_info->syscall already contains
> corresponding scnr,
> so we use it instead of passing the same number from asm.

Ah! Okay, I wasn't CCed on the 1/2 patch. I see it now, thanks!

> So everything should work fine without current patch, and also current
> patch should not
> change anything in the expected behavior.

Great. If this still passes the seccomp testsuite, I'm fine for it. I
can test it later this week if no one else gets to it.

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

>
> --
> Roman
>
>
>
>
>>
>> -Kees
>>
>>>
>>>         /* Do the secure computing check first; failures should be fast. */
>>>  #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
>>> @@ -944,6 +944,8 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>>>         if (test_thread_flag(TIF_SYSCALL_TRACE))
>>>                 tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>>>
>>> +       /* Syscall can be aborted (-1 can be set) or even changed
>>> +        * by the tracer and subsequent PTRACE_SET_SYSCALL request */
>>>         scno = current_thread_info()->syscall;
>>>
>>>         if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>>> --
>>> 2.1.3
>>>
>>
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
