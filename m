Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3IXIST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:18:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57956 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3IXISQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:18:16 -0400
Message-ID: <1380010613.5443.40.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>
Date: Tue, 24 Sep 2013 18:16:53 +1000
In-Reply-To: <20130924080436.GH9326@twins.programming.kicks-ass.net>
References: <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	 <1379981427.5443.8.camel@pasglop>
	 <CA+55aFwyVG4DXOEvaVTp0gE-H2Zy0Kx7Mg7RWzpxzwm_RSWEYQ@mail.gmail.com>
	 <1379987527.5443.20.camel@pasglop>
	 <20130924080436.GH9326@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 10:04 +0200, Peter Zijlstra wrote:
> On Tue, Sep 24, 2013 at 11:52:07AM +1000, Benjamin Herrenschmidt wrote:
> > So if that holds, we have a solid way to do per-cpu. On one side, I tend
> > to think that r13 being task/thread/thread_info is probably a better
> > overall choice, I'm worried that going in a different direction than x86
> > means generic code will get "tuned" to use per-cpu for performance
> > critical stuff rather than task/thread/thread_info in inflexible ways.
> 
> The plus side of per-cpu over per-task is that one typically has a lot
> less cpus than tasks. Also, its far easier/cheaper to iterate cpus than
> it is to iterate tasks.

I don't see how that relates to the above though... ie, how the number
of CPUs vs. tasks and the relative ease of iteration relates to how fast
we access the "current" cpu and the "current" task ?

The thing is, if I use r13 as "current" (and put thread_info in the task
struct), virtually *all* my accesses to task, thread and thread_info
structs become a single load or store instruction from r13.

On the other hand, access to "my_cpu_offset" for per-cpu remains (since
that's what we do today already) a load to get the offset an an addition
+ access. (ie, I would stash the cpu offset into the thread info and
context switch it).

If I use r13 as "my_cpu_offset", then I might be able to skip a load for
per-cpu accesses to the current cpu, making them a bit faster, but add
an indirection for "current" and thread_info.

It's basically a question of where do I put the extra load and what has
the bigger net benefit. I tend to think we access "current" a LOT more
than per-cpu but I might be wrong.

Additionally, using r13 for "current" removes all the problems with gcc
copying the value accross preempt_disable/enable etc... while using it
as per-cpu means they remain. We think we have a fix (which will involve
a special preempt_barrier() added to preempt_disable/enable and irq
enable/disable), but it's still not as nice as "the problem just doesn't
exist" :-)

Cheers,
Ben.


