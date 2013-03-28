Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3C1QV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:21:27 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:49694 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab3C1QVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:21:25 -0400
Message-ID: <1364487672.3559.5.camel@thor.lan>
Subject: Re: [PATCH v2 02/13] rwsem: shorter spinlocked section in
 rwsem_down_failed_common()
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
Date: Thu, 28 Mar 2013 12:21:12 -0400
In-Reply-To: <1363344869-15732-3-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> This change reduces the size of the spinlocked and TASK_UNINTERRUPTIBLE
> sections in rwsem_down_failed_common():
> 
> - We only need the sem->wait_lock to insert ourselves on the wait_list;
>   the waiter node can be prepared outside of the wait_lock.
> 
> - The task state only needs to be set to TASK_UNINTERRUPTIBLE immediately
>   before checking if we actually need to sleep; it doesn't need to protect
>   the entire function.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  lib/rwsem.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 672eb33218ac..40636454cf3c 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -188,14 +188,12 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  	struct task_struct *tsk = current;
>  	signed long count;
>  
> -	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> -
>  	/* set up my own style of waitqueue */
> -	raw_spin_lock_irq(&sem->wait_lock);
>  	waiter.task = tsk;
>  	waiter.type = type;
>  	get_task_struct(tsk);
>  
> +	raw_spin_lock_irq(&sem->wait_lock);
>  	if (list_empty(&sem->wait_list))
>  		adjustment += RWSEM_WAITING_BIAS;
>  	list_add_tail(&waiter.list, &sem->wait_list);
> @@ -218,7 +216,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  	raw_spin_unlock_irq(&sem->wait_lock);
>  
>  	/* wait to be given the lock */
> -	for (;;) {
> +	while (true) {

I would drop this gratutious change.

> +		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>  		if (!waiter.task)
>  			break;
>  
> @@ -231,7 +230,6 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  			}
>  		raw_spin_unlock_irq(&sem->wait_lock);
>  		schedule();
> -		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>  	}
>  
>  	tsk->state = TASK_RUNNING;


