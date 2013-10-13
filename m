Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3JMVSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 17:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3JMVSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 17:18:44 -0400
Date: Sun, 13 Oct 2013 23:18:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC] perf record,top: Add callchain option into .perfconfig
Message-ID: <20131013211805.GA1018@krava>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <87wqljxyqg.fsf@tassilo.jf.intel.com>
 <525875FB.1090104@gmail.com>
 <20131013102521.GA1044@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013102521.GA1044@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 12:25:21PM +0200, Jiri Olsa wrote:

SNIP

> 
> I'll try to come up with something later today
> 
> jirka


hi,
here it is.. not fully tested, no doc updates, dont want
to go too far before we agreed on this ;-)

thanks for comments,
jirka

--
The callchain option is now used only to enable
callchains. By default it's framepointer type.

If dwarf unwind is needed, following option needs
to be added into .perfconfig:

for top command:
  [top]
        call-graph = dwarf,8192

for record command:
  [record]
        call-graph = dwarf,8192

running perf with above config like this:
perf record -g ls
perf top -G

will enable dwarf unwind. The config file option
by itself does not enable the callchain, the -g/-G
option does.

TODO: doc/help needs to be updated

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c | 58 ++++++++++++++++++++++++++++++---------------
 tools/perf/builtin-top.c    | 23 +++++++++++-------
 tools/perf/perf.h           |  1 +
 tools/perf/util/callchain.h |  4 +++-
 tools/perf/util/evsel.c     |  2 +-
 5 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 92ca541..9b245d3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -709,19 +709,35 @@ static int get_stack_size(char *str, unsigned long *_size)
 #endif /* HAVE_LIBUNWIND_SUPPORT */
 
 int record_parse_callchain_opt(const struct option *opt,
-			       const char *arg, int unset)
+			       const char *arg __maybe_unused,
+			       int unset)
 {
 	struct perf_record_opts *opts = opt->value;
-	char *tok, *name, *saveptr = NULL;
-	char *buf;
-	int ret = -1;
+
+	opts->call_graph_enabled = !unset;
 
 	/* --no-call-graph */
-	if (unset)
+	if (unset) {
+		opts->call_graph = CALLCHAIN_NONE;
 		return 0;
+	}
+
+	if (opts->call_graph == CALLCHAIN_NONE)
+		opts->call_graph = CALLCHAIN_FP;
+
+	pr_debug("callchain: type %d\n", opts->call_graph);
+
+	if (opts->call_graph == CALLCHAIN_DWARF)
+		pr_debug("callchain: stack dump size %d\n",
+			 opts->stack_dump_size);
+	return 0;
+}
 
-	/* We specified default option if none is provided. */
-	BUG_ON(!arg);
+int record_parse_callchain(const char *arg, struct perf_record_opts *opts)
+{
+	char *tok, *name, *saveptr = NULL;
+	char *buf;
+	int ret = -1;
 
 	/* We need buffer that we know we can write to. */
 	buf = malloc(strlen(arg) + 1);
@@ -740,7 +756,7 @@ int record_parse_callchain_opt(const struct option *opt,
 				opts->call_graph = CALLCHAIN_FP;
 				ret = 0;
 			} else
-				pr_err("callchain: No more arguments "
+				fprintf(stderr, "callchain: No more arguments "
 				       "needed for -g fp\n");
 			break;
 
@@ -760,13 +776,9 @@ int record_parse_callchain_opt(const struct option *opt,
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-
-			if (!ret)
-				pr_debug("callchain: stack dump size %d\n",
-					 opts->stack_dump_size);
 #endif /* HAVE_LIBUNWIND_SUPPORT */
 		} else {
-			pr_err("callchain: Unknown -g option "
+			fprintf(stderr, "callchain: Unknown -g option "
 			       "value: %s\n", arg);
 			break;
 		}
@@ -774,11 +786,17 @@ int record_parse_callchain_opt(const struct option *opt,
 	} while (0);
 
 	free(buf);
+	return ret;
+}
 
-	if (!ret)
-		pr_debug("callchain: type %d\n", opts->call_graph);
+static int perf_record_config(const char *var, const char *value, void *cb)
+{
+	struct perf_record *rec = cb;
 
-	return ret;
+	if (!strcmp(var, "record.call-graph"))
+		return record_parse_callchain(value, &rec->opts);
+
+	return perf_default_config(var, value, cb);
 }
 
 static const char * const record_usage[] = {
@@ -855,9 +873,9 @@ const struct option record_options[] = {
 		     perf_evlist__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &record_parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('g', "call-graph", &record.opts,
+			   "mode[,dump_size]", record_callchain_help,
+			   &record_parse_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
@@ -906,6 +924,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	rec->evlist = evsel_list;
 
+	perf_config(perf_record_config, rec);
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && perf_target__none(&rec->opts.target))
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 65c49b2..b8e1b96 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1017,17 +1017,20 @@ out_delete:
 static int
 parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	/*
-	 * --no-call-graph
-	 */
-	if (unset)
-		return 0;
-
 	symbol_conf.use_callchain = true;
-
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int perf_top_config(const char *var, const char *value, void *cb)
+{
+	struct perf_top *top = cb;
+
+	if (!strcmp(var, "top.call-graph"))
+		return record_parse_callchain(value, &top->record_opts);
+
+	return perf_default_config(var, value, cb);
+}
+
 static int
 parse_percent_limit(const struct option *opt, const char *arg,
 		    int unset __maybe_unused)
@@ -1109,9 +1112,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
+	OPT_CALLBACK_NOOPT('G', "call-graph", &top.record_opts,
 			     "mode[,dump_size]", record_callchain_help,
-			     &parse_callchain_opt, "fp"),
+			     &parse_callchain_opt),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
@@ -1145,6 +1148,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 84502e8..fed8903 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -215,6 +215,7 @@ enum perf_call_graph_mode {
 struct perf_record_opts {
 	struct perf_target target;
 	int	     call_graph;
+	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2b585bc..b3e796b 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -147,6 +147,8 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 
 struct option;
 
-int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+int record_parse_callchain_opt(const struct option *opt, const char *arg,
+			       int unset);
+int record_parse_callchain(const char *arg, struct perf_record_opts *rec);
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bfebc1e..8f3dd33 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -633,7 +633,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
+	if (opts->call_graph_enabled) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
-- 
1.7.11.7

