Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3ILPgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:36:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59304 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3ILPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:36:43 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
Date: Thu, 12 Sep 2013 17:36:43 +0200
Message-ID: <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 5:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> So I'm poking around the preemption code and stumbled upon:
>
> drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
> drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();
>
> All these sites basically do:
>
>   while (!trylock())
>         yield();
>
> which is a horrible and broken locking pattern.
>
> Firstly its deadlock prone, suppose the faulting process is a FIFOn+1
> task that preempted the lock holder at FIFOn.
>
> Secondly the implementation is worse than usual by abusing
> VM_FAULT_NOPAGE, which is supposed to install a PTE so that the fault
> doesn't retry, but you're using it as a get out of fault path. And
> you're using set_need_resched() which is not something a driver should
> _ever_ touch.
>
> Now I'm going to take away set_need_resched() -- and while you can
> 'reimplement' it using set_thread_flag() you're not going to do that
> because it will be broken due to changes to the preempt code.
>
> So please as to fix ASAP and don't allow anybody to trick you into
> merging silly things like that again ;-)

The set_need_resched in i915_gem.c:i915_gem_fault can actually be
removed. It was there to give the error handler a chance to sneak in
and reset the hw/sw tracking when the gpu is dead. That hack goes back
to the days when the locking around our error handler was somewhere
between nonexistent and totally broken, nowadays we keep things from
live-locking by a bit of magic in i915_mutex_lock_interruptible. I'll
whip up a patch to rip this out. I'll also check that our testsuite
properly exercises this path (needs a bit of work on a quick look for
better coverage).

The one in ttm is just bonghits to shut up lockdep: ttm can recurse
into it's own pagefault handler and then deadlock, the trylock just
keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
fun userspace did and now have testcases for them. The right solution
to fix this is to use copy_to|from_user_atomic in ttm everywhere it
holds locks and have slowpaths which drops locks, copies stuff into a
temp allocation and then continues. At least that's how we've fixed
all those inversions in i915-gem. I'm not volunteering to fix this ;-)

The one in udl just looks like copypasta from i915, without any
justification (at least I don't see any) for why it's there. Probably
can die, too, since there isn't any gpu to reset on usb display-link
devices ...

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
