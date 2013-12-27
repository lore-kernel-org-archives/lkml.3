Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3L0Usc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:48:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3L0Ur1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 49/49] perf tools: Use zfree to help detect use after free bugs
Date: Fri, 27 Dec 2013 17:47:05 -0300
Message-Id: <1388177225-17349-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Several areas already used this technique, so do some audit to
consistently use it elsewhere.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9sbere0kkplwe45ak6rk4a1f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c          |  2 +-
 tools/perf/builtin-sched.c         |  2 +-
 tools/perf/builtin-script.c        |  6 +++---
 tools/perf/ui/browsers/hists.c     |  2 +-
 tools/perf/ui/stdio/hist.c         |  2 +-
 tools/perf/util/annotate.c         | 20 ++++++++++----------
 tools/perf/util/cgroup.c           |  2 +-
 tools/perf/util/comm.c             |  2 +-
 tools/perf/util/evsel.c            |  8 ++++----
 tools/perf/util/header.c           | 10 +++++-----
 tools/perf/util/help.c             |  4 ++--
 tools/perf/util/hist.c             |  6 +++---
 tools/perf/util/parse-events.c     |  8 ++++----
 tools/perf/util/pmu.c              |  2 +-
 tools/perf/util/probe-event.c      |  8 ++++----
 tools/perf/util/probe-finder.c     |  2 +-
 tools/perf/util/session.c          | 24 ++++++++++++------------
 tools/perf/util/srcline.c          |  6 +++---
 tools/perf/util/strbuf.c           |  2 +-
 tools/perf/util/strfilter.c        |  2 +-
 tools/perf/util/string.c           |  2 +-
 tools/perf/util/strlist.c          |  3 ++-
 tools/perf/util/svghelper.c        |  5 +++--
 tools/perf/util/symbol-elf.c       |  2 +-
 tools/perf/util/symbol-minimal.c   |  3 ++-
 tools/perf/util/symbol.c           |  2 +-
 tools/perf/util/thread_map.c       | 10 +++++-----
 tools/perf/util/trace-event-info.c |  4 ++--
 tools/perf/util/values.c           | 14 +++++++-------
 29 files changed, 84 insertions(+), 81 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2a85cc9a2d09..e6a0844bc2f0 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -654,7 +654,7 @@ static void data__free(struct data__file *d)
 	for (col = 0; col < PERF_HPP_DIFF__MAX_INDEX; col++) {
 		struct diff_hpp_fmt *fmt = &d->fmt[col];
 
-		free(fmt->header);
+		zfree(&fmt->header);
 	}
 }
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0f3c65518a2c..6a76a07b6789 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -469,7 +469,7 @@ static void *thread_func(void *ctx)
 	char comm2[22];
 	int fd;
 
-	free(parms);
+	zfree(&parms);
 
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 62ef190c4320..6040000bdfa6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1102,9 +1102,9 @@ static struct script_desc *script_desc__new(const char *name)
 
 static void script_desc__delete(struct script_desc *s)
 {
-	free(s->name);
-	free(s->half_liner);
-	free(s->args);
+	zfree(&s->name);
+	zfree(&s->half_liner);
+	zfree(&s->args);
 	free(s);
 }
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 022d1731b801..a7045ea6d1d5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1327,7 +1327,7 @@ static int switch_data_file(void)
 
 			abs_path[nr_options] = strdup(path);
 			if (!abs_path[nr_options]) {
-				free(options[nr_options]);
+				zfree(&options[nr_options]);
 				ui__warning("Can't search all data files due to memory shortage.\n");
 				fclose(file);
 				break;
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index c244cb524ef2..831fbb77d1ff 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -510,7 +510,7 @@ print_entries:
 
 	free(line);
 out:
-	free(rem_sq_bracket);
+	zfree(&rem_sq_bracket);
 
 	return ret;
 }
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a78721d14694..469eb679fb9d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -26,10 +26,10 @@ static int disasm_line__parse(char *line, char **namep, char **rawp);
 
 static void ins__delete(struct ins_operands *ops)
 {
-	free(ops->source.raw);
-	free(ops->source.name);
-	free(ops->target.raw);
-	free(ops->target.name);
+	zfree(&ops->source.raw);
+	zfree(&ops->source.name);
+	zfree(&ops->target.raw);
+	zfree(&ops->target.name);
 }
 
 static int ins__raw_scnprintf(struct ins *ins, char *bf, size_t size,
@@ -204,9 +204,9 @@ static int lock__scnprintf(struct ins *ins, char *bf, size_t size,
 
 static void lock__delete(struct ins_operands *ops)
 {
-	free(ops->locked.ops);
-	free(ops->target.raw);
-	free(ops->target.name);
+	zfree(&ops->locked.ops);
+	zfree(&ops->target.raw);
+	zfree(&ops->target.name);
 }
 
 static struct ins_ops lock_ops = {
@@ -583,7 +583,7 @@ static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privs
 	return dl;
 
 out_free_line:
-	free(dl->line);
+	zfree(&dl->line);
 out_delete:
 	free(dl);
 	return NULL;
@@ -591,8 +591,8 @@ out_delete:
 
 void disasm_line__free(struct disasm_line *dl)
 {
-	free(dl->line);
-	free(dl->name);
+	zfree(&dl->line);
+	zfree(&dl->name);
 	if (dl->ins && dl->ins->ops->free)
 		dl->ins->ops->free(&dl->ops);
 	else
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 96bbda1ddb83..0922aa4218c2 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -133,7 +133,7 @@ void close_cgroup(struct cgroup_sel *cgrp)
 	/* XXX: not reentrant */
 	if (--cgrp->refcnt == 0) {
 		close(cgrp->fd);
-		free(cgrp->name);
+		zfree(&cgrp->name);
 		free(cgrp);
 	}
 }
diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index ee0df0e24cdb..67d1e404c0cb 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -21,7 +21,7 @@ static void comm_str__put(struct comm_str *cs)
 {
 	if (!--cs->ref) {
 		rb_erase(&cs->rb_node, &comm_str_root);
-		free(cs->str);
+		zfree(&cs->str);
 		free(cs);
 	}
 }
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 93b6031d5459..ade8d9c1c431 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -208,7 +208,7 @@ struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int
 	return evsel;
 
 out_free:
-	free(evsel->name);
+	zfree(&evsel->name);
 	free(evsel);
 	return NULL;
 }
@@ -766,7 +766,7 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 void perf_evsel__free_counts(struct perf_evsel *evsel)
 {
-	free(evsel->counts);
+	zfree(&evsel->counts);
 }
 
 void perf_evsel__exit(struct perf_evsel *evsel)
@@ -780,10 +780,10 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
-	free(evsel->group_name);
+	zfree(&evsel->group_name);
 	if (evsel->tp_format)
 		pevent_free_format(evsel->tp_format);
-	free(evsel->name);
+	zfree(&evsel->name);
 	free(evsel);
 }
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 20f3a9c97bd8..a4a60b7887ee 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -800,10 +800,10 @@ static void free_cpu_topo(struct cpu_topo *tp)
 		return;
 
 	for (i = 0 ; i < tp->core_sib; i++)
-		free(tp->core_siblings[i]);
+		zfree(&tp->core_siblings[i]);
 
 	for (i = 0 ; i < tp->thread_sib; i++)
-		free(tp->thread_siblings[i]);
+		zfree(&tp->thread_siblings[i]);
 
 	free(tp);
 }
@@ -1232,8 +1232,8 @@ static void free_event_desc(struct perf_evsel *events)
 		return;
 
 	for (evsel = events; evsel->attr.size; evsel++) {
-		free(evsel->name);
-		free(evsel->id);
+		zfree(&evsel->name);
+		zfree(&evsel->id);
 	}
 
 	free(events);
@@ -2105,7 +2105,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 	ret = 0;
 out_free:
 	for (i = 0; i < nr_groups; i++)
-		free(desc[i].name);
+		zfree(&desc[i].name);
 	free(desc);
 
 	return ret;
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 7b68978e50d2..86c37c472263 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -22,8 +22,8 @@ static void clean_cmdnames(struct cmdnames *cmds)
 	unsigned int i;
 
 	for (i = 0; i < cmds->cnt; ++i)
-		free(cmds->names[i]);
-	free(cmds->names);
+		zfree(&cmds->names[i]);
+	zfree(&cmds->names);
 	cmds->cnt = 0;
 	cmds->alloc = 0;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6cd4823a7a8b..4ed3e883240d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -372,7 +372,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			 * This mem info was allocated from machine__resolve_mem
 			 * and will not be used anymore.
 			 */
-			free(entry->mem_info);
+			zfree(&entry->mem_info);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -475,8 +475,8 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 
 void hist_entry__free(struct hist_entry *he)
 {
-	free(he->branch_info);
-	free(he->mem_info);
+	zfree(&he->branch_info);
+	zfree(&he->mem_info);
 	free_srcline(he->srcline);
 	free(he);
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 094c28ba2fae..0153435b8427 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -204,7 +204,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 				}
 				path->name = malloc(MAX_EVENT_LENGTH);
 				if (!path->name) {
-					free(path->system);
+					zfree(&path->system);
 					free(path);
 					return NULL;
 				}
@@ -236,8 +236,8 @@ struct tracepoint_path *tracepoint_name_to_path(const char *name)
 	path->name = strdup(str+1);
 
 	if (path->system == NULL || path->name == NULL) {
-		free(path->system);
-		free(path->name);
+		zfree(&path->system);
+		zfree(&path->name);
 		free(path);
 		path = NULL;
 	}
@@ -917,7 +917,7 @@ int parse_events_terms(struct list_head *terms, const char *str)
 	ret = parse_events__scanner(str, &data, PE_START_TERMS);
 	if (!ret) {
 		list_splice(data.terms, terms);
-		free(data.terms);
+		zfree(&data.terms);
 		return 0;
 	}
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 56fc10a5e288..0934d645ebdc 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -755,7 +755,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			continue;
 		}
 		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
-		free(aliases[j]);
+		zfree(&aliases[j]);
 		printed++;
 	}
 	if (printed)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4d3cd1a0278a..86ed8580c3cb 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -356,7 +356,7 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 		offset = tevs[i].point.address - stext;
 		offset += tevs[i].point.offset;
 		tevs[i].point.offset = 0;
-		free(tevs[i].point.symbol);
+		zfree(&tevs[i].point.symbol);
 		ret = e_snprintf(buf, 32, "0x%lx", offset);
 		if (ret < 0)
 			break;
@@ -683,7 +683,7 @@ static int show_available_vars_at(struct debuginfo *dinfo,
 		 */
 		fprintf(stdout, "\t@<%s+%lu>\n", vl->point.symbol,
 			vl->point.offset);
-		free(vl->point.symbol);
+		zfree(&vl->point.symbol);
 		nvars = 0;
 		if (vl->vars) {
 			strlist__for_each(node, vl->vars) {
@@ -1592,7 +1592,7 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 		field = pev->args[i].field;
 		while (field) {
 			next = field->next;
-			free(field->name);
+			zfree(&field->name);
 			free(field);
 			field = next;
 		}
@@ -2153,7 +2153,7 @@ end:
 	for (i = 0; i < npevs; i++) {
 		for (j = 0; j < pkgs[i].ntevs; j++)
 			clear_probe_trace_event(&pkgs[i].tevs[j]);
-		free(pkgs[i].tevs);
+		zfree(&pkgs[i].tevs);
 	}
 	free(pkgs);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 6d8796e38d7f..061edb162b5b 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1409,7 +1409,7 @@ int debuginfo__find_available_vars_at(struct debuginfo *dbg,
 	if (ret < 0) {
 		/* Free vlist for error */
 		while (af.nvls--) {
-			free(af.vls[af.nvls].point.symbol);
+			zfree(&af.vls[af.nvls].point.symbol);
 			strlist__delete(af.vls[af.nvls].vars);
 		}
 		zfree(vls);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d3a857be9682..8ffe29c55d0f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -132,18 +132,18 @@ static void perf_session__delete_threads(struct perf_session *session)
 
 static void perf_session_env__delete(struct perf_session_env *env)
 {
-	free(env->hostname);
-	free(env->os_release);
-	free(env->version);
-	free(env->arch);
-	free(env->cpu_desc);
-	free(env->cpuid);
-
-	free(env->cmdline);
-	free(env->sibling_cores);
-	free(env->sibling_threads);
-	free(env->numa_nodes);
-	free(env->pmu_mappings);
+	zfree(&env->hostname);
+	zfree(&env->os_release);
+	zfree(&env->version);
+	zfree(&env->arch);
+	zfree(&env->cpu_desc);
+	zfree(&env->cpuid);
+
+	zfree(&env->cmdline);
+	zfree(&env->sibling_cores);
+	zfree(&env->sibling_threads);
+	zfree(&env->numa_nodes);
+	zfree(&env->pmu_mappings);
 }
 
 void perf_session__delete(struct perf_session *session)
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 58b2bd8f38c9..7e67879ebd25 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -129,7 +129,7 @@ static struct a2l_data *addr2line_init(const char *path)
 
 out:
 	if (a2l) {
-		free((void *)a2l->input);
+		zfree((void **)&a2l->input);
 		free(a2l);
 	}
 	bfd_close(abfd);
@@ -140,8 +140,8 @@ static void addr2line_cleanup(struct a2l_data *a2l)
 {
 	if (a2l->abfd)
 		bfd_close(a2l->abfd);
-	free((void *)a2l->input);
-	free(a2l->syms);
+	zfree((void **)&a2l->input);
+	zfree(&a2l->syms);
 	free(a2l);
 }
 
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index cfa906882e2c..4abe23550c73 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -28,7 +28,7 @@ void strbuf_init(struct strbuf *sb, ssize_t hint)
 void strbuf_release(struct strbuf *sb)
 {
 	if (sb->alloc) {
-		free(sb->buf);
+		zfree(&sb->buf);
 		strbuf_init(sb, 0);
 	}
 }
diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
index 3edd0538161f..79a757a2a15c 100644
--- a/tools/perf/util/strfilter.c
+++ b/tools/perf/util/strfilter.c
@@ -14,7 +14,7 @@ static void strfilter_node__delete(struct strfilter_node *node)
 {
 	if (node) {
 		if (node->p && !is_operator(*node->p))
-			free((char *)node->p);
+			zfree((char **)&node->p);
 		strfilter_node__delete(node->l);
 		strfilter_node__delete(node->r);
 		free(node);
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index f0b0c008c507..2553e5b55b89 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -128,7 +128,7 @@ void argv_free(char **argv)
 {
 	char **p;
 	for (p = argv; *p; p++)
-		free(*p);
+		zfree(p);
 
 	free(argv);
 }
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index eabdce0a2daa..61a90bf24b4d 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -5,6 +5,7 @@
  */
 
 #include "strlist.h"
+#include "util.h"
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -38,7 +39,7 @@ out_delete:
 static void str_node__delete(struct str_node *snode, bool dupstr)
 {
 	if (dupstr)
-		free((void *)snode->s);
+		zfree((void **)&snode->s);
 	free(snode);
 }
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 56a84f2cc46d..43262b83c541 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -21,6 +21,7 @@
 
 #include "perf.h"
 #include "svghelper.h"
+#include "util.h"
 #include "cpumap.h"
 
 static u64 first_time, last_time;
@@ -708,8 +709,8 @@ int svg_build_topology_map(char *sib_core, int sib_core_nr,
 	return 0;
 
 exit:
-	free(t.sib_core);
-	free(t.sib_thr);
+	zfree(&t.sib_core);
+	zfree(&t.sib_thr);
 
 	return -1;
 }
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index bf0ce29567b6..4b0a127a4d3b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -554,7 +554,7 @@ bool symsrc__has_symtab(struct symsrc *ss)
 
 void symsrc__destroy(struct symsrc *ss)
 {
-	free(ss->name);
+	zfree(&ss->name);
 	elf_end(ss->elf);
 	close(ss->fd);
 }
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index ac7070a2f2b6..bd15f490d04f 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,4 +1,5 @@
 #include "symbol.h"
+#include "util.h"
 
 #include <stdio.h>
 #include <fcntl.h>
@@ -275,7 +276,7 @@ bool symsrc__has_symtab(struct symsrc *ss __maybe_unused)
 
 void symsrc__destroy(struct symsrc *ss)
 {
-	free(ss->name);
+	zfree(&ss->name);
 	close(ss->fd);
 }
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fd9e1a4fad16..39ce9adbaaf0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -796,7 +796,7 @@ static void delete_modules(struct rb_root *modules)
 		mi = rb_entry(next, struct module_info, rb_node);
 		next = rb_next(&mi->rb_node);
 		rb_erase(&mi->rb_node, modules);
-		free(mi->name);
+		zfree(&mi->name);
 		free(mi);
 	}
 }
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index cf44644a4058..5d3215912105 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -41,7 +41,7 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 	}
 
 	for (i=0; i<items; i++)
-		free(namelist[i]);
+		zfree(&namelist[i]);
 	free(namelist);
 
 	return threads;
@@ -118,7 +118,7 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
 			threads->map[threads->nr + i] = atoi(namelist[i]->d_name);
 
 		for (i = 0; i < items; i++)
-			free(namelist[i]);
+			zfree(&namelist[i]);
 		free(namelist);
 
 		threads->nr += items;
@@ -135,7 +135,7 @@ out_free_threads:
 
 out_free_namelist:
 	for (i = 0; i < items; i++)
-		free(namelist[i]);
+		zfree(&namelist[i]);
 	free(namelist);
 
 out_free_closedir:
@@ -194,7 +194,7 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 
 		for (i = 0; i < items; i++) {
 			threads->map[j++] = atoi(namelist[i]->d_name);
-			free(namelist[i]);
+			zfree(&namelist[i]);
 		}
 		threads->nr = total_tasks;
 		free(namelist);
@@ -206,7 +206,7 @@ out:
 
 out_free_namelist:
 	for (i = 0; i < items; i++)
-		free(namelist[i]);
+		zfree(&namelist[i]);
 	free(namelist);
 
 out_free_threads:
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 9f73bf43862c..7e6fcfe8b438 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -397,8 +397,8 @@ put_tracepoints_path(struct tracepoint_path *tps)
 		struct tracepoint_path *t = tps;
 
 		tps = tps->next;
-		free(t->name);
-		free(t->system);
+		zfree(&t->name);
+		zfree(&t->system);
 		free(t);
 	}
 }
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 697c8b4e59cc..0fb3c1fcd3e6 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -31,14 +31,14 @@ void perf_read_values_destroy(struct perf_read_values *values)
 		return;
 
 	for (i = 0; i < values->threads; i++)
-		free(values->value[i]);
-	free(values->value);
-	free(values->pid);
-	free(values->tid);
-	free(values->counterrawid);
+		zfree(&values->value[i]);
+	zfree(&values->value);
+	zfree(&values->pid);
+	zfree(&values->tid);
+	zfree(&values->counterrawid);
 	for (i = 0; i < values->counters; i++)
-		free(values->countername[i]);
-	free(values->countername);
+		zfree(&values->countername[i]);
+	zfree(&values->countername);
 }
 
 static void perf_read_values__enlarge_threads(struct perf_read_values *values)
-- 
1.8.1.4

