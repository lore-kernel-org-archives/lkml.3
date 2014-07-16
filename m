Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaGPUDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaGPUDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 12/13] perf tests: Add test case for alias and JSON parsing
Date: Wed, 16 Jul 2014 22:02:48 +0200
Message-Id: <1405540969-18975-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple test case to perf test that runs perf download and parses
all the available events, including json events.

This needs adding an all event iterator to pmu.c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1405123165-22666-11-git-send-email-andi@firstfloor.org
[ use pr_* for output instead of fprintf calls ]
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf        |  1 +
 tools/perf/tests/aliases.c      | 58 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |  4 +++
 tools/perf/tests/tests.h        |  1 +
 4 files changed, 64 insertions(+)
 create mode 100644 tools/perf/tests/aliases.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index b1c0b758f88d..a38191a335b4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -420,6 +420,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/aliases.o
 ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
diff --git a/tools/perf/tests/aliases.c b/tools/perf/tests/aliases.c
new file mode 100644
index 000000000000..f315fbc25272
--- /dev/null
+++ b/tools/perf/tests/aliases.c
@@ -0,0 +1,58 @@
+/* Check if we can set up all aliases and can read JSON files */
+#include <stdlib.h>
+#include "tests.h"
+#include "pmu.h"
+#include "evlist.h"
+#include "parse-events.h"
+
+static struct perf_evlist *evlist;
+
+static int num_events;
+static int failed;
+
+static int test__event(const char *pmu, const char *name)
+{
+	int ret;
+
+	/* Not supported for now */
+	if (strcmp(pmu, "cpu"))
+		return 0;
+
+	ret = parse_events(evlist, name);
+
+	if (ret) {
+		/*
+		 * We only print on failure because common perf setups
+		 * have events that cannot be parsed.
+		 */
+		pr_err("invalid or unsupported event: '%s'\n", name);
+		ret = 0;
+		failed++;
+	} else
+		num_events++;
+	return ret;
+}
+
+int test__aliases(void)
+{
+	int err;
+
+	/* Download JSON files */
+	/* XXX assumes perf is installed */
+	/* For now user must manually download */
+	if (0 && system("perf download > /dev/null") < 0) {
+		/* Don't error out for this for now */
+		pr_err("perf download failed\n");
+	}
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	err = pmu_iterate_events(test__event);
+	pr_debug(" Parsed %d events :", num_events);
+	if (failed > 0)
+		pr_err(" %d events failed", failed);
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01bc6033..bb37ac205971 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test parsing JSON aliases",
+		.func = test__aliases,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790a395f..ab92ad9bf0e6 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__aliases(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1

