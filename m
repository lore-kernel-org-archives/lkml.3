Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3GJTUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:20:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3GJTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/23] perf record: Remove -A/--append option
Date: Wed, 10 Jul 2013 16:19:08 -0300
Message-Id: <1373483963-19277-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

It's no longer working and needed.

Quite straightforward discussion/vote was in here:
http://marc.info/?t=137028288300004&r=1&w=2

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8fgdva12hl8w3xzzpsvvg7nx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |  4 +-
 tools/perf/builtin-record.c              | 82 ++++----------------------------
 tools/perf/util/header.c                 | 13 +----
 3 files changed, 11 insertions(+), 88 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..7e32580 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -65,12 +65,10 @@ OPTIONS
 -r::
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
+
 -D::
 --no-delay::
 	Collect data without buffering.
--A::
---append::
-	Append to the output file to do incremental profiling.
 
 -f::
 --force::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fff985c..2990570 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -61,11 +61,6 @@ static void __handle_on_exit_funcs(void)
 }
 #endif
 
-enum write_mode_t {
-	WRITE_FORCE,
-	WRITE_APPEND
-};
-
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
@@ -77,12 +72,9 @@ struct perf_record {
 	int			output;
 	unsigned int		page_size;
 	int			realtime_prio;
-	enum write_mode_t	write_mode;
 	bool			no_buildid;
 	bool			no_buildid_cache;
 	bool			force;
-	bool			file_new;
-	bool			append_file;
 	long			samples;
 	off_t			post_processing_offset;
 };
@@ -200,25 +192,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 	signal(signr, SIG_DFL);
 }
 
-static bool perf_evlist__equal(struct perf_evlist *evlist,
-			       struct perf_evlist *other)
-{
-	struct perf_evsel *pos, *pair;
-
-	if (evlist->nr_entries != other->nr_entries)
-		return false;
-
-	pair = perf_evlist__first(other);
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
-			return false;
-		pair = perf_evsel__next(pair);
-	}
-
-	return true;
-}
-
 static int perf_record__open(struct perf_record *rec)
 {
 	char msg[512];
@@ -273,16 +246,7 @@ try_again:
 		goto out;
 	}
 
-	if (rec->file_new)
-		session->evlist = evlist;
-	else {
-		if (!perf_evlist__equal(session->evlist, evlist)) {
-			fprintf(stderr, "incompatible append\n");
-			rc = -1;
-			goto out;
-		}
- 	}
-
+	session->evlist = evlist;
 	perf_session__set_id_hdr_size(session);
 out:
 	return rc;
@@ -415,23 +379,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		if (!strcmp(output_name, "-"))
 			opts->pipe_output = true;
 		else if (!stat(output_name, &st) && st.st_size) {
-			if (rec->write_mode == WRITE_FORCE) {
-				char oldname[PATH_MAX];
-				snprintf(oldname, sizeof(oldname), "%s.old",
-					 output_name);
-				unlink(oldname);
-				rename(output_name, oldname);
-			}
-		} else if (rec->write_mode == WRITE_APPEND) {
-			rec->write_mode = WRITE_FORCE;
+			char oldname[PATH_MAX];
+			snprintf(oldname, sizeof(oldname), "%s.old",
+				 output_name);
+			unlink(oldname);
+			rename(output_name, oldname);
 		}
 	}
 
-	flags = O_CREAT|O_RDWR;
-	if (rec->write_mode == WRITE_APPEND)
-		rec->file_new = 0;
-	else
-		flags |= O_TRUNC;
+	flags = O_CREAT|O_RDWR|O_TRUNC;
 
 	if (opts->pipe_output)
 		output = STDOUT_FILENO;
@@ -445,7 +401,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	rec->output = output;
 
 	session = perf_session__new(output_name, O_WRONLY,
-				    rec->write_mode == WRITE_FORCE, false, NULL);
+				    true, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -465,12 +421,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
-	if (!rec->file_new) {
-		err = perf_session__read_header(session, output);
-		if (err < 0)
-			goto out_delete_session;
-	}
-
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
 						    argv, opts->pipe_output,
@@ -498,7 +448,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		err = perf_header__write_pipe(output);
 		if (err < 0)
 			goto out_delete_session;
-	} else if (rec->file_new) {
+	} else {
 		err = perf_session__write_header(session, evsel_list,
 						 output, false);
 		if (err < 0)
@@ -869,8 +819,6 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
-	.write_mode = WRITE_FORCE,
-	.file_new   = true,
 };
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
@@ -906,8 +854,6 @@ const struct option record_options[] = {
 		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &record.opts.target.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('A', "append", &record.append_file,
-			    "append to the output file to do incremental profiling"),
 	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &record.force,
@@ -977,16 +923,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc && perf_target__none(&rec->opts.target))
 		usage_with_options(record_usage, record_options);
 
-	if (rec->force && rec->append_file) {
-		ui__error("Can't overwrite and append at the same time."
-			  " You need to choose between -f and -A");
-		usage_with_options(record_usage, record_options);
-	} else if (rec->append_file) {
-		rec->write_mode = WRITE_APPEND;
-	} else {
-		rec->write_mode = WRITE_FORCE;
-	}
-
 	if (nr_cgroups && !rec->opts.target.system_wide) {
 		ui__error("cgroup monitoring only available in"
 			  " system-wide mode\n");
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 738d3b8..93dd315 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2303,29 +2303,18 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
-	struct perf_evsel *evsel, *pair = NULL;
+	struct perf_evsel *evsel;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
-	if (session->evlist != evlist)
-		pair = perf_evlist__first(session->evlist);
-
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
 		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (err < 0) {
-out_err_write:
 			pr_debug("failed to write perf header\n");
 			return err;
 		}
-		if (session->evlist != evlist) {
-			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
-			if (err < 0)
-				goto out_err_write;
-			evsel->ids += pair->ids;
-			pair = perf_evsel__next(pair);
-		}
 	}
 
 	header->attr_offset = lseek(fd, 0, SEEK_CUR);
-- 
1.8.1.4

