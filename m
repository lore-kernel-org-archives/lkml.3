Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3JKHKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:10:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54565 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3JKHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:10:27 -0400
Subject: [PATCH -tip 1/2] perf probe: Support "$vars" meta argument syntax for
 local variables
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 11 Oct 2013 16:10:23 +0900
Message-ID: <20131011071023.15557.51770.stgit@udc4-manage.rcp.hitachi.co.jp>
In-Reply-To: <20131011071020.15557.20050.stgit@udc4-manage.rcp.hitachi.co.jp>
References: <20131011071020.15557.20050.stgit@udc4-manage.rcp.hitachi.co.jp>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support "$vars" meta argument syntax for tracing all
local variables at probe point.

Now you can trace all available local variables (including
function parameters) at the probe point by passing $vars.

# perf probe --add foo $vars

This automatically finds all local variables at foo()
and adds it as probe arguments.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/probe-event.c  |    1 
 tools/perf/util/probe-finder.c |   96 +++++++++++++++++++++++++++++++++++++---
 tools/perf/util/probe-finder.h |    1 
 3 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index aa04bf9..a0f0c45 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -47,7 +47,6 @@
 #include "session.h"
 
 #define MAX_CMDLEN 256
-#define MAX_PROBE_ARGS 128
 #define PERFPROBE_GROUP "probe"
 
 bool probe_event_dry_run;	/* Dry run flag */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c09e0a9..5a46be9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1136,12 +1136,78 @@ found:
 	return ret;
 }
 
+struct local_vars_finder {
+	struct probe_finder *pf;
+	struct perf_probe_arg *args;
+	int max_args;
+	int nargs;
+	int ret;
+};
+
+/* Collect available variables in this scope */
+static int copy_variables_cb(Dwarf_Die *die_mem, void *data)
+{
+	struct local_vars_finder *vf = data;
+	int tag;
+
+	tag = dwarf_tag(die_mem);
+	if (tag == DW_TAG_formal_parameter ||
+	    tag == DW_TAG_variable) {
+		if (convert_variable_location(die_mem, vf->pf->addr,
+					      vf->pf->fb_ops, NULL) == 0) {
+			vf->args[vf->nargs].var = (char *)dwarf_diename(die_mem);
+			if (vf->args[vf->nargs].var == NULL) {
+				vf->ret = -ENOMEM;
+				return DIE_FIND_CB_END;
+			}
+			pr_debug(" %s", vf->args[vf->nargs].var);
+			vf->nargs++;
+		}
+	}
+
+	if (dwarf_haspc(die_mem, vf->pf->addr))
+		return DIE_FIND_CB_CONTINUE;
+	else
+		return DIE_FIND_CB_SIBLING;
+}
+
+static int expand_probe_args(Dwarf_Die *sc_die, struct probe_finder *pf,
+			     struct perf_probe_arg *args)
+{
+	Dwarf_Die die_mem;
+	int i;
+	int n = 0;
+	struct local_vars_finder vf = {.pf = pf, .args = args,
+				.max_args = MAX_PROBE_ARGS, .ret = 0};
+
+	for (i = 0; i < pf->pev->nargs; i++) {
+		/* var never be NULL */
+		if (strcmp(pf->pev->args[i].var, "$vars") == 0) {
+			pr_debug("Expanding $vars into:");
+			vf.nargs = n;
+			/* Special local variables */
+			die_find_child(sc_die, copy_variables_cb, (void *)&vf,
+				       &die_mem);
+			pr_debug(" (%d)\n", vf.nargs - n);
+			if (vf.ret < 0)
+				return vf.ret;
+			n = vf.nargs;
+		} else {
+			/* Copy normal argument */
+			args[n] = pf->pev->args[i];
+			n++;
+		}
+	}
+	return n;
+}
+
 /* Add a found probe point into trace event list */
 static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	struct trace_event_finder *tf =
 			container_of(pf, struct trace_event_finder, pf);
 	struct probe_trace_event *tev;
+	struct perf_probe_arg *args;
 	int ret, i;
 
 	/* Check number of tevs */
@@ -1161,21 +1227,35 @@ static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
 		 tev->point.offset);
 
-	/* Find each argument */
-	tev->nargs = pf->pev->nargs;
-	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
-	if (tev->args == NULL)
+	/* Expand special probe argument if exist */
+	args = zalloc(sizeof(struct perf_probe_arg) * MAX_PROBE_ARGS);
+	if (args == NULL)
 		return -ENOMEM;
-	for (i = 0; i < pf->pev->nargs; i++) {
-		pf->pvar = &pf->pev->args[i];
+
+	ret = expand_probe_args(sc_die, pf, args);
+	if (ret < 0)
+		goto end;
+
+	tev->nargs = ret;
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
+	if (tev->args == NULL) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	/* Find each argument */
+	for (i = 0; i < tev->nargs; i++) {
+		pf->pvar = &args[i];
 		pf->tvar = &tev->args[i];
 		/* Variable should be found from scope DIE */
 		ret = find_variable(sc_die, pf);
 		if (ret != 0)
-			return ret;
+			break;
 	}
 
-	return 0;
+end:
+	free(args);
+	return ret;
 }
 
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 3b7d630..36da99f 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -7,6 +7,7 @@
 
 #define MAX_PROBE_BUFFER	1024
 #define MAX_PROBES		 128
+#define MAX_PROBE_ARGS		 128
 
 static inline int is_c_varname(const char *name)
 {


