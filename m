Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182Ab3AYAvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:51:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3AYAu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:50:59 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EdCCnysJoiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5Y64mutqEVMA:10 a=QyXUC8HyAAAA:8 a=VswHOVK8bnAQ3exyNawA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359075057.21576.181.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 24 Jan 2013 19:50:57 -0500
In-Reply-To: <20130124161413.a3903fa4.akpm@linux-foundation.org>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
	 <20130124161413.a3903fa4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 16:14 -0800, Andrew Morton wrote:
> On Thu, 24 Jan 2013 17:22:45 +0800
> Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> > that we can collect the lock statistics of spin_lock_mutex from
> > /proc/lock_stat.
> > 
> > ...
> >
> > --- a/kernel/mutex-debug.h
> > +++ b/kernel/mutex-debug.h
> > @@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
> >  							\
> >  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
> >  		local_irq_save(flags);			\
> > -		arch_spin_lock(&(lock)->rlock.raw_lock);\
> > +		spin_lock(lock);			\
> >  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
> >  	} while (0)
> >  
> >  #define spin_unlock_mutex(lock, flags)				\
> >  	do {							\
> > -		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
> > +		spin_unlock(lock);				\
> >  		local_irq_restore(flags);			\
> >  		preempt_check_resched();			\
> >  	} while (0)
> 
> >From my reading of the c2f21ce2e3128 changelog, this patch might screw
> up the -rt kernel:
> 
>     locking: Implement new raw_spinlock
>     
>     Now that the raw_spin name space is freed up, we can implement
>     raw_spinlock and the related functions which are used to annotate the
>     locks which are not converted to sleeping spinlocks in preempt-rt.
>     
>     A side effect is that only such locks can be used with the low level
>     lock fsunctions which circumvent lockdep.
>     
>     For !rt spin_* functions are mapped to the raw_spin* implementations.

Actually this code is never called when we enable -rt.

At the top of -rt's mutex.h header:

#ifdef CONFIG_PREEMPT_RT_FULL
# include <linux/mutex_rt.h>
#else

[...]

Which basically includes the rest of the mutex.h file.

The kernel/Makefile has:

ifneq ($(CONFIG_PREEMPT_RT_FULL),y)
obj-y += mutex.o
obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
obj-y += rwsem.o
endif


That's because the -rt kernel uses the priority inheritance rtmutex.
Pretty much the same one that userspace futexes use.

These changes are fine and wont hurt -rt. But thanks for think about
us :-)



> 
> 
> Also, I believe your patch permits this cleanup:
> 
> --- a/kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock-fix
> +++ a/kernel/mutex-debug.h
> @@ -42,14 +42,12 @@ static inline void mutex_clear_owner(str
>  		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
>  							\
>  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
> -		local_irq_save(flags);			\
> -		spin_lock(lock);			\
> +		spin_lock_irqsave(lock, flags);		\
>  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
>  	} while (0)
>  
>  #define spin_unlock_mutex(lock, flags)				\
>  	do {							\
> -		spin_unlock(lock);				\
> -		local_irq_restore(flags);			\
> +		spin_unlock_irqrestore(lock, flags);		\
>  		preempt_check_resched();			\
>  	} while (0)

Actually this perhaps hurts lockdep. We want to keep the
arch_spin_(un)lock() versions because each spin_lock() and spin_unlock()
needs to be verified by lockdep. Lockdep also verifies mutex locks. But
with this change, for every mutex, it's going to also analyze a
spin_lock and spin_unlock twice each (one for mutex lock and one for
unlock). As this is just locking the mutex internals, it may not be
necessary to debug it via lockdep. Hence we probably want to keep the
arch_* version.

> 
> But we should hear from the -rt guys (at least!) before proceeding with
> this, please.

-rt fine, lockdep not so fine.

-- Steve


