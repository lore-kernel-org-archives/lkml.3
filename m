Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3ILQWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:22:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51507 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3ILQWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:22:19 -0400
Date: Thu, 12 Sep 2013 18:22:10 +0200
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
Message-ID: <20130912162210.GE31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
 <20130912154329.GB31370@twins.programming.kicks-ass.net>
 <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:58:49PM +0200, Daniel Vetter wrote:
> On Thu, Sep 12, 2013 at 5:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
> >> into it's own pagefault handler and then deadlock, the trylock just
> >> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
> >> fun userspace did and now have testcases for them. The right solution
> >> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
> >> holds locks and have slowpaths which drops locks, copies stuff into a
> >> temp allocation and then continues. At least that's how we've fixed
> >> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
> >
> > Yikes.. so how common is it? If I simply rip the set_need_resched() out
> > it will 'spin' on the fault a little longer until a 'natural' preemption
> > point -- if such a thing is every going to happen.
> 
> It's a case of "our userspace doesn't do this", so as long as you're
> not evil and frob the drm device nodes of ttm drivers directly the
> deadlock will never happen. No idea how much contention actually
> happens on e.g. shared buffer objects - in i915 we have just one lock
> and so suffer quite a bit more from contention. So no idea how much
> removing the yield would hurt.

If 'sane' userspace is never supposed to do this, then only insane
userspace is going to hurt from this and that's a GOOD (tm) thing,
right? ;-)

And it won't actually deadlock if you don't use FIFO, for the regular
scheduler class it'll just spin a little longer before getting preempted
so no real worries there.


