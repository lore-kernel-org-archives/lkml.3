Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaBQW6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:58:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43537 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaBQW6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:58:21 -0500
Date: Mon, 17 Feb 2014 14:58:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 5/6] Documentation/memory-barriers.txt: Need
 barriers() for some control dependencies
Message-ID: <20140217225816.GN4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672413-5114-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217214606.GC7941@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217214606.GC7941@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BF1996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:46:06PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 01:26:52PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Current compilers can "speculate" stores in the case where both legs
> > of the "if" statement start with identical stores.  Because the stores
> > are identical, the compiler knows that the store will unconditionally
> > execute regardless of the "if" condition, and so the compiler is within
> > its rights to hoist the store to precede the condition.  Such hoisting
> > destroys the control-dependency ordering.  This ordering can be restored
> > by placing a barrier() at the beginning of each leg of the "if" statement.
> > This commit adds this requirement to the control-dependencies section.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This is starting to become a rather unreasonable level of fighting the
> compiler.  ("Threads cannot be implemented as a library" indeed.)  This
> doesn't seem like a reasonable thing to require users to do.  Is there
> really no other way to cope with this particular bit of "help" from the
> compiler?

Well, we could use smp_mb() instead of barrier(), but that was the
sort of thing that Peter Zijlstra was trying to avoid.  That said,
I do sympathize completely with your position here -- it is just that
it is better to have our compiler-fights documented that not, right?

							Thanx, Paul

> >  Documentation/memory-barriers.txt | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > index f2668c19807e..adfaca831a90 100644
> > --- a/Documentation/memory-barriers.txt
> > +++ b/Documentation/memory-barriers.txt
> > @@ -608,26 +608,30 @@ as follows:
> >  	b = p;  /* BUG: Compiler can reorder!!! */
> >  	do_something();
> >  
> > -The solution is again ACCESS_ONCE(), which preserves the ordering between
> > -the load from variable 'a' and the store to variable 'b':
> > +The solution is again ACCESS_ONCE() and barrier(), which preserves the
> > +ordering between the load from variable 'a' and the store to variable 'b':
> >  
> >  	q = ACCESS_ONCE(a);
> >  	if (q) {
> > +		barrier();
> >  		ACCESS_ONCE(b) = p;
> >  		do_something();
> >  	} else {
> > +		barrier();
> >  		ACCESS_ONCE(b) = p;
> >  		do_something_else();
> >  	}
> >  
> > -You could also use barrier() to prevent the compiler from moving
> > -the stores to variable 'b', but barrier() would not prevent the
> > -compiler from proving to itself that a==1 always, so ACCESS_ONCE()
> > -is also needed.
> > +The initial ACCESS_ONCE() is required to prevent the compiler from
> > +proving the value of 'a', and the pair of barrier() invocations are
> > +required to prevent the compiler from pulling the two identical stores
> > +to 'b' out from the legs of the "if" statement.
> >  
> >  It is important to note that control dependencies absolutely require a
> >  a conditional.  For example, the following "optimized" version of
> > -the above example breaks ordering:
> > +the above example breaks ordering, which is why the barrier() invocations
> > +are absolutely required if you have identical stores in both legs of
> > +the "if" statement:
> >  
> >  	q = ACCESS_ONCE(a);
> >  	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
> > @@ -643,9 +647,11 @@ It is of course legal for the prior load to be part of the conditional,
> >  for example, as follows:
> >  
> >  	if (ACCESS_ONCE(a) > 0) {
> > +		barrier();
> >  		ACCESS_ONCE(b) = q / 2;
> >  		do_something();
> >  	} else {
> > +		barrier();
> >  		ACCESS_ONCE(b) = q / 3;
> >  		do_something_else();
> >  	}
> > @@ -659,9 +665,11 @@ the needed conditional.  For example:
> >  
> >  	q = ACCESS_ONCE(a);
> >  	if (q % MAX) {
> > +		barrier();
> >  		ACCESS_ONCE(b) = p;
> >  		do_something();
> >  	} else {
> > +		barrier();
> >  		ACCESS_ONCE(b) = p;
> >  		do_something_else();
> >  	}
> > @@ -723,6 +731,10 @@ In summary:
> >        use smb_rmb(), smp_wmb(), or, in the case of prior stores and
> >        later loads, smp_mb().
> >  
> > +  (*) If both legs of the "if" statement begin with identical stores
> > +      to the same variable, a barrier() statement is required at the
> > +      beginning of each leg of the "if" statement.
> > +
> >    (*) Control dependencies require at least one run-time conditional
> >        between the prior load and the subsequent store, and this
> >        conditional must involve the prior load.  If the compiler
> > -- 
> > 1.8.1.5
> > 
> 

