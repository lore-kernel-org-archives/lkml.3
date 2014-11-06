Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKFVIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:08:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:43130 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaKFVFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:13 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/18] perf tools: Add call information to the database export API
Date: Thu,  6 Nov 2014 18:04:26 -0300
Message-Id: <1415307879-912-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Make it possible for the database export API to use the enhanced thread
stack and export detailed information about paired calls and returns.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/db-export.c | 52 ++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/db-export.h | 12 +++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index bccb83120971..017ecbb0ec05 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -21,6 +21,7 @@
 #include "comm.h"
 #include "symbol.h"
 #include "event.h"
+#include "thread-stack.h"
 #include "db-export.h"
 
 int db_export__init(struct db_export *dbe)
@@ -29,8 +30,10 @@ int db_export__init(struct db_export *dbe)
 	return 0;
 }
 
-void db_export__exit(struct db_export *dbe __maybe_unused)
+void db_export__exit(struct db_export *dbe)
 {
+	call_return_processor__free(dbe->crp);
+	dbe->crp = NULL;
 }
 
 int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel)
@@ -270,6 +273,13 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 				     &es.addr_sym_db_id, &es.addr_offset);
 		if (err)
 			return err;
+		if (dbe->crp) {
+			err = thread_stack__process(thread, comm, sample, al,
+						    &addr_al, es.db_id,
+						    dbe->crp);
+			if (err)
+				return err;
+		}
 	}
 
 	if (dbe->export_sample)
@@ -316,3 +326,43 @@ int db_export__branch_types(struct db_export *dbe)
 	}
 	return err;
 }
+
+int db_export__call_path(struct db_export *dbe, struct call_path *cp)
+{
+	int err;
+
+	if (cp->db_id)
+		return 0;
+
+	if (cp->parent) {
+		err = db_export__call_path(dbe, cp->parent);
+		if (err)
+			return err;
+	}
+
+	cp->db_id = ++dbe->call_path_last_db_id;
+
+	if (dbe->export_call_path)
+		return dbe->export_call_path(dbe, cp);
+
+	return 0;
+}
+
+int db_export__call_return(struct db_export *dbe, struct call_return *cr)
+{
+	int err;
+
+	if (cr->db_id)
+		return 0;
+
+	err = db_export__call_path(dbe, cr->cp);
+	if (err)
+		return err;
+
+	cr->db_id = ++dbe->call_return_last_db_id;
+
+	if (dbe->export_call_return)
+		return dbe->export_call_return(dbe, cr);
+
+	return 0;
+}
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
index e4baa45ead70..dd5ac2ae97d4 100644
--- a/tools/perf/util/db-export.h
+++ b/tools/perf/util/db-export.h
@@ -25,6 +25,9 @@ struct comm;
 struct dso;
 struct perf_sample;
 struct addr_location;
+struct call_return_processor;
+struct call_path;
+struct call_return;
 
 struct export_sample {
 	union perf_event	*event;
@@ -57,6 +60,10 @@ struct db_export {
 	int (*export_branch_type)(struct db_export *dbe, u32 branch_type,
 				  const char *name);
 	int (*export_sample)(struct db_export *dbe, struct export_sample *es);
+	int (*export_call_path)(struct db_export *dbe, struct call_path *cp);
+	int (*export_call_return)(struct db_export *dbe,
+				  struct call_return *cr);
+	struct call_return_processor *crp;
 	u64 evsel_last_db_id;
 	u64 machine_last_db_id;
 	u64 thread_last_db_id;
@@ -65,6 +72,8 @@ struct db_export {
 	u64 dso_last_db_id;
 	u64 symbol_last_db_id;
 	u64 sample_last_db_id;
+	u64 call_path_last_db_id;
+	u64 call_return_last_db_id;
 };
 
 int db_export__init(struct db_export *dbe);
@@ -89,4 +98,7 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 
 int db_export__branch_types(struct db_export *dbe);
 
+int db_export__call_path(struct db_export *dbe, struct call_path *cp);
+int db_export__call_return(struct db_export *dbe, struct call_return *cr);
+
 #endif
-- 
1.9.3

