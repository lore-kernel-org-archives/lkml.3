Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLaWuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:50:39 -0500
Received: from tex.lwn.net ([70.33.254.29]:52239 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaLaWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:50:37 -0500
Date: Wed, 31 Dec 2014 15:50:35 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] doc: detailed documentation for completion
Message-ID: <20141231155035.5d49c60a@lwn.net>
In-Reply-To: <1419363700-26085-3-git-send-email-der.herr@hofr.at>
References: <1419363700-26085-1-git-send-email-der.herr@hofr.at>
	<1419363700-26085-3-git-send-email-der.herr@hofr.at>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014 20:41:40 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> diff --git a/Documentation/scheduler/completion-design.txt b/Documentation/scheduler/completion-design.txt
> new file mode 100644
> index 0000000..ec3e320
> --- /dev/null
> +++ b/Documentation/scheduler/completion-design.txt
> @@ -0,0 +1,498 @@
> +completion - wait for completion handler
> +========================================
> +
> +Origin: Linus Torvalds, kernel 2.4.7, 2001 [1]
> +Location: kernel/sched/completion.c [11]
> +	include/linux/completion.h
> +Users: all subsystems - mostly wait_for_completion and
> +	wait_for_completion_timeout is in use.

Again, I'm not sure we need this bit of stuff.

> +This document was originally written based on 3.18.0 (linux-next)
> +For general constraints and usage of completion see completion.txt

completion*s*

> +
> +Design Goal:
> +------------
> +
> + - Replace the semaphores used as "code"-locks - primarily for driver
> +   synchronization.
> + - Provide a primitive that is optimized for the contended case and
> +   not for the uncontended case (as semaphores are).
> + - Allow multiple threads to wait for the same condition to 'complete'.
> + - Provide a code-lock (similar to pthread_barriers or conditional
> +   variables)
> +   just a bit simpler.
> + - Have an API that makes the intent of the code clear (which the use
> +   of locks did not).
> + - Provide a proper way to yield the CPU for waiting on events which
> +   yield(); does not do [7]
> +
> +Design:
> +-------
> +
> + Locking, from the threads perspective, is intended to be used for
> + exclusion which raises issues of priority inversion, deadlocks etc.
> + while waiting for a specific state change to occur aka "completion"
> + is a thread synchronization point - so the exact opposite of an
> + exclusion point.
> +
> + Locks have been traditionally in (mis)use for code-locking while they
> + are intended for data locking only.
> +
> + Completion provides a simple counter to indicate how many waiting

"Completions provide..."

> + threads can continue. If a single thread should be allowed to
> + continue, the counter is incremented by 1 if ALL should be allowed to

semicolon after 1

> + continue it is simply incremented by UINT_MAX/2 which ensures that
> + ALL will be woken. Note that this behavior implies a one-shot nature
> + of completion - that means it is intended to signal one event only

completion*s*...I won't point this out everywhere.

> + and if a new event/condition is to be signaled then it needs to be
> + reinitialized. Completion has no notion of unlock/lock rather it is
> + initialized in a "not done"/locked state and can be unlocked once.
> +
> + The tasks that wait_for_completion are put on a wait-queue and when the
> + condition they are waiting for is signaled by a thread calling complete()
> + on the appropriate struct completion, the tasks waiting (one or all) is
> + woken by a call to try_to_wake_up().
> +
> + As the completion structure does not have an/ associated lock of its

Extraneous "/"?

> + own the wait-queue lock is used in cases where locking is needed e.g.

"wait queue"

> + complete(),complete_all(),try_wait_for_completion() and
> + completion_done().
> +
> + Completion replaced the (mis)used semaphores in synchronizing execution
> + paths - notably when there were multiple waiters.
> +
> +<snip>
> +   The basic summary is that we had this (fairly common) way of
> +   waiting for certain events by having a locked semaphore on the
> +   stack of the waiter, and then having the waiter do a "down()"
> +   which caused it to block until the thing it was waiting for did
> +   an "up()".
> +<snip> [1]

A quote like this could use some context.  "As Linus put it in 2001:" or
some such?

> + The design and also the core API implementation has been stable
> + since 2004.
> +
> + The _timeout/_interruptible API extension was added in 2004 [10]
> + to allow converting the racy sleep_on() users to the sound
> + completion API.
> +
> + An extension initially for the XFS object flushing was added in

s/the//

> + 2008 extending the API by the try_wait_for_completion() and

here too

> + completion_done() allowing safe use with held locks.
> +
> + The last extension was to add the _io variants in 2013 [14]. These
> + were added to correct iowait time accounting when the completion
> + is used for waiting on IO (e.g.  completion of a bio request in
> + the block layer). Currently this is only used in the block layer.
> +
> +
> +Design rational for a new primitive:

rationale

> +------------------------------------
> +
> + So why not extend semaphores rather than add a new primitive ?
> +
> + - Semaphores are optimized for the non-contention case. The "wait
> +   for completion" usage has the opposite default case.
> + - The optimization of semaphores is architecture-specific, making
> +   it hard to change this and probably would have not been possible
> +   without a penalty. There as at least an attempt to provide
> +   completion as a wrapper to semaphores [3] but this path was not
> +   further followed.
> + - Problem with semaphores that are declared on the local stack
> +   doing down(); return; [1] or:
> +   down(); kfree() on the semaphore [2].

This is not a complete sentence, and it's not clear what the point is.

> + - The intent of the code is not made clear when using locks
> +
> +
> +Implementation:
> +===============
> +
> + Completion is built on top of the generic kernel event infrastructure,
> + it can be seen as a specialized front-end to events.
> +
> + Basically there are three parts to the API, the initialization
> + of the completion, the waiting part through a call to a variant
> + of wait_to_completion and the signaling side through a call to
> + complete(). The structure used for handling of completion is:
> +
> +	struct completion {
> +		unsigned int done;
> +		wait_queue_head_t wait;
> +	};
> +
> + completions primitives come in two big groups, blocking through
> + enqueuing the task on the wait-queue and non-blocking which will never
> + queue the task. The non-blocking variants are prefixed with a
> + try_ (e.g. try_wait_for_completion()).
> +
> +
> +init_completion()/reinit_completion:
> +
> + As the default state is "not available" all that needs to be done is
> + to initialize the counter to 0 and provide an initialized wait queue
> + for potential waiters to enqueue on. For struct completion *x this is
> + thus two lines:
> +
> +	x->done = 0;
> +	init_waitqueue_head(&x->wait);
> +
> + The re-initialization simply resets the done variable to "not done"
> + thus 0. So reinit_completion is one line:
> +
> +	x->done = 0;
> +
> +
> +complete()/complete_all():
> +
> + A call to complete signals completion by incrementing the wait
> + condition, x->done++ for signaling only one waiter, respectively
> + adding UNIT_MAX/2 to signal all waiters. Both complete() and
> + complete_all() serialize by holding the associated wait-queue lock.
> +
> + The call chain for complete() to wake up waiters for one task is:
> +
> + wake_up_locked
> +  -> __wake_up_locked((x), TASK_NORMAL, 1)
> +    -> __wake_up_common(q, mode, nr, 0, NULL);    nr == 1
> +      -> __wake_up_common
> +           will call the first waiter in the queue
> +           by calling:
> +             -> autoremove_wake_function
> +               -> default_wake_function
> +                 -> try_to_wake_up
> +

I'm not sure this is useful to understand completions.  It's also the kind
of thing that goes out of date quickly.

> + for ALL tasks at once:
> +
> + wake_up_all_locked
> +  -> __wake_up_locked((x), TASK_NORMAL, 0)
> +    -> __wake_up_common(q, mode, nr, 0, NULL);    nr == 0 == ALL
> +      -> __wake_up_common
> +           will iterate over the wait-queue and
> +           wake all waiting threads by calling:
> +             -> autoremove_wake_function
> +               -> default_wake_function
> +                 -> try_to_wake_up
> +
> + The autoremove_wake_function was registered through a call in
> + prepare_to_wait_event (wait->func = autoremove_wake_function;)
> +
> + Note that __wake_up_common is not specific to completion and would
> + allow waking a defined number of waiters, but the completion interface
> + only provides one or all.
> +
> +
> +wait_for_completion():
> +
> + The default behavior is to wait without a timeout and mark the task
> + as uninterruptible (ignoring all signals until woken).
> +
> + wait_for_completion    default uninterruptiple and MAX_SCHEDULE_TIMEOUT
> +  -> wait_for_common
> +    -> __wait_for_common
> +      -> do_wait_for_common
> +        -> __add_wait_queue_tail_exclusive
> +             which will conditionally add the task to the
> +             wait queue (if done == 0) and also checks
> +             signals before setting the tasks state to
> +             TASK_UNINTERRUPTIBLE via __set_current_state.
> +
> + The timeout and interruptible variants use the same call chain but
> + start at wait_for_completion_timeout() passing in a timeout rather than
> + MAX_SCHEDULE_TIMEOUT and wait_for_completion_interruptible() passes
> + TASK_INTERRUPTIBLE as the tasks designated state rather than

task's

> + TASK_UNINTERRUPTIBLE. The combined type is then
> + wait_for_completion_interruptible_timeout() which passes both a timeout
> + and TASK_INTERRUPTIBLE. Finally a last type is _killable which passes
> + TASK_KILLABLE, that is equivalent to (TASK_WAKEKILL |
> + TASK_UNINTERRUPTIBLE) as the designated tasks state and thus does not
> + need to be explicitly woken up to receive a terminating signal. It will
> + return a -ERESTARTSYS if interrupted or else 0 (completion achieved)
> + [16][17].
> +
> + The _io variants of wait_for_completion behave the same except for
> + setting the tasks current->in_iowait indicating that the thread is
> + waiting on IO which is used to account waiting times for the thread
> + via iowait_count and iowait_sum [9].
> +
> +
> +try_wait_for_completion()/completion_done():
> +
> + The try_wait_for_completion will not put the thread on the wait-queue
> + but rather returns 0 if it would need to enqueue (block) the thread,

Again, it's a bool; it returns FALSE

> + else it consumes any posted completion (x->done--) and returns.
> + try_wait_for_completion is primarily used to consume possibly missed

try_wait_for_completion()

> + events or clear any pending completions from failed actions
> + (e.g. see sound/soc/codecs/wm8996.c:wm8996_set_fll).
> +
> + Finally to check state of a completion without changing it in any way
> + is provided by completion_done();
> +
> +
> +Declaration and initialization:
> +-------------------------------
> +
> +Note on naming:
> +
> + completions should be named to convey the intent of the waiter
> + e.g.:
> +	wait_for_completion(&early_console_added);
> +	...
> +	complete(&early_console_added);
> +
> + is easier to understand than a more or less meaningless variable
> + naming like:
> +	wait_for_completion(&Completion);
> +	...
> +	complete(&Completion);
> + unfortunately the later being not that uncommon.
> +
> +
> +dynamic declaration and initialization:
> +
> +	struct completion setup_done;
> +
> +	init_completion(&setup_done)
> +
> +  Simply initialize "done" to 0 (calls to wait_for_completion() will
> + thus block) as well as initializing the wait queue.
> +
> +
> +	reinit_completion(&setup_done)
> +
> +  This reinitializes "done" to 0 and leaves the wait-queue untouched.
> +
> +
> +static declaration and initialization:
> +
> +	static DECLARE_COMPLETION(setup_done)
> +
> +  File scope static initialization.
> +
> +	DECLARE_COMPLETION_ONSTACK(setup_done) [15]
> +
> +  This declares and initializes a completion structure on the kernel
> + stack. This is for initializing local/automatic completion variables
> + on the kernel stack. Under the hood this calls the dynamic
> + init_completion on the struct completion passed.
> +
> +
> +Usage:
> +======
> +
> + The basic usage is simply described by the initial post [1]
> + describing a replacement for the misused semaphores.

This is fine, but why not just reference that nice usage document you
posted as part 1?

> +<snip>
> +	So instead, I introduced the notion of "wait for completion":
> +
> +	struct completion event;
> +
> +	init_completion(&event);
> +	... pass of event pointer to waker ..
> +	wait_for_completion(&event);
> +
> +	where the thing we're waiting for just does "complete(event)"
> +	and we're all done.
> +<snip>
> +
> + The API has been expanded a bit since the initial release to handle
> + timeouts and interruptible and killable completions as well as
> + non-blocking try_ variant.
> +
> + the most common usage is wait_for_completion and the timeout variant:
> +
> +	wait_for_completion                       562
> +	wait_for_completion_timeout               428
> +	wait_for_completion_interruptible_timeout 73
> +	wait_for_completion_interruptible         68
> +	try_wait_for_completion                   8
> +	wait_for_completion_io                    6
> +	wait_for_completion_io_timeout            1
> +
> +	[number of call sites as of 3.18.0-rc7]

Not sure this is useful - and it will immediately go out of date.

> +  Note that the number of call sites need to reflect the usage as some
> + calls sites are in wrapper functions - this should just show the
> + relative distribution and the rough overall usage.
> +
> +
> +complete()/complete_all():
> +
> +
> +	complete(struct completion *x)
> +
> +  Increment the "done" field (x->done++) allowing one waiter to proceed.

It also does a wakeup - seems worth a mention somehow.

> +	complete_all(struct completion *x)
> +
> +  Increment the counter (x->done += UNIT_MAX/2) to effectively a large
> + enough number to ensure that all waiters will be woken. Note that
> + the counter is not zeroed, so the value of x->done found there after
> + a call to complete_all() is more or less meaningless. Calling
> + complete_all() multiple times will role-over but always be "large"

"roll over" (or, better, "overflow").

> + never the less calling complete_all() multiple times on the same

"nevertheless"

> + completion object is most likely a bug.

If we're going to give that advice, it seems that mixing complete() and
complete_all() is also a path to little joy...

> +
> +wait_for_completion*():
> +
> +	wait_for_completion(struct completion *x)
> +
> +  for blocking wait on an event like a startup/shutdown or a sent
> + command to complete and (properly) yield the CPU for productive
> + use in the meantime.
> +
> +
> +	wait_for_completion_interruptible(struct completion *x)
> +
> +  Basically a blocking call but it may return immediately if a
> + restart has been received already by the time call. In most

Not sure what "restart has been received already by the time call" means.
It returns if a signal arrives...?

> + cases were _interruptible variants are used, the interruption
> + indicates an error condition, so the _interruptible versions
> + should always be checking the return value.

And that return value is, exactly...?  :)

> +	wait_for_completion_io_timeout(struct completion *x,
> +		unsigned long timeout)
> +
> +  Blocking call with a timeout rather than waiting for ever, the return

"forever"

> + value is the remaining wait time if completion occurred (at least 1
> + though to ensure the conditions can be differentiated) and 0 if
> + timeout occurred this somewhat strange handling of the timeout value

"occurred.  This..."

> + is due to a race [4] where system load could lead to the condition
> + being achieved and the timeout occurring anyway..
> +
> +
> + 	wait_for_completion_interruptible_timeout(struct completion *x,
> +		unsigned long timeout)
> +
> +
> +  Blocking call combining the above two cases with the return value
> + differentiating the cases as follows:
> +	-ERESTARTSYS if interrupted,
> +	0 if timed out,
> +	>0 (1 or number of jiffies left till timeout) if completed.

s/till/until/

> +
> +
> +	wait_for_completion_killable(struct completion *x)
> +
> +  Blocking call like wait_for_completion_interruptible but will only
> + terminate wait if a SIGKILL (__fatal_signal_pending) is received

There are a number of fatal signals normally, not just SIGKILL

> + rather than on any signal as wait_for_completion_interruptible. Note
> + the return value is also -ERESTARTSYS in case a SIGKILL was received
> + and 0 if completion occurred.
> +
> +
> +	wait_for_completion_killable_timeout(struct completion *x,
> +		unsigned long timeout)
> +
> +  Blocking call like wait_for_completion_interruptible_timeout just
> + that receiving -ERESTARTSYS indicates that SIGKILL was received.
> +
> +
> +_io() variants:
> +
> +	wait_for_completion_io(struct completion *);
> +	wait_for_completion_io_timeout(struct completion *x,
> +		unsigned long timeout);
> +
> +  These calls are essentially the same as there non-_io variants
> + except that they call io_schedule_timeout() rather than
> + schedule_timeout(). Essentially the difference is that the first
> + sets current->in_iowait = 1 indicating that the task is waiting for
> + IO and not just sleeping.
> +
> +
> +_try() variant:
> +
> +	try_wait_for_completion(struct completion *)
> +
> +  The non-blocking try_ variant was introduced to allow
> + use of completions to begin safely while holding locks. If it
> + would block the thread (x->done is 0) it returns 0 else 1

Again, it's bool

> + indicating that completion was achieved at the time of call.
> + Note, that it can block on the wait-queue lock if complete() or
> + complete_all() is in progress - the non-blocking refers only to
> + not enqueuing the calling thread on the wait-queue.

I'm not sure I'd use "block" in that context; it might wait for a spinlock
but that wait will be brief.  We hope.

> +	completion_done(struct completion *)
> +
> +  This is a non-blocking check for completion in progress, returning
> + 0 if there are waiters and 1 otherwise. In some rare cases (e.g. in

returns a bool

> + kernel/stop_machine.c:stop_machine_from_inactive_cpu)
> + completion_done issued in a busy-wait loop like so:

s/issued/is called/

> +	while (!completion_done(&done.completion))
> +		cpu_relax();

...but do we want to encourage people to code that type of loop?  It
shouldn't be needed in too many places...

> +ARM specific: per_cpu completion in ARM (Nicolas Pitre)
> +
> + This currently ARM specific extension provides basic IPI triggered
> + completion support through:
> +
> + register_ipi_completion - to register a per_cpu completion
> + ipi_complete - to signal completion
> +
> + currently this is used only on ARM (see: arch/arm/kernel/smp.c)
> +
> +
> +Notes on RT:
> +============

Again, I wonder if this should be in the -rt tree instead.

> +
> + * in PREEMPT_RT the wait-queue used in queuing tasks is changed to a
> +   simple wait-queue to minimize the lock contention of the queue
> +   related lock [6].
> + * PREEMPT_RT only changes the completion usage related to stop_machine
> +   [13]
> +
> +
> +Notes on history of completion:

"Notes on the history of completions"

> +
> + After the initial API proposal focused on resolving the semaphore
> + misuse for code synchronization [1] the API was relatively quickly
> + extended by the _timeout and _interruptible variants (2004) [10].
> + The completion API was extended by the try_wait_for_completion()/
> + completion_done() to accommodate for XFS object flushing needs which
> + did not quite fit the available completion API [12].  The _killable
> + variant was added in 2007 [17] together with a whole set of event
> + subsystem primitives allowing asynchronous kill without wakeup [16]
> + to take care of unkillable tasks. _killable_timeout was later added
> + for Ceph waiting on MDS requests [16]. The final API extension was
> + for provision of proper scheduling accounting in the block layer which
> + added _io versions [14].
> + As completion is a "code-lock" it resided in the core scheduling
> + code (kernel/sched.c) for a long time, it was not until 2013 [11]
> + that it was moved into a separate kernel/sched/completion.c file.
> +
> +References:
> +===========
> +
> +Link: 1  http://lkml.iu.edu/hypermail/linux/kernel/0107.3/0674.html
> +tink: 2  http://lkml.iu.edu/hypermail/linux/kernel/0107.3/0733.html
> +Link: 3  http://lwn.net/Articles/277621/
> +Link: 4  /lkml.iu.edu/hypermail/linux/kernel/0806.2/1659.html
> +Link: 5  https://lkml.org/lkml/2014/7/5/229
> +Link: 6  https://www.kernel.org/pub/linux/kernel/projects/rt/
> +	Thomas Gleixner completion-Use-simple-wait-queues.patch
> +	part of the rt patch series
> +File: 7  see the notes in kernel/sched/core.c:yield why not to use it
> +Link: 8  LWN Porting Drivers to 2.6 series
> +	http://lwn.net/Articles/23993/
> +File: 9  see kernel/sched/fair.c:enqueue_sleeper
> +Link: 10 http://lkml.org/lkml/2004/10/20/461
> +Link: 11 http://lkml.org/lkml/2013/11/6/166
> +Link: 12 http://oss.sgi.com/archives/xfs/2008-06/msg01320.html
> +Link: 13 https://www.kernel.org/pub/linux/kernel/projects/rt/
> +	Thomas Gleixner stomp-machine-raw-lock.patch.patch
> +	part of the rt patch series
> +Link: 14 http://lkml.org/lkml/2013/2/14/209
> +Link: 15 http://lkml.org/lkml/2006/9/28/83
> +Link: 16 http://lkml.org/lkml/2010/5/24/198
> +Link: 17 http://lwn.net/Articles/288056/
> +Link: 18 https://www.mail-archive.com/git-commits-head@vger.kernel.org/msg37284.html

Again, thanks for doing this.

jon
