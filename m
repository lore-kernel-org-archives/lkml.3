Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3KGWNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:13:47 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:54961 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3KGWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <1383860919-1883-3-git-send-email-jack@suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-3-git-send-email-jack@suse.cz>
Date: Thu, 7 Nov 2013 23:13:39 +0100
Message-ID: <CAFTL4hxLXb3hZacx_EdHeKZVfrpuyGoNqpGbX997XJx0UJSwyg@mail.gmail.com>
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed on
 any cpu
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/7 Jan Kara <jack@suse.cz>:
> Provide new irq work flag - IRQ_WORK_UNBOUND - meaning that can be
> processed on any cpu. This flag implies IRQ_WORK_LAZY so that things are
> simple and we don't have to pick any particular cpu to do the work. We
> just do the work from a timer tick on whichever cpu it happens first.
> This is useful as a lightweight and simple code path without locking or
> other dependencies to offload work to other cpu if possible.
>
> We will use this type of irq work to make a guarantee of forward
> progress of printing to a (serial) console when printing on one cpu
> would cause interrupts to be disabled for too long.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/irq_work.h |  2 ++
>  kernel/irq_work.c        | 41 +++++++++++++++++++++++++----------------
>  2 files changed, 27 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index 66017028dcb3..ca07a16355ed 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -16,6 +16,8 @@
>  #define IRQ_WORK_BUSY          2UL
>  #define IRQ_WORK_FLAGS         3UL
>  #define IRQ_WORK_LAZY          4UL /* Doesn't want IPI, wait for tick */
> +#define __IRQ_WORK_UNBOUND      8UL /* Use IRQ_WORK_UNBOUND instead! */
> +#define IRQ_WORK_UNBOUND       (__IRQ_WORK_UNBOUND | IRQ_WORK_LAZY) /* Any cpu can process this work */
>
>  struct irq_work {
>         unsigned long flags;
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 55fcce6065cf..b06350b63c67 100644
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
>         /* Queue the entry and raise the IPI if needed. */
>         preempt_disable();
>
> -       llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> +       if (work->flags & __IRQ_WORK_UNBOUND)
> +               llist_add(&work->llnode, &unbound_irq_work_list);
> +       else
> +               llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>
>         /*
>          * If the work is not "lazy" or the tick is stopped, raise the irq
>          * work interrupt (if supported by the arch), otherwise, just wait
> -        * for the next tick.
> +        * for the next tick. We do this even for unbound work to make sure
> +        * *some* CPU will be doing the work.
>          */
>         if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
>                 if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
> @@ -100,28 +107,17 @@ bool irq_work_needs_cpu(void)
>         return true;
>  }
>
> -static void __irq_work_run(void)
> +static void process_irq_work_list(struct llist_head *llhead)
>  {
>         unsigned long flags;
>         struct irq_work *work;
> -       struct llist_head *this_list;
>         struct llist_node *llnode;
>
> -
> -       /*
> -        * Reset the "raised" state right before we check the list because
> -        * an NMI may enqueue after we find the list empty from the runner.
> -        */
> -       __this_cpu_write(irq_work_raised, 0);
> -       barrier();
> -
> -       this_list = &__get_cpu_var(irq_work_list);
> -       if (llist_empty(this_list))
> +       if (llist_empty(llhead))
>                 return;
>
>         BUG_ON(!irqs_disabled());
> -
> -       llnode = llist_del_all(this_list);
> +       llnode = llist_del_all(llhead);
>         while (llnode != NULL) {
>                 work = llist_entry(llnode, struct irq_work, llnode);
>
> @@ -146,6 +142,19 @@ static void __irq_work_run(void)
>         }
>  }
>
> +static void __irq_work_run(void)
> +{
> +       /*
> +        * Reset the "raised" state right before we check the list because
> +        * an NMI may enqueue after we find the list empty from the runner.
> +        */
> +       __this_cpu_write(irq_work_raised, 0);
> +       barrier();
> +
> +       process_irq_work_list(&__get_cpu_var(irq_work_list));
> +       process_irq_work_list(&unbound_irq_work_list);
> +}
> +

But then, who's going to process that work if every CPUs is idle?
