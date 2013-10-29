Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3J2KFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:05:01 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61568 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2KE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:04:59 -0400
Date: Tue, 29 Oct 2013 11:04:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131029100455.GA25765@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: cd65718712469ad844467250e8fad20a5838baae Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

It contains five tooling fixes:

 - fix a remaining mmap2 assumption which resulted in perf top output breakage
 - fix mmap ring-buffer processing bug that corrupts data
 - fix for a severe python scripting memory leak
 - fix broken (and user-visible) -g option handling
 - fix stdio output

The diffstat size is larger than what we'd like to see this late :-/

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf tools: Fix up /proc/PID/maps parsing

Jiri Olsa (3):
      perf hists: Add color overhead for stdio output buffer
      perf record: Split -g and --call-graph
      perf top: Split -G and --call-graph

Joseph Schuchart (1):
      perf script python: Fix mem leak due to missing Py_DECREFs on dict entries

Zhouyi Zhou (1):
      perf tools: Fixup mmap event consumption


 tools/perf/Documentation/perf-record.txt           | 14 ++++-
 tools/perf/Documentation/perf-top.txt              | 18 ++----
 tools/perf/builtin-kvm.c                           |  7 +++
 tools/perf/builtin-record.c                        | 73 +++++++++++++++-------
 tools/perf/builtin-top.c                           | 33 +++++-----
 tools/perf/builtin-trace.c                         |  8 ++-
 tools/perf/tests/code-reading.c                    |  1 +
 tools/perf/tests/keep-tracking.c                   |  1 +
 tools/perf/tests/mmap-basic.c                      |  1 +
 tools/perf/tests/open-syscall-tp-fields.c          |  4 +-
 tools/perf/tests/perf-record.c                     |  2 +
 tools/perf/tests/perf-time-to-tsc.c                |  4 +-
 tools/perf/tests/sw-clock.c                        |  4 +-
 tools/perf/tests/task-exit.c                       |  6 +-
 tools/perf/ui/stdio/hist.c                         |  9 ++-
 tools/perf/util/callchain.h                        |  3 +
 tools/perf/util/event.c                            |  2 +-
 tools/perf/util/evlist.c                           | 13 +++-
 tools/perf/util/evlist.h                           |  2 +
 tools/perf/util/hist.h                             | 13 ++++
 tools/perf/util/python.c                           |  2 +
 .../util/scripting-engines/trace-event-python.c    | 37 +++++++----
 22 files changed, 176 insertions(+), 81 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e297b74..ca0d3d9 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -90,8 +90,20 @@ OPTIONS
 	Number of mmap data pages. Must be a power of two.
 
 -g::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-	Do call-graph (stack chain/backtrace) recording.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -g.
+
+	Allows specifying "fp" (frame pointer) or "dwarf"
+	(DWARF's CFI - Call Frame Information) as the method to collect
+	the information used to show the call graphs.
+
+	In some systems, where binaries are build with gcc
+	--fomit-frame-pointer, using the "fp" method will produce bogus
+	call graphs, using "dwarf", if available (perf tools linked to
+	the libunwind library) should be used instead.
 
 -q::
 --quiet::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 58d6598..6a118e7 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -140,20 +140,12 @@ Default is to monitor all CPUS.
 --asm-raw::
 	Show raw instruction encoding of assembly instructions.
 
--G [type,min,order]::
+-G::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-        Display call chains using type, min percent threshold and order.
-	type can be either:
-	- flat: single column, linear exposure of call chains.
-	- graph: use a graph tree, displaying absolute overhead rates.
-	- fractal: like graph, but displays relative rates. Each branch of
-		 the tree is considered as a new profiled object.
-
-	order can be either:
-	- callee: callee based call graph.
-	- caller: inverted caller based call graph.
-
-	Default: fractal,0.5,callee.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -G.
 
 --ignore-callees=<regex>::
         Ignore callees of the function(s) matching the given regex.
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 935d522..fbc2888 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -888,11 +888,18 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
 	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
 		err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
 		if (err) {
+			perf_evlist__mmap_consume(kvm->evlist, idx);
 			pr_err("Failed to parse sample\n");
 			return -1;
 		}
 
 		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+		/*
+		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
+		 *        point to it, and it'll get possibly overwritten by the kernel.
+		 */
+		perf_evlist__mmap_consume(kvm->evlist, idx);
+
 		if (err) {
 			pr_err("Failed to enqueue sample: %d\n", err);
 			return -1;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a41ac415..d046514 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -712,21 +712,12 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
-int record_parse_callchain_opt(const struct option *opt,
-			       const char *arg, int unset)
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts)
 {
-	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
 	int ret = -1;
 
-	/* --no-call-graph */
-	if (unset)
-		return 0;
-
-	/* We specified default option if none is provided. */
-	BUG_ON(!arg);
-
 	/* We need buffer that we know we can write to. */
 	buf = malloc(strlen(arg) + 1);
 	if (!buf)
@@ -764,13 +755,9 @@ int record_parse_callchain_opt(const struct option *opt,
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-
-			if (!ret)
-				pr_debug("callchain: stack dump size %d\n",
-					 opts->stack_dump_size);
 #endif /* LIBUNWIND_SUPPORT */
 		} else {
-			pr_err("callchain: Unknown -g option "
+			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
 			break;
 		}
@@ -778,13 +765,52 @@ int record_parse_callchain_opt(const struct option *opt,
 	} while (0);
 
 	free(buf);
+	return ret;
+}
+
+static void callchain_debug(struct perf_record_opts *opts)
+{
+	pr_debug("callchain: type %d\n", opts->call_graph);
 
+	if (opts->call_graph == CALLCHAIN_DWARF)
+		pr_debug("callchain: stack dump size %d\n",
+			 opts->stack_dump_size);
+}
+
+int record_parse_callchain_opt(const struct option *opt,
+			       const char *arg,
+			       int unset)
+{
+	struct perf_record_opts *opts = opt->value;
+	int ret;
+
+	/* --no-call-graph */
+	if (unset) {
+		opts->call_graph = CALLCHAIN_NONE;
+		pr_debug("callchain: disabled\n");
+		return 0;
+	}
+
+	ret = record_parse_callchain(arg, opts);
 	if (!ret)
-		pr_debug("callchain: type %d\n", opts->call_graph);
+		callchain_debug(opts);
 
 	return ret;
 }
 
+int record_callchain_opt(const struct option *opt,
+			 const char *arg __maybe_unused,
+			 int unset __maybe_unused)
+{
+	struct perf_record_opts *opts = opt->value;
+
+	if (opts->call_graph == CALLCHAIN_NONE)
+		opts->call_graph = CALLCHAIN_FP;
+
+	callchain_debug(opts);
+	return 0;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -813,12 +839,12 @@ static struct perf_record record = {
 	},
 };
 
-#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+#define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
 #ifdef LIBUNWIND_SUPPORT
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
-const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
+const char record_callchain_help[] = CALLCHAIN_HELP "fp";
 #endif
 
 /*
@@ -858,9 +884,12 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &record_parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
+			   NULL, "enables call-graph recording" ,
+			   &record_callchain_opt),
+	OPT_CALLBACK(0, "call-graph", &record.opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &record_parse_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2122141..5a11f13 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -810,7 +810,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		ret = perf_evlist__parse_sample(top->evlist, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
-			continue;
+			goto next_event;
 		}
 
 		evsel = perf_evlist__id2evsel(session->evlist, sample.id);
@@ -825,13 +825,13 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		case PERF_RECORD_MISC_USER:
 			++top->us_samples;
 			if (top->hide_user_symbols)
-				continue;
+				goto next_event;
 			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_KERNEL:
 			++top->kernel_samples;
 			if (top->hide_kernel_symbols)
-				continue;
+				goto next_event;
 			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
@@ -847,7 +847,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			 */
 			/* Fall thru */
 		default:
-			continue;
+			goto next_event;
 		}
 
 
@@ -859,6 +859,8 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			machine__process_event(machine, event);
 		} else
 			++session->stats.nr_unknown_events;
+next_event:
+		perf_evlist__mmap_consume(top->evlist, idx);
 	}
 }
 
@@ -1016,16 +1018,16 @@ out_delete:
 }
 
 static int
-parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	/*
-	 * --no-call-graph
-	 */
-	if (unset)
-		return 0;
-
 	symbol_conf.use_callchain = true;
+	return record_callchain_opt(opt, arg, unset);
+}
 
+static int
+parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+{
+	symbol_conf.use_callchain = true;
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
@@ -1106,9 +1108,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+			   NULL, "enables call-graph recording",
+			   &callchain_opt),
+	OPT_CALLBACK(0, "call-graph", &top.record_opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &parse_callchain_opt),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 71aa3e3..99c8d9a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -987,7 +987,7 @@ again:
 			err = perf_evlist__parse_sample(evlist, event, &sample);
 			if (err) {
 				fprintf(trace->output, "Can't parse sample, err = %d, skipping...\n", err);
-				continue;
+				goto next_event;
 			}
 
 			if (trace->base_time == 0)
@@ -1001,18 +1001,20 @@ again:
 			evsel = perf_evlist__id2evsel(evlist, sample.id);
 			if (evsel == NULL) {
 				fprintf(trace->output, "Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
-				continue;
+				goto next_event;
 			}
 
 			if (sample.raw_data == NULL) {
 				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
-				continue;
+				goto next_event;
 			}
 
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
+next_event:
+			perf_evlist__mmap_consume(evlist, i);
 
 			if (done)
 				goto out_unmap_evlist;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6fb781d..e3fedfa 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -290,6 +290,7 @@ static int process_events(struct machine *machine, struct perf_evlist *evlist,
 	for (i = 0; i < evlist->nr_mmaps; i++) {
 		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
 			ret = process_event(machine, evlist, event, state);
+			perf_evlist__mmap_consume(evlist, i);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index d444ea2..376c356 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -36,6 +36,7 @@ static int find_comm(struct perf_evlist *evlist, const char *comm)
 			    (pid_t)event->comm.tid == getpid() &&
 			    strcmp(event->comm.comm, comm) == 0)
 				found += 1;
+			perf_evlist__mmap_consume(evlist, i);
 		}
 	}
 	return found;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index c4185b9..a7232c2 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -122,6 +122,7 @@ int test__basic_mmap(void)
 			goto out_munmap;
 		}
 		nr_events[evsel->idx]++;
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	err = 0;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index fc5b9fc..524b221 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -77,8 +77,10 @@ int test__syscall_open_tp_fields(void)
 
 				++nr_events;
 
-				if (type != PERF_RECORD_SAMPLE)
+				if (type != PERF_RECORD_SAMPLE) {
+					perf_evlist__mmap_consume(evlist, i);
 					continue;
+				}
 
 				err = perf_evsel__parse_sample(evsel, event, &sample);
 				if (err) {
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index b8a7056..7923b06 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -263,6 +263,8 @@ int test__PERF_RECORD(void)
 						 type);
 					++errs;
 				}
+
+				perf_evlist__mmap_consume(evlist, i);
 			}
 		}
 
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 0ab61b1..4ca1b93 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -122,7 +122,7 @@ int test__perf_time_to_tsc(void)
 			if (event->header.type != PERF_RECORD_COMM ||
 			    (pid_t)event->comm.pid != getpid() ||
 			    (pid_t)event->comm.tid != getpid())
-				continue;
+				goto next_event;
 
 			if (strcmp(event->comm.comm, comm1) == 0) {
 				CHECK__(perf_evsel__parse_sample(evsel, event,
@@ -134,6 +134,8 @@ int test__perf_time_to_tsc(void)
 								 &sample));
 				comm2_time = sample.time;
 			}
+next_event:
+			perf_evlist__mmap_consume(evlist, i);
 		}
 	}
 
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 2e41e2d..6e2b44e 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -78,7 +78,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE)
-			continue;
+			goto next_event;
 
 		err = perf_evlist__parse_sample(evlist, event, &sample);
 		if (err < 0) {
@@ -88,6 +88,8 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 
 		total_periods += sample.period;
 		nr_samples++;
+next_event:
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	if ((u64) nr_samples == total_periods) {
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 28fe589..a3e6487 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -96,10 +96,10 @@ int test__task_exit(void)
 
 retry:
 	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
-		if (event->header.type != PERF_RECORD_EXIT)
-			continue;
+		if (event->header.type == PERF_RECORD_EXIT)
+			nr_exit++;
 
-		nr_exit++;
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	if (!exited || !nr_exit) {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 194e2f4..6c15268 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -315,8 +315,7 @@ static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 }
 
 static int hist_entry__period_snprintf(struct perf_hpp *hpp,
-				       struct hist_entry *he,
-				       bool color)
+				       struct hist_entry *he)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct perf_hpp_fmt *fmt;
@@ -338,7 +337,7 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 		} else
 			first = false;
 
-		if (color && fmt->color)
+		if (perf_hpp__use_color() && fmt->color)
 			ret = fmt->color(fmt, hpp, he);
 		else
 			ret = fmt->entry(fmt, hpp, he);
@@ -358,12 +357,11 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.buf		= bf,
 		.size		= size,
 	};
-	bool color = !symbol_conf.field_sep;
 
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he, color);
+	ret = hist_entry__period_snprintf(&hpp, he);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
@@ -482,6 +480,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 print_entries:
 	linesz = hists__sort_list_width(hists) + 3 + 1;
+	linesz += perf_hpp__color_overhead();
 	line = malloc(linesz);
 	if (line == NULL) {
 		ret = -1;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2b585bc..9e99060 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -147,6 +147,9 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 
 struct option;
 
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+int record_callchain_opt(const struct option *opt, const char *arg, int unset);
+
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 63df031..49096ea 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -213,7 +213,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.pgoff,
 		       execname);
 
-		if (n != 8)
+		if (n != 5)
 			continue;
 
 		if (prot[2] != 'x')
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f9f77be..e584cd3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -545,12 +545,19 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 
 	md->prev = old;
 
-	if (!evlist->overwrite)
-		perf_mmap__write_tail(md, old);
-
 	return event;
 }
 
+void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
+{
+	if (!evlist->overwrite) {
+		struct perf_mmap *md = &evlist->mmap[idx];
+		unsigned int old = md->prev;
+
+		perf_mmap__write_tail(md, old);
+	}
+}
+
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 {
 	if (evlist->mmap[idx].base != NULL) {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 880d713..206d093 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -89,6 +89,8 @@ struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
+void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
+
 int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1329b6b..ce8dc61 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "color.h"
 
 extern struct callchain_param callchain_param;
 
@@ -175,6 +176,18 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+static inline size_t perf_hpp__use_color(void)
+{
+	return !symbol_conf.field_sep;
+}
+
+static inline size_t perf_hpp__color_overhead(void)
+{
+	return perf_hpp__use_color() ?
+	       (COLOR_MAXLEN + sizeof(PERF_COLOR_RESET)) * PERF_HPP__MAX_INDEX
+	       : 0;
+}
+
 struct perf_evlist;
 
 struct hist_browser_timer {
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 71b5412..2ac4bc9 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -822,6 +822,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		PyObject *pyevent = pyrf_event__new(event);
 		struct pyrf_event *pevent = (struct pyrf_event *)pyevent;
 
+		perf_evlist__mmap_consume(evlist, cpu);
+
 		if (pyevent == NULL)
 			return PyErr_NoMemory();
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cc75a3c..95d91a0 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -56,6 +56,17 @@ static void handler_call_die(const char *handler_name)
 	Py_FatalError("problem in Python trace event handler");
 }
 
+/*
+ * Insert val into into the dictionary and decrement the reference counter.
+ * This is necessary for dictionaries since PyDict_SetItemString() does not 
+ * steal a reference, as opposed to PyTuple_SetItem().
+ */
+static void pydict_set_item_string_decref(PyObject *dict, const char *key, PyObject *val)
+{
+	PyDict_SetItemString(dict, key, val);
+	Py_DECREF(val);
+}
+
 static void define_value(enum print_arg_type field_type,
 			 const char *ev_name,
 			 const char *field_name,
@@ -279,11 +290,11 @@ static void python_process_tracepoint(union perf_event *perf_event
 		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
 		PyTuple_SetItem(t, n++, PyString_FromString(comm));
 	} else {
-		PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
-		PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
-		PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
-		PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
-		PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
+		pydict_set_item_string_decref(dict, "common_cpu", PyInt_FromLong(cpu));
+		pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
+		pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
+		pydict_set_item_string_decref(dict, "common_pid", PyInt_FromLong(pid));
+		pydict_set_item_string_decref(dict, "common_comm", PyString_FromString(comm));
 	}
 	for (field = event->format.fields; field; field = field->next) {
 		if (field->flags & FIELD_IS_STRING) {
@@ -313,7 +324,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 		if (handler)
 			PyTuple_SetItem(t, n++, obj);
 		else
-			PyDict_SetItemString(dict, field->name, obj);
+			pydict_set_item_string_decref(dict, field->name, obj);
 
 	}
 	if (!handler)
@@ -370,21 +381,21 @@ static void python_process_general_event(union perf_event *perf_event
 	if (!handler || !PyCallable_Check(handler))
 		goto exit;
 
-	PyDict_SetItemString(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
-	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
+	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
 			(const char *)sample, sizeof(*sample)));
-	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
-	PyDict_SetItemString(dict, "comm",
+	pydict_set_item_string_decref(dict, "comm",
 			PyString_FromString(thread->comm));
 	if (al->map) {
-		PyDict_SetItemString(dict, "dso",
+		pydict_set_item_string_decref(dict, "dso",
 			PyString_FromString(al->map->dso->name));
 	}
 	if (al->sym) {
-		PyDict_SetItemString(dict, "symbol",
+		pydict_set_item_string_decref(dict, "symbol",
 			PyString_FromString(al->sym->name));
 	}
 
