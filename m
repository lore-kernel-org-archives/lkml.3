Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3FKSO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:14:26 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5635 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3FKSOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:14:24 -0400
Message-ID: <1370974461.1744.13.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?Q?=E8=B5=96=E6=B1=9F=E5=B1=B1?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Date: Tue, 11 Jun 2013 11:14:21 -0700
In-Reply-To: <1370974231.9844.212.camel@gandalf.local.home>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <1370911480.9844.160.camel@gandalf.local.home>
	 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	 <1370974231.9844.212.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 14:10 -0400, Steven Rostedt wrote:
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

Agreed.

> > 
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

I didn't actually collect perf traces in this run but I will rerun it
with that in mind. I'm also running some OLTP and data mining Oracle
based benchmarks where I'm already collecting perf reports.

Will post when I have everything.

Thanks,
Davidlohr


