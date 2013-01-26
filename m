Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3AZUGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3AZUEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:04:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf tools: Add name term processing for alias
Date: Sat, 26 Jan 2013 21:04:05 +0100
Message-Id: <1359230650-10415-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for name term being specified within
the alias definition and gives the name for the alias.

Alias could be now defined like:
  name=BR_MISP_EXEC.ALL_BRANCHES,event=0x89,umask=0xff

It'll be handy for having single file with multiple
alias definitions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c | 19 ++-----------------
 tools/perf/util/pmu.c          | 35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |  3 +++
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 83362f2..0143c90 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -616,22 +616,6 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, NULL);
 }
 
-static int parse_events__is_name_term(struct parse_events_term *term)
-{
-	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
-}
-
-static char *pmu_event_name(struct list_head *head_terms)
-{
-	struct parse_events_term *term;
-
-	list_for_each_entry(term, head_terms, list)
-		if (parse_events__is_name_term(term))
-			return term->val.str;
-
-	return NULL;
-}
-
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *name, struct list_head *head_config)
 {
@@ -656,7 +640,8 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return __add_event(list, idx, &attr, pmu_event_name(head_config),
+	return __add_event(list, idx, &attr,
+			   perf_pmu__event_name(head_config, false),
 			   pmu->cpus);
 }
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f7852e9..0d45ccd 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -95,6 +95,27 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
+static int parse_events__is_name_term(struct parse_events_term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
+}
+
+char *perf_pmu__event_name(struct list_head *head_terms, bool remove)
+{
+	struct parse_events_term *term;
+
+	list_for_each_entry(term, head_terms, list)
+		if (parse_events__is_name_term(term)) {
+			if (remove) {
+				list_del(&term->list);
+				free(term);
+			}
+			return term->val.str;
+		}
+
+	return NULL;
+}
+
 static int perf_pmu__new_alias(struct list_head *list, char *name, char *data)
 {
 	struct perf_pmu_alias *alias;
@@ -111,6 +132,20 @@ static int perf_pmu__new_alias(struct list_head *list, char *name, char *data)
 		return ret;
 	}
 
+	/*
+	 * Use NAME term to get alias name. In case there's no name
+	 * at all, bail out. In case we find NAME term, remove it
+	 * not to mangle with event term name.
+	 */
+	if (!name) {
+		name = perf_pmu__event_name(&alias->terms, true);
+
+		if (!name) {
+			free(alias);
+			return -EINVAL;
+		}
+	}
+
 	alias->name = strdup(name);
 	list_add_tail(&alias->list, list);
 	return 0;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 32fe55b..54cd809 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -3,6 +3,7 @@
 
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
+#include <stdbool.h>
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
@@ -40,5 +41,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
+char *perf_pmu__event_name(struct list_head *head_terms, bool remove);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.11.7

