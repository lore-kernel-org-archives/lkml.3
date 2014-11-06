Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaKFVJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:09:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:43076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaKFVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:04 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/18] perf tools: Add branch type to db export
Date: Thu,  6 Nov 2014 18:04:24 -0300
Message-Id: <1415307879-912-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add the ability to export branch types through the database export
facility.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/db-export.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/db-export.h |  6 ++++++
 2 files changed, 54 insertions(+)

diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index be128b075a32..bccb83120971 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -208,6 +208,15 @@ static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
 	return 0;
 }
 
+int db_export__branch_type(struct db_export *dbe, u32 branch_type,
+			   const char *name)
+{
+	if (dbe->export_branch_type)
+		return dbe->export_branch_type(dbe, branch_type, name);
+
+	return 0;
+}
+
 int db_export__sample(struct db_export *dbe, union perf_event *event,
 		      struct perf_sample *sample, struct perf_evsel *evsel,
 		      struct thread *thread, struct addr_location *al)
@@ -268,3 +277,42 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 
 	return 0;
 }
+
+static struct {
+	u32 branch_type;
+	const char *name;
+} branch_types[] = {
+	{0, "no branch"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL, "call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN, "return"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CONDITIONAL, "conditional jump"},
+	{PERF_IP_FLAG_BRANCH, "unconditional jump"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_INTERRUPT,
+	 "software interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN | PERF_IP_FLAG_INTERRUPT,
+	 "return from interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_SYSCALLRET,
+	 "system call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN | PERF_IP_FLAG_SYSCALLRET,
+	 "return from system call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_ASYNC, "asynchronous branch"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_ASYNC |
+	 PERF_IP_FLAG_INTERRUPT, "hardware interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TX_ABORT, "transaction abort"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TRACE_BEGIN, "trace begin"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TRACE_END, "trace end"},
+	{0, NULL}
+};
+
+int db_export__branch_types(struct db_export *dbe)
+{
+	int i, err = 0;
+
+	for (i = 0; branch_types[i].name ; i++) {
+		err = db_export__branch_type(dbe, branch_types[i].branch_type,
+					     branch_types[i].name);
+		if (err)
+			break;
+	}
+	return err;
+}
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
index b3643e8e5750..e4baa45ead70 100644
--- a/tools/perf/util/db-export.h
+++ b/tools/perf/util/db-export.h
@@ -54,6 +54,8 @@ struct db_export {
 			  struct machine *machine);
 	int (*export_symbol)(struct db_export *dbe, struct symbol *sym,
 			     struct dso *dso);
+	int (*export_branch_type)(struct db_export *dbe, u32 branch_type,
+				  const char *name);
 	int (*export_sample)(struct db_export *dbe, struct export_sample *es);
 	u64 evsel_last_db_id;
 	u64 machine_last_db_id;
@@ -79,8 +81,12 @@ int db_export__dso(struct db_export *dbe, struct dso *dso,
 		   struct machine *machine);
 int db_export__symbol(struct db_export *dbe, struct symbol *sym,
 		      struct dso *dso);
+int db_export__branch_type(struct db_export *dbe, u32 branch_type,
+			   const char *name);
 int db_export__sample(struct db_export *dbe, union perf_event *event,
 		      struct perf_sample *sample, struct perf_evsel *evsel,
 		      struct thread *thread, struct addr_location *al);
 
+int db_export__branch_types(struct db_export *dbe);
+
 #endif
-- 
1.9.3

