Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765Ab3DDN2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:28:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44270 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760371Ab3DDN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:28:29 -0400
Date: Thu, 4 Apr 2013 15:31:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130404133123.GW2228@phenom.ffwll.local>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365076908.2609.94.camel@laptop>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:01:48PM +0200, Peter Zijlstra wrote:
> 
> I'm sorry, this email ended up quite a bit longer than I had hoped for;
> please bear with me.
> 
> On Tue, 2013-04-02 at 18:59 +0200, Peter Zijlstra wrote:
> >   struct ww_mutex; /* wound/wait */
> > 
> >   int mutex_wound_lock(struct ww_mutex *); /* returns -EDEADLK */
> >   int mutex_wait_lock(struct ww_mutex *);  /* does not fail */
> > 
> > Hmm.. thinking about that,.. you only need that second variant because
> > you don't have a clear lock to wait for the 'older' process to
> > complete; but having the unconditional wait makes the entire thing
> > prone to accidents and deadlocks when the 'user' (read your fellow
> > programmers) make a mistake.
> > 
> > Ideally we'd only have the one primitive that returns -EDEADLK and use
> > a 'proper' mutex to wait on or somesuch.. let me ponder this a bit
> > more.
> 
> So I had me a little ponder..

I need to chew some more through this, but figured some early comments to
clarify a few things would be good.

> Its all really about breaking the symmetry (equivalence of both sides)
> of the deadlock. Lets start with the simplest AB-BA deadlock:
> 
> 	task-O	task-Y
> 	  A
> 		B
> 		A <-- blocks on O
> 	  B <-- blocks on Y
> 
> In this case the wound-wait algorithm says that the older task (O) has
> precedence over the younger task (Y) and we'll 'kill' Y to allow
> progress for O.
> 
> Now clearly we don't really want to kill Y, instead we'll allow its
> lock operation to return -EDEADLK.
> 
> This would suggest that our 'new' mutex implementation (ww_mutex
> henceforth) has owner tracking -- so O acquiring B can find Y to 'kill'
> -- and that we have a new wakeup state TASK_DEADLOCK similar to
> TASK_WAKEKILL (can we avoid this by using the extra state required
> below? I don't think so since we'd have the risk of waking Y while it
> would be blocked on a !ww_mutex)

We do add some form of owner tracking by storing the reservation ticket
of the current holder into every ww_mutex. So when task-Y in your above
example tries to acquire lock A it notices that it's behind in the global
queue and immedieately returns -EAGAIN to indicate the deadlock.

Aside, there's a bit of fun in that ttm uses -EDEADLCK for when you try to
reserve the same buffer twice - it can easily detect that by comparing the
lock owner ticket with the provided one and if it matches bail out. The
special error code is useful since userspace could prepare a gpu
batch command submission which lists a buffer twice, which is a userspace
bug with the current drm/gem apis. But since userspace usually doesn't try
to trick the kernel it's better to detect this lazily, and due to the
retry logic we have all the relevant error bail-out code anyway.

Hence we've kept the special -EDEADLCK semantics even for the ww_mutex
stuff.

> Now this gets a little more interesting if we change the scenario a
> little:
> 
> 	task-O	task-Y
> 	  A
> 		B
> 	  B <-- blocks on Y
> 		* <-- could be A

The current code at least simple blocks task-O on B until task-Y unlocks
B. Deadlocks cannot happen since if task-Y ever tries to acquire a lock
which is held by an older task (e.g. lock A) it will bail out with
-EAGAIN.

> In this case when O blocks Y isn't actually blocked, so our
> TASK_DEADLOCK wakeup doesn't actually achieve anything.
> 
> This means we also have to track (task) state so that once Y tries to
> acquire A (creating the actual deadlock) we'll not wait so our
> TASK_DEADLOCK wakeup doesn't actually achieve anything.
> 
> Note that Y doesn't need to acquire A in order to return -EDEADLK, any
> acquisition from the same set (see below) would return -EDEADLK even if
> there isn't an actual deadlock. This is the cost of heuristic; we could
> walk the actual block graph but that would be prohibitively expensive
> since we'd have to do this on every acquire.

Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the wait
times of older task. This could be interesting for RT, but I'm unsure of
the implications. The trick with the current code is that the oldest task
will never see an -EAGAIN ever and hence is guaranteed to make forward
progress. If the task is really unlucky though it might be forced to wait
for a younger task for every ww_mutex it tries to acquire.

The thing is now that you're not expected to hold these locks for a long
time - if you need to synchronously stall while holding a lock performance
will go down the gutters anyway. And since most current gpus/co-processors
still can't really preempt fairness isn't that high a priority, either.
So we didn't think too much about that.

> This raises the point of what would happen if Y were to acquire a
> 'regular' mutex in between the series of ww_mutexes. In this case we'd
> clearly have an actual deadlock scenario. However lockdep would catch
> this for we'd clearly invert the lock class order:
> 
> 	ww_mutex -> other -> ww_mutex
> 
> For the more complex scenarios there's the case of multiple waiters. In
> this case its desirable to order the waiters in age order so that we
> don't introduce age inversion -- this minimizes the amount of -EDEADLK
> occurrences, but also allows doing away with the unconditional wait.
> 
> With the lock queue ordering we can simply immediately re-try the lock
> acquisition sequence. Since the older task is already queued it will
> obtain the lock, even if we re-queue ourselves before the lock is
> assigned.
> 
> Now the one thing I've so far 'ignored' is how to assign age. Forward
> progress guarantees demand that the age doesn't get reset on retries;
> doing so would mean you're always pushing yourself fwd, decreasing your
> 'priority', never getting to be the most eligible. However it also
> means that we should (re)set the time every time we start a 'new'
> acquisition sequence. If we'd use a static (per task) age the task with
> the lowest age would be able to 'starve' all other.
> 
> This means we need means to mark the start of an acquisition sequence;
> one that is not included in the restart loop.
> 
> Having a start suggests having an end marker too, and indeed we can
> find a reason for having one; suppose our second scenario above, where
> Y has already acquired all locks it needs to proceed. In this case we
> would have marked Y to fail on another acquisition. This doesn't seem
> like a problem until you consider the case where we nest different
> mm_mutex sets. In this case Y would -EDEADLK on the first of the second
> (nested) set, even though re-trying that set is pointless, O doesn't
> care.

Another big reason for having a start/end marker like you've describe is
lockdep support. Lockdep is oblivious to the magic deadlock avoidance, so
when trying to just annotate the ww_mutexes themselves you can only
annotate them as trylocks (which in a way they are). But that completely
breaks lockdep warnings for the above mentioned

> 	ww_mutex -> other -> ww_mutex

loop. So we don't want that. The trick Maarten's patches employ is to add
a fake/virtual lockdep lock for the reservation ticket/age itself, which
is acquired in start and dropped again in end. All the ww_mutex locking is
then annotated as blocking locks nested within that virtual mutex (this is
already used in mm_take_all_locks). Maarten added a few patches to ensure
that lockdep properly checks this nesting, too:

commit d094595078d00b63839d0c5ccb8b184ef242cb45
Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date:   Thu Sep 13 11:39:51 2012 +0200

    lockdep: Check if nested lock is actually held

> Furthermore, considering the first scenario, O could block on a lock of
> the first set when Y is blocked on a lock of the second (nested) set;
> we need means of discerning the different lock sets. This cannot be
> done by local means, that is, any context created by the start/end
> markers would be local to that task and would not be recognizable by
> another as to belong to the same group.
> 
> Instead we'd need to create a set-class, much like lockdep has and
> somehow ensure all locks in a set are of that class.

I'm a bit confused about the different classes you're talking about. Since
the ticket queue is currently a global counter there's only one class of
ww_mutexes. I guess we could change that once a second user shows up, but
currently with dma-bufs we _want_ all reservartion mutexes to be in the
same class. And if you nest reservation mutexe loops (i.e. nest calls to
acquire_start in your example below) we want that to fail. So currently we
only have one lockdep class for the mutexes plus one class for the virtual
lock everything nests in.

> One thing I'm not entirely sure of is the strict need for a local
> context it could be used to track the set-class, but I'm not entirely
> sure we need that to clean up state at the end marker. I haven't been
> creative enough to construct a fail case where both O and Y nest and a
> pending EDEADLK state could cross the end marker wrongly.
> 
> However, having a local context, even if empty, does put a few
> constraints on the API usage, which as per below, is a good thing.
> 
> To recap, we now have:
> 
>   struct ww_mutex_key { };
>   struct ww_mutex;
>   struct ww_mutex_ctx;
> 
>   void __ww_mutex_init(struct ww_mutex *, void *);
> 
>   #define ww_mutex_init(ww_mutex) 	 		\
>     do {					\
> 	static struct ww_mutex_key __key;		\
> 	__ww_mutex_init(ww_mutex, &__key);		\
>     } while (0)
> 
>   void ww_mutex_acquire_start(struct ww_mutex_ctx *);
>   void ww_mutex_acquire_end  (struct ww_mutex_ctx *);
> 
>   int  ww_mutex_lock(struct ww_mutex_ctx *, struct ww_mutex *);
>   void ww_mutex_unlock(struct ww_mutex *);
> 
> Which are to be used like:
> 
>   int bufs_lock(bufs)
>   {
> 	struct ww_mutex_ctx ww_ctx;
> 
> 	ww_mutex_acquire_start(&ww_ctx);
>   retry:
> 	for-all-buffers(buf, bufs) {
> 		err = ww_mutex_lock(&ww_ctx, &buf->lock);
> 		if (err)
> 			goto error;
> 	}
> 
> 	ww_mutex_acquire_end(&ww_ctx);
> 
> 	return 0; /* success */
> 
>   error:
> 	for-all-buffers(buf2, bufs) {
> 		if (buf2 == buf)
> 			break;
> 		ww_mutex_unlock(&buf->lock);
> 	}
> 	if (err == -EDEADLK)
> 		goto again;
> 
> 	return err; /* other error */
>   }
> 
>   void bufs_unlock(bufs)
>   {
> 	for-all-buffers(buf, bufs)
> 		ww_mutex_unlock(&buf->lock);
>   }
> 
> This API has a few problems as per Rusty's API guidelines, it is fairly
> trivial to use it wrong; mostly the placement of the start and end
> markers are easy to get wrong, but of course one can get all kinds of
> badness from doing the retry wrong. At least having the local context
> forces one to use the start/end markers.

I share your concerns about the api, it's way too easy to get wrong. But
with the lockdep nesting checks we should at least be covered for the
ordering in the fastpath. For the error paths themselves I've just thought
about ranodm -EAGAIN injection as a debug option. With that we should at
least be able to cover these paths sufficiently in regression test suites.

Would be a new patch for Maarten to write though ;-)

> The only remaining 'problem' left is RT, however the above suggests a
> very clean solution; change the lock queueing order to first sort on
> priority (be it the SCHED_FIFO/RR static priority or SCHED_DEADLINE
> dynamic priority) and secondly on the age. 
> 
> Note that (re)setting the age at every acquisition set is really only a
> means to provide FIFO fairness between tasks, RT tasks don't strictly
> require this, they have their own ordering.
> 
> With all that this locking scheme should be deterministic; and in cases
> where the older task would block (the young task has passed the end
> marker) we can apply PI and push Y's priority.

We've discussed this approach of using (rt-prio, age) instead of just age
to determine the the "oldness" of a task for deadlock-breaking with
-EAGAIN. The problem is that through PI boosting or normal rt-prio changes
while tasks are trying to acquire ww_mutexes you can create acyclic loops
in the blocked-on graph of ww_mutexes after the fact and so cause
deadlocks. So we've convinced ourselves that this approche doesn't work.

The only somewhat similar approache we couldn't poke holes into is to set
a PI-boost flag on the reservation ticket (your ww_ctx) of the task a
higher-prio RT thread is blocking on. Any task who has set that flag on
its ww_ctx would then unconditionally fail with -EAGAIN on the next
ww_mutex_lock. See my other mail from yesterday for some of the ideas
we've discussed about RT-compliant ww_mutexes on irc.

> Did I miss something?
> 
> Anyway, I haven't actually looked at the details of your implementation
> yet, I'll get to that next, but I think something like the above should
> be what we want to aim for.
> 
> *phew* thanks for reading this far ! :-)

Well, it was a good read and I'm rather happy that we agree on the ww_ctx
thing (whatever it's called in the end), even though we have slightly
different reasons for it.

I don't really have a useful idea to make the retry handling for users
more rusty-compliant though, and I'm still unhappy with all current naming
proposals ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
