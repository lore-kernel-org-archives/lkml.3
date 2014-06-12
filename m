Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaFLXQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:16:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42902 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFLXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:16:14 -0400
Date: Thu, 12 Jun 2014 16:16:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 1/5] kernel/rcu/tree.c:1272 fix a sparse warning
Message-ID: <20140612231609.GG4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-2-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402519183-12752-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061223-1542-0000-0000-000002885DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:39:39PM -0400, Pranith Kumar wrote:
> kernel/rcu/tree.c:1272:9: warning: context imbalance in 'rcu_start_future_gp' - different lock contexts for basic block
> 
> We can simplify the function by keeping the contexts together and removing
> redundant checks.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree.c | 65 ++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f1ba773..9ab84d3 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1234,49 +1234,54 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
>  	}
> 
>  	/*
> -	 * There might be no grace period in progress.  If we don't already
> +	 * There is be no grace period in progress.  If we don't already

We actually don't know at this point, unless rnp==rnp_root.  Otherwise,
the grace period might have started, but initialization might not yet
have reached rnp.

>  	 * hold it, acquire the root rcu_node structure's lock in order to
> -	 * start one (if needed).
> +	 * start one.
>  	 */
>  	if (rnp != rnp_root) {
>  		raw_spin_lock(&rnp_root->lock);
>  		smp_mb__after_unlock_lock();

I am not convinced that this transformation is correct, especially in
the rnp==rnp_root case.  For one thing, I don't see the need for a
future grace period being recorded in that case.

And I believe that if this transformation is fixed, there will be some
duplicate code, which scares me more than sparse false positives.  So I
am not willing to take this sort of transformation.  Or am I missing
something?

> +		/*
> +		 * Get a new grace-period number.  If there really is no grace
> +		 * period in progress, it will be smaller than the one we obtained
> +		 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
> +		 */
> +		c = rcu_cbs_completed(rdp->rsp, rnp_root);

But I believe that this statement could be moved into the preceding "if"
statement in the original code.  If this is really the case, it could
be a good change.

							Thanx, Paul

> +
> +		/*
> +		 * If the needed request for the required grace period is already
> +		 * recorded, trace and leave.
> +		 */
> +		if (rnp_root->need_future_gp[c & 0x1]) {
> +			trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
> +			raw_spin_unlock(&rnp_root->lock);
> +			goto out;
> +		}
> +
> +		/* Record the need for the future grace period. */
> +		rnp_root->need_future_gp[c & 0x1]++;
> +
> +		/*
> +		 * Start a new grace period since it is not started
> +		 */
> +		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
> +		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
> +		raw_spin_unlock(&rnp_root->lock);
> +		goto out;
>  	}
> 
> +	/* rnp == rnp_root, we already hold the lock */
> +	trace_rcu_future_gp(rnp, rdp, c, TPS("StartedLeaf"));
> +	ret = rcu_start_gp_advanced(rdp->rsp, rnp, rdp);
> +out:
>  	/*
> -	 * Get a new grace-period number.  If there really is no grace
> -	 * period in progress, it will be smaller than the one we obtained
> -	 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
> -	 * CPUs have a ->nxtcompleted[] array, so no no-CBs checks needed.
> +	 * Adjust callbacks as needed.  Note that even no-CBs CPUs
> +	 * have a ->nxtcompleted[] array, so no no-CBs checks needed.
>  	 */
> -	c = rcu_cbs_completed(rdp->rsp, rnp_root);
>  	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
>  		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
>  			rdp->nxtcompleted[i] = c;
> 
> -	/*
> -	 * If the needed for the required grace period is already
> -	 * recorded, trace and leave.
> -	 */
> -	if (rnp_root->need_future_gp[c & 0x1]) {
> -		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
> -		goto unlock_out;
> -	}
> -
> -	/* Record the need for the future grace period. */
> -	rnp_root->need_future_gp[c & 0x1]++;
> -
> -	/* If a grace period is not already in progress, start one. */
> -	if (rnp_root->gpnum != rnp_root->completed) {
> -		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleafroot"));
> -	} else {
> -		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
> -		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
> -	}
> -unlock_out:
> -	if (rnp != rnp_root)
> -		raw_spin_unlock(&rnp_root->lock);
> -out:
>  	if (c_out != NULL)
>  		*c_out = c;
>  	return ret;
> -- 
> 1.9.1
> 

