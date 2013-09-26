Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3IZIx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:53:26 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64781 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3IZIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:53:23 -0400
Message-ID: <5243F5FE.10103@gmail.com>
Date: Thu, 26 Sep 2013 16:53:18 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/2] Update sem_otime for all operations
References: <1380172135-11025-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1380172135-11025-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Jia He<jiakernel@gmail.com>

# cat /proc/sysvipc/sem 
       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime
        -1      32768   666          1     0     0     0     0 1380185570 1380185570


On Thu, 26 Sep 2013 07:08:55 +0200 from manfred@colorfullife.com wrote:
> Hi Jia,
>
> Could you check if the patch below resolves the bug you have reported?
> Just this patch, i.e. without your proposal.
>
> I want to leave the optimization for the get_seconds() call:
> We must update sem_otime in two places anyway
> (either perform_atomic_semop() and exit_sem() or
> do_smart_update() and semtimedop())
>
> --
> 	Manfred
>
> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
> was moved to one central position (do_smart_update).
>
> But: Since do_smart_update() is only called for operations that modify
> the array, this means that wait-for-zero semops do not update sem_otime
> anymore.
>
> The fix is simple:
> Non-alter operations must update sem_otime.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Reported-by: Jia He <jiakernel@gmail.com>
> ---
>  ipc/sem.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/ipc/sem.c b/ipc/sem.c
> index e5d9bb8..ec83f79 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -910,6 +910,24 @@ again:
>  }
>  
>  /**
> + * set_semotime(sma, sops) - set sem_otime
> + * @sma: semaphore array
> + * @sops: operations that modified the array, may be NULL
> + *
> + * sem_otime is replicated to avoid cache line trashing.
> + * This function sets one instance to the current time.
> + */
> +static void set_semotime(struct sem_array *sma, struct sembuf *sops)
> +{
> +	if (sops == NULL) {
> +		sma->sem_base[0].sem_otime = get_seconds();
> +	} else {
> +		sma->sem_base[sops[0].sem_num].sem_otime =
> +							get_seconds();
> +	}
> +}
> +
> +/**
>   * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
>   * @sma: semaphore array
>   * @sops: operations that were performed
> @@ -959,17 +977,10 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
>  			}
>  		}
>  	}
> -	if (otime) {
> -		if (sops == NULL) {
> -			sma->sem_base[0].sem_otime = get_seconds();
> -		} else {
> -			sma->sem_base[sops[0].sem_num].sem_otime =
> -								get_seconds();
> -		}
> -	}
> +	if (otime)
> +		set_semotime(sma, sops);
>  }
>  
> -
>  /* The following counts are associated to each semaphore:
>   *   semncnt        number of tasks waiting on semval being nonzero
>   *   semzcnt        number of tasks waiting on semval being zero
> @@ -1831,10 +1842,16 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  
>  	error = perform_atomic_semop(sma, sops, nsops, un,
>  					task_tgid_vnr(current));
> -	if (error <= 0) {
> -		if (alter && error == 0)
> +	if (error == 0) {
> +		/* If the operation was successful, then do
> +		 * the required updates.
> +		 */
> +		if (alter)
>  			do_smart_update(sma, sops, nsops, 1, &tasks);
> -
> +		else
> +			set_semotime(sma, sops);
> +	}
> +	if (error <= 0) {
>  		goto out_unlock_free;
>  	}
>  

