Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3C1Qvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:51:51 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:52188 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab3C1Qvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:51:49 -0400
Message-ID: <1364489492.3559.18.camel@thor.lan>
Subject: Re: [PATCH v2 10/13] rwsem: simplify __rwsem_do_wake
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 12:51:32 -0400
In-Reply-To: <1363344869-15732-11-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-11-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> This is mostly for cleanup value:
> 
> - We don't need several gotos to handle the case where the first
>   waiter is a writer. Two simple tests will do (and generate very
>   similar code).
> 
> - In the remainder of the function, we know the first waiter is a reader,
>   so we don't have to double check that. We can use do..while loops
>   to iterate over the readers to wake (generates slightly better code).
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  lib/rwsem-spinlock.c | 25 ++++++++-----------------
>  lib/rwsem.c          | 26 ++++++++++++--------------
>  2 files changed, 20 insertions(+), 31 deletions(-)
> 
> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
> index 5f117f37ac0a..20207a6e8ac3 100644
> --- a/lib/rwsem-spinlock.c
> +++ b/lib/rwsem-spinlock.c
> @@ -70,26 +70,17 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  
>  	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
>  
> -	if (!wakewrite) {
> -		if (waiter->type == RWSEM_WAITING_FOR_WRITE)
> -			goto out;
> -		goto dont_wake_writers;
> -	}
> -
> -	/*
> -	 * as we support write lock stealing, we can't set sem->activity
> -	 * to -1 here to indicate we get the lock. Instead, we wake it up
> -	 * to let it go get it again.
> -	 */
>  	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
> -		wake_up_process(waiter->task);
> +		if (wakewrite)
> +			/* Wake up a writer. Note that we do not grant it the
> +			 * lock - it will have to acquire it when it runs. */
> +			wake_up_process(waiter->task);
>  		goto out;
>  	}
>  
> -	/* grant an infinite number of read locks to the front of the queue */
> - dont_wake_writers:
> +	/* grant read locks to all queued readers. */

I think the original comment still applies here now?

>  	woken = 0;
> -	while (waiter->type == RWSEM_WAITING_FOR_READ) {
> +	do {
>  		struct list_head *next = waiter->list.next;
>  
>  		list_del(&waiter->list);
> @@ -99,10 +90,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  		wake_up_process(tsk);
>  		put_task_struct(tsk);
>  		woken++;
> -		if (list_empty(&sem->wait_list))
> +		if (next == &sem->wait_list)
>  			break;
>  		waiter = list_entry(next, struct rwsem_waiter, list);
> -	}
> +	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);

Maybe convert this to list_for_each_entry_safe() since you're cleaning
it up?

>  
>  	sem->activity += woken;
>  
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 0d50e46d5b0c..9a675fa9d78e 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -68,20 +68,17 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  	signed long woken, loop, adjustment;
>  
>  	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
> -	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
> -		goto readers_only;
> -
> -	if (wake_type == RWSEM_WAKE_READ_OWNED)
> -		/* Another active reader was observed, so wakeup is not
> -		 * likely to succeed. Save the atomic op.
> -		 */
> +	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
> +		if (wake_type != RWSEM_WAKE_READ_OWNED)
> +			/* Wake writer at the front of the queue, but do not
> +			 * grant it the lock yet as we want other writers
> +			 * to be able to steal it.  Readers, on the other hand,
> +			 * will block as they will notice the queued writer.
> +			 */
> +			wake_up_process(waiter->task);
>  		goto out;
> +	}
>  
> -	/* Wake up the writing waiter and let the task grab the sem: */
> -	wake_up_process(waiter->task);
> -	goto out;
> -
> - readers_only:
>  	/* If we come here from up_xxxx(), another thread might have reached
>  	 * rwsem_down_failed_common() before we acquired the spinlock and
>  	 * woken up a waiter, making it now active.  We prefer to check for
> @@ -125,7 +122,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  	rwsem_atomic_add(adjustment, sem);
>  
>  	next = sem->wait_list.next;
> -	for (loop = woken; loop > 0; loop--) {
> +	loop = woken;
> +	do {
>  		waiter = list_entry(next, struct rwsem_waiter, list);
>  		next = waiter->list.next;
>  		tsk = waiter->task;
> @@ -133,7 +131,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  		waiter->task = NULL;
>  		wake_up_process(tsk);
>  		put_task_struct(tsk);
> -	}
> +	} while (--loop);
>  
>  	sem->wait_list.next = next;
>  	next->prev = &sem->wait_list;


