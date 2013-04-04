Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3DDMCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:02:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51187
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759345Ab3DDMCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:02:04 -0400
Message-ID: <1365076908.2609.94.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        daniel.vetter@ffwll.ch, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 14:01:48 +0200
In-Reply-To: <1364921954.20640.22.camel@laptop>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sorry, this email ended up quite a bit longer than I had hoped for;
please bear with me.

On Tue, 2013-04-02 at 18:59 +0200, Peter Zijlstra wrote:
>   struct ww_mutex; /* wound/wait */
> 
>   int mutex_wound_lock(struct ww_mutex *); /* returns -EDEADLK */
>   int mutex_wait_lock(struct ww_mutex *);  /* does not fail */
> 
> Hmm.. thinking about that,.. you only need that second variant because
> you don't have a clear lock to wait for the 'older' process to
> complete; but having the unconditional wait makes the entire thing
> prone to accidents and deadlocks when the 'user' (read your fellow
> programmers) make a mistake.
> 
> Ideally we'd only have the one primitive that returns -EDEADLK and use
> a 'proper' mutex to wait on or somesuch.. let me ponder this a bit
> more.

So I had me a little ponder..

Its all really about breaking the symmetry (equivalence of both sides)
of the deadlock. Lets start with the simplest AB-BA deadlock:

	task-O	task-Y
	  A
		B
		A <-- blocks on O
	  B <-- blocks on Y

In this case the wound-wait algorithm says that the older task (O) has
precedence over the younger task (Y) and we'll 'kill' Y to allow
progress for O.

Now clearly we don't really want to kill Y, instead we'll allow its
lock operation to return -EDEADLK.

This would suggest that our 'new' mutex implementation (ww_mutex
henceforth) has owner tracking -- so O acquiring B can find Y to 'kill'
-- and that we have a new wakeup state TASK_DEADLOCK similar to
TASK_WAKEKILL (can we avoid this by using the extra state required
below? I don't think so since we'd have the risk of waking Y while it
would be blocked on a !ww_mutex)

Now this gets a little more interesting if we change the scenario a
little:

	task-O	task-Y
	  A
		B
	  B <-- blocks on Y
		* <-- could be A

In this case when O blocks Y isn't actually blocked, so our
TASK_DEADLOCK wakeup doesn't actually achieve anything.

This means we also have to track (task) state so that once Y tries to
acquire A (creating the actual deadlock) we'll not wait so our
TASK_DEADLOCK wakeup doesn't actually achieve anything.

Note that Y doesn't need to acquire A in order to return -EDEADLK, any
acquisition from the same set (see below) would return -EDEADLK even if
there isn't an actual deadlock. This is the cost of heuristic; we could
walk the actual block graph but that would be prohibitively expensive
since we'd have to do this on every acquire.

This raises the point of what would happen if Y were to acquire a
'regular' mutex in between the series of ww_mutexes. In this case we'd
clearly have an actual deadlock scenario. However lockdep would catch
this for we'd clearly invert the lock class order:

	ww_mutex -> other -> ww_mutex

For the more complex scenarios there's the case of multiple waiters. In
this case its desirable to order the waiters in age order so that we
don't introduce age inversion -- this minimizes the amount of -EDEADLK
occurrences, but also allows doing away with the unconditional wait.

With the lock queue ordering we can simply immediately re-try the lock
acquisition sequence. Since the older task is already queued it will
obtain the lock, even if we re-queue ourselves before the lock is
assigned.

Now the one thing I've so far 'ignored' is how to assign age. Forward
progress guarantees demand that the age doesn't get reset on retries;
doing so would mean you're always pushing yourself fwd, decreasing your
'priority', never getting to be the most eligible. However it also
means that we should (re)set the time every time we start a 'new'
acquisition sequence. If we'd use a static (per task) age the task with
the lowest age would be able to 'starve' all other.

This means we need means to mark the start of an acquisition sequence;
one that is not included in the restart loop.

Having a start suggests having an end marker too, and indeed we can
find a reason for having one; suppose our second scenario above, where
Y has already acquired all locks it needs to proceed. In this case we
would have marked Y to fail on another acquisition. This doesn't seem
like a problem until you consider the case where we nest different
mm_mutex sets. In this case Y would -EDEADLK on the first of the second
(nested) set, even though re-trying that set is pointless, O doesn't
care.

Furthermore, considering the first scenario, O could block on a lock of
the first set when Y is blocked on a lock of the second (nested) set;
we need means of discerning the different lock sets. This cannot be
done by local means, that is, any context created by the start/end
markers would be local to that task and would not be recognizable by
another as to belong to the same group.

Instead we'd need to create a set-class, much like lockdep has and
somehow ensure all locks in a set are of that class.

One thing I'm not entirely sure of is the strict need for a local
context it could be used to track the set-class, but I'm not entirely
sure we need that to clean up state at the end marker. I haven't been
creative enough to construct a fail case where both O and Y nest and a
pending EDEADLK state could cross the end marker wrongly.

However, having a local context, even if empty, does put a few
constraints on the API usage, which as per below, is a good thing.

To recap, we now have:

  struct ww_mutex_key { };
  struct ww_mutex;
  struct ww_mutex_ctx;

  void __ww_mutex_init(struct ww_mutex *, void *);

  #define ww_mutex_init(ww_mutex) 	 		\
    do {					\
	static struct ww_mutex_key __key;		\
	__ww_mutex_init(ww_mutex, &__key);		\
    } while (0)

  void ww_mutex_acquire_start(struct ww_mutex_ctx *);
  void ww_mutex_acquire_end  (struct ww_mutex_ctx *);

  int  ww_mutex_lock(struct ww_mutex_ctx *, struct ww_mutex *);
  void ww_mutex_unlock(struct ww_mutex *);

Which are to be used like:

  int bufs_lock(bufs)
  {
	struct ww_mutex_ctx ww_ctx;

	ww_mutex_acquire_start(&ww_ctx);
  retry:
	for-all-buffers(buf, bufs) {
		err = ww_mutex_lock(&ww_ctx, &buf->lock);
		if (err)
			goto error;
	}

	ww_mutex_acquire_end(&ww_ctx);

	return 0; /* success */

  error:
	for-all-buffers(buf2, bufs) {
		if (buf2 == buf)
			break;
		ww_mutex_unlock(&buf->lock);
	}
	if (err == -EDEADLK)
		goto again;

	return err; /* other error */
  }

  void bufs_unlock(bufs)
  {
	for-all-buffers(buf, bufs)
		ww_mutex_unlock(&buf->lock);
  }

This API has a few problems as per Rusty's API guidelines, it is fairly
trivial to use it wrong; mostly the placement of the start and end
markers are easy to get wrong, but of course one can get all kinds of
badness from doing the retry wrong. At least having the local context
forces one to use the start/end markers.

The only remaining 'problem' left is RT, however the above suggests a
very clean solution; change the lock queueing order to first sort on
priority (be it the SCHED_FIFO/RR static priority or SCHED_DEADLINE
dynamic priority) and secondly on the age. 

Note that (re)setting the age at every acquisition set is really only a
means to provide FIFO fairness between tasks, RT tasks don't strictly
require this, they have their own ordering.

With all that this locking scheme should be deterministic; and in cases
where the older task would block (the young task has passed the end
marker) we can apply PI and push Y's priority.


Did I miss something?

Anyway, I haven't actually looked at the details of your implementation
yet, I'll get to that next, but I think something like the above should
be what we want to aim for.

*phew* thanks for reading this far ! :-)

