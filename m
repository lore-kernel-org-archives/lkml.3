Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3C1RZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:25:25 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:55370 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3C1RZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:25:24 -0400
Message-ID: <1364491509.3559.35.camel@thor.lan>
Subject: Re: [PATCH v2 12/13] rwsem: do not block readers at head of queue
 if other readers are active
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
Date: Thu, 28 Mar 2013 13:25:09 -0400
In-Reply-To: <1363344869-15732-13-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-13-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> This change fixes a race condition where a reader might determine it
> needs to block, but by the time it acquires the wait_lock the rwsem
> has active readers and no queued waiters.
> 
> In this situation the reader can just in parallel with the existing active
                                      ^^^
                                     start ?

> readers; it does not need to block until the active readers complete.
> 
> Thanks to Peter Hurley for noticing this possible race.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  lib/rwsem.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 09bf03e7808c..4e4c8893dc00 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -162,8 +162,14 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
>  	/* we're now waiting on the lock, but no longer actively locking */
>  	count = rwsem_atomic_update(adjustment, sem);
                      ^^^^^^^^^
>  
> -	/* If there are no active locks, wake the front queued process(es). */
> -	if (!(count & RWSEM_ACTIVE_MASK))
> +	/* If there are no active locks, wake the front queued process(es).
> +	 *
> +	 * If there are no writers and we are first in the queue,
> +	 * wake our own waiter to join the existing active readers !
> +	 */
> +	if (count == RWSEM_WAITING_BIAS ||
> +	    (count > RWSEM_WAITING_BIAS &&
> +	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
>  		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);

Thanks for fixing this.


