Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbaJ3Gqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:46:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaJ3Gq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:46:27 -0400
Date: Wed, 29 Oct 2014 23:45:27 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-42634bc7a02ead59cf2d50e60d8b8f825de8a3b0@git.kernel.org>
Cc: namhyung@gmail.com, hpa@zytor.com, adrian.hunter@intel.com,
        mingo@kernel.org, paulus@samba.org, fweisbec@gmail.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, eranian@google.com,
        peterz@infradead.org
Reply-To: peterz@infradead.org, jolsa@redhat.com, eranian@google.com,
        tglx@linutronix.de, dsahern@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, acme@redhat.com, paulus@samba.org, hpa@zytor.com,
        namhyung@gmail.com
In-Reply-To: <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf pmu: Let pmu'
 s with no events show up on perf list
Git-Commit-ID: 42634bc7a02ead59cf2d50e60d8b8f825de8a3b0
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

Commit-ID:  42634bc7a02ead59cf2d50e60d8b8f825de8a3b0
Gitweb:     http://git.kernel.org/tip/42634bc7a02ead59cf2d50e60d8b8f825de8a3b0
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 23 Oct 2014 13:45:10 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:48 -0200

perf pmu: Let pmu's with no events show up on perf list

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
