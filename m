Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKGFaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:30:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKGFaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:30:00 -0500
Date: Thu, 6 Nov 2014 21:29:05 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-88f50d602f500d206f2f5a9a9751dd45f2d97739@git.kernel.org>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        fweisbec@gmail.com, eranian@google.com, acme@redhat.com,
        adrian.hunter@intel.com, hpa@zytor.com, paulus@samba.org,
        namhyung@gmail.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        dsahern@gmail.com
Reply-To: eranian@google.com, acme@redhat.com, adrian.hunter@intel.com,
        hpa@zytor.com, paulus@samba.org, namhyung@gmail.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
In-Reply-To: <1414678188-14946-6-git-send-email-adrian.hunter@intel.com>
References: <1414678188-14946-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add call information to the database export API
Git-Commit-ID: 88f50d602f500d206f2f5a9a9751dd45f2d97739
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88f50d602f500d206f2f5a9a9751dd45f2d97739
Gitweb:     http://git.kernel.org/tip/88f50d602f500d206f2f5a9a9751dd45f2d97739
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 30 Oct 2014 16:09:46 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 3 Nov 2014 18:09:33 -0300

perf tools: Add call information to the database export API

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
index bccb831..017ecbb 100644
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
index e4baa45..dd5ac2a 100644
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
