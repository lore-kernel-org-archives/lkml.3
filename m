Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3AYA4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:56:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3AYA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:56:24 -0500
Date: Thu, 24 Jan 2013 16:56:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-Id: <20130124165623.cba62f07.akpm@linux-foundation.org>
In-Reply-To: <1359075057.21576.181.camel@gandalf.local.home>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
	<20130124161413.a3903fa4.akpm@linux-foundation.org>
	<1359075057.21576.181.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 19:50:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> These changes are fine and wont hurt -rt. But thanks for think about
> us :-)

Thanks (tglx) for writing a useful changelog ;)

> > 
> > Also, I believe your patch permits this cleanup:
> > 
> > --- a/kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock-fix
> > +++ a/kernel/mutex-debug.h
> > @@ -42,14 +42,12 @@ static inline void mutex_clear_owner(str
> >  		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
> >  							\
> >  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
> > -		local_irq_save(flags);			\
> > -		spin_lock(lock);			\
> > +		spin_lock_irqsave(lock, flags);		\
> >  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
> >  	} while (0)
> >  
> >  #define spin_unlock_mutex(lock, flags)				\
> >  	do {							\
> > -		spin_unlock(lock);				\
> > -		local_irq_restore(flags);			\
> > +		spin_unlock_irqrestore(lock, flags);		\
> >  		preempt_check_resched();			\
> >  	} while (0)
> 
> Actually this perhaps hurts lockdep. We want to keep the
> arch_spin_(un)lock() versions because each spin_lock() and spin_unlock()
> needs to be verified by lockdep. Lockdep also verifies mutex locks. But
> with this change, for every mutex, it's going to also analyze a
> spin_lock and spin_unlock twice each (one for mutex lock and one for
> unlock). As this is just locking the mutex internals, it may not be
> necessary to debug it via lockdep. Hence we probably want to keep the
> arch_* version.

In what way is this actually a problem?  lockdep will have more work to
do (and given the frequency of mutex_lock/unlock, that overhead may be
significant).  Anything else?

