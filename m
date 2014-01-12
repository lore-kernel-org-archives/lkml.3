Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaALSlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:41:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaALSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:40:58 -0500
Date: Sun, 12 Jan 2014 10:40:13 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-pfw02ezuab37kha18wlut7ir@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce zfree
Git-Commit-ID: 046625231a0397f1776eb353a4ec9ff142cd2f6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:40:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  046625231a0397f1776eb353a4ec9ff142cd2f6b
Gitweb:     http://git.kernel.org/tip/046625231a0397f1776eb353a4ec9ff142cd2f6b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 26 Dec 2013 17:41:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 Dec 2013 15:17:00 -0300

perf tools: Introduce zfree

For the frequent idiom of:

   free(ptr);
   ptr = NULL;

Make it expect a pointer to the pointer being freed, so that it becomes
clear at first sight that the variable being freed is being modified.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pfw02ezuab37kha18wlut7ir@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c           |  3 +--
 tools/perf/builtin-annotate.c      |  3 +--
 tools/perf/builtin-stat.c          |  6 ++----
 tools/perf/builtin-timechart.c     |  3 +--
 tools/perf/builtin-trace.c         | 12 ++++--------
 tools/perf/ui/browser.c            |  6 ++----
 tools/perf/ui/browsers/hists.c     |  6 ++----
 tools/perf/ui/gtk/util.c           |  3 +--
 tools/perf/util/alias.c            |  6 ++----
 tools/perf/util/annotate.c         | 12 ++++--------
 tools/perf/util/dso.c              |  9 +++------
 tools/perf/util/evlist.c           |  9 +++------
 tools/perf/util/evsel.c            |  6 ++----
 tools/perf/util/header.c           |  3 +--
 tools/perf/util/help.c             |  3 +--
 tools/perf/util/machine.c          | 12 +++++-------
 tools/perf/util/probe-event.c      |  6 ++----
 tools/perf/util/probe-finder.c     | 24 ++++++++----------------
 tools/perf/util/symbol.c           |  9 +++------
 tools/perf/util/thread_map.c       | 10 ++++------
 tools/perf/util/trace-event-info.c |  6 ++----
 tools/perf/util/util.h             |  2 ++
 22 files changed, 56 insertions(+), 103 deletions(-)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index aacef07..42faf36 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -154,8 +154,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		}
 		if (lookup_path(buf))
 			goto out;
-		free(buf);
-		buf = NULL;
+		zfree(&buf);
 	}
 
 	if (!strcmp(arch, "arm"))
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4136f99..ab65057 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -180,8 +180,7 @@ find_next:
 			 * symbol, free he->ms.sym->src to signal we already
 			 * processed this symbol.
 			 */
-			free(notes->src);
-			notes->src = NULL;
+			zfree(&notes->src);
 		}
 	}
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dab98b5..106a5e5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -185,8 +185,7 @@ static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 
 static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
 {
-	free(evsel->priv);
-	evsel->priv = NULL;
+	zfree(&evsel->priv);
 }
 
 static int perf_evsel__alloc_prev_raw_counts(struct perf_evsel *evsel)
@@ -208,8 +207,7 @@ static int perf_evsel__alloc_prev_raw_counts(struct perf_evsel *evsel)
 
 static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 {
-	free(evsel->prev_raw_counts);
-	evsel->prev_raw_counts = NULL;
+	zfree(&evsel->prev_raw_counts);
 }
 
 static void perf_evlist__free_stats(struct perf_evlist *evlist)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 20d4212..652af0b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -488,8 +488,7 @@ static const char *cat_backtrace(union perf_event *event,
 				 * It seems the callchain is corrupted.
 				 * Discard all.
 				 */
-				free(p);
-				p = NULL;
+				zfree(&p);
 				goto exit;
 			}
 			continue;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f64b5b0..c5b4bc5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -146,8 +146,7 @@ static int perf_evsel__init_tp_ptr_field(struct perf_evsel *evsel,
 
 static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 {
-	free(evsel->priv);
-	evsel->priv = NULL;
+	zfree(&evsel->priv);
 	perf_evsel__delete(evsel);
 }
 
@@ -165,8 +164,7 @@ static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
 	return -ENOMEM;
 
 out_delete:
-	free(evsel->priv);
-	evsel->priv = NULL;
+	zfree(&evsel->priv);
 	return -ENOENT;
 }
 
@@ -1278,10 +1276,8 @@ static size_t syscall_arg__scnprintf_close_fd(char *bf, size_t size,
 	size_t printed = syscall_arg__scnprintf_fd(bf, size, arg);
 	struct thread_trace *ttrace = arg->thread->priv;
 
-	if (ttrace && fd >= 0 && fd <= ttrace->paths.max) {
-		free(ttrace->paths.table[fd]);
-		ttrace->paths.table[fd] = NULL;
-	}
+	if (ttrace && fd >= 0 && fd <= ttrace->paths.max)
+		zfree(&ttrace->paths.table[fd]);
 
 	return printed;
 }
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 94223d40..d11541d 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -256,8 +256,7 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 	__ui_browser__show_title(browser, title);
 
 	browser->title = title;
-	free(browser->helpline);
-	browser->helpline = NULL;
+	zfree(&browser->helpline);
 
 	va_start(ap, helpline);
 	err = vasprintf(&browser->helpline, helpline, ap);
@@ -272,8 +271,7 @@ void ui_browser__hide(struct ui_browser *browser)
 {
 	pthread_mutex_lock(&ui__lock);
 	ui_helpline__pop();
-	free(browser->helpline);
-	browser->helpline = NULL;
+	zfree(&browser->helpline);
 	pthread_mutex_unlock(&ui__lock);
 }
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0d9dd99..022d173 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1267,10 +1267,8 @@ static inline void free_popup_options(char **options, int n)
 {
 	int i;
 
-	for (i = 0; i < n; ++i) {
-		free(options[i]);
-		options[i] = NULL;
-	}
+	for (i = 0; i < n; ++i)
+		zfree(&options[i]);
 }
 
 /* Check whether the browser is for 'top' or 'report' */
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 696c1fb..52e7fc4 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -23,8 +23,7 @@ int perf_gtk__deactivate_context(struct perf_gtk_context **ctx)
 	if (!perf_gtk__is_active_context(*ctx))
 		return -1;
 
-	free(*ctx);
-	*ctx = NULL;
+	zfree(ctx);
 	return 0;
 }
 
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index e6d1347..c0b43ee 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -55,8 +55,7 @@ int split_cmdline(char *cmdline, const char ***argv)
 				src++;
 				c = cmdline[src];
 				if (!c) {
-					free(*argv);
-					*argv = NULL;
+					zfree(argv);
 					return error("cmdline ends with \\");
 				}
 			}
@@ -68,8 +67,7 @@ int split_cmdline(char *cmdline, const char ***argv)
 	cmdline[dst] = 0;
 
 	if (quoted) {
-		free(*argv);
-		*argv = NULL;
+		zfree(argv);
 		return error("unclosed quote");
 	}
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 27ab7b5..a78721d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -185,8 +185,7 @@ static int lock__parse(struct ins_operands *ops)
 	return 0;
 
 out_free_ops:
-	free(ops->locked.ops);
-	ops->locked.ops = NULL;
+	zfree(&ops->locked.ops);
 	return 0;
 }
 
@@ -256,8 +255,7 @@ static int mov__parse(struct ins_operands *ops)
 	return 0;
 
 out_free_source:
-	free(ops->source.raw);
-	ops->source.raw = NULL;
+	zfree(&ops->source.raw);
 	return -1;
 }
 
@@ -560,8 +558,7 @@ static int disasm_line__parse(char *line, char **namep, char **rawp)
 	return 0;
 
 out_free_name:
-	free(*namep);
-	*namep = NULL;
+	zfree(namep);
 	return -1;
 }
 
@@ -1113,8 +1110,7 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 		src_line = (void *)src_line + sizeof_src_line;
 	}
 
-	free(notes->src->lines);
-	notes->src->lines = NULL;
+	zfree(&notes->src->lines);
 }
 
 /* Get the filename:line for the colored entries */
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4ddeecb..4045d08 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -497,21 +497,18 @@ void dso__delete(struct dso *dso)
 		symbols__delete(&dso->symbols[i]);
 
 	if (dso->short_name_allocated) {
-		free((char *)dso->short_name);
-		dso->short_name		  = NULL;
+		zfree((char **)&dso->short_name);
 		dso->short_name_allocated = false;
 	}
 
 	if (dso->long_name_allocated) {
-		free((char *)dso->long_name);
-		dso->long_name		 = NULL;
+		zfree((char **)&dso->long_name);
 		dso->long_name_allocated = false;
 	}
 
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
-	free(dso->symsrc_filename);
-	dso->symsrc_filename = NULL;
+	zfree(&dso->symsrc_filename);
 	free(dso);
 }
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index da31829..b08a7ec 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -101,10 +101,8 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
-	free(evlist->mmap);
-	free(evlist->pollfd);
-	evlist->mmap = NULL;
-	evlist->pollfd = NULL;
+	zfree(&evlist->mmap);
+	zfree(&evlist->pollfd);
 }
 
 void perf_evlist__delete(struct perf_evlist *evlist)
@@ -587,8 +585,7 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 	for (i = 0; i < evlist->nr_mmaps; i++)
 		__perf_evlist__munmap(evlist, i);
 
-	free(evlist->mmap);
-	evlist->mmap = NULL;
+	zfree(&evlist->mmap);
 }
 
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6874e04..93b6031 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -750,8 +750,7 @@ void perf_evsel__free_id(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
-	free(evsel->id);
-	evsel->id = NULL;
+	zfree(&evsel->id);
 }
 
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
@@ -1960,8 +1959,7 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 		evsel->attr.type   = PERF_TYPE_SOFTWARE;
 		evsel->attr.config = PERF_COUNT_SW_CPU_CLOCK;
 
-		free(evsel->name);
-		evsel->name = NULL;
+		zfree(&evsel->name);
 		return true;
 	}
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 10730b0..20f3a9c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1324,8 +1324,7 @@ read_event_desc(struct perf_header *ph, int fd)
 		}
 	}
 out:
-	if (buf)
-		free(buf);
+	free(buf);
 	return events;
 error:
 	if (events)
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 8b1f6e8..7b68978 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -263,9 +263,8 @@ static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 
 	for (i = 0; i < old->cnt; i++)
 		cmds->names[cmds->cnt++] = old->names[i];
-	free(old->names);
+	zfree(&old->names);
 	old->cnt = 0;
-	old->names = NULL;
 }
 
 const char *help_unknown_cmd(const char *cmd)
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c78cc84..a98538d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -102,8 +102,7 @@ void machine__exit(struct machine *machine)
 	map_groups__exit(&machine->kmaps);
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
-	free(machine->root_dir);
-	machine->root_dir = NULL;
+	zfree(&machine->root_dir);
 }
 
 void machine__delete(struct machine *machine)
@@ -562,11 +561,10 @@ void machine__destroy_kernel_maps(struct machine *machine)
 			 * on one of them.
 			 */
 			if (type == MAP__FUNCTION) {
-				free((char *)kmap->ref_reloc_sym->name);
-				kmap->ref_reloc_sym->name = NULL;
-				free(kmap->ref_reloc_sym);
-			}
-			kmap->ref_reloc_sym = NULL;
+				zfree((char **)&kmap->ref_reloc_sym->name);
+				zfree(&kmap->ref_reloc_sym);
+			} else
+				kmap->ref_reloc_sym = NULL;
 		}
 
 		map__delete(machine->vmlinux_maps[type]);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 095a98e..4d3cd1a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -506,15 +506,13 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 		case EFAULT:
 			raw_path = strchr(++raw_path, '/');
 			if (!raw_path) {
-				free(*new_path);
-				*new_path = NULL;
+				zfree(new_path);
 				return -ENOENT;
 			}
 			continue;
 
 		default:
-			free(*new_path);
-			*new_path = NULL;
+			zfree(new_path);
 			return -errno;
 		}
 	}
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 8c08735..6d8796e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -226,10 +226,8 @@ struct debuginfo *debuginfo__new(const char *path)
 	if (!dbg)
 		return NULL;
 
-	if (debuginfo__init_offline_dwarf(dbg, path) < 0) {
-		free(dbg);
-		dbg = NULL;
-	}
+	if (debuginfo__init_offline_dwarf(dbg, path) < 0)
+		zfree(&dbg);
 
 	return dbg;
 }
@@ -241,10 +239,8 @@ struct debuginfo *debuginfo__new_online_kernel(unsigned long addr)
 	if (!dbg)
 		return NULL;
 
-	if (debuginfo__init_online_kernel_dwarf(dbg, (Dwarf_Addr)addr) < 0) {
-		free(dbg);
-		dbg = NULL;
-	}
+	if (debuginfo__init_online_kernel_dwarf(dbg, (Dwarf_Addr)addr) < 0)
+		zfree(&dbg);
 
 	return dbg;
 }
@@ -1302,8 +1298,7 @@ int debuginfo__find_trace_events(struct debuginfo *dbg,
 
 	ret = debuginfo__find_probes(dbg, &tf.pf);
 	if (ret < 0) {
-		free(*tevs);
-		*tevs = NULL;
+		zfree(tevs);
 		return ret;
 	}
 
@@ -1417,8 +1412,7 @@ int debuginfo__find_available_vars_at(struct debuginfo *dbg,
 			free(af.vls[af.nvls].point.symbol);
 			strlist__delete(af.vls[af.nvls].vars);
 		}
-		free(af.vls);
-		*vls = NULL;
+		zfree(vls);
 		return ret;
 	}
 
@@ -1522,8 +1516,7 @@ post:
 	if (fname) {
 		ppt->file = strdup(fname);
 		if (ppt->file == NULL) {
-			free(ppt->function);
-			ppt->function = NULL;
+			zfree(&ppt->function);
 			ret = -ENOMEM;
 			goto end;
 		}
@@ -1577,8 +1570,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 		else
 			ret = 0;	/* Lines are not found */
 	else {
-		free(lf->lr->path);
-		lf->lr->path = NULL;
+		zfree(&lf->lr->path);
 	}
 	return ret;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 923d000..fd9e1a4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1621,13 +1621,10 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 
 static void vmlinux_path__exit(void)
 {
-	while (--vmlinux_path__nr_entries >= 0) {
-		free(vmlinux_path[vmlinux_path__nr_entries]);
-		vmlinux_path[vmlinux_path__nr_entries] = NULL;
-	}
+	while (--vmlinux_path__nr_entries >= 0)
+		zfree(&vmlinux_path[vmlinux_path__nr_entries]);
 
-	free(vmlinux_path);
-	vmlinux_path = NULL;
+	zfree(&vmlinux_path);
 }
 
 static int vmlinux_path__init(void)
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 9b5f856..cf44644 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -9,6 +9,7 @@
 #include "strlist.h"
 #include <string.h>
 #include "thread_map.h"
+#include "util.h"
 
 /* Skip "." and ".." directories */
 static int filter(const struct dirent *dir)
@@ -138,8 +139,7 @@ out_free_namelist:
 	free(namelist);
 
 out_free_closedir:
-	free(threads);
-	threads = NULL;
+	zfree(&threads);
 	goto out_closedir;
 }
 
@@ -210,8 +210,7 @@ out_free_namelist:
 	free(namelist);
 
 out_free_threads:
-	free(threads);
-	threads = NULL;
+	zfree(&threads);
 	goto out;
 }
 
@@ -262,8 +261,7 @@ out:
 	return threads;
 
 out_free_threads:
-	free(threads);
-	threads = NULL;
+	zfree(&threads);
 	goto out;
 }
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index c354b95..9f73bf4 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -562,10 +562,8 @@ out:
 		output_fd = fd;
 	}
 
-	if (err) {
-		free(tdata);
-		tdata = NULL;
-	}
+	if (err)
+		zfree(&tdata);
 
 	put_tracepoints_path(tps);
 	return tdata;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9a2c268..6995d66 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -186,6 +186,8 @@ static inline void *zalloc(size_t size)
 	return calloc(1, size);
 }
 
+#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
+
 static inline int has_extension(const char *filename, const char *ext)
 {
 	size_t len = strlen(filename);
