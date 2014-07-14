Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaGNKEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:04:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:40395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbaGNKEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434105"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/41] perf record: Select comm_exec flag if supported
Date: Mon, 14 Jul 2014 13:02:28 +0300
Message-Id: <1405332185-4050-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comm_exec flag on the attribute can later
be found in the perf.data file allowing a
tool to know in advance if the captured data
has the flag.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/record.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 049e0a0..1657231 100644
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
1.8.3.2

