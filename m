Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3I3Ryo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:54:44 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17127 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3I3Ryn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:54:43 -0400
Message-ID: <1380563681.2431.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/sem.c: synchronize semop and semctl with IPC_RMID
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Date: Mon, 30 Sep 2013 10:54:41 -0700
In-Reply-To: <1380532423-19613-1-git-send-email-manfred@colorfullife.com>
References: <1380532423-19613-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

On Mon, 2013-09-30 at 11:13 +0200, Manfred Spraul wrote:
> After acquiring the semlock spinlock, the operations must test that the
> array is still valid.
> 
> - semctl() and exit_sem() would walk stale linked lists (ugly, but should
>   be ok: all lists are empty)
> 
> - semtimedop() would sleep forever - and if woken up due to a signal -
>   access memory after free.

Yep, that was next on my list - I had a patch for semtimedop() but was
waiting to rebase it on top of your previous changes. Anyway thanks for
sending this.

> 
> The patch standardizes the tests for .deleted, so that all tests in one
> function leave the function with the same approach.
> 
> Right now, it's a mixture of "goto cleanup", some cleanup and then
> "goto further_cleanup" and all cleanup+"return -EIDRM" - that makes the
> review much harder.
> 
> Davidlohr: Could you please review the patch?
> I did some stress test, but probably I didn't hit exactly the modified
> lines.

This shouldn't affect performance, if that's what you mean. One more
read in the critical region won't make any difference. The patch looks
good, just one doubt below.


> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/sem.c | 43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 19c8b98..a2fa795 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1229,6 +1229,12 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
>  
>  	sem_lock(sma, NULL, -1);
>  
> +	if (sma->sem_perm.deleted) {
> +		sem_unlock(sma, -1);
> +		rcu_read_unlock();
> +		return -EIDRM;
> +	}
> +
>  	curr = &sma->sem_base[semnum];
>  
>  	ipc_assert_locked_object(&sma->sem_perm);
> @@ -1285,10 +1291,8 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  		sem_lock(sma, NULL, -1);
>  		if(nsems > SEMMSL_FAST) {
>  			if (!ipc_rcu_getref(sma)) {
> -				sem_unlock(sma, -1);
> -				rcu_read_unlock();
>  				err = -EIDRM;
> -				goto out_free;
> +				goto out_unlock;
>  			}
>  			sem_unlock(sma, -1);
>  			rcu_read_unlock();
> @@ -1301,10 +1305,13 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  			rcu_read_lock();
>  			sem_lock_and_putref(sma);
>  			if (sma->sem_perm.deleted) {
> -				sem_unlock(sma, -1);
> -				rcu_read_unlock();
>  				err = -EIDRM;
> -				goto out_free;
> +				goto out_unlock;
> +			}
> +		} else {
> +			if (sma->sem_perm.deleted) {
> +				err = -EIDRM;
> +				goto out_unlock;
>  			}

I'm a bit lost here. Why should we only check the existence of the sem
if nsems <= SEMMSL_FAST? Shouldn't the same should apply either way? 

Thanks,
Davidlohr

