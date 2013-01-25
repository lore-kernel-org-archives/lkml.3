Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3AYHlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:41:00 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44459 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AYHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:40:57 -0500
Date: Fri, 25 Jan 2013 08:40:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130125074053.GD18243@gmail.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20130124161413.a3903fa4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124161413.a3903fa4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 24 Jan 2013 17:22:45 +0800
> Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> > that we can collect the lock statistics of spin_lock_mutex from
> > /proc/lock_stat.

So, as per the discussion we don't want this patch, because we 
are using raw locks there to keep mutex lockdep overhead low. 
The value of lockdep-checking such a basic locking primitive is 
minimal - it's rarely tweaked and if it breaks we won't have a 
bootable kernel to begin with.

So instead I suggested a different patch: adding a comment to 
explain why we don't lockdep-cover the mutex code spinlocks.

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

Yes, I mentioned that yesterday, but we really don't want the 
change to begin with.

Thanks,

	Ingo
