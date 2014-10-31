Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbaJaKzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:55:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47862 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaJaKzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:55:50 -0400
Subject: [PATCH perf/core 4/6] perf-probe: Add --no-inlines option to avoid
 searching inline functions
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:51:56 -0400
Message-ID: <20141031185156.27889.81899.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --no-inlines(--inlines) option to avoid searching inline
functions.
Searching all functions which matches glob pattern can take a
long time and find a lot of inline functions. With this option
perf-probe searches target on the non-inlined functions.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/Documentation/perf-probe.txt |    4 ++++
 tools/perf/builtin-probe.c              |    6 +++++-
 tools/perf/util/probe-event.c           |   21 +++++++++++++--------
 tools/perf/util/probe-event.h           |    3 ++-
 tools/perf/util/probe-finder.c          |    8 +++++---
 tools/perf/util/probe-finder.h          |    3 ++-
 6 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 6f183ab..835f685 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -81,6 +81,10 @@ OPTIONS
 	(Only for --vars) Show external defined variables in addition to local
 	variables.
 
+--no-inlines::
+	(Only for --add) Search only for non-inlined functions. The functions
+	which do not have instances are ignored.
+
 -F::
 --funcs::
 	Show available functions in given module or kernel. With -x/--exec,
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c2fa3a3..a910cbc 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,6 +55,7 @@ static struct {
 	bool show_funcs;
 	bool mod_events;
 	bool uprobes;
+	bool no_inlines;
 	bool quiet;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
@@ -386,6 +387,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('m', "module", NULL, "modname|path",
 		"target module name (for online) or path (for offline)",
 		opt_set_target),
+	OPT_BOOLEAN('\0', "no-inlines", &params.no_inlines,
+		"Don't search inlined functions"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
@@ -512,7 +515,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		ret = add_perf_probe_events(params.events, params.nevents,
 					    params.max_probe_points,
 					    params.target, params.output,
-					    params.force_add);
+					    params.force_add,
+					    params.no_inlines);
 		if (ret < 0) {
 			pr_err_with_code("  Error: Failed to add events.", ret);
 			return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2aab9c9..0062114 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -462,7 +462,8 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 					  struct probe_trace_event **tevs,
-					  int max_tevs, const char *target)
+					  int max_tevs, const char *target,
+					  bool no_inline)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	struct debuginfo *dinfo;
@@ -479,7 +480,8 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 
 	pr_debug("Try to find probe point from debuginfo.\n");
 	/* Searching trace events corresponding to a probe event */
-	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs);
+	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs,
+					     no_inline);
 
 	debuginfo__delete(dinfo);
 
@@ -812,7 +814,8 @@ find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 				struct probe_trace_event **tevs __maybe_unused,
 				int max_tevs __maybe_unused,
-				const char *target __maybe_unused)
+				const char *target __maybe_unused,
+				bool no_inline __maybe_unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
@@ -2349,8 +2352,9 @@ err_out:
 }
 
 static int convert_to_probe_trace_events(struct perf_probe_event *pev,
-					  struct probe_trace_event **tevs,
-					  int max_tevs, const char *target)
+					 struct probe_trace_event **tevs,
+					 int max_tevs, const char *target,
+					 bool no_inline)
 {
 	int ret;
 
@@ -2364,7 +2368,8 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target,
+					     no_inline);
 	if (ret != 0)
 		return ret;	/* Found in debuginfo or got an error */
 
@@ -2379,7 +2384,7 @@ struct __event_package {
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 			  int max_tevs, const char *target, const char *output,
-			  bool force_add)
+			  bool force_add, bool no_inline)
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
@@ -2416,7 +2421,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 		ret  = convert_to_probe_trace_events(pkgs[i].pev,
 						     &pkgs[i].tevs,
 						     max_tevs,
-						     target);
+						     target, no_inline);
 		if (ret < 0)
 			goto end;
 		pkgs[i].ntevs = ret;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index df91d0a..93d0b10 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -125,7 +125,8 @@ extern const char *kernel_get_module_path(const char *module);
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 int max_probe_points, const char *module,
-				 const char *output, bool force_add);
+				 const char *output, bool force_add,
+				 bool no_inline);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr, const char *module,
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1914dfd..0c6f6f2 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -926,7 +926,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
 		}
-	} else
+	} else if (!pf->no_inline)
 		/* Inlined function: search instances */
 		param->retval = die_walk_instances(sp_die,
 					probe_point_inline_cb, (void *)pf);
@@ -1178,10 +1178,12 @@ end:
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
 int debuginfo__find_trace_events(struct debuginfo *dbg,
 				 struct perf_probe_event *pev,
-				 struct probe_trace_event **tevs, int max_tevs)
+				 struct probe_trace_event **tevs,
+				 int max_tevs, bool no_inline)
 {
 	struct trace_event_finder tf = {
-			.pf = {.pev = pev, .callback = add_probe_trace_event},
+			.pf = {.pev = pev, .callback = add_probe_trace_event,
+				.no_inline = no_inline},
 			.mod = dbg->mod, .max_tevs = max_tevs};
 	int ret;
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 92590b2..2b77339 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -38,7 +38,7 @@ extern void debuginfo__delete(struct debuginfo *dbg);
 extern int debuginfo__find_trace_events(struct debuginfo *dbg,
 					struct perf_probe_event *pev,
 					struct probe_trace_event **tevs,
-					int max_tevs);
+					int max_tevs, bool no_inline);
 
 /* Find a perf_probe_point from debuginfo */
 extern int debuginfo__find_probe_point(struct debuginfo *dbg,
@@ -76,6 +76,7 @@ struct probe_finder {
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
 	struct probe_trace_arg	*tvar;		/* Current result variable */
+	bool			no_inline;	/* Do not find inlines */
 };
 
 struct trace_event_finder {


