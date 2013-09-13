Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3IMJAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:00:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3IMJAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:00:08 -0400
Date: Fri, 13 Sep 2013 11:00:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
Message-ID: <20130913090000.GJ31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
 <5231E18D.7070306@canonical.com>
 <5231EF5A.7010901@vmware.com>
 <52323734.4070908@canonical.com>
 <5232B44C.9010408@vmware.com>
 <5232BBE1.5030509@canonical.com>
 <5232C2BB.9070303@vmware.com>
 <20130913082933.GH31370@twins.programming.kicks-ass.net>
 <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:41:54AM +0200, Daniel Vetter wrote:
> On Fri, Sep 13, 2013 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Sep 13, 2013 at 09:46:03AM +0200, Thomas Hellstrom wrote:
> >> >>if (!bo_tryreserve()) {
> >> >>     up_read mmap_sem(); // Release the mmap_sem to avoid deadlocks.
> >> >>     bo_reserve();               // Wait for the BO to become available (interruptible)
> >> >>     bo_unreserve();           // Where is bo_wait_unreserved() when we need it, Maarten :P
> >> >>     return VM_FAULT_RETRY; // Go ahead and retry the VMA walk, after regrabbing
> >> >>}
> >>
> >> Anyway, could you describe what is wrong, with the above solution, because
> >> it seems perfectly legal to me.
> >
> > Luckily the rule of law doesn't have anything to do with this stuff --
> > at least I sincerely hope so.
> >
> > The thing that's wrong with that pattern is that its still not
> > deterministic - although its a lot better than the pure trylock. Because
> > you have to release and re-acquire with the trylock another user might
> > have gotten in again. Its utterly prone to starvation.
> >
> > The acquire+release does remove the dead/life-lock scenario from the
> > FIFO case, since blocking on the acquire will allow the other task to
> > run (or even get boosted on -rt).
> >
> > Aside from that there's nothing particularly wrong with it and lockdep
> > should be happy afaict (but I haven't had my morning juice yet).
> 
> bo_reserve internally maps to a ww-mutex and task can already hold
> ww-mutex (potentially even the same for especially nasty userspace).

OK, yes I wasn't aware of that. Yes in that case you're quite right.
