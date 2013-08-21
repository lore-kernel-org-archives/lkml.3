Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab3HUIie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:38:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3HUIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:38:24 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=2OzRHhLI-igA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IuSzSYa--aEA:10 a=6IzRx_vaAAAA:8 a=1XgbTMcIoZujeijMWV0A:9 a=CjuIK1q_8ugA:10 a=WYjQ3DCYG8cA:10 a=8qLt0MA8ctR2pIsb:21 a=ngbk0CvZtQqHOTdq:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 04:38:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Message-ID: <20130821043821.6e1224b4@gandalf.local.home>
In-Reply-To: <20130821033658.GE4051@kmo-pixel>
References: <20130820111602.3cea203c@gandalf.local.home>
	<20130821021900.GB4051@kmo-pixel>
	<20130820224153.5667495b@gandalf.local.home>
	<20130821033658.GE4051@kmo-pixel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 20:36:58 -0700
Kent Overstreet <kmo@daterainc.com> wrote:


> I think we're mostly quibbling over semantics here, and it's not that
> big a deal - that said, I don't really get your distinction between a
> semaphore and a mutex; I'd distinguish them by saying a semaphore can
> count an arbitrary number of resources (the number it's initialized to),
> and a mutex is always initialized to one - the fact that in the kernel
> mutexes must be released by the same process that took them (while
> important for PI and debugging) is not fundamental.

Understood. As, I usually am focused on PI and debugging, it may be
more fundamental to me than others.

> 
> "rw semaphore" never made any sense to me; they're not counting
> anything, like regular semaphores. They're just sleepable rw locks.

Me either.

> 
> So it _sounds_ like you're saying bcache is using it as a semaphore,
> beacuse it's using it as a lock we don't release in the original
> context? in analogy to linux mutexes and semaphores? Not quite sure what
> you mean.

Actually, I'm thinking you are using it more as a completion than a
semaphore.


> > I have a hack that actually implements a work around for non_owner, but
> > it adds overhead to all locks to do so.
> 
> Ok - I'd just be curious why the PI bit can't be factored out into a
> wrapper like how the debug stuff is handled with the _non_owner bits,
> but I can certainly believe that.

The problem is that all sleeping locks go through rt_mutex. The locks
are replaced with locks that incorporate PI.


> To simplify the algorithm just a bit (only leaving out some
> optimizations), bcache is using it to protect a rb tree, which containts
> "things that are undergoing background writeback".

I think this is what makes bcache unique in the kernel, and I don't
think there's open coded locks elsewhere.

> 
> For foreground writes, we've got to check if the write overlaps with
> anything in this rb tree. If so, we force _this_ write to writeback;
> background writeback will write stale data to the backing device, but
> that's fine because the data in the cache will still be marked as dirty.
> 
> To add stuff to this rb tree - i.e. for background writeback to start
> flushing some dirty data - it's got to make sure it's not going to
> overwrite some in progress foreground writethrough write.
> 
> Tracking every outstanding foreground write would be expensive, so
> foreground writes take a read lock on the rb tree (both to check it for
> anything they overlap with, and for their duration), and background
> writeback takes a write lock when it goes to scan for dirty data to add
> to the rb tree.
> 
> Even if you complain it's not _just_ protecting the rb tree, we're still
> using it for mutual exclusion, plain and simple, and that's all a lock
> is.

Well, rwlocks and rwsems are not mutually exclusive ;-) The read side
has multiple accessors. A mutual exclusion also would be a single task
needing exclusive access to a resource. But as things are done in the
background, that is not the case. But we are arguing semantics here and
not helping with a solution.

> 
> 
> > > Also, nack this patch because increasing the number of atomic ops to
> > > shared cachelines in our fast path. If it does end up being open coded,
> > > I'll make a more efficient version.
> > 
> > Perhaps I can whip up a "struct rwsem_non_owner" and have a very
> > limited API for that, and then you can use that.
> 
> That would be perfect :)

OK, I'll see what I can do.

-- Steve


