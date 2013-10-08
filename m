Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3JHUee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:34:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42416 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHUec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:34:32 -0400
Date: Tue, 8 Oct 2013 22:34:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Thoughts on this RCU idle entry/exit patch?
Message-ID: <20131008203427.GE8392@localhost.localdomain>
References: <20131007153955.GA30925@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007153955.GA30925@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 08:39:55AM -0700, Paul E. McKenney wrote:
> Hello, Frederic!
> 
> The following patch seems to me to be a good idea to better handle
> task nesting.  Any reason why it would be a bad thing?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Allow task-level idle entry/exit nesting
> 
> The current task-level idle entry/exit code forces an entry/exit on
> each call, regardless of the nesting level.  This commit therefore
> properly accounts for nesting.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Looks good. In fact, the current code is even buggy because two nesting rcu_user_eqs()
as in:

        rcu_eqs_enter()
            rcu_eqs_enter()
            rcu_eqs_exit()
        rcu_eqs_exit()

would result in rdtp->dynticks wrong increment, right?

So that's even a bug fix. I wonder if it's a regression. That said rcu_eqs_enter_common()
should warn on such miscount, so may be these functions actually don't nest in practice
or you would have received such warnings.

So I wonder, do we want to continue to allow this nesting? I remember that DYNTICK_TASK_NEST_*
stuff is there to protects against non finishing interrupts on some archs (I also remember that
this, or at least a practical scenario for this, was hard to really define though :o)
But then wouldn't it involve other kind of scenario like this?

       rcu_irq_enter()
           rcu_eqs_enter()
           rcu_eqs_exit()
           ...

Anyway, that's just random thougths on further simplifications, in any case, this
patch looks good.

Thanks.

> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 106f7f5cdd1d..f0be20886617 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -411,11 +411,12 @@ static void rcu_eqs_enter(bool user)
>  	rdtp = this_cpu_ptr(&rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
> -	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
> +	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
>  		rdtp->dynticks_nesting = 0;
> -	else
> +		rcu_eqs_enter_common(rdtp, oldval, user);
> +	} else {
>  		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
> -	rcu_eqs_enter_common(rdtp, oldval, user);
> +	}
>  }
>  
>  /**
> @@ -533,11 +534,12 @@ static void rcu_eqs_exit(bool user)
>  	rdtp = this_cpu_ptr(&rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	WARN_ON_ONCE(oldval < 0);
> -	if (oldval & DYNTICK_TASK_NEST_MASK)
> +	if (oldval & DYNTICK_TASK_NEST_MASK) {
>  		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
> -	else
> +	} else {
>  		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> -	rcu_eqs_exit_common(rdtp, oldval, user);
> +		rcu_eqs_exit_common(rdtp, oldval, user);
> +	}
>  }
>  
>  /**
> 
