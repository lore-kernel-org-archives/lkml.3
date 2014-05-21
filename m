Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaEUPaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:30:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaEUPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:30:15 -0400
Date: Wed, 21 May 2014 17:30:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
Message-ID: <20140521153013.GG5226@laptop.programming.kicks-ass.net>
References: <20140521150613.GA28702@redhat.com>
 <20140521151655.GG2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521151655.GG2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 05:16:55PM +0200, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 11:06:13AM -0400, Dave Jones wrote:
> > I thought we had this nailed down a while ago, but it still keeps
> > popping up...
> > 
> > WARNING: CPU: 3 PID: 32310 at kernel/events/core.c:2384 task_ctx_sched_out+0x6b/0x80()
> > CPU: 3 PID: 32310 Comm: trinity-c185 Not tainted 3.15.0-rc5+ #214
> >  0000000000000009 000000003d7dfb5c ffff880019671df8 ffffffff9371a1fd
> >  0000000000000000 ffff880019671e30 ffffffff9306d5dd ffff88024d0d6d48
> >  ffff88010c4944e8 0000000000000286 ffff880243b82d00 ffff88010c4944e8
> > Call Trace:
> >  [<ffffffff9371a1fd>] dump_stack+0x4e/0x7a
> >  [<ffffffff9306d5dd>] warn_slowpath_common+0x7d/0xa0
> >  [<ffffffff9306d70a>] warn_slowpath_null+0x1a/0x20
> >  [<ffffffff931430bb>] task_ctx_sched_out+0x6b/0x80
> >  [<ffffffff93146138>] perf_event_comm+0xc8/0x220
> >  [<ffffffff930a19cd>] ? get_parent_ip+0xd/0x50
> >  [<ffffffff931c025f>] set_task_comm+0x4f/0xc0
> >  [<ffffffff93085b23>] SyS_prctl+0x1d3/0x480
> >  [<ffffffff9372cf9f>] tracesys+0xdd/0xe2
> > 
> > There was on perf activity at all going on at the time.
> > I had told trinity to do -g vm which excludes all non-VM related syscalls.
> > 
> > What is perf_event_comm doing ? Is that storing some state in case
> > I later decide to run perf ?
> 
> So we use perf_event_comm() to trigger start_on_exec, which in turn
> pretty much assumes .tsk=current.
> 
> Now some people have advanced set_task_comm() usage far beyond this
> point and we can now pretty much call it on random tasks at random times
> in order to make 'top' look pretty or similar useless things.
> 
> So I think I should separate this and add perf_event_exec() and leave
> perf_event_comm() for just reporting task->comm changes.

A little something like so I suppose.

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
index 7ab734fbaeeb..e46ae0635dca 100644
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
+		ctx = task->perf_event_ctxp[ctxn];
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
