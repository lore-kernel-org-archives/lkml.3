Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3A3BMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:12:45 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61458 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3A3BMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:12:42 -0500
MIME-Version: 1.0
In-Reply-To: <1358253244-11453-3-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-3-git-send-email-maarten.lankhorst@canonical.com>
Date: Tue, 29 Jan 2013 19:07:15 -0600
Message-ID: <CAF6AEGv2XqJB49Q-6BUtU80qMZx9tXHuwTV0Ds6c7L1J+4xwBw@mail.gmail.com>
Subject: Re: [PATCH 2/7] mutex: add support for reservation style locks
From: Rob Clark <robdclark@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 6:33 AM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
>

Hi Maarten,

This is a nice looking extension to avoid re-implementing a mutex in
TTM/reservation code..  ofc, probably someone more familiar with mutex
code should probably review, but probably a bit of explanation about
what and why would be helpful.

> mutex_reserve_lock, and mutex_reserve_lock_interruptible:
>   Lock a buffer with a reservation_id set. reservation_id must not be set to 0,
>   since this is a special value that means no reservation_id.
>
>   Normally if reservation_id is not set, or is older than the reservation_id that's
>   currently set on the mutex, the behavior will be to wait normally.
>
>   However, if  the reservation_id is newer than the current reservation_id, -EAGAIN
>   will be returned, and this function must unreserve all other mutexes and then redo
>   a blocking lock with normal mutex calls to prevent a deadlock, then call
>   mutex_locked_set_reservation on successful locking to set the reservation_id inside
>   the lock.

It might be a bit more clear to write up how this works from the
perspective of the user of ticket_mutex, separately from the internal
implementation first, and then how it works internally?  Ie, the
mutex_set_reservation_fastpath() call is internal to the
implementation of ticket_mutex, but -EAGAIN is something the caller of
ticket_mutex shall deal with.  This might give a clearer picture of
how TTM / reservation uses this to prevent deadlock, so those less
familiar with TTM could better understand.

Well, here is an attempt to start a write-up, which should perhaps
eventually be folded into Documentation/ticket-mutex-design.txt.  But
hopefully a better explanation of the problem and the solution will
encourage some review of the ticket_mutex changes.

==========================
Basic problem statement:
----- ------- ---------
GPU's do operations that commonly involve many buffers.  Those buffers
can be shared across contexts/processes, exist in different memory
domains (for example VRAM vs system memory), and so on.  And with
PRIME / dmabuf, they can even be shared across devices.  So there are
a handful of situations where the driver needs to wait for buffers to
become ready.  If you think about this in terms of waiting on a buffer
mutex for it to become available, this presents a problem because
there is no way to guarantee that buffers appear in a execbuf/batch in
the same order in all contexts.  That is directly under control of
userspace, and a result of the sequence of GL calls that an
application makes.  Which results in the potential for deadlock.  The
problem gets more complex when you consider that the kernel may need
to migrate the buffer(s) into VRAM before the GPU operates on the
buffer(s), which main in turn require evicting some other buffers (and
you don't want to evict other buffers which are already queued up to
the GPU), but for a simplified understanding of the problem you can
ignore this.

The algorithm that TTM came up with for dealing with this problem is
quite simple.  For each group of buffers (execbuf) that need to be
locked, the caller would be assigned a unique reservation_id, from a
global counter.  In case of deadlock in the process of locking all the
buffers associated with a execbuf, the one with the lowest
reservation_id wins, and the one with the higher reservation_id
unlocks all of the buffers that it has already locked, and then tries
again.

Originally TTM implemented this algorithm on top of an event-queue and
atomic-ops, but Maarten Lankhorst realized that by merging this with
the mutex code we could take advantage of the existing mutex fast-path
code and result in a simpler solution, and so ticket_mutex was born.
(Well, there where also some additional complexities with the original
implementation when you start adding in cross-device buffer sharing
for PRIME.. Maarten could probably better explain.)

How it is used:
--- -- -- -----

A very simplified version:

  int submit_execbuf(execbuf)
  {
      /* acquiring locks, before queuing up to GPU: */
      seqno = assign_global_seqno();
  retry:
      for (buf in execbuf->buffers) {
          ret = mutex_reserve_lock(&buf->lock, seqno);
          switch (ret) {
          case 0:
              /* we got the lock */
              break;
          case -EAGAIN:
              /* someone with a lower seqno, so unreserve and try again: */
              for (buf2 in reverse order starting before buf in
execbuf->buffers)
                  mutex_unreserve_unlock(&buf2->lock);
              goto retry;
          default:
              goto err;
          }
      }

      /* now everything is good to go, submit job to GPU: */
      ...
  }

  int finish_execbuf(execbuf)
  {
      /* when GPU is finished: */
      for (buf in execbuf->buffers)
          mutex_unreserve_unlock(&buf->lock);
  }
==========================

anyways, for the rest of the patch, I'm still going through the
mutex/ticket_mutex code in conjunction with the reservation/fence
patches, so for now just a couple very superficial comments.

>   These functions will return -EDEADLK instead of -EAGAIN if reservation_id is the same
>   as the reservation_id that's attempted to lock the mutex with, since in that case you
>   presumably attempted to lock the same lock twice.
>
> mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>   Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN. This is useful
>   after mutex_reserve_lock failed with -EAGAIN, and you unreserved all buffers so no
>   deadlock can occur.
>
> mutex_unreserve_unlock:
>    Unlock a buffer reserved with the previous calls.
>
> Missing at the moment, maybe TODO?
>   * lockdep warnings when wrongly calling mutex_unreserve_unlock or mutex_unlock,
>     depending on whether reservation_id was set previously or not.
>     - Does lockdep have something for this or do I need to extend struct mutex?
>
>   * Check if lockdep warns if you unlock a lock that other locks were nested to.
>     - spin_lock(m); spin_lock_nest_lock(a, m); spin_unlock(m); spin_unlock(a);
>       would be nice if it gave a splat. Have to recheck if it does, though..
>
> Design:
>   I chose for ticket_mutex to encapsulate struct mutex, so the extra memory usage and
>   atomic set on init will only happen when you deliberately create a ticket lock.
>
>   Since the mutexes are mostly meant to protect buffer object serialization in ttm, not
>   much contention is expected. I could be slightly smarter with wakeups, but this would
>   be at the expense at adding a field to struct mutex_waiter. Because this would add
>   overhead to all cases where ticket_mutexes are not used, and ticket_mutexes are less
>   performance sensitive anyway since they only protect buffer objects, I didn't want to
>   do this. It's still better than ttm always calling wake_up_all, which does a
>   unconditional spin_lock_irqsave/irqrestore.
>
>   I needed this in kernel/mutex.c because of the extensions to __lock_common, which are
>   hopefully optimized away for all normal paths.
>
> Changes since RFC patch v1:
>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>  - removed mutex_locked_set_reservation_id (or w/e it was called)
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  include/linux/mutex.h |  86 +++++++++++++-
>  kernel/mutex.c        | 317 +++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 387 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 9121595..602c247 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -62,6 +62,11 @@ struct mutex {
>  #endif
>  };
>
> +struct ticket_mutex {
> +       struct mutex base;
> +       atomic_long_t reservation_id;
> +};
> +
>  /*
>   * This is the control structure for tasks blocked on mutex,
>   * which resides on the blocked task's kernel stack:
> @@ -109,12 +114,24 @@ static inline void mutex_destroy(struct mutex *lock) {}
>                 __DEBUG_MUTEX_INITIALIZER(lockname) \
>                 __DEP_MAP_MUTEX_INITIALIZER(lockname) }
>
> +#define __TICKET_MUTEX_INITIALIZER(lockname) \
> +               { .base = __MUTEX_INITIALIZER(lockname) \
> +               , .reservation_id = ATOMIC_LONG_INIT(0) }
> +
>  #define DEFINE_MUTEX(mutexname) \
>         struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
>
>  extern void __mutex_init(struct mutex *lock, const char *name,
>                          struct lock_class_key *key);
>
> +static inline void __ticket_mutex_init(struct ticket_mutex *lock,
> +                                      const char *name,
> +                                      struct lock_class_key *key)
> +{
> +       __mutex_init(&lock->base, name, key);
> +       atomic_long_set(&lock->reservation_id, 0);
> +}
> +
>  /**
>   * mutex_is_locked - is the mutex locked
>   * @lock: the mutex to be queried
> @@ -133,26 +150,91 @@ static inline int mutex_is_locked(struct mutex *lock)
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
>  extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
> +
>  extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
>                                         unsigned int subclass);
>  extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
>                                         unsigned int subclass);
>
> +extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
> +                                       struct lockdep_map *nest_lock,
> +                                       unsigned long reservation_id);
> +
> +extern int __must_check _mutex_reserve_lock_interruptible(struct ticket_mutex *,
> +                                       struct lockdep_map *nest_lock,
> +                                       unsigned long reservation_id);
> +
> +extern void _mutex_reserve_lock_slow(struct ticket_mutex *lock,
> +                                    struct lockdep_map *nest_lock,
> +                                    unsigned long reservation_id);
> +
> +extern int __must_check _mutex_reserve_lock_intr_slow(struct ticket_mutex *,
> +                                       struct lockdep_map *nest_lock,
> +                                       unsigned long reservation_id);
> +
>  #define mutex_lock(lock) mutex_lock_nested(lock, 0)
>  #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
>  #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
>
>  #define mutex_lock_nest_lock(lock, nest_lock)                          \
>  do {                                                                   \
> -       typecheck(struct lockdep_map *, &(nest_lock)->dep_map);         \
> +       typecheck(struct lockdep_map *, &(nest_lock)->dep_map); \

looks like that was unintended whitespace change..`

>         _mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);             \
>  } while (0)
>
> +#define mutex_reserve_lock(lock, nest_lock, reservation_id)            \
> +({                                                                     \
> +       typecheck(struct lockdep_map *, &(nest_lock)->dep_map); \
> +       _mutex_reserve_lock(lock, &(nest_lock)->dep_map, reservation_id);       \
> +})
> +
> +#define mutex_reserve_lock_interruptible(lock, nest_lock, reservation_id)      \
> +({                                                                     \
> +       typecheck(struct lockdep_map *, &(nest_lock)->dep_map); \
> +       _mutex_reserve_lock_interruptible(lock, &(nest_lock)->dep_map,  \
> +                                          reservation_id);             \
> +})
> +
> +#define mutex_reserve_lock_slow(lock, nest_lock, reservation_id)       \
> +do {                                                                   \
> +       typecheck(struct lockdep_map *, &(nest_lock)->dep_map); \
> +       _mutex_reserve_lock_slow(lock, &(nest_lock)->dep_map, reservation_id);  \
> +} while (0)
> +
> +#define mutex_reserve_lock_intr_slow(lock, nest_lock, reservation_id)  \
> +({                                                                     \
> +       typecheck(struct lockdep_map *, &(nest_lock)->dep_map); \
> +       _mutex_reserve_lock_intr_slow(lock, &(nest_lock)->dep_map,      \
> +                                     reservation_id);                  \
> +})
> +
>  #else
>  extern void mutex_lock(struct mutex *lock);
>  extern int __must_check mutex_lock_interruptible(struct mutex *lock);
>  extern int __must_check mutex_lock_killable(struct mutex *lock);
>
> +extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
> +                                           unsigned long reservation_id);
> +extern int __must_check _mutex_reserve_lock_interruptible(struct ticket_mutex *,
> +                                               unsigned long reservation_id);
> +
> +extern void _mutex_reserve_lock_slow(struct ticket_mutex *lock,
> +                                    unsigned long reservation_id);
> +extern int __must_check _mutex_reserve_lock_intr_slow(struct ticket_mutex *,
> +                                               unsigned long reservation_id);
> +
> +#define mutex_reserve_lock(lock, nest_lock, reservation_id)            \
> +       _mutex_reserve_lock(lock, reservation_id)
> +
> +#define mutex_reserve_lock_interruptible(lock, nest_lock, reservation_id)      \
> +       _mutex_reserve_lock_interruptible(lock, reservation_id)
> +
> +#define mutex_reserve_lock_slow(lock, nest_lock, reservation_id)       \
> +       _mutex_reserve_lock_slow(lock, reservation_id)
> +
> +#define mutex_reserve_lock_intr_slow(lock, nest_lock, reservation_id)  \
> +       _mutex_reserve_lock_intr_slow(lock, reservation_id)
> +
>  # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
>  # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
>  # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
> @@ -167,6 +249,8 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
>   */
>  extern int mutex_trylock(struct mutex *lock);
>  extern void mutex_unlock(struct mutex *lock);
> +extern void mutex_unreserve_unlock(struct ticket_mutex *lock);
> +
>  extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
>
>  #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a307cc9..8282729 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -126,16 +126,119 @@ void __sched mutex_unlock(struct mutex *lock)
>
>  EXPORT_SYMBOL(mutex_unlock);
>
> +/**
> + * mutex_unreserve_unlock - release the mutex
> + * @lock: the mutex to be released
> + *
> + * Unlock a mutex that has been locked by this task previously
> + * with _mutex_reserve_lock*.
> + *
> + * This function must not be used in interrupt context. Unlocking
> + * of a not locked mutex is not allowed.
> + */
> +void __sched mutex_unreserve_unlock(struct ticket_mutex *lock)
> +{
> +       /*
> +        * mark mutex as no longer part of a reservation, next
> +        * locker can set this again
> +        */
> +       atomic_long_set(&lock->reservation_id, 0);
> +
> +       /*
> +        * The unlocking fastpath is the 0->1 transition from 'locked'
> +        * into 'unlocked' state:
> +        */
> +#ifndef CONFIG_DEBUG_MUTEXES
> +       /*
> +        * When debugging is enabled we must not clear the owner before time,
> +        * the slow path will always be taken, and that clears the owner field
> +        * after verifying that it was indeed current.
> +        */
> +       mutex_clear_owner(&lock->base);
> +#endif
> +       __mutex_fastpath_unlock(&lock->base.count, __mutex_unlock_slowpath);
> +}
> +EXPORT_SYMBOL(mutex_unreserve_unlock);
> +
> +static inline int __sched
> +__mutex_lock_check_reserve(struct mutex *lock, unsigned long reservation_id)
> +{
> +       struct ticket_mutex *m = container_of(lock, struct ticket_mutex, base);
> +       unsigned long cur_id;
> +
> +       cur_id = atomic_long_read(&m->reservation_id);
> +       if (!cur_id)
> +               return 0;
> +
> +       if (unlikely(reservation_id == cur_id))
> +               return -EDEADLK;
> +
> +       if (unlikely(reservation_id - cur_id <= LONG_MAX))
> +               return -EAGAIN;
> +
> +       return 0;
> +}
> +
> +/*
> + * after acquiring lock with fastpath or when we lost out in contested
> + * slowpath, set reservation_id and wake up any waiters so they can recheck.
> + */

I think that is a bit misleading, if I'm understanding correctly this
is called once you get the lock (but in either fast or slow path)

> +static __always_inline void
> +mutex_set_reservation_fastpath(struct ticket_mutex *lock,
> +                              unsigned long reservation_id, bool check_res)
> +{
> +       unsigned long flags;
> +       struct mutex_waiter *cur;
> +
> +       if (check_res || config_enabled(CONFIG_DEBUG_LOCK_ALLOC)) {
> +               unsigned long cur_id;
> +
> +               cur_id = atomic_long_xchg(&lock->reservation_id,
> +                                         reservation_id);
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +               if (check_res)
> +                       DEBUG_LOCKS_WARN_ON(cur_id &&
> +                                          cur_id != reservation_id);
> +               else
> +                       DEBUG_LOCKS_WARN_ON(cur_id);
> +               lockdep_assert_held(&lock->base);
> +#endif
> +
> +               if (unlikely(cur_id == reservation_id))
> +                       return;
> +       } else
> +               atomic_long_set(&lock->reservation_id, reservation_id);
> +
> +       /*
> +        * Check if lock is contended, if not there is nobody to wake up
> +        */
> +       if (likely(atomic_read(&lock->base.count) == 0))
> +               return;
> +
> +       /*
> +        * Uh oh, we raced in fastpath, wake up everyone in this case,
> +        * so they can see the new reservation_id
> +        */
> +       spin_lock_mutex(&lock->base.wait_lock, flags);
> +       list_for_each_entry(cur, &lock->base.wait_list, list) {
> +               debug_mutex_wake_waiter(&lock->base, cur);
> +               wake_up_process(cur->task);
> +       }
> +       spin_unlock_mutex(&lock->base.wait_lock, flags);
> +}
> +
>  /*
>   * Lock a mutex (possibly interruptible), slowpath:
>   */
>  static inline int __sched
>  __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> -                   struct lockdep_map *nest_lock, unsigned long ip)
> +                   struct lockdep_map *nest_lock, unsigned long ip,
> +                   unsigned long reservation_id, bool res_slow)
>  {
>         struct task_struct *task = current;
>         struct mutex_waiter waiter;
>         unsigned long flags;
> +       int ret;
>
>         preempt_disable();
>         mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
> @@ -162,6 +265,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>         for (;;) {
>                 struct task_struct *owner;
>
> +               if (!__builtin_constant_p(reservation_id) && !res_slow) {
> +                       ret = __mutex_lock_check_reserve(lock, reservation_id);
> +                       if (ret)
> +                               goto err_nowait;
> +               }
> +
>                 /*
>                  * If there's an owner, wait for it to either
>                  * release the lock or go to sleep.
> @@ -172,6 +281,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>
>                 if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
>                         lock_acquired(&lock->dep_map, ip);
> +                       if (res_slow) {
> +                               struct ticket_mutex *m;
> +                               m = container_of(lock, struct ticket_mutex, base);
> +
> +                               mutex_set_reservation_fastpath(m, reservation_id, false);
> +                       }
> +
>                         mutex_set_owner(lock);
>                         preempt_enable();
>                         return 0;
> @@ -227,15 +343,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>                  * TASK_UNINTERRUPTIBLE case.)
>                  */
>                 if (unlikely(signal_pending_state(state, task))) {
> -                       mutex_remove_waiter(lock, &waiter,
> -                                           task_thread_info(task));
> -                       mutex_release(&lock->dep_map, 1, ip);
> -                       spin_unlock_mutex(&lock->wait_lock, flags);
> +                       ret = -EINTR;
> +                       goto err;
> +               }
>
> -                       debug_mutex_free_waiter(&waiter);
> -                       preempt_enable();
> -                       return -EINTR;
> +               if (!__builtin_constant_p(reservation_id) && !res_slow) {
> +                       ret = __mutex_lock_check_reserve(lock, reservation_id);
> +                       if (ret)
> +                               goto err;
>                 }
> +
>                 __set_task_state(task, state);
>
>                 /* didn't get the lock, go to sleep: */
> @@ -250,6 +367,28 @@ done:
>         mutex_remove_waiter(lock, &waiter, current_thread_info());
>         mutex_set_owner(lock);
>
> +       if (!__builtin_constant_p(reservation_id)) {
> +               struct ticket_mutex *m;
> +               struct mutex_waiter *cur;
> +               /*
> +                * this should get optimized out for the common case,
> +                * and is only important for _mutex_reserve_lock
> +                */
> +
> +               m = container_of(lock, struct ticket_mutex, base);
> +               atomic_long_set(&m->reservation_id, reservation_id);
> +
> +               /*
> +                * give any possible sleeping processes the chance to wake up,
> +                * so they can recheck if they have to back off from
> +                * reservations
> +                */
> +               list_for_each_entry(cur, &lock->wait_list, list) {
> +                       debug_mutex_wake_waiter(lock, cur);
> +                       wake_up_process(cur->task);
> +               }
> +       }
> +
>         /* set it to 0 if there are no waiters left: */
>         if (likely(list_empty(&lock->wait_list)))
>                 atomic_set(&lock->count, 0);
> @@ -260,6 +399,19 @@ done:
>         preempt_enable();
>
>         return 0;
> +
> +err:
> +       mutex_remove_waiter(lock, &waiter, task_thread_info(task));
> +       spin_unlock_mutex(&lock->wait_lock, flags);
> +       debug_mutex_free_waiter(&waiter);
> +
> +#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
> +err_nowait:
> +#endif
> +       mutex_release(&lock->dep_map, 1, ip);
> +
> +       preempt_enable();
> +       return ret;
>  }
>
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> @@ -267,7 +419,8 @@ void __sched
>  mutex_lock_nested(struct mutex *lock, unsigned int subclass)
>  {
>         might_sleep();
> -       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
> +       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> +                           subclass, NULL, _RET_IP_, 0, 0);
>  }
>
>  EXPORT_SYMBOL_GPL(mutex_lock_nested);
> @@ -276,7 +429,8 @@ void __sched
>  _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
>  {
>         might_sleep();
> -       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
> +       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> +                           0, nest, _RET_IP_, 0, 0);
>  }
>
>  EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
> @@ -285,7 +439,8 @@ int __sched
>  mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
>  {
>         might_sleep();
> -       return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
> +       return __mutex_lock_common(lock, TASK_KILLABLE,
> +                                  subclass, NULL, _RET_IP_, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
>
> @@ -294,10 +449,63 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
>  {
>         might_sleep();
>         return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
> -                                  subclass, NULL, _RET_IP_);
> +                                  subclass, NULL, _RET_IP_, 0, 0);
>  }
>
>  EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
> +
> +int __sched
> +_mutex_reserve_lock(struct ticket_mutex *lock, struct lockdep_map *nest,
> +                   unsigned long reservation_id)
> +{
> +       DEBUG_LOCKS_WARN_ON(!reservation_id);
> +
> +       might_sleep();
> +       return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
> +                                  0, nest, _RET_IP_, reservation_id, 0);
> +}
> +EXPORT_SYMBOL_GPL(_mutex_reserve_lock);
> +
> +
> +int __sched
> +_mutex_reserve_lock_interruptible(struct ticket_mutex *lock,
> +                                 struct lockdep_map *nest,
> +                                 unsigned long reservation_id)
> +{
> +       DEBUG_LOCKS_WARN_ON(!reservation_id);
> +
> +       might_sleep();
> +       return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
> +                                  0, nest, _RET_IP_, reservation_id, 0);
> +}
> +EXPORT_SYMBOL_GPL(_mutex_reserve_lock_interruptible);
> +
> +void __sched
> +_mutex_reserve_lock_slow(struct ticket_mutex *lock, struct lockdep_map *nest,
> +                        unsigned long reservation_id)
> +{
> +       DEBUG_LOCKS_WARN_ON(!reservation_id);
> +
> +       might_sleep();
> +       __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
> +                           nest, _RET_IP_, reservation_id, 1);
> +}
> +EXPORT_SYMBOL_GPL(_mutex_reserve_lock_slow);
> +
> +int __sched
> +_mutex_reserve_lock_intr_slow(struct ticket_mutex *lock,
> +                             struct lockdep_map *nest,
> +                             unsigned long reservation_id)
> +{
> +       DEBUG_LOCKS_WARN_ON(!reservation_id);
> +
> +       might_sleep();
> +       return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
> +                                  nest, _RET_IP_, reservation_id, 1);
> +}
> +EXPORT_SYMBOL_GPL(_mutex_reserve_lock_intr_slow);
> +
> +
>  #endif
>
>  /*
> @@ -400,7 +608,8 @@ __mutex_lock_slowpath(atomic_t *lock_count)
>  {
>         struct mutex *lock = container_of(lock_count, struct mutex, count);
>
> -       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
> +       __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
> +                           NULL, _RET_IP_, 0, 0);
>  }
>
>  static noinline int __sched
> @@ -408,7 +617,8 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count)
>  {
>         struct mutex *lock = container_of(lock_count, struct mutex, count);
>
> -       return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
> +       return __mutex_lock_common(lock, TASK_KILLABLE, 0,
> +                                  NULL, _RET_IP_, 0, 0);
>  }
>
>  static noinline int __sched
> @@ -416,8 +626,28 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
>  {
>         struct mutex *lock = container_of(lock_count, struct mutex, count);
>
> -       return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
> +       return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
> +                                  NULL, _RET_IP_, 0, 0);
> +}
> +
> +static noinline int __sched
> +__mutex_lock_reserve_slowpath(atomic_t *lock_count, void *rid)
> +{
> +       struct mutex *lock = container_of(lock_count, struct mutex, count);
> +
> +       return __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
> +                                  NULL, _RET_IP_, (unsigned long)rid, 0);
> +}
> +
> +static noinline int __sched
> +__mutex_lock_interruptible_reserve_slowpath(atomic_t *lock_count, void *rid)
> +{
> +       struct mutex *lock = container_of(lock_count, struct mutex, count);
> +
> +       return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
> +                                  NULL, _RET_IP_, (unsigned long)rid, 0);
>  }
> +
>  #endif
>
>  /*
> @@ -473,6 +703,63 @@ int __sched mutex_trylock(struct mutex *lock)
>  }
>  EXPORT_SYMBOL(mutex_trylock);
>
> +#ifndef CONFIG_DEBUG_LOCK_ALLOC
> +int __sched
> +_mutex_reserve_lock(struct ticket_mutex *lock, unsigned long rid)
> +{
> +       int ret;
> +
> +       might_sleep();
> +
> +       ret = __mutex_fastpath_lock_retval_arg(&lock->base.count, (void *)rid,
> +                                       __mutex_lock_reserve_slowpath);
> +
> +       if (!ret) {
> +               mutex_set_reservation_fastpath(lock, rid, true);
> +               mutex_set_owner(&lock->base);
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL(_mutex_reserve_lock);
> +
> +int __sched
> +_mutex_reserve_lock_interruptible(struct ticket_mutex *lock, unsigned long rid)
> +{
> +       int ret;
> +
> +       might_sleep();
> +
> +       ret = __mutex_fastpath_lock_retval_arg(&lock->base.count, (void *)rid,
> +                               __mutex_lock_interruptible_reserve_slowpath);
> +
> +       if (!ret) {
> +               mutex_set_reservation_fastpath(lock, rid, true);
> +               mutex_set_owner(&lock->base);
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL(_mutex_reserve_lock_interruptible);
> +
> +void __sched
> +_mutex_reserve_lock_slow(struct ticket_mutex *lock, unsigned long rid)
> +{
> +       might_sleep();
> +       __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
> +                           0, NULL, _RET_IP_, rid, 1);
> +}
> +EXPORT_SYMBOL(_mutex_reserve_lock_slow);
> +
> +int __sched
> +_mutex_reserve_lock_intr_slow(struct ticket_mutex *lock, unsigned long rid)
> +{
> +       might_sleep();
> +       return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
> +                                  0, NULL, _RET_IP_, rid, 1);
> +}
> +EXPORT_SYMBOL(_mutex_reserve_lock_intr_slow);
> +
> +#endif
> +
>  /**
>   * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
>   * @cnt: the atomic which we are to dec
> --
> 1.8.0.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
