Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3C1VFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:05:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11822 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3C1VFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:05:50 -0400
Message-ID: <1364504747.8132.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with
 find_alloc_undo
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 14:05:47 -0700
In-Reply-To: <20130328113222.194bbfe8@cuia.bos.redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5151DBD3.6080201@oracle.com> <20130328113222.194bbfe8@cuia.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 11:32 -0400, Rik van Riel wrote:
> On Tue, 26 Mar 2013 13:33:07 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
> > [   96.347341] ================================================
> > [   96.348085] [ BUG: lock held when returning to user space! ]
> > [   96.348834] 3.9.0-rc4-next-20130326-sasha-00011-gbcb2313 #318 Tainted: G        W
> > [   96.360300] ------------------------------------------------
> > [   96.361084] trinity-child9/7583 is leaving the kernel with locks still held!
> > [   96.362019] 1 lock held by trinity-child9/7583:
> > [   96.362610]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192eafb>] SYSC_semtimedop+0x1fb/0xec0
> > 
> > It seems that we can leave semtimedop without releasing the rcu read lock.
> 
> Sasha, this patch untangles the RCU locking with find_alloc_undo,
> and should fix the above issue. As a side benefit, this makes the
> code a little cleaner.
> 
> Next up: implement locking in a way that does not trigger any 
> lockdep warnings...
> 
> ---8<---
> 
> Subject: ipc,sem: untangle RCU locking with find_alloc_undo
> 
> The ipc semaphore code has a nasty RCU locking tangle, with both
> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
> code can be cleaned up somewhat by only taking the rcu_read_lock
> once.

indeed!

> 
> The only caller of find_alloc_undo is in semtimedop.
> 
> This should solve the trinity issue reported by Sasha Levin.
> 
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

find_alloc_undo() has some nested rcu_read_locks of its own. We can
simplify that as well. Will look into it, but don't want to introduce
any more changes until we address all the issues with the patchset, and
know it to behave.

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

Yeah, I was tempted in doing something much like this, but didn't want
to change any existing logic. Hopefully we can get away with this and it
fixes Sasha's issue.

>  
>  	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
>  	if (error <= 0) {

Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>


