Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3BZX0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:26:38 -0500
Received: from fe1.lbl.gov ([128.3.41.133]:23034 "EHLO fe1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab3BZX0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:26:36 -0500
X-Ironport-SBRS: 4.7
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8CAEtELVHRVdVHk2dsb2JhbABFsCcBkVJ5CBYOAQEBAQkJFBQEI4JADUUGBAMmXRIBBQE1iBMMoUKQOY10jVmBO4NHA5J/g0GBHo1oFimEHg6BaQ
X-IronPort-AV: E=Sophos;i="4.84,743,1355126400"; 
   d="scan'208";a="10450996"
MIME-Version: 1.0
Date: Wed, 27 Feb 2013 00:26:33 +0100
Message-ID: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
Subject: [PATCH] perf: add callgrind conversion tool
From: Roberto Vitillo <ravitillo@lbl.gov>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proposed patch adds the convert tool to perf which allows to convert a
perf.data file to a callgrind data file which can subsequently be displayed
with kcachegrind. Callgraphs are not supported.

In order to speed up the converter I am not piping to addr2line, this
means that
the code depends on libbfd. Considering that perf doesn't strictly depend on
libbfd my question is if it would be feasible to add that requirement.

Note that the code may trigger the following bug in libbfd:
http://sourceware.org/bugzilla/show_bug.cgi?id=15106

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
---
 tools/perf/Documentation/perf-convert.txt |  55 ++++++++
 tools/perf/Makefile                       |  59 ++++----
 tools/perf/builtin-convert.c              | 217 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                      |   1 +
 tools/perf/perf.c                         |   1 +
 tools/perf/util/a2l.c                     | 136 +++++++++++++++++++
 tools/perf/util/a2l.h                     |   9 ++
 tools/perf/util/cgcnv.c                   | 188 ++++++++++++++++++++++++++
 tools/perf/util/cgcnv.h                   |  17 +++
 9 files changed, 654 insertions(+), 29 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-convert.txt
 create mode 100644 tools/perf/builtin-convert.c
 create mode 100644 tools/perf/util/a2l.c
 create mode 100644 tools/perf/util/a2l.h
 create mode 100644 tools/perf/util/cgcnv.c
 create mode 100644 tools/perf/util/cgcnv.h

diff --git a/tools/perf/Documentation/perf-convert.txt
b/tools/perf/Documentation/perf-convert.txt
new file mode 100644
index 0000000..cff59c6
--- /dev/null
+++ b/tools/perf/Documentation/perf-convert.txt
@@ -0,0 +1,55 @@
+perf-convert(1)
+================
+
+NAME
+----
+perf-convert - Convert perf.data (created by perf record) to a
callgrind data file.
+
+SYNOPSIS
+--------
+[verse]
+'perf convert' [-i <file> | --input=file] [-o <file> | --output=file]
+
+DESCRIPTION
+-----------
+This command converts the input file to a callgrind data file which can be
+subsequently displayed with kcachegrind.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Input file name. (default: perf.data unless stdin is a fifo)
+
+-o::
+--output=::
+        Output file name. (default: callgrind.out)
+
+-d::
+--dsos=<dso[,dso...]>::
+        Only consider symbols in these dsos.
+
+-f::
+--force::
+        Don't complain, do it.
+
+-k::
+--vmlinux=<file>::
+        vmlinux pathname.
+
+-m::
+--modules::
+        Load module symbols. WARNING: use only with -k and LIVE kernel.
+
+-C::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..55c35d5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -399,6 +399,8 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
+LIB_H += util/cgcnv.h
+LIB_H += util/a2l.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -472,6 +474,8 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/cgcnv.o
+LIB_OBJS += $(OUTPUT)util/a2l.o

 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
@@ -528,6 +532,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-convert.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o

 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
@@ -793,39 +798,35 @@ endif

 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else
-        ifdef HAVE_CPLUS_DEMANGLE
+endif
+
+FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd -ldl
+has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
+ifeq ($(has_bfd),y)
+	EXTLIBS += -lbfd -ldl
+
+	ifdef HAVE_CPLUS_DEMANGLE
 		EXTLIBS += -liberty
-		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-        else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-		ifeq ($(has_bfd),y)
-			EXTLIBS += -lbfd
+	endif
+else
+	FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+	has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
+
+	ifeq ($(has_bfd_iberty),y)
+		EXTLIBS += -lbfd -ldl -liberty
+	else
+		FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+		has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
+		ifeq ($(has_bfd_iberty_z),y)
+			EXTLIBS += -lbfd -ldl -liberty -lz
 		else
-			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-			ifeq ($(has_bfd_iberty),y)
-				EXTLIBS += -lbfd -liberty
-			else
-				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-				ifeq ($(has_bfd_iberty_z),y)
-					EXTLIBS += -lbfd -liberty -lz
-				else
-					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-					has_cplus_demangle := $(call
try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-					ifeq ($(has_cplus_demangle),y)
-						EXTLIBS += -liberty
-						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-					else
-						msg := $(warning No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
-					endif
-				endif
-			endif
+			msg := $(error No bfd.h/libbfd found, install binutils-dev[el]/zlib-static)
 		endif
 	endif
+
+	ifndef NO_DEMANGLE
+		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+	endif
 endif

 ifeq ($(NO_PERF_REGS),0)
diff --git a/tools/perf/builtin-convert.c b/tools/perf/builtin-convert.c
new file mode 100644
index 0000000..9311b3a
--- /dev/null
+++ b/tools/perf/builtin-convert.c
@@ -0,0 +1,217 @@
+/*
+ * builtin-convert.c
+ *
+ * Builtin convert command: Convert a perf.data input file
+ * to a callgrind profile data file.
+ */
+#include "builtin.h"
+
+#include "util/util.h"
+#include "util/color.h"
+#include <linux/list.h>
+#include "util/cache.h"
+#include <linux/rbtree.h>
+#include "util/symbol.h"
+
+#include "perf.h"
+#include "util/debug.h"
+
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/annotate.h"
+#include "util/event.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+#include "util/thread.h"
+#include "util/hist.h"
+#include "util/session.h"
+#include "util/tool.h"
+#include "util/cgcnv.h"
+
+#include <linux/bitmap.h>
+
+struct perf_convert {
+	struct perf_tool tool;
+	char const *input_name;
+	FILE *output_file;
+	bool	   force;
+	const char *cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+};
+
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	struct perf_convert *cnv = container_of(tool, struct perf_convert, tool);
+	struct addr_location al;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  symbol__annotate_init) < 0) {
+		pr_warning("problem processing %d event, skipping it.\n",
+			   event->header.type);
+		return -1;
+	}
+
+	if (cnv->cpu_list && !test_bit(sample->cpu, cnv->cpu_bitmap))
+		return 0;
+
+	if (!al.filtered && cg_cnv_sample(evsel, sample, &al)) {
+		pr_warning("problem incrementing symbol count, skipping event\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void hists__find_annotations(struct hists *self, int evidx,
+				    struct perf_convert *cnv)
+{
+	struct rb_node *nd = rb_first(&self->entries);
+	int key = K_RIGHT;
+
+	while (nd) {
+		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+		struct annotation *notes;
+
+		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned) {
+			cg_cnv_unresolved(cnv->output_file, evidx, he);
+			goto find_next;
+		}
+
+		notes = symbol__annotation(he->ms.sym);
+
+		if (notes->src == NULL) {
+find_next:
+			if (key == K_LEFT)
+				nd = rb_prev(nd);
+			else
+				nd = rb_next(nd);
+			continue;
+		}
+
+		cg_cnv_symbol(cnv->output_file, he->ms.sym, he->ms.map);
+
+		free(notes->src);
+		notes->src = NULL;
+	}
+}
+
+static int __cmd_convert(struct perf_convert *cnv)
+{
+	int ret;
+	struct perf_session *session;
+	struct perf_evsel *pos;
+	u64 total_nr_samples = 0;
+
+	session = perf_session__new(cnv->input_name, O_RDONLY,
+				    cnv->force, false, &cnv->tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	if (cnv->cpu_list) {
+		ret = perf_session__cpu_bitmap(session, cnv->cpu_list,
+					       cnv->cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
+	ret = perf_session__process_events(session, &cnv->tool);
+	if (ret)
+		goto out_delete;
+
+	ret = cg_cnv_header(cnv->output_file, session);
+	if (ret)
+		goto out_delete;
+
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		if (nr_samples > 0) {
+			total_nr_samples += nr_samples;
+			hists__collapse_resort(hists);
+			hists__output_resort(hists);
+			hists__find_annotations(hists, pos->idx, cnv);
+		}
+	}
+
+	if (total_nr_samples == 0) {
+		ui__error("The %s file has no samples!\n", session->filename);
+		goto out_delete;
+	}
+
+out_delete:
+	/*
+	 * Speed up the exit process, for large files this can
+	 * take quite a while.
+	 *
+	 * XXX Enable this when using valgrind or if we ever
+	 * librarize this command.
+	 *
+	 * Also experiment with obstacks to see how much speed
+	 * up we'll get here.
+	 *
+	 * perf_session__delete(session);
+	 */
+	return ret;
+}
+
+static const char * const convert_usage[] = {
+	"perf convert [<options>]",
+	NULL
+};
+
+int cmd_convert(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	const char *output_filename = "callgrind.out";
+	struct perf_convert convert = {
+		.tool = {
+			.sample	= process_sample_event,
+			.mmap	= perf_event__process_mmap,
+			.comm	= perf_event__process_comm,
+			.exit	= perf_event__process_exit,
+			.fork	= perf_event__process_fork,
+			.ordered_samples = true,
+			.ordering_requires_timestamps = true,
+		},
+	};
+	const struct option options[] = {
+	OPT_STRING('i', "input", &convert.input_name, "file",
+		    "input file name"),
+	OPT_STRING('o', "output", &output_filename, "output", "output filename, "
+			"default is callgrind.out"),
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_BOOLEAN('f', "force", &convert.force, "don't complain, do it"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
+	OPT_STRING('C', "cpu", &convert.cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		   "Look for files with symbols relative to this directory"),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, options, convert_usage, 0);
+
+	symbol_conf.priv_size = sizeof(struct annotation);
+	symbol_conf.try_vmlinux_path = true;
+
+	convert.output_file = fopen(output_filename, "w");
+	if (!convert.output_file) {
+		fprintf(stderr, "Cannot open %s for output\n", output_filename);
+		return -1;
+	}
+
+	if (symbol__init() < 0)
+		return -1;
+
+	if (setup_sorting() < 0)
+		usage_with_options(convert_usage, options);
+
+	return __cmd_convert(&convert);
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 08143bd..e4f7d5a 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,6 +36,7 @@ extern int cmd_kvm(int argc, const char **argv,
const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_convert(int argc, const char **argv, const char *prefix);

 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 095b882..d70f100 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -60,6 +60,7 @@ static struct cmd_struct commands[] = {
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
+	{ "convert",	cmd_convert,	0 },
 };

 struct pager_config {
diff --git a/tools/perf/util/a2l.c b/tools/perf/util/a2l.c
new file mode 100644
index 0000000..82f1023
--- /dev/null
+++ b/tools/perf/util/a2l.c
@@ -0,0 +1,136 @@
+/* Based on addr2line. */
+
+#include "a2l.h"
+
+#define PACKAGE 'perf'
+
+#include <bfd.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+#include <linux/kernel.h>
+
+static const char *filename;
+static const char *functionname;
+static unsigned int line;
+static asymbol **syms;
+static bfd_vma pc;
+static bfd_boolean found;
+static bfd *abfd;
+
+static void bfd_nonfatal(const char *string)
+{
+	const char *errmsg;
+
+	errmsg = bfd_errmsg(bfd_get_error());
+	fflush(stdout);
+	if (string)
+		pr_warning("%s: %s\n", string, errmsg);
+	else
+		pr_warning("%s\n", errmsg);
+}
+
+static int bfd_fatal(const char *string)
+{
+	bfd_nonfatal(string);
+	return -1;
+}
+
+static int slurp_symtab(void)
+{
+	long storage;
+	long symcount;
+	bfd_boolean dynamic = FALSE;
+
+	if ((bfd_get_file_flags(abfd) & HAS_SYMS) == 0)
+		return bfd_fatal(bfd_get_filename(abfd));
+
+	storage = bfd_get_symtab_upper_bound(abfd);
+	if (storage == 0) {
+		storage = bfd_get_dynamic_symtab_upper_bound(abfd);
+		dynamic = TRUE;
+	}
+	if (storage < 0)
+		return bfd_fatal(bfd_get_filename(abfd));
+
+	syms = (asymbol **) malloc(storage);
+	if (dynamic)
+		symcount = bfd_canonicalize_dynamic_symtab(abfd, syms);
+	else
+		symcount = bfd_canonicalize_symtab(abfd, syms);
+
+	if (symcount < 0)
+		return bfd_fatal(bfd_get_filename(abfd));
+
+	return 0;
+}
+
+static void find_address_in_section(bfd *self, asection *section,
+				    void *data ATTRIBUTE_UNUSED)
+{
+	bfd_vma vma;
+	bfd_size_type size;
+
+	if (found)
+		return;
+
+	if ((bfd_get_section_flags(abfd, section) & SEC_ALLOC) == 0)
+		return;
+
+	vma = bfd_get_section_vma(abfd, section);
+	if (pc < vma)
+		return;
+
+	size = bfd_get_section_size(section);
+	if (pc >= vma + size)
+		return;
+
+	found = bfd_find_nearest_line(self, section, syms, pc - vma,
+			&filename, &functionname, &line);
+}
+
+int addr2line_init(const char *file_name)
+{
+	abfd = bfd_openr(file_name, NULL);
+	if (abfd == NULL)
+		return -1;
+
+	if (!bfd_check_format(abfd, bfd_object))
+		return bfd_fatal(bfd_get_filename(abfd));
+
+	return slurp_symtab();
+
+}
+
+void addr2line_cleanup(void)
+{
+	if (syms != NULL) {
+		free(syms);
+		syms = NULL;
+	}
+
+	bfd_close(abfd);
+	line = found = 0;
+}
+
+int addr2line_inline(const char **file, unsigned *line_nr)
+{
+
+	found = bfd_find_inliner_info(abfd, &filename, &functionname, &line);
+	*file = filename;
+	*line_nr = line;
+
+	return found;
+}
+
+int addr2line(unsigned long addr, const char **file, unsigned *line_nr)
+{
+	found = 0;
+	pc = addr;
+	bfd_map_over_sections(abfd, find_address_in_section, NULL);
+
+	*file = filename;
+	*line_nr = line;
+
+	return found;
+}
diff --git a/tools/perf/util/a2l.h b/tools/perf/util/a2l.h
new file mode 100644
index 0000000..b248429
--- /dev/null
+++ b/tools/perf/util/a2l.h
@@ -0,0 +1,9 @@
+#ifndef __A2L_H_
+#define __A2L_H_
+
+int addr2line_init(const char *file_name);
+int addr2line(unsigned long addr, const char **file, unsigned *line_nr);
+int addr2line_inline(const char **file, unsigned *line_nr);
+void addr2line_cleanup(void);
+
+#endif
diff --git a/tools/perf/util/cgcnv.c b/tools/perf/util/cgcnv.c
new file mode 100644
index 0000000..02fcfa5
--- /dev/null
+++ b/tools/perf/util/cgcnv.c
@@ -0,0 +1,188 @@
+#include "cgcnv.h"
+#include "a2l.h"
+#include "parse-events.h"
+#include "symbol.h"
+#include "map.h"
+#include "util.h"
+#include "annotate.h"
+
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
+static const char *last_source_name;
+static unsigned last_line;
+static u64 last_off;
+
+int cg_cnv_header(FILE *output, struct perf_session *session)
+{
+	struct perf_evsel *pos;
+
+	fprintf(output, "positions: instr line\nevents:");
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		const char *evname = NULL;
+		struct hists *hists = &pos->hists;
+		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		if (nr_samples > 0) {
+			evname = perf_evsel__name(pos);
+			fprintf(output, " %s", evname);
+		}
+	}
+	fprintf(output, "\n");
+
+	return 0;
+}
+
+int cg_cnv_sample(struct perf_evsel *evsel, struct perf_sample *sample,
+		  struct addr_location *al)
+{
+	struct hist_entry *he;
+	int ret = 0;
+
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	if (he == NULL)
+		return -ENOMEM;
+
+	ret = 0;
+	if (he->ms.sym != NULL) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			return -ENOMEM;
+
+		ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	}
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	return ret;
+}
+
+static void cg_sym_header_printf(FILE *output, struct symbol *sym,
+				 struct map *map, struct annotation *notes,
+				 u64 offset)
+{
+	int idx, ret, ret_callee, ret_caller = 0;
+	u64 address = map__rip_2objdump(map, sym->start) + offset;
+	unsigned caller_line;
+	const char *caller_name;
+
+	ret_callee = addr2line(address, &last_source_name, &last_line);
+	while ((ret = addr2line_inline(&caller_name, &caller_line)))
+		ret_caller = ret;
+
+	/* Needed to display correctly the inlining relationship in kcachegrind */
+	if (ret_caller && caller_line)
+		fprintf(output, "fl=%s\n0 0\n", caller_name);
+
+	if (ret_callee && last_line)
+		fprintf(output, "fl=%s\n", last_source_name);
+	else
+		fprintf(output, "fl=\n");
+
+	fprintf(output, "%#" PRIx64 " %u", address, last_line);
+	for (idx = 0; idx < notes->src->nr_histograms; idx++)
+		fprintf(output, " %" PRIu64,
+			annotation__histogram(notes, idx)->addr[offset]);
+
+	fprintf(output, "\n");
+	last_off = offset;
+}
+
+static void cg_sym_events_printf(FILE *output, struct symbol *sym,
+				 struct map *map, struct annotation *notes,
+				 u64 offset)
+{
+	int ret, idx;
+	unsigned line;
+	const char *filename;
+
+	ret = addr2line(map__rip_2objdump(map, sym->start) + offset,
+			&filename, &line);
+	if (filename && last_source_name && strcmp(filename, last_source_name)) {
+		fprintf(output, "fl=%s\n", filename);
+		last_source_name = filename;
+	}
+
+	if (ret)
+		fprintf(output, "+%" PRIu64 " %+d", offset - last_off,
+			(int)(line - last_line));
+	else
+		fprintf(output, "+%" PRIu64 " %u", offset - last_off, line);
+
+	for (idx = 0; idx < notes->src->nr_histograms; idx++) {
+		u64 cnt = annotation__histogram(notes, idx)->addr[offset];
+		fprintf(output, " %" PRIu64, cnt);
+	}
+
+	fprintf(output, "\n");
+	last_off = offset;
+	last_line = line;
+}
+
+static inline bool cg_check_events(struct annotation *notes, u64 offset)
+{
+	int idx;
+
+	for (idx = 0; idx < notes->src->nr_histograms; idx++)
+		if (annotation__histogram(notes, idx)->addr[offset])
+			return true;
+
+	return false;
+}
+
+static void cg_sym_total_printf(FILE *output, struct annotation *notes)
+{
+	int idx;
+
+	fprintf(output, "0 0");
+	for (idx = 0; idx < notes->src->nr_histograms; idx++) {
+		u64 cnt = annotation__histogram(notes, idx)->sum;
+		fprintf(output, " %" PRIu64, cnt);
+	}
+	fprintf(output, "\n");
+}
+
+void cg_cnv_unresolved(FILE *output, int evidx, struct hist_entry *he)
+{
+	int idx;
+
+	fprintf(output, "ob=%s\n", he->ms.map->dso->long_name);
+	fprintf(output, "fn=%#" PRIx64 "\n", he->ip);
+
+	fprintf(output, "0 0");
+	for (idx = 0; idx < evidx; idx++)
+		fprintf(output, " 0");
+	fprintf(output, " %" PRIu32, he->stat.nr_events);
+	fprintf(output, "\n");
+}
+
+int cg_cnv_symbol(FILE *output, struct symbol *sym, struct map *map)
+{
+	const char *filename = map->dso->long_name;
+	struct annotation *notes = symbol__annotation(sym);
+	u64 sym_len = sym->end - sym->start, i;
+
+	fprintf(output, "ob=%s\n", filename);
+	fprintf(output, "fn=%s\n", sym->name);
+
+	if (addr2line_init(map->dso->long_name)) {
+		cg_sym_total_printf(output, notes);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < sym_len; i++) {
+		if (cg_check_events(notes, i)) {
+			cg_sym_header_printf(output, sym, map, notes, i);
+			break;
+		}
+	}
+
+	for (++i; i < sym_len; i++) {
+		if (cg_check_events(notes, i))
+			cg_sym_events_printf(output, sym, map, notes, i);
+	}
+
+	addr2line_cleanup();
+
+	return 0;
+}
diff --git a/tools/perf/util/cgcnv.h b/tools/perf/util/cgcnv.h
new file mode 100644
index 0000000..88fede2
--- /dev/null
+++ b/tools/perf/util/cgcnv.h
@@ -0,0 +1,17 @@
+#ifndef CGCNV_H
+#define CGCNV_H
+
+#include "evlist.h"
+#include "evsel.h"
+#include "session.h"
+
+#include <stdio.h>
+
+int cg_cnv_header(FILE *output, struct perf_session *session);
+int cg_cnv_sample(struct perf_evsel *evsel, struct perf_sample *sample,
+		  struct addr_location *al);
+void cg_cnv_unresolved(FILE *output, int evidx, struct hist_entry *he);
+int cg_cnv_symbol(FILE *output, struct symbol *sym, struct map *map);
+
+#endif
+
-- 
1.8.1.2
