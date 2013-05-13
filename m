Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3EMMBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:01:16 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43841 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3EMMBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:13 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-a1-5190d6063561
Subject: [PATCH 1/3] [BUGFIX] tracing/kprobes: Use rcu_dereference_raw for
 tp->files
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Mon, 13 May 2013 20:58:34 +0900
Message-ID: <20130513115834.6545.17022.stgit@mhiramat-M0-7522>
In-Reply-To: <20130513115824.6545.47677.stgit@mhiramat-M0-7522>
References: <20130513115824.6545.47677.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcu_dereference_raw() for accessing tp->files. Because the
write-side uses rcu_assign_pointer() for memory barrier,
the read-side also has to use rcu_dereference_raw() with
read memory barrier.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kprobe.c |   47 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 636d45f..0a3d8d5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -185,9 +185,14 @@ static struct trace_probe *find_trace_probe(const char *event,
 
 static int trace_probe_nr_files(struct trace_probe *tp)
 {
-	struct ftrace_event_file **file = tp->files;
+	struct ftrace_event_file **file;
 	int ret = 0;
 
+	/*
+	 * Since all tp->files updater is protected by probe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	file = rcu_dereference_raw(tp->files);
 	if (file)
 		while (*(file++))
 			ret++;
@@ -209,9 +214,10 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	mutex_lock(&probe_enable_lock);
 
 	if (file) {
-		struct ftrace_event_file **new, **old = tp->files;
+		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
 
+		old = rcu_dereference_raw(tp->files);
 		/* 1 is for new one and 1 is for stopper */
 		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
 			      GFP_KERNEL);
@@ -251,11 +257,17 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 static int
 trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
 {
+	struct ftrace_event_file **files;
 	int i;
 
-	if (tp->files) {
-		for (i = 0; tp->files[i]; i++)
-			if (tp->files[i] == file)
+	/*
+	 * Since all tp->files updater is protected by probe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	files = rcu_dereference_raw(tp->files);
+	if (files) {
+		for (i = 0; files[i]; i++)
+			if (files[i] == file)
 				return i;
 	}
 
@@ -274,10 +286,11 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	mutex_lock(&probe_enable_lock);
 
 	if (file) {
-		struct ftrace_event_file **new, **old = tp->files;
+		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
 		int i, j;
 
+		old = rcu_dereference_raw(tp->files);
 		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
 			ret = -EINVAL;
 			goto out_unlock;
@@ -872,9 +885,16 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 static __kprobes void
 kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct ftrace_event_file **file = tp->files;
+	/*
+	 * Note: preempt is already disabled around the kprobe handler.
+	 * However, we still need an smp_read_barrier_depends() corresponding
+	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
+	 */
+	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
+
+	if (unlikely(!file))
+		return;
 
-	/* Note: preempt is already disabled around the kprobe handler */
 	while (*file) {
 		__kprobe_trace_func(tp, regs, *file);
 		file++;
@@ -925,9 +945,16 @@ static __kprobes void
 kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
-	struct ftrace_event_file **file = tp->files;
+	/*
+	 * Note: preempt is already disabled around the kprobe handler.
+	 * However, we still need an smp_read_barrier_depends() corresponding
+	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
+	 */
+	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
+
+	if (unlikely(!file))
+		return;
 
-	/* Note: preempt is already disabled around the kprobe handler */
 	while (*file) {
 		__kretprobe_trace_func(tp, ri, regs, *file);
 		file++;

