Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaEOOhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbaEOOhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:37:07 -0400
Message-ID: <5374D10A.1060905@redhat.com>
Date: Thu, 15 May 2014 16:36:58 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Sergio Durigan Junior <sergiodj@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <52CEEF1F.90803@redhat.com> <20140110135802.GA26953@redhat.com> <m3sisk4rfq.fsf@redhat.com> <20140119152922.GA13689@redhat.com> <5373BACB.9090807@redhat.com>
In-Reply-To: <5373BACB.9090807@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 08:49 PM, Pedro Alves wrote:
> I realized now that I responded to this.  Sorry about that.
> 
> On 01/19/2014 03:29 PM, Oleg Nesterov wrote:
>> On 01/19, Sergio Durigan Junior wrote:
>>>
>>> On Friday, January 10 2014, Oleg Nesterov wrote:
>>>
>>>> So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
>>>> executes the "syscall" insn. What it should report?
>>> [...]
>>>> But what should syscall-exit do? Should it still report SIGSEGV as
>>>> it currently does, or should it report _SYSCALL_EXIT instead (if
>>>> PTRACE_O_SYSCALL_EXIT of course), or should it report both?
>>>
>>> Both only if _SYSCALL_EXIT is set.  Otherwise, stick to the current
>>> behavior, I guess.
>>
>> OK, both. In which order? Probably _EXIT first. But this looks a bit
>> strange. Suppose that the tracee reports _EXIT, then debugger does
>> ptrace(PTRACE_CONT), should the tracee report SIGTRAP?
>
> Seems to me that this should be very much the same as fork/vfork/clone
> event handling.  Those are triggered by a syscall anyway.  So, say:
> 
> - ptrace(PTRACE_SINGLESTEP)
> - the tracee executes the "syscall" insn, and the syscall is "clone".
> - PTRACE_EVENT_FORK is reported.
> - The debugger does ptrace(PTRACE_CONT).
> 
> What should be reported?  What is reported now?

Yes, PTRACE_SINGLESTEP looks ambiguous. Just like PTRACE_SYSCALL is.

I think we can take it further and add PTRACE_EVENT_SINGLESTEP too,
like the patches under discussing which add PTRACE_EVENT_SYSCALL_ENTER,EXIT
and therefore do away with the need to use ambiguous PTRACE_SYSCALL.

Such API is clearer (I hope) - as long as option is on,
user wants to get single-stepping SIGTRAPs after each insn,
including syscall insn (in this case, after we return to userspace).
