Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3CVBjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:39:40 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:58154 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab3CVBjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130321115259.GA17883@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
Date: Thu, 21 Mar 2013 18:39:38 -0700
Message-ID: <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 4:52 AM, Eric Wong <normalperson@yhbt.net> wrote:
> This is still not a proper commit, I've lightly tested this.
>
> Replace the spinlock-protected linked list ready list with wfcqueue.
>
> This improves performance under heavy, multi-threaded workloads with
> multiple threads calling epoll_wait.
>
> Using my multi-threaded EPOLLONESHOT microbenchmark, performance is
> nearly doubled:
>
> $ eponeshotmt -t 4 -w 4 -f 10 -c 1000000
>
> Before:
> real    0m 9.58s
> user    0m 1.22s
> sys     0m 37.08s
>
> After:
> real    0m 5.00s
> user    0m 1.07s
> sys     0m 18.92s
>
> ref: http://yhbt.net/eponeshotmt.c
>
> Unfortunately, there are still regressions for the common,
> single threaded, Level Trigger use case.
>
> Things changed/removed:
>
> * ep->ovflist - is no longer needed, the main ready list continues
>   to be appended to while we iterate through the transaction list.
>
> * ep_scan_ready_list - not enough generic code between users
>   anymore to warrant this.  ep_poll_readyevents_proc (used for
>   poll) is read-only, using __wfcq_for_each, while
>   ep_send_events (used for epoll_wait) dequeues and needs
>   __wfcq_for_each_safe.
>
> * ep->lock renamed to ep->wqlock; this only protects waitqueues now
>   (we use trylock to further avoid redundant wakeups)
>
> * EPOLL_CTL_DEL/close() on a ready file will not immediately release
>   epitem memory, epoll_wait() must be called since there's no way to
>   delete a ready item from wfcqueue in O(1) time.  In practice this
>   should not be a problem, any valid app using epoll must call
>   epoll_wait occasionally.  Unfreed epitems still count against
>   max_user_watches to protect against local DoS.  This should be the
>   only possibly-noticeable change (in case there's an app that blindly
>   adds/deletes things from the rbtree but never calls epoll_wait)
>
> Changes since v1:
> * fixed memory leak with pre-existing zombies in ep_free
> * updated to use the latest wfcqueue.h APIs
> * switched to using __wfcq_splice and a global transaction list
>   (this is like the old txlist in ep_scan_ready_list)
> * redundant wakeups avoided in ep_notify_waiters:
>   - only attempt a wakeup when an item is enqueued the first time
>   - use spin_trylock_irqsave when attempting notification, since a
>     failed lock means either another task is already waking, or
>     ep_poll is already running and will check anyways upon releasing
>     wqlock, anyways.
> * explicitly cache-aligned rdltail in SMP
> * added ep_item_state for atomically reading epi->state with barrier
>   (avoids WARN_ON in ep_send_events)
> * reverted epi->nwait removal, it was not necessary
>   sizeof(epitem) is still <= 128 bytes on 64-bit machines
>
> Changes since v2:
> * epi->state is no longer atomic, we only cmpxchg in ep_poll_callback
>   now and rely on implicit barriers in other places for reading.
> * intermediate EP_STATE_DEQUEUE removed, this (with xchg) caused too
>   much overhead in the ep_send_events loop and could not eliminate
>   starvation dangers from improper EPOLLET usage (the original code
>   had this problem, too, the window is just a few cycles larger, now).
> * minor code cleanups
>
> Lightly-tested-by: Eric Wong <normalperson@yhbt.net>
> Cc: Davide Libenzi <davidel@xmailserver.org>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>
...
> @@ -967,8 +951,6 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
>   */
>  static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
> -       int pwake = 0;
> -       unsigned long flags;
>         struct epitem *epi = ep_item_from_wait(wait);
>         struct eventpoll *ep = epi->ep;
>
> @@ -983,7 +965,8 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>                 list_del_init(&wait->task_list);
>         }
>
> -       spin_lock_irqsave(&ep->lock, flags);
> +       /* pairs with smp_mb in ep_modify */
> +       smp_rmb();
>
>         /*
>          * If the event mask does not contain any poll(2) event, we consider the
> @@ -992,7 +975,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>          * until the next EPOLL_CTL_MOD will be issued.
>          */
>         if (!(epi->event.events & ~EP_PRIVATE_BITS))
> -               goto out_unlock;
> +               return 1;
>
>         /*
>          * Check the events coming with the callback. At this stage, not
> @@ -1001,52 +984,14 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>          * test for "key" != NULL before the event match test.
>          */
>         if (key && !((unsigned long) key & epi->event.events))
> -               goto out_unlock;
> -
> -       /*
> -        * If we are transferring events to userspace, we can hold no locks
> -        * (because we're accessing user memory, and because of linux f_op->poll()
> -        * semantics). All the events that happen during that period of time are
> -        * chained in ep->ovflist and requeued later on.
> -        */
> -       if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
> -               if (epi->next == EP_UNACTIVE_PTR) {
> -                       epi->next = ep->ovflist;
> -                       ep->ovflist = epi;
> -                       if (epi->ws) {
> -                               /*
> -                                * Activate ep->ws since epi->ws may get
> -                                * deactivated at any time.
> -                                */
> -                               __pm_stay_awake(ep->ws);
> -                       }
> +               return 1;
>
> -               }
> -               goto out_unlock;
> -       }
> -
> -       /* If this file is already in the ready list we exit soon */
> -       if (!ep_is_linked(&epi->rdllink)) {
> -               list_add_tail(&epi->rdllink, &ep->rdllist);
> +       if (ep_mark_ready(epi)) {
> +               wfcq_enqueue(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
>                 ep_pm_stay_awake_rcu(epi);
> +               ep_notify_waiters(ep);
>         }
>
> -       /*
> -        * Wake up ( if active ) both the eventpoll wait list and the ->poll()
> -        * wait list.
> -        */
> -       if (waitqueue_active(&ep->wq))
> -               wake_up_locked(&ep->wq);
> -       if (waitqueue_active(&ep->poll_wait))
> -               pwake++;
> -
> -out_unlock:
> -       spin_unlock_irqrestore(&ep->lock, flags);
> -
> -       /* We have to call this outside the lock */
> -       if (pwake)
> -               ep_poll_safewake(&ep->poll_wait);
> -
>         return 1;
>  }
>
...
> -static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
> -                              void *priv)
> +static int ep_send_events(struct eventpoll *ep,
> +                         struct epoll_event __user *uevent, int maxevents)
>  {
> -       struct ep_send_events_data *esed = priv;
> -       int eventcnt;
> +       int eventcnt = 0;
>         unsigned int revents;
>         struct epitem *epi;
> -       struct epoll_event __user *uevent;
>         struct wakeup_source *ws;
> +       struct wfcq_node *node, *n;
> +       enum epoll_item_state state;
>         poll_table pt;
>
>         init_poll_funcptr(&pt, NULL);
>
>         /*
> -        * We can loop without lock because we are passed a task private list.
> -        * Items cannot vanish during the loop because ep_scan_ready_list() is
> -        * holding "mtx" during this call.
> +        * Items cannot vanish during the loop because we are holding
> +        * "mtx" during this call.
>          */
> -       for (eventcnt = 0, uevent = esed->events;
> -            !list_empty(head) && eventcnt < esed->maxevents;) {
> -               epi = list_first_entry(head, struct epitem, rdllink);
> +       __wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
> +               epi = ep_item_from_node(node);
> +               __wfcq_dequeue(&ep->txlhead, &ep->txltail);
> +
> +               /* no barrier needed, splicing txl should be enough */
> +               state = epi->state;
> +
> +               if (state == EP_STATE_ZOMBIE) {
> +                       ep_reap(ep, epi);
> +                       continue;
> +               }
> +               WARN_ON(state != EP_STATE_READY);
> +               wfcq_node_init(&epi->rdllink);
>
>                 /*
>                  * Activate ep->ws before deactivating epi->ws to prevent

Does anything deactivate ep->ws now?

> @@ -1459,7 +1394,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>                  *
>                  * This could be rearranged to delay the deactivation of epi->ws
>                  * instead, but then epi->ws would temporarily be out of sync
> -                * with ep_is_linked().
> +                * with epi->state.
>                  */
>                 ws = ep_wakeup_source(epi);
>                 if (ws) {
> @@ -1468,25 +1403,29 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>                         __pm_relax(ws);
>                 }
>
> -               list_del_init(&epi->rdllink);
> -
>                 revents = ep_item_poll(epi, &pt);
>
>                 /*
>                  * If the event mask intersect the caller-requested one,
> -                * deliver the event to userspace. Again, ep_scan_ready_list()
> +                * deliver the event to userspace. Again, ep_poll()
>                  * is holding "mtx", so no operations coming from userspace
>                  * can change the item.
>                  */
>                 if (revents) {
>                         if (__put_user(revents, &uevent->events) ||
>                             __put_user(epi->event.data, &uevent->data)) {
> -                               list_add(&epi->rdllink, head);
> +                               wfcq_enqueue(&ep->txlhead, &ep->txltail,
> +                                                       &epi->rdllink);
>                                 ep_pm_stay_awake(epi);
> -                               return eventcnt ? eventcnt : -EFAULT;
> +                               if (!eventcnt)
> +                                       eventcnt = -EFAULT;
> +                               break;
>                         }
> -                       eventcnt++;
> +
>                         uevent++;
> +                       if (++eventcnt == maxevents)
> +                               n = NULL; /* stop iteration */
> +
>                         if (epi->event.events & EPOLLONESHOT)
>                                 epi->event.events &= EP_PRIVATE_BITS;
>                         else if (!(epi->event.events & EPOLLET)) {
> @@ -1495,32 +1434,25 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
>                                  * Trigger mode, we need to insert back inside
>                                  * the ready list, so that the next call to
>                                  * epoll_wait() will check again the events
> -                                * availability. At this point, no one can insert
> -                                * into ep->rdllist besides us. The epoll_ctl()
> -                                * callers are locked out by
> -                                * ep_scan_ready_list() holding "mtx" and the
> -                                * poll callback will queue them in ep->ovflist.
> +                                * availability.
>                                  */
> -                               list_add_tail(&epi->rdllink, &ep->rdllist);
> +                               wfcq_enqueue(&ep->rdlhead, &ep->rdltail,
> +                                                       &epi->rdllink);
>                                 ep_pm_stay_awake(epi);
> +                               continue;
>                         }
>                 }
> +
> +               /*
> +                * reset item state for EPOLLONESHOT and EPOLLET
> +                * no barrier here, rely on ep->mtx release for write barrier
> +                */

What happens if ep_poll_callback runs before you set epi->state below?
It used to queue on ep->ovflist and call __pm_stay_awake on ep->ws,
but now it does not appear to do anything.

> +               epi->state = EP_STATE_IDLE;
>         }
>
>         return eventcnt;
>  }
>
...

-- 
Arve Hjønnevåg
