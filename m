Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIDLId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:08:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbaIDLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:08:32 -0400
Date: Thu, 4 Sep 2014 12:07:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140904110740.GB32228@leverpostej>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
 <20140903115013.GA3127@leverpostej>
 <20140904104402.GS4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904104402.GS4783@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:44:02AM +0100, Peter Zijlstra wrote:
> On Wed, Sep 03, 2014 at 12:50:14PM +0100, Mark Rutland wrote:
> > From 6465beace3ad9b12039127468f4596b8e87a53e8 Mon Sep 17 00:00:00 2001
> > From: Mark Rutland <mark.rutland@arm.com>
> > Date: Wed, 3 Sep 2014 11:06:22 +0100
> > Subject: [PATCH] perf: prevent hotplug race on event->ctx
> > 
> > The perf_pmu_migrate_context code introduced in 0cda4c023132 (perf:
> > Introduce perf_pmu_migrate_context()) didn't take the tear-down of
> > events into account, and left open a race with put_event on event->ctx.
> > A resulting duplicate put_ctx of an event's original context can lead to
> > the context being erroneously kfreed via RCU, resulting in the below
> > splat with the intel uncore_imc PMU driver:
> 
> <snip>
> 
> > In response to a CPU notifier an uncore PMU driver calls
> > perf_pmu_migrate context, which will remove all events from the old CPU
> > context before placing them all into the new CPU context. For a short
> > period the events are in limbo and are part of neither context, though
> > their event->ctx pointers still point at the old context.
> > 
> > During this period another CPU may enter put_event, which will try to
> > remove the event from event->ctx. As this may still point at the old
> > context, put_ctx can be called twice for a given event on the original
> > context. The context's refcount may drop to zero unexpectedly, whereupon
> > put_ctx will queue up a kfree with RCU. This blows up at the end of the
> > next grace period as the uncore PMU contexts are housed within
> > perf_cpu_context and weren't directly allocated with k*alloc.
> > 
> > This patch prevents the issue by inhibiting hotplug for the portion of
> > put_event which must access event->ctx, preventing the notifiers which
> > call perf_pmu_migrate_context from running concurrently. Once the event
> > has been removed from its context perf_pmu_migrate_context will no
> > longer be able to access it, so it is not necessary to inhibit hotplug
> > for the duration of event tear-down.
> 
> Right, so that works I suppose. The thing is, get_online_cpus() is a
> global lock and we can potentially do a lot of put_event()s. I had a
> patch a while back that rewrote the cpuhotplug locking, but Linus didn't
> particularly like that at the time.

Yeah, calling {get,put}_online_cpus() is far from ideal.

When testing open/close and hotplug had a rather noticeable effect on
each others' progress (per visible rate of output over serial, I didn't
make any actual measurements). Killing a few tasks with ~1024 events
open each would crawl to completion over a few seconds.

> I'll try and see if I can come up with anything else, but so far I've
> only discovered a lot of ways that don't work (like I'm sure you did
> too).

Yup; ABBA deadlock or too many/few put_ctx(old_ctx) calls.

Thanks for taking a look. If you have any ideas I'm happy to try another
approach.

Mark.
