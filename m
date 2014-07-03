Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991AbaGCP5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:57:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:35818 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932239AbaGCP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:57:41 -0400
Date: Thu, 3 Jul 2014 11:57:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] tracing/uprobes: Various fixes
Message-ID: <20140703115738.6f5c8eda@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Oleg Nesterov found and fixed a bug in the perf/ftrace/uprobes code where
running:

   # perf probe -x /lib/libc.so.6 syscall
   # echo 1 >> /sys/kernel/debug/tracing/events/probe_libc/enable
   # perf record -e probe_libc:syscall whatever

kills the uprobe. Along the way he found some other minor bugs and clean ups
that he fixed up making it a total of 4 patches.

Doing unrelated work, I found that the reading of the ftrace trace
file disables all function tracer callbacks. This was fine when ftrace
was the only user, but now that it's used by perf and kprobes, this
is a bug where reading trace can disable kprobes and perf. A very unexpected
side effect and should be fixed.

Please pull the latest trace-fixes-v3.16-rc3 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.16-rc3

Tag SHA1: ff029a4ecb5ecfc316bb258534805f1a242e0616
Head SHA1: 099ed151675cd1d2dbeae1dac697975f6a68716d


Oleg Nesterov (4):
      tracing/uprobes: Revert "Support mix of ftrace and perf"
      uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
      tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in uprobe_dispatcher()
      tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_event_enable()

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

----
 kernel/events/uprobes.c     |  6 +++---
 kernel/trace/trace.c        |  2 --
 kernel/trace/trace_uprobe.c | 46 ++++++++++++++++++++++++++-------------------
 3 files changed, 30 insertions(+), 24 deletions(-)
---------------------------
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c445e392e93f..6f3254e8c137 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -846,7 +846,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
 {
 	int err;
 
-	if (!consumer_del(uprobe, uc))	/* WARN? */
+	if (WARN_ON(!consumer_del(uprobe, uc)))
 		return;
 
 	err = register_for_each_vma(uprobe, NULL);
@@ -927,7 +927,7 @@ int uprobe_apply(struct inode *inode, loff_t offset,
 	int ret = -ENOENT;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return ret;
 
 	down_write(&uprobe->register_rwsem);
@@ -952,7 +952,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	struct uprobe *uprobe;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return;
 
 	down_write(&uprobe->register_rwsem);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..f243444a3772 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1396,7 +1396,6 @@ void tracing_start(void)
 
 	arch_spin_unlock(&global_trace.max_lock);
 
-	ftrace_start();
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
 }
@@ -1443,7 +1442,6 @@ void tracing_stop(void)
 	struct ring_buffer *buffer;
 	unsigned long flags;
 
-	ftrace_stop();
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
 	if (global_trace.stop_count++)
 		goto out;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 04fdb5de823c..3c9b97e6b1f4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -893,6 +893,9 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 	int ret;
 
 	if (file) {
+		if (tu->tp.flags & TP_FLAG_PROFILE)
+			return -EINTR;
+
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -901,29 +904,40 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		list_add_tail_rcu(&link->list, &tu->tp.files);
 
 		tu->tp.flags |= TP_FLAG_TRACE;
-	} else
-		tu->tp.flags |= TP_FLAG_PROFILE;
+	} else {
+		if (tu->tp.flags & TP_FLAG_TRACE)
+			return -EINTR;
 
-	ret = uprobe_buffer_enable();
-	if (ret < 0)
-		return ret;
+		tu->tp.flags |= TP_FLAG_PROFILE;
+	}
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	if (enabled)
 		return 0;
 
+	ret = uprobe_buffer_enable();
+	if (ret)
+		goto err_flags;
+
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret) {
-		if (file) {
-			list_del(&link->list);
-			kfree(link);
-			tu->tp.flags &= ~TP_FLAG_TRACE;
-		} else
-			tu->tp.flags &= ~TP_FLAG_PROFILE;
-	}
+	if (ret)
+		goto err_buffer;
 
+	return 0;
+
+ err_buffer:
+	uprobe_buffer_disable();
+
+ err_flags:
+	if (file) {
+		list_del(&link->list);
+		kfree(link);
+		tu->tp.flags &= ~TP_FLAG_TRACE;
+	} else {
+		tu->tp.flags &= ~TP_FLAG_PROFILE;
+	}
 	return ret;
 }
 
@@ -1201,12 +1215,6 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 
 	current->utask->vaddr = (unsigned long) &udd;
 
-#ifdef CONFIG_PERF_EVENTS
-	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
-	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
-		return UPROBE_HANDLER_REMOVE;
-#endif
-
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
 		return 0;
 
