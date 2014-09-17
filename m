Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaIQVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:58138 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaIQVZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@cloudius-systems.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/20] perf tools: Disable kernel symbol demangling by default
Date: Wed, 17 Sep 2014 18:24:15 -0300
Message-Id: <1410989063-14207-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@cloudius-systems.com>

Some Linux symbols (for example __vt_event_wait) are interpreted by the
demangler as C++ mangled names, which of course they aren't.

Disable kernel symbol demangling by default to avoid this, and allow
enabling it with a new option --demangle-kernel for those who wish it.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1410581705-26968-1-git-send-email-avi@cloudius-systems.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt  | 3 +++
 tools/perf/Documentation/perf-report.txt | 3 +++
 tools/perf/Documentation/perf-top.txt    | 3 +++
 tools/perf/builtin-probe.c               | 2 ++
 tools/perf/builtin-report.c              | 2 ++
 tools/perf/builtin-top.c                 | 2 ++
 tools/perf/util/symbol-elf.c             | 7 ++++++-
 tools/perf/util/symbol.c                 | 1 +
 tools/perf/util/symbol.h                 | 1 +
 9 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 1513935c399b..aaa869be3dc1 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -104,6 +104,9 @@ OPTIONS
 	Specify path to the executable or shared library file for user
 	space tracing. Can also be used with --funcs option.
 
+--demangle-kernel::
+	Demangle kernel symbols.
+
 In absence of -m/-x options, perf probe checks if the first argument after
 the options is an absolute path name. If its an absolute path, perf probe
 uses it as a target module/target user space binary to probe.
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index d561e0214f52..0927bf4e6c2a 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -276,6 +276,9 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
+--demangle-kernel::
+	Demangle kernel symbol names to human readable form (for C++ kernels).
+
 --mem-mode::
 	Use the data addresses of samples in addition to instruction addresses
 	to build the histograms.  To generate meaningful output, the perf.data
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 28fdee394880..3265b1070518 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -98,6 +98,9 @@ Default is to monitor all CPUS.
 --hide_user_symbols::
         Hide user symbols.
 
+--demangle-kernel::
+        Demangle kernel symbols.
+
 -D::
 --dump-symtab::
         Dump the symbol table used for profiling.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 347729e29a92..4d6858dbebea 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -376,6 +376,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 			"target executable name or path", opt_set_target),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
+	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
+		    "Enable kernel symbol demangling"),
 	OPT_END()
 	};
 	int ret;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3da59a87ec7c..8c0b3f22412a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -680,6 +680,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
+	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
+		    "Enable kernel symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9848e270b92c..7da2c46ea38f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1142,6 +1142,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
+	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
+		    "Enable kernel symbol demangling"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		    "objdump binary to use for disassembly and annotations"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9fb5e9e9f161..9c9b27fbc78d 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -680,6 +680,11 @@ static u64 ref_reloc(struct kmap *kmap)
 	return 0;
 }
 
+static bool want_demangle(bool is_kernel_sym)
+{
+	return is_kernel_sym ? symbol_conf.demangle_kernel : symbol_conf.demangle;
+}
+
 int dso__load_sym(struct dso *dso, struct map *map,
 		  struct symsrc *syms_ss, struct symsrc *runtime_ss,
 		  symbol_filter_t filter, int kmodule)
@@ -938,7 +943,7 @@ new_symbol:
 		 * DWARF DW_compile_unit has this, but we don't always have access
 		 * to it...
 		 */
-		if (symbol_conf.demangle) {
+		if (want_demangle(dso->kernel || kmodule)) {
 			int demangle_flags = DMGL_NO_OPTS;
 			if (verbose)
 				demangle_flags = DMGL_PARAMS | DMGL_ANSI;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ac098a3c2a31..1adb143867e3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -34,6 +34,7 @@ struct symbol_conf symbol_conf = {
 	.try_vmlinux_path	= true,
 	.annotate_src		= true,
 	.demangle		= true,
+	.demangle_kernel	= false,
 	.cumulate_callchain	= true,
 	.show_hist_headers	= true,
 	.symfs			= "",
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 3f95ea0357e3..bec4b7bd09de 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -120,6 +120,7 @@ struct symbol_conf {
 			annotate_src,
 			event_group,
 			demangle,
+			demangle_kernel,
 			filter_relative,
 			show_hist_headers;
 	const char	*vmlinux_name,
-- 
1.9.3

