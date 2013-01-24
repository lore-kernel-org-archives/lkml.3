Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3AXKMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:12:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:25504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3AXKMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:12:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="251672843"
Date: Thu, 24 Jan 2013 18:13:05 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130124101305.GE12678@yliu-dev.sh.intel.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20130124095807.GA26351@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124095807.GA26351@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:58:07AM +0100, Ingo Molnar wrote:
> 
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> > that we can collect the lock statistics of spin_lock_mutex from
> > /proc/lock_stat.
> > 
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  kernel/mutex-debug.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
> > index 0799fd3..556c0bc 100644
> > --- a/kernel/mutex-debug.h
> > +++ b/kernel/mutex-debug.h
> > @@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
> >  							\
> >  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
> >  		local_irq_save(flags);			\
> > -		arch_spin_lock(&(lock)->rlock.raw_lock);\
> > +		spin_lock(lock);			\
> 
> But in that case it could probably use the spin_lock_irqsave() 
> primitive, right?

Right, in that case I should use spin_lock_irqsave.

But one question, why we use spin_lock at kernel/mutex.h,
while use 'local_irq_save(); arch_spin_lock' at kernel/mutex-debug.h?

Shouldn't we keep it consistent? Say use spin_lock_irqsave?

Thanks.

	--yliu
> 
> >  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
> >  	} while (0)
> >  
> >  #define spin_unlock_mutex(lock, flags)				\
> >  	do {							\
> > -		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
> > +		spin_unlock(lock);				\
> >  		local_irq_restore(flags);			\
> >  		preempt_check_resched();			\
> 
> And here spin_unlock_irqrestore().
> 
> Thanks,
> 
> 	Ingo
