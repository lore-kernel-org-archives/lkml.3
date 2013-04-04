Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab3DDUoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:44:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51578 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760640Ab3DDUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:44:32 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1365094158.2609.119.camel@laptop>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
	<1365076908.2609.94.camel@laptop>
	<20130404133123.GW2228@phenom.ffwll.local>
	<1365094158.2609.119.camel@laptop>
Date: Thu, 4 Apr 2013 22:44:31 +0200
X-Google-Sender-Auth: vB70I9WSNHln8visujGUQ0y-uRk
Message-ID: <CAKMK7uEUdtiDDCRPwpiumkrST6suFY7YuQcPAXR_nJ0XHKzsAw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
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

On Thu, Apr 4, 2013 at 6:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
>> We've discussed this approach of using (rt-prio, age) instead of just
>> age
>> to determine the the "oldness" of a task for deadlock-breaking with
>> -EAGAIN. The problem is that through PI boosting or normal rt-prio
>> changes
>> while tasks are trying to acquire ww_mutexes you can create acyclic
>> loops
>> in the blocked-on graph of ww_mutexes after the fact and so cause
>> deadlocks. So we've convinced ourselves that this approche doesn't
>> work.
>
> Could you pretty please draw me a picture, I'm having trouble seeing
> what you mean.
>
> AFAICT as long as you boost Y while its the lock owner things should
> work out, no?

So this one here took a bit of pondering. But I think you'll like the
conclusion.

Now the deadlock detection works because it impose a dag onto all
lockers which clearly denotes who'll wait and who will get wounded.
The problem with using (rt_prio, ww_age/ticket) instead of just the
ticket si that it's ambigous in the face of PI boosting. E.g.
- rt_prio of A > rt_prio of B, but
- task A is younger than task B

Before boosting task A wins, but after boosting (when only the age
matters) task B wins, since it's now older. So now when B comes around
and tries to grab a lock A currently holds, it'll also block.

Now the cool thing with TASK_KILLABLE (hey, I start to appreciate it,
bear with me!) is that this is no problem - it limits the length of
any chain of blocked tasks to just one link of blocked tasks:
- If the length is currently one it cannot be extended - the blocked
task will set the PF_GTFO flag on the current holder, and since that
would be checked before blocking on another ww_mutex the chain can't
grow past one blocked task.
- If the current holder itself is blocked on another ww_mutex it'll be
in TASK_DEADLOCK state and get woken up.

In both case the current holder of the lock will either continue with
what it's been doing (PI-boosted ofc) until it unlocks everything or
hits the PF_GTFO check and backs off from all currently held locks. RT
mission accomplished I think since the wait time for the highest-prio
task for grabbing a lock is bounded by the lock hold time for the
completely uncontended case. And within a given rt-prio the normal
wait/wound algorithm will resolve conflicts (and ensure forward
progress).

So I'm now rather convinced that with the TASK_DEADLOCK implementation
we can make (rt_prio, age) lock ordering work. But it's not an
artifact of consistent PI boosting (I've raced down that alley first
trying to prove it to no avail), but the fact that lock holder kicking
through PF_GTFO naturally limits blocked task chains on ww_mutexes to
just one link. That in turn makes any post-PI-boosted considerations
moot and so can't result in havoc due to a PI-boost having flipped an
edge in the lock_er_ ordering DAG (we sort tasks with wait/wound, not
locks, hence it's not a lock ordering DAG).

Please poke holes into this argument, I've probably missed a sublety
somewhere ...
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
