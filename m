Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3C1QoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:44:21 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51568 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3C1QoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:44:20 -0400
Message-ID: <1364489046.3559.14.camel@thor.lan>
Subject: Re: [PATCH v2 07/13] rwsem: use cmpxchg for trying to steal write
 lock
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
Date: Thu, 28 Mar 2013 12:44:06 -0400
In-Reply-To: <1363344869-15732-8-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-8-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> Using rwsem_atomic_update to try stealing the write lock forced us to
> undo the adjustment in the failure path. We can have simpler and faster
> code by using cmpxchg instead.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  lib/rwsem.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 2360bf204098..64c2dc007be2 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -142,25 +142,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  	return sem;
>  }
>  
> -/* Try to get write sem, caller holds sem->wait_lock: */
> -static int try_get_writer_sem(struct rw_semaphore *sem)
> -{
> -	long oldcount, adjustment;
> -
> -	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
> -	if (list_is_singular(&sem->wait_list))
> -		adjustment -= RWSEM_WAITING_BIAS;
> -
> -try_again_write:
> -	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> -	if (!(oldcount & RWSEM_ACTIVE_MASK))
> -		return 1;
> -	/* some one grabbed the sem already */
> -	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
> -		return 0;
> -	goto try_again_write;
> -}
> -
>  /*
>   * wait for the read lock to be granted
>   */
> @@ -236,7 +217,12 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
>  	while (true) {
>  		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>  
> -		if (try_get_writer_sem(sem))
> +		/* Try acquiring the write lock. */
> +		count = RWSEM_ACTIVE_WRITE_BIAS;
> +		if (!list_is_singular(&sem->wait_list))
> +			count += RWSEM_WAITING_BIAS;
> +		if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
> +							RWSEM_WAITING_BIAS)

This is just my opinion but I think this is way more readable if this
stays in try_get_writer_sem() and you change that to static inline
rather than inlining here. Especially because 9/13 adds a scope.

>  			break;
>  
>  		raw_spin_unlock_irq(&sem->wait_lock);


