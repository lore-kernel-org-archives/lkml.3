Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaB0MbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:31:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53630 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbaB0MbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:31:02 -0500
Date: Thu, 27 Feb 2014 12:30:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 7/7] perf: kill perf_event_context::pmu
Message-ID: <20140227123035.GA8647@e106331-lin.cambridge.arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
 <20140210181026.GD27965@twins.programming.kicks-ass.net>
 <20140211175651.GA15200@e106331-lin.cambridge.arm.com>
 <20140225113100.GN9987@twins.programming.kicks-ass.net>
 <20140227114805.GG6945@e106331-lin.cambridge.arm.com>
 <20140227115143.GC9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227115143.GC9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:51:43AM +0000, Peter Zijlstra wrote:
> On Thu, Feb 27, 2014 at 11:48:05AM +0000, Mark Rutland wrote:
> > On Tue, Feb 25, 2014 at 11:31:00AM +0000, Peter Zijlstra wrote:
> > > On Tue, Feb 11, 2014 at 05:56:51PM +0000, Mark Rutland wrote:
> > > > Another option would be to have a context per-pmu. Each context's pmu
> > > > pointer would be valid, and (other than the case of software events) it
> > > > doesn't make sense to place events from disparate PMUs into the same
> > > > group anyway. Then you don't need a fixed sized pmu list in the context
> > > > or some arcane list structs.
> > > 
> > > No it does make sense; for example on hardware that doesn't have a PMI
> > > you can create a software event + hardware event group and have the
> > > software interrupt read the hardware counter and still get 'some'
> > > sampling.
> > 
> > Sure, I called out software events as an exception above.
> 
> Oh sorry missed that.
> 
> > Does it ever make sense to group two hardware events for disparate
> > hardware PMUs?
> 
> No, and I think we disallow that. We only explicitly allow software
> events/groups to move to !software context.

As you say, other than the sw leader, hw follower case we currently
check that event->ctx is equivalent. This works for homogeneous PMUs, as
we only ever have one PMU in any task's
perf_event_ctxp[perf_hw_context].

In the heterogeneous PMU case multiple CPU PMUs can share the
perf_hw_context in a task, so the check for context equivalence is not
sufficient.

I can hide the check in the architecture backend, or we could try to
make the core code be more picky with something like the below.

---->8----
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..a4b6f80 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7135,6 +7135,8 @@ SYSCALL_DEFINE5(perf_event_open,
                        if (group_leader->ctx->type != ctx->type)
                                goto err_context;
                } else {
+                       if (group_leader->pmu != pmu)
+                               goto err_context;
                        if (group_leader->ctx != ctx)
                                goto err_context;
                }
---->8----

Cheers,
Mark.
