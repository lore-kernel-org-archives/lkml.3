Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3CYJSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:18:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57304 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab3CYJSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:18:37 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-eb-51501667993b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, wcohen@redhat.com
Subject: [PATCH v2] perf report: Add --no-demangle option
Date: Mon, 25 Mar 2013 18:18:18 +0900
Message-Id: <1364203098-17741-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364202536-17576-1-git-send-email-namhyung@kernel.org>
References: <1364202536-17576-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's sometimes useful to see undemangled raw symbol name for example
other tools using the perf output to do manipulation of binaries.

Suggested-by: William Cohen <wcohen@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Forgot to update the doc. Resending..

 tools/perf/Documentation/perf-report.txt | 4 ++++
 tools/perf/builtin-report.c              | 2 ++
 tools/perf/util/symbol-elf.c             | 9 ++++++---
 tools/perf/util/symbol.c                 | 1 +
 tools/perf/util/symbol.h                 | 3 ++-
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 02284a0067f0..71f15510ca0b 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -206,6 +206,10 @@ OPTIONS
 --group::
 	Show event group information together.
 
+--demangle::
+	Demangle symbol names to human readable form. It's enabled by default,
+	disable with --no-demangle.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 296bd219977a..b5ea26cc7eb1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -692,6 +692,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
+		    "Disable symbol demangling"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 54efcb5659ac..4b12bf850325 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -806,9 +806,12 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * DWARF DW_compile_unit has this, but we don't always have access
 		 * to it...
 		 */
-		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
-		if (demangled != NULL)
-			elf_name = demangled;
+		if (symbol_conf.demangle) {
+			demangled = bfd_demangle(NULL, elf_name,
+						 DMGL_PARAMS | DMGL_ANSI);
+			if (demangled != NULL)
+				elf_name = demangled;
+		}
 new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
 				GELF_ST_BIND(sym.st_info), elf_name);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e6432d85b43d..8cf3b5426a9a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -36,6 +36,7 @@ struct symbol_conf symbol_conf = {
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
+	.demangle	  = true,
 	.symfs            = "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b62ca37c4b77..d7654c23861a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,7 +97,8 @@ struct symbol_conf {
 			kptr_restrict,
 			annotate_asm_raw,
 			annotate_src,
-			event_group;
+			event_group,
+			demangle;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

