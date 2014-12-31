Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaLaWaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:30:02 -0500
Received: from tex.lwn.net ([70.33.254.29]:52187 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaLaWaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:30:00 -0500
Date: Wed, 31 Dec 2014 15:29:58 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] doc: brief user documentation for completion
Message-ID: <20141231152958.1031f153@lwn.net>
In-Reply-To: <1419363700-26085-2-git-send-email-der.herr@hofr.at>
References: <1419363700-26085-1-git-send-email-der.herr@hofr.at>
	<1419363700-26085-2-git-send-email-der.herr@hofr.at>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm finally getting around to looking at this.  Honestly, I think we could
add it now and make our documentation better, but I'm going to pick nits
anyway in the hopes of one more round of improvement :)

On Tue, 23 Dec 2014 20:41:39 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> diff --git a/Documentation/scheduler/completion.txt b/Documentation/scheduler/completion.txt
> new file mode 100644
> index 0000000..d35a948
> --- /dev/null
> +++ b/Documentation/scheduler/completion.txt
> @@ -0,0 +1,198 @@
> +completion - wait for completion handler
> +========================================
> +
> +Origin: Linus Torvalds, kernel 2.4.7, 2001
> +Location: kernel/sched/completion.c
> +	include/linux/completion.h
> +Users: all subsystems - mostly wait_for_completion and
> +	wait_for_completion_timeout is in use.

I'm not sure we need this stuff; will it really help readers to use this
facility?  

> +This document was originally written based on 3.18.0 (linux-next)

This, instead, is something I wish we had in more of our documentation; it
lets future readers get a sense for how likely it is to be current.

> +Introduction:
> +=============
> +
> +Completion is a code synchronization mechanism that is preferable to mis-

It would read a bit better to talk about completions in the plural
everywhere.  "Completions are..."

> +using of locks - semantically they are somewhat like a pthread_barrier. If
> +you have one or more threads of execution that must wait for some process
> +to have reached a point or a specific state, completions can provide a race
> +free solution to this problem.
> +
> +Completion is built on top of the generic event infrastructure in Linux,

Here too

> +with the event reduced to a simple flag appropriately called "done" in
> +struct completion, that tells the waiting threads of execution that they
> +can continue safely.
> +
> +For details on completion design and implementation see completion-design.txt
> +
> +Usage:
> +======
> +
> +Basically there are three parts to the API, the initialization of the

"There are three parts to the API: ..."

> +completion, the waiting part through a call to a variant of
> +wait_to_completion and the signaling side through a call to complete()

Let's use the function notation consistently (and get the name right while
we're at it) - wait_for_completion()

> +or complete_all().
> +
> +To use completions one needs to including <linux/completion.h> and
> +creating a variable of type struct completion. The structure used for

"to include" and "create"

> +handling of completion is:
> +
> +	struct completion {
> +		unsigned int done;
> +		wait_queue_head_t wait;
> +	};
> +
> +providing the wait queue to place tasks on for waiting and the flag for
> +indicating the state of affairs.
> +
> +Completions should be named to convey the intent of the waiter.  A good
> +example is:
> +
> +	wait_for_completion(&early_console_added);
> +
> +	complete(&early_console_added);
> +
> +good naming (as always) helps code readability.
> +
> +
> +init_completion:

init_completion().  But even better would be "Initialization" or something
like that.

> +----------------
> +
> +Initialization is accomplished by init_completion() for dynamic

accomplished *by calling* init_completion()...

> +initialization. It initializes the wait-queue and sets the default state

wait queue (no hyphen)

> +to "not available", that is, "done" is set to 0.
> +
> +The reinitialization reinit_completion(), simply resets the done element

The reinitialization *function* reinit_completion()...

> +to "not available", thus again to 0, without touching the wait-queue.
> +
> +declaration and initialization macros available are:

*The* declaration and ...

> +
> +	static DECLARE_COMPLETION(setup_done)
> +
> +used for static declarations in file scope - probably NOT what you want to
> +use - instead use:

There are some 50 uses, so it has its value.

> +	DECLARE_COMPLETION_ONSTACK(setup_done)
> +
> +used for automatic/local variables on the stack and will make lockdep happy.

All this is good, but the predominant use looks to be embedding a
completion directly into some other structure and initializing it
explicitly.  It might be worth finding a way to actually say that.

> +wait_for_completion:

wait_for_completion()  (or "Waiting")

> +--------------------
> +
> +For a thread of execution to wait on some other thread to reach some
> +preparatory action to reach completion, this is achieved by passing the
> +completion event to wait_for_completion():

That sentence is a bit hard to read.  How about something like:

     A thread may wait for a completion to be signaled by calling one of
     the variants of wait_for_completion().

> +
> +	wait_for_completion(struct completion *done):

Here (and with all of them) it would be nice to have the return type too.
"void" in this case.

> +The default behavior is to wait without a timeout and mark the task as
> +uninterruptible.
> +
> +
> +Variants available are:
> +
> +	wait_for_completion_interruptible(struct completion *done)
> +
> +marking the task TASK_INTERRUPTIBLE.  

Return value?  It's important here.  It's -ERESTARTSYS if interrupted.

> +	wait_for_completion_timeout(struct completion *done,
> +		unsigned long timeout)

Return value here too: it's the number of jiffies until the timeout - zero
if the timeout happened. 

> +passing a timeout in jiffies and marking the task as TASK_UNINTERRUPTIBLE.
> +
> +	wait_for_completion_interruptible_timeout(struct completion *done,
> +		unsigned long timeout)

...and here too

> +passing a timeout in jiffies and marking the task as TASK_INTERRUPTIBLE.
> +
> +Further variants include _killable which passes TASK_KILLABLE as the
> +designated tasks state and will return a -ERESTARTSYS if interrupted or
> +else 0 if completion was achieved.

It's worth noting that a fatal signal has been received in that case.  Nice
to see the return value documented though! :)

> +	wait_for_completion_killable(struct completion *done)
> +	wait_for_completion_killable_timeout(struct completion *done,
> +		unsigned long timeout)
> +
> +The _io variants wait_for_completion_io behave the same as the non-_io
> +variants, except for accounting its waiting time as waiting on IO.
> +
> +	wait_for_completion_io(struct completion *done)
> +	wait_for_completion_io_timeout(struct completion *done
> +		unsigned long timeout)
> +
> +complete:

complete()  (or "Signaling completion")

> +---------
> +
> +A thread of execution that wants to signal that the conditions for
> +continuation have been achieved calls complete() to signal exactly one
> +of the waiters that it can continue
> +
> +	complete(struct completion *done)
> +
> +or calls complete_all to signal all current and future waiters.
> +
> +	complete_all(struct completion *done)
> +
> +The signaling will work as expected even if completion is signaled before
> +a thread starts waiting. This is achieved by the waiter "consuming"
> +(decrementing) the done element of struct completion.
> +
> +If complete() is called multiple times then this will allow for that number
> +of waiters to continue - each call to complete() will simply increment the
> +done element. Calling complete_all() multiple times is a bug though.
> +
> +
> +try_wait_for_completion()/completion_done():
> +--------------------------------------------
> +
> +The try_wait_for_completion will not put the thread on the wait-queue but
> +rather returns 0 if it would need to enqueue (block) the thread, else it
> +consumes any posted completion and returns.

Um, it's a bool, so we should document the return value as such.  Again,
being explicit about return types is useful.

> +	try_wait_for_completion(struct completion *done)
> +
> +Finally to check state of a completion without changing it in any way is
> +provided by completion_done();
> +
> +	completion_done(struct completion *done)
> +
> +
> +Constraints:
> +============

The information in this section is all useful, but I really think it should
be placed in the text above where it's relevant.  Why make readers jump
back and forth?

> + * DECLARE_COMPLETION should not be used for completion objects
> +   declared within functions (automatic variables) use
> +   DECLARE_COMPLETION_ONSTACK for that case.
> + * calling init_completion() on the same completion object is most
> +   likely a bug - use reinit_completion() in that case.
> + * Waiting threads wakeup order is the same in which they were
> +   enqueued (FIFO order).
> + * There only can be one thread calling complete() or complete_all()
> +   on a particular struct completion at any time - serialized
> +   through the wait-queue spinlock. Any concurrent calls to
> +   complete() or complete_all() probably are a design bug though.
> + * Calling complete() multiple time is permitted, calling
> +   complete_all() multiple times is very likely a bug.
> + * Timeouts are in jiffies - use msecs_to_jiffies/usecs_to_jiffies to
> +   convert arguments.
> + * By default wait_for_completion is neither interruptible nor will it
> +   time out - appropriate _interruptible/_timeout variants must be
> +   used.
> + * With held locks only try_wait_for_completion is safe, all other
> +   variants can sleep.

With held *spinlocks*.  One can hold a mutex, of course.

> + * The struct completion should be given a meaningful name - e.g.
> +   &cmd.complete or thread->started but not &completion. so that
> +   it is clear what is being waited on.
> + * The completion API is basically RT safe as it only is using
> +   boostable locks but these could never the less be held for quite

"nevertheless"

> +   lengthy periods of time.
> + * In PREEMPT_RT the wait-queue used in queuing tasks is changed to a
> +   simple wait-queue to minimize the lock contention of the queue

again, "wait queue"

> +   related lock.
> + * PREEMPT_RT only changes the completion usage related to stop_machine

Should this information go in the -rt tree instead, to be merged when the
relevant code is?  It's hard enough to keep these things current when
they're in the same tree.

> +Code that thinks of using yield() or some quirky msleep(1); loop to allow
> +something else to proceed probably wants to look into using
> +wait_for_completion() instead.

Thanks for doing this!

jon
