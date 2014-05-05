Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaEEQr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbaEEQr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:47:56 -0400
Date: Mon, 5 May 2014 18:47:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140505164719.GA31758@redhat.com>
References: <20140503161133.GA8838@redhat.com> <20140504180145.GC8754@linux.vnet.ibm.com> <20140504191757.GA11319@redhat.com> <20140504223804.GF8754@linux.vnet.ibm.com> <20140505132659.GA17996@redhat.com> <20140505152610.GK8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505152610.GK8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Paul E. McKenney wrote:
>
> Does the patch below cover it?

Yes, thanks.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> signal: Explain local_irq_save() call
> 
> The explicit local_irq_save() in __lock_task_sighand() is needed to avoid
> a potential deadlock condition, as noted in a841796f11c90d53 (signal:
> align __lock_task_sighand() irq disabling and RCU).  However, someone
> reading the code might be forgiven for concluding that this separate
> local_irq_save() was completely unnecessary.  This commit therefore adds
> a comment referencing the shiny new block comment on rcu_read_unlock().
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 6ea13c09ae56..513e8c252aa4 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1288,6 +1288,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>  	struct sighand_struct *sighand;
>  
>  	for (;;) {
> +		/*
> +		 * Disable interrupts early to avoid deadlocks.
> +		 * See rcu_read_unlock comment header for details.
> +		 */
>  		local_irq_save(*flags);
>  		rcu_read_lock();
>  		sighand = rcu_dereference(tsk->sighand);
> 

