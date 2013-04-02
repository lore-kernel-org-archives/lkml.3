Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3DBRXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:23:25 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:64004 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab3DBRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:23:22 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1364921954.20640.22.camel@laptop>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
Date: Tue, 2 Apr 2013 19:23:22 +0200
Message-ID: <CAKMK7uGPGbNiKUPvdmsuyTB5g8G0DhGhdFDiN0ht8jBsgdG+SQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 6:59 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > Head hurts, needs more time to ponder. It would be good if someone else
>> > (this would probably be you maarten) would also consider this explore
>> > this 'interesting' problem space :-)
>
>> My head too, evil priority stuff!
>>
>> Hacky but pragmatical workaround for now: use a real mutex around all
>> the reserve_mutex_lock* calls instead of a virtual lock. It can be
>> unlocked as soon as all locks have been taken, before any actual work
>> is done.
>>
>> It only slightly kills the point of having a reservation in the first
>> place, but at least it won't break completely -rt completely for now.
>
> Yeah, global lock, yay :-(

We've discussed this quite a bit on irc and came up with a bunch of
other ideas. The global lock is completely transparent to users, since
the lockdep annotations already rely on ticket_init/fini being a
virtual lock. So we can always fall back to that option.

For more fancy approaches we need to consider the aim first - do we
just want to prevent deadlocks through PI or do we aim for bounded
per-reservation_mutex wait block-to-acquire times for the thread with
highest rt-prio.

If it's just the former I think we can get by by piggy-packing on top
of the existing PI mutex code. Only downside is that threads can lock
arbitrary many reservation locks and so we're looking at boosting an
entire tree of processes. Otoh common operations done while holding
such a lock are swapping buffer objects in or waiting for gpu
rendering. And since we can easily queue up a few ms of rendering rt
guarantees are out the window ;-)

If that's not good enough and the global lock not scalable enough we
could try to limit the fan-out by setting a PI-boost flag in the
reservation ticket (in additional to the normal PI boosting for the
reservation mutex). Threads which are boosted in that fashion will get
a -EAGAIN on the next mutex_reserv_lock call, ensuring that the
blocking doesn't spread to further threads. But that requires that we
pass around pointers to tickets instead of values, so lifetime fun
(atm the ticket is on the stack) and probably tons of races in
updating the ticket boost state. I'd like to avoid that until we've
demonstrated a need for it ...

In any way I think that all three approaches should fit into the
proposed interfaces, so we should be able to do something sane here.
But since I have pretty much zero clue about rt I have no idea which
of the first two approaches would be preferable.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
