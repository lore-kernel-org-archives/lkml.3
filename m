Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab3JOQSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:18:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59762 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab3JOQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:18:46 -0400
Date: Tue, 15 Oct 2013 18:18:44 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, dsahern@gmail.com, acme@redhat.com,
        ak@linux.intel.com, jolsa@redhat.com, hughd@google.com
Subject: [PATCH] perf: revert PERF_RECORD_MMAP2 support
Message-ID: <20131015161843.GA17653@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This unified patch removes the following commits
for both kernel and perf tool:

6adb0b0 perf tools: Add default handler for mmap2 events
384c671 perf trace: Add mmap2 handler
5c5e854 perf tools: Add attr->mmap2 support
d008d52 perf: Fix up MMAP2 buffer space reservation
13d7a24 perf: Add attr->mmap2 attribute to an event

The MMAP2 record extension is not quite ready for prime time.
We have identified address space cases where mappings would
not be reported properly when apps fiddled directly with clone()
and VM_CLONE. We will revisit the patch series soon.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/uapi/linux/perf_event.h |   24 +----------------
 kernel/events/core.c            |   47 +++-----------------------------
 tools/perf/builtin-annotate.c   |    1 -
 tools/perf/builtin-inject.c     |   15 -----------
 tools/perf/builtin-mem.c        |    1 -
 tools/perf/builtin-report.c     |    1 -
 tools/perf/builtin-script.c     |    1 -
 tools/perf/builtin-trace.c      |    1 -
 tools/perf/tests/perf-record.c  |   15 +++--------
 tools/perf/util/build-id.c      |    1 -
 tools/perf/util/event.c         |   56 +++++++++------------------------------
 tools/perf/util/event.h         |   19 -------------
 tools/perf/util/evsel.c         |   16 +++--------
 tools/perf/util/header.c        |    3 ---
 tools/perf/util/machine.c       |   53 +-----------------------------------
 tools/perf/util/machine.h       |    1 -
 tools/perf/util/map.c           |    8 +-----
 tools/perf/util/map.h           |    8 ++----
 tools/perf/util/session.c       |   27 +------------------
 tools/perf/util/tool.h          |    1 -
 20 files changed, 30 insertions(+), 269 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index da48837..03a5ad6 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -300,9 +300,8 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
-				mmap2          :  1, /* include mmap with inode data     */
 
-				__reserved_1   : 40;
+				__reserved_1   : 41;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -681,27 +680,6 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_SAMPLE			= 9,
 
-	/*
-	 * The MMAP2 records are an augmented version of MMAP, they add
-	 * maj, min, ino numbers to be used to uniquely identify each mapping
-	 *
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *
-	 *	u32				pid, tid;
-	 *	u64				addr;
-	 *	u64				len;
-	 *	u64				pgoff;
-	 *	u32				maj;
-	 *	u32				min;
-	 *	u64				ino;
-	 *	u64				ino_generation;
-	 *	char				filename[];
-	 * 	struct sample_id		sample_id;
-	 * };
-	 */
-	PERF_RECORD_MMAP2			= 10,
-
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c716385..aa79a2a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4806,7 +4806,7 @@ next:
 /*
  * task tracking -- fork/exit
  *
- * enabled by: attr.comm | attr.mmap | attr.mmap2 | attr.mmap_data | attr.task
+ * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.task
  */
 
 struct perf_task_event {
@@ -4826,9 +4826,8 @@ struct perf_task_event {
 
 static int perf_event_task_match(struct perf_event *event)
 {
-	return event->attr.comm  || event->attr.mmap ||
-	       event->attr.mmap2 || event->attr.mmap_data ||
-	       event->attr.task;
+	return event->attr.comm || event->attr.mmap ||
+	       event->attr.mmap_data || event->attr.task;
 }
 
 static void perf_event_task_output(struct perf_event *event,
@@ -5023,9 +5022,6 @@ struct perf_mmap_event {
 
 	const char		*file_name;
 	int			file_size;
-	int			maj, min;
-	u64			ino;
-	u64			ino_generation;
 
 	struct {
 		struct perf_event_header	header;
@@ -5046,7 +5042,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	int executable = vma->vm_flags & VM_EXEC;
 
 	return (!executable && event->attr.mmap_data) ||
-	       (executable && (event->attr.mmap || event->attr.mmap2));
+	       (executable && event->attr.mmap);
 }
 
 static void perf_event_mmap_output(struct perf_event *event,
@@ -5061,14 +5057,6 @@ static void perf_event_mmap_output(struct perf_event *event,
 	if (!perf_event_mmap_match(event, data))
 		return;
 
-	if (event->attr.mmap2) {
-		mmap_event->event_id.header.type = PERF_RECORD_MMAP2;
-		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
-		mmap_event->event_id.header.size += sizeof(mmap_event->min);
-		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
-		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
-	}
-
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				mmap_event->event_id.header.size);
@@ -5079,14 +5067,6 @@ static void perf_event_mmap_output(struct perf_event *event,
 	mmap_event->event_id.tid = perf_event_tid(event, current);
 
 	perf_output_put(&handle, mmap_event->event_id);
-
-	if (event->attr.mmap2) {
-		perf_output_put(&handle, mmap_event->maj);
-		perf_output_put(&handle, mmap_event->min);
-		perf_output_put(&handle, mmap_event->ino);
-		perf_output_put(&handle, mmap_event->ino_generation);
-	}
-
 	__output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
 
@@ -5101,8 +5081,6 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 {
 	struct vm_area_struct *vma = mmap_event->vma;
 	struct file *file = vma->vm_file;
-	int maj = 0, min = 0;
-	u64 ino = 0, gen = 0;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
@@ -5111,8 +5089,6 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	memset(tmp, 0, sizeof(tmp));
 
 	if (file) {
-		struct inode *inode;
-		dev_t dev;
 		/*
 		 * d_path works from the end of the rb backwards, so we
 		 * need to add enough zero bytes after the string to handle
@@ -5128,13 +5104,6 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;
 		}
-		inode = file_inode(vma->vm_file);
-		dev = inode->i_sb->s_dev;
-		ino = inode->i_ino;
-		gen = inode->i_generation;
-		maj = MAJOR(dev);
-		min = MINOR(dev);
-
 	} else {
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
@@ -5165,10 +5134,6 @@ got_name:
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
-	mmap_event->maj = maj;
-	mmap_event->min = min;
-	mmap_event->ino = ino;
-	mmap_event->ino_generation = gen;
 
 	if (!(vma->vm_flags & VM_EXEC))
 		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
@@ -5205,10 +5170,6 @@ void perf_event_mmap(struct vm_area_struct *vma)
 			.len    = vma->vm_end - vma->vm_start,
 			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
 		},
-		/* .maj (attr_mmap2 only) */
-		/* .min (attr_mmap2 only) */
-		/* .ino (attr_mmap2 only) */
-		/* .ino_generation (attr_mmap2 only) */
 	};
 
 	perf_event_mmap_event(&mmap_event);
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 94f9a8e..cd3687d 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -297,7 +297,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
-			.mmap2	= perf_event__process_mmap2,
 			.comm	= perf_event__process_comm,
 			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f51a963..783ceb3 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -123,19 +123,6 @@ static int perf_event__repipe_mmap(struct perf_tool *tool,
 	return err;
 }
 
-static int perf_event__repipe_mmap2(struct perf_tool *tool,
-				   union perf_event *event,
-				   struct perf_sample *sample,
-				   struct machine *machine)
-{
-	int err;
-
-	err = perf_event__process_mmap2(tool, event, sample, machine);
-	perf_event__repipe(tool, event, sample, machine);
-
-	return err;
-}
-
 static int perf_event__repipe_fork(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
@@ -350,7 +337,6 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	if (inject->build_ids || inject->sched_stat) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
-		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
@@ -402,7 +388,6 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= perf_event__repipe_sample,
 			.mmap		= perf_event__repipe,
-			.mmap2		= perf_event__repipe,
 			.comm		= perf_event__repipe,
 			.fork		= perf_event__repipe,
 			.exit		= perf_event__repipe,
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 253133a..791b432 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -190,7 +190,6 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= process_sample_event,
 			.mmap		= perf_event__process_mmap,
-			.mmap2		= perf_event__process_mmap2,
 			.comm		= perf_event__process_comm,
 			.lost		= perf_event__process_lost,
 			.fork		= perf_event__process_fork,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21b5c2f..da7c311 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -757,7 +757,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
-			.mmap2		 = perf_event__process_mmap2,
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9c333ff..80c6a2d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -542,7 +542,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
-	.mmap2		 = perf_event__process_mmap2,
 	.comm		 = perf_event__process_comm,
 	.exit		 = perf_event__process_exit,
 	.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d0f91fe..cb3e1e0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1790,7 +1790,6 @@ static int trace__replay(struct trace *trace)
 
 	trace->tool.sample	  = trace__process_sample;
 	trace->tool.mmap	  = perf_event__process_mmap;
-	trace->tool.mmap2	  = perf_event__process_mmap2;
 	trace->tool.comm	  = perf_event__process_comm;
 	trace->tool.exit	  = perf_event__process_exit;
 	trace->tool.fork	  = perf_event__process_fork;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 82ac715..6143b06 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -50,7 +50,7 @@ int test__PERF_RECORD(void)
 	struct perf_sample sample;
 	const char *cmd = "sleep";
 	const char *argv[] = { cmd, "1", NULL, };
-	char *bname, *mmap_filename;
+	char *bname;
 	u64 prev_time = 0;
 	bool found_cmd_mmap = false,
 	     found_libc_mmap = false,
@@ -202,7 +202,6 @@ int test__PERF_RECORD(void)
 
 				if ((type == PERF_RECORD_COMM ||
 				     type == PERF_RECORD_MMAP ||
-				     type == PERF_RECORD_MMAP2 ||
 				     type == PERF_RECORD_FORK ||
 				     type == PERF_RECORD_EXIT) &&
 				     (pid_t)event->comm.pid != evlist->workload.pid) {
@@ -211,8 +210,7 @@ int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP ||
-				     type == PERF_RECORD_MMAP2) &&
+				     type == PERF_RECORD_MMAP) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
 					++errs;
@@ -228,12 +226,7 @@ int test__PERF_RECORD(void)
 				case PERF_RECORD_EXIT:
 					goto found_exit;
 				case PERF_RECORD_MMAP:
-					mmap_filename = event->mmap.filename;
-					goto check_bname;
-				case PERF_RECORD_MMAP2:
-					mmap_filename = event->mmap2.filename;
-				check_bname:
-					bname = strrchr(mmap_filename, '/');
+					bname = strrchr(event->mmap.filename, '/');
 					if (bname != NULL) {
 						if (!found_cmd_mmap)
 							found_cmd_mmap = !strcmp(bname + 1, cmd);
@@ -242,7 +235,7 @@ int test__PERF_RECORD(void)
 						if (!found_ld_mmap)
 							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
 					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(mmap_filename, "[vdso]");
+						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
 					break;
 
 				case PERF_RECORD_SAMPLE:
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 7ded71d..fb58409 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -67,7 +67,6 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
-	.mmap2	= perf_event__process_mmap2,
 	.fork	= perf_event__process_fork,
 	.exit	= perf_event__exit_del_thread,
 	.attr		 = perf_event__process_attr,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9b393e7..8d51f21 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -11,7 +11,6 @@
 static const char *perf_event__names[] = {
 	[0]					= "TOTAL",
 	[PERF_RECORD_MMAP]			= "MMAP",
-	[PERF_RECORD_MMAP2]			= "MMAP2",
 	[PERF_RECORD_LOST]			= "LOST",
 	[PERF_RECORD_COMM]			= "COMM",
 	[PERF_RECORD_EXIT]			= "EXIT",
@@ -187,7 +186,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP2;
+	event->header.type = PERF_RECORD_MMAP;
 	/*
 	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 	 */
@@ -198,9 +197,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
-		unsigned int ino;
 		size_t size;
-		ssize_t n;
 
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
@@ -209,16 +206,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
-		       &event->mmap2.start, &event->mmap2.len, prot,
-		       &event->mmap2.pgoff, &event->mmap2.maj,
-		       &event->mmap2.min,
-		       &ino, execname);
-
-		event->mmap2.ino = (u64)ino;
-
-		if (n != 8)
-			continue;
+		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
+		       &event->mmap.start, &event->mmap.len, prot,
+		       &event->mmap.pgoff, execname);
 
 		if (prot[2] != 'x')
 			continue;
@@ -227,15 +217,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap2.filename, execname, size);
+		memcpy(event->mmap.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap2.len -= event->mmap.start;
-		event->mmap2.header.size = (sizeof(event->mmap2) -
-					(sizeof(event->mmap2.filename) - size));
-		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
-		event->mmap2.header.size += machine->id_hdr_size;
-		event->mmap2.pid = tgid;
-		event->mmap2.tid = pid;
+		event->mmap.len -= event->mmap.start;
+		event->mmap.header.size = (sizeof(event->mmap) -
+					   (sizeof(event->mmap.filename) - size));
+		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
+		event->mmap.header.size += machine->id_hdr_size;
+		event->mmap.pid = tgid;
+		event->mmap.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
@@ -537,17 +527,6 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
-size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
-{
-	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
-			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
-		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
-		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
-		       event->mmap2.min, event->mmap2.ino,
-		       event->mmap2.ino_generation,
-		       event->mmap2.filename);
-}
-
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
@@ -556,14 +535,6 @@ int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 	return machine__process_mmap_event(machine, event);
 }
 
-int perf_event__process_mmap2(struct perf_tool *tool __maybe_unused,
-			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
-			     struct machine *machine)
-{
-	return machine__process_mmap2_event(machine, event);
-}
-
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, "(%d:%d):(%d:%d)\n",
@@ -603,9 +574,6 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_MMAP:
 		ret += perf_event__fprintf_mmap(event, fp);
 		break;
-	case PERF_RECORD_MMAP2:
-		ret += perf_event__fprintf_mmap2(event, fp);
-		break;
 	default:
 		ret += fprintf(fp, "\n");
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 752709c..ae64683 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -17,19 +17,6 @@ struct mmap_event {
 	char filename[PATH_MAX];
 };
 
-struct mmap2_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	u32 maj;
-	u32 min;
-	u64 ino;
-	u64 ino_generation;
-	char filename[PATH_MAX];
-};
-
 struct comm_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -182,7 +169,6 @@ struct tracing_data_event {
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
-	struct mmap2_event		mmap2;
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct lost_event		lost;
@@ -233,10 +219,6 @@ int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process_mmap2(struct perf_tool *tool,
-			     union perf_event *event,
-			     struct perf_sample *sample,
-			     struct machine *machine);
 int perf_event__process_fork(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -267,7 +249,6 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
-size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bfebc1e..092410a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -27,7 +27,6 @@
 static struct {
 	bool sample_id_all;
 	bool exclude_guest;
-	bool mmap2;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -677,9 +676,8 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-	attr->mmap  = track;
-	attr->mmap2 = track && !perf_missing_features.mmap2;
-	attr->comm  = track;
+	attr->mmap = track;
+	attr->comm = track;
 
 	if (opts->sample_transaction)
 		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
@@ -1021,8 +1019,6 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 fallback_missing_features:
-	if (perf_missing_features.mmap2)
-		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 retry_sample_id:
@@ -1087,11 +1083,8 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
-		perf_missing_features.mmap2 = true;
-		goto fallback_missing_features;
-	} else if (!perf_missing_features.exclude_guest &&
-		   (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+	if (!perf_missing_features.exclude_guest &&
+	    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
 		perf_missing_features.exclude_guest = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.sample_id_all) {
@@ -1944,7 +1937,6 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(exclude_hv);
 		if_print(exclude_idle);
 		if_print(mmap);
-		if_print(mmap2);
 		if_print(comm);
 		if_print(freq);
 		if_print(inherit_stat);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c3e5a3b..34dbe5f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1366,9 +1366,6 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		fprintf(fp, ", precise_ip = %d", evsel->attr.precise_ip);
 
-		fprintf(fp, ", attr_mmap2 = %d", evsel->attr.mmap2);
-		fprintf(fp, ", attr_mmap  = %d", evsel->attr.mmap);
-		fprintf(fp, ", attr_mmap_data = %d", evsel->attr.mmap_data);
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
 			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6b861ae..32e2472 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -983,54 +983,6 @@ out_problem:
 	return -1;
 }
 
-int machine__process_mmap2_event(struct machine *machine,
-				 union perf_event *event)
-{
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread;
-	struct map *map;
-	enum map_type type;
-	int ret = 0;
-
-	if (dump_trace)
-		perf_event__fprintf_mmap2(event, stdout);
-
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
-	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = machine__process_kernel_mmap_event(machine, event);
-		if (ret < 0)
-			goto out_problem;
-		return 0;
-	}
-
-	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.pid);
-	if (thread == NULL)
-		goto out_problem;
-
-	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
-		type = MAP__VARIABLE;
-	else
-		type = MAP__FUNCTION;
-
-	map = map__new(&machine->user_dsos, event->mmap2.start,
-			event->mmap2.len, event->mmap2.pgoff,
-			event->mmap2.pid, event->mmap2.maj,
-			event->mmap2.min, event->mmap2.ino,
-			event->mmap2.ino_generation,
-			event->mmap2.filename, type);
-
-	if (map == NULL)
-		goto out_problem;
-
-	thread__insert_map(thread, map);
-	return 0;
-
-out_problem:
-	dump_printf("problem processing PERF_RECORD_MMAP2, skipping event.\n");
-	return 0;
-}
-
 int machine__process_mmap_event(struct machine *machine, union perf_event *event)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -1062,8 +1014,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, 0, 0, 0, 0,
-			event->mmap.filename,
+			event->mmap.pid, event->mmap.filename,
 			type);
 
 	if (map == NULL)
@@ -1136,8 +1087,6 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 		ret = machine__process_comm_event(machine, event); break;
 	case PERF_RECORD_MMAP:
 		ret = machine__process_mmap_event(machine, event); break;
-	case PERF_RECORD_MMAP2:
-		ret = machine__process_mmap2_event(machine, event); break;
 	case PERF_RECORD_FORK:
 		ret = machine__process_fork_event(machine, event); break;
 	case PERF_RECORD_EXIT:
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index d44c09b..8d8ad02 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -45,7 +45,6 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
 int machine__process_fork_event(struct machine *machine, union perf_event *event);
 int machine__process_lost_event(struct machine *machine, union perf_event *event);
 int machine__process_mmap_event(struct machine *machine, union perf_event *event);
-int machine__process_mmap2_event(struct machine *machine, union perf_event *event);
 int machine__process_event(struct machine *machine, union perf_event *event);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ef5bc91..c3459c5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -48,8 +48,7 @@ void map__init(struct map *map, enum map_type type,
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen, char *filename,
+		     u64 pgoff, u32 pid, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -63,11 +62,6 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
 
-		map->maj = d_maj;
-		map->min = d_min;
-		map->ino = ino;
-		map->ino_generation = ino_gen;
-
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index e4e259c..8ff6395 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,9 +36,6 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
-	u32			maj, min; /* only valid for MMAP2 record */
-	u64			ino;      /* only valid for MMAP2 record */
-	u64			ino_generation;/* only valid for MMAP2 record */
 
 	/* ip -> dso rip */
 	u64			(*map_ip)(struct map *, u64);
@@ -94,9 +91,8 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen,
-		     char *filename, enum map_type type);
+		     u64 pgoff, u32 pid, char *filename,
+		     enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d1e4495..909cb59 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -256,8 +256,6 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->sample = process_event_sample_stub;
 	if (tool->mmap == NULL)
 		tool->mmap = process_event_stub;
-	if (tool->mmap2 == NULL)
-		tool->mmap2 = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
 	if (tool->fork == NULL)
@@ -353,25 +351,6 @@ static void perf_event__mmap_swap(union perf_event *event,
 	}
 }
 
-static void perf_event__mmap2_swap(union perf_event *event,
-				  bool sample_id_all)
-{
-	event->mmap2.pid   = bswap_32(event->mmap2.pid);
-	event->mmap2.tid   = bswap_32(event->mmap2.tid);
-	event->mmap2.start = bswap_64(event->mmap2.start);
-	event->mmap2.len   = bswap_64(event->mmap2.len);
-	event->mmap2.pgoff = bswap_64(event->mmap2.pgoff);
-	event->mmap2.maj   = bswap_32(event->mmap2.maj);
-	event->mmap2.min   = bswap_32(event->mmap2.min);
-	event->mmap2.ino   = bswap_64(event->mmap2.ino);
-
-	if (sample_id_all) {
-		void *data = &event->mmap2.filename;
-
-		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
-		swap_sample_id_all(event, data);
-	}
-}
 static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
@@ -487,7 +466,6 @@ typedef void (*perf_event__swap_op)(union perf_event *event,
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
-	[PERF_RECORD_MMAP2]		  = perf_event__mmap2_swap,
 	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
 	[PERF_RECORD_FORK]		  = perf_event__task_swap,
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
@@ -892,8 +870,7 @@ static struct machine *
 	     (cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
-		if (event->header.type == PERF_RECORD_MMAP
-		    || event->header.type == PERF_RECORD_MMAP2)
+		if (event->header.type == PERF_RECORD_MMAP)
 			pid = event->mmap.pid;
 		else
 			pid = sample->pid;
@@ -1020,8 +997,6 @@ static int perf_session_deliver_event(struct perf_session *session,
 						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
-	case PERF_RECORD_MMAP2:
-		return tool->mmap2(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 4385816..62b16b6 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -29,7 +29,6 @@ struct perf_tool {
 	event_sample	sample,
 			read;
 	event_op	mmap,
-			mmap2,
 			comm,
 			fork,
 			exit,
-- 
1.7.10.4

