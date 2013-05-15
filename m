Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3EOJ0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:26:22 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48457 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3EOJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:26:19 -0400
Date: Wed, 15 May 2013 02:25:43 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130515092543.GE16164@moria.home.lan>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-18-git-send-email-koverstreet@google.com>
 <20130514134859.GA17587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514134859.GA17587@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 03:48:59PM +0200, Oleg Nesterov wrote:
> On 05/13, Kent Overstreet wrote:
> >
> > +unsigned tag_alloc(struct tag_pool *pool, bool wait)
> > +{
> > +	struct tag_cpu_freelist *tags;
> > +	unsigned long flags;
> > +	unsigned ret;
> > +retry:
> > +	preempt_disable();
> > +	local_irq_save(flags);
> > +	tags = this_cpu_ptr(pool->tag_cpu);
> > +
> > +	while (!tags->nr_free) {
> > +		spin_lock(&pool->lock);
> > +
> > +		if (pool->nr_free)
> > +			move_tags(tags->free, &tags->nr_free,
> > +				  pool->free, &pool->nr_free,
> > +				  min(pool->nr_free, pool->watermark));
> > +		else if (wait) {
> > +			struct tag_waiter wait = { .task = current };
> > +
> > +			__set_current_state(TASK_UNINTERRUPTIBLE);
> > +			list_add(&wait.list, &pool->wait);
> > +
> > +			spin_unlock(&pool->lock);
> > +			local_irq_restore(flags);
> > +			preempt_enable();
> > +
> > +			schedule();
> > +			__set_current_state(TASK_RUNNING);
> 
> schedule() always returns in TASK_RUNNING state
> 
> > +
> > +			if (!list_empty_careful(&wait.list)) {
> > +				spin_lock_irqsave(&pool->lock, flags);
> > +				list_del_init(&wait.list);
> > +				spin_unlock_irqrestore(&pool->lock, flags);
> 
> This is only theoretical, but racy.
> 
> tag_free() does
> 
> 	list_del_init(wait->list);
> 	/* WINDOW */
> 	wake_up_process(wait->task);
> 	
> in theory the caller of tag_alloc() can notice list_empty_careful(),
> return without taking pool->lock, exit, and free this task_struct.
> 
> But the main problem is that it is not clear why this code reimplements
> add_wait_queue/wake_up_all, for what?

To save on locking... there's really no point in another lock for the
wait queue. Could just use the wait queue lock instead I suppose, like
wait_event_interruptible_locked()

(the extra spin_lock()/unlock() might not really cost anything but
nested irqsave()/restore() is ridiculously expensive, IME).

> I must admit, I do not understand what this code actually does ;)
> I didn't try to read it carefully though, but perhaps at least the
> changelog could explain more?

The changelog is admittedly terse, but that's basically all there is to
it -

Say you've got a device where you can have multiple outstanding
commands - you'll identify commands/responses by some integer (the
"tag"). Typically you won't get a full 64 bits for the tag, it might be
10 or 16 or 32 bits or whatever - and even if you could use raw pointers
you wouldn't really want to because then if the device gives you garbage
response you're derefing an untrusted pointer - you want to allocate tag
structures out of a fixed array so you can validate responses.

So you preallocate all your tag structures up front - now you can refer
to them by small fixed integers. But if you want to be able to
efficiently allocate from the same pool of tags across multiple CPUs -
well, that's what this code is for.
