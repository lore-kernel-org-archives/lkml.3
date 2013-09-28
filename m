Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3I1SDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:03:35 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57602 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3I1SDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:03:33 -0400
Date: Sat, 28 Sep 2013 20:03:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130928180327.GA5000@gmail.com>
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

   HEAD: 8a3da6c7d0031fcb6a0d17f9c7a68b0e01f52855 perf/x86: Fix PMU detection printout when no PMU is detected

A couple of tooling fixlets and a PMU detection printout fix.

 Thanks,

	Ingo

------------------>
Adrian Hunter (1):
      perf machine: Fix path unpopulated in machine__create_modules()

Andi Kleen (1):
      perf symbols: Demangle cloned functions

David Ahern (2):
      perf trace: Add mmap2 handler
      perf tools: Explicitly add libdl dependency

Ingo Molnar (1):
      perf/x86: Fix PMU detection printout when no PMU is detected

Jiri Olsa (1):
      perf kmem: Make it work again on non NUMA machines

Masami Hiramatsu (1):
      perf probe: Fix probing symbols with optimization suffix


 arch/x86/kernel/cpu/perf_event.c |  2 +-
 tools/perf/builtin-kmem.c        |  2 +-
 tools/perf/builtin-trace.c       |  1 +
 tools/perf/config/Makefile       |  2 +-
 tools/perf/util/machine.c        |  2 +-
 tools/perf/util/probe-finder.c   | 77 +++++++++++++++++++++-------------------
 tools/perf/util/probe-finder.h   |  3 ++
 tools/perf/util/symbol-elf.c     | 27 +++++++++++++-
 8 files changed, 75 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a9c606b..897783b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1506,7 +1506,7 @@ static int __init init_hw_perf_events(void)
 		err = amd_pmu_init();
 		break;
 	default:
-		return 0;
+		err = -ENOTSUPP;
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c2dff9c..9b5f077 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -101,7 +101,7 @@ static int setup_cpunode_map(void)
 
 	dir1 = opendir(PATH_SYS_NODE);
 	if (!dir1)
-		return -1;
+		return 0;
 
 	while ((dent1 = readdir(dir1)) != NULL) {
 		if (dent1->d_type != DT_DIR ||
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fd48534..71aa3e3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1055,6 +1055,7 @@ static int trace__replay(struct trace *trace)
 
 	trace->tool.sample	  = trace__process_sample;
 	trace->tool.mmap	  = perf_event__process_mmap;
+	trace->tool.mmap2	  = perf_event__process_mmap2;
 	trace->tool.comm	  = perf_event__process_comm;
 	trace->tool.exit	  = perf_event__process_exit;
 	trace->tool.fork	  = perf_event__process_fork;
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 346ee92..5f6f9b3 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -87,7 +87,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lelf -lpthread -lrt -lm
+EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f..6188d28 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -792,7 +792,7 @@ static int machine__create_modules(struct machine *machine)
 		modules = path;
 	}
 
-	if (symbol__restricted_filename(path, "/proc/modules"))
+	if (symbol__restricted_filename(modules, "/proc/modules"))
 		return -1;
 
 	file = fopen(modules, "r");
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
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a9c829b..d2a888e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -928,8 +928,33 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * to it...
 		 */
 		if (symbol_conf.demangle) {
-			demangled = bfd_demangle(NULL, elf_name,
+			/*
+			 * The demangler doesn't deal with cloned functions.
+			 * XXXX.clone.NUM or similar
+			 * Strip the dot part and readd it later.
+			 */
+			char *p = (char *)elf_name, *dot;
+			dot = strchr(elf_name, '.');
+			if (dot) {
+				p = strdup(elf_name);
+				if (!p)
+					goto new_symbol;
+				dot = strchr(p, '.');
+				*dot = 0;
+			}
+
+			demangled = bfd_demangle(NULL, p,
 						 DMGL_PARAMS | DMGL_ANSI);
+			if (dot)
+				*dot = '.';
+			if (demangled && dot) {
+				demangled = realloc(demangled, strlen(demangled) + strlen(dot) + 1);
+				if (!demangled)
+					goto new_symbol;
+				strcpy(demangled + (dot - p), dot);
+			}
+			if (p != elf_name)
+				free(p);
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
