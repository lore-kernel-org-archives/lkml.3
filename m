Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3IYSb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:31:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3IYSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:26 -0400
Date: Wed, 25 Sep 2013 11:31:02 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-576b523721b7fbbf44a411ff0b3d958906c41653@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp>
References: <20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix probing symbols with optimization suffix
Git-Commit-ID: 576b523721b7fbbf44a411ff0b3d958906c41653
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:31:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  576b523721b7fbbf44a411ff0b3d958906c41653
Gitweb:     http://git.kernel.org/tip/576b523721b7fbbf44a411ff0b3d958906c41653
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 25 Sep 2013 22:16:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Sep 2013 12:27:31 -0300

perf probe: Fix probing symbols with optimization suffix

Fix perf probe to probe on some symbols which have some optimzation
suffixes, e.g. ".part", ".isra", and ".constprop".

To fix this issue, instead of using the DIE name, perf probe uses the
symbol name found by dwfl_module_addrsym().

This also involves a perf probe --vars operation update which now shows
the symbol name instead of the DIE name.

Without this patch, putting a probe on an inlined function which was
compiled with a suffixed symbol will fail like this:

  $ perf probe -v getname_flags
  probe-definition(0): getname_flags
  symbol:getname_flags file:(null) line:0 offset:0 return:0 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (6 entries long)
  Using /lib/modules/3.11.0+/build/vmlinux for symbols
  found inline addr: 0xffffffff8119bb70
  Probe point found: getname_flags+0
  found inline addr: 0xffffffff8119bcb6
  Probe point found: getname+6
  found inline addr: 0xffffffff811a06a6
  Probe point found: user_path_at_empty+6
  find 3 probe_trace_events.
  Opening /sys/kernel/debug//tracing/kprobe_events write=1
  Added new events:
  Writing event: p:probe/getname_flags getname_flags+0
  Failed to write event: No such file or directory
    Error: Failed to add events. (-1)

Because the debuginfo knows only the original (non suffix) symbol name,
it uses the original symbol for probe address but the kernel (kallsyms)
knows only suffixed symbol.  Then, the kernel rejects that original
symbol.

This patch uses dwfl_module_addrsym() to get the correct (suffixed)
symbol from symtab when a probe point is found.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 77 ++++++++++++++++++++++--------------------
 tools/perf/util/probe-finder.h |  3 ++
 2 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 20c7299..371476c 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -118,7 +118,6 @@ static const Dwfl_Callbacks offline_callbacks = {
 static int debuginfo__init_offline_dwarf(struct debuginfo *self,
 					 const char *path)
 {
-	Dwfl_Module *mod;
 	int fd;
 
 	fd = open(path, O_RDONLY);
@@ -129,11 +128,11 @@ static int debuginfo__init_offline_dwarf(struct debuginfo *self,
 	if (!self->dwfl)
 		goto error;
 
-	mod = dwfl_report_offline(self->dwfl, "", "", fd);
-	if (!mod)
+	self->mod = dwfl_report_offline(self->dwfl, "", "", fd);
+	if (!self->mod)
 		goto error;
 
-	self->dbg = dwfl_module_getdwarf(mod, &self->bias);
+	self->dbg = dwfl_module_getdwarf(self->mod, &self->bias);
 	if (!self->dbg)
 		goto error;
 
@@ -676,37 +675,42 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 }
 
 /* Convert subprogram DIE to trace point */
-static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
-				  bool retprobe, struct probe_trace_point *tp)
+static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
+				  Dwarf_Addr paddr, bool retprobe,
+				  struct probe_trace_point *tp)
 {
 	Dwarf_Addr eaddr, highaddr;
-	const char *name;
-
-	/* Copy the name of probe point */
-	name = dwarf_diename(sp_die);
-	if (name) {
-		if (dwarf_entrypc(sp_die, &eaddr) != 0) {
-			pr_warning("Failed to get entry address of %s\n",
-				   dwarf_diename(sp_die));
-			return -ENOENT;
-		}
-		if (dwarf_highpc(sp_die, &highaddr) != 0) {
-			pr_warning("Failed to get end address of %s\n",
-				   dwarf_diename(sp_die));
-			return -ENOENT;
-		}
-		if (paddr > highaddr) {
-			pr_warning("Offset specified is greater than size of %s\n",
-				   dwarf_diename(sp_die));
-			return -EINVAL;
-		}
-		tp->symbol = strdup(name);
-		if (tp->symbol == NULL)
-			return -ENOMEM;
-		tp->offset = (unsigned long)(paddr - eaddr);
-	} else
-		/* This function has no name. */
-		tp->offset = (unsigned long)paddr;
+	GElf_Sym sym;
+	const char *symbol;
+
+	/* Verify the address is correct */
+	if (dwarf_entrypc(sp_die, &eaddr) != 0) {
+		pr_warning("Failed to get entry address of %s\n",
+			   dwarf_diename(sp_die));
+		return -ENOENT;
+	}
+	if (dwarf_highpc(sp_die, &highaddr) != 0) {
+		pr_warning("Failed to get end address of %s\n",
+			   dwarf_diename(sp_die));
+		return -ENOENT;
+	}
+	if (paddr > highaddr) {
+		pr_warning("Offset specified is greater than size of %s\n",
+			   dwarf_diename(sp_die));
+		return -EINVAL;
+	}
+
+	/* Get an appropriate symbol from symtab */
+	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
+	if (!symbol) {
+		pr_warning("Failed to find symbol at 0x%lx\n",
+			   (unsigned long)paddr);
+		return -ENOENT;
+	}
+	tp->offset = (unsigned long)(paddr - sym.st_value);
+	tp->symbol = strdup(symbol);
+	if (!tp->symbol)
+		return -ENOMEM;
 
 	/* Return probe must be on the head of a subprogram */
 	if (retprobe) {
@@ -1149,7 +1153,7 @@ static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 	tev = &tf->tevs[tf->ntevs++];
 
 	/* Trace point should be converted from subprogram DIE */
-	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+	ret = convert_to_trace_point(&pf->sp_die, tf->mod, pf->addr,
 				     pf->pev->point.retprobe, &tev->point);
 	if (ret < 0)
 		return ret;
@@ -1181,7 +1185,7 @@ int debuginfo__find_trace_events(struct debuginfo *self,
 {
 	struct trace_event_finder tf = {
 			.pf = {.pev = pev, .callback = add_probe_trace_event},
-			.max_tevs = max_tevs};
+			.mod = self->mod, .max_tevs = max_tevs};
 	int ret;
 
 	/* Allocate result tevs array */
@@ -1250,7 +1254,7 @@ static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 	vl = &af->vls[af->nvls++];
 
 	/* Trace point should be converted from subprogram DIE */
-	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+	ret = convert_to_trace_point(&pf->sp_die, af->mod, pf->addr,
 				     pf->pev->point.retprobe, &vl->point);
 	if (ret < 0)
 		return ret;
@@ -1289,6 +1293,7 @@ int debuginfo__find_available_vars_at(struct debuginfo *self,
 {
 	struct available_var_finder af = {
 			.pf = {.pev = pev, .callback = add_available_vars},
+			.mod = self->mod,
 			.max_vls = max_vls, .externs = externs};
 	int ret;
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 17e94d0..3b7d630 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -23,6 +23,7 @@ static inline int is_c_varname(const char *name)
 /* debug information structure */
 struct debuginfo {
 	Dwarf		*dbg;
+	Dwfl_Module	*mod;
 	Dwfl		*dwfl;
 	Dwarf_Addr	bias;
 };
@@ -77,6 +78,7 @@ struct probe_finder {
 
 struct trace_event_finder {
 	struct probe_finder	pf;
+	Dwfl_Module		*mod;		/* For solving symbols */
 	struct probe_trace_event *tevs;		/* Found trace events */
 	int			ntevs;		/* Number of trace events */
 	int			max_tevs;	/* Max number of trace events */
@@ -84,6 +86,7 @@ struct trace_event_finder {
 
 struct available_var_finder {
 	struct probe_finder	pf;
+	Dwfl_Module		*mod;		/* For solving symbols */
 	struct variable_list	*vls;		/* Found variable lists */
 	int			nvls;		/* Number of variable lists */
 	int			max_vls;	/* Max no. of variable lists */
