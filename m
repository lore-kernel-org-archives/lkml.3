Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbaGUSPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:15:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44744 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbaGUSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:15:33 -0400
Date: Mon, 21 Jul 2014 11:15:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 04/10] nohz: Appropriate timekeeper kick on sysidle break
Message-ID: <20140721181527.GI8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072118-0928-0000-0000-000003870EC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:15AM +0200, Frederic Weisbecker wrote:
> When a CPU wakes up from idle and finds out that the timekeeper is
> sleeping, we need to kick it such that it switches from dynticks to
> periodic mode to maintain its timekeeping duty on behalf of the newly
> awoken CPU.
> 
> However we aren't using the right API for that. rcu_kick_nohz_cpu() is
> aimed at waking full dynticks CPUs and not the timekeeper.
> 
> Moreover the timekeeper must perform a new dynticks cycle to check the
> new sysidle state and restart the tick if necessary. A simple call
> to irq_exit() isn't enough.
> 
> wake_up_nohz_cpu() is a good fit for that job because it pulls the
> target out of the idle loop and restart the tick. Then if no other
> task waits for the CPU, it will reenter the idle loop and then the
> new sysidle state will be visible and well handled.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Either name is fine by me...  ;-)

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 395c14d..b65da1a 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2494,7 +2494,7 @@ void rcu_sysidle_force_exit(void)
>  				      oldstate, RCU_SYSIDLE_NOT);
>  		if (oldstate == newoldstate &&
>  		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> -			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> +			wake_up_nohz_cpu(tick_do_timer_cpu);
>  			return; /* We cleared it, done! */
>  		}
>  		oldstate = newoldstate;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

