Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3FLMPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:15:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3FLMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:15:37 -0400
Date: Wed, 12 Jun 2013 14:15:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de
Subject: Re: [PATCH] spin_unlock*_no_resched()
Message-ID: <20130612121532.GD3204@twins.programming.kicks-ass.net>
References: <1022041371038807@web30d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1022041371038807@web30d.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:06:47PM +0400, Kirill Tkhai wrote:
> There are many constructions like:
> 
> 	spin_unlock_irq(lock);
> 	schedule();
> 
> In case of preemptible kernel we check if task needs reschedule
> at the end of spin_unlock(). So if TIF_NEED_RESCHED is set
> we call schedule() twice and we have a little overhead here.
> Add primitives to avoid these situations.
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/spinlock.h         |   27 +++++++++++++++++++++++++++
>  include/linux/spinlock_api_smp.h |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/spinlock_api_up.h  |   13 +++++++++++++
>  kernel/spinlock.c                |   20 ++++++++++++++++++++
>  4 files changed, 97 insertions(+), 0 deletions(-)
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 7d537ce..35caa32 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -221,13 +221,24 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>  #define raw_spin_lock_irq(lock)		_raw_spin_lock_irq(lock)
>  #define raw_spin_lock_bh(lock)		_raw_spin_lock_bh(lock)
>  #define raw_spin_unlock(lock)		_raw_spin_unlock(lock)
> +#define raw_spin_unlock_no_resched(lock)	\
> +	_raw_spin_unlock_no_resched(lock)
> +
>  #define raw_spin_unlock_irq(lock)	_raw_spin_unlock_irq(lock)
> +#define raw_spin_unlock_irq_no_resched(lock)	\
> +	_raw_spin_unlock_irq_no_resched(lock)
>  
>  #define raw_spin_unlock_irqrestore(lock, flags)		\
>  	do {							\
>  		typecheck(unsigned long, flags);		\
>  		_raw_spin_unlock_irqrestore(lock, flags);	\
>  	} while (0)
> +#define raw_spin_unlock_irqrestore_no_resched(lock, flags)	\
> +	do {							\
> +		typecheck(unsigned long, flags);		\
> +		_raw_spin_unlock_irqrestore_no_resched(lock, flags);	\
> +	} while (0)

So I absolutely hate this API because people can (and invariably will)
abuse it; much like they did/do preempt_enable_no_resched().

IIRC Thomas even maps preempt_enable_no_resched() to preempt_enable() in
-rt to make sure we don't miss preemption points due to stupidity.

He converted the 'few' sane sites to use schedule_preempt_disabled(). In
that vein, does it make sense to introduce schedule_spin_locked()?

Also, your patch 'fails' to make use of the new API.
