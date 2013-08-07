Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3HGQmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:42:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50749 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3HGQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:42:22 -0400
Date: Wed, 7 Aug 2013 09:42:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 7/8] rcu: add # of deferred _special() statistics
Message-ID: <20130807164200.GD4306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375871104-10688-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080716-7282-0000-0000-00001A27B07E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:25:03PM +0800, Lai Jiangshan wrote:
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/rcutree.h        |    1 +
>  kernel/rcutree_plugin.h |    1 +
>  kernel/rcutree_trace.c  |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4a39d36..a5e9643 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -290,6 +290,7 @@ struct rcu_data {
>  	unsigned long	n_force_qs_snap;
>  					/* did other CPU force QS recently? */
>  	long		blimit;		/* Upper limit on a processed batch */
> +	unsigned long	n_defer_special;/* # of deferred _special() */
> 
>  	/* 3) dynticks interface. */
>  	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index c9ff9f1..d828eec 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -396,6 +396,7 @@ void rcu_read_unlock_special(struct task_struct *t, bool unlock)
>  		 * is still unlikey to be true.
>  		 */
>  		if (unlikely(unlock && irqs_disabled_flags(flags))) {
> +			this_cpu_ptr(&rcu_preempt_data)->n_defer_special++;
>  			set_need_resched();
>  			local_irq_restore(flags);
>  			return;
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index cf6c174..17d8b2c 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -149,6 +149,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
>  	seq_printf(m, " ci=%lu nci=%lu co=%lu ca=%lu\n",

The above "\n" needs to be removed.  (Fixed while queueing.)

							Thanx, Paul

>  		   rdp->n_cbs_invoked, rdp->n_nocbs_invoked,
>  		   rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
> +	seq_printf(m, " ds=%lu\n", rdp->n_defer_special);
>  }
> 
>  static int show_rcudata(struct seq_file *m, void *v)
> -- 
> 1.7.4.4
> 

