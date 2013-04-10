Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936856Ab3DJKbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:31:14 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35035 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935892Ab3DJKbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:31:11 -0400
Date: Wed, 10 Apr 2013 12:34:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130410103408.GI27612@phenom.ffwll.local>
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
 <20130408115026.GL2228@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408115026.GL2228@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:50:26PM +0200, Daniel Vetter wrote:
> On Mon, Apr 08, 2013 at 12:39:24PM +0200, Peter Zijlstra wrote:
> > On Thu, 2013-04-04 at 18:56 +0200, Daniel Vetter wrote:
> > > Presuming I'm still following we should be able to fix this with the
> > > new sleep state TASK_DEADLOCK and a flag somewhere in the thread info
> > > (let's call it PF_GTFO for simplicity).
> > 
> > I'm reading "Get The F*ck Out" ? I like the name, except PF_flags are
> > unsuitable since they are not atomic and we'd need to set it from
> > another thread.
> 
> I think the PF_ flag is a non-starter for a different reason, too. To make
> different clases of ww_mutexes nest properly, we need to make sure that we
> don't dead/live-lock trying to wake up a task holdinga ww_mutex of class
> A, while that task is trying to acquire ww_mutexes of class B. Picture:
> 
> 	task 1			task 2			task 3
> 							holds lock B
> 	ticket_A = acquire_start(class A)
> 	ww_mutex_lock(lock A, ticket_A)			busy doing something
> 
> 	ticket_B = acquire_start(class B)
> 	ww_mutex_lock(lock B, ticket_B)
> 	-> contention with task 3
> 				
> 				ticket_task2 = acquire_start(class A)
> 				ww_mutex_lock(lock A, ticket_task2)
> 				-> contention with task 1
> 
> If we go with the PF_GTFO task flag, task 2 will set it on task 1
> (handwave locking/atomicity again here ;-). But taks 1 will only back off
> from any locks in class B. Or at least I think we should impose that
> restriction, since otherwise a ww_mutex acquire loop will leak out badly
> abstraction-wise and making nesting pretty much impossible in practice.
> 
> But if we really want nesting to work transparently, then task 1 should be
> allowed to continue taking locks from class A (after an acquire_end(class
> B) call ofc). But then it will have missed the wakeup from task 2, so task
> 2 blocks for too long and task 1 doesn't back off from further acquiring
> locks in class A.
> 
> Presuming my reasoning for the rt case isn't broken, this break deadlock
> avoidance if we sort by (rt_prio, ticket).
> 
> So I think we need to move the PF_GTFO flag to the ticket to make sure
> that task1 will notice that there's contention with one of the locks it
> holds from class A and that it better gtfo asap (i.e. back off, drop all
> currently held locks in class A and go into the slowpath).
> 
> But I still need to think the nesting case through a bit more (and draw
> some diagrams), so not sure yet. One thing I still need to ponder is how
> to best stack tickets (for tasks doing nested ww_mutex locking) and where
> all we need a pointer to relevant tickets and what kind of fun this
> entails ... I need to ponder this some more.

Ok, so I think the nesting case should all work if we have a
per-task/ticket flag to signal contention. The point I've mused over a bit
is how to get at both the flag and the corresponding task to do the
wakeup. I think for non-rt the simplest way is to store a pointer to the
ticket in the ww_mutex, and the ticket the holds both the contention flag
and a pointer to the task. Lifetime of that stuff would be protected by
the wait_lock from disappearing untimely, which should allow the
lock/unlock fastpaths to set/clear it non-atomically - only careful places
is in the contented unlock slowpath. So rough api sketch for nesting
ww_mutexes:

struct ww_class {
	atomic_t next_ticket;
	/* virtual lock to annotate the acquire_start/end sections. */
	struct lock_class_key acquire_key;
	/* lockdep class of all ww_mutexes in this class */
	struct lock_class_key mutex_key;
	/* for debug/tracepts */
	const char *name 
};

DEFINE_WW_CLASS(name) /* ... and all the other usual magic init funcitons */

struct ww_acquire_ctx {
	struct task_struct *task; /* invariant */
	usinged ticket; /* invariant */
	/* atomic is probably overkill, but need to review the resulting
	 * code with all the barriers first. */
	atomic_t contention;
}

void ww_acquire_start(struct ww_acuire_ctx *ctx, struct ww_class *class);
void ww_acquire_end(struct ww_acuire_ctx *ctx);

Originally I've thought we could store the pointer to the current acquire
ctx in task_struct (since we need that handy for PI boosting anyway), but
that makes things a bit ugly with nesting. Having a (somewhat) redundant
pointer to the acquiring taks in the ctx seemed less evil.

struct ww_mutex {
	struct mutex base;
	struct ww_acquire_ctx *holding_ctx;
}

I've considered whether we should try to pull clever tricks like with
lockdep keys and make the ww_class more implicit (by auto-instantiating it
somewhere and adding a pointer to it in each ww_mutex). But I think we
should not hide this complexity, but instead make it explicit.

All the ww_mutex_(un)lock* variants would then also need to take the
context instead of the ticket. Besides the usual return codes matching the
normal mutex functions we'd have:

-EDEADLK: Deadlock detected (or got kicked by a higher-prio task in RT),
drop all currently held locks (of the same class) and block on this lock
(since it's the contention point) with ww_mutex_lock_slow.

-EALREADY: Lock already held by the same acquire context. We need this to
be able to efficiently yell at evil userspace.

If ww_mutex_lock goes into the slowpath and it's not one of the above
cases (i.e. wait, not wound) then it sets the contention flag
(unconditionally) and wakes up the current holder iff the current holder
is in the TASK_DEADLOCK state.

If ww_mutex_lock gets woken up it checks the contextion flag on the
acquire context. If it is set it backs off and returns -EDEADLK. Obviously
it also needs to check that before blocking, and we might even want to
check unconditionally before attempting any lock operation (to ensure we
get out of the way of higher-prio tasks quicker).

One thing we probably need is to make TASK_DEADLOCK a flag, since we still
want the different interruptible types of blocking. At least i915 goes to
great lengths to make sure that we take every lock which could be held
while waiting for the gpu with interruptible sleeps (or at least
killable).

Did I miss anything?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
