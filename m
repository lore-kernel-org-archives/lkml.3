Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3LBLBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:01:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:43559 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3LBLBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:01:31 -0500
Date: Mon, 2 Dec 2013 12:01:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
In-Reply-To: <1385872653.17749.13.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1312021200100.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de>  <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>  <20131126085256.GD789@laptop.programming.kicks-ass.net>  <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>  <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
  <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>  <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>  <20131128115946.GD13532@twins.programming.kicks-ass.net> <1385872653.17749.13.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Davidlohr Bueso wrote:
> On Thu, 2013-11-28 at 12:59 +0100, Peter Zijlstra wrote:
> > On Wed, Nov 27, 2013 at 11:44:38PM -0800, Davidlohr Bueso wrote:
> > > How about both enlarging the table _and_ aligning the buckets? As you
> > > know, increasing the size of the table also benefits (particularly in
> > > larger systems) in having more spinlocks. So we reduce the amount of
> > > collisions and alleviate contention on the hb->lock. Btw, do you have
> > > any particular concerns about the larger hash table patch? 
> > 
> > My only concern was the amount of #ifdef.
> > 
> > Wouldn't something like the below also work?
> 
> Below are the results for a workload that stresses the uaddr hashing for
> large amounts of futexes (just make waits fail the uval check, so no
> list handing overhead) on an 80 core, 1Tb NUMA system.
> 
> +---------+--------------------+------------------------+-----------------------+-------------------------------+
> | threads | baseline (ops/sec) | aligned-only (ops/sec) | large table (ops/sec) | large table+aligned (ops/sec) |
> +---------+--------------------+------------------------+-----------------------+-------------------------------+
> |     512 |              32426 | 50531  (+55.8%)        | 255274  (+687.2%)     | 292553  (+802.2%)             |
> |     256 |              65360 | 99588  (+52.3%)        | 443563  (+578.6%)     | 508088  (+677.3%)             |
> |     128 |             125635 | 200075 (+59.2%)        | 742613  (+491.1%)     | 835452  (+564.9%)             |
> |      80 |             193559 | 323425 (+67.1%)        | 1028147 (+431.1%)     | 1130304 (+483.9%)             |
> |      64 |             247667 | 443740 (+79.1%)        | 997300  (+302.6%)     | 1145494 (+362.5%)             |
> |      32 |             628412 | 721401 (+14.7%)        | 965996  (+53.7%)      | 1122115 (+78.5%)              |
> +---------+--------------------+------------------------+-----------------------+-------------------------------+
> 
> Baseline of course sucks compared to any other performance boost, and we
> get the best throughput when applying both optimizations, no surprise.
> We do particularly well for more than 32 threads, and the 'aligned-only'
> column nicely exemplifies the benefits of SMP aligning the buckets
> without considering the reduction in collisions.

Right. So yes, we want both. And I fully agree with Peters dynamic
allocation approach.

Thanks,

	tglx
