Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaISFWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaISFVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:21:46 -0400
Date: Thu, 18 Sep 2014 22:21:33 -0700
From: tip-bot for Avi Kivity <tipbot@zytor.com>
Message-ID: <tip-763122ade725592402190f5ff3b8d2edf42b87e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, jolsa@redhat.com,
        avi@cloudius-systems.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, avi@cloudius-systems.com,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1410581705-26968-1-git-send-email-avi@cloudius-systems.com>
References: <1410581705-26968-1-git-send-email-avi@cloudius-systems.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Disable kernel symbol demangling by default
Git-Commit-ID: 763122ade725592402190f5ff3b8d2edf42b87e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  763122ade725592402190f5ff3b8d2edf42b87e8
Gitweb:     http://git.kernel.org/tip/763122ade725592402190f5ff3b8d2edf42b87e8
Author:     Avi Kivity <avi@cloudius-systems.com>
AuthorDate: Sat, 13 Sep 2014 07:15:05 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:09 -0300

perf tools: Disable kernel symbol demangling by default

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
index 1513935..aaa869b 100644
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
index d561e02..0927bf4 100644
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
index 28fdee3..3265b10 100644
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
index 347729e..4d6858d 100644
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
index 3da59a8..8c0b3f2 100644
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
index 9848e27..7da2c46 100644
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
index 9fb5e9e..9c9b27f 100644
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
index ac098a3..1adb143 100644
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
index 3f95ea0..bec4b7b 100644
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
