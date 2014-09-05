Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaIERAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:00:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaIERAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:00:48 -0400
Date: Fri, 5 Sep 2014 17:59:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140905165956.GA28623@leverpostej>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
 <20140903115013.GA3127@leverpostej>
 <20140904104402.GS4783@worktop.ger.corp.intel.com>
 <20140904110740.GB32228@leverpostej>
 <20140905151640.GN19379@twins.programming.kicks-ass.net>
 <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
Thread-Topic: Possible race between CPU hotplug and perf_pmu_migrate_context
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:41:43PM +0100, Linus Torvalds wrote:
> On Fri, Sep 5, 2014 at 8:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > How horrible is the below patch (performance wise). It does pretty much
> > the same thing except that percpu_rw_semaphore is a lot saner, its
> > read side performance should be minimal in the absence of writes.
> 
> Ugh. Why do any locking at all (whether a new 'perf_rwsem' or using
> 'get_online_cpus()').
> 
> Wouldn't it be much nicer to just do what memory management routines
> are *supposed* to do, and get a reference count to the context while
> having a pointer to it?
> 
> IOW, why doesn't put_event() just have a
> 
>    get_ctx(ctx);
>    ..
>    put_ctx(ctx);
> 
> around its use of the context pointer? So if the context ends up being
> migrated during this time, it doesn't get freed.

For the duration of put_event, the event holds a ref on the context. That only
gets decremented _after_ we're done dealing with event->ctx, at the very end of
put_event. Follow the callchain:

	put_event(event)
	-> _free_event(event)
	-> __free_event(event)
	-> put_ctx(event->ctx).

As you point out below, the race on event->ctx is the fundamental issue. That
is what results in decrementing the refcount twice (once on a stale event->ctx
pointer).

> However, the more fundamental question is "what protects accesses to
> 'events->ctx'". Why is "put_event()" so special that *it* gets locking
> for the reading of "event->ctx", but none of the other cases of
> reading the ctx pointer gets it or needs it?

The key point is that it doesn't, which is precisely what this patch attempted
to correct. 

Regardless you're right that other uses of event->ctx are just as broken.  What
perf_pmu_migrate_context failed to take into account was that it is possible to
access an event without going via its owning context and holding ctx->mutex.

> I'm getting the feeling that this race is bigger than just put_event().

We certainly have at least one more race; for event groups perf_read can lock
the stale context.

Mark.
