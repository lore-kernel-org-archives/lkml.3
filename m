Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaKUWTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:19:42 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:47971 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKUWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:19:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141121220704.GU5050@linux.vnet.ibm.com>
References: <cover.1416604491.git.luto@amacapital.net> <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
 <CALCETrXLq1y7e_dKFPgou-FKHB6Pu-r8+t-6Ds+8=va7anBWDA@mail.gmail.com> <20141121220704.GU5050@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 14:19:17 -0800
Message-ID: <CALCETrXVRqZ2fJJNOWLFzhE7wQvWejXbw0OUpcm6rt_UdFP6CA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 2:07 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Nov 21, 2014 at 01:32:50PM -0800, Andy Lutomirski wrote:
>> On Fri, Nov 21, 2014 at 1:26 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > We currently pretend that IST context is like standard exception
>> > context, but this is incorrect.  IST entries from userspace are like
>> > standard exceptions except that they use per-cpu stacks, so they are
>> > atomic.  IST entries from kernel space are like NMIs from RCU's
>> > perspective -- they are not quiescent states even if they
>> > interrupted the kernel during a quiescent state.
>> >
>> > Add and use ist_enter and ist_exit to track IST context.  Even
>> > though x86_32 has no IST stacks, we track these interrupts the same
>> > way.
>>
>> I should add:
>>
>> I have no idea why RCU read-side critical sections are safe inside
>> __do_page_fault today.  It's guarded by exception_enter(), but that
>> doesn't do anything if context tracking is off, and context tracking
>> is usually off. What am I missing here?
>
> Ah!  There are three cases:
>
> 1.      Context tracking is off on a non-idle CPU.  In this case, RCU is
>         still paying attention to CPUs running in both userspace and in
>         the kernel.  So if a page fault happens, RCU will be set up to
>         notice any RCU read-side critical sections.
>
> 2.      Context tracking is on on a non-idle CPU.  In this case, RCU
>         might well be ignoring userspace execution: NO_HZ_FULL and
>         all that.  However, as you pointed out, in this case the
>         context-tracking code lets RCU know that we have entered the
>         kernel, which means that RCU will again be paying attention to
>         RCU read-side critical sections.
>
> 3.      The CPU is idle.  In this case, RCU is ignoring the CPU, so
>         if we take a page fault when context tracking is off, life
>         will be hard.  But the kernel is not supposed to take page
>         faults in the idle loop, so this is not a problem.
>

I guess so, as long as there are really no page faults in the idle loop.

There are, however, machine checks in the idle loop, and maybe kprobes
(haven't checked), so I think this patch might fix real bugs.

> Just out of curiosity...  Can an NMI occur in IST context?  If it can,
> I need to make rcu_nmi_enter() and rcu_nmi_exit() deal properly with
> nested calls.

Yes, and vice versa.  That code looked like it handled nesting
correctly, but I wasn't entirely sure.

Also, just to make sure: are we okay if rcu_nmi_enter() is called
before exception_enter if context tracking is on and we came directly
from userspace?

--Andy
