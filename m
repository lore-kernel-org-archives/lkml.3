Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaBLPC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:02:26 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51427 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751218AbaBLPCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:02:25 -0500
Date: Wed, 12 Feb 2014 15:01:49 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 7/7] perf: kill perf_event_context::pmu
Message-ID: <20140212150132.GA2231@e103592.cambridge.arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
 <20140210181026.GD27965@twins.programming.kicks-ass.net>
 <20140211175651.GA15200@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211175651.GA15200@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:56:51PM +0000, Mark Rutland wrote:
> On Mon, Feb 10, 2014 at 06:10:26PM +0000, Peter Zijlstra wrote:
> > On Mon, Feb 10, 2014 at 05:44:24PM +0000, Mark Rutland wrote:
> > > Currently portions of the perf subsystem assume that a
> > > perf_event_context is associated with a single pmu while in reality a
> > > single perf_event_context may be shared by a number of pmus, as commit
> > > 443772776c69 (perf: Disable all pmus on unthrottling and rescheduling)
> > > describes.
> > > 
> > > This patch removes perf_event_context::pmu, replacing it with a direct
> > > pointer to the associated perf_cpu_context and a task_ctx_nr (as all
> > > pmus sharing a context have the same task_ctx_nr). This makes the
> > > relationship between pmus and perf_event_contexts clearer and allows us
> > > to save on some pointer chasing.
> > > 
> > > This also fixes a potential misuse of ctx->pmu introduced in commit
> > > bad7192b842c (perf: Fix PERF_EVENT_IOC_PERIOD to force-reset the
> > > period), where ctx->pmu is disabled before modifying state on
> > > event->pmu. In this case the two pmus are not guaranteed to be the same.
> > > 
> > > As perf_pmu_rotate_{start,stop} only really care about the context they
> > > are rotating, they are renamed to perf_event_ctx_{start,stop}.
> > 
> > This very much relies on the previous patch where you make pmu_disable
> > iterate all the events.
> > 
> > We could also change this to keep a pmu list for each context and
> > iterate that instead. Given there is indeed a fair limit on different
> > PMUs in the system that iteration should be much shorter.
> 
> Another option would be to have a context per-pmu. Each context's pmu
> pointer would be valid, and (other than the case of software events) it
> doesn't make sense to place events from disparate PMUs into the same
> group anyway. Then you don't need a fixed sized pmu list in the context
> or some arcane list structs.

Getting event rotation to work in a sensible way when there are mixtures
of events for different PMUs in a single context.  I've not come up with
a good enough solution for that to post yet.

Splitting out each PMU as a separate hardware context would make this
work a lot more naturally.

Cheers
---Dave
