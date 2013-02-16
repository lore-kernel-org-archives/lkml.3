Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3BQTlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:41:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38437 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3BQTlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:41:22 -0500
Date: Sat, 16 Feb 2013 12:59:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/16] rcu: rcutiny: Prevent RCU stall
Message-ID: <20130216205909.GB3094@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
 <1360771932-27150-5-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360771932-27150-5-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021719-9360-0000-0000-000010B44BEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 05:11:59PM +0100, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> rcu_read_unlock_special() checks in_serving_softirq() and leaves early
> when true. On RT this is obviously wrong as softirq processing context
> can be preempted and therefor such a task can be on the gp_tasks
> list. Leaving early here will leave the task on the list and therefor
> block RCU processing forever.
> 
> This cannot happen on mainline because softirq processing context
> cannot be preempted and therefor this can never happen at all.
> 
> In fact this check looks quite questionable in general. Neither irq
> context nor softirq processing context in mainline can ever be
> preempted in mainline so the special unlock case should not ever be
> invoked in such context. Now the only explanation might be a
> rcu_read_unlock() being interrupted and therefor leave the rcu nest
> count at 0 before the special unlock bit has been cleared. That looks
> fragile. At least it's missing a big fat comment. Paul ????
> 
> See mainline commits: ec433f0c5 and 8762705a for further enlightment.
> 
> Reported-by: Kristian Lehmann <krleit00@hs-esslingen.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [bigeasy@linutronix: different in-irq check]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/rcutiny_plugin.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 2b0484a..bac1906 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -552,7 +552,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  		rcu_preempt_cpu_qs();
> 
>  	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq()) {
> +	if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {

For whatever it is worth, in mainline this is:

	if (in_irq() || in_serving_softirq()) {

The definition of in_serving_softirq() is a bit different:

#define in_serving_softirq()    (softirq_count() & SOFTIRQ_OFFSET)

This might be due to differences between mainline and -rt, but thought
it worth calling attention to.

							Thanx, Paul

>  		local_irq_restore(flags);
>  		return;
>  	}
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

