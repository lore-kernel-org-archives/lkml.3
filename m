Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3HZMyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:54:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:14401 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab3HZMym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:54:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392111815"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V12 08/13] perf tools: move perf_evlist__config() to a new source file
Date: Mon, 26 Aug 2013 16:00:25 +0300
Message-Id: <1377522030-27870-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
References: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
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
Acked-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile      |  1 +
 tools/perf/util/evlist.c | 24 ------------------------
 tools/perf/util/record.c | 27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 24 deletions(-)
 create mode 100644 tools/perf/util/record.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e0d3d9f..868358c 100644
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
index c03f017..310eb4f 100644
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

