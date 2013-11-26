Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab3KZUvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:51:33 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:46859 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3KZUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:51:29 -0500
Message-ID: <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
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
Date: Tue, 26 Nov 2013 12:51:25 -0800
In-Reply-To: <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
	 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 11:25 -0800, Davidlohr Bueso wrote:
> On Tue, 2013-11-26 at 09:52 +0100, Peter Zijlstra wrote:
> > On Tue, Nov 26, 2013 at 12:12:31AM -0800, Davidlohr Bueso wrote:
> > 
> > > I am becoming hesitant about this approach. The following are some
> > > results, from my quad-core laptop, measuring the latency of nthread
> > > wakeups (1 at a time). In addition, failed wait calls never occur -- so
> > > we don't end up including the (otherwise minimal) overhead of the list
> > > queue+dequeue, only measuring the smp_mb() usage when !empty list never
> > > occurs.
> > > 
> > > +---------+--------------------+--------+-------------------+--------+----------+
> > > | threads | baseline time (ms) | stddev | patched time (ms) | stddev | overhead |
> > > +---------+--------------------+--------+-------------------+--------+----------+
> > > |     512 | 4.2410             | 0.9762 | 12.3660           | 5.1020 | +191.58% |
> > > |     256 | 2.7750             | 0.3997 | 7.0220            | 2.9436 | +153.04% |
> > > |     128 | 1.4910             | 0.4188 | 3.7430            | 0.8223 | +151.03% |
> > > |      64 | 0.8970             | 0.3455 | 2.5570            | 0.3710 | +185.06% |
> > > |      32 | 0.3620             | 0.2242 | 1.1300            | 0.4716 | +212.15% |
> > > +---------+--------------------+--------+-------------------+--------+----------+
> > > 
> > 
> > Whee, this is far more overhead than I would have expected... pretty
> > impressive really for a simple mfence ;-)
> 
> *sigh* I just realized I had some extra debugging options in the .config
> I ran for the patched kernel. This probably explains why the huge
> overhead. I'll rerun and report shortly.

I'm very sorry about the false alarm -- after midnight my brain starts
to melt. After re-running everything on my laptop (yes, with the
correct .config file), I can see that the differences are rather minimal
and variation also goes down, as expected. I've also included the
results for the original atomic ops approach, which mostly measures the
atomic_dec when we dequeue the woken task. Results are in the noise
range and virtually the same for both approaches (at least on a smaller
x86_64 system).

+---------+-----------------------------+----------------------------+------------------------------+
| threads | baseline time (ms) [stddev] | barrier time (ms) [stddev] | atomicops time (ms) [stddev] |
+---------+-----------------------------+----------------------------+------------------------------+
|     512 | 2.8360 [0.5168]             | 4.4100 [1.1150]            | 3.8150 [1.3293]              |
|     256 | 2.5080 [0.6375]             | 2.3070 [0.5112]            | 2.5980 [0.9079]              |
|     128 | 1.0200 [0.4264]             | 1.3980 [0.3391]            | 1.5180 [0.4902]              |
|      64 | 0.7890 [0.2667]             | 0.6970 [0.3374]            | 0.4020 [0.2447]              |
|      32 | 0.1150 [0.0184]             | 0.1870 [0.1428]            | 0.1490 [0.1156]              |
+---------+-----------------------------+----------------------------+------------------------------+

FYI I've uploaded the test program:
https://github.com/davidlohr/futex-stress/blob/master/futex_wake.c

I will now start running bigger, more realistic, workloads like the ones
described in the original patchset to get the big picture.

Thanks,
Davidlohr

