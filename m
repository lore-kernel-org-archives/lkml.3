Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab3HHCv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:28 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54842 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab3HHCvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:25 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/19] perf symbol: Add optimization for idle kernel symbols
Date: Wed,  7 Aug 2013 22:50:48 -0400
Message-Id: <1375930261-77273-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid walking the list of idle symbols more than once by setting a
flag in the symbol struct.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/symbol.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h |    5 ++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 77f3b95..c655b9e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -509,6 +509,46 @@ static u8 kallsyms2elf_type(char type)
 	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
 }
 
+static bool is_idle_sym(const char *name)
+{
+	static const char * const idle_symbols[] = {
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
+	for (i = 0; idle_symbols[i]; i++) {
+		if (!strcmp(idle_symbols[i], name))
+			return true;
+	}
+
+	return false;
+}
+
+bool symbol__is_idle(struct symbol *sym)
+{
+	if (!sym)
+		return false;
+
+	if (!sym->idle_checked) {
+		sym->is_idle = is_idle_sym(sym->name);
+		sym->idle_checked = true;
+	}
+
+	return sym->is_idle;
+}
+
 static int map__process_kallsym_symbol(void *arg, const char *name,
 				       char type, u64 start)
 {
@@ -527,6 +567,10 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
 	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
 	if (sym == NULL)
 		return -ENOMEM;
+
+	sym->is_idle = is_idle_sym(name);
+	sym->idle_checked = true;
+
 	/*
 	 * We will pass the symbols to the filter later, in
 	 * map__split_kallsyms, when we have split the maps per module
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fd5b70e..c163ba9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -59,7 +59,7 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 
 /** struct symbol - symtab entry
  *
- * @ignore - resolvable but tools ignore it (e.g. idle routines)
+ * @ignore - resolvable but perf-top ignores it (e.g. idle routines)
  */
 struct symbol {
 	struct rb_node	rb_node;
@@ -68,6 +68,8 @@ struct symbol {
 	u16		namelen;
 	u8		binding;
 	bool		ignore;
+	bool		is_idle;  /* pertains to kernel symbols only */
+	bool		idle_checked;
 	char		name[0];
 };
 
@@ -236,6 +238,7 @@ size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 bool symbol__restricted_filename(const char *filename,
 				 const char *restricted_filename);
+bool symbol__is_idle(struct symbol *sym);
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
-- 
1.7.10.1

