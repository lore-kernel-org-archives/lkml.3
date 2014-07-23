Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaGWMXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:23:44 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55686 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaGWMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:23:43 -0400
Date: Wed, 23 Jul 2014 05:23:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] rcu: Check for RCU_FLAG_GP_INIT bit in gp_flags
 for spurious wakeup
Message-ID: <20140723122335.GK11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-11-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-11-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-8236-0000-0000-0000040DA779
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:47AM -0400, Pranith Kumar wrote:
> rcu_gp_init() is called once the gp_kthread wakes up on the condition that
> the init bit is set in the gp_flags. For a spurious wakeup we need to check that
> it is actually set. This commit ensures that the RCU_GP_FLAG_INIT bit is set in
> gp_flags.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

The trick here is that the other bits have no meaning if we are not yet
in a grace period.  If any get spuriously set, for example, by a race
between force_quiescent_state() and the end of a grace period, we really
do want to clear them all.

So sorry, but no.

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 8d598a2..f8847d9 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1600,7 +1600,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  	rcu_bind_gp_kthread();
>  	raw_spin_lock_irq(&rnp->lock);
>  	smp_mb__after_unlock_lock();
> -	if (!ACCESS_ONCE(rsp->gp_flags)) {
> +	if (!(ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_INIT)) {
>  		/* Spurious wakeup, tell caller to go back to sleep.  */
>  		raw_spin_unlock_irq(&rnp->lock);
>  		return 0;
> -- 
> 2.0.0.rc2
> 

