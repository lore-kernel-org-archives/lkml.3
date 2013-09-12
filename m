Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3ILRCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:02:11 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:19503 "EHLO
	fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195Ab3ILRCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:02:09 -0400
X-Greylist: delayed 1575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 13:02:08 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=87.106.93.118;
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 12 Sep 2013 17:35:43 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
Message-ID: <20130912163543.GB12961@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@linux.ie>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
 <20130912154329.GB31370@twins.programming.kicks-ass.net>
 <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
 <20130912162210.GE31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912162210.GE31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
X-To-Not-Matched: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 06:22:10PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 12, 2013 at 05:58:49PM +0200, Daniel Vetter wrote:
> > On Thu, Sep 12, 2013 at 5:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
> > >> into it's own pagefault handler and then deadlock, the trylock just
> > >> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
> > >> fun userspace did and now have testcases for them. The right solution
> > >> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
> > >> holds locks and have slowpaths which drops locks, copies stuff into a
> > >> temp allocation and then continues. At least that's how we've fixed
> > >> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
> > >
> > > Yikes.. so how common is it? If I simply rip the set_need_resched() out
> > > it will 'spin' on the fault a little longer until a 'natural' preemption
> > > point -- if such a thing is every going to happen.
> > 
> > It's a case of "our userspace doesn't do this", so as long as you're
> > not evil and frob the drm device nodes of ttm drivers directly the
> > deadlock will never happen. No idea how much contention actually
> > happens on e.g. shared buffer objects - in i915 we have just one lock
> > and so suffer quite a bit more from contention. So no idea how much
> > removing the yield would hurt.
> 
> If 'sane' userspace is never supposed to do this, then only insane
> userspace is going to hurt from this and that's a GOOD (tm) thing,
> right? ;-)

Not quite, as it would be possible for the evil userspace to trigger a
GPU hang that would cause the sane userspace to spin indefinitely 
waiting for the error recovery to kick in.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
