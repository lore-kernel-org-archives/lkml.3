Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbbA0SQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:16:36 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:41507 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbbA0SQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:16:34 -0500
Message-ID: <1422382304.6710.15.camel@j-VirtualBox>
Subject: Re: [PATCH 6/6] locking/rwsem: Check for active lock before bailing
 on spinning
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>, jason.low2@hp.com
Date: Tue, 27 Jan 2015 10:11:44 -0800
In-Reply-To: <1422257769-14083-7-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-7-git-send-email-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-25 at 23:36 -0800, Davidlohr Bueso wrote:
> 37e9562453b (locking/rwsem: Allow conservative optimistic
> spinning when readers have lock) forced the default for
> optimistic spinning to be disabled if the lock owner was
> nil, which makes much sense for readers. However, while
> it is not our priority, we can make some optimizations
> for write-mostly workloads. We can bail the spinning step
> and still be conservative if there are any active tasks,
> otherwise there's really no reason not to spin, as the
> semaphore is most likely unlocked.
> 
> This patch recovers most of a Unixbench 'execl' benchmark
> throughput by sleeping less and making better average system
> usage:
> 
> before:
> CPU     %user     %nice   %system   %iowait    %steal     %idle
> all      0.60      0.00      8.02      0.00      0.00     91.38
> 
> after:
> CPU     %user     %nice   %system   %iowait    %steal     %idle
> all      1.22      0.00     70.18      0.00      0.00     28.60
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  kernel/locking/rwsem-xadd.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index 88b3468..e0e9738 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -296,23 +296,30 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
>  static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>  {
>  	struct task_struct *owner;
> -	bool on_cpu = false;
> +	bool ret = true;
>  
>  	if (need_resched())
>  		return false;
>  
>  	rcu_read_lock();
>  	owner = ACCESS_ONCE(sem->owner);
> -	if (owner)
> -		on_cpu = owner->on_cpu;
> -	rcu_read_unlock();
> +	if (!owner) {
> +		long count = ACCESS_ONCE(sem->count);
> +		/*
> +		 * If sem->owner is not set, yet we have just recently entered the
> +		 * slowpath with the lock being active, then there is a possibility
> +		 * reader(s) may have the lock. To be safe, bail spinning in these
> +		 * situations.
> +		 */
> +		if (count & RWSEM_ACTIVE_MASK)
> +			ret = false;
> +		goto done;
> +	}
>  
> -	/*
> -	 * If sem->owner is not set, yet we have just recently entered the
> -	 * slowpath, then there is a possibility reader(s) may have the lock.
> -	 * To be safe, avoid spinning in these situations.
> -	 */
> -	return on_cpu;
> +	ret = owner->on_cpu;
> +done:
> +	rcu_read_unlock();
> +	return ret;
>  }

Acked-by: Jason Low <jason.low2@hp.com>



