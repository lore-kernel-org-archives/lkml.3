Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3FZW4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:31996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab3FZW4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,947,1363158000"; 
   d="scan'208";a="360160146"
Subject: Re: [PATCH v4 5/5] rwsem: do optimistic spinning for writer lock
 acquisition
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <1372286407.3954.6.camel@buesod1.americas.hpqcorp.net>
References: <cover.1372282738.git.tim.c.chen@linux.intel.com>
	 <1372285687.22432.145.camel@schen9-DESK>
	 <1372286407.3954.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jun 2013 15:56:37 -0700
Message-ID: <1372287397.22432.146.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 15:40 -0700, Davidlohr Bueso wrote:
> On Wed, 2013-06-26 at 15:28 -0700, Tim Chen wrote:
> > We want to add optimistic spinning to rwsems because we've noticed that
> > the writer rwsem does not perform as well as mutexes. Tim noticed that
> > for exim (mail server) workloads, when reverting commit 4fc3f1d6 and Davidlohr
> > noticed it when converting the i_mmap_mutex to a rwsem in some aim7
> > workloads. We've noticed that the biggest difference, in a nutshell, is
> > when we fail to acquire a mutex in the fastpath, optimistic spinning
> > comes in to play and we can avoid a large amount of unnecessary sleeping
> > and wait queue overhead.
> > 
> > For rwsems on the other hand, upon entering the writer slowpath in
> > rwsem_down_write_failed(), we just acquire the ->wait_lock, add
> > ourselves to the wait_queue and blocking until we get the lock.
> > 
> > Reviewed-by: Peter Zijlstra <peterz@infradead.org>
> > Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > ---
> >  include/linux/rwsem.h |    3 +
> >  init/Kconfig          |    9 +++
> >  kernel/rwsem.c        |   29 +++++++++-
> >  lib/rwsem.c           |  150 +++++++++++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 179 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> > index 0616ffe..0c5933b 100644
> > --- a/include/linux/rwsem.h
> > +++ b/include/linux/rwsem.h
> > @@ -29,6 +29,9 @@ struct rw_semaphore {
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  	struct lockdep_map	dep_map;
> >  #endif
> > +#ifdef CONFIG_RWSEM_SPIN_ON_WRITE_OWNER
> > +	struct task_struct	*owner;
> > +#endif
> >  };
> >  
> >  extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 9d3a788..1c582d1 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1595,6 +1595,15 @@ config TRACEPOINTS
> >  
> >  source "arch/Kconfig"
> >  
> > +config RWSEM_SPIN_ON_WRITE_OWNER
> > +	bool "Optimistic spin write acquisition for writer owned rw-sem"
> > +	default n
> > +	depends on SMP
> > +	help
> > +	  Allows a writer to perform optimistic spinning if another writer own
> > +	  the read write semaphore.  This gives a greater chance for writer to
> > +	  acquire a semaphore before blocking it and putting it to sleep.
> > +
> 
> Quoting from kernel/mutex.c:
> 
> "The rationale is that if the lock owner is running, it is likely to
> release the lock soon." 
> 
> It would be good to add that to the Kconfig.

Sounds good.

Tim


