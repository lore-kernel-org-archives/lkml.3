Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3DEEiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:38:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49796 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3DEEiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:38:22 -0400
Message-ID: <1365136697.4579.12.camel@marge.simpson.net>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with
 find_alloc_undo
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 05 Apr 2013 06:38:17 +0200
In-Reply-To: <20130326160059.7b466a8d@annuminas.surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5151DBD3.6080201@oracle.com>
	 <1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>
	 <5151E3D2.1070103@oracle.com>
	 <20130326160059.7b466a8d@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:mHCBsFdten85aI5B1APGi6HTIWCG4mQvPhbAoCJF3LV
 eXRymzsH4Di+rwKX2YLPj35yr9Khher6qcYMTOYStBlC5mau08
 0jcARbanWtHtvKYW573Qc5uuI0OYEMmR1KuFGIq2aW+u8CwphR
 J6ScDzjNp8y/LjsH7S9ZihHnEzuWqdPja69sim3Eb7QsRu+g+8
 VJfNQvFWqbXyUMv8tOSST5uYojUvvvavnuwI3rRqKomVJ+gbar
 fW222c1vBfdR/CLU3X0n7hwpaF4/evot3qYWYkaYjGvx/mAVE2
 /bKcRNczUtBLxIAQPhhh+Y/Ir0puovwzl1loQrdu6Jp39PGfZi
 5kux0DavtnkkfRQ98TLf+txFAsyCbIG2dzvdtZDOxM/s6ecLOh
 RTpN+mqoqesRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 16:00 -0400, Rik van Riel wrote: 
> On Tue, 26 Mar 2013 14:07:14 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
> > > Not necessarily, we do release everything at the end of the function: 
> > >     out_unlock_free:
> > > 	sem_unlock(sma, locknum);
> > 
> > Ow, there's a rcu_read_unlock() in sem_unlock()? This complicates things even
> > more I suspect. If un is non-NULL we'll be unlocking rcu lock twice?
> 
> Sasha, this patch should resolve the RCU tangle, by making sure
> we only ever take the rcu_read_lock once in semtimedop.
> 
> ---8<---
> 
> The ipc semaphore code has a nasty RCU locking tangle, with both
> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
> code can be cleaned up somewhat by only taking the rcu_read_lock
> once.
> 
> There are no other callers to find_alloc_undo.
> 
> This should also solve the trinity issue reported by Sasha Levin.

I take it this is on top of the patchlet Sasha submitted?

(I hit rcu stall banging on patch set in rt with 60 synchronized core
executive model if I let it run long enough, fwtw)

> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  ipc/sem.c |   31 +++++++++----------------------
>  1 files changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index f46441a..2ec2945 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1646,22 +1646,23 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  			alter = 1;
>  	}
>  
> +	INIT_LIST_HEAD(&tasks);
> +
>  	if (undos) {
> +		/* On success, find_alloc_undo takes the rcu_read_lock */
>  		un = find_alloc_undo(ns, semid);
>  		if (IS_ERR(un)) {
>  			error = PTR_ERR(un);
>  			goto out_free;
>  		}
> -	} else
> +	} else {
>  		un = NULL;
> +		rcu_read_lock();
> +	}
>  
> -	INIT_LIST_HEAD(&tasks);
> -
> -	rcu_read_lock();
>  	sma = sem_obtain_object_check(ns, semid);
>  	if (IS_ERR(sma)) {
> -		if (un)
> -			rcu_read_unlock();
> +		rcu_read_unlock();
>  		error = PTR_ERR(sma);
>  		goto out_free;
>  	}
> @@ -1693,22 +1694,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  	 */
>  	error = -EIDRM;
>  	locknum = sem_lock(sma, sops, nsops);
> -	if (un) {
> -		if (un->semid == -1) {
> -			rcu_read_unlock();
> -			goto out_unlock_free;
> -		} else {
> -			/*
> -			 * rcu lock can be released, "un" cannot disappear:
> -			 * - sem_lock is acquired, thus IPC_RMID is
> -			 *   impossible.
> -			 * - exit_sem is impossible, it always operates on
> -			 *   current (or a dead task).
> -			 */
> -
> -			rcu_read_unlock();
> -		}
> -	}
> +	if (un && un->semid == -1)
> +		goto out_unlock_free;
>  
>  	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
>  	if (error <= 0) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


