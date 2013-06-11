Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3FKSrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:47:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38102 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3FKSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:47:05 -0400
Date: Tue, 11 Jun 2013 11:46:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?utf-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611184647.GV5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
 <1370974231.9844.212.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370974231.9844.212.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061118-5518-0000-0000-00000F8C7993
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 02:10:31PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 10:53 -0700, Davidlohr Bueso wrote:
> 
> > I hate to be the bearer of bad news but I got some pretty bad aim7
> > performance numbers with this patch on an 8-socket (80 core) 256 Gb
> > memory DL980 box against a vanilla 3.10-rc4 kernel:
> 
> This doesn't surprise me as the spin lock now contains a function call
> on any contention. Not to mention the added i$ pressure on the embedded
> spinlock code having to setup a function call.
> 
> Even if the queues are not used, it adds a slight overhead to all
> spinlocks, due to the code size increase as well as a function call on
> all contention, which will also have an impact on i$ and branch
> prediction.

Was this system hyperthreaded?  If so, it might be suffering from the
misplaced cpu_relax(), which would mean that hardware threads spinning
on the lock would fail to inform the CPU that it was not doing anything
useful.

							Thanx, Paul

> > * shared workload: 
> > 10-100 users is in the noise area.
> > 100-2000 users: -13% throughput.
> > 
> > * high_systime workload: 
> > 10-700 users is in the noise area.
> > 700-2000 users: -55% throughput.
> > 
> > * disk:
> > 10-100 users -57% throughput.
> > 100-1000 users: -25% throughput
> > 1000-2000 users: +8% throughput (this patch only benefits when we have a
> 
> Perhaps this actually started using the queues?
> 
> > lot of concurrency).
> > 
> > * custom:
> > 10-100 users: -33% throughput.
> > 100-2000 users: -46% throughput.
> > 
> > * alltests:
> > 10-1000 users is in the noise area.
> > 1000-2000 users: -10% throughput.
> > 
> > One notable exception is the short workload where we actually see
> > positive numbers:
> > 10-100 users: +40% throughput.
> > 100-2000 users: +69% throughput.
> 
> Perhaps short work loads have a cold cache, and the impact on cache is
> not as drastic?
> 
> It would be interesting to see what perf reports on these runs.
> 
> -- Steve
> 
> 

