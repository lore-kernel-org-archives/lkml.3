Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaAQPev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:34:51 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54024 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaAQPen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:34:43 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        dsahern@gmail.com, Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf stat: fix NULL pointer reference bug with event unit
Date: Fri, 17 Jan 2014 16:34:05 +0100
Message-Id: <1389972846-6566-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389972846-6566-1-git-send-email-eranian@google.com>
References: <1389972846-6566-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a problem with the handling of the newly
introduced optional event unit. The following cmdline
caused a segfault:
 $ perf stat -e cpu/event-0x3c/ ls

This patch fixes the problem with the default setting
for alias->unit which was eventually causing the segfault.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c |    2 +-
 tools/perf/util/pmu.c          |   24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |    2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a7f1b6a..d248fca 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -635,7 +635,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
 	struct perf_evsel *evsel;
-	char *unit;
+	const char *unit;
 	double scale;
 
 	pmu = perf_pmu__find(name);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d9cab4d..b752ecb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -105,7 +105,7 @@ static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *
 	char scale[128];
 	int fd, ret = -1;
 	char path[PATH_MAX];
-	char *lc;
+	const char *lc;
 
 	snprintf(path, PATH_MAX, "%s/%s.scale", dir, name);
 
@@ -609,7 +609,7 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 
 
 static int check_unit_scale(struct perf_pmu_alias *alias,
-			    char **unit, double *scale)
+			    const char **unit, double *scale)
 {
 	/*
 	 * Only one term in event definition can
@@ -634,14 +634,18 @@ static int check_unit_scale(struct perf_pmu_alias *alias,
  * defined for the alias
  */
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale)
+			  const char **unit, double *scale)
 {
 	struct parse_events_term *term, *h;
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	/*
+	 * Mark unit and scale as not set
+	 * (different from default values, see below)
+	 */
 	*unit   = NULL;
-	*scale  = 0;
+	*scale  = 0.0;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -658,6 +662,18 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		list_del(&term->list);
 		free(term);
 	}
+
+	/*
+	 * if no unit or scale foundin aliases, then
+	 * set defaults as for evsel
+	 * unit cannot left to NULL
+	 */
+	if (*unit == NULL)
+		*unit   = "";
+
+	if (*scale == 0.0)
+		*scale  = 1.0;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 9183380..8b64125 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -29,7 +29,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct list_head *head_terms);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale);
+			  const char **unit, double *scale);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
-- 
1.7.9.5

