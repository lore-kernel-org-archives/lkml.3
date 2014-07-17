Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099AbaGQQNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:52239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986AbaGQQNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:39 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/33] perf record: Select comm_exec flag if supported
Date: Thu, 17 Jul 2014 13:12:12 -0300
Message-Id: <1405613555-23380-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The comm_exec flag on the attribute can later be found in the perf.data
file allowing a tool to know in advance if the captured data has the
flag.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/record.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 049e0a09ccd3..165723152cfb 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -69,15 +69,26 @@ static void perf_probe_sample_identifier(struct perf_evsel *evsel)
 	evsel->attr.sample_type |= PERF_SAMPLE_IDENTIFIER;
 }
 
+static void perf_probe_comm_exec(struct perf_evsel *evsel)
+{
+	evsel->attr.comm_exec = 1;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
 }
 
+static bool perf_can_comm_exec(void)
+{
+	return perf_probe_api(perf_probe_comm_exec);
+}
+
 void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 {
 	struct perf_evsel *evsel;
 	bool use_sample_identifier = false;
+	bool use_comm_exec;
 
 	/*
 	 * Set the evsel leader links before we configure attributes,
@@ -89,8 +100,13 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	evlist__for_each(evlist, evsel)
+	use_comm_exec = perf_can_comm_exec();
+
+	evlist__for_each(evlist, evsel) {
 		perf_evsel__config(evsel, opts);
+		if (!evsel->idx && use_comm_exec)
+			evsel->attr.comm_exec = 1;
+	}
 
 	if (evlist->nr_entries > 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
-- 
1.9.3

