Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaGDIxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:53:22 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:14157 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:53:20 -0400
Message-ID: <1404463996.2457.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 04 Jul 2014 01:53:16 -0700
In-Reply-To: <1404457579.8764.161.camel@j-VirtualBox>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
	 <1404438890.8764.125.camel@j-VirtualBox> <20140704061306.GK9508@dastard>
	 <1404457579.8764.161.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 00:06 -0700, Jason Low 
> Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner

Could we change the subject to something more descriptive, ie:

rwsem: Allow conservative optimistic spinning for reader/writer paths

Thanks,
Davidlohr

> Commit 4fc828e24cd9 ("locking/rwsem: Support optimistic spinning")
> introduced a major performance regression for workloads such as
> xfs_repair which mix read and write locking of the mmap_sem across
> many threads. The result was xfs_repair ran 5x slower on 3.16-rc2
> than on 3.15 and using 20x more system CPU time.
> 
> Perf profiles indicate in some workloads that significant time can
> be spent spinning on !owner. This is because we don't set the lock
> owner when readers(s) obtain the rwsem.
> 
> In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll
> return false if there is no lock owner. The rationale is that if we
> just entered the slowpath, yet there is no lock owner, then there is
> a possibility that a reader has the lock. To be conservative, we'll
> avoid spinning in these situations.
> 
> This patch reduced the total run time of the xfs_repair workload from
> about 4 minutes 24 seconds down to approximately 1 minute 26 seconds,
> back to close to the same performance as on 3.15.
> 
> Tested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/locking/rwsem-xadd.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index dacc321..c40c7d2 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -285,10 +285,10 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
>  static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>  {
>  	struct task_struct *owner;
> -	bool on_cpu = true;
> +	bool on_cpu = false;
>  
>  	if (need_resched())
> -		return 0;
> +		return false;
>  
>  	rcu_read_lock();
>  	owner = ACCESS_ONCE(sem->owner);
> @@ -297,9 +297,9 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>  	rcu_read_unlock();
>  
>  	/*
> -	 * If sem->owner is not set, the rwsem owner may have
> -	 * just acquired it and not set the owner yet or the rwsem
> -	 * has been released.
> +	 * If sem->owner is not set, yet we have just recently entered the
> +	 * slowpath, then there is a possibility reader(s) may have the lock.
> +	 * To be safe, avoid spinning in these situations.
>  	 */
>  	return on_cpu;
>  }


