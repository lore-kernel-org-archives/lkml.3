Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaFXNcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:32:18 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42369 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFXNcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:32:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140620143525.GB8769@pathway.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
	<20140619185810.4137e14b@gandalf.local.home>
	<alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
	<20140619191923.1365850a@gandalf.local.home>
	<alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
	<20140619193635.1949b469@gandalf.local.home>
	<alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
	<20140620143525.GB8769@pathway.suse.cz>
Date: Tue, 24 Jun 2014 17:32:15 +0400
Message-ID: <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: =?UTF-8?B?UGV0ciBNbMOhZGVr?= <pmladek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 6:35 PM, Petr Mládek <pmladek@suse.cz> wrote:
> On Fri 2014-06-20 01:38:59, Jiri Kosina wrote:
>> On Thu, 19 Jun 2014, Steven Rostedt wrote:
>>
>> > > I don't think there is a need for a global stop_machine()-like
>> > > synchronization here. The printing CPU will be sending IPI to the CPU N+1
>> > > only after it has finished printing CPU N stacktrace.
>> >
>> > So you plan on sending an IPI to a CPU then wait for it to acknowledge
>> > that it is spinning, and then print out the data and then tell the CPU
>> > it can stop spinning?
>>
>> Yes, that was exactly my idea. You have to be synchronized with the CPU
>> receiving the NMI anyway in case you'd like to get its pt_regs and dump
>> those as part of the dump.
>
> This approach did not work after all. There was still the same
> race. If we stop a CPU in the middle of printk(), it does not help
> to move the printing task to another CPU ;-) We would need to
> make a copy of regs and all the stacks to unblock the CPU.
>
> Hmm, in general, if we want a consistent snapshot, we need to temporary store
> the information in NMI context and put it into the main ring buffer
> in normal context. We either need to copy stacks or copy the printed text.
>
>
> I start to like Steven's solution with the trace_seq buffer. I see the
> following advantages:
>
>     + the snapshot is pretty good;
>         + we still send NMI to all CPUs at the "same" time
>
>     + only minimal time is spent in NMI context;
>         + CPUs are not blocked by each other to get sequential output
>
>     + minimum of new code
>         + trace_seq buffer is already implemented and used
>         + it might be even better after getting attention from new users
>
>
> Of course, it has also some disadvantages:
>
>    + needs quite big per-CPU buffer;
>         + but we would need some extra space to copy the data anyway
>
>    + trace might be shrunken;
>         + but 1 page should be enough in most cases;
>         + we could make it configurable
>
>    + delay until the message appears in the ringbuffer and console
>         + better than freezing
>         + still saved in core file
>         + crash tool could get improved to find the traces
>
>
> Note that the above solution solves only printing of the stack.
> There are still other locations when printk is called in NMI
> context. IMHO, some of them are helpful:
>
>     ./arch/x86/kernel/nmi.c:                        WARN(in_nmi(),
>     ./arch/x86/mm/kmemcheck/kmemcheck.c:    WARN_ON_ONCE(in_nmi());
>     ./arch/x86/mm/fault.c:  WARN_ON_ONCE(in_nmi());
>     ./arch/x86/mm/fault.c:  WARN_ON_ONCE(in_nmi());
>
>     ./mm/vmalloc.c: BUG_ON(in_nmi());
>     ./lib/genalloc.c:       BUG_ON(in_nmi());
>     ./lib/genalloc.c:       BUG_ON(in_nmi());
>     ./include/linux/hardirq.h:              BUG_ON(in_nmi());
>
> And some are probably less important:
>
>     ./arch/x86/platform/uv/uv_nmi.c   several locations here
>     ./arch/m68k/mac/macints.c-              printk("... pausing, press NMI to resume ...");
>
>
> Well, there are only few. Maybe, we could share the trace_seq buffer
> here.
>
> Of course, there is still the possibility to implement a lockless
> buffer. But it will be much more complicated than the current one.
> I am not sure that we really want it.

Let me join the discussion.
In the past I've implemented similar feature for x86 in openvz kernel
and now I'm thinking about it for arm.

Originally I thought that seizing all cpus one by one and printing
from the initiator
is a best approach and I've started preparing arguments against
over-engineered printk...
But it seems deferring printk output isn't that bad idea, it much
easier and arch-independent.
Saving context is very arch-specific. Printing is a problem too:
show_regs() is a horrible mess,
on most arches it always prints something from current context. I'm
thinking about cleaning this
mess, but doing this for all arches takes some time for sure.

Instead of per-cpu buffers printk might use part of existing ring
buffer  -- initiator cpu allocates space for
target cpu and flushes it into common stream after it finish printing.
Probably this kind of transactional model might be used on single cpu
for multi-line KERN_CONT.

>
>
> Best Regards,
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
