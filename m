Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3FPXEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 19:04:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51602 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab3FPXEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 19:04:13 -0400
Date: Sun, 16 Jun 2013 16:04:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, Michal Hocko <mhocko@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.11] percpu-refcount: use RCU-sched insted of
 normal RCU
Message-ID: <20130616230404.GX5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130616215546.GB28587@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616215546.GB28587@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061623-5806-0000-0000-000021BB5AE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 02:55:46PM -0700, Tejun Heo wrote:
> percpu-refcount was incorrectly using preempt_disable/enable() for RCU
> critical sections against call_rcu().  6a24474da8 ("percpu-refcount:
> consistently use plain (non-sched) RCU") fixed it by converting the
> preepmtion operations with rcu_read_[un]lock() citing that there isn't
> any advantage in using sched-RCU over using the usual one; however,
> rcu_read_[un]lock() for the preemptible RCU implementation -
> CONFIG_TREE_PREEMPT_RCU, chosen when CONFIG_PREEMPT - are slightly
> more expensive than preempt_disable/enable().
> 
> In a contrived microbench which repeats the followings,
> 
>  - percpu_ref_get()
>  - copy 32 bytes of data into percpu buffer
>  - percpu_put_get()
>  - copy 32 bytes of data into percpu buffer
> 
> rcu_read_[un]lock() used in percpu_ref_get/put() makes it go slower by
> about 15% when compared to using sched-RCU.
> 
> As the RCU critical sections are extremely short, using sched-RCU
> shouldn't have any latency implications.  Convert to RCU-sched.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <koverstreet@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/percpu-refcount.h |   12 ++++++------
>  lib/percpu-refcount.c           |    2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -105,7 +105,7 @@ static inline void percpu_ref_get(struct
>  {
>  	unsigned __percpu *pcpu_count;
> 
> -	rcu_read_lock();
> +	rcu_read_lock_sched();
> 
>  	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> 
> @@ -114,7 +114,7 @@ static inline void percpu_ref_get(struct
>  	else
>  		atomic_inc(&ref->count);
> 
> -	rcu_read_unlock();
> +	rcu_read_unlock_sched();
>  }
> 
>  /**
> @@ -134,7 +134,7 @@ static inline bool percpu_ref_tryget(str
>  	unsigned __percpu *pcpu_count;
>  	int ret = false;
> 
> -	rcu_read_lock();
> +	rcu_read_lock_sched();
> 
>  	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> 
> @@ -143,7 +143,7 @@ static inline bool percpu_ref_tryget(str
>  		ret = true;
>  	}
> 
> -	rcu_read_unlock();
> +	rcu_read_unlock_sched();
> 
>  	return ret;
>  }
> @@ -159,7 +159,7 @@ static inline void percpu_ref_put(struct
>  {
>  	unsigned __percpu *pcpu_count;
> 
> -	rcu_read_lock();
> +	rcu_read_lock_sched();
> 
>  	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> 
> @@ -168,7 +168,7 @@ static inline void percpu_ref_put(struct
>  	else if (unlikely(atomic_dec_and_test(&ref->count)))
>  		ref->release(ref);
> 
> -	rcu_read_unlock();
> +	rcu_read_unlock_sched();
>  }
> 
>  #endif
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -154,5 +154,5 @@ void percpu_ref_kill_and_confirm(struct
>  		(((unsigned long) ref->pcpu_count)|PCPU_REF_DEAD);
>  	ref->confirm_kill = confirm_kill;
> 
> -	call_rcu(&ref->rcu, percpu_ref_kill_rcu);
> +	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
>  }
> 

