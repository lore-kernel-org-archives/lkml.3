Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaI2SoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:44:02 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43496 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaI2SoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <5429A556.50507@fds-team.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
 <54299979.6080705@amacapital.net> <5429A556.50507@fds-team.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 11:43:38 -0700
Message-ID: <CALCETrUVYY8E+EcfZp6xjN60zwvNM9jPgi5bYjeUxE-Vhne6ow@mail.gmail.com>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
To: Sebastian Lackner <sebastian@fds-team.de>
Cc: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:30 AM, Sebastian Lackner
<sebastian@fds-team.de> wrote:
> On 29.09.2014 19:40, Andy Lutomirski wrote:
>> On 09/25/2014 12:42 PM, Anish Bhatt wrote:
>>> The MSR_SYSCALL_MASK, which is responsible for clearing specific EFLAGS on
>>>  syscall entry, should also clear the nested task (NT) flag to be safe from
>>>  userspace injection. Without this fix the application segmentation
>>>  faults on syscall return because of the changed meaning of the IRET
>>>  instruction.
>>>
>>> Further details can be seen here https://bugs.winehq.org/show_bug.cgi?id=33275
>>>
>>> Signed-off-by: Anish Bhatt <anish@chelsio.com>
>>> Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
>>> ---
>>>  arch/x86/kernel/cpu/common.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>>> index e4ab2b4..3126558 100644
>>> --- a/arch/x86/kernel/cpu/common.c
>>> +++ b/arch/x86/kernel/cpu/common.c
>>> @@ -1184,7 +1184,7 @@ void syscall_init(void)
>>>      /* Flags to clear on syscall */
>>>      wrmsrl(MSR_SYSCALL_MASK,
>>>             X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
>>> -           X86_EFLAGS_IOPL|X86_EFLAGS_AC);
>>> +           X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
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
> Well, the best documentation I've found is something like
> http://www.fermimn.gov.it/linux/quarta/x86/int.htm
>
> which states:
>
> --- snip ---
> INTERRUPT-TO-INNER-PRIVILEGE:
>    [...]
>    TF := 0;
>    NT := 0;
> --- snip ---
> (Doesn't say anything about HW interrupts though)
>
> This also makes sense at my opinion, since the interrupt handler has to know if it should return
> to the previous task (when NT=1) or to the same task (when NT=0).
>
>>
>> sysret doesn't appear to care about NT at all.
>>
>> So: the test code doesn't appear to do anything interesting *unless* it
>> goes through syscall followed by the iret exit path.  Then it receives
>> #GP on return, which turns into a signal.
>
> Yep, thats also my interpretation of this issue. If the processor would be in 32-bit/protected-mode the
> NT flag would be interpreted as a task return, and it would probably cause a different exception,
> because the kernel never uses the task link property of the TSS.
>
>>
>> On the premise that the slow and fast return paths ought to be
>> indistinguishable from userspace, I think we should fix this.  But I
>> want to understand it better first.
>
> A reliable way to force the slow return path is to use ptrace, see:
> http://lxr.free-electrons.com/source/arch/x86/kernel/entry_64.S#L544
>
> This also matches the experience: The test application only crashes with a small probability,
> except you use strace, then it will always crash (because the kernel forces the slow return path).
>
> Two additional remarks:
>
> * A reliable way to let it crash without strace, is to run the fork()/clone() syscall afterwards and
>   compile as 32-bit.
>
> * When you run exec*() afterwards, the crash will happen at the entry of the new executable. Doesn't
>   matter if the target process is SUID or not. I don't see a way to exploit this issue, though, but
>   probably some more people should take a look at it...
>
>>
>> Also, 32-bit may need more care here.
>
> That might be possible. It probably makes sense to review other parts of the code, for similar issues.

sysenter probably has the same problem.

--Andy
