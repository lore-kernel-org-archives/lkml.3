Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab3KFPHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:07:21 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38189 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab3KFPHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:07:19 -0500
Date: Wed, 6 Nov 2013 06:45:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 3/4] MCS Lock: Barrier corrections
Message-ID: <20131106144520.GK18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1383670202.git.tim.c.chen@linux.intel.com>
 <1383673356.11046.279.camel@schen9-DESK>
 <20131105183744.GJ26895@mudshark.cambridge.arm.com>
 <1383679317.11046.293.camel@schen9-DESK>
 <20131105211803.GS28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105211803.GS28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110615-7182-0000-0000-000009054379
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:18:03PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 05, 2013 at 11:21:57AM -0800, Tim Chen wrote:
> > On Tue, 2013-11-05 at 18:37 +0000, Will Deacon wrote:
> > > On Tue, Nov 05, 2013 at 05:42:36PM +0000, Tim Chen wrote:
> > > > This patch corrects the way memory barriers are used in the MCS lock
> > > > and removes ones that are not needed. Also add comments on all barriers.
> > > 
> > > Hmm, I see that you're fixing up the barriers, but I still don't completely
> > > understand how what you have is correct. Hopefully you can help me out :)
> > > 
> > > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > > > ---
> > > >  include/linux/mcs_spinlock.h |   13 +++++++++++--
> > > >  1 files changed, 11 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
> > > > index 96f14299..93d445d 100644
> > > > --- a/include/linux/mcs_spinlock.h
> > > > +++ b/include/linux/mcs_spinlock.h
> > > > @@ -36,16 +36,19 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> > > >  	node->locked = 0;
> > > >  	node->next   = NULL;
> > > >  
> > > > +	/* xchg() provides a memory barrier */
> > > >  	prev = xchg(lock, node);
> > > >  	if (likely(prev == NULL)) {
> > > >  		/* Lock acquired */
> > > >  		return;
> > > >  	}
> > > >  	ACCESS_ONCE(prev->next) = node;
> > > > -	smp_wmb();
> > > >  	/* Wait until the lock holder passes the lock down */
> > > >  	while (!ACCESS_ONCE(node->locked))
> > > >  		arch_mutex_cpu_relax();
> > > > +
> > > > +	/* Make sure subsequent operations happen after the lock is acquired */
> > > > +	smp_rmb();
> > > 
> > > Ok, so this is an smp_rmb() because we assume that stores aren't speculated,
> > > right? (i.e. the control dependency above is enough for stores to be ordered
> > > with respect to taking the lock)...
> 
> PaulMck completely confused me a few days ago with control dependencies
> etc.. Pretty much saying that C/C++ doesn't do those.

I remember that there was a subtlety here, but don't remember what it was...

And while I do remember reviewing this code, I don't find any evidence
that I gave my "Reviewed-by".  Tim/Jason, if I fat-fingered this, please
forward that email back to me.

							Thanx, Paul

