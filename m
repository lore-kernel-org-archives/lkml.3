Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3IDUMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:12:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:55344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761170Ab3IDULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1023,1367996400"; 
   d="scan'208";a="391145047"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: add test for parsing with no sample_id_all bit
Date: Wed,  4 Sep 2013 23:18:16 +0300
Message-Id: <1378325897-3840-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com>
References: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test for parsing a non-sample event when there is
more than one selected event but no sample_id_all bit set.

The test fails because of a bug in the evlist logic.  That
is fixed in a separate patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile                       |   3 +-
 tools/perf/tests/builtin-test.c           |   4 ++
 tools/perf/tests/parse-no-sample-id-all.c | 108 ++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                  |   1 +
 4 files changed, 115 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/tests/parse-no-sample-id-all.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c5dc1ad..3a0ff7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -394,6 +394,8 @@ ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
 endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
+LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
+LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -439,7 +441,6 @@ PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
-LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 
 ifdef NO_LIBELF
 EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 8bbeba3..1e67437 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -112,6 +112,10 @@ static struct test {
 		.func = test__keep_tracking,
 	},
 	{
+		.desc = "Test parsing with no sample_id_all bit set",
+		.func = test__parse_no_sample_id_all,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
new file mode 100644
index 0000000..e117b6c
--- /dev/null
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -0,0 +1,108 @@
+#include <sys/types.h>
+#include <stddef.h>
+
+#include "tests.h"
+
+#include "event.h"
+#include "evlist.h"
+#include "header.h"
+#include "util.h"
+
+static int process_event(struct perf_evlist **pevlist, union perf_event *event)
+{
+	struct perf_sample sample;
+
+	if (event->header.type == PERF_RECORD_HEADER_ATTR) {
+		if (perf_event__process_attr(NULL, event, pevlist)) {
+			pr_debug("perf_event__process_attr failed\n");
+			return -1;
+		}
+		return 0;
+	}
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		return -1;
+
+	if (!*pevlist)
+		return -1;
+
+	if (perf_evlist__parse_sample(*pevlist, event, &sample)) {
+		pr_debug("perf_evlist__parse_sample failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int process_events(union perf_event **events, size_t count)
+{
+	struct perf_evlist *evlist = NULL;
+	int err = 0;
+	size_t i;
+
+	for (i = 0; i < count && !err; i++)
+		err = process_event(&evlist, events[i]);
+
+	if (evlist)
+		perf_evlist__delete(evlist);
+
+	return err;
+}
+
+struct test_attr_event {
+	struct attr_event attr;
+	u64 id;
+};
+
+/**
+ * test__parse_no_sample_id_all - test parsing with no sample_id_all bit set.
+ *
+ * This function tests parsing data produced on kernel's that do not support the
+ * sample_id_all bit.  Without the sample_id_all bit, non-sample events (such as
+ * mmap events) do not have an id sample appended, and consequently logic
+ * designed to determine the id will not work.  That case happens when there is
+ * more than one selected event, so this test processes three events: 2
+ * attributes representing the selected events and one mmap event.
+ *
+ * Return: %0 on success, %-1 if the test fails.
+ */
+int test__parse_no_sample_id_all(void)
+{
+	int err;
+
+	struct test_attr_event event1 = {
+		.attr = {
+			.header = {
+				.type = PERF_RECORD_HEADER_ATTR,
+				.size = sizeof(struct test_attr_event),
+			},
+		},
+		.id = 1,
+	};
+	struct test_attr_event event2 = {
+		.attr = {
+			.header = {
+				.type = PERF_RECORD_HEADER_ATTR,
+				.size = sizeof(struct test_attr_event),
+			},
+		},
+		.id = 2,
+	};
+	struct mmap_event event3 = {
+		.header = {
+			.type = PERF_RECORD_MMAP,
+			.size = sizeof(struct mmap_event),
+		},
+	};
+	union perf_event *events[] = {
+		(union perf_event *)&event1,
+		(union perf_event *)&event2,
+		(union perf_event *)&event3,
+	};
+
+	err = process_events(events, ARRAY_SIZE(events));
+	if (err)
+		return -1;
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index c048b58..e0ac713 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -39,5 +39,6 @@ int test__perf_time_to_tsc(void);
 int test__code_reading(void);
 int test__sample_parsing(void);
 int test__keep_tracking(void);
+int test__parse_no_sample_id_all(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

