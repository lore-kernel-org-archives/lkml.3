Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab3DBQ7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:59:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab3DBQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:59:37 -0400
Message-ID: <1364921954.20640.22.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        daniel.vetter@ffwll.ch, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Date: Tue, 02 Apr 2013 18:59:14 +0200
In-Reply-To: <515AF1C1.7080508@canonical.com>
References: <20130228102452.15191.22673.stgit@patser>
	  <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 16:57 +0200, Maarten Lankhorst wrote:
> Hey,
> 
> Thanks for reviewing.

Only partway through so far :-)

> Op 02-04-13 13:00, Peter Zijlstra schreef:
> > On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> >> +Reservation type mutexes
> >> +struct ticket_mutex {
> >> +extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
> > That's two different names and two different forms of one (for a total
> > of 3 variants) for the same scheme.
> >
> > FAIL...

> It's been hard since I haven't seen anything similar in the kernel, I
> originally went with tickets since that's what ttm originally called
> it, and tried to kill as many references as I could when I noticed
> ticket mutexes already being taken.

Ticket mutexes as such don't exist, but we have ticket based spinlock
implementations. It seems a situation ripe for confusion to have two
locking primitives (mutex, spinlock) with similar names (ticket) but
vastly different semantics.

> I'll fix up the ticket_mutex -> reservation_mutex, and mutex_reserve_*
> -> reserve_mutex_*

Do a google for "lock reservation" and observe the results.. its some
scheme where they pre-assign lock ownership to the most likely thread.

> > On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> >> +mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
> >> +  Similar to mutex_reserve_lock, except it won't backoff with
> >> -EAGAIN.
> >> +  This is useful when mutex_reserve_lock failed with -EAGAIN, and you
> >> +  unreserved all reservation_locks so no deadlock can occur.
> >> +
> > I don't particularly like these function names, with lock
> > implementations the _slow post-fix is typically used for slow path
> > implementations, not API type interfaces.

>  I didn't intend for drivers to use the new calls directly, but rather
> through a wrapper, for example by ttm_eu_reserve_buffers in
> drivers/gpu/drm/ttm/ttm_execbuf_util.c

You're providing a generic interface to the core kernel, other people
will end up using it. Providing a proper API is helpful.

> > Also, is there anything in CS literature that comes close to this? I'd
> > think the DBMS people would have something similar with their
> > transactional systems. What do they call it?

> I didn't study cs, but judging from your phrasing I guess you mean you
> want me to call it transaction_mutexes instead?

Nah, me neither, I just hate reinventing names for something that's
already got a perfectly fine name under which a bunch of people know
it.

See the email from Daniel, apparently its known as wound-wait deadlock
avoidance -- its actually described in the "deadlock" wikipedia
article.

So how about we call the thing something like:

  struct ww_mutex; /* wound/wait */

  int mutex_wound_lock(struct ww_mutex *); /* returns -EDEADLK */
  int mutex_wait_lock(struct ww_mutex *);  /* does not fail */

Hmm.. thinking about that,.. you only need that second variant because
you don't have a clear lock to wait for the 'older' process to
complete; but having the unconditional wait makes the entire thing
prone to accidents and deadlocks when the 'user' (read your fellow
programmers) make a mistake.

Ideally we'd only have the one primitive that returns -EDEADLK and use
a 'proper' mutex to wait on or somesuch.. let me ponder this a bit more.

> > Head hurts, needs more time to ponder. It would be good if someone else 
> > (this would probably be you maarten) would also consider this explore 
> > this 'interesting' problem space :-) 

> My head too, evil priority stuff!
> 
> Hacky but pragmatical workaround for now: use a real mutex around all
> the reserve_mutex_lock* calls instead of a virtual lock. It can be
> unlocked as soon as all locks have been taken, before any actual work
> is done.
> 
> It only slightly kills the point of having a reservation in the first
> place, but at least it won't break completely -rt completely for now.

Yeah, global lock, yay :-(

