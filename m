Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3ENNwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab3ENNwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:52:23 -0400
Date: Tue, 14 May 2013 15:48:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130514134859.GA17587@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-18-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368494338-7069-18-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Kent Overstreet wrote:
>
> +unsigned tag_alloc(struct tag_pool *pool, bool wait)
> +{
> +	struct tag_cpu_freelist *tags;
> +	unsigned long flags;
> +	unsigned ret;
> +retry:
> +	preempt_disable();
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	while (!tags->nr_free) {
> +		spin_lock(&pool->lock);
> +
> +		if (pool->nr_free)
> +			move_tags(tags->free, &tags->nr_free,
> +				  pool->free, &pool->nr_free,
> +				  min(pool->nr_free, pool->watermark));
> +		else if (wait) {
> +			struct tag_waiter wait = { .task = current };
> +
> +			__set_current_state(TASK_UNINTERRUPTIBLE);
> +			list_add(&wait.list, &pool->wait);
> +
> +			spin_unlock(&pool->lock);
> +			local_irq_restore(flags);
> +			preempt_enable();
> +
> +			schedule();
> +			__set_current_state(TASK_RUNNING);

schedule() always returns in TASK_RUNNING state

> +
> +			if (!list_empty_careful(&wait.list)) {
> +				spin_lock_irqsave(&pool->lock, flags);
> +				list_del_init(&wait.list);
> +				spin_unlock_irqrestore(&pool->lock, flags);

This is only theoretical, but racy.

tag_free() does

	list_del_init(wait->list);
	/* WINDOW */
	wake_up_process(wait->task);
	
in theory the caller of tag_alloc() can notice list_empty_careful(),
return without taking pool->lock, exit, and free this task_struct.

But the main problem is that it is not clear why this code reimplements
add_wait_queue/wake_up_all, for what?

I must admit, I do not understand what this code actually does ;)
I didn't try to read it carefully though, but perhaps at least the
changelog could explain more?

Oleg.

