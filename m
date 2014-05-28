Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaE1VP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:15:29 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:36123 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE1VP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <53864E91.4060207@linux.intel.com>
References: <1401279583-1027-1-git-send-email-pkern@google.com>
 <53864B66.8030100@amacapital.net> <53864E91.4060207@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 14:15:07 -0700
Message-ID: <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Philipp Kern <pkern@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 2:01 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 05/28/2014 01:47 PM, Andy Lutomirski wrote:
>> On 05/28/2014 05:19 AM, Philipp Kern wrote:
>>> audit_filter_syscall uses the syscall number to reference into a
>>> bitmask (e->rule.mask[word]). Not removing the x32 bit before passing
>>> the number to this architecture independent codepath will fail to
>>> lookup the proper audit bit. Furthermore it will cause an invalid memory
>>> access in the kernel if the out of bound location is not mapped:
>>>
>>>   BUG: unable to handle kernel paging request at ffff8800e5446630
>>>   IP: [<ffffffff810fcdd0>] audit_filter_syscall+0x90/0xf0
>>>
>>> Together with the entrypoint in entry_64.S this change causes x32
>>> programs to pass in both AUDIT_ARCH_X86_64 and AUDIT_ARCH_I386 depending
>>> on the syscall path.
>>>
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: H. J. Lu <hjl.tools@gmail.com>
>>> Cc: Eric Paris <eparis@redhat.com>
>>> Signed-off-by: Philipp Kern <pkern@google.com>
>>> ---
>>>  arch/x86/kernel/ptrace.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
>>> index 678c0ad..166a3c7 100644
>>> --- a/arch/x86/kernel/ptrace.c
>>> +++ b/arch/x86/kernel/ptrace.c
>>> @@ -1489,7 +1489,7 @@ long syscall_trace_enter(struct pt_regs *regs)
>>>
>>>      if (IS_IA32)
>>>              audit_syscall_entry(AUDIT_ARCH_I386,
>>> -                                regs->orig_ax,
>>> +                                regs->orig_ax & __SYSCALL_MASK,
>>
>> This is weird.  Three questions:
>>
>> 1. How can this happen?  I thought that x32 syscalls always came in
>> through the syscall path, which doesn't set is_compat_task.  (Can
>> someone rename is_compat_task to in_compat_syscall?  Pretty please?)
>
> The SYSCALL path doesn't set TS_COMPAT, but is_compat_task() looks both
> as TS_COMPAT and bit 30 of orig_ax.
>
> I think what is really needed here is IS_IA32 should use is_ia32_task()
> instead, and *that* is the context we can mask off the x32 bit in at
> all.  However, does audit not need that information?

This is thoroughly fscked up.

What *should* have happened is that there should have been an
AUDIT_ARCH_X32.  Unfortunately no one caught that in time, so the
current enshrined ABI is that, as far as seccomp is concerned, x32 is
AUDIT_ARCH_X86_64 (see syscall_get_arch) but nr has the x32 bit set.

But the audit code is different: x32 is AUDIT_ARCH_I386 and the x32
bit is set.  This may be changeable, since fixes to the audit ABI may
not break anything.  Can we just use syscall_get_arch to determine the
token to pass to the audit code?

If it makes everyone feel better, I think that every single
architecture has screwed this up.  We actually had to prevent seccomp
and audit from being configured in on any OABI-supporting ARM kernel,
and MIPS almost did the same thing that x32 did.  We caught that one
on time, and it's now fixed in Linus' tree.

>
> (And why the frakk does audit receive the first four syscall arguments?
>  Audit seems like the worst turd ever...)

If you ever benchmark the performance impact of merely running auditd,
you might have to upgrade that insult :-/

>
>> 2. Now audit can't tell whether a syscall is x32 or i386.  And audit is
>> inconsistent with seccomp.  This seems wrong.
>
> This is completely and totally bogus, indeed.

I'd suggest just fixing the bug in auditsc.c.

>
>> 3. The OOPS you're fixing doesn't seem like it's fixed.  What if some
>> other random high bits are set?
>
> There is a range check in entry_*.S for the system call.

I can imagine that causing a certain amount of confusion to fancy
seccomp users.  Oh, well.  No one that I know of has complained yet.

--Andy
