Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3CVDYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:24:14 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:58212 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3CVDYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:24:11 -0400
Date: Fri, 22 Mar 2013 03:24:10 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130322032410.GA19377@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
 <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> wrote:
> On Thu, Mar 21, 2013 at 4:52 AM, Eric Wong <normalperson@yhbt.net> wrote:
> > Changes since v2:
> > * epi->state is no longer atomic, we only cmpxchg in ep_poll_callback
> >   now and rely on implicit barriers in other places for reading.
> > * intermediate EP_STATE_DEQUEUE removed, this (with xchg) caused too
> >   much overhead in the ep_send_events loop and could not eliminate
> >   starvation dangers from improper EPOLLET usage (the original code
> >   had this problem, too, the window is just a few cycles larger, now).
> > * minor code cleanups

> >                 /*
> >                  * Activate ep->ws before deactivating epi->ws to prevent
> 
> Does anything deactivate ep->ws now?

Oops, I left that out when I killed ep_scan_ready_list.
But I think we need a different approach to wakeup sources in
this series...

> > +               /*
> > +                * reset item state for EPOLLONESHOT and EPOLLET
> > +                * no barrier here, rely on ep->mtx release for write barrier
> > +                */
> 
> What happens if ep_poll_callback runs before you set epi->state below?
> It used to queue on ep->ovflist and call __pm_stay_awake on ep->ws,
> but now it does not appear to do anything.
> 
> > +               epi->state = EP_STATE_IDLE;
> >         }
> >
> >         return eventcnt;
> >  }
> >

With EPOLLET and improper usage (not hitting EAGAIN), the event now
has a larger window to be lost (as mentioned in my changelog).

As far as correct __pm_stay_awake/__pm_relax handling, perhaps adding
an atomic counter to struct eventpoll (or each epitem) will work?

If we go with atomic counter in struct eventpoll, is per-epitem
wakeup_source still necessary?  We have space in epitem now, but
maybe one day we will might need it.

Thanks for looking at this patch.

Btw, I'm curious; which applications use EPOLLWAKEUP?

My epoll work is focused on network servers with thousands of clients,
and I don't think any of them use (or have use for) EPOLLWAKEUP.
But I will keep EPOLLWAKEUP users in mind when working on epoll :)
