Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JBSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:43:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:41802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3JBSnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1020,1371106800"; 
   d="scan'208";a="413117624"
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Waiman Long <waiman.long@hp.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <524B75F0.2070005@hp.com>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	 <1380147049.3467.67.camel@schen9-DESK>
	 <20130927152953.GA4464@linux.vnet.ibm.com>
	 <1380310733.3467.118.camel@schen9-DESK>
	 <20130927203858.GB9093@linux.vnet.ibm.com>
	 <1380322005.3467.186.camel@schen9-DESK>
	 <20130927230137.GE9093@linux.vnet.ibm.com>
	 <CAGQ1y=7YbB_BouYZVJwAZ9crkSMLVCxg8hoqcO_7sXHRrZ90_A@mail.gmail.com>
	 <20130928021947.GF9093@linux.vnet.ibm.com>
	 <CAGQ1y=5RnRsWdOe5CX6WYEJ2vUCFtHpj+PNC85NuEDH4bMdb0w@mail.gmail.com>
	 <52499E13.8050109@hp.com> <1380557440.14213.6.camel@j-VirtualBox>
	 <5249A8A4.9060400@hp.com> <1380646092.11046.6.camel@schen9-DESK>
	 <524B2A01.4080403@hp.com> <1380662188.11046.37.camel@schen9-DESK>
	 <524B75F0.2070005@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Oct 2013 11:43:11 -0700
Message-ID: <1380739391.11046.73.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 21:25 -0400, Waiman Long wrote: 
> On 10/01/2013 05:16 PM, Tim Chen wrote:
> > On Tue, 2013-10-01 at 16:01 -0400, Waiman Long wrote:
> >>>
> >>> The cpu could still be executing out of order load instruction from the
> >>> critical section before checking node->locked?  Probably smp_mb() is
> >>> still needed.
> >>>
> >>> Tim
> >> But this is the lock function, a barrier() call should be enough to
> >> prevent the critical section from creeping up there. We certainly need
> >> some kind of memory barrier at the end of the unlock function.
> > I may be missing something.  My understanding is that barrier only
> > prevents the compiler from rearranging instructions, but not for cpu out
> > of order execution (as in smp_mb). So cpu could read memory in the next
> > critical section, before node->locked is true, (i.e. unlock has been
> > completed).  If we only have a simple barrier at end of mcs_lock, then
> > say the code on CPU1 is
> >
> > 	mcs_lock
> > 	x = 1;
> > 	...
> > 	x = 2;
> > 	mcs_unlock
> >
> > and CPU 2 is
> >
> > 	mcs_lock
> > 	y = x;
> > 	...
> > 	mcs_unlock
> >
> > We expect y to be 2 after the "y = x" assignment.  But we
> > we may execute the code as
> >
> > 	CPU1		CPU2
> > 		
> > 	x = 1;
> > 	...		y = x;  ( y=1, out of order load)
> > 	x = 2
> > 	mcs_unlock
> > 			Check node->locked==true
> > 			continue executing critical section (y=1 when we expect y=2)
> >
> > So we get y to be 1 when we expect that it should be 2.  Adding smp_mb
> > after the node->locked check in lock code
> >
> >             ACCESS_ONCE(prev->next) = node;
> >             /* Wait until the lock holder passes the lock down */
> >             while (!ACCESS_ONCE(node->locked))
> >                      arch_mutex_cpu_relax();
> >             smp_mb();
> >
> > should prevent this scenario.
> >
> > Thanks.
> > Tim
> 
> If the lock and unlock functions are done right, there should be no 
> overlap of critical section. So it is job of the lock/unlock functions 
> to make sure that critical section code won't leak out. There should be 
> some kind of memory barrier at the beginning of the lock function and 
> the end of the unlock function.
> 
> The critical section also likely to have branches. The CPU may 
> speculatively execute code on the 2 branches, but one of them will be 
> discarded once the branch condition is known. Also 
> arch_mutex_cpu_relax() is a compiler barrier by itself. So we may not 
> need a barrier() after all. The while statement is a branch instruction, 
> any code after that can only be speculatively executed and cannot be 
> committed until the branch is done.

But the condition code may be checked after speculative execution? 
The condition may not be true during speculative execution and only
turns true when we check the condition, and take that branch?

The thing that bothers me is without memory barrier after the while
statement, we could speculatively execute before affirming the lock is 
in acquired state. Then when we check the lock, the lock is set
to acquired state in the mean time.    
We could be loading some memory entry *before*
the node->locked has been set true.  I think a smp_rmb (if not a 
smp_mb) should be set after the while statement.

At first I was also thinking that the memory barrier is not 
necessary but Paul convinced me otherwise in a previous email. 
https://lkml.org/lkml/2013/9/27/523 

> 
> In x86, the smp_mb() function translated to a mfence instruction which 
> cost time. That is why I try to get rid of it if it is not necessary.
> 

I also hope that the memory barrier is not necessary and I am missing
something obvious.  But I haven't been able to persuade myself.

Tim 



