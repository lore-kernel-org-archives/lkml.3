Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaCEEpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:45:42 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25992 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaCEEpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:45:41 -0500
Message-ID: <1393994738.2512.48.camel@buesod1.americas.hpqcorp.net>
Subject: Re: futex funkiness -- massive lockups
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 20:45:38 -0800
In-Reply-To: <CA+55aFzRi+r4=8D+d5odaRMRNOWSY01ydsbreko7HNsD_Dg68Q@mail.gmail.com>
References: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzRi+r4=8D+d5odaRMRNOWSY01ydsbreko7HNsD_Dg68Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 19:36 -0800, Linus Torvalds wrote:
> On Tue, Mar 4, 2014 at 5:43 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> >
> > From the paths related to futex wait we are stuck when taking the hb
> > spinlock in futex_wait_setup >> queue_lock.
> 
> Just judging from your trace, I would have suspected a (possibly soft)
> lockup in load_balance() rather than the futexes.
> 
> The futex being stuck seems expected, since one cpu is definitely
> holding the lock - it was interrupted by a timer interrupt at the
> successful return case of raw_spin_lock if I read the offset right.
> 
> So if that softirq is stuck - perhaps because it's in some endless
> loop in load_balance(), or perhaps because it's spending so much time
> load-balancing that the next balancing time happens immediately, or
> whatever - then you'd see that trace.

That does make a lot of sense, and since this is a futex intense
workload, it would also explain why I'm seeing so many CPUs stuck
waiting for the lock in the futex wait paths, it's the same hash bucket
and it's stuck just doing the cmpxchg over and over again.

Unfortunately the machine code dump is missing in for the load balancing
bits so it's pretty hard to see right away where the trapping
instruction would occur.

Thanks!

