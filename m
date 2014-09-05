Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIERbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:31:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37396 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaIERbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140905165956.GA28623@leverpostej>
References: <20140901181808.GA6427@leverpostej>
	<20140901190534.GC5806@worktop.ger.corp.intel.com>
	<20140902185807.GA7434@leverpostej>
	<20140903115013.GA3127@leverpostej>
	<20140904104402.GS4783@worktop.ger.corp.intel.com>
	<20140904110740.GB32228@leverpostej>
	<20140905151640.GN19379@twins.programming.kicks-ass.net>
	<CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
	<20140905165956.GA28623@leverpostej>
Date: Fri, 5 Sep 2014 10:31:49 -0700
X-Google-Sender-Auth: IQTNq8SmwJDH7WqJGS7JERjDEdo
Message-ID: <CA+55aFwqhPLjTyiwVs2F9p8BPxMV=FOTgLpcHcV2rUPvTt71ow@mail.gmail.com>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 9:59 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>
> As you point out below, the race on event->ctx is the fundamental issue. That
> is what results in decrementing the refcount twice (once on a stale event->ctx
> pointer).

So quite frankly, the whole perf_pmu_migrate_context() thing looks
completely and fundamentally broken.

Your patch doesn't really solve anything in general, and would need to
be extended to do that get_online_cpus() around every single case
where we read it. Which isn't really acceptable.

perf_pmu_migrate_context() is just f*cked up. It needs to be reverted.
It seems to think that "the event->ctx" pointer is a RCU-protected
pointer, but it really isn't. Its lifetime is protected by
refcounting, and the pointer access itself isn't protected by
anything, because "event->ctx" isn't supposed to change over the
lifetime of "event". Nobody does all the necessary rcu_read_[un]lock()
around it, nor access it with rcu_dereference(), because all users
know that it's just fixed.

Quite frankly, I think commit 0cda4c023132 ("perf: Introduce
perf_pmu_migrate_context()") is unfixably broken. The whole thing
needs to be re-thought. It violates everything that everybody else
does with the context. No amount of (sane) locking can fix the
breakage, I suspect.

A possible (but unfortunate) real fix is to try to keep the broken
code around, and make its broken assumptions be actually true. Make
"event->ctx" truly be an RCU pointer. Add the RCU annotations, add the
required rcu read-locking, and make everything really do what that
currently completely broken perf_pmu_migrate_context() thinks it does.

   That implies, for example, that any time you use the thing in a
sleeping context, you'd need to do something like this (possibly with
a helper function to do that: "get_event_ctx()"

        rcu_read_lock();
        ctx = rcu_dereference(event->rcu);
        get_ctx(ctx);
        rcu_read_unlock();

        .. you can now sleep here and use 'ctx' ...

        put_ctx(ctx);

    and if you don't need to sleep, you can just do

        rcu_read_lock();
        ctx = rcu_dereference(event->ctx);
        .. use ctx in an atomic context ...
        rcu_read_unlock();

but that is a much bigger patch than either of the "introduce a
completely broken ad-hoc lock around just one random use case"
patches.

Alternatively (and this sounds like the better fix), use some way to
avoid that broken perf_pmu_migrate_context() model entirely. Never
"migrate" events. Create completely new ones on the new CPU, and leave
the old stale ones alone even on dead CPU's (they will presumably not
actually be activated, and who the hell cares?).

Or even just say: "if somebody takes down a CPU with existing uncore
events, those events are now effectively dead". Don't try to migrate
them, don't try to create new events on another CPU, just let it go.
The CPU is down, the events are inactive.

Keep it simple. Not the current completely broken thing that clearly
doesn't honor the actual real rules for "event->ctx". Because the
current rules are effectively that event->ctx is a constant over the
whole lifetime of the event. Agreed?

                    Linus
