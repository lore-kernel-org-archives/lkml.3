Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaJWKrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:47:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:19432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaJWKrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594445873"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/16] perf pmu: Let pmu's with no events show up on perf list
Date: Thu, 23 Oct 2014 13:45:10 +0300
Message-Id: <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf list only lists PMUs with events.  Add a
flag to cause a PMU to be also listed separately.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/pmu.c | 13 +++++++++++--
 tools/perf/util/pmu.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index e243ad9..91dca60 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -747,15 +747,18 @@ void print_pmu_events(const char *event_glob, bool name_only)
 
 	pmu = NULL;
 	len = 0;
-	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 		list_for_each_entry(alias, &pmu->aliases, list)
 			len++;
+		if (pmu->selectable)
+			len++;
+	}
 	aliases = malloc(sizeof(char *) * len);
 	if (!aliases)
 		return;
 	pmu = NULL;
 	j = 0;
-	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 		list_for_each_entry(alias, &pmu->aliases, list) {
 			char *name = format_alias(buf, sizeof(buf), pmu, alias);
 			bool is_cpu = !strcmp(pmu->name, "cpu");
@@ -772,6 +775,12 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			aliases[j] = strdup(aliases[j]);
 			j++;
 		}
+		if (pmu->selectable) {
+			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
+			aliases[j] = strdup(buf);
+			j++;
+		}
+	}
 	len = j;
 	qsort(aliases, len, sizeof(char *), cmp_string);
 	for (j = 0; j < len; j++) {
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index fe9dfbe..8092de7 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -18,6 +18,7 @@ struct perf_event_attr;
 struct perf_pmu {
 	char *name;
 	__u32 type;
+	bool selectable;
 	struct perf_event_attr *default_config;
 	struct cpu_map *cpus;
 	struct list_head format;  /* HEAD struct perf_pmu_format -> list */
-- 
1.9.1

