Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaGWMN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:13:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39722 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaGWMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:13:55 -0400
Date: Wed, 23 Jul 2014 05:13:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/16] rcu: Clear gp_flags only when actually starting
 new gp
Message-ID: <20140723121349.GH11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-7-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-7-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-3532-0000-0000-00000358DE07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:43AM -0400, Pranith Kumar wrote:
> We are clearing the gp_flags before we check if a grace period is in progress.
> If a grace period is in progress, we return after incorrectly clearing the
> gp_flags. The code comments say that this is highly unlikely, but just to be
> safe this commit moves the clearing of gp_flags to after the check for grace
> period in progress.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Sorry, but no.  The WARN_ON_ONCE() indicates an error condition.  It should
not be possible to have a grace period already in progress at this point
in the code.  So the two locations for the clearing of ->gp_flags are
equivalent.

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 044946e..b14cecd 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1605,7 +1605,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  		raw_spin_unlock_irq(&rnp->lock);
>  		return 0;
>  	}
> -	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
> 
>  	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
>  		/*
> @@ -1616,6 +1615,8 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  		return 0;
>  	}
> 
> +	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
> +
>  	/* Advance to a new grace period and initialize state. */
>  	record_gp_stall_check_time(rsp);
>  	/* Record GP times before starting GP, hence smp_store_release(). */
> -- 
> 2.0.0.rc2
> 

