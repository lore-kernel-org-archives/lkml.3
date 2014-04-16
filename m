Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaDPSuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:50:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:35399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbaDPSuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:50:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,873,1389772800"; 
   d="scan'208";a="522180979"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/10] perf, tools, test: Add test case for alias and JSON parsing
Date: Wed, 16 Apr 2014 11:49:31 -0700
Message-Id: <1397674172-30959-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
References: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple test case to perf test that runs perf download and parses
all the events. This needs adding an all event iterator to pmu.c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf        |  1 +
 tools/perf/tests/aliases.c      | 52 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |  4 ++++
 tools/perf/tests/tests.h        |  1 +
 tools/perf/util/pmu.c           | 18 ++++++++++++++
 tools/perf/util/pmu.h           |  2 ++
 6 files changed, 78 insertions(+)
 create mode 100644 tools/perf/tests/aliases.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6c103f7..9f07018 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -416,6 +416,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/aliases.o
 ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
diff --git a/tools/perf/tests/aliases.c b/tools/perf/tests/aliases.c
new file mode 100644
index 0000000..ec267d3
--- /dev/null
+++ b/tools/perf/tests/aliases.c
@@ -0,0 +1,52 @@
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
+static int test_event(const char *name)
+{
+	int ret = parse_events(evlist, name);
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
+	err = pmu_iterate_events(test_event);
+	fprintf(stderr, " Parsed %d events :", num_events);
+	if (failed > 0)
+		fprintf(stderr, " %d events failed", num_events);
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b11bf8a..b77468d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -115,6 +115,10 @@ static struct test {
 		.desc = "Test parsing with no sample_id_all bit set",
 		.func = test__parse_no_sample_id_all,
 	},
+	{
+		.desc = "Test parsing JSON aliases",
+		.func = test__aliases,
+	},
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 	{
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a24795c..d090866 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -41,6 +41,7 @@ int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
+int test__aliases(void);
 
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8ae168c..fb58a51 100644
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
index 62255bb..b885c55 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -47,5 +47,7 @@ bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
 
+int pmu_iterate_events(int (*func)(const char *name));
+
 extern const char *json_file;
 #endif /* __PMU_H */
-- 
1.8.5.3

