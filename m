Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3C0OJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:09:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41121
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab3C0OJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:09:47 -0400
Message-ID: <1364393372.5053.68.camel@laptop>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 27 Mar 2013 15:09:32 +0100
In-Reply-To: <20130327094932.GA8385@pd.tnic>
References: <20130324115556.GA4866@pd.tnic> <20130324155924.GB4866@pd.tnic>
	 <20130326183452.GC27518@pd.tnic> <87ip4dgz31.fsf@sejong.aot.lge.com>
	 <20130327094932.GA8385@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 10:49 +0100, Borislav Petkov wrote:
> Ok, just for my own understanding: how do the events on the
> ->task_ctx->event_list relate to the current cpu in this path? I mean,
> we're on the task exit path here so is it possible to be rescheduled
> somewhere else and the check in event_filter_match to become
> meaningless?

Events can be per-cpu, so what could happen is that we'd send the exit
notification to a cpu we're not actually running on (anymore).

Furthermore, since we evaluate smp_processor_id() for every
event_filter_match(), it is possible we'd send the notification to
multiple events if our task migrates just right.

Also, I suspect we want something like preempt_disable_notrace() to be
sure we don't recurse or something daft like that... but I'm not
entirely sure.

---
 kernel/events/core.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b4a55d..0097d81 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4444,19 +4444,22 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
 		ctx = task_event->task_ctx;
-		if (!ctx) {
-			ctxn = pmu->task_ctx_nr;
-			if (ctxn < 0)
-				goto next;
-			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-			if (ctx)
-				perf_event_task_ctx(ctx, task_event);
-		}
+		if (ctx)
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
+	if (task_event->task_ctx) {
+		preempt_disable_notrace();
 		perf_event_task_ctx(task_event->task_ctx, task_event);
+		preempt_enable_notrace();
+	}
 
 	rcu_read_unlock();
 }


