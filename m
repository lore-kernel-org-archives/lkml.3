Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaELST4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:19:56 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21633 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaELSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:19:55 -0400
Message-ID: <1399918792.2648.29.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/6] ipc/sem.c: remove code duplication
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Date: Mon, 12 May 2014 11:19:52 -0700
In-Reply-To: <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
> count_semzcnt and count_semncnt are more of less identical.
> The patch creates a single function that either counts the number of tasks
> waiting for zero or waiting due to a decrease operation.

This is a nice cleanup.

> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/sem.c | 103 ++++++++++++++++++++++++++++++--------------------------------
>  1 file changed, 50 insertions(+), 53 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index dc648f8..821aba7 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -47,8 +47,7 @@
>   *   Thus: Perfect SMP scaling between independent semaphore arrays.
>   *         If multiple semaphores in one array are used, then cache line
>   *         trashing on the semaphore array spinlock will limit the scaling.
> - * - semncnt and semzcnt are calculated on demand in count_semncnt() and
> - *   count_semzcnt()
> + * - semncnt and semzcnt are calculated on demand in count_semcnt()
>   * - the task that performs a successful semop() scans the list of all
>   *   sleeping tasks and completes any pending operations that can be fulfilled.
>   *   Semaphores are actively given to waiting tasks (necessary for FIFO).
> @@ -989,6 +988,31 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
>  		set_semotime(sma, sops);
>  }
>  
> +/*
> + * check_qop: Test how often a queued operation sleeps on the semaphore semnum
> + */
> +static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
> +			bool count_zero)


Instead of directly calling check_qop(..., true/false), how about doing
something like the following? Should generate better code.

static inline int check_qop_zero(struct sem_array *sma, int semnum, struct sem_queue q)
{
	return check_qop(sma, senum, q, true);
}

static linline int check_qop_nonzero(struct sem_array *sma, int semnum, struct sem_queue q)
{
	return check_qop(sma, senum, q, false);
}

Perhaps instead of nonzero/zero we could replace it with the standard semncnt, semzcnt.

> +{
> +	struct sembuf *sops = q->sops;
> +	int nsops = q->nsops;
> +	int i, semcnt;
> +
> +	semcnt = 0;
> +
> +	for (i = 0; i < nsops; i++) {
> +		if (sops[i].sem_num != semnum)
> +			continue;
> +		if (sops[i].sem_flg & IPC_NOWAIT)
> +			continue;
> +		if (count_zero && sops[i].sem_op == 0)
> +			semcnt++;
> +		if (!count_zero && sops[i].sem_op < 0)
> +			semcnt++;
> +	}
> +	return semcnt;
> +}
> +
>  /* The following counts are associated to each semaphore:
>   *   semncnt        number of tasks waiting on semval being nonzero
>   *   semzcnt        number of tasks waiting on semval being zero
> @@ -998,66 +1022,39 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
>   * The counts we return here are a rough approximation, but still
>   * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
>   */
> -static int count_semncnt(struct sem_array *sma, ushort semnum)
> +static int count_semcnt(struct sem_array *sma, ushort semnum,
> +			bool count_zero)
>  {
> -	int semncnt;
> +	struct list_head *l;
>  	struct sem_queue *q;
> +	int semcnt;
>  
> -	semncnt = 0;

nit: can we unify the declaration and assignment?

> -	list_for_each_entry(q, &sma->sem_base[semnum].pending_alter, list) {
> -		struct sembuf *sops = q->sops;
> -		BUG_ON(sops->sem_num != semnum);
> -		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
> -			semncnt++;
> -	}
> +	semcnt = 0;
> +	/* First: check the simple operations. They are easy to evaluate */
> +	if (count_zero)
> +		l = &sma->sem_base[semnum].pending_const;
> +	else
> +		l = &sma->sem_base[semnum].pending_alter;
>  
> -	list_for_each_entry(q, &sma->pending_alter, list) {
> +	list_for_each_entry(q, l, list) {
>  		struct sembuf *sops = q->sops;
> -		int nsops = q->nsops;
> -		int i;
> -		for (i = 0; i < nsops; i++)
> -			if (sops[i].sem_num == semnum
> -			    && (sops[i].sem_op < 0)
> -			    && !(sops[i].sem_flg & IPC_NOWAIT))
> -				semncnt++;
> -	}
> -	return semncnt;
> -}
>  
> -static int count_semzcnt(struct sem_array *sma, ushort semnum)
> -{
> -	int semzcnt;
> -	struct sem_queue *q;
> -
> -	semzcnt = 0;
> -	list_for_each_entry(q, &sma->sem_base[semnum].pending_const, list) {
> -		struct sembuf *sops = q->sops;
>  		BUG_ON(sops->sem_num != semnum);
> -		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
> -			semzcnt++;
> +		BUG_ON(sops->sem_flg & IPC_NOWAIT);
> +		BUG_ON(sops->sem_op > 0);
> +		semcnt++;
>  	}
>  
> -	list_for_each_entry(q, &sma->pending_const, list) {
> -		struct sembuf *sops = q->sops;
> -		int nsops = q->nsops;
> -		int i;
> -		for (i = 0; i < nsops; i++)
> -			if (sops[i].sem_num == semnum
> -			    && (sops[i].sem_op == 0)
> -			    && !(sops[i].sem_flg & IPC_NOWAIT))
> -				semzcnt++;
> -	}
> +	/* Then: check the complex operations. */
>  	list_for_each_entry(q, &sma->pending_alter, list) {
> -		struct sembuf *sops = q->sops;
> -		int nsops = q->nsops;
> -		int i;
> -		for (i = 0; i < nsops; i++)
> -			if (sops[i].sem_num == semnum
> -			    && (sops[i].sem_op == 0)
> -			    && !(sops[i].sem_flg & IPC_NOWAIT))
> -				semzcnt++;
> +		semcnt += check_qop(sma, semnum, q, count_zero);
> +	}
> +	if (count_zero) {
> +		list_for_each_entry(q, &sma->pending_const, list) {
> +			semcnt += check_qop(sma, semnum, q, count_zero);
> +		}
>  	}
> -	return semzcnt;
> +	return semcnt;
>  }
>  
>  /* Free a semaphore set. freeary() is called with sem_ids.rwsem locked
> @@ -1459,10 +1456,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  		err = curr->sempid;
>  		goto out_unlock;
>  	case GETNCNT:
> -		err = count_semncnt(sma, semnum);
> +		err = count_semcnt(sma, semnum, 0);
>  		goto out_unlock;
>  	case GETZCNT:
> -		err = count_semzcnt(sma, semnum);
> +		err = count_semcnt(sma, semnum, 1);

nit: use true/false in count_semcnt().

>  		goto out_unlock;
>  	}
>  

Thanks,
Davidlohr

