Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3K0UVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:21:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab3K0URE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/34] perf symbols: Move idle syms check from top to generic function
Date: Wed, 27 Nov 2013 17:16:22 -0300
Message-Id: <1385583394-3703-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows list of idle symbols to be leveraged by other commands, such as
the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 25 ++-----------------------
 tools/perf/util/symbol.c | 30 ++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h |  1 +
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 531522d3d97b..03d37a76c612 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -634,26 +634,9 @@ repeat:
 	return NULL;
 }
 
-/* Tag samples to be skipped. */
-static const char *skip_symbols[] = {
-	"intel_idle",
-	"default_idle",
-	"native_safe_halt",
-	"cpu_idle",
-	"enter_idle",
-	"exit_idle",
-	"mwait_idle",
-	"mwait_idle_with_hints",
-	"poll_idle",
-	"ppc64_runlatch_off",
-	"pseries_dedicated_idle_sleep",
-	NULL
-};
-
 static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 {
 	const char *name = sym->name;
-	int i;
 
 	/*
 	 * ppc64 uses function descriptors and appends a '.' to the
@@ -671,12 +654,8 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	    strstr(name, "_text_end"))
 		return 1;
 
-	for (i = 0; skip_symbols[i]; i++) {
-		if (!strcmp(skip_symbols[i], name)) {
-			sym->ignore = true;
-			break;
-		}
-	}
+	if (symbol__is_idle(sym))
+		sym->ignore = true;
 
 	return 0;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0c36965fff0..f55c18da1e40 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -573,6 +573,36 @@ static u8 kallsyms2elf_type(char type)
 	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
 }
 
+bool symbol__is_idle(struct symbol *sym)
+{
+	const char * const idle_symbols[] = {
+		"cpu_idle",
+		"intel_idle",
+		"default_idle",
+		"native_safe_halt",
+		"enter_idle",
+		"exit_idle",
+		"mwait_idle",
+		"mwait_idle_with_hints",
+		"poll_idle",
+		"ppc64_runlatch_off",
+		"pseries_dedicated_idle_sleep",
+		NULL
+	};
+
+	int i;
+
+	if (!sym)
+		return false;
+
+	for (i = 0; idle_symbols[i]; i++) {
+		if (!strcmp(idle_symbols[i], sym->name))
+			return true;
+	}
+
+	return false;
+}
+
 static int map__process_kallsym_symbol(void *arg, const char *name,
 				       char type, u64 start)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 07de8fea2f48..ad13c5d50b91 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -240,6 +240,7 @@ size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 bool symbol__restricted_filename(const char *filename,
 				 const char *restricted_filename);
+bool symbol__is_idle(struct symbol *sym);
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
-- 
1.8.1.4

