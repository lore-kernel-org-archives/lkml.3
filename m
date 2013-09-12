Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3ILP6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:58:50 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44979 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3ILP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:58:49 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130912154329.GB31370@twins.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
	<CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
	<20130912154329.GB31370@twins.programming.kicks-ass.net>
Date: Thu, 12 Sep 2013 17:58:49 +0200
Message-ID: <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
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

On Thu, Sep 12, 2013 at 5:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
>> into it's own pagefault handler and then deadlock, the trylock just
>> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
>> fun userspace did and now have testcases for them. The right solution
>> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
>> holds locks and have slowpaths which drops locks, copies stuff into a
>> temp allocation and then continues. At least that's how we've fixed
>> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
>
> Yikes.. so how common is it? If I simply rip the set_need_resched() out
> it will 'spin' on the fault a little longer until a 'natural' preemption
> point -- if such a thing is every going to happen.

It's a case of "our userspace doesn't do this", so as long as you're
not evil and frob the drm device nodes of ttm drivers directly the
deadlock will never happen. No idea how much contention actually
happens on e.g. shared buffer objects - in i915 we have just one lock
and so suffer quite a bit more from contention. So no idea how much
removing the yield would hurt.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
