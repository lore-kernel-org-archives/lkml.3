Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaGaGC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:02:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbaGaGC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799889"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/31] perf pmu: Let pmu's with no events show up on perf list
Date: Thu, 31 Jul 2014 09:00:54 +0300
Message-Id: <1406786474-9306-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
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
index 348d1d2..ba300d9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -749,15 +749,18 @@ void print_pmu_events(const char *event_glob, bool name_only)
 
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
@@ -774,6 +777,12 @@ void print_pmu_events(const char *event_glob, bool name_only)
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
index c35f578..8c999b3 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -18,6 +18,7 @@ struct perf_event_attr;
 struct perf_pmu {
 	char *name;
 	__u32 type;
+	bool selectable;
 	struct perf_event_attr *default_config;
 	struct cpu_map *cpus;
 	struct list_head format;
-- 
1.8.3.2

