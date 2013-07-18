Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3GRKhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:37:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:56267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab3GRKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347700816"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V8 11/15] perf tools: move perf_evlist__config() to a new source file
Date: Thu, 18 Jul 2013 13:42:53 +0300
Message-Id: <1374144177-24762-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_evlist__config() must be moved to a separate source
file to avoid Python link errors when adding support for
PERF_SAMPLE_IDENTIFIER.

It is appropriate to do this because perf_evlist__config()
is a helper function for event recording.  It is used by
tools to apply recording options to perf_evlist.  It is
not used by the Python API.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile      |  1 +
 tools/perf/util/evlist.c | 24 ------------------------
 tools/perf/util/record.c | 27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 24 deletions(-)
 create mode 100644 tools/perf/util/record.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5b7c6db..5798cb9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -360,6 +360,7 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/record.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b8a5a75..ee6a8f1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -89,30 +89,6 @@ void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist)
 	perf_evlist__set_id_pos(evlist);
 }
 
-void perf_evlist__config(struct perf_evlist *evlist,
-			struct perf_record_opts *opts)
-{
-	struct perf_evsel *evsel;
-	/*
-	 * Set the evsel leader links before we configure attributes,
-	 * since some might depend on this info.
-	 */
-	if (opts->group)
-		perf_evlist__set_leader(evlist);
-
-	if (evlist->cpus->map[0] < 0)
-		opts->no_inherit = true;
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts);
-
-		if (evlist->nr_entries > 1)
-			perf_evsel__set_sample_id(evsel);
-	}
-
-	perf_evlist__make_sample_types_compatible(evlist);
-}
-
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
new file mode 100644
index 0000000..67291e4
--- /dev/null
+++ b/tools/perf/util/record.c
@@ -0,0 +1,27 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "cpumap.h"
+
+void perf_evlist__config(struct perf_evlist *evlist,
+			 struct perf_record_opts *opts)
+{
+	struct perf_evsel *evsel;
+	/*
+	 * Set the evsel leader links before we configure attributes,
+	 * since some might depend on this info.
+	 */
+	if (opts->group)
+		perf_evlist__set_leader(evlist);
+
+	if (evlist->cpus->map[0] < 0)
+		opts->no_inherit = true;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__config(evsel, opts);
+
+		if (evlist->nr_entries > 1)
+			perf_evsel__set_sample_id(evsel);
+	}
+
+	perf_evlist__make_sample_types_compatible(evlist);
+}
-- 
1.7.11.7

