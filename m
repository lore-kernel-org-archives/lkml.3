Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbaFQOzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:55:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54774 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162AbaFQOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:54:30 -0400
Date: Tue, 17 Jun 2014 07:54:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify
 force_quiescent_state()
Message-ID: <20140617145419.GE4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539FAE21.7070702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539FAE21.7070702@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061714-0928-0000-0000-000002B4DCB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:55:29PM -0400, Pranith Kumar wrote:
> This might sound really naive, but please bear with me.
> 
> force_quiescent_state() used to do a lot of things in the past in addition to
> forcing a quiescent state. (In my reading of the mailing list I found state
> transitions for one). 
> 
> Now according to the code, what is being done is multiple callers try to go up
> the hierarchy of nodes to see who reaches the root node. The caller reaching the
> root node wins and it acquires root node lock and it gets to set rsp->gp_flags!
> 
> At each level of the hierarchy we try to acquire fqslock. This is the only place
> which actually uses fqslock. 
> 
> I guess this was being done to avoid the contention on fqslock, but all we are
> doing here is setting one flag. This way of acquiring locks might reduce
> contention if every update is trying to do some independent work, but here all
> we are doing is setting the same flag with same value.

Actually, to reduce contention on rnp_root->lock.

The trick is that the "losers" at each level of ->fqslock acquisition go
away.  The "winner" ends up doing the real work of setting RCU_GP_FLAG_FQS.

> We can also remove fqslock completely if we do not need this. Also using
> cmpxchg() to set the value of the flag looks like a good idea to avoid taking
> the root node lock. Thoughts?

The ->fqslock funnel was needed to avoid lockups on large systems (many
hundreds or even thousands of CPUs).  Moving grace-period responsibilities
from softirq to the grace-period kthreads might have reduced contention
sufficienty to make the ->fqslock funnel unnecessary.  However, given
that I don't usually have access to such a large system, I will leave it,
at least for the time being.

But you might be interested in thinking through what else would need to
change in order to make cmpxchg() work.  ;-)

							Thanx, Paul

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree.c | 35 +++++++++++++----------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f1ba773..9a46f32 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2399,36 +2399,27 @@ static void force_qs_rnp(struct rcu_state *rsp,
>  static void force_quiescent_state(struct rcu_state *rsp)
>  {
>  	unsigned long flags;
> -	bool ret;
> -	struct rcu_node *rnp;
> -	struct rcu_node *rnp_old = NULL;
> -
> -	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> -	for (; rnp != NULL; rnp = rnp->parent) {
> -		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
> -		      !raw_spin_trylock(&rnp->fqslock);
> -		if (rnp_old != NULL)
> -			raw_spin_unlock(&rnp_old->fqslock);
> -		if (ret) {
> -			ACCESS_ONCE(rsp->n_force_qs_lh)++;
> -			return;
> -		}
> -		rnp_old = rnp;
> +	struct rcu_node *rnp_root = rcu_get_root(rsp);
> +
> +	/* early test to see if someone already forced a quiescent state
> +	 */
> +	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
> +		ACCESS_ONCE(rsp->n_force_qs_lh)++;
> +		return;  /* Someone beat us to it. */
>  	}
> -	/* rnp_old == rcu_get_root(rsp), rnp == NULL. */
> 
>  	/* Reached the root of the rcu_node tree, acquire lock. */
> -	raw_spin_lock_irqsave(&rnp_old->lock, flags);
> +	raw_spin_lock_irqsave(&rnp_root->lock, flags);
>  	smp_mb__after_unlock_lock();
> -	raw_spin_unlock(&rnp_old->fqslock);
>  	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
>  		ACCESS_ONCE(rsp->n_force_qs_lh)++;
> -		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
> -		return;  /* Someone beat us to it. */
> +		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
> +		return;  /* Someone actually beat us to it. */
>  	}
> +
> +	/* can we use cmpxchg instead of the above lock? */
>  	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
> -	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
> +	raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
>  	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>  }
> 
> -- 
> 1.9.1
> 

