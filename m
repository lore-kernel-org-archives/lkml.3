Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3HUStP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:49:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3HUStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:49:14 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=fnHqrKAB9ZkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=eifdOL8937gA:10 a=SgEL8TLxAAAA:8 a=qpEwVkA7H1VTCZIQyN0A:9 a=CjuIK1q_8ugA:10 a=CCVnAHeEpQsA:10 a=ltoAtzfyQ3MA:10 a=AxwtKzeeziMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 14:49:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed
 on any cpu
Message-ID: <20130821144912.1b96c962@gandalf.local.home>
In-Reply-To: <1377072512-7986-3-git-send-email-jack@suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
	<1377072512-7986-3-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 10:08:30 +0200
Jan Kara <jack@suse.cz> wrote:

  
>  struct irq_work {
>  	unsigned long flags;
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 55fcce6..446cd81 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -22,6 +22,9 @@
>  static DEFINE_PER_CPU(struct llist_head, irq_work_list);
>  static DEFINE_PER_CPU(int, irq_work_raised);
>  
> +/* List of irq-work any CPU can pick up */
> +static LLIST_HEAD(unbound_irq_work_list);
> +
>  /*
>   * Claim the entry so that no one else will poke at it.
>   */
> @@ -70,12 +73,16 @@ void irq_work_queue(struct irq_work *work)
>  	/* Queue the entry and raise the IPI if needed. */
>  	preempt_disable();
>  
> -	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> +	if (!(work->flags & __IRQ_WORK_UNBOUND))
> +		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> +	else
> +		llist_add(&work->llnode, &unbound_irq_work_list);


Just for better readability I would have:

	if (work->flags & __IRQ_WORK_UNBOUND)
		llist_add(&work->llnode, &unbound_irq_work_list);
	else
		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));

>  
>  	/*
>  	 * If the work is not "lazy" or the tick is stopped, raise the irq
>  	 * work interrupt (if supported by the arch), otherwise, just wait
> -	 * for the next tick.
> +	 * for the next tick. We do this even for unbound work to make sure
> +	 * *some* CPU will be doing the work.
>  	 */
>  	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
>  		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
> @@ -100,28 +107,11 @@ bool irq_work_needs_cpu(void)
>  	return true;
>  }
>  
> -static void __irq_work_run(void)
> +static void process_irq_work_list(struct llist_node *llnode)
>  {
>  	unsigned long flags;
>  	struct irq_work *work;
> -	struct llist_head *this_list;
> -	struct llist_node *llnode;
> -
> -
> -	/*
> -	 * Reset the "raised" state right before we check the list because
> -	 * an NMI may enqueue after we find the list empty from the runner.
> -	 */
> -	__this_cpu_write(irq_work_raised, 0);
> -	barrier();
>  
> -	this_list = &__get_cpu_var(irq_work_list);
> -	if (llist_empty(this_list))
> -		return;
> -
> -	BUG_ON(!irqs_disabled());
> -
> -	llnode = llist_del_all(this_list);
>  	while (llnode != NULL) {
>  		work = llist_entry(llnode, struct irq_work, llnode);
>  
> @@ -146,6 +136,27 @@ static void __irq_work_run(void)
>  	}
>  }
>  
> +static void __irq_work_run(void)
> +{
> +	struct llist_head *this_list;
> +
> +	/*
> +	 * Reset the "raised" state right before we check the list because
> +	 * an NMI may enqueue after we find the list empty from the runner.
> +	 */
> +	__this_cpu_write(irq_work_raised, 0);
> +	barrier();
> +
> +	this_list = &__get_cpu_var(irq_work_list);
> +	if (llist_empty(this_list) && llist_empty(&unbound_irq_work_list))
> +		return;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	process_irq_work_list(llist_del_all(this_list));
> +	process_irq_work_list(llist_del_all(&unbound_irq_work_list));

OK, I'm being a bit of an micro optimization freak here, but...

How about moving the list_empty() and BUG_ON into the
process_irq_work_list() call.

That is,

	if (list_empty(llnode))
		return;

	BUG_ON(!irqs_disabled());

That way we avoid the double xchg() that is done with the two calls to
llist_del_all().

-- Steve



> +}
> +
>  /*
>   * Run the irq_work entries on this cpu. Requires to be ran from hardirq
>   * context with local IRQs disabled.

