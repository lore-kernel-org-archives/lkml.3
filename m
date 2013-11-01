Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3KAIoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:44:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44400 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab3KAIoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:44:05 -0400
Date: Fri, 1 Nov 2013 01:43:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        gleb@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131101084359.GE4067@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131030190929.GA7153@redhat.com>
 <20131030201552.GP4126@linux.vnet.ibm.com>
 <20131030232605.GA28823@redhat.com>
 <20131031045629.GT4126@linux.vnet.ibm.com>
 <20131031135714.GE8976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031135714.GE8976@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110108-5806-0000-0000-00002349DCDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:57:14PM +0200, Michael S. Tsirkin wrote:
> On Wed, Oct 30, 2013 at 09:56:29PM -0700, Paul E. McKenney wrote:
> > On Thu, Oct 31, 2013 at 01:26:05AM +0200, Michael S. Tsirkin wrote:
> > > > > Paul, could you review this patch please?
> > > > > Documentation/memory-barriers.txt says that unlock has a weaker
> > > > > uni-directional barrier, but in practice srcu_read_unlock calls
> > > > > smp_mb().
> > > > > 
> > > > > Is it OK to rely on this? If not, can I add
> > > > > smp_mb__after_srcu_read_unlock (making it an empty macro for now)
> > > > > so we can avoid an actual extra smp_mb()?
> > > > 
> > > > Please use smp_mb__after_srcu_read_unlock().  After all, it was not
> > > > that long ago that srcu_read_unlock() contained no memory barriers,
> > > > and perhaps some day it won't need to once again.
> > > > 
> > > > 							Thanx, Paul
> > > >
> > > 
> > > Thanks!
> > > Something like this will be enough?
> > > 
> > > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > > index c114614..9b058ee 100644
> > > --- a/include/linux/srcu.h
> > > +++ b/include/linux/srcu.h
> > > @@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
> > >  	__srcu_read_unlock(sp, idx);
> > >  }
> > > 
> > > +/**
> > > + * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
> > > + *
> > > + * Converts the preceding srcu_read_unlock into a two-way memory barrier.
> > > + *
> > > + * Call this after srcu_read_unlock, to guarantee that all memory operations
> > > + * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
> > > + * the preceding srcu_read_unlock.
> > > + */
> > > +static inline void smp_mb__after_srcu_read_unlock(void)
> > > +{
> > > +	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
> > > +}
> > > +
> > >  #endif
> > 
> > Yep, that should do it!
> > 
> > 							Thanx, Paul
> 
> BTW I'm wondering about the smb_mb within srcu_read_lock.
> If we kept the index in the same memory with the buffer we
> dereference, could we get rid of it and use a dependency barrier
> instead? It does appear prominently in the profiles.
> Thoughts?

Unfortunately, no go:

	int __srcu_read_lock(struct srcu_struct *sp)
	{
		int idx;

		idx = ACCESS_ONCE(sp->completed) & 0x1;
		preempt_disable();
		ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
		smp_mb(); /* B */  /* Avoid leaking the critical section. */
		ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
		preempt_enable();
		return idx;
	}

The smp_mb() is between the two increments, and there is no dependency
between them.  There -could- be a dependency between the fetch of idx
and the first increment, but there is no ordering required there because
the rest of the algorithm will correctly handle any misordering.  Which
is why there is no memory barrier there.

							Thanx, Paul

