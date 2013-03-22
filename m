Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423434Ab3CVW1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:27:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36087 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648Ab3CVW1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130322192423.GA25561@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
	<CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
	<20130322032410.GA19377@dcvr.yhbt.net>
	<CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
	<20130322103102.GA4818@dcvr.yhbt.net>
	<20130322192423.GA25561@dcvr.yhbt.net>
Date: Fri, 22 Mar 2013 15:27:34 -0700
Message-ID: <CAMP5Xgfbgj__qCC6hC85py+TYVjDBjX+37UPZBnNb2xhKXKBmA@mail.gmail.com>
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

On Fri, Mar 22, 2013 at 12:24 PM, Eric Wong <normalperson@yhbt.net> wrote:
...
> Perhaps just using epitem->ws and removing ep->ws can work.
>
> I think the following change to keep wakeup_source in sync with
> epi->state is sufficient to prevent suspend.
>
> But I'm not familiar with suspend.  Is it possible to suspend while
> a) spinning on a lock?
> b) holding a spinlock?
>

If you code cannot be preempted suspend will not complete. However, if
you drop the last wakeup_source that was active, you may trigger a new
suspend attempt, so it is best to avoid this.

> Since we avoid spinlocks in the main ep_poll_callback path, maybe the
> chance of entering suspend is reduced anyways since we may activate
> the ws sooner.
>
> What do you think?
>

I think you should make sure ep_poll_callback does not return without
an active wakeup_source if EPOLLWAKEUP is set.

> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 1e04175..531ad46 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -214,9 +214,6 @@ struct eventpoll {
>         /* RB tree root used to store monitored fd structs */
>         struct rb_root rbr;
>
> -       /* wakeup_source used when ep_send_events is running */
> -       struct wakeup_source *ws;
> -
>         /* The user that created the eventpoll descriptor */
>         struct user_struct *user;
>
> @@ -718,7 +715,6 @@ static void ep_free(struct eventpoll *ep)
>         mutex_unlock(&epmutex);
>         mutex_destroy(&ep->mtx);
>         free_uid(ep->user);
> -       wakeup_source_unregister(ep->ws);
>         kfree(ep);
>  }
>
> @@ -1137,12 +1133,6 @@ static int ep_create_wakeup_source(struct epitem *epi)
>         const char *name;
>         struct wakeup_source *ws;
>
> -       if (!epi->ep->ws) {
> -               epi->ep->ws = wakeup_source_register("eventpoll");
> -               if (!epi->ep->ws)
> -                       return -ENOMEM;
> -       }
> -
>         name = epi->ffd.file->f_path.dentry->d_name.name;
>         ws = wakeup_source_register(name);
>
> @@ -1390,22 +1380,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
>                 WARN_ON(state != EP_STATE_READY);
>                 wfcq_node_init(&epi->rdllink);
>
> -               /*
> -                * Activate ep->ws before deactivating epi->ws to prevent
> -                * triggering auto-suspend here (in case we reactive epi->ws
> -                * below).
> -                *
> -                * This could be rearranged to delay the deactivation of epi->ws
> -                * instead, but then epi->ws would temporarily be out of sync
> -                * with epi->state.
> -                */
> -               ws = ep_wakeup_source(epi);
> -               if (ws) {
> -                       if (ws->active)
> -                               __pm_stay_awake(ep->ws);
> -                       __pm_relax(ws);
> -               }
> -
>                 revents = ep_item_poll(epi, &pt);
>
>                 /*
> @@ -1419,7 +1393,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
>                             __put_user(epi->event.data, &uevent->data)) {
>                                 wfcq_enqueue_local(&ep->txlhead, &ep->txltail,
>                                                         &epi->rdllink);
> -                               ep_pm_stay_awake(epi);
>                                 if (!eventcnt)
>                                         eventcnt = -EFAULT;
>                                 break;
> @@ -1441,13 +1414,34 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
>                                  */
>                                 wfcq_enqueue_local(&lthead, &lttail,
>                                                         &epi->rdllink);
> -                               ep_pm_stay_awake(epi);
>                                 continue;
>                         }
>                 }
>
>                 /*
> -                * reset item state for EPOLLONESHOT and EPOLLET
> +                * Deactivate the wakeup source before marking it idle.
> +                * The barrier implied by the spinlock in __pm_relax ensures
> +                * any ep_poll_callback callers running will see the
> +                * deactivated ws before epi->state == EP_STATE_IDLE.
> +                *
> +                * For EPOLLET, the event may still be merged into the one
> +                * that is currently on its way into userspace, but it has
> +                * always been the responsibility of userspace to trigger
> +                * EAGAIN on the file before it expects the item to appear
> +                * again in epoll_wait.
> +                *
> +                * Level Trigger never gets here, so the ws remains active.

I don't think this statement is true.

> +                *
> +                * EPOLLONESHOT will either be dropped by ep_poll_callback
> +                * or dropped the next time ep_send_events is called, so the
> +                * ws is irrelevant until it is hit by ep_modify
> +                */
> +               ws = ep_wakeup_source(epi);
> +               if (ws)
> +                       __pm_relax(ws);
> +
> +               /*
> +                * reset item state for EPOLLONESHOT and EPOLLET.
>                  * no barrier here, rely on ep->mtx release for write barrier
>                  */
>                 epi->state = EP_STATE_IDLE;
>
> --
> Eric Wong



-- 
Arve Hjønnevåg
