Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbaE3Vuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:50:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:56363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934712AbaE3Vus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:50:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,943,1392192000"; 
   d="scan'208";a="547492552"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 8/9] perf, tools, test: Add test case for alias and JSON parsing v2
Date: Fri, 30 May 2014 14:50:14 -0700
Message-Id: <1401486615-21374-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple test case to perf test that runs perf download and parses
all the events. This needs adding an all event iterator to pmu.c

v2: Rename identifiers
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf        |  1 +
 tools/perf/tests/aliases.c      | 58 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |  4 +++
 tools/perf/tests/tests.h        |  1 +
 tools/perf/util/pmu.c           | 18 +++++++++++++
 tools/perf/util/pmu.h           |  2 ++
 6 files changed, 84 insertions(+)
 create mode 100644 tools/perf/tests/aliases.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 741d213..c1ece75 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -418,6 +418,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/aliases.o
 ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
diff --git a/tools/perf/tests/aliases.c b/tools/perf/tests/aliases.c
new file mode 100644
index 0000000..68396e7
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
+static int test__event(const char *name)
+{
+	int ret;
+
+	/* Not supported for now */
+	if (!strncmp(name, "energy-", 7))
+		return 0;
+
+	ret = parse_events(evlist, name);
+
+	if (ret) {
+		/*
+		 * We only print on failure because common perf setups
+		 * have events that cannot be parsed.
+		 */
+		fprintf(stderr, "invalid or unsupported event: '%s'\n", name);
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
+		fprintf(stderr, "perf download failed\n");
+	}
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	err = pmu_iterate_events(test__event);
+	fprintf(stderr, " Parsed %d events :", num_events);
+	if (failed > 0)
+		pr_debug(" %d events failed", failed);
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 831f52c..23a0399 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -140,6 +140,10 @@ static struct test {
 		.func = test__hists_output,
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
index d76c0e2..ddef0fc 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -45,6 +45,7 @@ int test__hists_filter(void);
 int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
+int test__aliases(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8714f9a..b87f520 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -869,3 +869,21 @@ bool pmu_have_event(const char *pname, const char *name)
 	}
 	return false;
 }
+
+int pmu_iterate_events(int (*func)(const char *name))
+{
+	int ret = 0;
+	struct perf_pmu *pmu;
+	struct perf_pmu_alias *alias;
+
+	perf_pmu__find("cpu"); /* Load PMUs */
+	pmu = NULL;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
+		list_for_each_entry(alias, &pmu->aliases, list) {
+			ret = func(alias->name);
+			if (ret != 0)
+				break;
+		}
+	}
+	return ret;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 583d21e..a8ed283 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -47,5 +47,7 @@ bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
 
+int pmu_iterate_events(int (*func)(const char *name));
+
 extern const char *json_file;
 #endif /* __PMU_H */
-- 
1.9.0

