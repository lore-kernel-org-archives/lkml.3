Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaGWM0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:26:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40288 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGWM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:26:14 -0400
Date: Wed, 23 Jul 2014 05:26:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/16] rcu: Check for spurious wakeup using return value
Message-ID: <20140723122608.GL11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-12-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-12-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-6688-0000-0000-0000037FB96C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:48AM -0400, Pranith Kumar wrote:
> When the gp_kthread wakes up from the wait event, it returns 0 if the wake up is
> due to the condition having been met. This commit checks this return value
> for a spurious wake up before calling rcu_gp_init().
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

How does this added check help?  I don't see that it does.  If the flag
is set, we want to wake up.  If we get a spurious wakeup, but then the
flag gets set before we actually wake up, we still want to wake up.

So sorry, but no.

							Thanx, Paul

PS.  BTW, the ones that I am not immediately responding to are those
     that I will recheck later on and possibly accept.

> ---
>  kernel/rcu/tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f8847d9..3b20ad2 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1790,11 +1790,11 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  					       ACCESS_ONCE(rsp->gpnum),
>  					       TPS("reqwait"));
>  			rsp->gp_state = RCU_GP_WAIT_GPS;
> -			wait_event_interruptible(rsp->gp_wq,
> +			ret = wait_event_interruptible(rsp->gp_wq,
>  						 ACCESS_ONCE(rsp->gp_flags) &
>  						 RCU_GP_FLAG_INIT);
>  			/* Locking provides needed memory barrier. */
> -			if (rcu_gp_init(rsp))
> +			if (!ret && rcu_gp_init(rsp))
>  				break;
>  			cond_resched();
>  			flush_signals(current);
> -- 
> 2.0.0.rc2
> 

