Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbaJaK4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:56:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47883 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaJaKz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:55:58 -0400
Subject: [PATCH perf/core 5/6] perf-probe: Support $params special probe
 argument
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:52:03 -0400
Message-ID: <20141031185203.27889.26931.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$params is similar to $vars but matches only function parameters
not local variables.
Thus, this is useful for tracing function parameter changing
or tracing function call with parameters.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-finder.c          |   29 ++++++++++++++++-------------
 tools/perf/util/probe-finder.h          |    3 +++
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 835f685..fde40640 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -157,7 +157,7 @@ Each probe argument follows below syntax.
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
-'$vars' special argument is also available for NAME, it is expanded to the local variables which can access at given probe point.
+'$vars' and '$params' special arguments are also available for NAME, '$vars' is expanded to the local variables (including function parameters) which can access at given probe point. '$params' is expanded to only the function parameters.
 'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
 On x86 systems %REG is always the short form of the register: for example %AX. %RAX or %EAX is not valid.
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 0c6f6f2..d1fcab7 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1054,6 +1054,7 @@ found:
 struct local_vars_finder {
 	struct probe_finder *pf;
 	struct perf_probe_arg *args;
+	bool vars;
 	int max_args;
 	int nargs;
 	int ret;
@@ -1068,7 +1069,7 @@ static int copy_variables_cb(Dwarf_Die *die_mem, void *data)
 
 	tag = dwarf_tag(die_mem);
 	if (tag == DW_TAG_formal_parameter ||
-	    tag == DW_TAG_variable) {
+	    (tag == DW_TAG_variable && vf->vars)) {
 		if (convert_variable_location(die_mem, vf->pf->addr,
 					      vf->pf->fb_ops, &pf->sp_die,
 					      NULL) == 0) {
@@ -1094,26 +1095,28 @@ static int expand_probe_args(Dwarf_Die *sc_die, struct probe_finder *pf,
 	Dwarf_Die die_mem;
 	int i;
 	int n = 0;
-	struct local_vars_finder vf = {.pf = pf, .args = args,
+	struct local_vars_finder vf = {.pf = pf, .args = args, .vars = false,
 				.max_args = MAX_PROBE_ARGS, .ret = 0};
 
 	for (i = 0; i < pf->pev->nargs; i++) {
 		/* var never be NULL */
-		if (strcmp(pf->pev->args[i].var, "$vars") == 0) {
-			pr_debug("Expanding $vars into:");
-			vf.nargs = n;
-			/* Special local variables */
-			die_find_child(sc_die, copy_variables_cb, (void *)&vf,
-				       &die_mem);
-			pr_debug(" (%d)\n", vf.nargs - n);
-			if (vf.ret < 0)
-				return vf.ret;
-			n = vf.nargs;
-		} else {
+		if (strcmp(pf->pev->args[i].var, PROBE_ARG_VARS) == 0)
+			vf.vars = true;
+		else if (strcmp(pf->pev->args[i].var, PROBE_ARG_PARAMS) != 0) {
 			/* Copy normal argument */
 			args[n] = pf->pev->args[i];
 			n++;
+			continue;
 		}
+		pr_debug("Expanding %s into:", pf->pev->args[i].var);
+		vf.nargs = n;
+		/* Special local variables */
+		die_find_child(sc_die, copy_variables_cb, (void *)&vf,
+			       &die_mem);
+		pr_debug(" (%d)\n", vf.nargs - n);
+		if (vf.ret < 0)
+			return vf.ret;
+		n = vf.nargs;
 	}
 	return n;
 }
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 2b77339..7a340d3 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -10,6 +10,9 @@
 #define MAX_PROBES		 128
 #define MAX_PROBE_ARGS		 128
 
+#define PROBE_ARG_VARS		"$vars"
+#define PROBE_ARG_PARAMS	"$params"
+
 static inline int is_c_varname(const char *name)
 {
 	/* TODO */


