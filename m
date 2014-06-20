Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFTOfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:35:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaFTOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:35:30 -0400
Date: Fri, 20 Jun 2014 16:35:26 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140620143525.GB8769@pathway.suse.cz>
References: <20140619213329.478113470@goodmis.org>
 <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
 <20140619185810.4137e14b@gandalf.local.home>
 <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
 <20140619191923.1365850a@gandalf.local.home>
 <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
 <20140619193635.1949b469@gandalf.local.home>
 <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-20 01:38:59, Jiri Kosina wrote:
> On Thu, 19 Jun 2014, Steven Rostedt wrote:
> 
> > > I don't think there is a need for a global stop_machine()-like 
> > > synchronization here. The printing CPU will be sending IPI to the CPU N+1 
> > > only after it has finished printing CPU N stacktrace.
> > 
> > So you plan on sending an IPI to a CPU then wait for it to acknowledge
> > that it is spinning, and then print out the data and then tell the CPU
> > it can stop spinning?
> 
> Yes, that was exactly my idea. You have to be synchronized with the CPU 
> receiving the NMI anyway in case you'd like to get its pt_regs and dump 
> those as part of the dump.

This approach did not work after all. There was still the same
race. If we stop a CPU in the middle of printk(), it does not help
to move the printing task to another CPU ;-) We would need to
make a copy of regs and all the stacks to unblock the CPU.

Hmm, in general, if we want a consistent snapshot, we need to temporary store
the information in NMI context and put it into the main ring buffer
in normal context. We either need to copy stacks or copy the printed text.


I start to like Steven's solution with the trace_seq buffer. I see the
following advantages:

    + the snapshot is pretty good;
	+ we still send NMI to all CPUs at the "same" time

    + only minimal time is spent in NMI context;
	+ CPUs are not blocked by each other to get sequential output

    + minimum of new code
	+ trace_seq buffer is already implemented and used
	+ it might be even better after getting attention from new users


Of course, it has also some disadvantages:

   + needs quite big per-CPU buffer;
	+ but we would need some extra space to copy the data anyway

   + trace might be shrunken;
	+ but 1 page should be enough in most cases;
	+ we could make it configurable

   + delay until the message appears in the ringbuffer and console
	+ better than freezing
	+ still saved in core file
	+ crash tool could get improved to find the traces


Note that the above solution solves only printing of the stack.
There are still other locations when printk is called in NMI
context. IMHO, some of them are helpful:

    ./arch/x86/kernel/nmi.c:                        WARN(in_nmi(),
    ./arch/x86/mm/kmemcheck/kmemcheck.c:    WARN_ON_ONCE(in_nmi());
    ./arch/x86/mm/fault.c:  WARN_ON_ONCE(in_nmi());
    ./arch/x86/mm/fault.c:  WARN_ON_ONCE(in_nmi());

    ./mm/vmalloc.c: BUG_ON(in_nmi());
    ./lib/genalloc.c:       BUG_ON(in_nmi());
    ./lib/genalloc.c:       BUG_ON(in_nmi());
    ./include/linux/hardirq.h:              BUG_ON(in_nmi());

And some are probably less important:

    ./arch/x86/platform/uv/uv_nmi.c   several locations here
    ./arch/m68k/mac/macints.c-              printk("... pausing, press NMI to resume ...");


Well, there are only few. Maybe, we could share the trace_seq buffer
here.

Of course, there is still the possibility to implement a lockless
buffer. But it will be much more complicated than the current one.
I am not sure that we really want it.


Best Regards,
Petr
