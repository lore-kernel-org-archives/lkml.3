Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423379Ab3CVWSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:18:10 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39854 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422924Ab3CVWSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130322103102.GA4818@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
	<CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
	<20130322032410.GA19377@dcvr.yhbt.net>
	<CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
	<20130322103102.GA4818@dcvr.yhbt.net>
Date: Fri, 22 Mar 2013 15:18:06 -0700
Message-ID: <CAMP5XgcN+qBJ7FryzXJEG11F=3ajHDoBncMyShZOksd14SaptA@mail.gmail.com>
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

On Fri, Mar 22, 2013 at 3:31 AM, Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
>> On Thu, Mar 21, 2013 at 8:24 PM, Eric Wong <normalperson@yhbt.net> wrote:
>> >
>> > With EPOLLET and improper usage (not hitting EAGAIN), the event now
>> > has a larger window to be lost (as mentioned in my changelog).
>> >
>>
>> What about the case where EPOLLET is not set? The old code did not
>> drop events in that case.
>
> Nothing is dropped, if the event wasn't on the ready list before,
> ep_poll_callback may still append the ready list while __put_user
> is running.
>
> If the event was on the ready list:
>
> 1) It does not matter for EPOLLONESHOT, it'll get masked out and
>    discarded in the next ep_send_events call until ep_modify reenables
>    it.  Since ep_modify and ep_send_events both take ep->mtx, there's
>    no conflict.
>
> 2) Level Trigger - event stays ready, so nothing is dropped.
>

At some point the level triggered event has to get cleared. As far as
I can tell, your new code will drop new events that occur between
"revents = ep_item_poll(epi, &pt);" and "epi->state = EP_STATE_IDLE;"
in that case.

-- 
Arve Hjønnevåg
