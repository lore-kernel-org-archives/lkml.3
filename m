Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaJWKv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:51:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:11817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbaJWKrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594446014"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/16] perf tools: Add branch type to db export
Date: Thu, 23 Oct 2014 13:45:16 +0300
Message-Id: <1414061124-26830-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to export branch types through the
database export facility.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/db-export.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/db-export.h |  6 ++++++
 2 files changed, 54 insertions(+)

diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index 53d0e75..c5b6e02 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -205,6 +205,15 @@ static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
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
@@ -266,3 +275,42 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 
 	return 0;
 }
+
+static struct {
+	u32 branch_type;
+	const char *name;
+} branch_types[] = {
+	{0, "no branch"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_CALL, "call"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_RETURN, "return"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_CONDITIONAL, "conditional jump"},
+	{PERF_FLAG_BRANCH, "unconditional jump"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_CALL | PERF_FLAG_INTERRUPT,
+	 "software interrupt"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_RETURN | PERF_FLAG_INTERRUPT,
+	 "return from interrupt"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_CALL | PERF_FLAG_SYSCALLRET,
+	 "system call"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_RETURN | PERF_FLAG_SYSCALLRET,
+	 "return from system call"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_ASYNC, "asynchronous branch"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_CALL | PERF_FLAG_ASYNC |
+	 PERF_FLAG_INTERRUPT, "hardware interrupt"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_TX_ABORT, "transaction abort"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_TRACE_BEGIN, "trace begin"},
+	{PERF_FLAG_BRANCH | PERF_FLAG_TRACE_END, "trace end"},
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
index b3643e8..e4baa45 100644
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
1.9.1

