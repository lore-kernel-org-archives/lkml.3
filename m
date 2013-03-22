Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3CVKbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:31:05 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:60352 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab3CVKbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:31:03 -0400
Date: Fri, 22 Mar 2013 10:31:02 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130322103102.GA4818@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
 <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
 <20130322032410.GA19377@dcvr.yhbt.net>
 <CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> wrote:
> On Thu, Mar 21, 2013 at 8:24 PM, Eric Wong <normalperson@yhbt.net> wrote:
> >
> > With EPOLLET and improper usage (not hitting EAGAIN), the event now
> > has a larger window to be lost (as mentioned in my changelog).
> >
> 
> What about the case where EPOLLET is not set? The old code did not
> drop events in that case.

Nothing is dropped, if the event wasn't on the ready list before,
ep_poll_callback may still append the ready list while __put_user
is running.

If the event was on the ready list:

1) It does not matter for EPOLLONESHOT, it'll get masked out and
   discarded in the next ep_send_events call until ep_modify reenables
   it.  Since ep_modify and ep_send_events both take ep->mtx, there's
   no conflict.

2) Level Trigger - event stays ready, so nothing is dropped.

> > As far as correct __pm_stay_awake/__pm_relax handling, perhaps adding
> > an atomic counter to struct eventpoll (or each epitem) will work?
> 
> The wakeup_source should stay in sync with the epoll state. I don't
> think any additional state is needed.

The problem is epi->state is not set atomically in ep_send_events,

Having atomic operations in the loop hurts performance (early versions
of this patch did that, and hurt the single-threaded case).

Maybe I'll only set epi->state atomically if epi->ws is used...

> > If we go with atomic counter in struct eventpoll, is per-epitem
> > wakeup_source still necessary?  We have space in epitem now, but
> > maybe one day we will might need it.
> >
> 
> The wakeup_source per epitem is useful for accounting reasons. If
> suspend fails, it is useful to know which device caused it.

OK.  I'll keep epitem->ws
