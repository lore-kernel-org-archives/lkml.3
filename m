Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989Ab3BNUxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:53:31 -0500
Received: from kanga.kvack.org ([205.233.56.17]:56980 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003Ab3BNUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:53:29 -0500
Date: Thu, 14 Feb 2013 15:53:28 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zab@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WIP v1] aio: experimental use of threads, demonstration of cancel method
Message-ID: <20130214205328.GB25505@kvack.org>
References: <20130213221632.GA25312@kvack.org> <20130214193333.GG22221@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214193333.GG22221@lenny.home.zabbo.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:33:33AM -0800, Zach Brown wrote:
> On Wed, Feb 13, 2013 at 05:16:32PM -0500, Benjamin LaHaise wrote:
> > This patch is purely for experimentation purposes, and is by no means
> > complete or cleaned up for submission yet.  It is, however, useful for
> > demonstrating the cancellation of a kiocb when the kiocb is being
> > processed by using a kernel thread.
> 
> I'll raise the high level design questions:
> 
> 1) The patch handles the processing thread's current->mm needing to
>    match the submitting thread's.  What's the plan for the rest of the
>    task_struct state that a processing thread might need to read from and
>    write to the submitting thread?

The plan is to handle that with submit time helpers that get references to 
the state that is required for the operation in question.  For example, 
network operations would not need to get a reference on current->io_context, 
while block based filesystem operations would.  Helpers like this would be 
far simpler than writing fully asynchronous read/write ops.  Likely a 
bitmask of state to clone would make this easier to implement.

> 2) Why do we want to put aio between userspace and a pool of threads
>    that call syscalls?  Put another way: whatever the benefit is here,
>    can't the kernel offer that benefit as some "thread pool
>    coordination" interface and not force users to pass their work through
>    aio contexts and iocbs and the ring?

I don't see any need to introduce a new API at this point in time, plus 
the existing hooks allow for operations to do the submit in the caller's 
thread (which things like DIO will likely continue to need), which in turn 
will allow for only passing the state needed around.  There are problems 
with a generic thread pool management facility that supports arbitrary 
asynchronous syscalls: some syscalls assume particular thread-local state.  
Any generic facility would need to cope with the state problem as much as 
limited read/write operations do.  I don't see the complexity being much 
different.

If you can demonstrate a new API that has enough value to make the addition 
worthwhile, please show me the proof in the pudding.  I suspect most users 
just want something that works and don't care one way or another what the 
API is if it works.

> > way had any performance tuning done on it.  A subsequent demonstration
> > patch will be written to make use of queue_work() for the purpose of
> > examining and comparing the overhead of various APIs.
> 
> Hopefully cmwq could help, yeah.  You could also use a wake queue func
> to pass iocbs around under the wait queue lock and get rid of all the
> manual waking, locking, task state, and scheduling code.
...
> wait_queue_head_t waitq;

That's a good idea.  I'll give it a spin in the next version.

> An on-stack iocb pointer and wait queue in a container struct would let
> the wait queue's wakeup func set the iocb from the wake up's key and
> then call default_wake_func().

*nod*

> > +	cancel = cmpxchg(&iocb->ki_cancel, aio_thread_cancel_fn, NULL);
> > +	if (cancel == KIOCB_CANCELLED) {
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		while (!signal_pending(current)) {
> > +			schedule();
> > +			if (signal_pending(current))
> > +				break;
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +		}
> > +	} else
> > +		BUG_ON(cancel != aio_thread_cancel_fn);
> 
> It took me a while to guess what this was doing.  Is it trying to make
> sure that the cancel's force_signal() has finished before exiting? 

If the kiocb has been cancelled, this code ensures that the helper thread 
has received the SIGSEGV.  This ensures that the signal can then be flushed 
by flush_signals().  If the kiocb has not been cancelled, it can no longer 
be cancelled after the cmpxchg() has executed.

> Are we sure that no paths that could be called from an f_op have their
> own flush_signals() that would lose the cancel's signal?  Or that a call
> couldn't already have pending signals before the cancel's signal has
> been sent?

Looking around the tree, the only places that use flush_signals() tend to 
be kernel thread related code (mostly drbd, iscsi, md, some scsi bits and 
a few other places).  By definition, any read/write operation that flushes 
a SEGV signal in-kernel would be a bug (doing so would prevent a process 
from being killed by a kill -9), so I don't have any worries about this.  
Furthermore, neither users nor root can send a SEGV to these helper 
processes, as they are kernel threads with signals otherwise blocked.

> It seems fragile.

How so?  Nothing else in the kernel can generate these signals, and any 
other parts of the kernel flushing these signals would be a bug.  The only 
real concern would likely be in the signalfd code, which needs special 
handling.

...
> Scary stuff.  It'll be nice to see it go :).

Yup, that's vastly simplified by using wait queues.

> > +	void *aio_data;
> 
> A task_struct for a submitter and an iocb for the processing thread?  Is
> that just a quick hack for the prototype?  A few more bytes spent on
> separate members with proper types would be appreciated.  My brain is
> old.

I said this was an ugly first attempt. =)

		-ben
-- 
"Thought is the essence of where you are now."
