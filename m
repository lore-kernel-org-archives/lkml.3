Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3AYAOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:14:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:14:15 -0500
Date: Thu, 24 Jan 2013 16:14:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-Id: <20130124161413.a3903fa4.akpm@linux-foundation.org>
In-Reply-To: <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 17:22:45 +0800
Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> that we can collect the lock statistics of spin_lock_mutex from
> /proc/lock_stat.
> 
> ...
>
> --- a/kernel/mutex-debug.h
> +++ b/kernel/mutex-debug.h
> @@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
>  							\
>  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
>  		local_irq_save(flags);			\
> -		arch_spin_lock(&(lock)->rlock.raw_lock);\
> +		spin_lock(lock);			\
>  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
>  	} while (0)
>  
>  #define spin_unlock_mutex(lock, flags)				\
>  	do {							\
> -		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
> +		spin_unlock(lock);				\
>  		local_irq_restore(flags);			\
>  		preempt_check_resched();			\
>  	} while (0)

>From my reading of the c2f21ce2e3128 changelog, this patch might screw
up the -rt kernel:

    locking: Implement new raw_spinlock
    
    Now that the raw_spin name space is freed up, we can implement
    raw_spinlock and the related functions which are used to annotate the
    locks which are not converted to sleeping spinlocks in preempt-rt.
    
    A side effect is that only such locks can be used with the low level
    lock fsunctions which circumvent lockdep.
    
    For !rt spin_* functions are mapped to the raw_spin* implementations.


Also, I believe your patch permits this cleanup:

--- a/kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock-fix
+++ a/kernel/mutex-debug.h
@@ -42,14 +42,12 @@ static inline void mutex_clear_owner(str
 		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
 							\
 		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
-		local_irq_save(flags);			\
-		spin_lock(lock);			\
+		spin_lock_irqsave(lock, flags);		\
 		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
 	} while (0)
 
 #define spin_unlock_mutex(lock, flags)				\
 	do {							\
-		spin_unlock(lock);				\
-		local_irq_restore(flags);			\
+		spin_unlock_irqrestore(lock, flags);		\
 		preempt_check_resched();			\
 	} while (0)

But we should hear from the -rt guys (at least!) before proceeding with
this, please.

