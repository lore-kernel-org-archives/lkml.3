Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbaJaK4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:56:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47903 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015AbaJaK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:56:04 -0400
Subject: [PATCH perf/core 6/6] perf-probe: Support glob wildcards for
 function name
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:52:10 -0400
Message-ID: <20141031185210.27889.51399.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support glob wildcards for function name when adding
new probes. This will allow us to build caches of
function-entry level information with $params.

e.g.
  # perf probe --max-probes=100000 --no-inlines -a '* $params' -o event.cache

builds "event.cache" file in which event settings for
all function entries, like below;

  p:probe/reset_early_page_tables _text+12980741
  p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
  p:probe/exit_amd_microcode _text+14692680
  p:probe/early_make_pgtable _text+12981274 address=%di:u64
  p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
  p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
  p:probe/reserve_ebda_region _text+12982117

This event.cache file will be big if your kernel have many
option embedded. Anyway, you can compress it too.

  # wc -l event.cache
  33813 event.cache
  # ls -sh event.cache
  2.3M event.cache
  # ls -sh event.cache.gz
  464K event.cache.gz

For setting up a probe event, you can grep the function name
and write it to tracing/kprobe_events, as below;

  # zcat event.cache.gz | \
    grep probe/vfs_symlink > /sys/kernel/debug/tracing/kprobe_events

This can be applied for the remote machine only if the machine
runs on completely same kernel binary.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/dwarf-aux.c    |   16 ++++++++++++++++
 tools/perf/util/dwarf-aux.h    |    3 +++
 tools/perf/util/probe-event.c  |   15 +++++++++++----
 tools/perf/util/probe-event.h  |    1 +
 tools/perf/util/probe-finder.c |   27 +++++++++++++++++++++------
 tools/perf/util/util.h         |    4 ++++
 6 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 780b2bc..8db75cf 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -139,11 +139,27 @@ int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
 	const char *name;
+
 	name = dwarf_diename(dw_die);
 	return name ? (strcmp(tname, name) == 0) : false;
 }
 
 /**
+ * die_match_name - Match diename and glob
+ * @dw_die: a DIE
+ * @glob: a string of target glob pattern
+ *
+ * Glob matching the name of @dw_die and @glob. Return false if matching fail.
+ */
+bool die_match_name(Dwarf_Die *dw_die, const char *glob)
+{
+	const char *name;
+
+	name = dwarf_diename(dw_die);
+	return name ? strglobmatch(name, glob) : false;
+}
+
+/**
  * die_get_call_lineno - Get callsite line number of inline-function instance
  * @in_die: a DIE of an inlined function instance
  *
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index af7dbcd..50a3cdc 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -47,6 +47,9 @@ extern bool die_is_func_instance(Dwarf_Die *dw_die);
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
+/* Matching diename with glob pattern */
+extern bool die_match_name(Dwarf_Die *dw_die, const char *glob);
+
 /* Get callsite line number of inline-function instance */
 extern int die_get_call_lineno(Dwarf_Die *in_die);
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0062114..7a8ce15 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -450,7 +450,11 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 			tmp = strdup(reloc_sym->name);
 			if (!tmp)
 				return -ENOMEM;
-			free(tevs[i].point.symbol);
+			/* If we have no realname, use symbol for it */
+			if (!tevs[i].point.realname)
+				tevs[i].point.realname = tevs[i].point.symbol;
+			else
+				free(tevs[i].point.symbol);
 			tevs[i].point.symbol = tmp;
 			tevs[i].point.offset = tevs[i].point.address -
 					       reloc_sym->unrelocated_addr;
@@ -1778,6 +1782,7 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 	free(tev->event);
 	free(tev->group);
 	free(tev->point.symbol);
+	free(tev->point.realname);
 	free(tev->point.module);
 	for (i = 0; i < tev->nargs; i++) {
 		free(tev->args[i].name);
@@ -2113,6 +2118,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	char buf[64];
 	const char *event, *group;
 	struct strlist *namelist;
+	bool safename;
 
 	if (outfd >= 0)
 		fd = outfd;
@@ -2137,6 +2143,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		return -EIO;
 	}
 
+	safename = (pev->point.function && !strisglob(pev->point.function));
 	ret = 0;
 	pr_info("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
@@ -2144,10 +2151,10 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		if (pev->event)
 			event = pev->event;
 		else
-			if (pev->point.function)
+			if (safename)
 				event = pev->point.function;
 			else
-				event = tev->point.symbol;
+				event = tev->point.realname;
 		if (pev->group)
 			group = pev->group;
 		else
@@ -2210,7 +2217,7 @@ static int probe_function_filter(struct map *map __maybe_unused,
 				      struct symbol *sym)
 {
 	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
-	    strcmp(looking_function_name, sym->name) == 0) {
+	    strglobmatch(sym->name, looking_function_name)) {
 		num_matched_functions++;
 		return 0;
 	}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 93d0b10..5b45e2a 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,6 +10,7 @@ extern bool probe_event_dry_run;
 
 /* kprobe-tracer and uprobe-tracer tracing point */
 struct probe_trace_point {
+	char		*realname;	/* function real name (if needed) */
 	char		*symbol;	/* Base symbol */
 	char		*module;	/* Module name */
 	unsigned long	offset;		/* Offset from symbol */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d1fcab7..dfaf88a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -711,7 +711,7 @@ static int find_best_scope_cb(Dwarf_Die *fn_die, void *data)
 	}
 	/* If the function name is given, that's what user expects */
 	if (fsp->function) {
-		if (die_compare_name(fn_die, fsp->function)) {
+		if (die_match_name(fn_die, fsp->function)) {
 			memcpy(fsp->die_mem, fn_die, sizeof(Dwarf_Die));
 			fsp->found = true;
 			return 1;
@@ -903,13 +903,14 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 
 	/* Check tag and diename */
 	if (!die_is_func_def(sp_die) ||
-	    !die_compare_name(sp_die, pp->function))
+	    !die_match_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
 	if (pp->file && strtailcmp(pp->file, dwarf_decl_file(sp_die)))
 		return DWARF_CB_OK;
 
+	pr_debug("Matched function: %s\n", dwarf_diename(sp_die));
 	pf->fname = dwarf_decl_file(sp_die);
 	if (pp->line) { /* Function relative line */
 		dwarf_decl_line(sp_die, &pf->lno);
@@ -926,10 +927,20 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
 		}
-	} else if (!pf->no_inline)
+	} else if (!pf->no_inline) {
 		/* Inlined function: search instances */
 		param->retval = die_walk_instances(sp_die,
 					probe_point_inline_cb, (void *)pf);
+		/* This could be a non-existed inline definition */
+		if (param->retval == -ENOENT && strisglob(pp->function))
+			param->retval = 0;
+	}
+
+	/* We need to find other candidates */
+	if (strisglob(pp->function) && param->retval >= 0) {
+		param->retval = 0;	/* We have to clear the result */
+		return DWARF_CB_OK;
+	}
 
 	return DWARF_CB_ABORT; /* Exit; no same symbol in this CU. */
 }
@@ -958,7 +969,7 @@ static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
 		if (dwarf_tag(param->sp_die) != DW_TAG_subprogram)
 			return DWARF_CB_OK;
 
-		if (die_compare_name(param->sp_die, param->function)) {
+		if (die_match_name(param->sp_die, param->function)) {
 			if (!dwarf_offdie(dbg, gl->cu_offset, param->cu_die))
 				return DWARF_CB_OK;
 
@@ -995,7 +1006,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 		return -ENOMEM;
 
 	/* Fastpath: lookup by function name from .debug_pubnames section */
-	if (pp->function) {
+	if (pp->function && !strisglob(pp->function)) {
 		struct pubname_callback_param pubname_param = {
 			.function = pp->function,
 			.file	  = pp->file,
@@ -1144,6 +1155,10 @@ static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 	if (ret < 0)
 		return ret;
 
+	tev->point.realname = strdup(dwarf_diename(sc_die));
+	if (!tev->point.realname)
+		return -ENOMEM;
+
 	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
 		 tev->point.offset);
 
@@ -1508,7 +1523,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 		return DWARF_CB_OK;
 
 	if (die_is_func_def(sp_die) &&
-	    die_compare_name(sp_die, lr->function)) {
+	    die_match_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);
 		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 80bfdaa..6f5683d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -257,6 +257,10 @@ char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
+static inline bool strisglob(const char *str)
+{
+	return strpbrk(str, "*?[") != NULL;
+}
 int strtailcmp(const char *s1, const char *s2);
 char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);


