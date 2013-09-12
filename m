Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3ILPnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:43:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3ILPni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:43:38 -0400
Date: Thu, 12 Sep 2013 17:43:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
Message-ID: <20130912154329.GB31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:36:43PM +0200, Daniel Vetter wrote:
> The set_need_resched in i915_gem.c:i915_gem_fault can actually be
> removed. It was there to give the error handler a chance to sneak in
> and reset the hw/sw tracking when the gpu is dead. That hack goes back
> to the days when the locking around our error handler was somewhere
> between nonexistent and totally broken, nowadays we keep things from
> live-locking by a bit of magic in i915_mutex_lock_interruptible. I'll
> whip up a patch to rip this out. I'll also check that our testsuite
> properly exercises this path (needs a bit of work on a quick look for
> better coverage).
> 
> The one in udl just looks like copypasta from i915, without any
> justification (at least I don't see any) for why it's there. Probably
> can die, too, since there isn't any gpu to reset on usb display-link
> devices ...

OK, awesome that. 2 down.

> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
> into it's own pagefault handler and then deadlock, the trylock just
> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
> fun userspace did and now have testcases for them. The right solution
> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
> holds locks and have slowpaths which drops locks, copies stuff into a
> temp allocation and then continues. At least that's how we've fixed
> all those inversions in i915-gem. I'm not volunteering to fix this ;-)

Yikes.. so how common is it? If I simply rip the set_need_resched() out
it will 'spin' on the fault a little longer until a 'natural' preemption
point -- if such a thing is every going to happen.

It would make that path take longer, but not be more or less broken.

So if its a rare path, I'll just rip the set_need_resched() out and you
DRM people can then fix up at your own pace.
