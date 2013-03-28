Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3C1RLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:11:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3C1RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        William Cohen <wcohen@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/36] perf report: Add --no-demangle option
Date: Thu, 28 Mar 2013 14:02:14 -0300
Message-Id: <1364490156-32064-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's sometimes useful to see undemangled raw symbol name for example
other tools using the perf output to do manipulation of binaries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: William Cohen <wcohen@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: William Cohen <wcohen@redhat.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=55571
Link: http://lkml.kernel.org/r/1364203098-17741-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    4 ++++
 tools/perf/builtin-report.c              |    2 ++
 tools/perf/util/symbol-elf.c             |    9 ++++++---
 tools/perf/util/symbol.c                 |    1 +
 tools/perf/util/symbol.h                 |    3 ++-
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 02284a0..71f1551 100644
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
index 296bd21..b5ea26c 100644
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
index 54efcb5..4b12bf8 100644
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
index e6432d8..8cf3b54 100644
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
index b62ca37..d7654c2 100644
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
1.7.1

