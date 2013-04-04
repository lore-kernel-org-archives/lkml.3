Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496Ab3DDQ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:57:03 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37391 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763090Ab3DDQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:56:59 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
	<1365076908.2609.94.camel@laptop>
	<20130404133123.GW2228@phenom.ffwll.local>
Date: Thu, 4 Apr 2013 18:56:58 +0200
Message-ID: <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 3:31 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> In this case when O blocks Y isn't actually blocked, so our
>> TASK_DEADLOCK wakeup doesn't actually achieve anything.
>>
>> This means we also have to track (task) state so that once Y tries to
>> acquire A (creating the actual deadlock) we'll not wait so our
>> TASK_DEADLOCK wakeup doesn't actually achieve anything.
>>
>> Note that Y doesn't need to acquire A in order to return -EDEADLK, any
>> acquisition from the same set (see below) would return -EDEADLK even if
>> there isn't an actual deadlock. This is the cost of heuristic; we could
>> walk the actual block graph but that would be prohibitively expensive
>> since we'd have to do this on every acquire.
>
> Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the wait
> times of older task. This could be interesting for RT, but I'm unsure of
> the implications. The trick with the current code is that the oldest task
> will never see an -EAGAIN ever and hence is guaranteed to make forward
> progress. If the task is really unlucky though it might be forced to wait
> for a younger task for every ww_mutex it tries to acquire.

[Aside: I'm writing this while your replies trickle in, but I think
it's not yet answered already.]

Ok, I've discussed this a lot with Maarten on irc and I think I see a
bit clearer now what's the aim with the new sleep state. Or at least I
have an illusion about it ;-) So let me try to recap my understanding
to check whether we're talking roughly about the same idea.

I think for starters we need to have a slightly more interesting example:

3 threads O, M, Y: O has the oldest ww_age/ticket, Y the youngest, M
is in between.
2 ww_mutexes: A, B

Y has already acquired ww_mutex A, M has already acquired ww_mutex B.

Now O wants to acquire B and M wants to acquire A (let's ignore
detailed ordering for now), resulting in O blocking on M (M holds B
already, but O is older) and M blocking on Y (same for lock B).

Now first question to check my understanding: Your aim with that
special wakeup is to kick M so that it backs off and drops B? That way
O does not need to wait for Y to complete whatever it's currently
doing, unlock A and then in turn M to complete whatever it's doing so
that it can unlock A&B and finally allows O to grab the lock.

Presuming I'm still following we should be able to fix this with the
new sleep state TASK_DEADLOCK and a flag somewhere in the thread info
(let's call it PF_GTFO for simplicity). Then every time a task does a
blocking wait on a ww_mutex it would set this special sleep state and
also check the PF_GTFO bit. If the later is set, it bails out with
-EAGAIN (so that all locks are dropped).

Now if a task wants to take a lock and notices that it's held by a
younger locker it can set that flag and wake the thread up (need to
think about all the races a bit, but we should be able to make this
work). Then it can do the normal blocking mutex slowpath and wait for
the unlock.

Now if O and M race a bit against each another M should either get
woken (if it's already blocked on Y) and back off, or notice that the
thread flag is set before it even tries to grab another mutex (and so
before the block tree can extend further to Y). And the special sleep
state is to make sure we don't cause any other spurious interrupts.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
