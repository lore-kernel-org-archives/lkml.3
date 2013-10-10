Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3JJTPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:15:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60323 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3JJTPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:15:12 -0400
Date: Thu, 10 Oct 2013 12:15:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010191506.GR5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <CA+55aFx-JxRBbPa5EF1foZORpX_+o3T-qqm+1vh5Goa9znmOxA@mail.gmail.com>
 <20131010144327.5ded02ec@gandalf.local.home>
 <20131010185032.GS13848@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010185032.GS13848@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101019-7164-0000-0000-0000025899BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:50:32PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 10, 2013 at 02:43:27PM -0400, Steven Rostedt wrote:
> > On Thu, 10 Oct 2013 11:10:35 -0700
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >      .. now we can free all the percpu data and kill the CPU ..
> > > 
> > > without any locking anywhere - not stop-machine, not anything. If
> > > somebody is doing a "for_each_cpu()" (under just a regular
> > > rcu_read_lock()) and they see the bit set while it's going down, who
> > > cares? The CPU is still there, the data is accessible..
> > 
> > The problem is that rcu_read_lock() requires preemption disabled unless
> > you are using the preemptable rcu tree version. There's always
> > srcu_read_lock() but that's not so free. It's basically the same as
> > what Peter is doing.
> 
> No, srcu is actually more expensive in the fast path. Although possibly
> we could make SRCU more complex ;-)

Indeed.  Especially if we wanted to get rid of the memory barriers in
srcu_read_lock() and srcu_read_unlock() and still allow SRCU to be used
from idle and offline CPUs!  ;-)

							Thanx, Paul

> > There's places in the kernel that does for_each_cpu() that I'm sure you
> > don't want to disable preemption for. Especially when you start having
> > 4096 CPU machines!
> 
> :-)

But shouldn't you only have to disable over each separate pass through
the loop rather across the entire loop?  "I guarantee that the CPU I
just handed you will remain online through the body of the loop" rather
than "I guarantee that no CPU is going anywhere through the entire loop."

							Thanx, Paul

