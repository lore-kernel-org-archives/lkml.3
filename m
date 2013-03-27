Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3C0Kne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3C0Knd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:43:33 -0400
Date: Wed, 27 Mar 2013 11:42:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327104256.GB1092@krava.brq.redhat.com>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <87ip4dgz31.fsf@sejong.aot.lge.com>
 <20130327094932.GA8385@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327094932.GA8385@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:49:32AM +0100, Borislav Petkov wrote:
> On Wed, Mar 27, 2013 at 03:02:10PM +0900, Namhyung Kim wrote:
> > > --
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index 7b4a55d41efc..f3bb3384a106 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -4455,8 +4455,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
> > >  next:
> > >  		put_cpu_ptr(pmu->pmu_cpu_context);
> > >  	}
> > > +
> > > +	preempt_disable();
> > >  	if (task_event->task_ctx)
> > >  		perf_event_task_ctx(task_event->task_ctx, task_event);
> > > +	preempt_enable();
> 
> Ok, just for my own understanding: how do the events on the
> ->task_ctx->event_list relate to the current cpu in this path? I mean,
> we're on the task exit path here so is it possible to be rescheduled
> somewhere else and the check in event_filter_match to become
> meaningless?
> 
> Because with this fix, we have a small window between enabling
> preemption after the last pmu context and disabling it again to get
> moved somewhere else.

hm, at that point we have 'task_event->task_ctx' detached from
the task and all events on it are owned by the task

so I wonder maybe we could eliminate the preempt switch and make
a special case for task context, saying all event match for it,
something like in patch below (untested)

because if we keep the check we could endup with no EXIT event,
just because the exit code was scheduled on another cpu
(for task events with specified cpu)

also that's probably what we want to do in here - send EXIT
event for any task event that asked for it

the output code in perf_event_task_output is guarding
the preemption by itself

jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b4a55d..8414bcf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4403,12 +4403,12 @@ out:
 	task_event->event_id.header.size = size;
 }
 
-static int perf_event_task_match(struct perf_event *event)
+static int perf_event_task_match(struct perf_event *event, int match)
 {
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (!event_filter_match(event))
+	if (!match && !event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4419,12 +4419,13 @@ static int perf_event_task_match(struct perf_event *event)
 }
 
 static void perf_event_task_ctx(struct perf_event_context *ctx,
-				  struct perf_task_event *task_event)
+				  struct perf_task_event *task_event,
+				int match)
 {
 	struct perf_event *event;
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_task_match(event))
+		if (perf_event_task_match(event, match))
 			perf_event_task_output(event, task_event);
 	}
 }
@@ -4441,7 +4442,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		if (cpuctx->unique_pmu != pmu)
 			goto next;
-		perf_event_task_ctx(&cpuctx->ctx, task_event);
+		perf_event_task_ctx(&cpuctx->ctx, task_event, 0);
 
 		ctx = task_event->task_ctx;
 		if (!ctx) {
@@ -4450,13 +4451,13 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 				goto next;
 			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
 			if (ctx)
-				perf_event_task_ctx(ctx, task_event);
+				perf_event_task_ctx(ctx, task_event, 0);
 		}
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
 	if (task_event->task_ctx)
-		perf_event_task_ctx(task_event->task_ctx, task_event);
+		perf_event_task_ctx(task_event->task_ctx, task_event, 1);
 
 	rcu_read_unlock();
 }
