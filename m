Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab3GQRvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921Ab3GQRvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/23] perf tools: Add data object to handle perf data file
Date: Wed, 17 Jul 2013 19:49:59 +0200
Message-Id: <1374083403-14591-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding data object to define 'struct perf_data_file', which
holds all attributes wrt to perf.data file.

This patch uses 'struct perf_data_file' as a placeholder for
all attributes regarding perf.data file handling. Changing
perf_session__new to take it as an argument.

The rest of the functionality will be added later to keep this
change simple enough, because all the places using perf_session
are changed now.

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
 tools/perf/builtin-annotate.c      |  9 ++++--
 tools/perf/builtin-buildid-cache.c |  8 ++++--
 tools/perf/builtin-buildid-list.c  |  9 ++++--
 tools/perf/builtin-diff.c          | 19 +++++++-----
 tools/perf/builtin-evlist.c        |  7 ++++-
 tools/perf/builtin-inject.c        |  7 ++++-
 tools/perf/builtin-kmem.c          |  7 ++++-
 tools/perf/builtin-kvm.c           |  8 ++++--
 tools/perf/builtin-lock.c          |  8 +++++-
 tools/perf/builtin-mem.c           |  9 ++++--
 tools/perf/builtin-record.c        | 59 +++++++++++++++++++++-----------------
 tools/perf/builtin-report.c        | 10 +++++--
 tools/perf/builtin-sched.c         |  6 +++-
 tools/perf/builtin-script.c        | 14 +++++++--
 tools/perf/builtin-timechart.c     | 10 +++++--
 tools/perf/builtin-top.c           |  6 +++-
 tools/perf/perf.h                  |  1 -
 tools/perf/tests/session-simple.c  | 36 ++++++++++++-----------
 tools/perf/util/data.h             | 29 +++++++++++++++++++
 tools/perf/util/session.c          | 12 ++++----
 tools/perf/util/session.h          |  6 ++--
 21 files changed, 197 insertions(+), 83 deletions(-)
 create mode 100644 tools/perf/util/data.h

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index db491e9..048576f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,6 +28,7 @@
 #include "util/hist.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/data.h"
 #include "arch/common.h"
 
 #include <linux/bitmap.h>
@@ -189,9 +190,13 @@ static int __cmd_annotate(struct perf_annotate *ann)
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
index 93de3ac..ee7430b 100644
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
index 8fcaf77..6305bdf 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -15,6 +15,7 @@
 #include "util/tool.h"
 #include "util/debug.h"
 #include "util/build-id.h"
+#include "util/data.h"
 
 #include "util/parse-options.h"
 
@@ -332,6 +333,10 @@ static int __cmd_inject(struct perf_inject *inject)
 {
 	struct perf_session *session;
 	int ret = -EINVAL;
+	struct perf_data_file file = {
+		.path = inject->input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
 	signal(SIGINT, sig_handler);
 
@@ -341,7 +346,7 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(inject->input_name, O_RDONLY, false, true, &inject->tool);
+	session = perf_session__new(&file, true, &inject->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b49f5c5..08ea212 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -13,6 +13,7 @@
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
+#include "util/data.h"
 
 #include "util/debug.h"
 
@@ -485,8 +486,12 @@ static int __cmd_kmem(void)
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
index 24b78ae..88ddb03 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -15,6 +15,7 @@
 #include <lk/debugfs.h>
 #include "util/tool.h"
 #include "util/stat.h"
+#include "util/data.h"
 
 #include <sys/prctl.h>
 
@@ -733,10 +734,13 @@ static int read_events(struct perf_kvm_stat *kvm)
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
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 76543a4..65d6bec 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -15,6 +15,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/data.h"
 
 #include <sys/types.h>
 #include <sys/prctl.h>
@@ -835,7 +836,12 @@ static int read_events(void)
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
index a8ff6d2..a7e8312 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -5,6 +5,7 @@
 #include "util/trace-event.h"
 #include "util/tool.h"
 #include "util/session.h"
+#include "util/data.h"
 
 #define MEM_OPERATION_LOAD	"load"
 #define MEM_OPERATION_STORE	"store"
@@ -121,10 +122,14 @@ static int process_sample_event(struct perf_tool *tool,
 
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
index 33a5bce..c4ec7eb 100644
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
@@ -252,6 +255,7 @@ out:
 
 static int process_buildids(struct perf_record *rec)
 {
+	struct perf_data_file *file  = rec->file;
 	struct perf_session *session = rec->session;
 	u64 data_offset              = PERF_FILE_HEADER__DATA_OFFSET;
 	u64 size                     = session->header.data_size;
@@ -259,7 +263,7 @@ static int process_buildids(struct perf_record *rec)
 	if (size == 0)
 		return 0;
 
-	rec->session->fd = rec->output;
+	rec->session->fd = file->fd;
 	return __perf_session__process_events(session, data_offset,
 					      size - data_offset, size,
 					      &build_id__mark_dso_hit_ops);
@@ -268,17 +272,18 @@ static int process_buildids(struct perf_record *rec)
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
@@ -322,6 +327,7 @@ static int synthesize_record_pipe(struct perf_record *rec)
 	struct perf_session  *session = rec->session;
 	struct perf_tool        *tool = &rec->tool;
 	struct perf_evlist    *evlist = rec->evlist;
+	struct perf_data_file   *file = rec->file;
 	int err;
 
 	err = perf_event__synthesize_attrs(tool, session,
@@ -340,7 +346,7 @@ static int synthesize_record_pipe(struct perf_record *rec)
 		 * return this more properly and also
 		 * propagate errors that now are calling die()
 		 */
-		err = perf_event__synthesize_tracing_data(tool, rec->output, evlist,
+		err = perf_event__synthesize_tracing_data(tool, file->fd, evlist,
 							  process_synthesized_event);
 		if (err <= 0) {
 			pr_err("Couldn't record tracing data.\n");
@@ -397,10 +403,10 @@ static int synthesize_record_file(struct perf_record *rec)
 
 static int synthesize_record(struct perf_record *rec)
 {
-	struct perf_record_opts *opts = &rec->opts;
+	struct perf_data_file *file = rec->file;
 	int err = 0;
 
-	if (opts->pipe_output)
+	if (file->is_pipe)
 		err = synthesize_record_pipe(rec);
 
 	return err ? err : synthesize_record_file(rec);
@@ -437,12 +443,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	struct stat st;
 	int flags;
-	int err, output, feat;
+	int err, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct perf_record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
-	const char *output_name = rec->output_name;
+	struct perf_data_file *file = rec->file;
+	const char *output_name = file->path;
 	struct perf_session *session;
 	bool disabled = false;
 
@@ -458,13 +465,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
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
@@ -476,19 +483,16 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
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
@@ -510,7 +514,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
-						    argv, opts->pipe_output,
+						    argv, file->is_pipe,
 						    true);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
@@ -531,12 +535,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
@@ -836,6 +840,7 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.file = &record.file_base,
 };
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
@@ -874,7 +879,7 @@ const struct option record_options[] = {
 	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
-	OPT_STRING('o', "output", &record.output_name, "file",
+	OPT_STRING('o', "output", &record.file_base.path, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &record.opts.no_inherit,
 		    "child tasks do not inherit counters"),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a34c587..7904173 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,6 +33,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/data.h"
 #include "arch/common.h"
 
 #include <linux/bitmap.h>
@@ -834,6 +835,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
 	};
+	struct perf_data_file file = {
+		.mode  = PERF_DATA_MODE_READ,
+	};
 
 	perf_config(perf_report_config, &report);
 
@@ -863,9 +867,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 948183a..1e50899 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1458,8 +1458,12 @@ static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
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
index ecb6979..bbd524c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -15,6 +15,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/sort.h"
+#include "util/data.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1092,10 +1093,14 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
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
 
@@ -1296,6 +1301,10 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf script [<options>] <top-script> [script-args]",
 		NULL
 	};
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
 
 	setup_scripting();
 
@@ -1465,8 +1474,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
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
index bbf4635..3b01281 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -931,11 +931,15 @@ static int __cmd_top(struct perf_top *top)
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
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..95b2903 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -215,7 +215,6 @@ struct perf_record_opts {
 	bool	     no_delay;
 	bool	     no_inherit;
 	bool	     no_samples;
-	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_weight;
diff --git a/tools/perf/tests/session-simple.c b/tools/perf/tests/session-simple.c
index 3a34843..4038a8e 100644
--- a/tools/perf/tests/session-simple.c
+++ b/tools/perf/tests/session-simple.c
@@ -7,6 +7,7 @@
 #include "header.h"
 #include "util.h"
 #include "evlist.h"
+#include "data.h"
 
 
 static char *get_file(void)
@@ -102,28 +103,29 @@ static int store_event(int fd, union perf_event *event, size_t *size)
 
 static int session_write(void)
 {
+	struct perf_data_file file = {
+		.mode  = PERF_DATA_MODE_WRITE,
+	};
 	struct perf_session *session;
 	struct perf_evlist *evlist;
 	size_t size = 0;
-	char *file;
-	int feat, fd;
+	int feat;
 
-	file = get_file();
-	TEST_ASSERT_VAL("failed to get temporary file", file);
+	file.path = get_file();
+	TEST_ASSERT_VAL("failed to get temporary file", file.path);
 
-	fd = open(file, O_RDWR);
-	TEST_ASSERT_VAL("failed to open data file", fd >= 0);
+	file.fd = open(file.path, O_RDWR);
+	TEST_ASSERT_VAL("failed to open data file", file.fd >= 0);
 
 	evlist = get_evlist();
 	TEST_ASSERT_VAL("failed to get evlist", evlist);
 
 	pr_debug("session writing start\n");
 
-	session = perf_session__new(file, O_WRONLY, true, false, NULL);
+	session = perf_session__new(&file, false, NULL);
 	TEST_ASSERT_VAL("failed to create session", session);
 
 	session->evlist = evlist;
-	session->fd     = fd;
 
 	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
 		perf_header__set_feat(&session->header, feat);
@@ -133,18 +135,18 @@ static int session_write(void)
 	perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__prepare_header(fd));
+		!perf_session__prepare_header(file.fd));
 
 	TEST_ASSERT_VAL("failed to store MMAP event",
-		!store_event(fd, get_event_MMAP(), &size));
+		!store_event(file.fd, get_event_MMAP(), &size));
 
 	TEST_ASSERT_VAL("failed to store COMM event",
-		!store_event(fd, get_event_COMM(), &size));
+		!store_event(file.fd, get_event_COMM(), &size));
 
 	session->header.data_size += size;
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__write_header(session, evlist, fd));
+		!perf_session__write_header(session, evlist, file.fd));
 
 	perf_session__delete(session);
 	perf_evlist__delete(evlist);
@@ -235,19 +237,21 @@ static int process_mmap(struct perf_tool *tool __maybe_unused,
 
 static int session_read(void)
 {
+	struct perf_data_file file = {
+		.mode  = PERF_DATA_MODE_READ,
+	};
 	struct perf_session *session;
 	struct perf_tool tool = {
 		.mmap = process_mmap,
 		.comm = process_comm,
 	};
-	char *file;
 
-	file = get_file();
-	TEST_ASSERT_VAL("failed to get temporary file", file);
+	file.path = get_file();
+	TEST_ASSERT_VAL("failed to get temporary file", file.path);
 
 	pr_debug("session reading start\n");
 
-	session = perf_session__new(file, O_RDONLY, false, false, &tool);
+	session = perf_session__new(&file, false, &tool);
 	TEST_ASSERT_VAL("failed to create session", session);
 
 	TEST_ASSERT_VAL("failed to process events", session);
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
index 272c9cf..60d55ca 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -101,11 +101,11 @@ static void perf_session__destroy_kernel_maps(struct perf_session *self)
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
 
@@ -129,11 +129,11 @@ struct perf_session *perf_session__new(const char *filename, int mode,
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
index ad8d3d4..8054acd 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,6 +7,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "thread.h"
+#include "data.h"
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
@@ -43,9 +44,8 @@ struct perf_session {
 
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

