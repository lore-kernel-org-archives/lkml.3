Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKFVFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:05:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:43156 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaKFVFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:23 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/18] perf tools: Defer export of comms that were not 'set'
Date: Thu,  6 Nov 2014 18:04:28 -0300
Message-Id: <1415307879-912-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Tracing for a workload begins before the comm event is seen, which
results in the initial comm having a string of the form ":<pid>" (e.g.
":12345").

In order to export the correct string, defer the export until the new
script 'flush' callback.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/db-export.c                        | 62 +++++++++++++++++++++-
 tools/perf/util/db-export.h                        |  3 ++
 .../util/scripting-engines/trace-event-python.c    |  4 +-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index 017ecbb0ec05..c81dae399763 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -21,17 +21,74 @@
 #include "comm.h"
 #include "symbol.h"
 #include "event.h"
+#include "util.h"
 #include "thread-stack.h"
 #include "db-export.h"
 
+struct deferred_export {
+	struct list_head node;
+	struct comm *comm;
+};
+
+static int db_export__deferred(struct db_export *dbe)
+{
+	struct deferred_export *de;
+	int err;
+
+	while (!list_empty(&dbe->deferred)) {
+		de = list_entry(dbe->deferred.next, struct deferred_export,
+				node);
+		err = dbe->export_comm(dbe, de->comm);
+		list_del(&de->node);
+		free(de);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void db_export__free_deferred(struct db_export *dbe)
+{
+	struct deferred_export *de;
+
+	while (!list_empty(&dbe->deferred)) {
+		de = list_entry(dbe->deferred.next, struct deferred_export,
+				node);
+		list_del(&de->node);
+		free(de);
+	}
+}
+
+static int db_export__defer_comm(struct db_export *dbe, struct comm *comm)
+{
+	struct deferred_export *de;
+
+	de = zalloc(sizeof(struct deferred_export));
+	if (!de)
+		return -ENOMEM;
+
+	de->comm = comm;
+	list_add_tail(&de->node, &dbe->deferred);
+
+	return 0;
+}
+
 int db_export__init(struct db_export *dbe)
 {
 	memset(dbe, 0, sizeof(struct db_export));
+	INIT_LIST_HEAD(&dbe->deferred);
 	return 0;
 }
 
+int db_export__flush(struct db_export *dbe)
+{
+	return db_export__deferred(dbe);
+}
+
 void db_export__exit(struct db_export *dbe)
 {
+	db_export__free_deferred(dbe);
 	call_return_processor__free(dbe->crp);
 	dbe->crp = NULL;
 }
@@ -115,7 +172,10 @@ int db_export__comm(struct db_export *dbe, struct comm *comm,
 	comm->db_id = ++dbe->comm_last_db_id;
 
 	if (dbe->export_comm) {
-		err = dbe->export_comm(dbe, comm);
+		if (main_thread->comm_set)
+			err = dbe->export_comm(dbe, comm);
+		else
+			err = db_export__defer_comm(dbe, comm);
 		if (err)
 			return err;
 	}
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
index dd5ac2ae97d4..adbd22d66798 100644
--- a/tools/perf/util/db-export.h
+++ b/tools/perf/util/db-export.h
@@ -17,6 +17,7 @@
 #define __PERF_DB_EXPORT_H
 
 #include <linux/types.h>
+#include <linux/list.h>
 
 struct perf_evsel;
 struct machine;
@@ -74,9 +75,11 @@ struct db_export {
 	u64 sample_last_db_id;
 	u64 call_path_last_db_id;
 	u64 call_return_last_db_id;
+	struct list_head deferred;
 };
 
 int db_export__init(struct db_export *dbe);
+int db_export__flush(struct db_export *dbe);
 void db_export__exit(struct db_export *dbe);
 int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel);
 int db_export__machine(struct db_export *dbe, struct machine *machine);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cb1d9602f418..118bc62850a8 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1030,7 +1030,9 @@ error:
 
 static int python_flush_script(void)
 {
-	return 0;
+	struct tables *tables = &tables_global;
+
+	return db_export__flush(&tables->dbe);
 }
 
 /*
-- 
1.9.3

