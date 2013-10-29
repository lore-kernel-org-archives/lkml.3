Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3J2TZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab3J2TZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:25:39 -0400
Date: Tue, 29 Oct 2013 20:25:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel: use lockless list for
 smp_call_function_single
Message-ID: <20131029192536.GB9568@quack.suse.cz>
References: <20131024151921.537751910@bombadil.infradead.org>
 <20131024152314.204817634@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024152314.204817634@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-10-13 08:19:27, Christoph Hellwig wrote:
> Make smp_call_function_single and friends more efficient by using
> a lockless list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h |    5 +----
>  include/linux/smp.h    |    6 +++++-
>  kernel/smp.c           |   51 ++++++++++++------------------------------------
>  3 files changed, 19 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f26ec20f..287bf7c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -95,10 +95,7 @@ enum rq_cmd_type_bits {
>   * as well!
>   */
>  struct request {
> -	union {
> -		struct list_head queuelist;
> -		struct llist_node ll_list;
> -	};
> +	struct list_head queuelist;
>  	union {
>  		struct call_single_data csd;
>  		struct work_struct mq_flush_data;
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 7885151..10755dd 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -11,12 +11,16 @@
>  #include <linux/list.h>
>  #include <linux/cpumask.h>
>  #include <linux/init.h>
> +#include <linux/llist.h>
>  
>  extern void cpu_idle(void);
>  
>  typedef void (*smp_call_func_t)(void *info);
>  struct call_single_data {
> -	struct list_head list;
> +	union {
> +		struct list_head list;
> +		struct llist_node llist;
> +	};
  I'm wondering: Who's still using the normal list_head? I was grepping for
a while and I couldn't find any user. Otherwise the patch looks good to me.
You can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

>  	smp_call_func_t func;
>  	void *info;
>  	u16 flags;
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 53644e6..a735c66 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -28,12 +28,7 @@ struct call_function_data {
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
>  
> -struct call_single_queue {
> -	struct list_head	list;
> -	raw_spinlock_t		lock;
> -};
> -
> -static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
> +static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
>  
>  static int
>  hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
> @@ -85,12 +80,8 @@ void __init call_function_init(void)
>  	void *cpu = (void *)(long)smp_processor_id();
>  	int i;
>  
> -	for_each_possible_cpu(i) {
> -		struct call_single_queue *q = &per_cpu(call_single_queue, i);
> -
> -		raw_spin_lock_init(&q->lock);
> -		INIT_LIST_HEAD(&q->list);
> -	}
> +	for_each_possible_cpu(i)
> +		init_llist_head(&per_cpu(call_single_queue, i));
>  
>  	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
>  	register_cpu_notifier(&hotplug_cfd_notifier);
> @@ -141,18 +132,9 @@ static void csd_unlock(struct call_single_data *csd)
>   */
>  static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
>  {
> -	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
> -	unsigned long flags;
> -	int ipi;
> -
>  	if (wait)
>  		csd->flags |= CSD_FLAG_WAIT;
>  
> -	raw_spin_lock_irqsave(&dst->lock, flags);
> -	ipi = list_empty(&dst->list);
> -	list_add_tail(&csd->list, &dst->list);
> -	raw_spin_unlock_irqrestore(&dst->lock, flags);
> -
>  	/*
>  	 * The list addition should be visible before sending the IPI
>  	 * handler locks the list to pull the entry off it because of
> @@ -164,7 +146,7 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
>  	 * locking and barrier primitives. Generic code isn't really
>  	 * equipped to do the right thing...
>  	 */
> -	if (ipi)
> +	if (llist_add(&csd->llist, &per_cpu(call_single_queue, cpu)))
>  		arch_send_call_function_single_ipi(cpu);
>  
>  	if (wait)
> @@ -177,27 +159,26 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
>   */
>  void generic_smp_call_function_single_interrupt(void)
>  {
> -	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
> -	LIST_HEAD(list);
> +	struct llist_node *entry, *next;
>  
>  	/*
>  	 * Shouldn't receive this interrupt on a cpu that is not yet online.
>  	 */
>  	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
>  
> -	raw_spin_lock(&q->lock);
> -	list_replace_init(&q->list, &list);
> -	raw_spin_unlock(&q->lock);
> +	entry = llist_del_all(&__get_cpu_var(call_single_queue));
> +	entry = llist_reverse_order(entry);
>  
> -	while (!list_empty(&list)) {
> +	while (entry) {
>  		struct call_single_data *csd;
>  
> -		csd = list_entry(list.next, struct call_single_data, list);
> -		list_del(&csd->list);
> +		next = entry->next;
>  
> +		csd = llist_entry(entry, struct call_single_data, llist);
>  		csd->func(csd->info);
> -
>  		csd_unlock(csd);
> +
> +		entry = next;
>  	}
>  }
>  
> @@ -410,17 +391,11 @@ void smp_call_function_many(const struct cpumask *mask,
>  
>  	for_each_cpu(cpu, cfd->cpumask) {
>  		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
> -		struct call_single_queue *dst =
> -					&per_cpu(call_single_queue, cpu);
> -		unsigned long flags;
>  
>  		csd_lock(csd);
>  		csd->func = func;
>  		csd->info = info;
> -
> -		raw_spin_lock_irqsave(&dst->lock, flags);
> -		list_add_tail(&csd->list, &dst->list);
> -		raw_spin_unlock_irqrestore(&dst->lock, flags);
> +		llist_add(&csd->llist, &per_cpu(call_single_queue, cpu));
>  	}
>  
>  	/* Send a message to all CPUs in the map */
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
