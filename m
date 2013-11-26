Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3KZTZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:25:18 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11144 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab3KZTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:25:15 -0500
Message-ID: <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
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
Date: Tue, 26 Nov 2013 11:25:11 -0800
In-Reply-To: <20131126085256.GD789@laptop.programming.kicks-ass.net>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 09:52 +0100, Peter Zijlstra wrote:
> On Tue, Nov 26, 2013 at 12:12:31AM -0800, Davidlohr Bueso wrote:
> 
> > I am becoming hesitant about this approach. The following are some
> > results, from my quad-core laptop, measuring the latency of nthread
> > wakeups (1 at a time). In addition, failed wait calls never occur -- so
> > we don't end up including the (otherwise minimal) overhead of the list
> > queue+dequeue, only measuring the smp_mb() usage when !empty list never
> > occurs.
> > 
> > +---------+--------------------+--------+-------------------+--------+----------+
> > | threads | baseline time (ms) | stddev | patched time (ms) | stddev | overhead |
> > +---------+--------------------+--------+-------------------+--------+----------+
> > |     512 | 4.2410             | 0.9762 | 12.3660           | 5.1020 | +191.58% |
> > |     256 | 2.7750             | 0.3997 | 7.0220            | 2.9436 | +153.04% |
> > |     128 | 1.4910             | 0.4188 | 3.7430            | 0.8223 | +151.03% |
> > |      64 | 0.8970             | 0.3455 | 2.5570            | 0.3710 | +185.06% |
> > |      32 | 0.3620             | 0.2242 | 1.1300            | 0.4716 | +212.15% |
> > +---------+--------------------+--------+-------------------+--------+----------+
> > 
> 
> Whee, this is far more overhead than I would have expected... pretty
> impressive really for a simple mfence ;-)

*sigh* I just realized I had some extra debugging options in the .config
I ran for the patched kernel. This probably explains why the huge
overhead. I'll rerun and report shortly.

