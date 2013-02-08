Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947315Ab3BHWsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:48:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57211 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947294Ab3BHWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:48:08 -0500
Date: Fri, 8 Feb 2013 14:47:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, tglx@linutronix.de, peterz@infradead.org,
        oleg@redhat.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com
Subject: Re: [PATCH v5 04/45] percpu_rwlock: Implement the core design of
 Per-CPU Reader-Writer Locks
Message-ID: <20130208224742.GJ2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
 <20130122073347.13822.85876.stgit@srivatsabhat.in.ibm.com>
 <20130123185522.GG2373@mtj.dyndns.org>
 <51003B20.2060506@linux.vnet.ibm.com>
 <20130123195740.GI2373@mtj.dyndns.org>
 <5100B8CC.4080406@linux.vnet.ibm.com>
 <87ip6gutsq.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip6gutsq.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020822-5406-0000-0000-000005139437
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 08:12:37PM +0900, Namhyung Kim wrote:
> On Thu, 24 Jan 2013 10:00:04 +0530, Srivatsa S. Bhat wrote:
> > On 01/24/2013 01:27 AM, Tejun Heo wrote:
> >> On Thu, Jan 24, 2013 at 01:03:52AM +0530, Srivatsa S. Bhat wrote:
> >>> CPU 0                          CPU 1
> >>>
> >>> read_lock(&rwlock)
> >>>
> >>>                               write_lock(&rwlock) //spins, because CPU 0
> >>>                               //has acquired the lock for read
> >>>
> >>> read_lock(&rwlock)
> >>>    ^^^^^
> >>> What happens here? Does CPU 0 start spinning (and hence deadlock) or will
> >>> it continue realizing that it already holds the rwlock for read?
> >> 
> >> I don't think rwlock allows nesting write lock inside read lock.
> >> read_lock(); write_lock() will always deadlock.
> >> 
> >
> > Sure, I understand that :-) My question was, what happens when *two* CPUs
> > are involved, as in, the read_lock() is invoked only on CPU 0 whereas the
> > write_lock() is invoked on CPU 1.
> >
> > For example, the same scenario shown above, but with slightly different
> > timing, will NOT result in a deadlock:
> >
> > Scenario 2:
> >   CPU 0                                CPU 1
> >
> > read_lock(&rwlock)
> >
> >
> > read_lock(&rwlock) //doesn't spin
> >
> >                                     write_lock(&rwlock) //spins, because CPU 0
> >                                     //has acquired the lock for read
> >
> >
> > So I was wondering whether the "fairness" logic of rwlocks would cause
> > the second read_lock() to spin (in the first scenario shown above) because
> > a writer is already waiting (and hence new readers should spin) and thus
> > cause a deadlock.
> 
> In my understanding, current x86 rwlock does basically this (of course,
> in an atomic fashion):
> 
> 
> #define RW_LOCK_BIAS 0x10000
> 
> rwlock_init(rwlock)
> {
> 	rwlock->lock = RW_LOCK_BIAS;
> }
> 
> arch_read_lock(rwlock)
> {
> retry:
> 	if (--rwlock->lock >= 0)
> 		return;
> 
>         rwlock->lock++;
>         while (rwlock->lock < 1)
>         	continue;
> 
>         goto retry;
> }
> 
> arch_write_lock(rwlock)
> {
> retry:
> 	if ((rwlock->lock -= RW_LOCK_BIAS) == 0)
>         	return;
> 
>         rwlock->lock += RW_LOCK_BIAS;
> 	while (rwlock->lock != RW_LOCK_BIAS)
> 		continue;
> 
>         goto retry;
> }
> 
> 
> So I can't find where the 'fairness' logic comes from..

I looked through several of the rwlock implementations, and in all of
them the writer backs off if it sees readers -- or refrains from asserting
ownership of the lock to begin with.

So it should be OK to use rwlock as shown in the underlying patch.

							Thanx, Paul

