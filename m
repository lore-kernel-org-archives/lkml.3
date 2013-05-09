Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3EIFrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42733 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3EIFrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:17 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-94-518b3863cfd6
Subject: [PATCH 08/11] tracing/kprobes: Increment probe hit-count even if it
 is used by perf
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:36 +0900
Message-ID: <20130509054436.30398.21133.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment probe hit-count for profiling even if it is used
by perf tool. Same thing has already done in trace_uprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_kprobe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0b7386a..6e86fbb 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -733,8 +733,6 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
-	tp->nhit++;
-
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -767,8 +765,6 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
-	tp->nhit++;
-
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -1075,6 +1071,8 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 
+	tp->nhit++;
+
 	if (tp->flags & TP_FLAG_TRACE)
 		kprobe_trace_func(kp, regs);
 #ifdef CONFIG_PERF_EVENTS
@@ -1089,6 +1087,8 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 
+	tp->nhit++;
+
 	if (tp->flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(ri, regs);
 #ifdef CONFIG_PERF_EVENTS

