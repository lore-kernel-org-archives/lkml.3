Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaIPUvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:51:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:23204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaIPUvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:51:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,535,1406617200"; 
   d="scan'208";a="603799464"
Message-ID: <1410900692.31585.68.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH v2] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jason Low <jason.low2@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <dbueso@suse.de>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>
Date: Tue, 16 Sep 2014 13:51:32 -0700
In-Reply-To: <541898C7.6070508@hurleysoftware.com>
References: <1410894118.2447.4.camel@j-VirtualBox>
	 <541898C7.6070508@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 16:08 -0400, Peter Hurley wrote:
> Hi Jason,
> 
> On 09/16/2014 03:01 PM, Jason Low wrote:
> > Commit 9b0fc9c09f1b checks for if there are known active lockers in
> > order to avoid write trylocking using expensive cmpxchg() when it
> > likely wouldn't get the lock.
> > 
> > However, a subsequent patch was added such that we directly check for
> > sem->count == RWSEM_WAITING_BIAS right before trying that cmpxchg().
> > Thus, commit 9b0fc9c09f1b now just adds extra overhead. This patch
> > deletes it.
> 
> It would be better to just not reload sem->count, and check the parameter
> count == RWSEM_WAITING_BIAS instead. The count parameter is a very recent
> load of sem->count (one of which is the latest exclusive read from an
> atomic operation), so likely to be just as accurate as a reload of
> sem->count without causing more cache line contention.
> 

Agree with Peter.
I think the extra check in the original code was to try to 
avoid reloading sem->count. 
So checking directly here (count == RWSEM_WAITING_BIAS) will
accomplish that end.  You'll need to modify your comment slightly
to say

Try acquiring the write lock. Check count first   ...

Thanks.

Tim

> Regards,
> Peter Hurley
> 
> > Also, add a comment on why we do an "extra check" of sem->count before
> > the cmpxchg().
> > 
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> > ---
> >  kernel/locking/rwsem-xadd.c |   24 +++++++++++++-----------
> >  1 files changed, 13 insertions(+), 11 deletions(-)
> > 
> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > index d6203fa..63d3ef2 100644
> > --- a/kernel/locking/rwsem-xadd.c
> > +++ b/kernel/locking/rwsem-xadd.c
> > @@ -247,18 +247,20 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
> >  	return sem;
> >  }
> >  
> > -static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
> > +static inline bool rwsem_try_write_lock(struct rw_semaphore *sem)
> >  {
> > -	if (!(count & RWSEM_ACTIVE_MASK)) {
> > -		/* try acquiring the write lock */
> > -		if (sem->count == RWSEM_WAITING_BIAS &&
> > -		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > -			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
> > -			if (!list_is_singular(&sem->wait_list))
> > -				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> > -			return true;
> > -		}
> > +	/*
> > +	 * Try acquiring the write lock. Check sem->count first
> > +	 * in order to reduce unnecessary expensive cmpxchg() operations.
> > +	 */
> > +	if (sem->count == RWSEM_WAITING_BIAS &&
> > +	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > +		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
> > +		if (!list_is_singular(&sem->wait_list))
> > +			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> > +		return true;
> >  	}
> > +
> >  	return false;
> >  }
> >  
> > @@ -446,7 +448,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
> >  	/* wait until we successfully acquire the lock */
> >  	set_current_state(TASK_UNINTERRUPTIBLE);
> >  	while (true) {
> > -		if (rwsem_try_write_lock(count, sem))
> > +		if (rwsem_try_write_lock(sem))
> >  			break;
> >  		raw_spin_unlock_irq(&sem->wait_lock);
> >  
> > 
> 


