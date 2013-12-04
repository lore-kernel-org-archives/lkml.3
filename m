Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3LDBDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:03:40 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26785 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:03:39 -0500
Message-ID: <1386119012.2836.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: avoid overflow of semop undo (semadj) value
From: Davidlohr Bueso <davidlohr@hp.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 17:03:32 -0800
In-Reply-To: <1386063865-23966-1-git-send-email-pmladek@suse.cz>
References: <1386063865-23966-1-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 10:44 +0100, Petr Mladek wrote:
> When trying to understand semop code, I found a small mistake in the check for
> semadj (undo) value overflow. The new undo value is not stored immediately
> and next potential checks are done against the old value.
> 
> The failing scenario is not much practical. One semop call has to do more
> operations on the same semaphore. Also semval and semadj must have different
> values, so there has to be some operations without SEM_UNDO flag. For example:
> 
> 	struct sembuf depositor_op[1];
> 	struct sembuf collector_op[2];
> 
> 	depositor_op[0].sem_num = 0;
> 	depositor_op[0].sem_op = 20000;
> 	depositor_op[0].sem_flg = 0;
> 
> 	collector_op[0].sem_num = 0;
> 	collector_op[0].sem_op = -10000;
> 	collector_op[0].sem_flg = SEM_UNDO;
> 	collector_op[1].sem_num = 0;
> 	collector_op[1].sem_op = -10000;
> 	collector_op[1].sem_flg = SEM_UNDO;
> 
> 	if (semop(semid, depositor_op, 1) == -1)
> 		{ perror("Failed to do 1st deposit"); return 1; }
> 
> 	if (semop(semid, collector_op, 2) == -1)
> 		{ perror("Failed to do 1st collect"); return 1; }
> 
> 	if (semop(semid, depositor_op, 1) == -1)
> 		{ perror("Failed to do 2nd deposit"); return 1; }
> 
> 	if (semop(semid, collector_op, 2) == -1)
> 		{ perror("Failed to do 2nd collect"); return 1; }
> 
> 	return 0;
> 
> It passes without error now but the semadj value has overflown in the
> 2nd collector operation.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>

Seems sane.

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

> ---
>  ipc/sem.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index db9d241af133..0d4375761449 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -599,7 +599,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
>  static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
>  			     int nsops, struct sem_undo *un, int pid)
>  {
> -	int result, sem_op;
> +	int result, undo, sem_op;
>  	struct sembuf *sop;
>  	struct sem * curr;
>  
> @@ -607,7 +607,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
>  		curr = sma->sem_base + sop->sem_num;
>  		sem_op = sop->sem_op;
>  		result = curr->semval;
> -  
> +
>  		if (!sem_op && result)
>  			goto would_block;
>  
> @@ -616,25 +616,24 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
>  			goto would_block;
>  		if (result > SEMVMX)
>  			goto out_of_range;
> +
>  		if (sop->sem_flg & SEM_UNDO) {
> -			int undo = un->semadj[sop->sem_num] - sem_op;
> -			/*
> -	 		 *	Exceeding the undo range is an error.
> -			 */
> +			undo = un->semadj[sop->sem_num] - sem_op;
> +			/* Exceeding the undo range is an error. */
>  			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
>  				goto out_of_range;
> +			un->semadj[sop->sem_num] = undo;
>  		}
> +
>  		curr->semval = result;
>  	}
>  
>  	sop--;
>  	while (sop >= sops) {
>  		sma->sem_base[sop->sem_num].sempid = pid;
> -		if (sop->sem_flg & SEM_UNDO)
> -			un->semadj[sop->sem_num] -= sop->sem_op;
>  		sop--;
>  	}
> -	
> +
>  	return 0;
>  
>  out_of_range:
> @@ -650,7 +649,10 @@ would_block:
>  undo:
>  	sop--;
>  	while (sop >= sops) {
> -		sma->sem_base[sop->sem_num].semval -= sop->sem_op;
> +		sem_op = sop->sem_op;
> +		sma->sem_base[sop->sem_num].semval -= sem_op;
> +		if (sop->sem_flg & SEM_UNDO)
> +			un->semadj[sop->sem_num] += sem_op;
>  		sop--;
>  	}
>  


