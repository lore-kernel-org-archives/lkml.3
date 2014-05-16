Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaEPKbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbaEPKbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:31:09 -0400
Message-ID: <5375E8E2.6000406@redhat.com>
Date: Fri, 16 May 2014 11:30:58 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Sergio Durigan Junior <sergiodj@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <52CEEF1F.90803@redhat.com> <20140110135802.GA26953@redhat.com> <m3sisk4rfq.fsf@redhat.com> <20140119152922.GA13689@redhat.com> <5373BACB.9090807@redhat.com> <5374D10A.1060905@redhat.com>
In-Reply-To: <5374D10A.1060905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 03:36 PM, Denys Vlasenko wrote:
> On 05/14/2014 08:49 PM, Pedro Alves wrote:
>> I realized now that I responded to this.  Sorry about that.
>>
>> On 01/19/2014 03:29 PM, Oleg Nesterov wrote:
>>> On 01/19, Sergio Durigan Junior wrote:
>>>>
>>>> On Friday, January 10 2014, Oleg Nesterov wrote:
>>>>
>>>>> So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
>>>>> executes the "syscall" insn. What it should report?
>>>> [...]
>>>>> But what should syscall-exit do? Should it still report SIGSEGV as
>>>>> it currently does, or should it report _SYSCALL_EXIT instead (if
>>>>> PTRACE_O_SYSCALL_EXIT of course), or should it report both?
>>>>
>>>> Both only if _SYSCALL_EXIT is set.  Otherwise, stick to the current
>>>> behavior, I guess.
>>>
>>> OK, both. In which order? Probably _EXIT first. But this looks a bit
>>> strange. Suppose that the tracee reports _EXIT, then debugger does
>>> ptrace(PTRACE_CONT), should the tracee report SIGTRAP?
>>
>> Seems to me that this should be very much the same as fork/vfork/clone
>> event handling.  Those are triggered by a syscall anyway.  So, say:
>>
>> - ptrace(PTRACE_SINGLESTEP)
>> - the tracee executes the "syscall" insn, and the syscall is "clone".
>> - PTRACE_EVENT_FORK is reported.
>> - The debugger does ptrace(PTRACE_CONT).
>>
>> What should be reported?  What is reported now?
> 
> Yes, PTRACE_SINGLESTEP looks ambiguous. Just like PTRACE_SYSCALL is.

Well, we just need to _define_ what should happen in these cases,
then it's no longer ambiguous.

I tried that out under GDB, using 3.14.3-200.fc20.x86_64 (Fedora 20),
_without_ Sérgio's patches.  Here's what I see.  All this is
with PTRACE_O_TRACEFORK enabled, of course.

#1 - Enter the syscall with PTRACE_SINGLESTEP, then PTRACE_SINGLESTEP

The first PTRACE_SINGLESTEP triggers the PTRACE_EVENT_FORK event.
We see that PTRACE_EVENT_FORK leaves the PC pointing after
the syscall instruction:

Dump of assembler code from 0x373bcbca6a to 0x373bcbca74:
   0x000000373bcbca6a <__libc_fork+170>:        syscall
=> 0x000000373bcbca6c <__libc_fork+172>:        cmp    $0xfffffffffffff000,%rax
   0x000000373bcbca72 <__libc_fork+178>:        ja     0x373bcbcbb6 <__libc_fork+502>

Then after the second PTRACE_SINGLESTEP, the kernel reports a trap with
the PC still pointing at the insn after the "syscall".  IOW, the PC
doesn't move, and the instruction after the "syscall" insn hasn't
been executed yet.  But the PC did move if we consider last time
the thread was resumed while it was running userspace code.  So,
the "syscall" insn is finally fully executed.  I think this is
reasonable.

#2 - Enter the syscall with PTRACE_SINGLESTEP, then PTRACE_CONTINUE

After the PTRACE_SINGLESTEP, the state is the same as in #1.
That is, PC points after "syscall".  The kernel reports no trap
for the latter PTRACE_CONTINUE, the process just continues
free until the next event.

#3 - Enter syscall with PTRACE_CONTINUE, then PTRACE_SINGLESTEP

Like in #1 and #2, we see that PTRACE_EVENT_FORK leaves the
PC pointing after the syscall instruction.  The latter
PTRACE_SINGLESTEP behaves just like in #1.  IOW, we get
a trap, but the PC doesn't move -- the "syscall" insn is
finally fully executed.

#4 - Enter syscall with PTRACE_CONTINUE, then PTRACE_CONTINUE

Same as #2.  IOW, no spurious trap.



So it doesn't really matter whether the process enters
the syscall through PTRACE_SINGLESTEP vs PTRACE_CONTINUE.
What matters is the last resumption.  At least from the
ptracer's perspective, the kernel doesn't "remember" that
the process was PTRACE_SINGLESTEP'd on entry to the syscall.

I think this is the most reasonable behavior, and the
simplest for a ptracer, and very much what I prefer for GDB.

If that last PTRACE_CONTINUE would instead report a SIGTRAP for
the previous PTRACE_SINGLESTEP, then the ptracer would need to
keep track of more state, for no good reason.  If the ptracer
really wants the ptracee to continue single-stepping as if
the fork/vfork/clone wasn't caught with a magic event, then
it just continues issuing PTRACE_SINGLESTEP.

Now I think PTRACE_EVENT_SYSCALL_{ENTER,EXIT} should behave
just the same.  That is, this is the sequence I expect:

  -> PTRACE_SINGLESTEP/PTRACE_CONTINUE over "syscall"
     <- PTRACE_EVENT_SYSCALL_ENTER
        -- PC points after "syscall"
  -> PTRACE_SINGLESTEP/PTRACE_CONTINUE
     <- PTRACE_EVENT_FORK
        -- PC points after "syscall"
  -> PTRACE_SINGLESTEP/PTRACE_CONTINUE
     <- PTRACE_EVENT_SYSCALL_EXIT
        -- PC points after "syscall"

And then after, either:

a) PTRACE_SINGLESTEP
     <- SIGTRAP
        -- PC points after "syscall"

b) PTRACE_CONTINUE
     <- *nothing*


Of course, skip the PTRACE_EVENT_FORK step in the middle
of the sequence if PTRACE_O_TRACEFORK is not enabled.

Thanks,
-- 
Pedro Alves

