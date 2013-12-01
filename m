Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3LAEhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 23:37:41 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23156 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3LAEhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 23:37:40 -0500
Message-ID: <1385872653.17749.13.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 30 Nov 2013 20:37:33 -0800
In-Reply-To: <20131128115946.GD13532@twins.programming.kicks-ass.net>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
	 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
	 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
	 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
	 <20131128115946.GD13532@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 12:59 +0100, Peter Zijlstra wrote:
> On Wed, Nov 27, 2013 at 11:44:38PM -0800, Davidlohr Bueso wrote:
> > How about both enlarging the table _and_ aligning the buckets? As you
> > know, increasing the size of the table also benefits (particularly in
> > larger systems) in having more spinlocks. So we reduce the amount of
> > collisions and alleviate contention on the hb->lock. Btw, do you have
> > any particular concerns about the larger hash table patch? 
> 
> My only concern was the amount of #ifdef.
> 
> Wouldn't something like the below also work?

Below are the results for a workload that stresses the uaddr hashing for
large amounts of futexes (just make waits fail the uval check, so no
list handing overhead) on an 80 core, 1Tb NUMA system.

+---------+--------------------+------------------------+-----------------------+-------------------------------+
| threads | baseline (ops/sec) | aligned-only (ops/sec) | large table (ops/sec) | large table+aligned (ops/sec) |
+---------+--------------------+------------------------+-----------------------+-------------------------------+
|     512 |              32426 | 50531  (+55.8%)        | 255274  (+687.2%)     | 292553  (+802.2%)             |
|     256 |              65360 | 99588  (+52.3%)        | 443563  (+578.6%)     | 508088  (+677.3%)             |
|     128 |             125635 | 200075 (+59.2%)        | 742613  (+491.1%)     | 835452  (+564.9%)             |
|      80 |             193559 | 323425 (+67.1%)        | 1028147 (+431.1%)     | 1130304 (+483.9%)             |
|      64 |             247667 | 443740 (+79.1%)        | 997300  (+302.6%)     | 1145494 (+362.5%)             |
|      32 |             628412 | 721401 (+14.7%)        | 965996  (+53.7%)      | 1122115 (+78.5%)              |
+---------+--------------------+------------------------+-----------------------+-------------------------------+

Baseline of course sucks compared to any other performance boost, and we
get the best throughput when applying both optimizations, no surprise.
We do particularly well for more than 32 threads, and the 'aligned-only'
column nicely exemplifies the benefits of SMP aligning the buckets
without considering the reduction in collisions.

Thanks,
Davidlohr

