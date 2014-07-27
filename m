Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaG0Xtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:49:41 -0400
Received: from mail.efficios.com ([78.47.125.74]:32848 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaG0Xtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:49:39 -0400
Date: Sun, 27 Jul 2014 23:49:42 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Message-ID: <456359712.21364.1406504982621.JavaMail.zimbra@efficios.com>
In-Reply-To: <1406504249-15176-1-git-send-email-bobby.prani@gmail.com>
References: <1406504249-15176-1-git-send-email-bobby.prani@gmail.com>
Subject: Re: [PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up grace
 period kthreads
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.29.13]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: Use rcu_gp_kthread_wake() to wake up grace period kthreads
Thread-Index: k4P5WbL10+8Oyvf6+ozjlCNWQliSFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Pranith Kumar" <bobby.prani@gmail.com>
> To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "Josh Triplett" <josh@joshtriplett.org>, "Steven Rostedt"
> <rostedt@goodmis.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
> "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
> Sent: Sunday, July 27, 2014 7:37:29 PM
> Subject: [PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
> 
> The rcu_gp_kthread_wake() function checks for three conditions before waking
> up
> grace period kthreads:
> 
> *  Is the thread we are trying to wake up the current thread?
> *  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
> *  Is there no thread created for this flavour, hence nothing to wake up?
> 
> If any one of these condition is true, we do not call wake_up().
> 
> It was found that there are quite a few avoidable wake ups both during idle
> time and under stress induced by rcutorture.
> 
> Idle:
> 
> Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
> Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0
> 
> rcutorture:
> 
> Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
> Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0
> 
> Here case{1-3} are the cases listed above. We can avoid these wake ups by
> using
> rcu_gp_kthread_wake() to conditionally wake up the grace period kthreads.
> 
> Hence this commit tries to avoid calling wake_up() whenever we can by using
> rcu_gp_kthread_wake() function.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index b63517c..36911ee 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1938,7 +1938,10 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp,
> unsigned long flags)
>  {
>  	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
>  	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
> -	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> +	/* ->gp_flags is properly protected by locks, so a memory barrier
> +	 * is not necessary here

Two point:

1- The format of this comment is odd, and should be:

/*
 * Text...
 */

2- Since when can a memory barrier be replaced by a lock ? More explanation
   appears to be needed on what this barrier matches exactly.

Thanks,

Mathieu

> +	 */
> +	rcu_gp_kthread_wake(rsp);
>  }
>  
>  /*
> @@ -2516,7 +2519,10 @@ static void force_quiescent_state(struct rcu_state
> *rsp)
>  	ACCESS_ONCE(rsp->gp_flags) =
>  		ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
>  	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
> -	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> +	/* ->gp_flags is properly protected by locks, so a memory barrier
> +	 * is not necessary here
> +	 */
> +	rcu_gp_kthread_wake(rsp);
>  }
>  
>  /*
> --
> 1.9.1
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
