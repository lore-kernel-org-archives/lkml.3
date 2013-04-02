Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419Ab3DBJhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:37:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390Ab3DBJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:37:31 -0400
Date: Tue, 2 Apr 2013 02:37:14 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-328ccdace8855289ad114b70ee1464ba5e3f6436@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, wcohen@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        wcohen@redhat.com
In-Reply-To: <1364203098-17741-1-git-send-email-namhyung@kernel.org>
References: <1364203098-17741-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add --no-demangle option
Git-Commit-ID: 328ccdace8855289ad114b70ee1464ba5e3f6436
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:37:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  328ccdace8855289ad114b70ee1464ba5e3f6436
Gitweb:     http://git.kernel.org/tip/328ccdace8855289ad114b70ee1464ba5e3f6436
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 25 Mar 2013 18:18:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 26 Mar 2013 16:38:21 -0300

perf report: Add --no-demangle option

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
 tools/perf/Documentation/perf-report.txt | 4 ++++
 tools/perf/builtin-report.c              | 2 ++
 tools/perf/util/symbol-elf.c             | 9 ++++++---
 tools/perf/util/symbol.c                 | 1 +
 tools/perf/util/symbol.h                 | 3 ++-
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
