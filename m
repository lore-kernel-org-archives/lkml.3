Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123Ab3DHLrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:47:31 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52759 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934964Ab3DHLr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:47:28 -0400
Date: Mon, 8 Apr 2013 13:50:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130408115026.GL2228@phenom.ffwll.local>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	rob clark <robclark@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
 <1365417564.2609.153.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365417564.2609.153.camel@laptop>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:39:24PM +0200, Peter Zijlstra wrote:
> On Thu, 2013-04-04 at 18:56 +0200, Daniel Vetter wrote:
> > Presuming I'm still following we should be able to fix this with the
> > new sleep state TASK_DEADLOCK and a flag somewhere in the thread info
> > (let's call it PF_GTFO for simplicity).
> 
> I'm reading "Get The F*ck Out" ? I like the name, except PF_flags are
> unsuitable since they are not atomic and we'd need to set it from
> another thread.

I think the PF_ flag is a non-starter for a different reason, too. To make
different clases of ww_mutexes nest properly, we need to make sure that we
don't dead/live-lock trying to wake up a task holdinga ww_mutex of class
A, while that task is trying to acquire ww_mutexes of class B. Picture:

	task 1			task 2			task 3
							holds lock B
	ticket_A = acquire_start(class A)
	ww_mutex_lock(lock A, ticket_A)			busy doing something

	ticket_B = acquire_start(class B)
	ww_mutex_lock(lock B, ticket_B)
	-> contention with task 3
				
				ticket_task2 = acquire_start(class A)
				ww_mutex_lock(lock A, ticket_task2)
				-> contention with task 1

If we go with the PF_GTFO task flag, task 2 will set it on task 1
(handwave locking/atomicity again here ;-). But taks 1 will only back off
from any locks in class B. Or at least I think we should impose that
restriction, since otherwise a ww_mutex acquire loop will leak out badly
abstraction-wise and making nesting pretty much impossible in practice.

But if we really want nesting to work transparently, then task 1 should be
allowed to continue taking locks from class A (after an acquire_end(class
B) call ofc). But then it will have missed the wakeup from task 2, so task
2 blocks for too long and task 1 doesn't back off from further acquiring
locks in class A.

Presuming my reasoning for the rt case isn't broken, this break deadlock
avoidance if we sort by (rt_prio, ticket).

So I think we need to move the PF_GTFO flag to the ticket to make sure
that task1 will notice that there's contention with one of the locks it
holds from class A and that it better gtfo asap (i.e. back off, drop all
currently held locks in class A and go into the slowpath).

But I still need to think the nesting case through a bit more (and draw
some diagrams), so not sure yet. One thing I still need to ponder is how
to best stack tickets (for tasks doing nested ww_mutex locking) and where
all we need a pointer to relevant tickets and what kind of fun this
entails ... I need to ponder this some more.

> >  Then every time a task does a
> > blocking wait on a ww_mutex it would set this special sleep state and
> > also check the PF_GTFO bit.
> 
> So its the contending task (O for B) setting PF_GTFO on the owning task
> (M for B), right?

Yeah, the idea is that the contending task sets this bit on the current
holder (whether we put that bit into the task or the ticket), so that the
current owner can back off and drop all currently held locks at the next
opportunity (either due to being woken up in TASK_DEADLCOK state or in the
next ww_mutex_lock call).

> But yeah, all ww_mutex sleep states should have the new TASK_DEADLOCK
> sleep state added.
> 
> >  If the later is set, it bails out with
> > -EAGAIN (so that all locks are dropped).
> 
> I would really rather see -EDEADLK for that..

I agree it makes more sense for a general api (outside of ttm), but I
struggle a bit to come up with a good errno for the "you hold this lock
already" case. Best I could do is -EBUSY ...

Hm, looking through errno.h I've just spotted -EALREADY. Seems to be used
all over (not just networking), so I guess we could extend it's meaning a
bit?

> > Now if a task wants to take a lock and notices that it's held by a
> > younger locker it can set that flag and wake the thread up (need to
> > think about all the races a bit, but we should be able to make this
> > work). Then it can do the normal blocking mutex slowpath and wait for
> > the unlock.
> 
> Right.
> 
> > Now if O and M race a bit against each another M should either get
> > woken (if it's already blocked on Y) and back off, or notice that the
> > thread flag is set before it even tries to grab another mutex 
> 
> ww_mutex, it should block just fine on regular mutexes and other
> primitives.

Yes, that special behaviour should only apply to ww_mutexes not to any
other locking. I've not been terribly careful here ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
