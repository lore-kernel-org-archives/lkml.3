Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbbAWPXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:23:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41916 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:23:23 -0500
Date: Fri, 23 Jan 2015 15:22:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/3] perf: Tighten (and fix) the grouping condition
Message-ID: <20150123152257.GB6091@leverpostej>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.090683288@infradead.org>
 <20150123150211.GA6091@leverpostej>
 <20150123150716.GN2896@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123150716.GN2896@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:07:16PM +0000, Peter Zijlstra wrote:
> On Fri, Jan 23, 2015 at 03:02:12PM +0000, Mark Rutland wrote:
> > On Fri, Jan 23, 2015 at 12:52:00PM +0000, Peter Zijlstra wrote:
> > > The fix from 9fc81d87420d ("perf: Fix events installation during
> > > moving group") was incomplete in that it failed to recognise that
> > > creating a group with events for different CPUs is semantically
> > > broken -- they cannot be co-scheduled.
> > > 
> > > Furthermore, it leads to real breakage where, when we create an event
> > > for CPU Y and then migrate it to form a group on CPU X, the code gets
> > > confused where the counter is programmed -- triggered by the fuzzer.
> > > 
> > > Fix this by tightening the rules for creating groups. Only allow
> > > grouping of counters that can be co-scheduled in the same context.
> > > This means for the same task and/or the same cpu.
> > 
> > It seems this would still allow you to group CPU-affine software and
> > uncore events, which also doesn't make sense: the software events will
> > count on a single CPU while the uncore events aren't really CPU-affine.
> > 
> > Which isn't anything against this patch, but probably something we
> > should tighten up too.
> 
> Indeed, that would need a wee bit of extra infrastructure though; as we
> cannot currently distinguish between regular cpuctx and uncore like
> things.

Isn't the event->pmu->task_ctx_nr sufficient, as with how we identify
software events?

Or am I making some completely bogus assumptions in the diff below?

Mark.

---->8----
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 664de5a..7b945d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -657,6 +657,15 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
+/*
+ * Return 1 for an event which is associated with neither a particular
+ * CPU nor a particular task.
+ */
+static inline int is_system_event(struct perf_event *event)
+{
+	return event->pmu->task_ctx_nr == perf_invalid_context;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2cb857d..50c42b6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7525,6 +7525,18 @@ SYSCALL_DEFINE5(perf_event_open,
 	account_event(event);
 
 	/*
+	 * System-wide (A.K.A. "uncore") events cannot be associated with a
+	 * particular CPU, and hence cannot be associated with a particular
+	 * task either. It's non-sensical to group them with other event types,
+	 * which are CPU or task bound.
+	 */
+	if (group_leader &&
+		(is_system_event(event) != is_system_event(group_leader))) {
+		err = -EINVAL;
+		goto err_alloc;
+	}
+
+	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
 	 */

