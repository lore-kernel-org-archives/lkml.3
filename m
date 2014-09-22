Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaIVS6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:58:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:8227 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750914AbaIVS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:58:31 -0400
Date: Mon, 22 Sep 2014 14:58:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in
 lock_task_sighand()
Message-ID: <20140922145828.4d06108a@gandalf.local.home>
In-Reply-To: <20140922164437.GA28939@redhat.com>
References: <20140922164404.GA28910@redhat.com>
	<20140922164437.GA28939@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 18:44:37 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> __lock_task_sighand() does local_irq_save() to prevent the potential
> deadlock, we can use preempt_disable() with the same effect. And in
> this case we can do preempt_disable/enable + rcu_read_lock/unlock only
> once outside of the main loop and simplify the code. This also shaves
> 112 bytes from signal.o.
> 
> With this patch the main loop runs with preemption disabled, but this
> should be fine because restart is very unlikely: it can only happen if
> we race with de_thread() and ->sighand is shared. And the latter is only
> possible if CLONE_SIGHAND was used without CLONE_THREAD, most probably
> nobody does this nowadays.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/signal.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 8f0876f..61a1f55 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1261,30 +1261,25 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>  					   unsigned long *flags)
>  {
>  	struct sighand_struct *sighand;
> -
> +	/*
> +	 * We are going to do rcu_read_unlock() under spin_lock_irqsave().
> +	 * Make sure we can not be preempted after rcu_read_lock(), see
> +	 * rcu_read_unlock() comment header for details.
> +	 */
> +	preempt_disable();

The sad part is, this is going to break -rt. Or is this something we
can have preempt_disable_nort() with (for the -rt kernel that is). That
is, is -rt susceptible to this deadlock as well?

-- Steve


> +	rcu_read_lock();
>  	for (;;) {
> -		/*
> -		 * Disable interrupts early to avoid deadlocks.
> -		 * See rcu_read_unlock() comment header for details.
> -		 */
> -		local_irq_save(*flags);
> -		rcu_read_lock();
>  		sighand = rcu_dereference(tsk->sighand);
> -		if (unlikely(sighand == NULL)) {
> -			rcu_read_unlock();
> -			local_irq_restore(*flags);
> +		if (unlikely(sighand == NULL))
>  			break;
> -		}
>  
> -		spin_lock(&sighand->siglock);
> -		if (likely(sighand == tsk->sighand)) {
> -			rcu_read_unlock();
> +		spin_lock_irqsave(&sighand->siglock, *flags);
> +		if (likely(sighand == tsk->sighand))
>  			break;
> -		}
> -		spin_unlock(&sighand->siglock);
> -		rcu_read_unlock();
> -		local_irq_restore(*flags);
> +		spin_unlock_irqrestore(&sighand->siglock, *flags);
>  	}
> +	rcu_read_unlock();
> +	preempt_enable();
>  
>  	return sighand;
>  }

