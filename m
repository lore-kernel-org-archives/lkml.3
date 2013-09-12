Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3ILPO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:14:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3ILPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:14:28 -0400
Date: Thu, 12 Sep 2013 17:14:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: airlied@linux.ie, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
Message-ID: <20130912151420.GA31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <5231D99D.80706@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5231D99D.80706@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:11:25PM +0200, Maarten Lankhorst wrote:
> Op 12-09-13 17:06, Peter Zijlstra schreef:
> > Hi Dave,
> >
> > So I'm poking around the preemption code and stumbled upon:
> >
> > drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
> > drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
> > drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
> > drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();
> >
> > All these sites basically do:
> >
> >   while (!trylock())
> >   	yield();
> >
> > which is a horrible and broken locking pattern. 
> >
> > Firstly its deadlock prone, suppose the faulting process is a FIFOn+1
> > task that preempted the lock holder at FIFOn.
> >
> > Secondly the implementation is worse than usual by abusing
> > VM_FAULT_NOPAGE, which is supposed to install a PTE so that the fault
> > doesn't retry, but you're using it as a get out of fault path. And
> > you're using set_need_resched() which is not something a driver should
> > _ever_ touch.
> >
> > Now I'm going to take away set_need_resched() -- and while you can
> > 'reimplement' it using set_thread_flag() you're not going to do that
> > because it will be broken due to changes to the preempt code.
> >
> > So please as to fix ASAP and don't allow anybody to trick you into
> > merging silly things like that again ;-)
> >
> Agreed, but this is a case of locking inversion. How do you propose to get around that?

me? No idea, I've never looked at the actual locking in DRM. Someone
who's familiar with that code would have to tackle that.

I just spotted the fail because I was going to remove set_need_resched()
and had a WTF moment when I tripped over this stuff.
