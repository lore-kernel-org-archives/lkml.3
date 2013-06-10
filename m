Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3FJXUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:20:36 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44244 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3FJXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:20:33 -0400
Date: Mon, 10 Jun 2013 16:20:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130610232030.GA6151@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-18-git-send-email-koverstreet@google.com>
 <20130514134859.GA17587@redhat.com>
 <20130515092543.GE16164@moria.home.lan>
 <20130515154121.GA21932@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515154121.GA21932@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 05:41:21PM +0200, Oleg Nesterov wrote:
> On 05/15, Kent Overstreet wrote:
> >
> > On Tue, May 14, 2013 at 03:48:59PM +0200, Oleg Nesterov wrote:
> > > tag_free() does
> > >
> > > 	list_del_init(wait->list);
> > > 	/* WINDOW */
> > > 	wake_up_process(wait->task);
> > > 	
> > > in theory the caller of tag_alloc() can notice list_empty_careful(),
> > > return without taking pool->lock, exit, and free this task_struct.
> > >
> > > But the main problem is that it is not clear why this code reimplements
> > > add_wait_queue/wake_up_all, for what?
> >
> > To save on locking... there's really no point in another lock for the
> > wait queue. Could just use the wait queue lock instead I suppose, like
> > wait_event_interruptible_locked()
> 
> Yes. Or perhaps you can reuse wait_queue_head_t->lock for move_tags().
> 
> And,
> 
> > (the extra spin_lock()/unlock() might not really cost anything but
> > nested irqsave()/restore() is ridiculously expensive, IME).
> 
> But this is the slow path anyway. Even if you do not use _locked, how
> much this extra locking (save/restore) can make the things worse?
> 
> In any case, I believe it would be much better to reuse the code we
> already have, to avoid the races and make the code more understandable.
> And to not bloat the code.
> 
> Do you really think that, say,
> 
> 	unsigned tag_alloc(struct tag_pool *pool, bool wait)
> 	{
> 		struct tag_cpu_freelist *tags;
> 		unsigned ret = 0;
> 	retry:
> 		tags = get_cpu_ptr(pool->tag_cpu);
> 		local_irq_disable();
> 		if (!tags->nr_free && pool->nr_free) {
> 			spin_lock(&pool->wq.lock);
> 			if (pool->nr_free)
> 				move_tags(...);
> 			spin_unlock(&pool->wq.lock);
> 		}
> 
> 		if (tags->nr_free)
> 			ret = tags->free[--tags->nr_free];
> 		local_irq_enable();
> 		put_cpu_var(pool->tag_cpu);
> 
> 		if (ret || !wait)
> 			return ret;
> 
> 		__wait_event(&pool->wq, pool->nr_free);
> 		goto retry;
> 	}
> 
> will be much slower?

The overhead from doing nested irqsave/restore() sucks. I've had it bite
me hard with the recent aio work. But screw it, it's not going to matter
that much here.

> 
> > > I must admit, I do not understand what this code actually does ;)
> > > I didn't try to read it carefully though, but perhaps at least the
> > > changelog could explain more?
> >
> > The changelog is admittedly terse, but that's basically all there is to
> > it -
> > [...snip...]
> 
> Yes, thanks for your explanation, I already realized what it does...
> 
> Question. tag_free() does move_tags+wakeup if nr_free = pool->watermark * 2.
> Perhaps it should should also take waitqueue_active() into account ?
> tag_alloc() can sleep more than necessary, it seems.

No.

By "sleeping more than necessary" you mean sleeping when there's tags
available on other percpu freelists.

That's just unavoidable if the thing's to be percpu - efficient use of
available tags requires global knowledge. Sleeping less would require
more global cacheline contention, and would defeat the purpose of this
code.

So what we do is _bound_ that inefficiency - we cap the size of the
percpu freelists so that no more than half of the available tags can be
stuck on all the percpu freelists.

This means from the POV of work executing on one cpu, they will always
be able to use up to half the total tags (assuming they aren't
actually allocated).

So when you're deciding how many tag structs to allocate, you just
double the number you'd allocate otherwise when you're using this code.
