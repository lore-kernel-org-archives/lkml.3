Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3K3MxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:53:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3K3MxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:01 -0500
Date: Sat, 30 Nov 2013 04:52:29 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-82d1deb0546a4af7a2ddbcfed99690b3a61776c5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384806771-2945-3-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Move idle syms check from top to generic function
Git-Commit-ID: 82d1deb0546a4af7a2ddbcfed99690b3a61776c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:52:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82d1deb0546a4af7a2ddbcfed99690b3a61776c5
Gitweb:     http://git.kernel.org/tip/82d1deb0546a4af7a2ddbcfed99690b3a61776c5
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 18 Nov 2013 13:32:45 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:37 -0300

perf symbols: Move idle syms check from top to generic function

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
index 531522d..03d37a7 100644
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
index c0c3696..f55c18d 100644
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
index 07de8fe..ad13c5d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -240,6 +240,7 @@ size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 bool symbol__restricted_filename(const char *filename,
 				 const char *restricted_filename);
+bool symbol__is_idle(struct symbol *sym);
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
