Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaJ1Ndz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:33:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:51390 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaJ1Nds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:33:48 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/32] perf pmu: Let pmu's with no events show up on perf list
Date: Tue, 28 Oct 2014 11:32:09 -0200
Message-Id: <1414503146-22789-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414503146-22789-1-git-send-email-acme@kernel.org>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

perf list only lists PMUs with events.  Add a flag to cause a PMU to be
also listed separately.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414061124-26830-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 13 +++++++++++--
 tools/perf/util/pmu.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index e243ad962a4d..91dca604c422 100644
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
index fe9dfbee8eed..8092de78e818 100644
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
1.9.3

