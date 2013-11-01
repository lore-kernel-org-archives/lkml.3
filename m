Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3KAJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:28:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35631 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab3KAJ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:28:22 -0400
Date: Fri, 1 Nov 2013 02:28:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131101092814.GG4067@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
 <20131031090457.GU19466@laptop.lan>
 <20131031150756.GB4067@linux.vnet.ibm.com>
 <20131031151955.GY19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031151955.GY19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110109-0320-0000-0000-000001980391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 04:19:55PM +0100, Peter Zijlstra wrote:
> On Thu, Oct 31, 2013 at 08:07:56AM -0700, Paul E. McKenney wrote:
> > On Thu, Oct 31, 2013 at 10:04:57AM +0100, Peter Zijlstra wrote:
> > > On Wed, Oct 30, 2013 at 09:32:58PM -0700, Paul E. McKenney wrote:
> > > > Before C/C++11, the closest thing to such a prohibition is use of
> > > > volatile, for example, ACCESS_ONCE().  Even in C/C++11, you have to
> > > > use atomics to get anything resembing this prohibition.
> > > > 
> > > > If you just use normal variables, the compiler is within its rights
> > > > to transform something like the following:
> > > > 
> > > > 	if (a)
> > > > 		b = 1;
> > > > 	else
> > > > 		b = 42;
> > > > 
> > > > Into:
> > > > 
> > > > 	b = 42;
> > > > 	if (a)
> > > > 		b = 1;
> > > > 
> > > > Many other similar transformations are permitted.  Some are used to all
> > > > vector instructions to be used -- the compiler can do a write with an
> > > > overly wide vector instruction, then clean up the clobbered variables
> > > > later, if it wishes.  Again, if the variables are not marked volatile,
> > > > or, in C/C++11, atomic.
> > > 
> > > While I've heard you tell this story before, my mind keeps boggling how
> > > we've been able to use shared memory at all, all these years.
> > > 
> > > It seems to me stuff should have broken left, right and center if
> > > compilers were really aggressive about this.
> > 
> > Sometimes having stupid compilers is a good thing.  But they really are
> > getting more aggressive.
> 
> But surely we cannot go mark all data structures lodged in shared memory
> as volatile, that's insane.
> 
> I'm sure you're quite worried about this as well. Suppose we have:
> 
> struct foo {
> 	unsigned long value;
> 	void *ptr;
> 	unsigned long value1;
> };
> 
> And our ptr member is RCU managed. Then while the assignment using:
> rcu_assign_ptr() will use the volatile cast, what stops the compiler
> from wrecking ptr while writing either of the value* members and
> 'fixing' her up after?

Nothing at all!

We can reduce the probability by putting the pointer at one end or the
other, so that if the compiler uses (say) vector instructions to aggregate
individual assignments to the other fields, it will be less likely to hit
"ptr".  But yes, this is ugly and it would be really hard to get all
this right, and would often conflict with cache-locality needs.

> This is a completely untenable position.

Indeed it is!

C/C++ never was intended to be used for parallel programming, and this is
but one of the problems that can arise when we nevertheless use it for
parallel programming.  As compilers get smarter (for some definition of
"smarter") and as more systems have special-purpose hardware (such as
vector units) that are visible to the compiler, we can expect more of
this kind of trouble.

This was one of many reasons that I decided to help with the C/C++11
effort, whatever anyone might think about the results.

> How do the C/C++ people propose to deal with this?

By marking "ptr" as atomic, thus telling the compiler not to mess with it.
And thus requiring that all accesses to it be decorated, which in the
case of RCU could be buried in the RCU accessors.

							Thanx, Paul

