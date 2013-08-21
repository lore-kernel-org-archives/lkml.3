Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3HUDgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:36:51 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39436 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3HUDgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:36:49 -0400
Date: Tue, 20 Aug 2013 20:36:58 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Message-ID: <20130821033658.GE4051@kmo-pixel>
References: <20130820111602.3cea203c@gandalf.local.home>
 <20130821021900.GB4051@kmo-pixel>
 <20130820224153.5667495b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820224153.5667495b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:41:53PM -0400, Steven Rostedt wrote:
> > I get that there's a problem, but the bcache code REALLY IS USING THE
> > RWSEM AS A LOCK; the answer isn't to open code the lock!
> 
> Actually, it is using it as a semaphore. The problem with Linux
> was that it only had spin locks and semaphores. People would use the
> semaphore as either a completion or a mutex. Luckily, we created both
> of those and replaced 90% of all semaphores with either a mutex or a
> completion.
> 
> The rwsem, sorta has the same issue. But it was pretty much always used
> as a read/write sleeping lock. It was not used as a semaphore. But it
> seems that the bcache really does use it as a semaphore here as it
> isn't just a mutex location. It's a special kind of completion, but the
> completion is in a strange way.

I think we're mostly quibbling over semantics here, and it's not that
big a deal - that said, I don't really get your distinction between a
semaphore and a mutex; I'd distinguish them by saying a semaphore can
count an arbitrary number of resources (the number it's initialized to),
and a mutex is always initialized to one - the fact that in the kernel
mutexes must be released by the same process that took them (while
important for PI and debugging) is not fundamental.

"rw semaphore" never made any sense to me; they're not counting
anything, like regular semaphores. They're just sleepable rw locks.

So it _sounds_ like you're saying bcache is using it as a semaphore,
beacuse it's using it as a lock we don't release in the original
context? in analogy to linux mutexes and semaphores? Not quite sure what
you mean.

> > Apologies to Christoph for getting distracted and not responding when
> > you started to explain what the issues were for RT. I'm not really
> > convinced they're that insurmountable (one of the issues was debugging,
> > which the _non_owner() stuff always handled just fine), but I'll take it
> > on faith that this usage is incompatible with rwsems + the RT
> > functionality since I haven't actually had time to dig into it.
> 
> The thing is, RT requires priority inheritance. When a task blocks on a
> rwsem, it has to boost the owner of that rwsem otherwise it risks
> unbounded priority inversion.
> 
> I have a hack that actually implements a work around for non_owner, but
> it adds overhead to all locks to do so.

Ok - I'd just be curious why the PI bit can't be factored out into a
wrapper like how the debug stuff is handled with the _non_owner bits,
but I can certainly believe that.

> > So assuming that's the case, IMO the sanest thing to do is make a new
> > type of lock - "rwsem_non_process" or somesuch - and use _that_ in
> > bcache. Not open coding the lock.
> 
> I actually started that, but decided this was the easier patch to send.
> Don't worry, I was expecting this email. No surprises here ;-)
> 
> This email was taken from Andrew Morton's play book (I see you Cc'd
> him, I forgot to). It's one of these patches of "It's so bad that the
> owner of the code will fix the issue out of fear that this patch may
> make it in".

Ah, I see :)

> > It can even live in the bcache code if we want since there currently
> > wouldn't be any other users, I don't really care. But open coding it?
> > Come on... makes me wonder what other code in the kernel is open coding
> > locks because it couldn't release it in the same process context that
> > took the lock for whatever reason.
> 
> Most cases just have completions. This looks like a case where "don't
> do something while transaction is taking place". Which can usually get
> away with a wait event.

Eh, only in sense that it's easy to implement mutexes and rwlocks with
wait_event().

To simplify the algorithm just a bit (only leaving out some
optimizations), bcache is using it to protect a rb tree, which containts
"things that are undergoing background writeback".

For foreground writes, we've got to check if the write overlaps with
anything in this rb tree. If so, we force _this_ write to writeback;
background writeback will write stale data to the backing device, but
that's fine because the data in the cache will still be marked as dirty.

To add stuff to this rb tree - i.e. for background writeback to start
flushing some dirty data - it's got to make sure it's not going to
overwrite some in progress foreground writethrough write.

Tracking every outstanding foreground write would be expensive, so
foreground writes take a read lock on the rb tree (both to check it for
anything they overlap with, and for their duration), and background
writeback takes a write lock when it goes to scan for dirty data to add
to the rb tree.

Even if you complain it's not _just_ protecting the rb tree, we're still
using it for mutual exclusion, plain and simple, and that's all a lock
is.


> > Also, nack this patch because increasing the number of atomic ops to
> > shared cachelines in our fast path. If it does end up being open coded,
> > I'll make a more efficient version.
> 
> Perhaps I can whip up a "struct rwsem_non_owner" and have a very
> limited API for that, and then you can use that.

That would be perfect :)
