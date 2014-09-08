Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIHJoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbaIHJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:44:41 -0400
Date: Mon, 8 Sep 2014 11:43:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908094348.GB1172@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902105036.GH5806@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:50:36PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 25, 2014 at 04:45:35PM +0200, Jiri Olsa wrote:
> > As described in commit:
> >   1f9a7268c67f perf: Do not allow optimized switch for non-cloned events
> > we dont allow optimized switch for non cloned contexts.
> > 
> > There's no need now to check if one of the context is parent
> > of the other in context_equiv function.
> > 
> 
> OK, so talk to me about that patch; it looks like you're slowly
> reverting: 5a3126d4fe7c ("perf: Fix the perf context switch
> optimization").
> 
> So what exactly is the problem? I'm still jet-lagged and not seeing it.

the problem is, that we cannot allow non-cloned context
to be part of the optimized switch for reasons explained
in commit 1f9a7268c67f

I did not realize there was a just single commit introducing
non-cloned context switch to revert ;-) attached

I haven't tested it yet.. will do with my other changes

thanks,
jirka


---
This reverts commit 5a3126d4fe7c311fe12f98fef0470f6cb582d1ef.

As explained in commit:
  1f9a7268c67f perf: Do not allow optimized switch for non-cloned events

we cannot allow optimized switch for non cloned contexts. It
suppressed it by forcing the condition for parent contexts.

But what we actually should do is to revert the full commit that
introduced the optimized switch for non-cloned contexts.
This way we get rid of unneeded (now) ctx->generation updates
for non-cloned contexts.
---
 kernel/events/core.c | 64 +++++++++++++++-------------------------------------
 1 file changed, 18 insertions(+), 46 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8cb4d21a346..424e6d3b07b7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -916,7 +916,6 @@ static void unclone_ctx(struct perf_event_context *ctx)
 		put_ctx(ctx->parent_ctx);
 		ctx->parent_ctx = NULL;
 	}
-	ctx->generation++;
 }
 
 static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
@@ -1154,8 +1153,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
-
-	ctx->generation++;
 }
 
 /*
@@ -1333,8 +1330,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 */
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
-
-	ctx->generation++;
 }
 
 static void perf_group_detach(struct perf_event *event)
@@ -2243,38 +2238,22 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 }
 
 /*
- * Test whether two contexts are equivalent, i.e. whether they have both been
- * cloned from the same version of the same context.
- *
- * Equivalence is measured using a generation number in the context that is
- * incremented on each modification to it; see unclone_ctx(), list_add_event()
- * and list_del_event().
+ * Test whether two contexts are equivalent, i.e. whether they
+ * have both been cloned from the same version of the same context
+ * and they both have the same number of enabled events.
+ * If the number of enabled events is the same, then the set
+ * of enabled events should be the same, because these are both
+ * inherited contexts, therefore we can't access individual events
+ * in them directly with an fd; we can only enable/disable all
+ * events via prctl, or enable/disable all events in a family
+ * via ioctl, which will have the same effect on both contexts.
  */
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
-	/* Pinning disables the swap optimization */
-	if (ctx1->pin_count || ctx2->pin_count)
-		return 0;
-
-	/* If ctx1 is the parent of ctx2 */
-	if (ctx1 == ctx2->parent_ctx && ctx1->generation == ctx2->parent_gen)
-		return 1;
-
-	/* If ctx2 is the parent of ctx1 */
-	if (ctx1->parent_ctx == ctx2 && ctx1->parent_gen == ctx2->generation)
-		return 1;
-
-	/*
-	 * If ctx1 and ctx2 have the same parent; we flatten the parent
-	 * hierarchy, see perf_event_init_context().
-	 */
-	if (ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx &&
-			ctx1->parent_gen == ctx2->parent_gen)
-		return 1;
-
-	/* Unmatched */
-	return 0;
+	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
+		&& ctx1->parent_gen == ctx2->parent_gen
+		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
 static void __perf_event_sync_stat(struct perf_event *event,
@@ -2354,7 +2333,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 {
 	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
 	struct perf_event_context *next_ctx;
-	struct perf_event_context *parent, *next_parent;
+	struct perf_event_context *parent;
 	struct perf_cpu_context *cpuctx;
 	int do_switch = 1;
 
@@ -2366,18 +2345,10 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		return;
 
 	rcu_read_lock();
-	next_ctx = next->perf_event_ctxp[ctxn];
-	if (!next_ctx)
-		goto unlock;
-
 	parent = rcu_dereference(ctx->parent_ctx);
-	next_parent = rcu_dereference(next_ctx->parent_ctx);
-
-	/* If neither context have a parent context; they cannot be clones. */
-	if (!parent || !next_parent)
-		goto unlock;
-
-	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
+	next_ctx = next->perf_event_ctxp[ctxn];
+	if (parent && next_ctx &&
+	    rcu_dereference(next_ctx->parent_ctx) == parent) {
 		/*
 		 * Looks like the two contexts are clones, so we might be
 		 * able to optimize the context switch.  We lock both
@@ -2405,7 +2376,6 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_unlock(&next_ctx->lock);
 		raw_spin_unlock(&ctx->lock);
 	}
-unlock:
 	rcu_read_unlock();
 
 	if (do_switch) {
@@ -7398,6 +7368,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	perf_install_in_context(ctx, event, event->cpu);
+	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -7484,6 +7455,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
+	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
-- 
1.8.3.1

