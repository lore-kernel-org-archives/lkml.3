Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3J3J40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:56:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40687 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3J3J4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:56:25 -0400
Date: Wed, 30 Oct 2013 10:56:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@google.com
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131030095615.GG16117@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
 <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:36:52AM -0400, Vince Weaver wrote:
> On Tue, 29 Oct 2013, Peter Zijlstra wrote:
> > On Tue, Oct 29, 2013 at 04:28:10AM +0000, Will Deacon wrote:
> > > 
> > > I can CC LKML on ARM perf patches if you think it will help, but all PMU
> > > backend patches go via their respective arch trees afaict.
> > 
> > Just those that change user visible semantics that are shared between
> > archs I suppose :-)
> 
> I suppose it is hard to know what's commonly shared.  I hadn't realized
> that the IOC_PERIOD stuff was arch specific code, I would have thought
> it was common code.

OK, so I've gone over this and this isn't in fact arch specific at all.
The arch code should simply use ->period to reset the counters, and
stuff the last period into ->last_period.

Aside from that it shouldn't do anything. So what ARM did was actively
wrong.

Esp. since it added code to the common path instead of the uncommon
(ioctl) path.

> > We could start by making all archs do the same thing again; but yes
> > ideally we'd move some of it into generic code. Not entirely sure how
> > that will work out though, there's a reason its in per-arch code :/
> > 
> > 
> > Vince, what would you prefer to do here?
> 
> as with most of thes things there isn't really a good answer.

Yeah, I was afraid of that :/

> It turns out in the end that PAPI isn't bit by this one, because instead 
> of using PERF_EVENT_IOC_PERIOD when the period is changed, PAPI just tears 
> down all the perf_events and re-sets them up from scratch with the new 
> period.  This is probably because PERF_EVENT_IOC_PERIOD was broken until 
> 2.6.36.

Right, it was one of those interfaces that people claimed were
absolutely required so I implemented them but then nobody actually tried
using them for a long while :-(

This is a prime example of why Ingo now insists the perf tools supports
every new interface, we had too many of these incidents.

> It is true the current behavior is unexpected.  What was the logic behind 
> deferring to the next overflow for the update?  Was it a code simplicity 
> thing?  Or were there hardware reasons behind it?

Mostly an oversight I think. The delay is simply how it worked out in
that the arch code has to reload the period once an event fires in order
to reprogram. Since nobody actually used the thing, nobody had
experience with it.

Now it turns out someone had a complaint but hid it somewhere on some
obscure list :-(

There is actually generic code that force resets the period; see
perf_event_period().

> Definitely when an event is stopped, it makes more sense for 
> PERF_EVENT_IOC_PERIOD to take place immediately.  
> 
> I'm not sure what happens if we try to use it on a running event, 
> especially if we've already passed the new period value.

The below code should deal with both cases I think -- completely
untested.

---
 arch/arm/kernel/perf_event.c |  4 ----
 kernel/events/core.c         | 16 +++++++++++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index e186ee1e63f6..4eb288f7ba69 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -99,10 +99,6 @@ int armpmu_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
-	/* The period may have been changed by PERF_EVENT_IOC_PERIOD */
-	if (unlikely(period != hwc->last_period))
-		left = period - (hwc->last_period - left);
-
 	if (unlikely(left <= -period)) {
 		left = period;
 		local64_set(&hwc->period_left, left);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 17b3c6cf1606..c45d53e561da 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3530,7 +3530,7 @@ static void perf_event_for_each(struct perf_event *event,
 static int perf_event_period(struct perf_event *event, u64 __user *arg)
 {
 	struct perf_event_context *ctx = event->ctx;
-	int ret = 0;
+	int ret = 0, active;
 	u64 value;
 
 	if (!is_sampling_event(event))
@@ -3554,6 +3554,20 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 		event->attr.sample_period = value;
 		event->hw.sample_period = value;
 	}
+
+	active = (event->state == PERF_EVENT_STATE_ACTIVE);
+	if (active) {
+		perf_pmu_disable(ctx->pmu);
+		event->pmu->stop(event, PERF_EF_UPDATE);
+	}
+
+	local64_set(event->hw.period_left, 0);
+
+	if (active) {
+		event->pmu->start(event, PERF_EF_RELOAD);
+		perf_pmu_enable(ctx->pmu);
+	}
+
 unlock:
 	raw_spin_unlock_irq(&ctx->lock);
 
