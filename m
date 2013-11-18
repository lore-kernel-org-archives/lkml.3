Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3KRUdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:14 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49541 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3KRUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:02 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf symbols: Move idle syms check from top to generic function
Date: Mon, 18 Nov 2013 13:32:45 -0700
Message-Id: <1384806771-2945-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows list of idle symbols to be leveraged by other commands,
such as the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

