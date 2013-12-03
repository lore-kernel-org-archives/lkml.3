Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3LCC7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:59:01 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34218 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LCC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:58:58 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
Date: Mon, 2 Dec 2013 18:58:57 -0800
X-Google-Sender-Auth: FdkZPwvZHNUQiA6bq7wa-1V4LrI
Message-ID: <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds())
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once more on this issue, because I've been unable to stop thinking
about it, and noticed that it's actually even subtler than I thought
initially.

On Mon, Dec 2, 2013 at 8:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> All our reference counting etc seems right, but we have one very
> subtle bug: on the freeing path, we have a pattern like this:
>
>         spin_lock(&inode->i_lock);
>         if (!--pipe->files) {
>                 inode->i_pipe = NULL;
>                 kill = 1;
>         }
>         spin_unlock(&inode->i_lock);
>         __pipe_unlock(pipe);
>         if (kill)
>                 free_pipe_info(pipe);
>
> which on the face of it is trying to be very careful in not accessing
> the pipe-info after it is released by having that "kill" flag, and
> doing the release last.
>
> And it's complete garbage.
>
> Why?
>
> Because the thread that decrements "pipe->files" *without* releasing
> it, will very much access it after it has been dropped: that
> "__pipe_unlock(pipe)" happens *after* we've decremented the pipe
> reference count and dropped the inode lock. So another CPU can come in
> and free the structure concurrently with that __pipe_unlock(pipe).

So I still think this was the bug, and the problems Simon and Ian saw
should be fixed, but it ends up being even more interesting than just
the above explanation.

Yes, the inode->i_lock is what protects the "pipe->files" counter, and
we do in fact on the allocation side have cases where we update the
counter with just the spinlock held, without holding the pipe mutex.
So when we decrement the 'files' counter and release the i_lock
spinlock, technically it's now freeable.

BUT.

It turns out that on the *releasing* side, the old code actually held
the pipe->mutex in all situations where it was decrementing the
pipe->files counter, so the race we saw happen *shouldn't* have
happened, because even though the i_lock spinlock was the real lock,
the pipe->mutex lock *should* have serialized the two threads
releasing the pipe, and thus the bug shouldn't have been visible.

So we have two threads serialized by that pipe->lock mutex, and yet
one of them writes to the structure *after* the other one (remember:
serialized!) decides that it can free it.

In other words: while the fix for pipes was simply to move the mutex
unlock up, this actually shows a big fundamental issue with mutexes.
That issue being that you cannot use them (at least as is) to protect
an object reference count. And I wonder if we do that somewhere else.

And I kind of knew about this, because we historically had very strict
rules about the whole "don't use semaphores to implement completions",
which has the exact same issue: a semaphore isn't "safe" wrt
de-allocation, and we have some places that use completions exactly
because completions guarantee that the very last access to them on the
waiter is on the waiter side (who can then free the memory), and all
other users are "safe".

And mutexes and semaphores don't have those guarantees: they just
serialize what is *inside* the mutex/semaphore, but not necessarily
the lock *ITSELF*.

So this "obviously correct" pattern is in fact fundamentally buggy:

   mutex_lock(obj->lock);
   dead = !--obj->recount;
   mutex_unlock(obj->lock);
   if (dead)
      free(obj);

even though it *looks* safe. Because by definition only the last
thread to get the object mutex will be the one freeing it, right?

Wrong. Because what can happen is (roughly):

    CPU1:

        mutex_lock(obj->lock);
        dead = !--obj->refcount;
        // refcount was 2, is now 1, dead = 0.

.. at this point CPU2 comes in, tries to do the same thing:

        mutex_lock(obj->lock);
        // blocks on obj->lock, goes to slowpath
        // mutex is negative, CPU2 is in optimistic
        //  spinning mode in __mutex_lock_common
        // under #ifdef CONFIG_MUTEX_SPIN_ON_OWNER

-- CPU1 again:

        mutex_unlock(obj->lock);
          __mutex_fastpath_unlock()
            fastpath fails (because mutex is nonpositive
              __mutex_unlock_slowpath:
                if (__mutex_slowpath_needs_to_unlock())
                        atomic_set(&lock->count, 1);

.. CPU2 - who is spinning, sees this, and does

                if ((atomic_read(&lock->count) == 1) &&
                    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {

.. and now CPU2 owns the mutex, and goes on to do

        dead = !--obj->refcount;
        // refcount was 1, is now 0, dead = 1.
        mutex_unlock(obj->lock);
        if (dead)
                free(obj);

 - but in the meantime, CPU1 is busy still unlocking:

                if (!list_empty(&lock->wait_list)) {
                        /* get the first entry from the wait-list: */
                        struct mutex_waiter *waiter =
                                        list_entry(lock->wait_list.next,
                                                   struct mutex_waiter, list);

                        debug_mutex_wake_waiter(lock, waiter);

                        wake_up_process(waiter->task);
        }
        spin_unlock_mutex(&lock->wait_lock, flags);

and in particular notice how CPU1 wrote to the lock *after* CPU2 had
gotten the lock and free'd the data structure. In practice, it's only
really that "spin_unlock_mutex(&lock->wait_lock, flags);" that happens
(and this is how we got the single byte being incremented).

In other words, it's unsafe to protect reference counts inside objects
with anything but spinlocks and/or atomic refcounts. Or you have to
have the lock *outside* the object you're protecting (which is often
what you want for other reasons anyway, notably lookup).

So having a non-atomic refcount protected inside a sleeping lock is a
bug, and that's really the bug that ended up biting us for pipes.

Now, the question is: do we have other such cases? How do we document
this? Do we try to make mutexes and other locks safe to use for things
like this?

              Linus
