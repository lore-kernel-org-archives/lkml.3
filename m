Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaHHTux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:50:53 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58880 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaHHTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:50:51 -0400
Message-ID: <1407527412.8365.60.camel@j-VirtualBox>
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Date: Fri, 08 Aug 2014 12:50:12 -0700
In-Reply-To: <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
	 <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>
	 <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net>
	 <1407476387.2513.39.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  __visible __used noinline
> @@ -730,6 +744,23 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>  	if (__mutex_slowpath_needs_to_unlock())
>  		atomic_set(&lock->count, 1);
>  
> +/*
> + * Skipping the mutex_has_owner() check when DEBUG, allows us to
> + * avoid taking the wait_lock in order to do not call mutex_release()
> + * and debug_mutex_unlock() when !DEBUG. This can otherwise result in
> + * deadlocks when another task enters the lock's slowpath in mutex_lock().
> + */
> +#ifndef CONFIG_DEBUG_MUTEXES
> +	/*
> +	 * Abort the wakeup operation if there is an another mutex owner, as the
> +	 * lock was stolen. mutex_unlock() should have cleared the owner field
> +	 * before calling this function. If that field is now set, another task
> +	 * must have acquired the mutex.
> +	 */
> +	if (mutex_has_owner(lock))
> +		return;

Would we need the mutex lock count to eventually get set to a negative
value if there are waiters? An optimistic spinner can get the lock and
set lock->count to 0. Then the lock count might remain 0 since a waiter
might not get waken up here to try-lock and set lock->count to -1 if it
goes back to sleep in the lock path.


