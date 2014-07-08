Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaGHPb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:31:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52951 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaGHPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:31:25 -0400
Date: Tue, 8 Jul 2014 08:31:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release
 barriers to pairing rules
Message-ID: <20140708153117.GJ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708075902.GM19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708075902.GM19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070815-1344-0000-0000-000002AE105D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:59:02AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 03:24:21PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > It is possible to pair acquire and release barriers with other barriers,
> > so this commit adds them to the list in the SMP barrier pairing section.
> > 
> > Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> 
> > +A write barrier should always be paired with a data dependency barrier,
> > +acquire barrier, release barrier, or read barrier, though a general
> > +barrier would also be viable.
> 
>    Similarly a read barrier or a data
> > +dependency barrier should always be paired with at least a write barrier,
> > +an acquire barrier, or a release barrier, though, again, a general
> > +barrier is viable:
> 
> When I first read the Changelog I though you were going to add things
> like:
> 
>   An acquire barrier should be paired with a release barrier, however
>   .... barrier is also viable.
> 
>   A release barrier should be paired with an acquire barrier,... etc.
> 
> Now the above does seem to imply such rules but it isn't explicit in
> them, since it only lists the requirements for read/write. Now since the
> entire thing is indeed symmetric the implications are fairly strong,
> still.

Good point, how about the following?

	General barriers pair with each other, though they also pair
	with most other types of barriers, albeit without transitivity.
	An acquire barrier pairs with a release barrier, but both may also
	pair with other barriers, including of course general barriers.
	A write barrier pairs with a data dependency barrier, an acquire
	barrier, a release barrier, a read barrier, or a general barrier.
	Similarly a read barrier or a data dependency barrier pairs
	with a write barrier, an acquire barrier, a release barrier,
	or a general barrier:

> Also, it might be good to have a section on the ramifications of pairing
> acquire/release with other than themselves, I have the feeling there's
> subtle things there.

It can get quite subtle.  For the time being, I am dodging this subtlety
by saying that only general barriers provide transitivity (see the
"TRANSITIVITY" section).

To give but one example of the subtlety, given X, Y, and Z all initially
zero where it matters:

	X=2;		Y=2;		Z=2;
	smp_wmb();	smp_wmb();	smp_wmb();
	Y=1;		Z=1;		X=1;

	BUG_ON(X==2 && Y==2 && Z==2); /* Never triggers. */

But:

	X=2;		Y=2;		Z=2;
	smp_wmb();	smp_wmb();	smp_mb();
	Y=1;		Z=1;		r1=X;

	BUG_ON(r1==0 && Y==2 && Z==2); /* Can trigger!!! */

Maybe some day we should capture this subtlety in memory-barriers.txt,
but we will first need a new generation of small children who are not
scared by the current document.  ;-)

								Thanx, Paul

