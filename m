Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3LMPMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:12:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45304 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3LMPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/20] tools lib symbol: Start carving out symbol parsing routines from perf
Date: Fri, 13 Dec 2013 12:11:47 -0300
Message-Id: <1386947526-7118-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Eventually this should be useful to other tools/ living utilities.

For now don't try to build any .a, just trying the minimal approach of
separating existing code into multiple .c files that can then be
included wherever they are needed, using whatever build machinery
already in place.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pfa8i5zpf4bf9rcccryi0lt3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/symbol/kallsyms.c  | 58 +++++++++++++++++++++++++++++++++++++
 tools/lib/symbol/kallsyms.h  | 24 +++++++++++++++
 tools/perf/MANIFEST          |  2 ++
 tools/perf/Makefile.perf     |  5 ++++
 tools/perf/util/event.c      |  1 +
 tools/perf/util/machine.c    |  1 +
 tools/perf/util/symbol-elf.c |  1 +
 tools/perf/util/symbol.c     | 69 +-------------------------------------------
 tools/perf/util/symbol.h     |  3 --
 9 files changed, 93 insertions(+), 71 deletions(-)
 create mode 100644 tools/lib/symbol/kallsyms.c
 create mode 100644 tools/lib/symbol/kallsyms.h

diff --git a/tools/lib/symbol/kallsyms.c b/tools/lib/symbol/kallsyms.c
new file mode 100644
index 000000000000..18bc271a4bbc
--- /dev/null
+++ b/tools/lib/symbol/kallsyms.c
@@ -0,0 +1,58 @@
+#include "symbol/kallsyms.h"
+#include <stdio.h>
+#include <stdlib.h>
+
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
+					  char type, u64 start))
+{
+	char *line = NULL;
+	size_t n;
+	int err = -1;
+	FILE *file = fopen(filename, "r");
+
+	if (file == NULL)
+		goto out_failure;
+
+	err = 0;
+
+	while (!feof(file)) {
+		u64 start;
+		int line_len, len;
+		char symbol_type;
+		char *symbol_name;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		line[--line_len] = '\0'; /* \n */
+
+		len = hex2u64(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		symbol_type = line[len];
+		len += 2;
+		symbol_name = line + len;
+		len = line_len - len;
+
+		if (len >= KSYM_NAME_LEN) {
+			err = -1;
+			break;
+		}
+
+		err = process_symbol(arg, symbol_name, symbol_type, start);
+		if (err)
+			break;
+	}
+
+	free(line);
+	fclose(file);
+	return err;
+
+out_failure:
+	return -1;
+}
diff --git a/tools/lib/symbol/kallsyms.h b/tools/lib/symbol/kallsyms.h
new file mode 100644
index 000000000000..6084f5e18b3c
--- /dev/null
+++ b/tools/lib/symbol/kallsyms.h
@@ -0,0 +1,24 @@
+#ifndef __TOOLS_KALLSYMS_H_
+#define __TOOLS_KALLSYMS_H_ 1
+
+#include <elf.h>
+#include <linux/ctype.h>
+#include <linux/types.h>
+
+#ifndef KSYM_NAME_LEN
+#define KSYM_NAME_LEN 256
+#endif
+
+static inline u8 kallsyms2elf_type(char type)
+{
+	if (type == 'W')
+		return STB_WEAK;
+
+	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
+}
+
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
+					  char type, u64 start));
+
+#endif /* __TOOLS_KALLSYMS_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 025de796067c..3170a7ff5782 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -2,6 +2,8 @@ tools/perf
 tools/scripts
 tools/lib/traceevent
 tools/lib/lk
+tools/lib/symbol/kallsyms.c
+tools/lib/symbol/kallsyms.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9a8cf376f874..fad61079e795 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -202,6 +202,7 @@ $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
+LIB_H += ../lib/symbol/kallsyms.h
 LIB_H += ../../include/uapi/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
@@ -312,6 +313,7 @@ LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
+LIB_OBJS += $(OUTPUT)util/kallsyms.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
@@ -672,6 +674,9 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c77814bf01e1..694876877ae2 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -7,6 +7,7 @@
 #include "strlist.h"
 #include "thread.h"
 #include "thread_map.h"
+#include "symbol/kallsyms.h"
 
 static const char *perf_event__names[] = {
 	[0]					= "TOTAL",
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 751454bcde69..c78cc84f433e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -9,6 +9,7 @@
 #include "strlist.h"
 #include "thread.h"
 #include <stdbool.h>
+#include <symbol/kallsyms.h>
 #include "unwind.h"
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index eed0b96302af..bf0ce29567b6 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -6,6 +6,7 @@
 #include <inttypes.h>
 
 #include "symbol.h"
+#include <symbol/kallsyms.h>
 #include "debug.h"
 
 #ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e377c2e96191..61eb1cddf01a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -18,12 +18,9 @@
 
 #include <elf.h>
 #include <limits.h>
+#include <symbol/kallsyms.h>
 #include <sys/utsname.h>
 
-#ifndef KSYM_NAME_LEN
-#define KSYM_NAME_LEN 256
-#endif
-
 static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
@@ -446,62 +443,6 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 	return ret;
 }
 
-int kallsyms__parse(const char *filename, void *arg,
-		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start))
-{
-	char *line = NULL;
-	size_t n;
-	int err = -1;
-	FILE *file = fopen(filename, "r");
-
-	if (file == NULL)
-		goto out_failure;
-
-	err = 0;
-
-	while (!feof(file)) {
-		u64 start;
-		int line_len, len;
-		char symbol_type;
-		char *symbol_name;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0 || !line)
-			break;
-
-		line[--line_len] = '\0'; /* \n */
-
-		len = hex2u64(line, &start);
-
-		len++;
-		if (len + 2 >= line_len)
-			continue;
-
-		symbol_type = line[len];
-		len += 2;
-		symbol_name = line + len;
-		len = line_len - len;
-
-		if (len >= KSYM_NAME_LEN) {
-			err = -1;
-			break;
-		}
-
-		err = process_symbol(arg, symbol_name,
-				     symbol_type, start);
-		if (err)
-			break;
-	}
-
-	free(line);
-	fclose(file);
-	return err;
-
-out_failure:
-	return -1;
-}
-
 int modules__parse(const char *filename, void *arg,
 		   int (*process_module)(void *arg, const char *name,
 					 u64 start))
@@ -565,14 +506,6 @@ struct process_kallsyms_args {
 	struct dso *dso;
 };
 
-static u8 kallsyms2elf_type(char type)
-{
-	if (type == 'W')
-		return STB_WEAK;
-
-	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
-}
-
 bool symbol__is_idle(struct symbol *sym)
 {
 	const char * const idle_symbols[] = {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6de9c2b8a601..8a9d910c5345 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -221,9 +221,6 @@ struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
-int kallsyms__parse(const char *filename, void *arg,
-		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start));
 int modules__parse(const char *filename, void *arg,
 		   int (*process_module)(void *arg, const char *name,
 					 u64 start));
-- 
1.8.1.4

