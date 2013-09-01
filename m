Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3IAKh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab3IAKhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:37:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/25] perf tools: Move synthesizing into single function
Date: Sun,  1 Sep 2013 12:36:30 +0200
Message-Id: <1378031796-17892-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving synthesizing into single function, so it
could be reused.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-annotate.c      |   9 +-
 tools/perf/builtin-buildid-cache.c |   8 +-
 tools/perf/builtin-buildid-list.c  |   9 +-
 tools/perf/builtin-diff.c          |  19 ++--
 tools/perf/builtin-evlist.c        |   7 +-
 tools/perf/builtin-inject.c        |   7 +-
 tools/perf/builtin-kmem.c          |   7 +-
 tools/perf/builtin-kvm.c           |  13 ++-
 tools/perf/builtin-lock.c          |   8 +-
 tools/perf/builtin-mem.c           |   9 +-
 tools/perf/builtin-record.c        | 204 +++++++++++++++++++++----------------
 tools/perf/builtin-report.c        |  10 +-
 tools/perf/builtin-sched.c         |   6 +-
 tools/perf/builtin-script.c        |  15 ++-
 tools/perf/builtin-timechart.c     |  10 +-
 tools/perf/builtin-top.c           |   6 +-
 tools/perf/builtin-trace.c         |   8 +-
 tools/perf/perf.h                  |   1 -
 tools/perf/tests/session-simple.c  |  30 ++++--
 tools/perf/util/data.h             |  29 ++++++
 tools/perf/util/session.c          |  12 +--
 tools/perf/util/session.h          |   6 +-
 22 files changed, 290 insertions(+), 143 deletions(-)
 create mode 100644 tools/perf/util/data.h

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f988d38..64eae2c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,6 +28,7 @@
 #include "util/hist.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/data.h"
 #include "arch/common.h"
 
 #include <linux/bitmap.h>
@@ -188,9 +189,13 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	struct perf_session *session;
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
+	struct perf_data_file file = {
+		.path  = input_name,
+		.mode  = PERF_DATA_MODE_READ,
+		.force = ann->force,
+	};
 
-	session = perf_session__new(input_name, O_RDONLY,
-				    ann->force, false, &ann->tool);
+	session = perf_session__new(&file, false, &ann->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index c96c8fa..581c62a 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -82,8 +82,12 @@ static bool dso__missing_buildid_cache(struct dso *dso, int parm __maybe_unused)
 
 static int build_id_cache__fprintf_missing(const char *filename, bool force, FILE *fp)
 {
-	struct perf_session *session = perf_session__new(filename, O_RDONLY,
-							 force, false, NULL);
+	struct perf_data_file file = {
+		.path  = filename,
+		.mode  = PERF_DATA_MODE_READ,
+		.force = force,
+	};
+	struct perf_session *session = perf_session__new(&file, false, NULL);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index e74366a..0164c1c 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -15,6 +15,7 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/symbol.h"
+#include "util/data.h"
 
 static int sysfs__fprintf_build_id(FILE *fp)
 {
@@ -52,6 +53,11 @@ static bool dso__skip_buildid(struct dso *dso, int with_hits)
 static int perf_session__list_build_ids(bool force, bool with_hits)
 {
 	struct perf_session *session;
+	struct perf_data_file file = {
+		.path  = input_name,
+		.mode  = PERF_DATA_MODE_READ,
+		.force = force,
+	};
 
 	symbol__elf_init();
 	/*
@@ -60,8 +66,7 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	if (filename__fprintf_build_id(input_name, stdout))
 		goto out;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false,
-				    &build_id__mark_dso_hit_ops);
+	session = perf_session__new(&file, false, &build_id__mark_dso_hit_ops);
 	if (session == NULL)
 		return -1;
 	/*
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f28799e..3fb2d46 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -16,6 +16,7 @@
 #include "util/sort.h"
 #include "util/symbol.h"
 #include "util/util.h"
+#include "util/data.h"
 
 #include <stdlib.h>
 #include <math.h>
@@ -42,7 +43,7 @@ struct diff_hpp_fmt {
 
 struct data__file {
 	struct perf_session	*session;
-	const char		*file;
+	struct perf_data_file	file;
 	int			 idx;
 	struct hists		*hists;
 	struct diff_hpp_fmt	 fmt[PERF_HPP_DIFF__MAX_INDEX];
@@ -599,7 +600,7 @@ static void data__fprintf(void)
 
 	data__for_each_file(i, d)
 		fprintf(stdout, "#  [%d] %s %s\n",
-			d->idx, d->file,
+			d->idx, d->file.path,
 			!d->idx ? "(Baseline)" : "");
 
 	fprintf(stdout, "#\n");
@@ -661,17 +662,16 @@ static int __cmd_diff(void)
 	int ret = -EINVAL, i;
 
 	data__for_each_file(i, d) {
-		d->session = perf_session__new(d->file, O_RDONLY, force,
-					       false, &tool);
+		d->session = perf_session__new(&d->file, false, &tool);
 		if (!d->session) {
-			pr_err("Failed to open %s\n", d->file);
+			pr_err("Failed to open %s\n", d->file.path);
 			ret = -ENOMEM;
 			goto out_delete;
 		}
 
 		ret = perf_session__process_events(d->session, &tool);
 		if (ret) {
-			pr_err("Failed to process %s\n", d->file);
+			pr_err("Failed to process %s\n", d->file.path);
 			goto out_delete;
 		}
 
@@ -1014,7 +1014,12 @@ static int data_init(int argc, const char **argv)
 		return -ENOMEM;
 
 	data__for_each_file(i, d) {
-		d->file = use_default ? defaults[i] : argv[i];
+		struct perf_data_file *file = &d->file;
+
+		file->path  = use_default ? defaults[i] : argv[i];
+		file->mode  = PERF_DATA_MODE_READ,
+		file->force = force,
+
 		d->idx  = i;
 	}
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 05bd9df..20b0f12 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -14,13 +14,18 @@
 #include "util/parse-events.h"
 #include "util/parse-options.h"
 #include "util/session.h"
+#include "util/data.h"
 
 static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
 	struct perf_evsel *pos;
+	struct perf_data_file file = {
+		.path = file_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
-	session = perf_session__new(file_name, O_RDONLY, 0, false, NULL);
+	session = perf_session__new(&file, 0, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6dd8ed1..1ec5246 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -15,6 +15,7 @@
 #include "util/tool.h"
 #include "util/debug.h"
 #include "util/build-id.h"
+#include "util/data.h"
 
 #include "util/parse-options.h"
 
@@ -334,6 +335,10 @@ static int __cmd_inject(struct perf_inject *inject)
 {
 	struct perf_session *session;
 	int ret = -EINVAL;
+	struct perf_data_file file = {
+		.path = inject->input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
 	signal(SIGINT, sig_handler);
 
@@ -343,7 +348,7 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(inject->input_name, O_RDONLY, false, true, &inject->tool);
+	session = perf_session__new(&file, true, &inject->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c2dff9c..a4bff1c 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -13,6 +13,7 @@
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
+#include "util/data.h"
 
 #include "util/debug.h"
 
@@ -486,8 +487,12 @@ static int __cmd_kmem(void)
 		{ "kmem:kfree",			perf_evsel__process_free_event, },
     		{ "kmem:kmem_cache_free",	perf_evsel__process_free_event, },
 	};
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_kmem);
+	session = perf_session__new(&file, false, &perf_kmem);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f89f7d6..187848c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -17,6 +17,7 @@
 #include "util/tool.h"
 #include "util/stat.h"
 #include "util/top.h"
+#include "util/data.h"
 
 #include <sys/prctl.h>
 #include <sys/timerfd.h>
@@ -1215,10 +1216,13 @@ static int read_events(struct perf_kvm_stat *kvm)
 		.comm			= perf_event__process_comm,
 		.ordered_samples	= true,
 	};
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
 	kvm->tool = eops;
-	kvm->session = perf_session__new(kvm->file_name, O_RDONLY, 0, false,
-					 &kvm->tool);
+	kvm->session = perf_session__new(&file, false, &kvm->tool);
 	if (!kvm->session) {
 		pr_err("Initializing perf session failed\n");
 		return -EINVAL;
@@ -1450,6 +1454,9 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		"perf kvm stat live [<options>]",
 		NULL
 	};
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_WRITE,
+	};
 
 
 	/* event handling */
@@ -1514,7 +1521,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	/*
 	 * perf session
 	 */
-	kvm->session = perf_session__new(NULL, O_WRONLY, false, false, &kvm->tool);
+	kvm->session = perf_session__new(&file, false, &kvm->tool);
 	if (kvm->session == NULL) {
 		err = -ENOMEM;
 		goto out;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ee33ba2..c3b685c 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -15,6 +15,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/data.h"
 
 #include <sys/types.h>
 #include <sys/prctl.h>
@@ -836,7 +837,12 @@ static int read_events(void)
 		.comm		 = perf_event__process_comm,
 		.ordered_samples = true,
 	};
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
+
+	session = perf_session__new(&file, false, &eops);
 	if (!session) {
 		pr_err("Initializing perf session failed\n");
 		return -1;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 791b432..1b703da 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -5,6 +5,7 @@
 #include "util/trace-event.h"
 #include "util/tool.h"
 #include "util/session.h"
+#include "util/data.h"
 
 #define MEM_OPERATION_LOAD	"load"
 #define MEM_OPERATION_STORE	"store"
@@ -119,10 +120,14 @@ static int process_sample_event(struct perf_tool *tool,
 
 static int report_raw_events(struct perf_mem *mem)
 {
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 	int err = -EINVAL;
 	int ret;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &mem->tool);
+	struct perf_session *session = perf_session__new(&file, false,
+							 &mem->tool);
 
 	if (session == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4011698..1887b20 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -24,6 +24,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include "util/data.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -65,11 +66,11 @@ struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
 	u64			bytes_written;
-	const char		*output_name;
+	struct perf_data_file	file_base;
+	struct perf_data_file	*file;
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
-	int			output;
 	unsigned int		page_size;
 	int			realtime_prio;
 	bool			no_buildid;
@@ -84,8 +85,10 @@ static void advance_output(struct perf_record *rec, size_t size)
 
 static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
+	struct perf_data_file *file = rec->file;
+
 	while (size) {
-		int ret = write(rec->output, buf, size);
+		int ret = write(file->fd, buf, size);
 
 		if (ret < 0) {
 			pr_err("failed to write\n");
@@ -248,6 +251,7 @@ out:
 
 static int process_buildids(struct perf_record *rec)
 {
+	struct perf_data_file *file  = rec->file;
 	struct perf_session *session = rec->session;
 	u64 data_offset              = PERF_FILE_HEADER__DATA_OFFSET;
 	u64 size                     = session->header.data_size;
@@ -255,7 +259,7 @@ static int process_buildids(struct perf_record *rec)
 	if (size == 0)
 		return 0;
 
-	rec->session->fd = rec->output;
+	rec->session->fd = file->fd;
 	return __perf_session__process_events(session, data_offset,
 					      size - data_offset, size,
 					      &build_id__mark_dso_hit_ops);
@@ -264,17 +268,18 @@ static int process_buildids(struct perf_record *rec)
 static void perf_record__exit(int status, void *arg)
 {
 	struct perf_record *rec = arg;
+	struct perf_data_file *file = rec->file;
 
 	if (status != 0)
 		return;
 
-	if (!rec->opts.pipe_output) {
+	if (!file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
 		if (!rec->no_buildid)
 			process_buildids(rec);
 		perf_session__write_header(rec->session, rec->evlist,
-					   rec->output);
+					   file->fd);
 		perf_session__delete(rec->session);
 		perf_evlist__delete(rec->evlist);
 		symbol__exit();
@@ -313,6 +318,92 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 		       " relocation symbol.\n", machine->pid);
 }
 
+static int synthesize_record_pipe(struct perf_record *rec)
+{
+	struct perf_session  *session = rec->session;
+	struct perf_tool        *tool = &rec->tool;
+	struct perf_evlist    *evlist = rec->evlist;
+	struct perf_data_file   *file = rec->file;
+	int err;
+
+	err = perf_event__synthesize_attrs(tool, session,
+					   process_synthesized_event);
+	if (err < 0) {
+		pr_err("Couldn't synthesize attrs.\n");
+		return err;
+	}
+
+	if (have_tracepoints(&evlist->entries)) {
+		err = perf_event__synthesize_tracing_data(tool, file->fd,
+						evlist,
+						process_synthesized_event);
+		if (err <= 0) {
+			pr_err("Couldn't record tracing data.\n");
+			return err;
+		}
+		advance_output(rec, err);
+	}
+
+	return 0;
+}
+
+static int synthesize_record_file(struct perf_record *rec)
+{
+	struct perf_session  *session = rec->session;
+	struct perf_tool        *tool = &rec->tool;
+	struct perf_record_opts *opts = &rec->opts;
+	struct machine       *machine = &session->machines.host;
+	struct perf_evlist    *evlist = rec->evlist;
+	int err;
+
+	err = perf_event__synthesize_kernel_mmap(tool,
+					process_synthesized_event,
+					 machine, "_text");
+	if (err < 0)
+		err = perf_event__synthesize_kernel_mmap(tool,
+						process_synthesized_event,
+						 machine, "_stext");
+	if (err < 0)
+		pr_err("Couldn't record kernel reference relocation symbol\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/kallsyms permission or run as root.\n");
+
+	err = perf_event__synthesize_modules(tool, process_synthesized_event,
+					     machine);
+	if (err < 0)
+		pr_err("Couldn't record kernel module information.\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/modules permission or run as root.\n");
+
+	if (perf_guest)
+		machines__process_guests(&session->machines,
+					 perf_event__synthesize_guest_os, tool);
+
+	if (perf_target__has_task(&opts->target))
+		err = perf_event__synthesize_thread_map(tool, evlist->threads,
+						  process_synthesized_event,
+						  machine);
+	else if (perf_target__has_cpu(&opts->target))
+		err = perf_event__synthesize_threads(tool,
+						process_synthesized_event,
+						machine);
+	else /* command specified */
+		err = 0;
+
+	return err;
+}
+
+static int synthesize_record(struct perf_record *rec)
+{
+	struct perf_data_file *file = rec->file;
+	int err = 0;
+
+	if (file->is_pipe)
+		err = synthesize_record_pipe(rec);
+
+	return err ? err : synthesize_record_file(rec);
+}
+
 static struct perf_event_header finished_round_event = {
 	.size = sizeof(struct perf_event_header),
 	.type = PERF_RECORD_FINISHED_ROUND,
@@ -344,14 +435,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	struct stat st;
 	int flags;
-	int err, output, feat;
+	int err, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
-	struct machine *machine;
-	struct perf_tool *tool = &rec->tool;
 	struct perf_record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
-	const char *output_name = rec->output_name;
+	struct perf_data_file *file = rec->file;
+	const char *output_name = file->path;
 	struct perf_session *session;
 	bool disabled = false;
 
@@ -367,13 +457,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			opts->pipe_output = true;
+			file->is_pipe = true;
 		else
-			rec->output_name = output_name = "perf.data";
+			file->path = output_name = "perf.data";
 	}
 	if (output_name) {
 		if (!strcmp(output_name, "-"))
-			opts->pipe_output = true;
+			file->is_pipe = true;
 		else if (!stat(output_name, &st) && st.st_size) {
 			char oldname[PATH_MAX];
 			snprintf(oldname, sizeof(oldname), "%s.old",
@@ -385,19 +475,16 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	flags = O_CREAT|O_RDWR|O_TRUNC;
 
-	if (opts->pipe_output)
-		output = STDOUT_FILENO;
+	if (file->is_pipe)
+		file->fd = STDOUT_FILENO;
 	else
-		output = open(output_name, flags, S_IRUSR | S_IWUSR);
-	if (output < 0) {
+		file->fd = open(output_name, flags, S_IRUSR | S_IWUSR);
+	if (file->fd < 0) {
 		perror("failed to create output file");
 		return -1;
 	}
 
-	rec->output = output;
-
-	session = perf_session__new(output_name, O_WRONLY,
-				    true, false, NULL);
+	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -419,7 +506,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
-						    argv, opts->pipe_output,
+						    argv, file->is_pipe,
 						    true);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
@@ -440,12 +527,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	 */
 	on_exit(perf_record__exit, rec);
 
-	if (opts->pipe_output) {
-		err = perf_header__write_pipe(output);
+	if (file->is_pipe) {
+		err = perf_header__write_pipe(file->fd);
 		if (err < 0)
 			goto out_delete_session;
 	} else {
-		err = perf_session__prepare_header(output);
+		err = perf_session__prepare_header(file->fd);
 		if (err < 0)
 			goto out_delete_session;
 	}
@@ -458,68 +545,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
-	machine = &session->machines.host;
-
-	if (opts->pipe_output) {
-		err = perf_event__synthesize_attrs(tool, session,
-						   process_synthesized_event);
-		if (err < 0) {
-			pr_err("Couldn't synthesize attrs.\n");
-			goto out_delete_session;
-		}
-
-		if (have_tracepoints(&evsel_list->entries)) {
-			/*
-			 * FIXME err <= 0 here actually means that
-			 * there were no tracepoints so its not really
-			 * an error, just that we don't need to
-			 * synthesize anything.  We really have to
-			 * return this more properly and also
-			 * propagate errors that now are calling die()
-			 */
-			err = perf_event__synthesize_tracing_data(tool, output, evsel_list,
-								  process_synthesized_event);
-			if (err <= 0) {
-				pr_err("Couldn't record tracing data.\n");
-				goto out_delete_session;
-			}
-			advance_output(rec, err);
-		}
-	}
-
-	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
-	if (err < 0)
-		pr_err("Couldn't record kernel reference relocation symbol\n"
-		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
-		       "Check /proc/kallsyms permission or run as root.\n");
-
-	err = perf_event__synthesize_modules(tool, process_synthesized_event,
-					     machine);
-	if (err < 0)
-		pr_err("Couldn't record kernel module information.\n"
-		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
-		       "Check /proc/modules permission or run as root.\n");
-
-	if (perf_guest) {
-		machines__process_guests(&session->machines,
-					 perf_event__synthesize_guest_os, tool);
-	}
-
-	if (perf_target__has_task(&opts->target))
-		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
-						  process_synthesized_event,
-						  machine);
-	else if (perf_target__has_cpu(&opts->target))
-		err = perf_event__synthesize_threads(tool, process_synthesized_event,
-					       machine);
-	else /* command specified */
-		err = 0;
-
-	if (err != 0)
+	err = synthesize_record(rec);
+	if (err)
 		goto out_delete_session;
 
 	if (rec->realtime_prio) {
@@ -805,6 +832,7 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.file = &record.file_base,
 };
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
@@ -843,7 +871,7 @@ const struct option record_options[] = {
 	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
-	OPT_STRING('o', "output", &record.output_name, "file",
+	OPT_STRING('o', "output", &record.file_base.path, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &record.opts.no_inherit,
 		    "child tasks do not inherit counters"),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9725aa3..815866d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,6 +33,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/data.h"
 #include "arch/common.h"
 
 #include <linux/bitmap.h>
@@ -843,6 +844,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
 	};
+	struct perf_data_file file = {
+		.mode  = PERF_DATA_MODE_READ,
+	};
 
 	perf_config(perf_report_config, &report);
 
@@ -872,9 +876,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		perf_hpp__init();
 	}
 
+	file.path  = input_name;
+	file.force = report.force;
+
 repeat:
-	session = perf_session__new(input_name, O_RDONLY,
-				    report.force, false, &report.tool);
+	session = perf_session__new(&file, false, &report.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d8c51b2..5a46b10 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1446,8 +1446,12 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
 	};
 	struct perf_session *session;
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &sched->tool);
+	session = perf_session__new(&file, false, &sched->tool);
 	if (session == NULL) {
 		pr_debug("No Memory for session\n");
 		return -1;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 93a34ce..32103c2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -15,6 +15,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/sort.h"
+#include "util/data.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1114,10 +1115,14 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	char scripts_path[MAXPATHLEN], lang_path[MAXPATHLEN];
 	DIR *scripts_dir, *lang_dir;
 	struct perf_session *session;
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 	char *temp;
 	int i = 0;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	session = perf_session__new(&file, false, NULL);
 	if (!session)
 		return -1;
 
@@ -1318,12 +1323,17 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf script [<options>] <top-script> [script-args]",
 		NULL
 	};
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_READ,
+	};
 
 	setup_scripting();
 
 	argc = parse_options(argc, argv, options, script_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
+	file.path = input_name;
+
 	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
 		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
 		if (!rec_script_path)
@@ -1487,8 +1497,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false,
-				    &perf_script);
+	session = perf_session__new(&file, false, &perf_script);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c2e0231..e11c61d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -36,6 +36,7 @@
 #include "util/session.h"
 #include "util/svghelper.h"
 #include "util/tool.h"
+#include "util/data.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
@@ -990,8 +991,13 @@ static int __cmd_timechart(const char *output_name)
 		{ "power:power_frequency",	process_sample_power_frequency },
 #endif
 	};
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &perf_timechart);
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
+
+	struct perf_session *session = perf_session__new(&file, false,
+							 &perf_timechart);
 	int ret = -EINVAL;
 
 	if (session == NULL)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0a84334..46489cb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -930,11 +930,15 @@ static int __cmd_top(struct perf_top *top)
 	struct perf_record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_WRITE,
+	};
+
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	top->session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+	top->session = perf_session__new(&file, false, NULL);
 	if (top->session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9967a56..d80b628 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -873,7 +873,10 @@ static int trace__replay(struct trace *trace)
 		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
 		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
 	};
-
+	struct perf_data_file file = {
+		.path  = input_name,
+		.mode  = PERF_DATA_MODE_READ,
+	};
 	struct perf_session *session;
 	int err = -1;
 
@@ -895,8 +898,7 @@ static int trace__replay(struct trace *trace)
 	if (symbol__init() < 0)
 		return -1;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false,
-				    &trace->tool);
+	session = perf_session__new(&file, false, &trace->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf20187..0914630 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -218,7 +218,6 @@ struct perf_record_opts {
 	bool	     no_delay;
 	bool	     no_inherit;
 	bool	     no_samples;
-	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_weight;
diff --git a/tools/perf/tests/session-simple.c b/tools/perf/tests/session-simple.c
index 215b6dc..e2b1037 100644
--- a/tools/perf/tests/session-simple.c
+++ b/tools/perf/tests/session-simple.c
@@ -11,6 +11,7 @@
 #include "header.h"
 #include "util.h"
 #include "evlist.h"
+#include "data.h"
 
 #define EVENTS_MMAP 5
 #define EVENTS_LOST 6
@@ -449,15 +450,19 @@ static int store_event(int fd, union perf_event *event, size_t *size)
 	return write(fd, event, event->header.size) > 0 ? 0 : -1;
 }
 
-static int session_write(char *file)
+static int session_write(char *path)
 {
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_WRITE,
+		.path = path,
+	};
 	struct perf_session *session;
 	struct perf_evlist *evlist;
 	size_t size = 0;
-	int feat, fd;
+	int feat;
 
-	fd = open(file, O_RDWR);
-	TEST_ASSERT_VAL("failed to open data file", fd >= 0);
+	file.fd = open(file.path, O_RDWR);
+	TEST_ASSERT_VAL("failed to open data file", file.fd >= 0);
 
 	evlist = perf_evlist__new_default();
 	TEST_ASSERT_VAL("failed to get evlist", evlist);
@@ -466,11 +471,10 @@ static int session_write(char *file)
 
 	pr_debug("session writing start\n");
 
-	session = perf_session__new(file, O_WRONLY, true, false, NULL);
+	session = perf_session__new(&file, false, NULL);
 	TEST_ASSERT_VAL("failed to create session", session);
 
 	session->evlist = evlist;
-	session->fd     = fd;
 
 	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
 		perf_header__set_feat(&session->header, feat);
@@ -480,14 +484,14 @@ static int session_write(char *file)
 	perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__prepare_header(fd));
+		!perf_session__prepare_header(file.fd));
 
 #define STORE_EVENTS(str, func, cnt)				\
 do {								\
 	int i;							\
 	for (i = 0; i < cnt; i++) {				\
 		TEST_ASSERT_VAL(str,				\
-			!store_event(fd, func(), &size));	\
+			!store_event(file.fd, func(), &size));	\
 	}							\
 } while (0)
 
@@ -520,7 +524,7 @@ do {								\
 	session->header.data_size += size;
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__write_header(session, evlist, fd));
+		!perf_session__write_header(session, evlist, file.fd));
 
 	perf_session__delete(session);
 	perf_evlist__delete(evlist);
@@ -529,7 +533,7 @@ do {								\
 	return 0;
 }
 
-static int __session_read(char *file)
+static int __session_read(char *path)
 {
 	struct perf_session *session;
 	struct perf_tool tool = {
@@ -542,10 +546,14 @@ static int __session_read(char *file)
 		.unthrottle = process_unthrottle,
 		.sample = process_sample,
 	};
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_READ,
+		.path = path,
+	};
 
 	pr_debug("session reading start\n");
 
-	session = perf_session__new(file, O_RDONLY, false, false, &tool);
+	session = perf_session__new(&file, false, &tool);
 	TEST_ASSERT_VAL("failed to create session", session);
 
 	TEST_ASSERT_VAL("failed to process events",
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
new file mode 100644
index 0000000..ffa0186
--- /dev/null
+++ b/tools/perf/util/data.h
@@ -0,0 +1,29 @@
+#ifndef __PERF_DATA_H
+#define __PERF_DATA_H
+
+#include <stdbool.h>
+
+enum perf_data_mode {
+	PERF_DATA_MODE_WRITE,
+	PERF_DATA_MODE_READ,
+};
+
+struct perf_data_file {
+	const char *path;
+	int fd;
+	bool is_pipe;
+	bool force;
+	enum perf_data_mode mode;
+};
+
+static inline bool perf_data_file__is_read(struct perf_data_file *file)
+{
+	return file->mode == PERF_DATA_MODE_READ;
+}
+
+static inline bool perf_data_file__is_write(struct perf_data_file *file)
+{
+	return file->mode == PERF_DATA_MODE_WRITE;
+}
+
+#endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 787c234..023a5b4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -106,11 +106,11 @@ static void perf_session__destroy_kernel_maps(struct perf_session *self)
 	machines__destroy_kernel_maps(&self->machines);
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, bool repipe,
-				       struct perf_tool *tool)
+struct perf_session *perf_session__new(struct perf_data_file *file,
+				       bool repipe, struct perf_tool *tool)
 {
 	struct perf_session *self;
+	const char *filename = file->path;
 	struct stat st;
 	size_t len;
 
@@ -134,11 +134,11 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machines__init(&self->machines);
 
-	if (mode == O_RDONLY) {
-		if (perf_session__open(self, force) < 0)
+	if (perf_data_file__is_read(file)) {
+		if (perf_session__open(self, file->force) < 0)
 			goto out_delete;
 		perf_session__set_id_hdr_size(self);
-	} else if (mode == O_WRONLY) {
+	} else if (perf_data_file__is_write(file)) {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
 		 * kernel MMAP event, in perf_event__process_mmap().
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3aa75fb..1e4d813 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,6 +7,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "thread.h"
+#include "data.h"
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
@@ -49,9 +50,8 @@ struct perf_session {
 
 struct perf_tool;
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, bool repipe,
-				       struct perf_tool *tool);
+struct perf_session *perf_session__new(struct perf_data_file *file,
+				       bool repipe, struct perf_tool *tool);
 void perf_session__delete(struct perf_session *session);
 
 void perf_event_header__bswap(struct perf_event_header *self);
-- 
1.7.11.7

