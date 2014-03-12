Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaCLEOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:14:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCLEOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:14:50 -0400
Date: Tue, 11 Mar 2014 21:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "majianpeng" <majianpeng@gmail.com>
Subject: Re: [PATCH] poll/wait/md: allow module to safely support 'poll' on
 /proc files
Message-Id: <20140311211924.a7f57352.akpm@linux-foundation.org>
In-Reply-To: <20140312141025.1a6c535f@notabene.brown>
References: <20140312133638.1fd84632@notabene.brown>
	<20140311200331.2a841ea9.akpm@linux-foundation.org>
	<20140312141025.1a6c535f@notabene.brown>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 14:10:25 +1100 NeilBrown <neilb@suse.de> wrote:

> On Tue, 11 Mar 2014 20:03:31 -0700 Andrew Morton <akpm@linux-foundation.org>
> wrote:
> 
> > On Wed, 12 Mar 2014 13:36:38 +1100 NeilBrown <neilb@suse.de> wrote:
> > 
> > > 
> > > The md driver currently supports 'poll' on /proc/mdstat.
> > > This is unsafe as if the md-mod module is removed while a 'poll'
> > > or 'select' is outstanding on /proc/mdstat, an oops occurs
> > > when the syscall completes.
> > > poll_freewait() will call remove_wait_queue() on a wait_queue_head_t
> > > which was local to the module which no-longer exists.
> > > 
> > > This problem is particular to /proc.  Most filesystems do not
> > > allow the module to be unloaded while any files are open on it.
> > > /proc only blocks module unloading while a file_operations
> > > call is currently active into the module, not while the file is open.
> > > kernfs has this property too but kernfs allocates a wait_queue_head_t
> > > in its internal data structures so the module doesn't need to provide
> > > one.
> > > (A previous patch to add a similar allocation to procfs was not
> > > accepted).
> > 
> > By who, me?  I was hoping we could somehow keep the implementation
> > contained within md.  I don't think I actually looked at it to any
> > significant extent!
> > 
> > Was hoping that viro would pipe up.
> 
> Was not accepted by anybody.  Everybody is guilty :-)
> You were at least nice enough to comment (thanks).
> 
> I think I like this version better so it might not be a problem that the
> previous version was not accepted.  Depends on what the scheduler guys think
> though....

OK..

> > > ...
> > >
> > > +/**
> > > + * wait_queue_purge - remove all waiter from a wait_queue
> > > + * @q: The queue to be purged
> > > + *
> > > + * Unlink all pending waiters from the queue.
> > > + * This can be used prior to freeing a queue providing all waiters are
> > > + * prepared for queue purging.
> > > + * Waiters must call remove_wait_queue_puregeable() rather than
> > > + * remove_wait_queue().
> > > + *
> > > + */
> > > +void wait_queue_purge(wait_queue_head_t *q)
> > > +{
> > > +	spin_lock(&q->lock);
> > > +	while (!list_empty(&q->task_list))
> > > +		list_del_init(q->task_list.next);
> > > +	spin_unlock(&q->lock);
> > > +	synchronize_rcu();
> > > +}
> > > +EXPORT_SYMBOL(wait_queue_purge);
> > 
> > I don't get this.  If a task is waiting on that wait_queue_head_t, how
> > does it get woken?
> 
> This is only expected to be used by tasks which have some other means of
> being woken up.  Possibly a timeout passed to 'select' or 'poll', possibly a
> signal.

Oh.  So the caller is supposed to take the tasks off the queue via
wait_queue_purge(), then to wake them up (which implies the caller has
a second way of looking the tasks up).

And the tasks themselves ...  do they need to know what happened?  If
they run remove_wait_queue() then will still take
wait_queue_head_t.lock, so the calling task need to somehow keep the
wait_queue_head_t alive until everyone has woken and cleared off.

Complex!  Could we please get that all fleshed out in the changelog and
kerneldoc?

> > 
> > > +/**
> > > + * remove_wait_queue_puregeable - remove_wait_queue if wait_queue_purge might be used.
> > > + * @q: the queue, which may already be purged, to remove from
> > > + * @wait: the waiter to remove
> > > + *
> > > + * Remove a waiter from a queue if it hasn't already been purged.
> > > + * If the queue has already been purged then task_list will be empty.
> > > + * If it isn't then it is still safe to lock the queue and remove
> > > + * the task.
> > > + */
> > > +void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_t *wait)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	rcu_read_lock();
> > > +	if (!list_empty(&wait->task_list)) {
> > > +		spin_lock_irqsave(&q->lock, flags);
> > 
> > Mixture of spin_lock_irqsave() here and spin_lock() in
> > wait_queue_purge() looks odd.
> 
> True - I was copying remove_wait_queue().  Maybe I should have just called
> remove_wait_queue() directly (we don't actually need that _init on the
> list_del).

lockdep should have complained about the spin_lock().
