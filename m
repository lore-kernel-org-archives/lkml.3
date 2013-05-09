Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3EIFr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:29 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58052 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3EIFr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:26 -0400
X-AuditID: 85900ec0-d60ccb900000151e-95-518b386b1e3c
Subject: [PATCH 09/11] tracing/kprobes: Pass trace_probe directly from
 dispatcher
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:41 +0900
Message-ID: <20130509054441.30398.69112.stgit@mhiramat-M0-7522>
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

Pass the pointer of struct trace_probe directly from probe
dispatcher to handlers. This removes redundant container_of
macro uses. Same thing has already done in trace_uprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_kprobe.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6e86fbb..9ca44fc 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -723,9 +723,9 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 }
 
 /* Kprobe handler */
-static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
+static __kprobes void
+kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -745,7 +745,7 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->ip = (unsigned long)kp->addr;
+	entry->ip = (unsigned long)tp->rp.kp.addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
@@ -754,10 +754,10 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 }
 
 /* Kretprobe handler */
-static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
-					  struct pt_regs *regs)
+static __kprobes void
+kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		     struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -973,10 +973,9 @@ static int set_print_fmt(struct trace_probe *tp)
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes void kprobe_perf_func(struct kprobe *kp,
-					 struct pt_regs *regs)
+static __kprobes void
+kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
 	struct hlist_head *head;
@@ -995,7 +994,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	if (!entry)
 		return;
 
-	entry->ip = (unsigned long)kp->addr;
+	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
@@ -1005,10 +1004,10 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 }
 
 /* Kretprobe profile handler */
-static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
-					    struct pt_regs *regs)
+static __kprobes void
+kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		    struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
 	struct hlist_head *head;
@@ -1074,10 +1073,10 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 	tp->nhit++;
 
 	if (tp->flags & TP_FLAG_TRACE)
-		kprobe_trace_func(kp, regs);
+		kprobe_trace_func(tp, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kprobe_perf_func(kp, regs);
+		kprobe_perf_func(tp, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1090,10 +1089,10 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 	tp->nhit++;
 
 	if (tp->flags & TP_FLAG_TRACE)
-		kretprobe_trace_func(ri, regs);
+		kretprobe_trace_func(tp, ri, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kretprobe_perf_func(ri, regs);
+		kretprobe_perf_func(tp, ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }

