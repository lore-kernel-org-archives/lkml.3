Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaA2JPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:15:52 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49241 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaA2JPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:15:12 -0500
Subject: [PATCH -tip v2 8/8] perf-probe: Allow to add events on the local
 functions
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:15:09 +0000
Message-ID: <20140129091509.22141.10958.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to add events on the local functions without debuginfo.
(With the debuginfo, we can add events even on inlined functions)
Currently, probing on local functions requires debuginfo to
locate actual address. It is also possible without debuginfo since
we have symbol maps.

Without this change;
  ----
  # ./perf probe -a t_show
  Added new event:
    probe:t_show         (on t_show)

  You can now use it in all perf tools, such as:

          perf record -e probe:t_show -aR sleep 1

  # ./perf probe -x perf -a identity__map_ip
  no symbols found in /kbuild/ksrc/linux-3/tools/perf/perf, maybe install a debug package?
  Failed to load map.
    Error: Failed to add events. (-22)
  ----
As the above results, perf probe just put one event
on the first found symbol for kprobe event. Moreover,
for uprobe event, perf probe failed to find local
functions.

With this change;
  ----
  # ./perf probe -a t_show
  Added new events:
    probe:t_show         (on t_show)
    probe:t_show_1       (on t_show)
    probe:t_show_2       (on t_show)
    probe:t_show_3       (on t_show)

  You can now use it in all perf tools, such as:

          perf record -e probe:t_show_3 -aR sleep 1

  # ./perf probe -x perf -a identity__map_ip
  Added new events:
    probe_perf:identity__map_ip (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
    probe_perf:identity__map_ip_1 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
    probe_perf:identity__map_ip_2 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
    probe_perf:identity__map_ip_3 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)

  You can now use it in all perf tools, such as:

          perf record -e probe_perf:identity__map_ip_3 -aR sleep 1
  ----
Now we succeed to put events on every given local functions
for both kprobes and uprobes. :)

Note that this also introduces some symbol rbtree
iteration macros; symbols__for_each, dso__for_each_symbol,
and map__for_each_symbol. These are for walking through
the symbol list in a map.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/dso.h         |   10 +
 tools/perf/util/map.h         |   10 +
 tools/perf/util/probe-event.c |  348 ++++++++++++++++++-----------------------
 tools/perf/util/symbol.h      |   11 +
 4 files changed, 184 insertions(+), 195 deletions(-)

diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index cd7d6f0..ab06f1c 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -102,6 +102,16 @@ struct dso {
 	char		 name[0];
 };
 
+/* dso__for_each_symbol - iterate over the symbols of given type
+ *
+ * @dso: the 'struct dso *' in which symbols itereated
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @n: the 'struct rb_node *' to use as a temporary storage
+ * @type: the 'enum map_type' type of symbols
+ */
+#define dso__for_each_symbol(dso, pos, n, type)	\
+	symbols__for_each_entry(&(dso)->symbols[(type)], pos, n)
+
 static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 {
 	dso->loaded |= (1 << type);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 18068c6..ef18a48 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -89,6 +89,16 @@ u64 map__objdump_2mem(struct map *map, u64 ip);
 
 struct symbol;
 
+/* map__for_each_symbol - iterate over the symbols in the given map
+ *
+ * @map: the 'struct map *' in which symbols itereated
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @n: the 'struct rb_node *' to use as a temporary storage
+ * Note: caller must ensure map->dso is not NULL (map is loaded).
+ */
+#define map__for_each_symbol(map, pos, n)	\
+	dso__for_each_symbol(map->dso, pos, n, map->type)
+
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *map, enum map_type type,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1d6ced1..5129e9e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -70,8 +70,6 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 }
 
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
-static int convert_name_to_addr(struct perf_probe_event *pev,
-				const char *exec);
 static void clear_probe_trace_event(struct probe_trace_event *tev);
 static struct machine *host_machine;
 
@@ -222,6 +220,14 @@ out:
 	return ret;
 }
 
+static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
+{
+	int i;
+
+	for (i = 0; i < ntevs; i++)
+		clear_probe_trace_event(tevs + i);
+}
+
 #ifdef HAVE_DWARF_SUPPORT
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
@@ -432,14 +438,6 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 	return 0;
 }
 
-static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
-{
-	int i;
-
-	for (i = 0; i < ntevs; i++)
-		clear_probe_trace_event(tevs + i);
-}
-
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 					  struct probe_trace_event **tevs,
@@ -1568,15 +1566,21 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
+	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s ", tp->retprobe ? 'r' : 'p',
+			 tev->group, tev->event);
+	if (len <= 0)
+		goto error;
+
+	/* Uprobes must have tp->address and tp->module */
+	if (tev->uprobes && (!tp->address || !tp->module))
+		goto error;
+
+	/* Use the tp->address for uprobes */
 	if (tev->uprobes)
-		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s:%s",
-				 tp->retprobe ? 'r' : 'p',
-				 tev->group, tev->event,
-				 tp->module, tp->symbol);
+		ret = e_snprintf(buf + len, MAX_CMDLEN - len, "%s:0x%lx",
+				 tp->module, tp->address);
 	else
-		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
-				 tp->retprobe ? 'r' : 'p',
-				 tev->group, tev->event,
+		len = e_snprintf(buf + len, MAX_CMDLEN - len, "%s%s%s+%lu",
 				 tp->module ?: "", tp->module ? ":" : "",
 				 tp->symbol, tp->offset);
 
@@ -2133,113 +2137,159 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static int convert_to_probe_trace_events(struct perf_probe_event *pev,
-					  struct probe_trace_event **tevs,
-					  int max_tevs, const char *target)
+static char *looking_function_name;
+static int num_matched_functions;
+
+static int probe_function_filter(struct map *map __maybe_unused,
+				      struct symbol *sym)
 {
+	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
+	    strcmp(looking_function_name, sym->name) == 0) {
+		num_matched_functions++;
+		return 0;
+	}
+	return 1;
+}
+
+#define strdup_or_goto(str, label)	\
+	({ char *__p = strdup(str); if (!__p) goto label; __p; })
+
+/*
+ * Find probe function addresses from map.
+ * Return an error or the number of found probe_trace_event
+ */
+static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
+					    struct probe_trace_event **tevs,
+					    int max_tevs, const char *target)
+{
+	struct map *map = NULL;
 	struct symbol *sym;
-	int ret, i;
+	struct rb_node *nd;
 	struct probe_trace_event *tev;
+	struct perf_probe_point *pp = &pev->point;
+	int ret, i;
 
-	if (pev->uprobes && !pev->group) {
-		/* Replace group name if not given */
-		ret = convert_exec_to_group(target, &pev->group);
-		if (ret != 0) {
-			pr_warning("Failed to make a group name.\n");
-			return ret;
-		}
-	}
-
-	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
-	if (ret != 0)
-		return ret;	/* Found in debuginfo or got an error */
+	/* Init maps of given executable or kernel */
+	if (pev->uprobes)
+		map = dso__new_map(target);
+	else
+		map = kernel_get_module_map(target);
 
-	if (pev->uprobes) {
-		ret = convert_name_to_addr(pev, target);
-		if (ret < 0)
-			return ret;
+	if (!map) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	/* Allocate trace event buffer */
-	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
-	if (tev == NULL)
-		return -ENOMEM;
+	/*
+	 * Load matched symbols: Since the different local symbols may have
+	 * same name but different addresses, this lists all the symbols.
+	 */
+	num_matched_functions = 0;
+	looking_function_name = pp->function;
+	ret = map__load(map, probe_function_filter);
+	if (ret || num_matched_functions == 0) {
+		pr_err("Failed to find symbol %s in %s\n", pp->function,
+			target ? : "kernel");
+		ret = -ENOENT;
+		goto out;
+	} else if (num_matched_functions > max_tevs) {
+		pr_err("Too many functions matched in %s\n",
+			target ? : "kernel");
+		ret = -E2BIG;
+		goto out;
+	}
 
-	/* Copy parameters */
-	tev->point.symbol = strdup(pev->point.function);
-	if (tev->point.symbol == NULL) {
+	/* Setup result trace-probe-events */
+	*tevs = zalloc(sizeof(*tev) * num_matched_functions);
+	if (!*tevs) {
 		ret = -ENOMEM;
-		goto error;
+		goto out;
 	}
 
-	if (target) {
-		tev->point.module = strdup(target);
-		if (tev->point.module == NULL) {
-			ret = -ENOMEM;
-			goto error;
+	ret = 0;
+	map__for_each_symbol(map, sym, nd) {
+		tev = (*tevs) + ret;
+		ret++;
+		if (ret > num_matched_functions) {
+			pr_warning("Too many symbols are listed. Skip it.\n");
+			break;
 		}
-	}
-
-	tev->point.offset = pev->point.offset;
-	tev->point.retprobe = pev->point.retprobe;
-	tev->nargs = pev->nargs;
-	tev->uprobes = pev->uprobes;
 
-	if (tev->nargs) {
-		tev->args = zalloc(sizeof(struct probe_trace_arg)
-				   * tev->nargs);
-		if (tev->args == NULL) {
-			ret = -ENOMEM;
-			goto error;
+		if (pp->offset > sym->end - sym->start) {
+			pr_warning("Offset %ld is bigger than the size of %s\n",
+				   pp->offset, sym->name);
+			ret = -ENOENT;
+			goto err_out;
 		}
+		tev->point.symbol = strdup_or_goto(sym->name, nomem_out);
+		tev->point.address = map->unmap_ip(map, sym->start)
+				     + pp->offset;
+		tev->point.offset = pp->offset;
+		tev->point.retprobe = pev->point.retprobe;
+		if (target)
+			tev->point.module = strdup_or_goto(target, nomem_out);
+		tev->uprobes = pev->uprobes;
+		tev->nargs = pev->nargs;
+		if (tev->nargs) {
+			tev->args = zalloc(sizeof(struct probe_trace_arg) *
+					   tev->nargs);
+			if (tev->args == NULL)
+				goto nomem_out;
+		}
+
 		for (i = 0; i < tev->nargs; i++) {
-			if (pev->args[i].name) {
-				tev->args[i].name = strdup(pev->args[i].name);
-				if (tev->args[i].name == NULL) {
-					ret = -ENOMEM;
-					goto error;
-				}
-			}
-			tev->args[i].value = strdup(pev->args[i].var);
-			if (tev->args[i].value == NULL) {
-				ret = -ENOMEM;
-				goto error;
-			}
-			if (pev->args[i].type) {
-				tev->args[i].type = strdup(pev->args[i].type);
-				if (tev->args[i].type == NULL) {
-					ret = -ENOMEM;
-					goto error;
-				}
-			}
+			if (pev->args[i].name)
+				tev->args[i].name =
+					strdup_or_goto(pev->args[i].name,
+							nomem_out);
+
+			tev->args[i].value = strdup_or_goto(pev->args[i].var,
+							    nomem_out);
+			if (pev->args[i].type)
+				tev->args[i].type =
+					strdup_or_goto(pev->args[i].type,
+							nomem_out);
 		}
 	}
 
-	if (pev->uprobes)
-		return 1;
+	ret = num_matched_functions;
+out:
+	if (map && pev->uprobes) {
+		/* Only when using uprobe(exec) map needs to be released */
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+	return ret;
 
-	/* Currently just checking function name from symbol map */
-	sym = __find_kernel_function_by_name(tev->point.symbol, NULL);
-	if (!sym) {
-		pr_warning("Kernel symbol \'%s\' not found.\n",
-			   tev->point.symbol);
-		ret = -ENOENT;
-		goto error;
-	} else if (tev->point.offset > sym->end - sym->start) {
-		pr_warning("Offset specified is greater than size of %s\n",
-			   tev->point.symbol);
-		ret = -ENOENT;
-		goto error;
+nomem_out:
+	ret = -ENOMEM;
+err_out:
+	clear_probe_trace_events(*tevs, num_matched_functions);
+	zfree(tevs);
+	goto out;
+}
+
+static int convert_to_probe_trace_events(struct perf_probe_event *pev,
+					  struct probe_trace_event **tevs,
+					  int max_tevs, const char *target)
+{
+	int ret;
 
+	if (pev->uprobes && !pev->group) {
+		/* Replace group name if not given */
+		ret = convert_exec_to_group(target, &pev->group);
+		if (ret != 0) {
+			pr_warning("Failed to make a group name.\n");
+			return ret;
+		}
 	}
 
-	return 1;
-error:
-	clear_probe_trace_event(tev);
-	free(tev);
-	*tevs = NULL;
-	return ret;
+	/* Convert perf_probe_event with debuginfo */
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
+	if (ret != 0)
+		return ret;	/* Found in debuginfo or got an error */
+
+	return find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
 }
 
 struct __event_package {
@@ -2444,7 +2494,7 @@ static struct strfilter *available_func_filter;
 static int filter_available_functions(struct map *map __maybe_unused,
 				      struct symbol *sym)
 {
-	if (sym->binding == STB_GLOBAL &&
+	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
 	    strfilter__compare(available_func_filter, sym->name))
 		return 0;
 	return 1;
@@ -2512,95 +2562,3 @@ int show_available_funcs(const char *target, struct strfilter *_filter,
 	return available_user_funcs(target);
 }
 
-/*
- * uprobe_events only accepts address:
- * Convert function and any offset to address
- */
-static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
-{
-	struct perf_probe_point *pp = &pev->point;
-	struct symbol *sym;
-	struct map *map = NULL;
-	char *function = NULL;
-	int ret = -EINVAL;
-	unsigned long long vaddr = 0;
-
-	if (!pp->function) {
-		pr_warning("No function specified for uprobes");
-		goto out;
-	}
-
-	function = strdup(pp->function);
-	if (!function) {
-		pr_warning("Failed to allocate memory by strdup.\n");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	map = dso__new_map(exec);
-	if (!map) {
-		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
-		goto out;
-	}
-	available_func_filter = strfilter__new(function, NULL);
-	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
-		goto out;
-	}
-
-	sym = map__find_symbol_by_name(map, function, NULL);
-	if (!sym) {
-		pr_warning("Cannot find %s in DSO %s\n", function, exec);
-		goto out;
-	}
-
-	if (map->start > sym->start)
-		vaddr = map->start;
-	vaddr += sym->start + pp->offset + map->pgoff;
-	pp->offset = 0;
-
-	if (!pev->event) {
-		pev->event = function;
-		function = NULL;
-	}
-	if (!pev->group) {
-		char *ptr1, *ptr2, *exec_copy;
-
-		pev->group = zalloc(sizeof(char *) * 64);
-		exec_copy = strdup(exec);
-		if (!exec_copy) {
-			ret = -ENOMEM;
-			pr_warning("Failed to copy exec string.\n");
-			goto out;
-		}
-
-		ptr1 = strdup(basename(exec_copy));
-		if (ptr1) {
-			ptr2 = strpbrk(ptr1, "-._");
-			if (ptr2)
-				*ptr2 = '\0';
-			e_snprintf(pev->group, 64, "%s_%s", PERFPROBE_GROUP,
-					ptr1);
-			free(ptr1);
-		}
-		free(exec_copy);
-	}
-	free(pp->function);
-	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
-	if (!pp->function) {
-		ret = -ENOMEM;
-		pr_warning("Failed to allocate memory by zalloc.\n");
-		goto out;
-	}
-	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
-	ret = 0;
-
-out:
-	if (map) {
-		dso__delete(map->dso);
-		map__delete(map);
-	}
-	if (function)
-		free(function);
-	return ret;
-}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fffe288..9c4fc23 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -79,6 +79,17 @@ struct symbol {
 void symbol__delete(struct symbol *sym);
 void symbols__delete(struct rb_root *symbols);
 
+/* symbols__for_each_entry - iterate over symbols (rb_root)
+ *
+ * @symbols: the rb_root of symbols
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @nd: the 'struct rb_node *' to use as a temporary storage
+ */
+#define symbols__for_each_entry(symbols, pos, nd)			\
+	for (nd = rb_first(symbols);					\
+	     nd && (pos = rb_entry(nd, struct symbol, rb_node));	\
+	     nd = rb_next(nd))
+
 static inline size_t symbol__size(const struct symbol *sym)
 {
 	return sym->end - sym->start + 1;


