Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaGIAHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:07:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54342 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaGIAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:07:06 -0400
Date: Tue, 8 Jul 2014 17:07:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
Message-ID: <20140709000701.GJ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070900-0928-0000-0000-00000340AA5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:55:45PM -0400, Pranith Kumar wrote:
> atomic_add_return() invalidates the cache line in other processors where-as
> atomic_read does not. I don't see why we would need invalidation in this case.
> If indeed it was need a comment would be helpful for readers. Otherwise doesn't
> using atomic_read() make more sense here? RFC!
> 
> replace atomic_add_return(0, v) with atomic_read(v) as the latter is better.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

This will break RCU -- the full memory barriers implied both before
and after atomic_add_return() are needed in order for RCU to be able to
avoid death due to memory reordering.

That said, I have considered replacing the atomic_add_return() with:

	smp_mb();
	... = atomic_read(...);
	smp_mb();

However, this is a very ticklish change, and would need serious thought
and even more serious testing.

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index dac6d20..a4a8f5f 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -891,7 +891,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
>  static int dyntick_save_progress_counter(struct rcu_data *rdp,
>  					 bool *isidle, unsigned long *maxj)
>  {
> -	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
> +	rdp->dynticks_snap = atomic_read(&rdp->dynticks->dynticks);
>  	rcu_sysidle_check_cpu(rdp, isidle, maxj);
>  	if ((rdp->dynticks_snap & 0x1) == 0) {
>  		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
> @@ -920,7 +920,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
>  	int *rcrmp;
>  	unsigned int snap;
> 
> -	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
> +	curr = (unsigned int)atomic_read(&rdp->dynticks->dynticks);
>  	snap = (unsigned int)rdp->dynticks_snap;
> 
>  	/*
> -- 
> 1.9.1
> 

