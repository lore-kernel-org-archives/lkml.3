Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaCLC7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:59:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCLC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:58:58 -0400
Date: Tue, 11 Mar 2014 20:03:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "majianpeng" <majianpeng@gmail.com>
Subject: Re: [PATCH] poll/wait/md: allow module to safely support 'poll' on
 /proc files
Message-Id: <20140311200331.2a841ea9.akpm@linux-foundation.org>
In-Reply-To: <20140312133638.1fd84632@notabene.brown>
References: <20140312133638.1fd84632@notabene.brown>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 13:36:38 +1100 NeilBrown <neilb@suse.de> wrote:

> 
> The md driver currently supports 'poll' on /proc/mdstat.
> This is unsafe as if the md-mod module is removed while a 'poll'
> or 'select' is outstanding on /proc/mdstat, an oops occurs
> when the syscall completes.
> poll_freewait() will call remove_wait_queue() on a wait_queue_head_t
> which was local to the module which no-longer exists.
> 
> This problem is particular to /proc.  Most filesystems do not
> allow the module to be unloaded while any files are open on it.
> /proc only blocks module unloading while a file_operations
> call is currently active into the module, not while the file is open.
> kernfs has this property too but kernfs allocates a wait_queue_head_t
> in its internal data structures so the module doesn't need to provide
> one.
> (A previous patch to add a similar allocation to procfs was not
> accepted).

By who, me?  I was hoping we could somehow keep the implementation
contained within md.  I don't think I actually looked at it to any
significant extent!

Was hoping that viro would pipe up.

> This patch takes a different approach and allows a module to
> disconnect the wait_queue_head_t that was passed to poll_wait()
> from all the clients which are waiting on it.  Thus after calling
>  proc_remove_entry("mdstat", NULL);
> we simply call
>  wait_queue_purge(&md_event_waiters);
> 
> and then know that it is safe to remove the module.
> 
> rcu infrastructure is used to avoid races.
> poll_freewait() checks if the purge has happened under rcu_read_lock()
> to ensure that it never touches any freed memory.  wait_queue_purge()
> uses synchronize_rcu() to ensure no poll_freewait() could still be
> looking at the wait_queue_head_t.
> 
> ...
>
> +/**
> + * wait_queue_purge - remove all waiter from a wait_queue
> + * @q: The queue to be purged
> + *
> + * Unlink all pending waiters from the queue.
> + * This can be used prior to freeing a queue providing all waiters are
> + * prepared for queue purging.
> + * Waiters must call remove_wait_queue_puregeable() rather than
> + * remove_wait_queue().
> + *
> + */
> +void wait_queue_purge(wait_queue_head_t *q)
> +{
> +	spin_lock(&q->lock);
> +	while (!list_empty(&q->task_list))
> +		list_del_init(q->task_list.next);
> +	spin_unlock(&q->lock);
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL(wait_queue_purge);

I don't get this.  If a task is waiting on that wait_queue_head_t, how
does it get woken?

> +/**
> + * remove_wait_queue_puregeable - remove_wait_queue if wait_queue_purge might be used.
> + * @q: the queue, which may already be purged, to remove from
> + * @wait: the waiter to remove
> + *
> + * Remove a waiter from a queue if it hasn't already been purged.
> + * If the queue has already been purged then task_list will be empty.
> + * If it isn't then it is still safe to lock the queue and remove
> + * the task.
> + */
> +void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_t *wait)
> +{
> +	unsigned long flags;
> +
> +	rcu_read_lock();
> +	if (!list_empty(&wait->task_list)) {
> +		spin_lock_irqsave(&q->lock, flags);

Mixture of spin_lock_irqsave() here and spin_lock() in
wait_queue_purge() looks odd.

> +		list_del_init(&wait->task_list);
> +		spin_unlock_irqrestore(&q->lock, flags);
> +	}
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(remove_wait_queue_purgeable);

