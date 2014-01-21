Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaAUUoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:44:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37262 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaAUUnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/8] perf stat: fix NULL pointer reference bug with event unit
Date: Tue, 21 Jan 2014 17:43:00 -0300
Message-Id: <1390336984-1553-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes a problem with the handling of the newly introduced
optional event unit. The following cmdline caused a segfault:

 $ perf stat -e cpu/event-0x3c/ ls

This patch fixes the problem with the default setting for alias->unit
which was eventually causing the segfault.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389972846-6566-2-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  2 +-
 tools/perf/util/pmu.c          | 24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a7f1b6a91fdd..d248fca6d7ed 100644
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
index d9cab4d27192..b752ecb40d86 100644
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
index 9183380e2038..8b64125a9281 100644
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
1.8.1.4

