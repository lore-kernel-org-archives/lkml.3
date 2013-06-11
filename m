Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3FKRxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:53:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:49133 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3FKRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:53:15 -0400
Message-ID: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Date: Tue, 11 Jun 2013 10:53:06 -0700
In-Reply-To: <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <1370911480.9844.160.camel@gandalf.local.home>
	 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 17:51 -0700, Linus Torvalds wrote:
> On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> > don't like trickssy, and we must find precccciouss!!!
> 
> .. and I personally have my usual reservations. I absolutely hate
> papering over scalability issues, and historically whenever people
> have ever thought that we want complex spinlocks, the problem has
> always been that the locking sucks.
> 
> So reinforced by previous events, I really feel that code that needs
> this kind of spinlock is broken and needs to be fixed, rather than
> actually introduce tricky spinlocks.
> 
> So in order to merge something like this, I want (a) numbers for real
> loads and (b) explanations for why the spinlock users cannot be fixed.

I hate to be the bearer of bad news but I got some pretty bad aim7
performance numbers with this patch on an 8-socket (80 core) 256 Gb
memory DL980 box against a vanilla 3.10-rc4 kernel:

* shared workload: 
10-100 users is in the noise area.
100-2000 users: -13% throughput.

* high_systime workload: 
10-700 users is in the noise area.
700-2000 users: -55% throughput.

* disk:
10-100 users -57% throughput.
100-1000 users: -25% throughput
1000-2000 users: +8% throughput (this patch only benefits when we have a
lot of concurrency).

* custom:
10-100 users: -33% throughput.
100-2000 users: -46% throughput.

* alltests:
10-1000 users is in the noise area.
1000-2000 users: -10% throughput.

One notable exception is the short workload where we actually see
positive numbers:
10-100 users: +40% throughput.
100-2000 users: +69% throughput.

Thanks,
Davidlohr

