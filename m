Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbaGPMQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:16:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59732 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaGPMQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:16:34 -0400
Date: Wed, 16 Jul 2014 05:16:26 -0700
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
Message-ID: <20140716121626.GM8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708075902.GM19379@twins.programming.kicks-ass.net>
 <20140708153117.GJ4603@linux.vnet.ibm.com>
 <20140714115738.GW19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714115738.GW19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071612-7164-0000-0000-0000032B813A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:57:38PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 08, 2014 at 08:31:17AM -0700, Paul E. McKenney wrote:
> 
> > Good point, how about the following?
> > 
> > 	General barriers pair with each other, though they also pair
> > 	with most other types of barriers, albeit without transitivity.
> 
> > 	An acquire barrier pairs with a release barrier, but both may also
> > 	pair with other barriers, including of course general barriers.
> 
> > 	A write barrier pairs with a data dependency barrier, an acquire
> > 	barrier, a release barrier, a read barrier, or a general barrier.
> 
> > 	Similarly a read barrier or a data dependency barrier pairs
> > 	with a write barrier, an acquire barrier, a release barrier,
> > 	or a general barrier:
> 
> It might be clearer with the added whitespace, or as an explicit list  I
> suppose, but yes.

If I get ambitious, I might try making a table out of it, but I am not
yet sure how I would set that up.  Something about having to say a lot
in each cell, but with only a small amount of room in which to say it.

> > > Also, it might be good to have a section on the ramifications of pairing
> > > acquire/release with other than themselves, I have the feeling there's
> > > subtle things there.
> > 
> > It can get quite subtle.  For the time being, I am dodging this subtlety
> > by saying that only general barriers provide transitivity (see the
> > "TRANSITIVITY" section).
> 
> Ah, I was more thinking of the fact that ACQUIRE/RELEASE are
> semi-permeable while READ/WRITE are memop dependent.
> 
> So any combination will be a semi-permeable memop dependent thing,
> which is the most narrow barrier possible.
> 
> So if we thing of ACQUIRE/RELEASE as being 'half' a full barrier,
> separated in direction, and READ/WRITE as being 'half' a full barrier
> separated on type, then the combination is a 'quarter' barrier.
> 
> Not arguing they're not useful, just saying we need to be extra careful.

I do agree completely about the need for extra care!

For whatever it is worth, the permeability and read-write properties
are isolated to each barrier in the pair.  For example, with "a" and
"b" both initially zero:

	CPU 1				CPU 2
	-----				-----
	ACCESS_ONCE(a) = 1;		r1 = b;
	smp_store_release(&b, 1);	smp_rmb();
	ACCESS_ONCE(c) = 1;		r2 = a;
					ACCESS_ONCE(c) = 2;

The outcome r1==1&&r2==0 is prohibited, but the ordering of the stores
to "c" are not ordered: CPU 1's smp_store_release() does not affect
later accesses, and CPU 2's smp_rmb() does not order stores.

Not sure that it is worth adding this sort of example, though.

							Thanx, Paul

> > Maybe some day we should capture this subtlety in memory-barriers.txt,
> > but we will first need a new generation of small children who are not
> > scared by the current document.  ;-)
> 
> Lolz :-)


