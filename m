Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3EVCWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:22:11 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45493 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3EVCWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:22:08 -0400
X-AuditID: 85900ec0-d60ccb900000151e-80-519c2bcd11fb
Subject: [PATCH v2 4/5] tracing/kprobes: Allow user to delete kprobe events by
 wild cards
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Wed, 22 May 2013 11:19:17 +0900
Message-ID: <20130522021917.4299.64635.stgit@mhiramat-M0-7522>
In-Reply-To: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
References: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow user to delete multiple kprobe events by using
wild cards. This makes removing events on a specific
function easy.

e.g.)
 # echo p vfs_symlink >> kprobe_events
 # echo p vfs_symlink+5 >> kprobe_events
 # echo p vfs_read >> kprobe_events
 # cat kprobe_events
p:kprobes/p_vfs_symlink_0 vfs_symlink
p:kprobes/p_vfs_symlink_5 vfs_symlink+5
p:kprobes/p_vfs_read_0 vfs_read
 # echo -:kprobes/\*vfs_symlink_\* >> kprobe_events
 # cat kprobe_events
p:kprobes/p_vfs_read_0 vfs_read

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 Documentation/trace/kprobetrace.txt |   19 ++++---
 kernel/trace/trace_kprobe.c         |   97 +++++++++++++++++++++++++----------
 2 files changed, 82 insertions(+), 34 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index d68ea5f..04f22be 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -26,9 +26,9 @@ Synopsis of kprobe_events
   r[:[GRP/]EVENT] [MOD:]SYM[+0] [FETCHARGS]		: Set a return probe
   -:[GRP/]EVENT						: Clear a probe
 
- GRP		: Group name. If omitted, use "kprobes" for it.
+ GRP		: Group name. If omitted, use "kprobes" for it.(*)
  EVENT		: Event name. If omitted, the event name is generated
-		  based on SYM+offs or MEMADDR.
+		  based on SYM+offs or MEMADDR.(*)
  MOD		: Module name which has given SYM.
  SYM[+offs]	: Symbol+offset where the probe is inserted.
  MEMADDR	: Address where the probe is inserted.
@@ -39,15 +39,16 @@ Synopsis of kprobe_events
   @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
   $stackN	: Fetch Nth entry of stack (N >= 0)
   $stack	: Fetch stack address.
-  $retval	: Fetch return value.(*)
-  +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
+  $retval	: Fetch return value.(**)
+  +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(***)
   NAME=FETCHARG : Set NAME as the argument name of FETCHARG.
   FETCHARG:TYPE : Set TYPE as the type of FETCHARG. Currently, basic types
 		  (u8/u16/u32/u64/s8/s16/s32/s64), "string" and bitfield
 		  are supported.
 
-  (*) only for return probe.
-  (**) this is useful for fetching a field of data structures.
+  (*) both GRP and EVENT accept glob-style wild cards when clearing probes.
+  (**) only for return probe.
+  (***) this is useful for fetching a field of data structures.
 
 Types
 -----
@@ -143,7 +144,11 @@ REC->dfd, REC->filename, REC->flags, REC->mode
 
   echo -:myprobe >> kprobe_events
 
- This clears probe points selectively.
+ This removes a probe points selectively. Since the event name and group
+ name accept wild cards only when removing, you can clear all event as
+ below too.
+
+  echo '-:*/*' >> kprobe_events
 
  Right after definition, each event is disabled by default. For tracing these
 events, you need to enable it.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98..b619853 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -171,16 +171,32 @@ static void free_trace_probe(struct trace_probe *tp)
 	kfree(tp);
 }
 
-static struct trace_probe *find_trace_probe(const char *event,
-					    const char *group)
+/**
+ * find_trace_probes - find matched trace_probe and return the number of it
+ * @event: event name (glob pattern)
+ * @group: group(subsystem) name (glob pattern)
+ * @buf:   the address of an array of trace_probe *
+ * @size:  the size of @buf array
+ *
+ * Search trace_probe matched with given name (pattern) and returns
+ * the number of it. If @buf is not NULL, it records the address of
+ * the matched trace_probe on it.
+ */
+static int
+find_trace_probes(const char *event, const char *group,
+		  struct trace_probe **buf, int size)
 {
 	struct trace_probe *tp;
+	int count = 0;
 
 	list_for_each_entry(tp, &probe_list, list)
-		if (strcmp(tp->call.name, event) == 0 &&
-		    strcmp(tp->call.class->system, group) == 0)
-			return tp;
-	return NULL;
+		if (strglobmatch(event, tp->call.name) &&
+		    strglobmatch(group, tp->call.class->system)) {
+			if (buf && count < size)
+				buf[count] = tp;
+			count++;
+		}
+	return count;
 }
 
 static int trace_probe_nr_files(struct trace_probe *tp)
@@ -414,8 +430,9 @@ static int register_trace_probe(struct trace_probe *tp)
 	mutex_lock(&probe_lock);
 
 	/* Delete old (same name) event if exist */
-	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
-	if (old_tp) {
+	ret = find_trace_probes(tp->call.name, tp->call.class->system,
+				&old_tp, 1);
+	if (ret) {
 		ret = unregister_trace_probe(old_tp);
 		if (ret < 0)
 			goto end;
@@ -475,6 +492,49 @@ static struct notifier_block trace_probe_module_nb = {
 	.priority = 1	/* Invoked after kprobe module callback */
 };
 
+static int delete_trace_probe(const char *event, const char *group)
+{
+	struct trace_probe **tps;
+	int nr_tps, i, ret = 0;
+
+	if (!event) {
+		pr_info("Delete command needs an event name.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&probe_lock);
+
+	nr_tps = find_trace_probes(event, group, NULL, 0);
+	if (nr_tps == 0) {
+		pr_info("Event %s/%s doesn't matched.\n", group, event);
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	tps = kzalloc(nr_tps * sizeof(*tps), GFP_KERNEL);
+	if (!tps) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	find_trace_probes(event, group, tps, nr_tps);
+
+	for (i = 0; i < nr_tps; i++) {
+		ret = unregister_trace_probe(tps[i]);
+		if (ret < 0) {
+			pr_info("Failed to delete event: %d\n", ret);
+			continue;	/* Greedy cleanup */
+		}
+		free_trace_probe(tps[i]);
+	}
+	ret = 0;
+	kfree(tps);
+
+ out_unlock:
+	mutex_unlock(&probe_lock);
+	return ret;
+}
+
 static int create_trace_probe(int argc, char **argv)
 {
 	/*
@@ -536,25 +596,8 @@ static int create_trace_probe(int argc, char **argv)
 	if (!group)
 		group = KPROBE_EVENT_SYSTEM;
 
-	if (is_delete) {
-		if (!event) {
-			pr_info("Delete command needs an event name.\n");
-			return -EINVAL;
-		}
-		mutex_lock(&probe_lock);
-		tp = find_trace_probe(event, group);
-		if (!tp) {
-			mutex_unlock(&probe_lock);
-			pr_info("Event %s/%s doesn't exist.\n", group, event);
-			return -ENOENT;
-		}
-		/* delete an event */
-		ret = unregister_trace_probe(tp);
-		if (ret == 0)
-			free_trace_probe(tp);
-		mutex_unlock(&probe_lock);
-		return ret;
-	}
+	if (is_delete)
+		return delete_trace_probe(event, group);
 
 	if (argc < 2) {
 		pr_info("Probe point is not specified.\n");

