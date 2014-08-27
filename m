Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbaH0UTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:19:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48465 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892AbaH0UTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:19:11 -0400
Subject: [PATCH v3 2/3] perf/sdt : List SDT events for a single file
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 28 Aug 2014 01:48:57 +0530
Message-ID: <20140827201757.11095.1940.stgit@hemant-fedora>
In-Reply-To: <20140827200933.11095.96814.stgit@hemant-fedora>
References: <20140827200933.11095.96814.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082720-0009-0000-0000-000000D350D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables perf to look for SDT markers in a single file.
An individual file argument must be given to "perf list" to find out the SDT markers
present in that file.

Usage is as below :
# perf list sdt /home/hemant/tmp

/home/hemant/tmp:
%user : foo
%user : bar

On using this command, perf looks for SDTs in that file using the ELF functions from
the previous patch (in this series) and dumps them on stdout.

Signed-off-by : Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/Makefile.perf       |    1 
 tools/perf/builtin-list.c      |    2 +
 tools/perf/util/parse-events.h |    2 +
 tools/perf/util/sdt.c          |  113 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+)
 create mode 100644 tools/perf/util/sdt.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..e098dcd 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/sdt.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..98a8200 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -53,6 +53,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
+		else if (strcmp(argv[i], "sdt") == 0)
+		        print_sdt_events(argv[++i]);
 		else if (strcmp(argv[i], "--raw-dump") == 0)
 			print_events(NULL, true);
 		else {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..fadc729 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -109,4 +109,6 @@ extern int is_valid_tracepoint(const char *event_string);
 
 extern int valid_debugfs_mount(const char *debugfs);
 
+void print_sdt_events(const char *arg);
+
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
new file mode 100644
index 0000000..91f0846
--- /dev/null
+++ b/tools/perf/util/sdt.c
@@ -0,0 +1,113 @@
+/* 
+ * util/sdt.c
+ * This contains the relevant functions needed to find the SDT markers
+ * in a binary.
+ *
+ * TODOS:
+ * - Listing SDT events in most of the binaries present in the system.
+ * - Build a cache for these SDT events.
+ * - Looking into directories provided by the user for binaries with SDTs, etc.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+
+#include "parse-events.h"
+#include "linux/list.h"
+#include "symbol.h"
+
+
+/*
+ * get_sdt_note_info(): flush the SDT notes onto stdout
+ */
+static void get_sdt_note_info(struct list_head *start, const char *target)
+{
+	struct sdt_note *pos;
+
+	if (list_empty(start))
+		return;
+
+	printf("%s :\n", target);
+	list_for_each_entry(pos, start, note_list) {
+		printf("%%%s : %s\n", pos->provider, pos->name);
+	}
+}
+
+/*                                                                                                            
+ * Error displayed in case of query of a
+ * single file for SDT markers
+ */
+static int sdt_err(int val, const char *target)
+{
+        switch (-val) {
+        case 0:
+                break;
+        case ENOENT:
+                /* Absence of SDT markers */
+                printf("%s : No SDT events found\n", target);
+                break;
+        case EBADF:
+                printf("%s : Bad file name\n", target);
+                break;
+        default:
+                printf("%s\n", strerror(val));
+        }
+
+        return val;
+}
+
+/*
+ * cleanup_sdt_note_list() : Free the sdt note list
+ */
+static void cleanup_sdt_note_list(struct list_head *sdt_notes)
+{
+        struct sdt_note *tmp, *pos;
+
+        if (list_empty(sdt_notes))
+                return;
+
+        list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
+                list_del(&pos->note_list);
+                free(pos->name);
+                free(pos->provider);
+                free(pos);
+        }
+}
+
+/*
+ * filename__find_sdt() : looks for sdt markers and the list is
+ * stored in sdt_notes
+ */
+static int filename__find_sdt(const char *target)
+{
+	int ret;
+
+	LIST_HEAD(sdt_notes);
+
+	ret = get_sdt_note_list(&sdt_notes, target);
+	if (!ret)
+		get_sdt_note_info(&sdt_notes, target);
+	else
+		sdt_err(ret, target);
+
+	cleanup_sdt_note_list(&sdt_notes);
+
+	return ret;
+}
+
+/*
+ * print_sdt_notes() : wrapper function
+ */
+void print_sdt_events(const char *arg)
+{
+	if (arg) {
+		filename__find_sdt(arg);
+		return;
+	}
+	pr_err("Error : File Name must be specified with \"sdt\" option!\n"
+		"Usage :\n  perf list sdt <file-name>\n");
+
+	return;
+}

