Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3G3TZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:25:03 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56153 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3TZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:25:01 -0400
Date: Tue, 30 Jul 2013 21:24:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        "Shi, Alex" <alex.shi@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: Performance regression from switching lock to rw-sem for
 anon-vma tree
Message-ID: <20130730192455.GA22259@gmail.com>
References: <20130628093809.GB29205@gmail.com>
 <1372453461.22432.216.camel@schen9-DESK>
 <20130629071245.GA5084@gmail.com>
 <1372710497.22432.224.camel@schen9-DESK>
 <20130702064538.GB3143@gmail.com>
 <1373997195.22432.297.camel@schen9-DESK>
 <20130723094513.GA24522@gmail.com>
 <20130723095124.GW27075@twins.programming.kicks-ass.net>
 <20130723095306.GA26174@gmail.com>
 <1375143209.22432.419.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375143209.22432.419.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> On Tue, 2013-07-23 at 11:53 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, Jul 23, 2013 at 11:45:13AM +0200, Ingo Molnar wrote:
> > >
> > > > Why not just try the delayed addition approach first? The spinning is 
> > > > time limited AFAICS, so we don't _have to_ recognize those as writers 
> > > > per se, only if the spinning fails and it wants to go on the waitlist. 
> > > > Am I missing something?
> > > > 
> > > > It will change patterns, it might even change the fairness balance - 
> > > > but is a legit change otherwise, especially if it helps performance.
> > > 
> > > Be very careful here. Some people (XFS) have very specific needs. Walken 
> > > and dchinner had a longish discussion on this a while back.
> > 
> > Agreed - yet it's worth at least trying it out the quick way, to see the 
> > main effect and to see whether that explains the performance assymetry and 
> > invest more effort into it.
> > 
> 
> Ingo & Peter,
> 
> Here's a patch that moved optimistic spinning of the 
> writer lock acquisition before putting the writer on the 
> wait list.  It did give me a 5% performance boost on my 
> exim mail server workload. It recovered a good portion of 
> the 8% performance regression from mutex implementation.

Very nice detective work!

> I think we are on the right track. Let me know if there's 
> anything in the patch that may cause grief to XFS.
> 
> There is some further optimization possible.  We went to 
> the failed path within __down_write if the count field is 
> non zero. But in fact if the old count field was 
> RWSEM_WAITING_BIAS, there's no one active and we could 
> have stolen the lock when we perform our atomic op on the 
> count field in __down_write. Yet we go to the failed path 
> in the current code.
> 
> I will combine this change and also Alex's patches on 
> rwsem together in a patchset later.
> 
> Your comments and thoughts are most welcomed.
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

> +config RWSEM_SPIN_ON_WRITE_OWNER
> +	bool "Optimistic spin write acquisition for writer owned rw-sem"
> +	default n
> +	depends on SMP
> +	help
> +	  Allows a writer to perform optimistic spinning if another writer own
> +	  the read write semaphore.  If the lock owner is running, it is likely
> +	  to release the lock soon. Spinning gives a greater chance for writer to
> +	  acquire a semaphore before putting it to sleep.

The way you've worded this new Kconfig option makes it 
sound as if it's not just for testing, and I'm not a big 
believer in extra Kconfig degrees of freedom for 
scalability features of core locking primitives like 
rwsems, in production kernels ...

So the bad news is that such scalability optimizations 
really need to work for everyone.

The good news is that I don't think there's anything 
particularly controversial about making the rwsem write 
side perform just as well as mutexes - it would in fact be 
a very nice quality of implementation feature: it gives 
people freedom to switch between mutexes and rwsems without 
having to worry about scalability differences too much.

Once readers are mixed into the workload can we keep the 
XFS assumptions, if they are broken in any way?

We are spinning here so we have full awareness about the 
state of the lock and we can react to a new reader in very 
short order - so at a quick glance I don't see any 
fundamental difficulty in being able to resolve it - beyond 
the SMOP aspect that is ... :-)

Thanks,

	Ingo
