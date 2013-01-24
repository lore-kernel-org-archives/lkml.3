Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3AXJ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:58:22 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39258 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3AXJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:58:14 -0500
Date: Thu, 24 Jan 2013 10:58:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130124095807.GA26351@gmail.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> that we can collect the lock statistics of spin_lock_mutex from
> /proc/lock_stat.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  kernel/mutex-debug.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
> index 0799fd3..556c0bc 100644
> --- a/kernel/mutex-debug.h
> +++ b/kernel/mutex-debug.h
> @@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
>  							\
>  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
>  		local_irq_save(flags);			\
> -		arch_spin_lock(&(lock)->rlock.raw_lock);\
> +		spin_lock(lock);			\

But in that case it could probably use the spin_lock_irqsave() 
primitive, right?

>  		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
>  	} while (0)
>  
>  #define spin_unlock_mutex(lock, flags)				\
>  	do {							\
> -		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
> +		spin_unlock(lock);				\
>  		local_irq_restore(flags);			\
>  		preempt_check_resched();			\

And here spin_unlock_irqrestore().

Thanks,

	Ingo
