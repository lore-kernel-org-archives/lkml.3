Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3D3P2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab3D3P2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:28:06 -0400
Date: Tue, 30 Apr 2013 17:27:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [RFCv2] Re: BUG: using smp_processor_id() in preemptible [00000000]
 code: asm/8267
Message-ID: <20130430152721.GC12715@krava.brq.redhat.com>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <87ip4dgz31.fsf@sejong.aot.lge.com>
 <20130327094932.GA8385@pd.tnic>
 <1364393372.5053.68.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364393372.5053.68.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:09:32PM +0100, Peter Zijlstra wrote:
> On Wed, 2013-03-27 at 10:49 +0100, Borislav Petkov wrote:
> > Ok, just for my own understanding: how do the events on the
> > ->task_ctx->event_list relate to the current cpu in this path? I mean,
> > we're on the task exit path here so is it possible to be rescheduled
> > somewhere else and the check in event_filter_match to become
> > meaningless?
> 
> Events can be per-cpu, so what could happen is that we'd send the exit
> notification to a cpu we're not actually running on (anymore).
> 
> Furthermore, since we evaluate smp_processor_id() for every
> event_filter_match(), it is possible we'd send the notification to
> multiple events if our task migrates just right.
> 
> Also, I suspect we want something like preempt_disable_notrace() to be
> sure we don't recurse or something daft like that... but I'm not
> entirely sure.

hum, I did not find reason for using the *_notrace stuff in here
also we use preempt_disable indirectly via get_cpu_ptr

sending updated patch.. tests looks ok so far

thanks for comments,
jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 82c01bf..bdcbda8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4459,7 +4459,7 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
 static void perf_event_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *task_ctx = task_event->task_ctx;
 	struct pmu *pmu;
 	int ctxn;
 
@@ -4470,20 +4470,22 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
-		ctx = task_event->task_ctx;
-		if (!ctx) {
-			ctxn = pmu->task_ctx_nr;
-			if (ctxn < 0)
-				goto next;
-			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-			if (ctx)
-				perf_event_task_ctx(ctx, task_event);
-		}
+		if (task_ctx)
+			goto next;
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			goto next;
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx)
+			perf_event_task_ctx(ctx, task_event);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
-	if (task_event->task_ctx)
-		perf_event_task_ctx(task_event->task_ctx, task_event);
+	if (task_ctx) {
+		preempt_disable();
+		perf_event_task_ctx(task_ctx, task_event);
+		preempt_enable();
+	}
 
 	rcu_read_unlock();
 }
