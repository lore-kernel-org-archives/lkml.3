Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaI2TI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:08:59 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38862 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaI2TI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
 <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 12:08:35 -0700
Message-ID: <CALCETrXnzh=E=m+Q3zeT66xKkPbn6K8xfDti54PXVtA+0iqoGQ@mail.gmail.com>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, sebastian@fds-team.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 29 Sep 2014, Andy Lutomirski wrote:
>> On 09/25/2014 12:42 PM, Anish Bhatt wrote:
>> > The MSR_SYSCALL_MASK, which is responsible for clearing specific EFLAGS on
>> >  syscall entry, should also clear the nested task (NT) flag to be safe from
>> >  userspace injection. Without this fix the application segmentation
>> >  faults on syscall return because of the changed meaning of the IRET
>> >  instruction.
>> >
>> > Further details can be seen here https://bugs.winehq.org/show_bug.cgi?id=33275
>> >
>> > Signed-off-by: Anish Bhatt <anish@chelsio.com>
>> > Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
>> > ---
>> >  arch/x86/kernel/cpu/common.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> > index e4ab2b4..3126558 100644
>> > --- a/arch/x86/kernel/cpu/common.c
>> > +++ b/arch/x86/kernel/cpu/common.c
>> > @@ -1184,7 +1184,7 @@ void syscall_init(void)
>> >     /* Flags to clear on syscall */
>> >     wrmsrl(MSR_SYSCALL_MASK,
>> >            X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
>> > -          X86_EFLAGS_IOPL|X86_EFLAGS_AC);
>> > +          X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
>>
>> Something's weird here, and at the very least the changelog is
>> insufficiently informative.
>>
>> The Intel SDM says:
>>
>> If the NT flag is set and the processor is in IA-32e mode, the IRET
>> instruction causes a general protection exception.
>>
>> Presumably interrupt delivery clears NT.  I haven't spotted where that's
>> documented yet.
>
> Nope, that's unrelated.
>
> See Volume 3, chapter 7.4 "Task linking":
>
> "The previous task link field of the TSS (sometimes called the
>  “backlink”) and the NT flag in the EFLAGS register are used to return
>  execution to the previous task. EFLAGS.NT = 1 indicates that the
>  currently executing task is nested within the execution of another
>  task.
>
>  When a CALL instruction, an interrupt, or an exception causes a task
>  switch: the processor copies the segment selector for the current TSS
>  to the previous task link field of the TSS for the new task; it then
>  sets EFLAGS.NT = 1.  If software uses an IRET instruction to suspend
>  the new task, the processor checks for EFLAGS.NT = 1; it then uses the
>  value in the previous task link field to return to the previous
>  task. See Figures 7-8."
>
> Now, Linux does not care about that. Thread management is done purely
> in software. So nothing uses and nothing can use the TSS backlink and
> NT mode.
>
> In IA-32e mode a IRET seing EFLAGS.NT=1 will cause #GP. In non IA-32e
> mode it would simply explode by returning to TSS.back_link, which is
> reliably NULL.
>
> So there is nothing to see here other than the stupid user space task
> fiddling with the NT flag being killed rightfully.

Except that we're exposing ourselves to security issues.  I don't see
any off the top of my head, but what if an unprivileged or
semi-privileged process sets NT, does syscall or sysenter, and causes
the kernel to jump to EFI code?  Or, hell, what if there's something
in the kernel that fakes interrupt delivery and blows up on return?
Or what if we're running in kernel mode with NT set and we take an NMI
or even a nested NMI?  What happens if we have NT set in kernel mode
and enter a VM?

I think it's absurd that you can set NT at all from CPL3 in long mode,
but we should at least try to be graceful about it.

I don't know of any actual bugs here, but fixing this (at least for
syscall) will have absolutely no performance impact.

--Andy
