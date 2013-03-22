Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3CVEMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:12:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54879 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3CVEMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130322032410.GA19377@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
	<CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
	<20130322032410.GA19377@dcvr.yhbt.net>
Date: Thu, 21 Mar 2013 21:07:14 -0700
Message-ID: <CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
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

On Thu, Mar 21, 2013 at 8:24 PM, Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
>> On Thu, Mar 21, 2013 at 4:52 AM, Eric Wong <normalperson@yhbt.net> wrote:
>> > Changes since v2:
>> > * epi->state is no longer atomic, we only cmpxchg in ep_poll_callback
>> >   now and rely on implicit barriers in other places for reading.
>> > * intermediate EP_STATE_DEQUEUE removed, this (with xchg) caused too
>> >   much overhead in the ep_send_events loop and could not eliminate
>> >   starvation dangers from improper EPOLLET usage (the original code
>> >   had this problem, too, the window is just a few cycles larger, now).
>> > * minor code cleanups
>
>> >                 /*
>> >                  * Activate ep->ws before deactivating epi->ws to prevent
>>
>> Does anything deactivate ep->ws now?
>
> Oops, I left that out when I killed ep_scan_ready_list.
> But I think we need a different approach to wakeup sources in
> this series...
>
>> > +               /*
>> > +                * reset item state for EPOLLONESHOT and EPOLLET
>> > +                * no barrier here, rely on ep->mtx release for write barrier
>> > +                */
>>
>> What happens if ep_poll_callback runs before you set epi->state below?
>> It used to queue on ep->ovflist and call __pm_stay_awake on ep->ws,
>> but now it does not appear to do anything.
>>
>> > +               epi->state = EP_STATE_IDLE;
>> >         }
>> >
>> >         return eventcnt;
>> >  }
>> >
>
> With EPOLLET and improper usage (not hitting EAGAIN), the event now
> has a larger window to be lost (as mentioned in my changelog).
>

What about the case where EPOLLET is not set? The old code did not
drop events in that case.

> As far as correct __pm_stay_awake/__pm_relax handling, perhaps adding
> an atomic counter to struct eventpoll (or each epitem) will work?
>

The wakeup_source should stay in sync with the epoll state. I don't
think any additional state is needed.

> If we go with atomic counter in struct eventpoll, is per-epitem
> wakeup_source still necessary?  We have space in epitem now, but
> maybe one day we will might need it.
>

The wakeup_source per epitem is useful for accounting reasons. If
suspend fails, it is useful to know which device caused it.

> Thanks for looking at this patch.
>
> Btw, I'm curious; which applications use EPOLLWAKEUP?
>
> My epoll work is focused on network servers with thousands of clients,
> and I don't think any of them use (or have use for) EPOLLWAKEUP.
> But I will keep EPOLLWAKEUP users in mind when working on epoll :)

EPOLLWAKEUP is only needed on systems that use suspend. I don't know
if it is currently in use, but it is intended to at least replace the
evdev wakelock in the android kernel, but user-space needs to be
updated before we can drop that patch.

-- 
Arve Hjønnevåg
