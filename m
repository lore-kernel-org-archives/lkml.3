Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaEUPcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:32:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaEUPcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:32:23 -0400
Date: Wed, 21 May 2014 17:32:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
Message-ID: <20140521153219.GH5226@laptop.programming.kicks-ass.net>
References: <20140521150613.GA28702@redhat.com>
 <20140521151655.GG2485@laptop.programming.kicks-ass.net>
 <20140521153013.GG5226@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521153013.GG5226@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 05:30:13PM +0200, Peter Zijlstra wrote:
> A little something like so I suppose.
> 
> ---

> +void perf_event_exec(void)
> +{
> +	struct perf_event_context *ctx;
> +	int ctxn;
> +
> +	rcu_read_lock();
> +	for_each_task_context_nr(ctxn) {
> +		ctx = task->perf_event_ctxp[ctxn];

s/task/current/

> +		if (!ctx)
> +			continue;
> +
> +		perf_event_enable_on_exec(ctx);
> +	}
> +	rcu_read_unlock();
> +}


It would help if I pasted the one that actually compiles I suppose..

---
 fs/exec.c                  |  1 +
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 28 ++++++++++++++++------------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 476f3ebf437e..8d51d7ce3dcf 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1111,6 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, suid_dumpable);
 
 	set_task_comm(current, kbasename(bprm->filename));
+	perf_event_exec();
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index af6dcf1d9e47..5975d68a3fe6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -694,6 +694,7 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
+extern void perf_event_exec(void);
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7ab734fbaeeb..59382cfc87a1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2973,6 +2973,22 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	local_irq_restore(flags);
 }
 
+void perf_event_exec(void)
+{
+	struct perf_event_context *ctx;
+	int ctxn;
+
+	rcu_read_lock();
+	for_each_task_context_nr(ctxn) {
+		ctx = current->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
+
+		perf_event_enable_on_exec(ctx);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Cross CPU call to read the hardware event
  */
@@ -5070,18 +5086,6 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 void perf_event_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
-	struct perf_event_context *ctx;
-	int ctxn;
-
-	rcu_read_lock();
-	for_each_task_context_nr(ctxn) {
-		ctx = task->perf_event_ctxp[ctxn];
-		if (!ctx)
-			continue;
-
-		perf_event_enable_on_exec(ctx);
-	}
-	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;
