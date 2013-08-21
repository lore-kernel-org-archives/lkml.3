Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3HUKJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:09:39 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63689 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3HUKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:09:35 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com, dsahern@gmail.com
Subject: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Date: Wed, 21 Aug 2013 12:10:25 +0200
Message-Id: <1377079825-19057-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377079825-19057-1-git-send-email-eranian@google.com>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new PERF_RECORD_MMAP2
record type exposed by the kernel. This is an extended
PERF_RECORD_MMAP record. It adds for each file-backed
mapping the device major, minor number and the inode
number and generation. This triplet uniquely identifies
the source of a file-backed mapping. It can be used to
detect identical virtual mappings between processes, for
instance.

The patch will prefer MMAP2 over MMAP.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-annotate.c |    1 +
 tools/perf/builtin-inject.c   |   15 +++++++++++
 tools/perf/builtin-mem.c      |    1 +
 tools/perf/builtin-report.c   |    1 +
 tools/perf/builtin-script.c   |    1 +
 tools/perf/util/build-id.c    |    1 +
 tools/perf/util/event.c       |   56 ++++++++++++++++++++++++++++++++---------
 tools/perf/util/event.h       |   19 ++++++++++++++
 tools/perf/util/evsel.c       |    5 ++--
 tools/perf/util/header.c      |    3 +++
 tools/perf/util/machine.c     |   52 +++++++++++++++++++++++++++++++++++++-
 tools/perf/util/machine.h     |    1 +
 tools/perf/util/map.c         |    8 +++++-
 tools/perf/util/map.h         |    8 ++++--
 tools/perf/util/session.c     |   25 +++++++++++++++++-
 tools/perf/util/tool.h        |    1 +
 16 files changed, 179 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f988d38..5ebd0c3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -277,6 +277,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
+			.mmap2	= perf_event__process_mmap2,
 			.comm	= perf_event__process_comm,
 			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1d8de2e..8695f35 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -123,6 +123,19 @@ static int perf_event__repipe_mmap(struct perf_tool *tool,
 	return err;
 }
 
+static int perf_event__repipe_mmap2(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine)
+{
+	int err;
+
+	err = perf_event__process_mmap2(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
+
+	return err;
+}
+
 static int perf_event__repipe_fork(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
@@ -337,6 +350,7 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	if (inject->build_ids || inject->sched_stat) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
+		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
@@ -388,6 +402,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= perf_event__repipe_sample,
 			.mmap		= perf_event__repipe,
+			.mmap2		= perf_event__repipe,
 			.comm		= perf_event__repipe,
 			.fork		= perf_event__repipe,
 			.exit		= perf_event__repipe,
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 706a1fa..ebf500e 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -190,6 +190,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= process_sample_event,
 			.mmap		= perf_event__process_mmap,
+			.mmap2		= perf_event__process_mmap2,
 			.comm		= perf_event__process_comm,
 			.lost		= perf_event__process_lost,
 			.fork		= perf_event__process_fork,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 958a56a..96625a79 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -744,6 +744,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
+			.mmap2		 = perf_event__process_mmap2,
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2ad9d5b..eed7f77 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -541,6 +541,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
+	.mmap2		 = perf_event__process_mmap2,
 	.comm		 = perf_event__process_comm,
 	.exit		 = perf_event__process_exit,
 	.fork		 = perf_event__process_fork,
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5295625..d8dd29a 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -64,6 +64,7 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.fork	= perf_event__process_fork,
 	.exit	= perf_event__exit_del_thread,
 	.attr		 = perf_event__process_attr,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 49713ae..3b7134c 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -11,6 +11,7 @@
 static const char *perf_event__names[] = {
 	[0]					= "TOTAL",
 	[PERF_RECORD_MMAP]			= "MMAP",
+	[PERF_RECORD_MMAP2]			= "MMAP2",
 	[PERF_RECORD_LOST]			= "LOST",
 	[PERF_RECORD_COMM]			= "COMM",
 	[PERF_RECORD_EXIT]			= "EXIT",
@@ -186,7 +187,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP;
+	event->header.type = PERF_RECORD_MMAP2;
 	/*
 	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 	 */
@@ -197,7 +198,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
+		unsigned int ino;
 		size_t size;
+		ssize_t n;
 
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
@@ -206,9 +209,16 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff, execname);
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
+		event->mmap2.ino = (u64)ino;
+
+		if (n != 8)
+			continue;
 
 		if (prot[2] != 'x')
 			continue;
@@ -217,15 +227,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap.filename, execname, size);
+		memcpy(event->mmap2.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap.len -= event->mmap.start;
-		event->mmap.header.size = (sizeof(event->mmap) -
-					   (sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-		event->mmap.header.size += machine->id_hdr_size;
-		event->mmap.pid = tgid;
-		event->mmap.tid = pid;
+		event->mmap2.len -= event->mmap.start;
+		event->mmap2.header.size = (sizeof(event->mmap2) -
+					(sizeof(event->mmap2.filename) - size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+		event->mmap2.header.size += machine->id_hdr_size;
+		event->mmap2.pid = tgid;
+		event->mmap2.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
@@ -527,6 +537,17 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
+		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
+		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
+		       event->mmap2.min, event->mmap2.ino,
+		       event->mmap2.ino_generation,
+		       event->mmap2.filename);
+}
+
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
@@ -535,6 +556,14 @@ int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 	return machine__process_mmap_event(machine, event);
 }
 
+int perf_event__process_mmap2(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
+			     struct perf_sample *sample __maybe_unused,
+			     struct machine *machine)
+{
+	return machine__process_mmap2_event(machine, event);
+}
+
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, "(%d:%d):(%d:%d)\n",
@@ -574,6 +603,9 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_MMAP:
 		ret += perf_event__fprintf_mmap(event, fp);
 		break;
+	case PERF_RECORD_MMAP2:
+		ret += perf_event__fprintf_mmap2(event, fp);
+		break;
 	default:
 		ret += fprintf(fp, "\n");
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 15db071..23b3879 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -27,6 +27,19 @@ struct mmap_event {
 	char filename[PATH_MAX];
 };
 
+struct mmap2_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	u32 maj;
+	u32 min;
+	u64 ino;
+	u64 ino_generation;
+	char filename[PATH_MAX];
+};
+
 struct comm_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -168,6 +181,7 @@ union perf_event {
 	struct perf_event_header	header;
 	struct ip_event			ip;
 	struct mmap_event		mmap;
+	struct mmap2_event		mmap2;
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct lost_event		lost;
@@ -217,6 +231,10 @@ int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
+int perf_event__process_mmap2(struct perf_tool *tool,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct machine *machine);
 int perf_event__process_fork(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -244,6 +262,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 960394e..2bc0e4d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -598,8 +598,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-	attr->mmap = track;
-	attr->comm = track;
+	attr->mmap  = track;
+	attr->mmap2 = track;
+	attr->comm  = track;
 
 	/*
 	 * XXX see the function comment above
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a33197a..26441d0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1351,6 +1351,9 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		fprintf(fp, ", precise_ip = %d", evsel->attr.precise_ip);
 
+		fprintf(fp, ", attr_mmap2 = %d", evsel->attr.mmap2);
+		fprintf(fp, ", attr_mmap  = %d", evsel->attr.mmap);
+		fprintf(fp, ", attr_mmap_data = %d", evsel->attr.mmap_data);
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
 			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4514e7e..1412e17 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -987,6 +987,53 @@ out_problem:
 	return -1;
 }
 
+int machine__process_mmap2_event(struct machine *machine,
+				 union perf_event *event)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread;
+	struct map *map;
+	enum map_type type;
+	int ret = 0;
+
+	if (dump_trace)
+		perf_event__fprintf_mmap2(event, stdout);
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	    cpumode == PERF_RECORD_MISC_KERNEL) {
+		ret = machine__process_kernel_mmap_event(machine, event);
+		if (ret < 0)
+			goto out_problem;
+		return 0;
+	}
+
+	thread = machine__findnew_thread(machine, event->mmap2.pid);
+	if (thread == NULL)
+		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
+	map = map__new(&machine->user_dsos, event->mmap2.start,
+			event->mmap2.len, event->mmap2.pgoff,
+			event->mmap2.pid, event->mmap2.maj,
+			event->mmap2.min, event->mmap2.ino,
+			event->mmap2.ino_generation,
+			event->mmap2.filename, type);
+
+	if (map == NULL)
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
+
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP2, skipping event.\n");
+	return 0;
+}
+
 int machine__process_mmap_event(struct machine *machine, union perf_event *event)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -1017,7 +1064,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, event->mmap.filename,
+			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.filename,
 			type);
 
 	if (map == NULL)
@@ -1081,6 +1129,8 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 		ret = machine__process_comm_event(machine, event); break;
 	case PERF_RECORD_MMAP:
 		ret = machine__process_mmap_event(machine, event); break;
+	case PERF_RECORD_MMAP2:
+		ret = machine__process_mmap2_event(machine, event); break;
 	case PERF_RECORD_FORK:
 		ret = machine__process_fork_event(machine, event); break;
 	case PERF_RECORD_EXIT:
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 603ffba..2593147 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -45,6 +45,7 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
 int machine__process_fork_event(struct machine *machine, union perf_event *event);
 int machine__process_lost_event(struct machine *machine, union perf_event *event);
 int machine__process_mmap_event(struct machine *machine, union perf_event *event);
+int machine__process_mmap2_event(struct machine *machine, union perf_event *event);
 int machine__process_event(struct machine *machine, union perf_event *event);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9e8304c..4f6680d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -48,7 +48,8 @@ void map__init(struct map *map, enum map_type type,
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -62,6 +63,11 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
 
+		map->maj = d_maj;
+		map->min = d_min;
+		map->ino = ino;
+		map->ino_generation = ino_gen;
+
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2cc93cb..4886ca2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,6 +36,9 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
+	u32			maj, min; /* only valid for MMAP2 record */
+	u64			ino;      /* only valid for MMAP2 record */
+	u64			ino_generation;/* only valid for MMAP2 record */
 
 	/* ip -> dso rip */
 	u64			(*map_ip)(struct map *, u64);
@@ -88,8 +91,9 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type);
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen,
+		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index de16a77..99e60f9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -351,6 +351,25 @@ static void perf_event__mmap_swap(union perf_event *event,
 	}
 }
 
+static void perf_event__mmap2_swap(union perf_event *event,
+				  bool sample_id_all)
+{
+	event->mmap2.pid   = bswap_32(event->mmap2.pid);
+	event->mmap2.tid   = bswap_32(event->mmap2.tid);
+	event->mmap2.start = bswap_64(event->mmap2.start);
+	event->mmap2.len   = bswap_64(event->mmap2.len);
+	event->mmap2.pgoff = bswap_64(event->mmap2.pgoff);
+	event->mmap2.maj   = bswap_32(event->mmap2.maj);
+	event->mmap2.min   = bswap_32(event->mmap2.min);
+	event->mmap2.ino   = bswap_64(event->mmap2.ino);
+
+	if (sample_id_all) {
+		void *data = &event->mmap2.filename;
+
+		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
+}
 static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
@@ -455,6 +474,7 @@ typedef void (*perf_event__swap_op)(union perf_event *event,
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
+	[PERF_RECORD_MMAP2]		  = perf_event__mmap2_swap,
 	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
 	[PERF_RECORD_FORK]		  = perf_event__task_swap,
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
@@ -849,7 +869,8 @@ static struct machine *
 	     (cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
-		if (event->header.type == PERF_RECORD_MMAP)
+		if (event->header.type == PERF_RECORD_MMAP
+		    || event->header.type == PERF_RECORD_MMAP2)
 			pid = event->mmap.pid;
 		else
 			pid = event->ip.pid;
@@ -975,6 +996,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
+	case PERF_RECORD_MMAP2:
+		return tool->mmap2(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 62b16b6..4385816 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -29,6 +29,7 @@ struct perf_tool {
 	event_sample	sample,
 			read;
 	event_op	mmap,
+			mmap2,
 			comm,
 			fork,
 			exit,
-- 
1.7.10.4

