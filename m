Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936604Ab3DHKjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:39:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42480
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934910Ab3DHKjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:39:47 -0400
Message-ID: <1365417564.2609.153.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 08 Apr 2013 12:39:24 +0200
In-Reply-To: <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
	 <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 18:56 +0200, Daniel Vetter wrote:
> On Thu, Apr 4, 2013 at 3:31 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >> In this case when O blocks Y isn't actually blocked, so our
> >> TASK_DEADLOCK wakeup doesn't actually achieve anything.
> >>
> >> This means we also have to track (task) state so that once Y tries to
> >> acquire A (creating the actual deadlock) we'll not wait so our
> >> TASK_DEADLOCK wakeup doesn't actually achieve anything.
> >>
> >> Note that Y doesn't need to acquire A in order to return -EDEADLK, any
> >> acquisition from the same set (see below) would return -EDEADLK even if
> >> there isn't an actual deadlock. This is the cost of heuristic; we could
> >> walk the actual block graph but that would be prohibitively expensive
> >> since we'd have to do this on every acquire.
> >
> > Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the wait
> > times of older task. This could be interesting for RT, but I'm unsure of
> > the implications. The trick with the current code is that the oldest task
> > will never see an -EAGAIN ever and hence is guaranteed to make forward
> > progress. If the task is really unlucky though it might be forced to wait
> > for a younger task for every ww_mutex it tries to acquire.
> 
> [Aside: I'm writing this while your replies trickle in, but I think
> it's not yet answered already.]
> 
> Ok, I've discussed this a lot with Maarten on irc and I think I see a
> bit clearer now what's the aim with the new sleep state. Or at least I
> have an illusion about it ;-) So let me try to recap my understanding
> to check whether we're talking roughly about the same idea.
> 
> I think for starters we need to have a slightly more interesting example:
> 
> 3 threads O, M, Y: O has the oldest ww_age/ticket, Y the youngest, M
> is in between.
> 2 ww_mutexes: A, B
> 
> Y has already acquired ww_mutex A, M has already acquired ww_mutex B.
> 
> Now O wants to acquire B and M wants to acquire A (let's ignore
> detailed ordering for now), resulting in O blocking on M (M holds B
> already, but O is older) and M blocking on Y (same for lock B).

drawing the picture for myself:

	task-O	task-M	task-Y
			A
		B
	B
		A

> Now first question to check my understanding: Your aim with that
> special wakeup is to kick M so that it backs off and drops B? That way
> O does not need to wait for Y to complete whatever it's currently
> doing, unlock A and then in turn M to complete whatever it's doing so
> that it can unlock A&B and finally allows O to grab the lock.

No, we always need to wait for locks to be unlocked. The sole purpose
of the special wakeups state is to not wake other (!ww_mutex) locks
that might be held by the task holding the contended ww_mutex. While
all schedule() sites should deal with spurious wakeups its a sad fact
of life that they do not :/

> Presuming I'm still following we should be able to fix this with the
> new sleep state TASK_DEADLOCK and a flag somewhere in the thread info
> (let's call it PF_GTFO for simplicity).

I'm reading "Get The F*ck Out" ? I like the name, except PF_flags are
unsuitable since they are not atomic and we'd need to set it from
another thread.

>  Then every time a task does a
> blocking wait on a ww_mutex it would set this special sleep state and
> also check the PF_GTFO bit.

So its the contending task (O for B) setting PF_GTFO on the owning task
(M for B), right?

But yeah, all ww_mutex sleep states should have the new TASK_DEADLOCK
sleep state added.

>  If the later is set, it bails out with
> -EAGAIN (so that all locks are dropped).

I would really rather see -EDEADLK for that..

> Now if a task wants to take a lock and notices that it's held by a
> younger locker it can set that flag and wake the thread up (need to
> think about all the races a bit, but we should be able to make this
> work). Then it can do the normal blocking mutex slowpath and wait for
> the unlock.

Right.

> Now if O and M race a bit against each another M should either get
> woken (if it's already blocked on Y) and back off, or notice that the
> thread flag is set before it even tries to grab another mutex 

ww_mutex, it should block just fine on regular mutexes and other
primitives.

> (and so
> before the block tree can extend further to Y). And the special sleep
> state is to make sure we don't cause any other spurious interrupts.

Right, I think we're understanding one another here.

